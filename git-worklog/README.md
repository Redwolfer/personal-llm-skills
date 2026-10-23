# Git worklog

Create a draft Excel work log from Git commits. The skill reads each diff, writes task summaries in Bahasa Indonesia, assigns estimated Man/Hour, and groups work by ISO calendar week.

The instructions are in English. Report prose remains in Bahasa Indonesia, and the column names, Type values, effort brackets, and defaults follow the report template.

Supported providers are limited to Claude, ChatGPT, and Gemini. Humanizer 3.1.0 ships inside the package and runs as a required step when drafting report cells. Install or load the package once to get both workflows.

## Package

```text
git-worklog/
|-- SKILL.md
|-- README.md
`-- references/
    |-- usage.md
    |-- inputs-and-history.md
    |-- project-context.md
    |-- diff-analysis.md
    |-- writing-style.md
    |-- humanizer.md
    |-- humanizer.LICENSE
    |-- type-classification.md
    |-- effort-estimation.md
    |-- calendar-weeks.md
    |-- spreadsheet.md
    `-- delivery.md
```

[SKILL.md](SKILL.md) is the entry point. Keep the entire folder together so its relative links resolve. The package contains instructions and references; it needs no vendor plugin manifest or API key. Workbook generation uses Python with `openpyxl` in the host environment.

The distribution files in the sibling `dist/` directory are `git-worklog.zip` for native skill installation and `git-worklog-chat.txt` for loading the complete instructions into a chat. Both include Humanizer and its license.

## Install or load the skill

### Claude

For Claude Code, copy the folder to `~/.claude/skills/git-worklog/` for personal use or `.claude/skills/git-worklog/` within a project. For claude.ai with custom Skills available, zip the `git-worklog` folder and upload it through the Skills settings. Keep `SKILL.md` inside that top-level folder. See [Anthropic's Agent Skills documentation](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview).

### ChatGPT

Standalone skills are supported in the ChatGPT desktop app and Codex. For local Codex discovery, copy the folder to `~/.agents/skills/git-worklog/` for personal use or `.agents/skills/git-worklog/` within a repository. Invoke it through the host's skill selector or ask it to use `git-worklog`. Follow the current [OpenAI skill setup documentation](https://learn.chatgpt.com/docs/build-skills) for the product you use.

For ChatGPT sessions without native skill installation, attach `git-worklog-chat.txt` and explicitly ask ChatGPT to follow it. Use the manual loading method below.

### Gemini

For Gemini CLI, run this from the directory containing the package:

```sh
gemini skills install ./git-worklog
```

You can also place the folder at `~/.gemini/skills/git-worklog/` or `.gemini/skills/git-worklog/`. See the [Gemini CLI Agent Skills documentation](https://geminicli.com/docs/cli/skills/).

For a Gemini Gem, add `git-worklog-chat.txt` under Knowledge and put the loading instruction below in the Gem's Instructions field. The text file includes the entry point, every reference, and Humanizer. See Google's [Gem instructions and file guidance](https://support.google.com/gemini/answer/15235603?hl=en).

## Load the text bundle

For Claude, ChatGPT, or Gemini sessions that use instructions and file uploads, attach `git-worklog-chat.txt` and use the loading instruction below. Each section is labeled with its original filename, so the host can find references without folder access. This method loads the workflow as instructions; native skill discovery depends on the product surface.

Use this instruction to identify the package:

```text
Follow the SKILL.md section in the attached git-worklog-chat.txt bundle.
Read its labeled reference sections when their workflow steps apply.
Apply the bundled humanizer.md in embedded mode to all five prose fields
before writing any report rows. Always ask me to supply or confirm the date
range and author before reading history. Offer Desktop and the working folder
as defaults for the optional output location and project scope.
```

The host also needs repository access or uploaded/pasted Git history and patches. File generation depends on its execution tools. When it cannot create an Excel workbook, the skill returns CSV or a short table.

## Use

```text
Use git-worklog to create a report from 2026-08-01 to 2026-08-22.
Repository: ../api
Project: PMB
Author: developer@example.com
Output: ./worklog_draft.xlsx
```

The skill also accepts `/git-worklog` option syntax as described in [usage.md](references/usage.md). That syntax is interpreted by the assistant; the package does not provide a command-line executable.

Every report run starts with a question confirming the date range and author. Both are required, including when they were supplied in options. The same question offers an output location and project scope, with Desktop and the working folder as defaults. After the user answers for that run, the assistant proceeds with the confirmed scope.

## Report behavior

The report supports multiple repositories, a required author filter, optional branch filtering, and manual Type classification. It uses one row per commit unless a diff contains separable work. Completion Date and Proof stay blank. Desktop is the default destination when accessible; sandbox sessions return a download, and text-only sessions return importable data.

When several projects are included, each Task starts with its resolved project context, such as `PMB Admin -` or `PMB Client -`. Context comes from the user's mapping or the commit and diff evidence. The assistant asks when the mapping is ambiguous. The Project column retains the source repository's assigned label.

After analyzing a diff, the assistant drafts the five prose fields, applies the bundled Humanizer, and checks the wording against the patch before exporting. Humanizer uses embedded mode, so cells contain only the final Indonesian text. Its [full instructions](references/humanizer.md) and [MIT license](references/humanizer.LICENSE) are included.

Review the draft before submitting it, especially Type and Man/Hour. Commit-derived hours are estimates of effort.
