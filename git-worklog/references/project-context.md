# Project context and Task prefixes

The default project location is the current working folder. It may contain one repository or several. Honor the project scope confirmed in [inputs-and-history.md](inputs-and-history.md).

Keep the source repository and its Project label attached to each row. Use supplied labels when available and repository folder basenames as the fallback. Do not assume that every repository belongs to PMB.

## Resolve the context

When the report covers multiple projects, identify the project or application represented by each row. Use the user's mapping first. Otherwise, inspect commit subjects, changed paths, module names, and the actual diff to establish the context. A repository name such as `frontend-jquery` alone does not establish whether a change belongs to PMB Admin or PMB Client.

Use a consistent label for each established context throughout the report. If a meaningful label remains ambiguous, ask the user to map the repository or module to a label before finalizing its rows. Offer the repository basename as a fallback. Keep the Project column's repository mapping; the Task prefix adds the row's application context.

## Format Task

For a report covering multiple projects, prefix every Task with the row's resolved context and a space-hyphen-space separator:

```text
<project context> - <task summary>
```

For example, changes in `frontend-jquery` may use `PMB Admin -` for administrator work and `PMB Client -` for applicant-facing work when the user's mapping or Git evidence supports those labels. Treat them as examples; choose labels that match the projects in this run.

The summary after the prefix stays in Bahasa Indonesia. Apply the prefix to every split row. If one commit spans separately reportable contexts, split it according to [diff-analysis.md](diff-analysis.md) and assign each row its own context. A cohesive change shared across contexts needs a clear shared label or a user-supplied mapping.

Preserve the context label while applying [Humanizer](humanizer.md). Do not repeat the prefix twice or use an internal directory name when a confirmed application label is available. Single-project reports may use unprefixed Task titles unless the user requests a prefix.
