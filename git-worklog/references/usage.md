# Usage

Accept a request in ordinary language, for example:

> Create a work log from 2026-08-01 to 2026-08-22 for the repository at `../api`, project PMB, filtered to `developer@example.com`.

The same options can be written in command form:

```text
/git-worklog --from <YYYY-MM-DD> --to <YYYY-MM-DD> --author <name-or-email> [options]
```

Treat this form as instructions to the assistant. A host may expose a matching slash command, but the package does not install a shell executable. In other hosts, invoke the skill by its name or make the request in ordinary language.

## Options

| Option | Alias | Meaning | Default |
|---|---|---|---|
| `--from <date>` | `--start` | Start date, `YYYY-MM-DD` | Required |
| `--to <date>` | `--end` | End date, `YYYY-MM-DD` | Required |
| `--repo <paths>` | | Project folders or repository paths, separated by commas | Current working folder, including its selected repositories |
| `--project <names>` | | Project labels, paired with repositories in order | Repository folder basenames, refined using the confirmed project context |
| `--author <name\|email>` | `--me` | Include commits from the specified author | Required; no all-author default |
| `--branch <name>` | | Read one branch | All branches |
| `--manual-type` | | Leave Type blank for the user | Classify automatically |
| `--include-merges` | | Include merge commits with no unique work | Skip those merges |
| `--out <path>` | `--output` | Output filename or path | Desktop when accessible; otherwise a session download |

Pair project names with repository paths one to one. If a supplied list has fewer names than repositories, use each remaining repository folder's basename. Users may give several repositories the same Project label when they belong to one project. For project contexts and Task prefixes, follow [project-context.md](project-context.md).

`--me` accepts the same author value as `--author`. If the user says "my commits" without identifying the author, ask for the name or email. Do not collect unfiltered history while waiting.

Before each report run, ask the user to supply or confirm the dates and author, and offer the output location and project scope with their defaults. Options prefill this question; they do not bypass it. Wait for the answer before reading commits or analyzing supplied history. An answer to this question applies to the current run.

The default filename is `worklog_<project>_<from>_<to>.xlsx`. See [delivery.md](delivery.md) for combined project names and text output.

## Examples

```text
/git-worklog --from 2026-08-01 --to 2026-08-22 --author developer@example.com --repo . --project PMB
```

```text
/git-worklog --from 2026-08-01 --to 2026-08-15 --repo ../api,../web,../mobile --project PMB,PMB,Mobile --author developer@example.com
```

```text
/git-worklog --from 2026-08-01 --to 2026-08-22 --author developer@example.com --manual-type --out ./worklog_draft.xlsx
```

For `/git-worklog -h` or `/git-worklog --help`, show the syntax, options, defaults, and two or three examples. Stop after displaying help.

For a request without options, ask for the parameters using [inputs-and-history.md](inputs-and-history.md). Do not require the user to rewrite their request as a command.
