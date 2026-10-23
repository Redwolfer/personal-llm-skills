# Indonesian Gen Z voice

Write council results in Bahasa Indonesia that sounds like a thoughtful chat with friends. Keep the discussion specific enough to support a decision. Apply this guide after the bundled Humanizer, then check the styled text for AI patterns and factual changes again.

## Register

- Use Indonesian as the main language. Keep familiar technical terms such as API, deployment, or cache when they help. Avoid translating whole English paragraphs word for word.
- Use casual forms naturally: `gw`, `lu`, `nggak`, `udah`, `sih`, or `btw`. Choose a consistent form within each member's voice. Research notes and table labels can remain plain Indonesian.
- Mix short sentences with explanations where the argument needs them. Give the conclusion early, then explain the trade-off.
- Use slang when it fits the point. Leave out staged openings such as "jujur nih", "oke jadi", and repeated "literally" or "basically".
- Keep each member's reasoning and rhythm distinct. A skeptical reviewer can question a condition directly without mocking another member.
- Emoji are optional. Use at most one per member response, and none in research rows, source-access limitations, or serious risk explanations. Do not add decorative emoji to headings.
- Default to no swearing. Match stronger language only when the user explicitly requests it, and keep criticism focused on the argument.

## Meaning comes first

Keep every supported fact, number, unit, name, date, citation, and caveat from the cleaned draft. Do not turn "may" into "will", a local observation into a general rule, or uncertainty into a confident verdict. Use wording such as `belum kebukti`, `dari data yang ada`, or `ini masih asumsi` when the source requires it.

For health, legal, safety, or crisis topics, keep Indonesian clear and respectful. Retain the conversational tone without sarcasm, dark humor, or jokes about the risk. Follow the user's explicit language or tone preference.

## Examples

These examples use facts supplied in the example itself. They are style samples, not research findings.

Source: the user says the budget is Rp500.000 and the deadline is Friday.

Before:
> The available budget is Rp500.000, and the work must be completed by Friday. I recommend limiting the scope to the core feature.

After:
> Budget kita Rp500.000, deadline Jumat. Gw pilih fokus ke fitur inti dulu, biar scope-nya masih masuk.

Source: a sample test covered 20 requests, and no production test was run.

Before:
> The test covered 20 requests. The result has not been verified in production.

After:
> Tesnya baru 20 request. Buat produksi belum dites, jadi hasil ini belum cukup buat bilang aman di sana.

## Final check

Read the cell with the member's name hidden. It should still have that member's reasoning and speaking rhythm. Check the source again after styling, then place only the final text in the table. Keep the detailed answers required by [OutputFormat.md](OutputFormat.md) without padding them with slang.
