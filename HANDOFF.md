# Project handoff

Updated: 2026-10-24 (Asia/Bangkok).
Last contributor: ChatGPT.

## Current status

The project includes a Windows PowerShell installer for selecting one or more skills and detected providers. Claude Code and ChatGPT/Codex support local installation. Gemini uses local installation when its CLI is detected; desktop-only Claude or Gemini is listed for manual upload.

Git worklog still bundles Humanizer 3.1.0 and its MIT license. Shared project rules remain in AGENTS.md, imported by CLAUDE.md and GEMINI.md.

## Active work

No active tasks or file reservations. The installer has been implemented and checked. The user can run install.ps1 to choose the skills and providers to install.

## Latest files

- [install.ps1](install.ps1): interactive selection, inventory, explicit options, and preview mode.
- [scripts/SkillInstaller.psm1](scripts/SkillInstaller.psm1): discovery, local installation, hash verification, and update backups.
- [tests/installer.tests.ps1](tests/installer.tests.ps1): isolated installer checks using temporary profiles.
- [README.md](README.md): commands, detection rules, destinations, backup behavior, and limitations.
- [HANDOFF.md](HANDOFF.md): current work snapshot.

## Distribution status

This task adds project-level installation tooling and tests. Git worklog package sources and the existing ZIP/text distribution files are unchanged.

## Verification

Sixteen installer tests passed on Windows PowerShell 5.1 using temporary fixture profiles, including two skills installed for all three simulated providers. Read-only detection and both interactive and explicit-option previews passed on the actual machine. No skills were installed or updated in real client profiles during testing.

The actual inventory found Claude Code and ChatGPT/Codex for local installation. A Gemini desktop application was found, but the Gemini CLI command was not detected. Native provider loading after installation has not been tested.
