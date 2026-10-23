# Council members

Write four distinct briefs tailored to the question and completed research. These are fictional analytical roles, not real people endorsing the result. Avoid invented employers, years of experience, personal anecdotes, or credentials.

## Choose perspectives

| Starting role | Main concern |
|---|---|
| Builder | What can work and what it takes to implement |
| Skeptic | Unsupported assumptions and concrete failure modes |
| Pragmatist | Cost, delivery, maintenance, and the user's constraints |
| Analyst | Evidence quality, scope, conflicting findings, and missing information |

Adapt these roles when another mix would expose the decision's trade-offs more clearly. Distinct perspectives need not reach opposite conclusions. Preserve agreement when evidence supports it.

## Write each brief

Give the member a stable fictional name and a short brief covering:

- The analytical role and the part of the decision it examines.
- An initial stance tied to relevant research rows or user-provided constraints.
- An assumption it will test in the other arguments.
- A speaking habit that distinguishes its Indonesian chat voice, such as short recommendations or a habit of explaining conditions before choosing.

Keep brief instructions in English. Render the user-facing roster in Indonesian after the same Humanizer and style pipeline as the debate.

## Execute each perspective

When separate agents are available and permitted, give each one its brief, the topic, relevant research rows with source links, round instructions, and the required output pipeline. Use a general agent if it allows the custom brief; do not require a vendor-specific agent type. Respect the host's available slots and finish all members in a round before starting the next.

When separate calls are unavailable, draft each perspective in the current session. Keep the same inputs and round boundaries. Record this as a simulation in the research table. Never claim that the provider's brand name establishes independent reviewers or multiple models.

Treat every response as a draft. Apply [Humanize.md](Humanize.md), then [GenZVoice.md](GenZVoice.md), then the final style and evidence checks before publishing it or passing the completed round to other members.

## Preserve distinct voices

Keep names, roles, and speaking habits consistent across all tables. Each role should reason from its own concerns and respond to actual arguments. If names were hidden, readers should still recognize the different approaches without relying on repeated catchphrases.
