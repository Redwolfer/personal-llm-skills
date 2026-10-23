# Claude project entry point

@AGENTS.md

Read HANDOFF.md for the current work status before changing files. Maintain shared rules in AGENTS.md and record handoffs in HANDOFF.md.

## Claude Code notes

These notes apply only to Claude Code. Shared rules stay in AGENTS.md.

- Read the bundled `git-worklog/references/humanizer.md` at the start of every task. The `humanizer` and `git-worklog` skills installed in a Claude session are separate copies and may be out of date. Edit the files in this repository and never point the project at an installed copy.
- This machine runs Windows PowerShell 5.1. `Compress-Archive` writes backslashes in ZIP entry names, so build `dist/git-worklog.zip` with Python's `zipfile` or .NET `ZipArchive` and set each entry name explicitly. Python 3.14 and `openpyxl` are installed.
- In PowerShell 5.1, `Set-Content -Encoding utf8` and `Out-File` add a byte order mark. Write `dist/git-worklog-chat.txt` from Python as UTF-8 without a BOM. The current file has none.
- After a rebuild, open the ZIP and confirm that every entry starts with `git-worklog/` and uses forward slashes. Compare each labeled section of the text bundle with its source file.
- Do not commit, push, or change `dist/` unless the user asks. Check `git status` before editing to preserve existing changes.
- The user writes to Claude in casual Indonesian. Reply in Indonesian in chat, and keep files in English except for Git worklog report text.
- When testing the Git worklog behavior, ask for the date range and author in chat and wait for the answer before running any `git log`.
- Update HANDOFF.md before ending a turn that changed files, and list the checks that actually ran.
