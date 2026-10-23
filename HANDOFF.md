# Project handoff

Updated: 2026-10-24 (Asia/Bangkok).
Last contributor: ChatGPT.

## Current status

The collection contains council, git-worklog, and humanizer. All three now have dedicated Gemini web exports alongside their canonical ZIP and text bundles.

Upload dist/gemini-web/<skill-name>/SKILL.md through Gemini web's file picker. Each Markdown file contains the original frontmatter, runtime instructions, all references, and the applicable MIT license. Local reference links target embedded sections. The optional dist/<skill-name>-gemini-web.zip contains only SKILL.md at its archive root.

The user's Gemini web uploader rejected the previous folder and ZIP with an unsupported-file-type error. The canonical packages include provider metadata and license files with uncommon or missing extensions. The Markdown-only exports avoid uploading those files separately. Google's documentation supports SKILL.md, folder, and ZIP uploads; the screenshot's picker advertises a narrower set of file types. The exact rejected source file was not identified by Gemini.

Humanizer's prompt and license remain unchanged. Council keeps English instructions, Indonesian Gen Z results, the complete Humanizer workflow, source diversity, and capability disclosures. Git worklog keeps its required date-and-author confirmation and fixed report schema.

## Active work

No active file reservations or delegated tasks. Gemini web exports, documentation, and validation are complete. No account-level uploads or client profile changes were performed.

## Latest files

- [scripts/build_gemini_web.py](scripts/build_gemini_web.py): compile current chat bundles into self-contained Markdown; convert relative links to embedded anchors; build flat web ZIPs; verify with --check.
- [tests/gemini_web_tests.py](tests/gemini_web_tests.py): metadata, reference resolution, factual text and license retention, stale resources, unexpected export files, and current collection exports.
- [README.md](README.md), [AGENTS.md](AGENTS.md), and [GEMINI.md](GEMINI.md): Gemini web upload paths, build commands, and maintenance rules.
- The three skill READMEs: provider-specific upload instructions. Humanizer's changelog records the packaging addition.
- [dist/gemini-web/humanizer/SKILL.md](dist/gemini-web/humanizer/SKILL.md), [dist/gemini-web/git-worklog/SKILL.md](dist/gemini-web/git-worklog/SKILL.md), and [dist/gemini-web/council/SKILL.md](dist/gemini-web/council/SKILL.md): direct file uploads.
- [dist/humanizer-gemini-web.zip](dist/humanizer-gemini-web.zip), [dist/git-worklog-gemini-web.zip](dist/git-worklog-gemini-web.zip), and [dist/council-gemini-web.zip](dist/council-gemini-web.zip): optional web ZIP uploads.

## Distribution status

Canonical ZIPs were rebuilt after changing the skill READMEs. Council's text bundle was refreshed because it includes its README. Humanizer and Git worklog text sections remain unchanged because their included runtime files did not change.

Run python scripts/build_gemini_web.py after updating the canonical text bundles. Use --check to compare current exports without writing files. Export folders contain only SKILL.md; do not add metadata, separate license files, or cached files to them. Select one skill folder at a time, not the parent gemini-web folder.

The web export does not install scripts, grant browsing, or create independent agents. Council and Git worklog retain their existing behavior when the host lacks those capabilities. Humanizer's original Git metadata remains preserved at .git/upstream-repositories/humanizer.git.

## Verification

- Eleven Python distribution and Gemini web export tests passed using isolated fixtures.
- The web builder's --check passed for all three skills. Each folder has one Markdown file; each corresponding ZIP has only a root SKILL.md with identical bytes.
- Canonical archives and text sections match their sources. The Humanizer validator passed.
- Documentation links and embedded reference anchors passed. Runtime source instructions, Humanizer's prompt and license, Council research/style rules, and Git worklog references were unchanged.
- Installer code was unchanged; the nineteen installer checks passed in the preceding task and were not repeated for this packaging update.

Successful upload into the user's Gemini account has not been verified. The generated files are between 33 KB and 66 KB, below Google's documented total upload size limit.
