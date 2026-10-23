---
name: git-worklog
description: Create an Excel work log, timesheet, or man-hour report from Git history. Read commit diffs, summarize work in Bahasa Indonesia, estimate effort, and group rows by calendar week. Use when a user asks to turn commits or a Git log into a work report.
---

# Git worklog

Turn a date range of commits into a draft work log. Use the diff to establish what changed, then write a concise account of the work in Bahasa Indonesia.

This package supports Claude, ChatGPT, and Gemini. It includes Humanizer as part of the worklog workflow. Read the bundled [humanizer.md](references/humanizer.md) when editing summaries; the package needs no separate Humanizer installation.

## Required inputs

For every report run, ask the user to supply or confirm the start and end dates and the author's name or email. Both are required. Include optional output location and project scope in that question, defaulting to Desktop and the current working folder. Even when options already contain the values, present them for confirmation and wait for the user's reply before reading history. Once the user answers for this run, proceed without asking again unless the scope changes. See [inputs-and-history.md](references/inputs-and-history.md).

Accept ordinary requests and the options in [usage.md](references/usage.md). For `-h` or `--help`, show the options, defaults, and two or three examples, then stop.

## Environment

Use the tools available in the host application:

| Available capability | How to proceed |
|---|---|
| Git and local repository access | Collect history and diffs from each repository. |
| Uploaded or pasted Git output | Read the supplied log and patches. Request missing patches when needed. |
| Python with `openpyxl` and file output | Create an `.xlsx` workbook. |
| Text output only | Return the same data as CSV or a short Markdown table. |

Check capabilities before relying on them. A model or product name does not establish access to a repository, a Python runtime, or the user's Desktop. The workflow can run from a native skill folder or from instructions and reference files loaded into a chat.

If a referenced file is unavailable, ask the user to provide it before performing the affected step. When uploads flatten folder paths, find references by their filenames.

## Workflow

Read each reference when its step becomes relevant.

1. Confirm inputs and collect history using [inputs-and-history.md](references/inputs-and-history.md). Apply author and branch filters, tag source projects, and sort commits chronologically.
2. Read each diff using [diff-analysis.md](references/diff-analysis.md). Start with one row per commit and split work that is independently reportable.
   For reports covering multiple projects, resolve each row's project context using [project-context.md](references/project-context.md) and prefix its Task with that context, such as `PMB Admin -` or `PMB Client -`.
3. Apply the bundled [Humanizer skill](references/humanizer.md) in embedded mode to every Task, Details/Objective, Issue, Action Plan, and Result draft. Follow [writing-style.md](references/writing-style.md) for the report's Indonesian wording and factual tone. Complete this step before writing those cells to Excel or the text fallback.
4. Assign one Type per row using [type-classification.md](references/type-classification.md). Leave Type blank when the user selects manual classification.
5. Assign Man/Hour using [effort-estimation.md](references/effort-estimation.md). Use the exact ceiling of the applicable bracket.
6. Group rows by ISO calendar week using [calendar-weeks.md](references/calendar-weeks.md).
7. Build the workbook or text fallback using [spreadsheet.md](references/spreadsheet.md).
8. Save and present the draft using [delivery.md](references/delivery.md).

## Report contract

Use these columns in this order:

```text
Type | Project | Request Date | Task | Details/Objective | Issue | Action Plan | Completion Date | Result | Man/Hour | Proof
```

- Write Task, Details/Objective, Issue, Action Plan, and Result in Bahasa Indonesia. Keep code identifiers, column headers, and Type values unchanged.
- Base each statement on the diff. State when a diff is empty or unreadable. Do not invent work, test results, or business impact.
- Humanize all five prose fields, including every row split from a commit. Write only the final wording to the report; keep drafts and editing notes out of the cells.
- In a report covering multiple projects, format Task as `<project context> - <task summary>`. Preserve the context label during the Humanizer pass.
- Use the commit's author date for Request Date, displayed as `DD/MM/YYYY`.
- Leave Completion Date and Proof blank, including when a commit is split across rows.
- Treat Man/Hour as an estimate. Use the fixed values in the effort guide.
- Group weeks from Monday through Sunday, including weeks that cross month or year boundaries.

## Final response

Reply in Bahasa Indonesia. Provide the saved path, download link, or attachment and a brief reminder to review the draft, especially Type and Man/Hour. If only text output is available, include the CSV or table and explain how to import it into Excel or Google Sheets. Keep the response brief and omit greetings, praise, and sign-offs.
