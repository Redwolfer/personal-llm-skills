# Type classification

Assign one Type to each row based on the diff. Keep these values exactly as written because they belong to the report's fixed vocabulary.

| Type | Use for |
|---|---|
| Operasional | Routine configuration, small data updates, deployments, contact-number changes, or banner updates. |
| Troubleshoot | Reactive bug or incident work, including production issues. |
| Inovasi/Research | Exploration, prototypes, or research that has not produced a shipped feature. |
| Customize Modul / Fitur / Bug Fix | Changes or fixes to an existing module or feature. |
| Penambahan Modul / Fitur | A new module or feature. |
| Permohonan Baru | Work arising from a new formal request or ticket. |
| QA | Testing, verification, or quality checks. |
| Support | Assistance to users or teams, including support outside development. |
| UI/UX | Visual design or interaction changes. |
| Coordination | Coordination or meeting work that is actually represented in a commit. |

When the user selects manual classification or passes `--manual-type`, leave Type blank. For a split commit, classify each row separately.
