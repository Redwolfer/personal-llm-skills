# Personal LLM skills

A personal collection of skills for Claude, ChatGPT, and Gemini. Each skill has its own folder with a `SKILL.md` entry point and the references needed to run it.

## Available skills

[Git worklog](git-worklog/README.md) turns Git commits into a draft Excel work log in Bahasa Indonesia. It reads the diffs, estimates effort, and groups rows by calendar week. Humanizer is bundled with the skill and runs before the prose is written to the report.

Start with the [Git worklog instructions](git-worklog/SKILL.md) or its [usage reference](git-worklog/references/usage.md). The skill README covers installation for the three supported providers.

[Humanizer](humanizer/SKILL.md) rewrites prose while preserving its facts and the writer's voice. The official 3.1.0 source is available as a separate skill, including its [MIT license](humanizer/LICENSE) and OpenAI display metadata. Select `humanizer` in the installer to use it for writing outside Git worklog. Git worklog keeps its own bundled copy, so either skill can be installed on its own.

[Council](council/README.md) researches a question across primary sources, Reddit, X/Twitter, and other relevant websites before comparing four perspectives. QUICK uses one round and DEBATE uses three. Results are Indonesian Gen Z tables, with the complete bundled Humanizer applied to all prose and a final evidence check after styling. Sessions without browsing or independent agents disclose those limits.

## Project layout

```text
personal-llm-skills/
|-- README.md
|-- AGENTS.md
|-- CLAUDE.md
|-- GEMINI.md
|-- HANDOFF.md
|-- install.ps1
|-- scripts/
|   `-- SkillInstaller.psm1
|-- tests/
|   `-- installer.tests.ps1
|-- git-worklog/
|   |-- SKILL.md
|   |-- README.md
|   `-- references/
|-- humanizer/
|   |-- SKILL.md
|   |-- README.md
|   |-- LICENSE
|   `-- agents/
|       `-- openai.yaml
|-- council/
|   |-- SKILL.md
|   |-- README.md
|   |-- Workflows/
|   |-- references/
|   `-- agents/
`-- dist/
    |-- git-worklog.zip
    |-- git-worklog-chat.txt
    |-- humanizer.zip
    |-- humanizer-chat.txt
    |-- council.zip
    `-- council-chat.txt
```

Skill folders contain the editable source. The root [AGENTS.md](AGENTS.md) describes how to maintain the project.

The `dist/` folder holds distribution files generated from that source:

- [git-worklog.zip](dist/git-worklog.zip) contains the skill folder for native installation where supported.
- [git-worklog-chat.txt](dist/git-worklog-chat.txt) combines the entry point and all references into one labeled text file for instruction uploads.
- [humanizer.zip](dist/humanizer.zip) contains the official Humanizer skill folder, supporting files, and MIT license. Git metadata is excluded.
- [humanizer-chat.txt](dist/humanizer-chat.txt) combines the Humanizer entry point and MIT license for instruction uploads.
- [council.zip](dist/council.zip) contains the council workflows, style guide, complete bundled Humanizer, and its MIT license.
- [council-chat.txt](dist/council-chat.txt) includes the same workflow instructions and references as labeled text sections for chat uploads.

Every skill must have `dist/<skill-name>.zip` and `dist/<skill-name>-chat.txt`. Create both when adding a new or imported skill, and rebuild them whenever its package content changes. All current distribution files include the applicable Humanizer instructions and MIT license.

## Install skills on this computer

Run the Windows installer from the project folder. It requires PowerShell 5.1 or later and no extra modules.

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
```

The installer lists detected clients and available skills. Choose one or more skills, then one or more providers. Enter numbers or names separated by commas, `all` for the whole list, or `q` to cancel. Add another skill folder with a matching `SKILL.md` name to make it appear in the catalog. Skill folders inside `skills/` are also supported.

For a read-only inventory:

```powershell
.\install.ps1 -List
```

To preview installation without writing skill copies:

```powershell
.\install.ps1 -Skills all -Providers all -NonInteractive -WhatIf
```

To install Git worklog for selected providers:

```powershell
.\install.ps1 -Skills git-worklog -Providers claude,chatgpt -NonInteractive
```

To install Humanizer by itself, or both skills together:

```powershell
.\install.ps1 -Skills humanizer -Providers all -NonInteractive
.\install.ps1 -Skills git-worklog,humanizer -Providers all -NonInteractive
```

To install Council for detected local clients:

```powershell
.\install.ps1 -Skills council -Providers all -NonInteractive
```

See [Council's setup and usage](council/README.md) for each provider, chat uploads, execution modes, and research access limits.

`-Skills` and `-Providers` accept comma-separated values or `all`. Provider IDs are `claude`, `chatgpt`, and `gemini`. For providers, `all` includes only detected clients that support local skill folders. Use `-RepositoryRoot` to read skills from another collection.

Existing copies are left unchanged when they match the source. Different copies are skipped unless `-Update` is supplied:

```powershell
.\install.ps1 -Skills all -Providers all -NonInteractive -Update
```

An update first verifies a staged copy, then saves the existing installation under the provider's `skill-backups/` directory. References, hidden support files, and licenses are included. Git metadata is excluded. Linked paths are rejected. Restart the client or reload its skill list after installation.

### Client detection and destinations

Detection checks CLI commands on PATH, common executable locations, registered Windows applications, Windows app packages, and running client processes. Configuration folders alone do not count as an installed client. The installer does not start clients, sign in, download applications, or change their credentials.

| Provider | Local installation target | Client requirement |
|---|---|---|
| Claude | `%USERPROFILE%\.claude\skills\<skill-name>` | Claude Code. Desktop-only Claude is listed as requiring manual upload. |
| ChatGPT | `%USERPROFILE%\.agents\skills\<skill-name>` | ChatGPT/Codex desktop or Codex CLI. |
| Gemini | `%USERPROFILE%\.gemini\skills\<skill-name>` | Gemini CLI. A desktop application alone is listed as requiring manual upload. |

These targets follow the official [Claude Code](https://code.claude.com/docs/en/skills), [OpenAI](https://learn.chatgpt.com/docs/build-skills), and [Gemini CLI](https://geminicli.com/docs/cli/skills/) skill locations. Claude Cowork and cloud sessions use account-level skills and do not read the personal Claude Code folder. Gemini CLI also discovers `.agents/skills`, so a ChatGPT-targeted copy may be visible to Gemini; that shared alias takes precedence over `.gemini/skills` at the same scope. A matching shared copy is reported as unchanged. If it differs from the source, the Gemini install stops and asks you to update the shared copy first. When both providers are selected with `-Update`, ChatGPT is processed before Gemini.

For a client marked `Manual upload required`, follow the [skill's upload instructions](git-worklog/README.md). Local file copying does not register skills in a web account or Gemini Gem. Application detection reports local evidence; it does not verify account access or client version compatibility.

### Use Humanizer with each provider

The installer uses the same `humanizer/SKILL.md` for all three providers. It accepts Windows and Unix line endings, including UTF-8 files with a byte order mark, and preserves the source files when copying them.

| Provider | Install for a detected local client | Use after installation |
|---|---|---|
| Claude Code | `.\install.ps1 -Skills humanizer -Providers claude -NonInteractive` | Ask Claude to use the `humanizer` skill on your text. |
| ChatGPT / Codex | `.\install.ps1 -Skills humanizer -Providers chatgpt -NonInteractive` | Select Humanizer or ask the assistant to use it. |
| Gemini CLI | `.\install.ps1 -Skills humanizer -Providers gemini -NonInteractive` | Ask Gemini to use the `humanizer` skill on your text. |

For a Claude, ChatGPT, or Gemini chat with file uploads, attach [humanizer-chat.txt](dist/humanizer-chat.txt) and ask: `Follow the SKILL.md section in the attached Humanizer bundle to rewrite this text. Preserve its facts and match my voice.` This loads the instructions for that chat. Use [humanizer.zip](dist/humanizer.zip) where native skill uploads are supported, or the local installer for automatic skill discovery in supported clients.

The official source folder retains its upstream documentation and plugin metadata. This collection installs skills through local folders and supports only Claude, ChatGPT, and Gemini. It does not run a plugin marketplace installer. Preserve [humanizer/LICENSE](humanizer/LICENSE) when sharing a copy.

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

For every new, imported, or changed skill package:

1. Check its metadata, relative links, and required behavior.
2. Create or rebuild `dist/<skill-name>.zip` with one top-level skill folder and forward slashes in archive paths. Exclude Git metadata, caches, and generated distribution files.
3. Create or rebuild `dist/<skill-name>-chat.txt` with a labeled section for the entry point, every reference, required text resources, and applicable licenses. Use UTF-8 without a BOM.
4. Compare both outputs with the source files and list them in this README. The work is complete when both distribution files are present and verified.

Run the installer tests with:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tests\installer.tests.ps1
```

The tests use temporary fixture homes to cover multi-skill and multi-provider selection, detection, copying, previews, update backups, failure cleanup, and path validation. They also check Windows metadata encodings and install the official Humanizer files for each simulated provider, including its license and OpenAI metadata. They do not change real client installations. The project has no checked-in distribution build script. Package checks establish file integrity and structure; live provider loading must be reported separately.
