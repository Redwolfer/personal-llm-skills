# Project handoff

Updated: 2026-10-24 (Asia/Bangkok).
Last contributor: ChatGPT.

## Current status

The installer discovers both Git worklog and the user-added official Humanizer 3.1.0 folder. Users can install either skill or both for detected Claude Code, ChatGPT/Codex, and Gemini CLI clients. Desktop-only Claude or Gemini is listed for manual upload.

Git worklog still bundles Humanizer 3.1.0 and its MIT license. Shared project rules remain in AGENTS.md, imported by CLAUDE.md and GEMINI.md.

Every new or imported skill must now include `dist/<skill-name>.zip` and `dist/<skill-name>-chat.txt`. Changes to a skill's source require rebuilding both. Both current skills have these files.

## Active work

No active tasks or file reservations. The distribution rule and Humanizer packages are complete. The user requested a commit and push directly on master using the existing Git credentials. No real client installations were performed.

## Latest files

- [AGENTS.md](AGENTS.md): require both distribution files for new, imported, or changed skills and verify them before completion.
- [CLAUDE.md](CLAUDE.md) and [GEMINI.md](GEMINI.md): follow the shared packaging requirement. The old Claude restriction on editing dist/ was removed; commits and pushes still require a user request.
- [README.md](README.md): list all four distribution files and explain the packaging requirement and Humanizer upload bundle.
- [humanizer.zip](dist/humanizer.zip) and [humanizer-chat.txt](dist/humanizer-chat.txt): new distribution files for the imported skill.
- [HANDOFF.md](HANDOFF.md): current work snapshot.

## Distribution status

Humanizer's ZIP contains 14 source files under a single humanizer/ directory, including its SKILL.md, supporting files, and MIT license. The upstream .git/ directory is excluded. Its text bundle includes loading instructions and labeled SKILL.md and LICENSE sections, written as UTF-8 without a BOM.

Neither skill's source files were edited for this packaging update. Git worklog's existing ZIP/text distribution files are unchanged. Both skills now have the required ZIP and text bundle in dist/.

Humanizer is imported as ordinary source files in the parent repository. Its original Git metadata is preserved locally at .git/upstream-repositories/humanizer.git so the upstream history remains recoverable. That backup is excluded from commits and distribution files. Do not add Humanizer as a Git link or submodule.

## Verification

Current checks: the Humanizer ZIP file list and all 14 payloads match the source. Its archive has one skill root, forward slash paths, and no Git metadata. Both labeled text sections match the source bytes exactly, and the text bundle is UTF-8 without a BOM. All current skills have both required distribution files. Documentation links passed. Git diff --check passed for maintained project files; the upstream README's two existing trailing spaces were retained.

Previous installer checks: eighteen tests passed on Windows PowerShell 5.1 using temporary fixture profiles. They include the official Humanizer package installed separately for each simulated provider, with matching SKILL.md, LICENSE, and agents/openai.yaml hashes. CRLF discovery passed with and without a BOM, and discovery preserved source bytes. Installer tests were not repeated for this documentation and packaging update.

Humanizer's scripts/validate-package.py previously passed under Python 3.14: package v3.1.0 is valid. Its upstream source files remain unchanged; the original Git metadata has been preserved in the parent repository metadata directory. The official and Git worklog copies of the Humanizer prompt match after line-ending normalization.

Read-only inventory and an explicit preview selecting both skills previously passed on the actual machine. No skills were installed or updated in real client profiles during testing.

The actual inventory found Claude Code and ChatGPT/Codex for local installation. A Gemini desktop application was found, but the Gemini CLI command was not detected. Native provider loading after installation has not been tested. Upstream marketplace checks were not run because this update uses local skill folders and does not change or publish the official package.
