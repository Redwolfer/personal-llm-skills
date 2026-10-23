# Council

Compare a question through four distinct perspectives after researching the evidence. QUICK uses one round; DEBATE uses three rounds and a final synthesis. Both return tables in natural Indonesian Gen Z chat style.

Skill instructions are written in English. Every original prose cell passes the bundled Humanizer, the Indonesian voice guide, and a final evidence check. The package includes Humanizer 3.1.0 and its [MIT license](references/humanizer.LICENSE), so council works without a separate Humanizer installation.

## Install

From the collection's root folder on Windows:

```powershell
.\install.ps1 -Skills council -Providers all -NonInteractive
```

Choose `claude`, `chatgpt`, or `gemini` instead of `all` to target one detected client. Multiple values can be separated by commas. The installer copies the complete skill folder. It does not sign in or register skills in web accounts.

| Provider | Personal skill folder | Setup reference |
|---|---|---|
| Claude Code | `~/.claude/skills/council/` | [Claude Code skills](https://code.claude.com/docs/en/skills) |
| ChatGPT / Codex local skills | `~/.agents/skills/council/` | [OpenAI skill setup](https://learn.chatgpt.com/docs/build-skills) |
| Gemini CLI | `~/.gemini/skills/council/` | [Gemini CLI skills](https://geminicli.com/docs/cli/skills/) |

Keep the complete folder when copying manually. Gemini CLI also recognizes `.agents/skills`, and the collection installer checks for a conflicting shared copy. Restart the client or reload its skill list after installation.

For a chat that accepts uploaded text, attach `dist/council-chat.txt` from the collection and ask it to follow the `SKILL.md` section. The labeled sections include every workflow and the bundled Humanizer. Use `dist/council.zip` where the product supports native skill uploads. Account-level skill setup depends on the product; copying local files does not configure a web account.

## Use

```text
Use council in QUICK mode to compare these two options against my budget.
```

```text
Use council in DEBATE mode to review this proposal. Check official sources,
Reddit, X/Twitter, and relevant forums. Keep the result in Indonesian Gen Z style.
```

Results default to Indonesian, even when the request is in English. Technical terms and exact quotations keep their meaning. An explicit request can change the language, tone, or length.

## Research and execution

The skill attempts primary-source, Reddit, and X/Twitter searches for researchable topics, then adds other relevant websites. It distinguishes community anecdotes from verified facts and checks original pages before citing them. Inaccessible sites, missing results, and unverified claims stay visible in the research table.

Independent reviewers run only when the session provides and permits separate agent calls. Other sessions use a disclosed simulation with the same perspectives and rounds. A session without browsing states that no live research was performed and uses supplied evidence or clearly marked unverified knowledge. Installing the skill does not add tools, grant permissions, or call other providers automatically.

## Files

- [SKILL.md](SKILL.md): entry point, workflow routing, capability handling, and required output pipeline.
- [Research.md](Research.md): source diversity, verification, citations, and access limitations.
- [CouncilMembers.md](CouncilMembers.md) and [RoundStructure.md](RoundStructure.md): member briefs and round boundaries.
- [OutputFormat.md](OutputFormat.md): Indonesian table schemas and detail requirements.
- [Humanize.md](Humanize.md) and [GenZVoice.md](GenZVoice.md): Humanizer integration and Indonesian chat style.
- [Workflows/Quick.md](Workflows/Quick.md) and [Workflows/Debate.md](Workflows/Debate.md): execution steps.
- [references/humanizer.md](references/humanizer.md) and [references/humanizer.LICENSE](references/humanizer.LICENSE): complete Humanizer instructions and attribution.
- `agents/openai.yaml`: display metadata for OpenAI-compatible hosts.
