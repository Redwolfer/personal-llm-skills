---
name: council
description: Research a question across the web, then compare distinct perspectives through a one-round QUICK review or three-round DEBATE. Use for council discussions, competing options, trade-offs, or requests for several viewpoints. Return sourced tables in natural Indonesian Gen Z chat style after applying the bundled Humanizer.
---

# Council

Research the question, brief four distinct reviewers, and let them test each other's arguments before recommending a course of action. Support Claude, ChatGPT/Codex, and Gemini through the host's available tools.

Instructions and supporting guides are written in English. User-facing council results default to Bahasa Indonesia in a natural Gen Z chat register. Keep technical terms when translating them would make the answer harder to understand. Follow an explicit request for another language or tone.

## Load the workflow

| Request | Workflow | Result |
|---|---|---|
| Full council discussion, debate, or a decision needing several rounds | [Workflows/Debate.md](Workflows/Debate.md) | Research, roster, three separate round tables, and synthesis |
| Quick council check or a short perspective review | [Workflows/Quick.md](Workflows/Quick.md) | Research, roster, one perspectives table, and summary |

Read [Research.md](Research.md), [CouncilMembers.md](CouncilMembers.md), and [OutputFormat.md](OutputFormat.md) for either workflow. Read [RoundStructure.md](RoundStructure.md) for DEBATE. Before writing user-facing cells, read [Humanize.md](Humanize.md), the complete bundled [Humanizer 3.1.0](references/humanizer.md), and [GenZVoice.md](GenZVoice.md).

## Host capabilities

Choose execution based on the current session's tools and permissions. A provider name does not establish that browsing or independent agents are available.

| Capability | Execution |
|---|---|
| Independent agent calls are available and permitted | Give each reviewer a separate call with its own brief. Run members concurrently when possible, or sequentially within a round. Respect the host's concurrency limit. |
| Independent calls are unavailable | Write each perspective separately in the current session, using the same briefs and completed previous-round tables. State that this is a simulation in one session. |
| Web search or browsing is available | Search before writing briefs or positions. Include primary sources, Reddit, X/Twitter, and other relevant public discussions as described in Research.md. |
| Browsing is unavailable or some sites are inaccessible | State the limitation in the research table. Use supplied material and clearly marked unverified knowledge. Never invent sources or claim to have read inaccessible posts. |

Record the actual execution mode in the research table. Independent reviewer calls are perspectives from the available host; do not claim that Claude, ChatGPT, or Gemini participated unless those providers were actually called. A simulated discussion must never be described as independent verification.

## Required behavior

1. Establish the topic and constraints. Ask for missing context only when it would change the decision.
2. Complete the research step before briefing members. Look across source types, read relevant pages, and preserve disagreements between credible sources.
3. Write four topic-specific briefs with different concerns and speaking habits. Members are fictional analytical roles unless the user supplies actual participants. Do not invent personal credentials or claim firsthand experience.
4. Finish each round before starting the next. Later rounds must respond to named arguments from the completed previous round.
5. Apply the output pipeline below to all original prose, including research summaries, roster descriptions, member responses, limitations, and the final recommendation.
6. Deliver the tables in OutputFormat.md. Give each round its own table. Use Indonesian section headings, with no opening speech, commentary between tables, or closing offer.

## Required output pipeline

For each draft, complete these steps before placing it in a table:

1. Check claims against the research rows or the user's supplied facts. Preserve uncertainty, conditions, dissent, and source links.
2. Apply the complete bundled Humanizer in **embedded mode**, following Humanize.md. Keep only the final wording; do not print drafts, critiques, or editing notes.
3. Apply GenZVoice.md so the result reads like Indonesian chat while keeping each reviewer's distinct voice.
4. Check the styled text again with Humanizer. Remove stock openings, inflated claims, repeated punchlines, and forced slang introduced during styling.
5. Compare the final text with the evidence. Keep names, numbers, units, dates, quotes, URLs, qualifications, and attribution intact. Repair any change of meaning before exporting the cell.

Use the same pipeline for QUICK, DEBATE, simulated execution, independent agents, and sessions without browsing. Never paste an agent's raw response directly into the deliverable. Preserve direct quotations exactly and explain them in Indonesian outside the quote.

## Final review

- Every factual claim has a source, user-provided basis, or an explicit unverified label.
- Research shows which source types were checked, including unavailable Reddit or X/Twitter searches where applicable.
- Reviewers address different concerns, and later rounds engage with actual named points.
- The recommendation explains the strongest evidence and any unresolved disagreement.
- All original prose has passed Humanizer, Indonesian Gen Z styling, and the final evidence check.
- Table schemas, member names, detailed answers, and separate round tables follow OutputFormat.md.

Humanizer is bundled with its [MIT license](references/humanizer.LICENSE). Installing council alone includes the writing workflow; it needs no separately installed Humanizer skill or provider plugin.
