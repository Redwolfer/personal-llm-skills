# Gemini project entry point

@./AGENTS.md

Read HANDOFF.md for the current work status before changing files. Maintain shared rules in AGENTS.md and record handoffs in HANDOFF.md.

## Gemini notes

These notes apply to Gemini CLI and Gemini coding environments. Shared rules stay in AGENTS.md.

- Read the bundled `git-worklog/references/humanizer.md` at the start of every task. Any `git-worklog` or `humanizer` skills installed under `~/.gemini/skills/` or other system paths are separate copies. Edit the repository files directly and keep references relative.
- This machine runs Windows PowerShell 5.1. Shell commands execute in individual sessions where working directories and environment variables do not carry over to subsequent commands.
- `Compress-Archive` writes backslashes in ZIP entry names on Windows. Build `dist/git-worklog.zip` using Python's `zipfile` module and verify entries use forward slashes starting with `git-worklog/`. Python 3.14 and `openpyxl` are installed.
- PowerShell 5.1 cmdlets like `Set-Content -Encoding utf8` prepend a byte order mark. Write `dist/git-worklog-chat.txt` using Python to maintain UTF-8 without a BOM.
- Check `git status` before editing root documentation and preserve existing changes. Avoid committing or pushing unless requested.
- The user writes in casual Indonesian. Respond in Indonesian in chat, and write files in English except for Git worklog report content.
- When running or testing the Git worklog workflow, always prompt for the date range and author in chat before invoking `git log`.
- Update HANDOFF.md before finishing any turn that modifies files, listing the exact checks that were run.
