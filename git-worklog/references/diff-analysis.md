# Analyze each diff

Read the changed files and patch body before writing a row. Use the commit subject as context. A subject such as "fix bug" cannot establish which behavior changed.

Write the report's prose fields in Bahasa Indonesia. Keep file paths, functions, classes, tables, columns, and variables in their original form.

## Write precise summaries

Use SMART as an editing discipline:

- Specific: name the affected behavior and the relevant file, function, or module.
- Measurable: include counts or other verifiable details when the diff supports them.
- Achievable and actionable: describe work completed in this commit.
- Relevant: explain which feature or workflow the change serves.
- Time-bound: use the commit's date and week, and describe the result at that point.

Keep these qualities within short sentences. For a large change that serves one purpose, choose the two or three facts that best explain it.

| Field | What to write |
|---|---|
| Task | A short title that a manager can understand. Paraphrase the subject using the actual change. In reports covering multiple projects, add the context prefix from [project-context.md](project-context.md). |
| Details/Objective | What changed, why it was needed, and which feature it serves. Name relevant files or functions when useful. |
| Issue | The prior problem or missing behavior established by the diff. Use `N/A` only when no preceding issue applies, such as a new module. |
| Action Plan | Concrete actions completed in the commit. Include verifiable details where available. |
| Result | The outcome supported by the patch at this commit. Describe behavior without claiming unmeasured impact. |

If the patch is empty or unreadable, including a binary-only change or submodule update, explain that limitation in Details/Objective. Do not fill the gap with an assumed implementation.

## Decide how many rows to write

Use one row for a cohesive change. A feature spread across many files or a large refactor can still be one task.

Split a commit when it contains independently reportable work. Relevant signals include unrelated fixes or features, separate modules with different purposes, different Type categories, or subchanges that belong in different effort brackets.

Give each split row its own Task, Details/Objective, Issue, Action Plan, Result, Type, and Man/Hour. Keep the same Project and Request Date across those rows. Leave Completion Date and Proof blank.

If the distinction remains unclear, use one row and briefly disclose that judgment to the user.

After drafting the summaries, apply the bundled [Humanizer skill](humanizer.md) in embedded mode and follow [writing-style.md](writing-style.md). This step is required for Task, Details/Objective, Issue, Action Plan, and Result in every row, including split rows. Compare the edited text with the diff, then write only the final wording to the report. Use [type-classification.md](type-classification.md) and [effort-estimation.md](effort-estimation.md) for each row's remaining values.
