#requires -Version 5.1
[CmdletBinding()]
param()
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path (Split-Path $PSScriptRoot -Parent) 'scripts\SkillInstaller.psm1') -Force

$testRoot = Join-Path ([IO.Path]::GetTempPath()) ('personal-llm-skills-installer-tests-' + [guid]::NewGuid().ToString('N'))
[void][IO.Directory]::CreateDirectory($testRoot)
$utf8 = New-Object System.Text.UTF8Encoding($false)
$script:passed = 0
function Assert-True([bool]$Condition, [string]$Message) {
    if (-not $Condition) { throw $Message }
}
function Assert-Throws([scriptblock]$Action, [string]$Message) {
    $thrown = $false
    try { & $Action | Out-Null } catch { $thrown = $true }
    Assert-True $thrown $Message
}
function Test-Case([string]$Name, [scriptblock]$Action) {
    & $Action
    $script:passed++
    Write-Host "PASS: $Name"
}
function Write-Fixture([string]$Path, [string]$Text) {
    [void][IO.Directory]::CreateDirectory((Split-Path -Parent $Path))
    [IO.File]::WriteAllText($Path, $Text, $utf8)
}
function New-Skill([string]$Root, [string]$Name) {
    $folder = Join-Path $Root $Name
    Write-Fixture (Join-Path $folder 'SKILL.md') "---`nname: $Name`ndescription: A fixture skill.`n---`n`n# $Name`n"
    Write-Fixture (Join-Path $folder 'references\humanizer.md') 'Bundled humanizer text'
    Write-Fixture (Join-Path $folder 'references\humanizer.LICENSE') 'MIT fixture notice'
    Write-Fixture (Join-Path $folder '.metadata') 'Hidden fixture file'
    return $folder
}

try {
    $repo = Join-Path $testRoot 'repository with spaces'
    $homePath = Join-Path $testRoot 'fake home'
    [void](New-Skill $repo 'alpha')
    [void](New-Skill (Join-Path $repo 'skills') 'beta')
    Write-Fixture (Join-Path $repo 'alpha\.git\config') 'Private Git metadata is not skill content'
    Write-Fixture (Join-Path $repo 'skills\beta\SKILL.md') "---`nname: 'beta'`ndescription: |`n  A multiline fixture`n  description.`n---`n`n# Beta`n"
    $catalog = @(Get-SkillCatalog $repo | Sort-Object Name)
    $providers = @(Get-ProviderInventory -HomeDirectory $homePath -Commands @{
        claude = 'C:\fixture\claude.exe'; chatgpt = 'C:\fixture\codex.cmd'; gemini = 'C:\fixture\gemini.cmd'
    } -DesktopApps @())

    Test-Case 'Discover multiple skills, including the skills/ layout' {
        Assert-True (($catalog.Name -join ',') -eq 'alpha,beta') 'The catalog lost a skill.'
        Assert-True ($catalog[1].Description -eq 'A multiline fixture description.') 'Multiline description was not read.'
    }
    Test-Case 'Select several skills by number and name without duplicates' {
        $selected = @(Resolve-InstallerSelection -Selection '2,alpha,2' -Items $catalog)
        Assert-True (($selected.Name -join ',') -eq 'alpha,beta') 'Selection was incomplete or duplicated.'
        Assert-True (@(Resolve-InstallerSelection -Selection all -Items $catalog).Count -eq 2) 'All did not select every skill.'
        Assert-Throws { Resolve-InstallerSelection -Selection '3' -Items $catalog } 'Out-of-range input was accepted.'
        Assert-Throws { Resolve-InstallerSelection -Selection 'all,alpha' -Items $catalog } 'Mixed all selection was accepted.'
        Assert-Throws { Resolve-InstallerSelection -Selection 'unknown' -Items $catalog } 'Unknown skill was accepted.'
    }
    Test-Case 'Detect three local clients from command evidence' {
        Assert-True ($providers.Count -eq 3) 'Unexpected provider count.'
        Assert-True (@($providers | Where-Object LocalInstall).Count -eq 3) 'A CLI was not selectable.'
        Assert-True ($providers[1].SkillsRoot -eq (Join-Path $homePath '.agents\skills')) 'Wrong ChatGPT destination.'
        $chosen = @(Resolve-InstallerSelection -Selection 'claude,gemini' -Items $providers -Key Id)
        Assert-True (($chosen.Id -join ',') -eq 'claude,gemini') 'Multiple provider selection failed.'
        Assert-Throws { Resolve-InstallerSelection -Selection 'another-provider' -Items $providers -Key Id } 'A fourth provider was accepted.'
    }
    Test-Case 'Empty config folders do not count as installed applications' {
        [void][IO.Directory]::CreateDirectory((Join-Path $homePath '.claude'))
        $absent = @(Get-ProviderInventory -HomeDirectory $homePath -Commands @{} -DesktopApps @())
        Assert-True (@($absent | Where-Object Detected).Count -eq 0) 'A leftover config folder caused a false detection.'
    }
    Test-Case 'Desktop-only Claude and Gemini require upload; ChatGPT desktop supports local installation' {
        $desktop = @(Get-ProviderInventory -HomeDirectory $homePath -Commands @{} -DesktopApps @(
            [pscustomobject]@{ Name = 'Claude'; Evidence = 'Fixture desktop' },
            [pscustomobject]@{ Name = 'OpenAI.Codex'; Evidence = 'Fixture desktop' },
            [pscustomobject]@{ Name = 'Gemini'; Evidence = 'Fixture desktop' }
        ))
        Assert-True ($desktop[0].Detected -and -not $desktop[0].LocalInstall) 'Claude desktop was treated as Claude Code.'
        Assert-True $desktop[1].LocalInstall 'ChatGPT desktop was not installable.'
        Assert-True ($desktop[2].Detected -and -not $desktop[2].LocalInstall) 'Gemini desktop was treated as its CLI.'
    }
    Test-Case 'Preview creates no target directory' {
        $preview = Install-LocalSkill -Skill $catalog[0] -Provider $providers[0] -WhatIf
        Assert-True ($preview.Status -eq 'Preview') 'Preview was not reported.'
        Assert-True (-not (Test-Path -LiteralPath $providers[0].SkillsRoot)) 'Preview wrote to the destination.'
    }
    Test-Case 'Install two skills for all three providers with bundled references intact' {
        foreach ($provider in $providers) {
            foreach ($skill in $catalog) {
                $installed = Install-LocalSkill -Skill $skill -Provider $provider
                Assert-True ($installed.Status -in @('Installed','Unchanged (shared copy)')) 'Skill was not installed or available through its shared alias.'
                Assert-True (-not (Test-Path -LiteralPath (Join-Path $installed.Destination '.git'))) 'Git metadata was copied.'
                foreach ($relative in @('SKILL.md','references\humanizer.md','references\humanizer.LICENSE','.metadata')) {
                    Assert-True ((Get-FileHash -LiteralPath (Join-Path $skill.Source $relative)).Hash -eq
                        (Get-FileHash -LiteralPath (Join-Path $installed.Destination $relative)).Hash) 'Copied content differs.'
                }
            }
        }
    }
    Test-Case 'Repeat installation leaves matching skills unchanged' {
        $again = Install-LocalSkill -Skill $catalog[0] -Provider $providers[0]
        Assert-True ($again.Status -eq 'Unchanged') 'Matching content was rewritten.'
        Assert-True (-not (Test-Path -LiteralPath $providers[0].BackupRoot)) 'Unchanged skill created a backup.'
    }
    Test-Case 'Gemini checks the higher-priority shared alias before reporting success' {
        $shared = Install-LocalSkill -Skill $catalog[0] -Provider $providers[2]
        Assert-True ($shared.Status -eq 'Unchanged (shared copy)') 'Matching shared copy was not recognized.'
        $localNote = Join-Path (Join-Path $providers[1].SkillsRoot 'beta') 'local-note.txt'
        Write-Fixture $localNote 'Different shared copy'
        Assert-Throws { Install-LocalSkill -Skill $catalog[1] -Provider $providers[2] -Update } 'A shadowed copy was reported as installed.'
        Assert-True (Test-Path -LiteralPath $localNote) 'Shared local edits were changed.'
    }
    Test-Case 'Existing local edits are skipped unless update is requested' {
        $destination = Join-Path $providers[0].SkillsRoot 'alpha'
        Write-Fixture (Join-Path $destination 'local-note.txt') 'Keep this local edit'
        $skipped = Install-LocalSkill -Skill $catalog[0] -Provider $providers[0]
        Assert-True ($skipped.Status -like 'Skipped*') 'Local edits were overwritten.'
        Assert-True (Test-Path -LiteralPath (Join-Path $destination 'local-note.txt')) 'Local file was lost.'
    }
    Test-Case 'Update backs up old content and removes stale files only from the new copy' {
        $updated = Install-LocalSkill -Skill $catalog[0] -Provider $providers[0] -Update
        Assert-True ($updated.Status -eq 'Updated') 'Update was not reported.'
        Assert-True (Test-Path -LiteralPath (Join-Path $updated.Backup 'local-note.txt')) 'Backup lost the local edit.'
        Assert-True (-not (Test-Path -LiteralPath (Join-Path $updated.Destination 'local-note.txt'))) 'Stale file remained in the installed skill.'
    }
    Test-Case 'Failed update preserves the installed copy and cleans staging' {
        $provider = [pscustomobject]@{
            Name = 'Fixture failure'; LocalInstall = $true
            SkillsRoot = Join-Path $testRoot 'failure\skills'; BackupRoot = Join-Path $testRoot 'failure\backup-file'
        }
        $old = Install-LocalSkill -Skill $catalog[0] -Provider $provider
        Write-Fixture (Join-Path $old.Destination 'local-note.txt') 'Original survives'
        Write-Fixture $provider.BackupRoot 'This file prevents backup directory creation'
        Assert-Throws { Install-LocalSkill -Skill $catalog[0] -Provider $provider -Update } 'Failure was not propagated.'
        Assert-True ((Get-Content -Raw -LiteralPath (Join-Path $old.Destination 'local-note.txt')) -eq 'Original survives') 'Existing installation was damaged.'
        Assert-True (@(Get-ChildItem -LiteralPath $provider.SkillsRoot -Force -Directory | Where-Object Name -Like '*staging*').Count -eq 0) 'Staging folder was left behind.'
    }
    Test-Case 'Reject path traversal, overlapping sources, and unsupported clients' {
        $bad = [pscustomobject]@{ Name = '../escape'; Source = $catalog[0].Source }
        Assert-Throws { Install-LocalSkill -Skill $bad -Provider $providers[0] } 'Traversal name was accepted.'
        $overlap = [pscustomobject]@{ Name = 'Overlap'; LocalInstall = $true; SkillsRoot = $repo; BackupRoot = (Join-Path $testRoot 'backups') }
        Assert-Throws { Install-LocalSkill -Skill $catalog[0] -Provider $overlap } 'Overlapping paths were accepted.'
        $manual = [pscustomobject]@{ Name = 'Manual'; LocalInstall = $false }
        Assert-Throws { Install-LocalSkill -Skill $catalog[0] -Provider $manual } 'Unsupported client accepted a local install.'
    }
    Test-Case 'The script entry point discovers its own collection without an explicit repository path' {
        $installerRoot = Split-Path -Parent $PSScriptRoot
        Copy-Item -LiteralPath (Join-Path $installerRoot 'install.ps1') -Destination (Join-Path $repo 'install.ps1')
        [void][IO.Directory]::CreateDirectory((Join-Path $repo 'scripts'))
        Copy-Item -LiteralPath (Join-Path $installerRoot 'scripts\SkillInstaller.psm1') -Destination (Join-Path $repo 'scripts\SkillInstaller.psm1')
        $output = & powershell.exe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $repo 'install.ps1') -List 2>&1 | Out-String
        Assert-True ($LASTEXITCODE -eq 0) "Default collection discovery failed: $output"
        Assert-True ($output -match 'alpha' -and $output -match 'beta') 'Entry point did not list its fixture skills.'
    }
    Test-Case 'Reject duplicate skill names before installation' {
        [void](New-Skill (Join-Path $repo 'skills') 'alpha')
        Assert-Throws { @(Get-SkillCatalog $repo) } 'Duplicate names were accepted.'
    }
    Test-Case 'Reject junction content without following it' {
        $link = Join-Path $catalog[0].Source 'linked-content'
        $outside = Join-Path $testRoot 'outside-skill'
        Write-Fixture (Join-Path $outside 'keep.txt') 'Outside file'
        [void](New-Item -ItemType Junction -Path $link -Target $outside)
        try {
            Assert-Throws { Install-LocalSkill -Skill $catalog[0] -Provider $providers[0] -Update } 'Linked content was copied.'
            Assert-True (Test-Path -LiteralPath (Join-Path $outside 'keep.txt')) 'Linked target changed.'
        } finally { [IO.Directory]::Delete($link) }
    }
    Write-Host "`n$script:passed tests passed. All installation writes used a temporary fixture home."
} finally {
    $resolved = [IO.Path]::GetFullPath($testRoot)
    $tempRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\','/')
    if ([IO.Path]::GetDirectoryName($resolved) -ne $tempRoot -or
        -not [IO.Path]::GetFileName($resolved).StartsWith('personal-llm-skills-installer-tests-')) {
        throw 'Unexpected test cleanup path.'
    }
    if (Test-Path -LiteralPath $resolved) { Remove-Item -LiteralPath $resolved -Recurse -Force }
}
