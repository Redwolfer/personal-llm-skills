# Project handoff

Updated: 2026-10-24 (Asia/Bangkok).
Last contributor: ChatGPT.

## Current status

The collection contains council, git-worklog, and humanizer. Each has a ZIP and text bundle in dist/. The installer supports the three provider families: Claude, ChatGPT/Codex, and Gemini.

Council instructions are in English. Results default to Indonesian Gen Z chat style. Every original prose cell uses the complete bundled Humanizer 3.1.0 in embedded mode, the Indonesian voice guide, and a final Humanizer and evidence check. This includes research notes, roster descriptions, member responses, limitations, and synthesis.

Both council workflows attempt research across primary sources, Reddit, X/Twitter, and other relevant websites. Findings identify source types and distinguish anecdotes from verified facts. Missing access, no browsing, and simulated execution remain visible in the research table. QUICK uses one round; DEBATE uses three separate round tables.

## Active work

No active file reservations or delegated tasks. Council adaptation, distribution files, and validation are complete. The user authorized a direct commit and push on master using the existing Git credentials.

## Latest files

- [council/SKILL.md](council/SKILL.md): portable entry point, capability-based execution, and mandatory writing pipeline.
- [council/Research.md](council/Research.md): primary sources, Reddit, X/Twitter, other sites, verification, and access limits.
- [council/Humanize.md](council/Humanize.md), [council/GenZVoice.md](council/GenZVoice.md), and [council/OutputFormat.md](council/OutputFormat.md): full Humanizer integration, Indonesian chat style, and table schemas.
- [council/CouncilMembers.md](council/CouncilMembers.md), [council/RoundStructure.md](council/RoundStructure.md), and [council/Workflows/](council/Workflows/): research-grounded briefs and round execution.
- [council/README.md](council/README.md): installation and usage for the three providers.
- [council/references/humanizer.md](council/references/humanizer.md) and [council/references/humanizer.LICENSE](council/references/humanizer.LICENSE): complete upstream Humanizer 3.1.0 and MIT license.
- [council/agents/openai.yaml](council/agents/openai.yaml): generated OpenAI display metadata.
- [tests/installer.tests.ps1](tests/installer.tests.ps1): Council installation and repeat-install checks using isolated profiles for each provider.
- [README.md](README.md): Council index, installer example, and distribution links.
- [dist/council.zip](dist/council.zip) and [dist/council-chat.txt](dist/council-chat.txt): source-matched distribution files.

## Distribution status

Council's ZIP contains all 13 source files under council/ with forward slash paths and one SKILL.md. The text bundle contains all 13 files as labeled sections, including workflows, voice guidance, complete Humanizer, display metadata, and the MIT license. Its loading instructions preserve research, execution disclosure, Humanizer, and Indonesian output requirements. Text is UTF-8 without a BOM.

Council's Humanizer and license match humanizer/SKILL.md and humanizer/LICENSE byte for byte. Existing Git worklog and standalone Humanizer sources and distribution files are unchanged.

Humanizer is tracked as ordinary files. Its original Git metadata remains preserved locally at .git/upstream-repositories/humanizer.git. Do not add it as a Git link or submodule.

## Verification

- Nineteen installer tests passed on Windows PowerShell 5.1. Council's 13 required files matched after installation for each simulated provider, and repeat installation reported unchanged.
- The skill-creator quick validator passed for council. PyYAML was installed only in the task's scratch validation directory; the user's Python environment was not changed.
- All 13 ZIP payloads and 13 labeled text sections match their source bytes. Archive layout, UTF-8 encoding, complete Humanizer, MIT license, and Council Markdown links passed.
- Read-only inventory lists council, git-worklog, and humanizer. A real-machine Council preview passed without writing to client profiles.
- Workflow review covered QUICK and DEBATE, source diversity, blocked sources, absent browsing, simulated reviewers, English instructions, Indonesian output, and the final evidence check after styling.
- Root documentation links and staged Git whitespace checks passed before the requested commit.

The machine detects Claude Code and ChatGPT/Codex for local installation. A Gemini desktop application is detected, but Gemini CLI is absent. Installer tests use simulated provider profiles. No real client installations or live model-output evaluations in the three provider accounts were performed.
