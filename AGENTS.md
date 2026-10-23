# Project guidance

These instructions apply to the whole `personal-llm-skills` project. Read the relevant skill's `SKILL.md` and references before changing its behavior.

## Required Humanizer use

For every task in this project, read and use the bundled [Humanizer skill](git-worklog/references/humanizer.md). This requirement applies to new skills, maintenance, reviews, documentation, code comments, progress updates, and final responses. Apply its rewrite and fact-check process to prose before finalizing it.

Preserve facts, executable code, commands, identifiers, paths, links, schemas, and numeric values. Use embedded mode for project work so files and deliverables contain the final text. Keep report-specific language and formatting rules in effect.

## Scope and layout

- Support Claude, ChatGPT, and Gemini. Keep provider-specific installation details in the skill README.
- Keep each skill in a folder named after its frontmatter `name`, with `SKILL.md` at the folder root.
- Use relative links for bundled references. Keep required resources inside the skill folder so a copied or uploaded package works on its own.
- Keep the root README as the project index. Use each skill's README for its installation and usage details.
- Keep the standalone skill layout. Add provider plugin manifests only when the user requests them.

## Writing

Write instructions and project documentation in English. Keep Git worklog report prose in Bahasa Indonesia and preserve its fixed column names and Type values.

Humanizer is a bundled dependency. Preserve its attribution, version metadata, and [MIT license](git-worklog/references/humanizer.LICENSE). Do not replace the bundled copy with a path to a locally installed skill. Update the version references together when replacing the snapshot.

## Collaboration across providers

[AGENTS.md](AGENTS.md) is the shared source for project rules. [CLAUDE.md](CLAUDE.md) and [GEMINI.md](GEMINI.md) import it for their respective tools. Keep these entry points thin and update shared rules here.

At the start of a task, read the [project README](README.md) and [HANDOFF.md](HANDOFF.md), then inspect the files relevant to the request. Continue from the current files and recorded status.

When dividing work, agree on the task and file ownership in the active conversation or HANDOFF.md. Work on separate files where possible. Re-read files before saving if another agent may have changed them, and preserve changes outside your assigned work.

Before handing over or stopping after substantive changes, update HANDOFF.md with the completed work, touched files, actual checks, blockers, and next action. Include provider and file ownership for any active tasks. Keep it as a current snapshot and remove stale entries.

For a chat without filesystem access, supply AGENTS.md, HANDOFF.md, the Humanizer reference, and the relevant source files. Return proposed file changes clearly so they can be applied before another agent takes over.

## Git worklog behavior

Preserve these requirements when editing the skill:

- For every report run, ask the user to supply or confirm the date range and author, even when options already contain them. Wait for the reply before reading Git history or analyzing uploaded history. Do not default to all authors.
- Offer Desktop as the default output location and the current working folder as the default project scope. Resolve inaccessible or ambiguous locations with the user.
- Apply the confirmed date and author scope to every repository and to supplied history.
- Read the actual diffs. Keep each summary grounded in the change and disclose unreadable patches.
- In reports covering multiple projects, prefix every Task with its resolved context. Use the user's mapping or Git evidence, ask when ambiguous, and preserve that prefix during Humanizer editing.
- Apply the bundled Humanizer in embedded mode to Task, Details/Objective, Issue, Action Plan, and Result before exporting any row. Include split rows and text fallback output. Only final wording belongs in the deliverable.
- Preserve the 11-column report layout, Type vocabulary, effort bracket values, ISO week grouping, and blank Completion Date and Proof fields. Their source definitions live in the skill references.

The report parameter question applies when generating a worklog. Maintaining or inspecting this project does not require report dates or an author.

## Distribution files

Edit skill sources first. When files inside a skill package change, regenerate its ZIP and text bundle in `dist/`. Root README, AGENTS.md, CLAUDE.md, GEMINI.md, or HANDOFF.md edits alone do not require repackaging.

For the Git worklog ZIP, include the complete `git-worklog/` folder under one top-level directory. Use forward slashes in entry names. Include one discoverable `SKILL.md`, every reference, the skill README, and the Humanizer license. Keep project-level documentation and `dist/` out of that ZIP.

For the text bundle, include `SKILL.md` and every file in `references/`, including the license. Label each section with its original relative path so references can be found without folder access. Preserve the parameter question and embedded Humanizer workflow in the loading instructions.

## Verification

Match checks to the change. For documentation, check local links and Markdown formatting. For skill changes, also check frontmatter, reference reachability, and the behavior affected by the edit.

When rebuilding distribution files, compare the ZIP entries with the source files and compare each labeled text section with its source. Check the single-root archive layout and the bundled Humanizer license.

Report what was actually checked. File validation does not establish successful installation in a provider's account. If a script or validator is unavailable, state the limitation without claiming it passed. Run any new or changed executable helper before handing it over.
