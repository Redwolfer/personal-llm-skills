# Worklog writing style

Edit Task, Details/Objective, Issue, Action Plan, and Result before writing them to the report. Keep the tone neutral and factual. Every claim, identifier, and number must remain traceable to the diff.

Read and apply the bundled [Humanizer skill](humanizer.md), version 3.1.0, in embedded mode. Its complete instructions ship with this package, with the [MIT license](humanizer.LICENSE). No external skill lookup or installation is needed.

For this workflow, return only the final cell text from each rewrite. Keep the report in Bahasa Indonesia, use a factual tone, and leave identifiers, dates, Type values, and Man/Hour unchanged. The report-specific rules in this file govern the use of Humanizer's general writing guidance.

Preserve any confirmed Task prefix such as `PMB Admin -` or `PMB Client -`. Rewrite the summary after the prefix while keeping its project identity intact.

The report stays in Bahasa Indonesia. Apply the patterns below to the Indonesian wording. Keep code identifiers and the fixed report vocabulary unchanged.

## Editing process

1. Read the draft for inflated claims, vague actions, filler, repeated sentence shapes, and chat residue.
2. Rewrite awkward sentences around the actual change. Use direct verbs and enough detail to identify the work.
3. Compare the rewrite with the diff. Restore any lost fact and remove any unsupported addition.
4. Read it once more for natural phrasing. Write only the final text into the cell.

Apply this process to every prose cell, including text fallback output. Before export, confirm that all five fields in every row have passed the rewrite and fact check. Do not put alternative drafts, pattern lists, or remarks about AI into the report.

## Patterns to remove

- Inflated significance, sales language, and vague impact. Replace claims such as "plays a crucial role" or "provides a robust solution" with the behavior the code changes.
- Added purpose clauses that imply unmeasured outcomes. A validation change does not establish better performance or user satisfaction.
- Empty verbs such as "improved" or "enhanced" without a specific change. Identify what was added, removed, or corrected.
- Filler such as "in order to," "it should be noted," and their Indonesian equivalents. Use the shorter wording when it preserves the meaning.
- Forced lists of three, repeated openings, dramatic fragments, and closing sentences that repeat the preceding point.
- Staged contrasts, announcements, or replies to objections the reader has not raised. State the relevant fact directly.
- Passive wording that hides the action. Name the changed component when the diff identifies it.
- Stacked qualifiers. Keep a qualification when the source supports it and the meaning needs it.
- Greetings, praise, offers to continue, sign-offs, and explanations of the assistant's writing process.
- Decorative bold text, headings, or Markdown syntax inside cells.

Use periods, commas, colons, or parentheses to connect prose. Do not put em dashes or en dashes in report prose cells. Preserve punctuation inside code identifiers. Keep technical terms such as `real-time` or `end-to-end` when the change supports them.

Do not add opinions, humor, first-person remarks, or invented details to make a sentence sound human. Preserve accurate technical language and useful uncertainty. A clear factual sentence can stay as written.

Apply the same plain style to the final chat reply. File paths, attachments, import instructions, and the draft-review reminder provide the information the user needs.

These editing patterns follow the humanizer approach to [Wikipedia's signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing).
