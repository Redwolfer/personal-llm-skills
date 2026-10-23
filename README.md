# Personal LLM skills

A personal collection of skills for Claude, ChatGPT, and Gemini. Each skill has its own folder with a `SKILL.md` entry point and the references needed to run it.

## Available skills

[Git worklog](git-worklog/README.md) turns Git commits into a draft Excel work log in Bahasa Indonesia. It reads the diffs, estimates effort, and groups rows by calendar week. Humanizer is bundled with the skill and runs before the prose is written to the report.

Start with the [Git worklog instructions](git-worklog/SKILL.md) or its [usage reference](git-worklog/references/usage.md). The skill README covers installation for the three supported providers.

## Project layout

```text
personal-llm-skills/
|-- README.md
|-- AGENTS.md
|-- CLAUDE.md
|-- GEMINI.md
|-- HANDOFF.md
|-- git-worklog/
|   |-- SKILL.md
|   |-- README.md
|   `-- references/
`-- dist/
    |-- git-worklog.zip
    `-- git-worklog-chat.txt
```

Skill folders contain the editable source. The root [AGENTS.md](AGENTS.md) describes how to maintain the project.

The `dist/` folder holds distribution files generated from that source:

- [git-worklog.zip](dist/git-worklog.zip) contains the skill folder for native installation where supported.
- [git-worklog-chat.txt](dist/git-worklog-chat.txt) combines the entry point and all references into one labeled text file for instruction uploads.

Both files include Humanizer and its MIT license. Make changes in `git-worklog/`, then regenerate the distribution files when package content changes.

## Work with ChatGPT, Claude, or Gemini

All three providers share the rules in [AGENTS.md](AGENTS.md) and the current status in [HANDOFF.md](HANDOFF.md). Every task must use the bundled [Humanizer](git-worklog/references/humanizer.md), including its prose review and fact check.

| Provider | Project entry point |
|---|---|
| ChatGPT through Codex | Open this project folder so Codex can load AGENTS.md. See [OpenAI's project instruction guidance](https://learn.chatgpt.com/docs/agent-configuration/agents-md). |
| Claude through Claude Code | CLAUDE.md imports AGENTS.md. See [Claude's instruction import guidance](https://code.claude.com/docs/en/memory). |
| Gemini through Gemini CLI | GEMINI.md imports AGENTS.md. See [Gemini's context import guidance](https://geminicli.com/docs/cli/gemini-md/). |

For a web chat that cannot read this folder, attach or paste AGENTS.md, HANDOFF.md, the Humanizer reference, and the source files needed for the task. Ask the assistant to follow the shared rules. Apply its returned changes to this project before the next handoff.

To transfer work, update HANDOFF.md with the outcome, affected files, checks, blockers, and next step. The next agent reads that snapshot and the current files before continuing. For simultaneous work, agree on separate tasks and file ownership to avoid overwriting each other's edits.

These files provide shared instructions and handoff context. They do not start provider sessions or synchronize edits between accounts.

## Git worklog requirements

Every report run asks the user to supply or confirm a date range and author before reading history. The output location defaults to Desktop, and project scope defaults to the working folder. Reports covering multiple projects use a context prefix in Task, such as `PMB Admin -` or `PMB Client -`, based on the confirmed mapping or Git evidence.

The host needs Git and repository access, or supplied commit metadata and patches. Creating an Excel workbook uses Python with `openpyxl`. A host without file generation can return CSV or a short table.

## Editing and packaging

Always use the bundled [Humanizer guidance](git-worklog/references/humanizer.md) for work in this project. Keep instructions and project documentation in English. Git worklog report text remains in Bahasa Indonesia.

Keep each skill self-contained. Store detailed rules in its references and link them from `SKILL.md` where they are used. Preserve the [Humanizer license](git-worklog/references/humanizer.LICENSE) when redistributing its instructions.

After changing a skill package:

1. Check its metadata, relative links, and required behavior.
2. Rebuild its ZIP with one top-level skill folder and forward slashes in archive paths.
3. Rebuild its text bundle with a labeled section for the entry point and every reference, including licenses.
4. Compare both outputs with the source files.

The project currently has no checked-in build script or automated test suite. Package checks establish file integrity and structure; live installation checks must be reported separately.
