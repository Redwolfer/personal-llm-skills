#requires -Version 5.1
<#
.SYNOPSIS
Install selected local skills for detected Claude, ChatGPT/Codex, and Gemini clients.
.EXAMPLE
.\install.ps1
.EXAMPLE
.\install.ps1 -Skills git-worklog -Providers claude,chatgpt -WhatIf
.EXAMPLE
.\install.ps1 -Skills all -Providers all -NonInteractive -Update
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [string[]]$Skills,
    [string[]]$Providers,
    [switch]$List,
    [switch]$NonInteractive,
    [switch]$Update,
    [string]$RepositoryRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($RepositoryRoot)) { $RepositoryRoot = $PSScriptRoot }
$preview = [bool]$WhatIfPreference
$WhatIfPreference = $false
Import-Module (Join-Path $PSScriptRoot 'scripts\SkillInstaller.psm1') -Force

function Read-Selection {
    param([string]$Prompt, [object[]]$Items, [string]$Key)
    while ($true) {
        $answer = Read-Host "$Prompt (numbers or names separated by commas; all; q to cancel)"
        if ($answer -eq 'q') { throw [OperationCanceledException]::new('Installation cancelled.') }
        try { return @(Resolve-InstallerSelection -Selection $answer -Items $Items -Key $Key) }
        catch { Write-Host $_.Exception.Message -ForegroundColor Yellow }
    }
}

try {
    if ($env:OS -ne 'Windows_NT') { throw 'This installer requires Windows PowerShell 5.1 or PowerShell on Windows.' }
    $catalog = @(Get-SkillCatalog -RepositoryRoot $RepositoryRoot)
    $inventory = @(Get-ProviderInventory)
    Write-Host "`nDetected clients"
    $inventory | Select-Object Id, Name, Status, Evidence | Format-Table -Wrap -AutoSize | Out-Host
    Write-Host 'Available skills'
    for ($i = 0; $i -lt $catalog.Count; $i++) { Write-Host ("  {0}. {1}" -f ($i + 1), $catalog[$i].Name) }
    if ($List) { return }
    if (-not $catalog.Count) { throw 'No skill folders containing SKILL.md were found.' }
    $available = @($inventory | Where-Object LocalInstall)
    if (-not $available.Count) { throw 'No client with local skill support was detected. Desktop-only Claude or Gemini requires a manual upload.' }
    if ($NonInteractive -and (-not $Skills -or -not $Providers)) {
        throw '-NonInteractive requires both -Skills and -Providers. Each accepts all.'
    }
    $selectedSkills = if ($Skills) { @(Resolve-InstallerSelection -Selection $Skills -Items $catalog) } else {
        @(Read-Selection 'Choose skills' $catalog 'Name')
    }
    Write-Host "`nLocal installation targets"
    for ($i = 0; $i -lt $available.Count; $i++) {
        Write-Host ("  {0}. {1} ({2}) -> {3}" -f ($i + 1), $available[$i].Name, $available[$i].Id, $available[$i].SkillsRoot)
    }
    $selectedProviders = if ($Providers) { @(Resolve-InstallerSelection -Selection $Providers -Items $available -Key Id) } else {
        @(Read-Selection 'Choose providers' $available 'Id')
    }
    Write-Host "`nSelected skills: $($selectedSkills.Name -join ', ')"
    Write-Host "Selected providers: $($selectedProviders.Name -join ', ')"
    if ('chatgpt' -in $selectedProviders.Id) {
        Write-Host 'ChatGPT uses .agents/skills, which Gemini CLI also recognizes as a shared alias.'
    }
    $results = @()
    $failed = $false
    foreach ($provider in $selectedProviders) {
        foreach ($skill in $selectedSkills) {
            try {
                $results += Install-LocalSkill -Skill $skill -Provider $provider -Update:$Update -WhatIf:$preview
            } catch {
                $failed = $true
                Write-Warning ("{0} / {1}: {2}" -f $provider.Name, $skill.Name, $_.Exception.Message)
            }
        }
    }
    $results | Format-Table Provider, Skill, Status, Destination, Backup -Wrap -AutoSize | Out-Host
    if ($preview) { Write-Host 'Preview complete. No skill copies were written.' } else {
        Write-Host 'Restart the client or reload its skill list after installation.'
    }
    if (@($inventory | Where-Object { $_.Detected -and -not $_.LocalInstall }).Count) {
        Write-Host 'For clients marked Manual upload required, use the upload steps in the skill README.'
    }
    if ($failed) { exit 1 }
} catch [OperationCanceledException] {
    Write-Host $_.Exception.Message
    exit 0
} catch {
    Write-Error $_.Exception.Message -ErrorAction Continue
    exit 1
}
