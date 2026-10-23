# Inputs and commit history

## Ask for parameters on every run

Before running `git log`, reading patches, or analyzing uploaded history, ask the user to supply or confirm:

- Required: the start and end dates.
- Required: the author's name or email used in Git commits.
- Optional: the Excel output directory or filename. Default to Desktop when accessible.
- Optional: the project folder, selected repositories, and project names. Default to the current working folder.

Always ask this question, including when a request, command options, or earlier instructions supply the values. Prefill supplied values and show the defaults so the user can confirm or change them in one reply. Wait for that reply. Silence or a timeout does not confirm the parameters. After the user answers for this run, do not repeat the question unless the date, author, or project scope changes. Help requests that generate no report do not need this question.

Use the host's question tool when available, or ask in chat. Ask in Bahasa Indonesia and collect the parameters together. The user may leave optional fields empty to accept Desktop and the working folder. If dates or author remain missing, ask for those values and keep history collection blocked. Do not default to all authors, infer an author from the current machine, or reuse an unconfirmed author from another run.

Validate that the start date is no later than the end date. Confirm access to the selected repositories or supplied history. Use automatic Type classification unless the user requests manual classification.

## Resolve the working folder

If project scope was omitted, inspect the current working folder for its Git repository or repositories. Keep discovery within that folder and honor any subset the user selected. If the collection is ambiguous, show the repository choices and ask which to include before reading their history. If the host has no working folder, ask for repository paths or uploaded history.

Use [project-context.md](project-context.md) to retain repository identities and determine Task prefixes when the report covers multiple projects.

When no repository is accessible, ask for a local path the host can reach or uploaded/pasted Git output. Do not invent commits. A commit list supplies metadata; the analysis also needs each commit's patch. Request missing patches or state that the diff cannot be read.

## Collect commits

Run the following once per repository, from that repository's directory:

```bash
git log --all --since="<start> 00:00:00" --until="<end> 23:59:59" \
  --author="<confirmed-author-name-or-email>" \
  --date=iso-strict \
  --pretty=format:"%H%x1f%ad%x1f%an%x1f%s%x1e"
```

Replace placeholders with the requested dates. Adapt line continuation syntax to the shell. Pass arguments with appropriate quoting.

When a branch was requested, replace `--all` with that branch. Always include the confirmed author filter. Apply the same date and author scope checks to supplied history; request author metadata if it is missing.

Split records on `\x1e` and fields on `\x1f`. These separators preserve subjects containing commas, pipes, or quotes. The fields are the commit hash, author date, author name, and subject.

Tag every commit with its source repository and Project before combining results. Sort the combined history in ascending chronological order.

Skip pure merge commits that contain no unique work unless `--include-merges` was requested. Inspect merge parents and changes before deciding whether a merge contains reportable work. Keep merge commits that carry unique changes.

## Read patches

For each included commit, retrieve the file summary and patch:

```bash
git show <hash> --stat -p
```

When the user supplies history, use the corresponding patch output. Continue with [diff-analysis.md](diff-analysis.md).
