Set-StrictMode -Version Latest

function Get-SkillCatalog {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$RepositoryRoot)

    $root = (Get-Item -LiteralPath $RepositoryRoot -ErrorAction Stop).FullName
    $folders = @(Get-ChildItem -LiteralPath $root -Directory -Force |
        Where-Object { $_.Name -notin @('.git', 'dist', 'scripts', 'tests', 'node_modules') })
    $skillsFolder = Join-Path $root 'skills'
    if (Test-Path -LiteralPath $skillsFolder -PathType Container) {
        $folders += @(Get-ChildItem -LiteralPath $skillsFolder -Directory)
    }
    $seen = @{}
    foreach ($folder in ($folders | Sort-Object FullName -Unique)) {
        $manifest = Join-Path $folder.FullName 'SKILL.md'
        if (-not (Test-Path -LiteralPath $manifest -PathType Leaf)) { continue }
        $text = Get-Content -LiteralPath $manifest -Raw -Encoding UTF8
        # Normalize metadata for parsing while keeping the installed files byte for byte.
        $text = $text.TrimStart([char]0xFEFF).Replace("`r`n", "`n")
        $header = [regex]::Match($text, '(?s)\A---\r?\n(.*?)\r?\n---(?:\r?\n|$)')
        if (-not $header.Success) { throw "Invalid frontmatter: $manifest" }
        $nameMatch = [regex]::Match($header.Groups[1].Value, '(?m)^name:[ \t]*(?<quote>["'']?)(?<name>[a-z0-9]+(?:-[a-z0-9]+)*)\k<quote>[ \t]*$')
        $description = [regex]::Match($header.Groups[1].Value, '(?m)^description:\s*([^\r\n]+)')
        if (-not $nameMatch.Success -or -not $description.Success) {
            throw "A skill needs a name and description: $manifest"
        }
        $name = $nameMatch.Groups['name'].Value
        if ($name.Length -gt 64 -or $name -ne $folder.Name) { throw "Skill name must match its folder: $manifest" }
        if ($name -in @('con', 'prn', 'aux', 'nul') -or $name -match '^(com|lpt)[0-9]$') {
            throw "Reserved Windows folder name: $name"
        }
        if ($seen.ContainsKey($name)) { throw "Duplicate skill name: $name" }
        $seen[$name] = $true
        $summary = $description.Groups[1].Value.Trim()
        if ($summary -in @('|', '>', '|-', '>-')) {
            $block = [regex]::Match($header.Groups[1].Value, '(?m)^description:[^\r\n]*\r?\n((?:[ \t]+[^\r\n]+\r?\n?)+)')
            $summary = ($block.Groups[1].Value -replace '\s+', ' ').Trim()
        }
        $summary = $summary.Trim('"', "'")
        if (-not $summary) { throw "Empty skill description: $manifest" }
        [pscustomobject]@{ Name = $name; Description = $summary; Source = $folder.FullName }
    }
}

function Get-ClientCommands {
    param([string]$HomeDirectory)
    $result = @{}
    $names = @{ claude = 'claude'; chatgpt = 'codex'; gemini = 'gemini' }
    foreach ($id in @('claude', 'chatgpt', 'gemini')) {
        $command = Get-Command $names[$id] -CommandType Application, ExternalScript -ErrorAction SilentlyContinue |
            Select-Object -First 1
        if ($command) { $result[$id] = $command.Source; continue }
        $candidates = @()
        if ($env:APPDATA) { $candidates += Join-Path $env:APPDATA ('npm\' + $names[$id] + '.cmd') }
        if ($id -eq 'claude') {
            $candidates += Join-Path $HomeDirectory '.local\bin\claude.exe'
            $candidates += Join-Path $HomeDirectory '.claude\local\claude.exe'
        }
        if ($id -eq 'chatgpt' -and $env:LOCALAPPDATA) {
            $candidates += Join-Path $env:LOCALAPPDATA 'Programs\OpenAI\Codex\bin\codex.exe'
        }
        foreach ($candidate in $candidates) {
            if (Test-Path -LiteralPath $candidate -PathType Leaf) { $result[$id] = $candidate; break }
        }
    }
    return $result
}

function Get-DesktopClients {
    $records = New-Object 'System.Collections.Generic.List[object]'
    $registryPaths = @(
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall',
        'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall',
        'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
    )
    foreach ($path in $registryPaths) {
        if (-not (Test-Path -LiteralPath $path)) { continue }
        foreach ($key in @(Get-ChildItem -LiteralPath $path -ErrorAction SilentlyContinue)) {
            $item = Get-ItemProperty -LiteralPath $key.PSPath -ErrorAction SilentlyContinue
            if ($item -and $item.PSObject.Properties['DisplayName'] -and $item.DisplayName) {
                $records.Add([pscustomobject]@{ Name = [string]$item.DisplayName; Evidence = "Installed app: $($item.DisplayName)" })
            }
        }
    }
    if (Get-Command Get-AppxPackage -ErrorAction SilentlyContinue) {
        foreach ($package in @(Get-AppxPackage -ErrorAction SilentlyContinue)) {
            $records.Add([pscustomobject]@{ Name = [string]$package.Name; Evidence = "Windows package: $($package.Name)" })
        }
    }
    foreach ($process in @(Get-Process -Name 'Claude', 'ChatGPT', 'Codex', 'Gemini' -ErrorAction SilentlyContinue)) {
        $records.Add([pscustomobject]@{ Name = [string]$process.ProcessName; Evidence = "Running app: $($process.ProcessName)" })
    }
    return $records.ToArray()
}

function Get-ProviderInventory {
    [CmdletBinding()]
    param(
        [string]$HomeDirectory = [Environment]::GetFolderPath('UserProfile'),
        [hashtable]$Commands,
        [object[]]$DesktopApps
    )
    if (-not $PSBoundParameters.ContainsKey('Commands')) { $Commands = Get-ClientCommands $HomeDirectory }
    if (-not $PSBoundParameters.ContainsKey('DesktopApps')) { $DesktopApps = @(Get-DesktopClients) }
    $definitions = @(
        @{ Id = 'claude'; Name = 'Claude'; Pattern = '(?i)(?:^|[.\s_-])claude(?:$|[.\s_-])'; Folder = '.claude'; DesktopLocal = $false },
        @{ Id = 'chatgpt'; Name = 'ChatGPT / Codex'; Pattern = '(?i)(?:^|[.\s_-])(?:chatgpt|codex)(?:$|[.\s_-])'; Folder = '.agents'; DesktopLocal = $true },
        @{ Id = 'gemini'; Name = 'Gemini'; Pattern = '(?i)(?:^|[.\s_-])gemini(?:$|[.\s_-])'; Folder = '.gemini'; DesktopLocal = $false }
    )
    foreach ($definition in $definitions) {
        $evidence = @()
        $hasCli = $Commands.ContainsKey($definition.Id) -and [bool]$Commands[$definition.Id]
        if ($hasCli) { $evidence += "CLI: $($Commands[$definition.Id])" }
        $desktop = @($DesktopApps | Where-Object { $_.Name -match $definition.Pattern })
        $evidence += @($desktop | ForEach-Object { $_.Evidence } | Select-Object -Unique)
        $detected = $hasCli -or $desktop.Count -gt 0
        $localInstall = $hasCli -or ($definition.DesktopLocal -and $desktop.Count -gt 0)
        $status = if ($localInstall) { 'Local install available' } elseif ($detected) { 'Manual upload required' } else { 'Not detected' }
        [pscustomobject]@{
            Id = $definition.Id; Name = $definition.Name; Detected = $detected
            LocalInstall = $localInstall; Status = $status; Evidence = ($evidence -join '; ')
            SkillsRoot = Join-Path (Join-Path $HomeDirectory $definition.Folder) 'skills'
            BackupRoot = Join-Path (Join-Path $HomeDirectory $definition.Folder) 'skill-backups'
            ShadowSkillsRoot = if ($definition.Id -eq 'gemini') { Join-Path $HomeDirectory '.agents\skills' } else { $null }
        }
    }
}

function Resolve-InstallerSelection {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string[]]$Selection, [Parameter(Mandatory)][object[]]$Items, [string]$Key = 'Name')
    $tokens = @($Selection | ForEach-Object { $_ -split '[,\s]+' } | Where-Object { $_ })
    if (-not $tokens.Count) { throw 'Choose at least one item.' }
    if ('all' -in $tokens) {
        if ($tokens.Count -ne 1) { throw 'Use all by itself.' }
        return $Items
    }
    $selected = @{}
    foreach ($token in $tokens) {
        $item = $null
        if ($token -match '^\d+$') {
            $index = 0
            if (-not [int]::TryParse($token, [ref]$index) -or $index -lt 1 -or $index -gt $Items.Count) {
                throw "Selection number is outside the list: $token"
            }
            $item = $Items[$index - 1]
        } else {
            $item = $Items | Where-Object { $_.$Key -eq $token } | Select-Object -First 1
            if (-not $item) { throw "Unknown selection: $token" }
        }
        if (-not $selected.ContainsKey($item.$Key)) { $selected[$item.$Key] = $item }
    }
    foreach ($item in $Items) { if ($selected.ContainsKey($item.$Key)) { $item } }
}

function Assert-PlainPath {
    param([string]$Path)
    $cursor = [IO.Path]::GetFullPath($Path)
    while ($cursor) {
        if (Test-Path -LiteralPath $cursor) {
            $item = Get-Item -LiteralPath $cursor -Force
            if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
                throw "Linked paths are not supported for installation: $cursor"
            }
        }
        $parent = [IO.Path]::GetDirectoryName($cursor.TrimEnd('\', '/'))
        if ($parent -eq $cursor) { break }
        $cursor = $parent
    }
}

function Get-SkillFiles {
    param([string]$Path)
    $WhatIfPreference = $false
    Assert-PlainPath $Path
    $root = (Get-Item -LiteralPath $Path -ErrorAction Stop).FullName.TrimEnd('\', '/')
    $pending = New-Object 'System.Collections.Generic.Queue[string]'
    $pending.Enqueue($root)
    $files = @{}
    while ($pending.Count) {
        foreach ($item in @(Get-ChildItem -LiteralPath $pending.Dequeue() -Force)) {
            if ($item.Name -eq '.git') { continue }
            if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
                throw "Linked content is not supported in skill copies: $($item.FullName)"
            }
            if ($item.PSIsContainer) { $pending.Enqueue($item.FullName) } else {
                $relative = $item.FullName.Substring($root.Length + 1)
                $files[$relative] = (Get-FileHash -LiteralPath $item.FullName -Algorithm SHA256).Hash
            }
        }
    }
    return $files
}

function Test-SameSkillFiles {
    param([hashtable]$Left, [hashtable]$Right)
    if ($Left.Count -ne $Right.Count) { return $false }
    foreach ($key in $Left.Keys) {
        if (-not $Right.ContainsKey($key) -or $Left[$key] -ne $Right[$key]) { return $false }
    }
    return $true
}

function Install-LocalSkill {
    [CmdletBinding(SupportsShouldProcess)]
    param([Parameter(Mandatory)][object]$Skill, [Parameter(Mandatory)][object]$Provider, [switch]$Update)
    if (-not $Provider.LocalInstall) { throw "Local installation is unavailable for $($Provider.Name)." }
    if ($Skill.Name -notmatch '^[a-z0-9]+(?:-[a-z0-9]+)*$') { throw 'Invalid skill name.' }
    $source = [IO.Path]::GetFullPath($Skill.Source).TrimEnd('\', '/')
    $root = [IO.Path]::GetFullPath($Provider.SkillsRoot).TrimEnd('\', '/')
    $target = [IO.Path]::GetFullPath((Join-Path $root $Skill.Name))
    if ([IO.Path]::GetDirectoryName($target) -ne $root) { throw 'Destination escaped the skill root.' }
    foreach ($path in @($root, $Provider.BackupRoot)) { Assert-PlainPath $path }
    if ($target -eq $source -or $target.StartsWith($source + '\', [StringComparison]::OrdinalIgnoreCase) -or
        $source.StartsWith($target + '\', [StringComparison]::OrdinalIgnoreCase)) { throw 'Source and destination overlap.' }
    if (-not (Test-Path -LiteralPath (Join-Path $source 'SKILL.md') -PathType Leaf)) { throw 'Source SKILL.md is missing.' }
    $sourceFiles = Get-SkillFiles $source
    $exists = Test-Path -LiteralPath $target
    $result = [ordered]@{ Provider = $Provider.Name; Skill = $Skill.Name; Status = ''; Destination = $target; Backup = '' }
    if ($Provider.PSObject.Properties['ShadowSkillsRoot'] -and $Provider.ShadowSkillsRoot) {
        $shared = Join-Path $Provider.ShadowSkillsRoot $Skill.Name
        if (Test-Path -LiteralPath $shared) {
            if (Test-SameSkillFiles $sourceFiles (Get-SkillFiles $shared)) {
                $result.Status = 'Unchanged (shared copy)'; $result.Destination = $shared
                return [pscustomobject]$result
            }
            throw "Gemini would load the different shared copy at $shared. Update that copy first; it takes precedence over $target."
        }
    }
    if ($exists) {
        if (-not (Test-Path -LiteralPath $target -PathType Container)) { throw "Destination is not a folder: $target" }
        if (Test-SameSkillFiles $sourceFiles (Get-SkillFiles $target)) {
            $result.Status = 'Unchanged'; return [pscustomobject]$result
        }
        if (-not $Update) { $result.Status = 'Skipped (use -Update)'; return [pscustomobject]$result }
    }
    if (-not $PSCmdlet.ShouldProcess($target, "Install $($Skill.Name) for $($Provider.Name)")) {
        $result.Status = 'Preview'; return [pscustomobject]$result
    }
    [void][IO.Directory]::CreateDirectory($root)
    $staging = Join-Path $root ('.' + $Skill.Name + '-staging-' + [guid]::NewGuid().ToString('N'))
    $backup = $null
    try {
        [void][IO.Directory]::CreateDirectory($staging)
        foreach ($relative in $sourceFiles.Keys) {
            $copyTarget = Join-Path $staging $relative
            [void][IO.Directory]::CreateDirectory((Split-Path -Parent $copyTarget))
            Copy-Item -LiteralPath (Join-Path $source $relative) -Destination $copyTarget -ErrorAction Stop
        }
        if (-not (Test-SameSkillFiles $sourceFiles (Get-SkillFiles $staging))) { throw 'Copied skill failed verification.' }
        if ($exists) {
            [void][IO.Directory]::CreateDirectory($Provider.BackupRoot)
            $backup = Join-Path $Provider.BackupRoot ($Skill.Name + '-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [guid]::NewGuid().ToString('N'))
            [IO.Directory]::Move($target, $backup)
        }
        [IO.Directory]::Move($staging, $target)
        $result.Status = if ($exists) { 'Updated' } else { 'Installed' }
        if ($backup) { $result.Backup = $backup }
        return [pscustomobject]$result
    } catch {
        if ($backup -and (Test-Path -LiteralPath $backup) -and -not (Test-Path -LiteralPath $target)) {
            [IO.Directory]::Move($backup, $target)
        }
        throw
    } finally {
        if (Test-Path -LiteralPath $staging) {
            $resolvedStage = [IO.Path]::GetFullPath($staging)
            if ([IO.Path]::GetDirectoryName($resolvedStage) -ne $root -or
                -not [IO.Path]::GetFileName($resolvedStage).StartsWith('.' + $Skill.Name + '-staging-')) {
                throw 'Refusing to clean an unexpected staging path.'
            }
            Assert-PlainPath $resolvedStage
            Remove-Item -LiteralPath $resolvedStage -Recurse -Force
        }
    }
}

Export-ModuleMember -Function Get-SkillCatalog, Get-ProviderInventory, Resolve-InstallerSelection, Install-LocalSkill
