# Spreadsheet output

## Column layout

Use this order for the workbook and every text fallback:

```text
Type | Project | Request Date | Task | Details/Objective | Issue | Action Plan | Completion Date | Result | Man/Hour | Proof
```

| Column | Value |
|---|---|
| Type | The fixed classification value, or blank in manual mode. |
| Project | The label assigned to the source repository. |
| Request Date | The commit's author date, displayed as `DD/MM/YYYY`. |
| Task | A short title in Bahasa Indonesia, prefixed with the resolved project context for reports covering multiple projects. See [project-context.md](project-context.md). |
| Details/Objective | The change and its purpose. |
| Issue | The prior problem or missing behavior, or `N/A` when applicable. |
| Action Plan | Actions completed in the commit. |
| Completion Date | Blank for the user to fill in. |
| Result | The outcome supported by the diff. |
| Man/Hour | A numeric value from [effort-estimation.md](effort-estimation.md). |
| Proof | Blank for the user's screenshot, ticket, or other evidence. |

Keep commit hashes and generated links out of Proof.

## Check the prose before export

Complete the bundled [Humanizer skill](humanizer.md) pass and the report rules in [writing-style.md](writing-style.md) for Task, Details/Objective, Issue, Action Plan, and Result in every row. Confirm that the final wording keeps the diff's facts and contains no drafts or editing notes. Apply this check to both Excel and text output before generating the deliverable.

## Build an Excel workbook

Use Python and `openpyxl` when available. Apply any spreadsheet conventions supplied by the host that fit this plain data table.

- Use a readable font such as Arial and a bold header row.
- Set `ws.freeze_panes = "A2"`.
- Set suitable column widths. Give Details/Objective, Issue, Action Plan, and Result more space, with `wrap_text=True`.
- Insert the week dividers described in [calendar-weeks.md](calendar-weeks.md), merged across all 11 columns with bold text and a light fill.
- Set `ws.auto_filter.ref = ws.dimensions`, or the exact header-to-last-row range, so filter controls appear on the headers. Include week-divider rows in that range.
- Store dates as dates where possible and use the display format `DD/MM/YYYY`. Store Man/Hour as numbers.

## Text fallback

When the host cannot create an `.xlsx` file, return CSV in a fenced block or a Markdown table for a short report. Keep the column order, row content, and week groups.

A CSV week divider occupies one field followed by ten empty fields:

```csv
--- Week of <date> ---,,,,,,,,,,
```

Quote CSV fields that contain commas, double quotes, or line breaks, and double any embedded quotes. Leave Completion Date and Proof empty.

Explain that the user can import the data into Excel or Google Sheets. Plain text does not preserve freeze panes, filters, merged cells, or styling. Follow [delivery.md](delivery.md) when presenting the result.
