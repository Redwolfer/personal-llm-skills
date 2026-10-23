# Man/Hour estimation

Choose a bracket for each row from the diff's scope, including files touched, lines changed, and architectural weight. Use the bracket's exact ceiling. The commit subject's length provides no basis for an estimate.

| Category | Bracket | Man/Hour | Typical scope | Examples |
|---|---|---|---|---|
| A | Very Small | 0.2 | Data updates, simple queries, configuration, small deployments, support | Production update, banner update, contact-number change, RT/RW fix, small export |
| B | Small | 0.5 | Support, troubleshooting, a small API, minor changes | Insert grades, data query, bug fix, simple API, log backup |
| C | Medium | 0.5 | Small or medium features, QA, enhancements, reports | Excel export, module QA, new API, validation adjustment |
| D | Large | 1 | New modules, frontend or backend work, master data, integration | User page, RPL master data, assessment, OBE, scholarship module |
| E | Extra Large | 1.5 | Large module development, rebuilds, analysis, research | EKTA rebuild, website launch, monitoring and evaluation mapping |
| F | Project / Research | 2 | New systems, research, large projects | New CELLA system, MSAT development |

B and C both use `0.5`. Choose B for reactive support or troubleshooting and C for a small or medium feature, QA, or reporting task.

Estimate split rows separately. Do not copy the full commit's estimate onto every row.

Write numeric cell values: `0.2`, `0.5`, `1`, `1.5`, or `2`. Let Excel apply the local decimal display. The values estimate effort; they do not measure time worked.
