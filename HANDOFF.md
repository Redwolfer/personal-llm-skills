# Project handoff

Updated: 2026-10-24 (Asia/Bangkok).
Last contributor: ChatGPT.

## Current status

The collection contains council, git-worklog, and humanizer, with ZIP and text distributions for each. The installer supports Claude, ChatGPT/Codex, and Gemini.

Humanizer is now a standalone skill in both its source folder and dist/humanizer.zip. Claude and Cursor plugin manifests have been removed. The Humanizer prompt, version 3.1.0, MIT license, and OpenAI display metadata are unchanged. Installation documentation and validation now cover the standalone package.

Council retains its English instructions, Indonesian Gen Z output, complete Humanizer bundle, and research across primary sources, Reddit, X/Twitter, and other relevant websites. QUICK and DEBATE behavior is unchanged.

## Active work

No active file reservations or delegated tasks. The Claude upload packaging correction is complete and verified. The user authorized a direct commit and push on master using existing Git credentials. Actual upload in the user's Claude account has not been repeated.

## Latest files

- [humanizer/](humanizer/): removed .claude-plugin/plugin.json, .claude-plugin/marketplace.json, and .cursor-plugin/plugin.json.
- [humanizer/README.md](humanizer/README.md): installation for the three providers and instructions to upload the collection's rebuilt skill ZIP.
- [humanizer/AGENTS.md](humanizer/AGENTS.md), [humanizer/CHANGELOG.md](humanizer/CHANGELOG.md), and [humanizer/.github/workflows/validate.yml](humanizer/.github/workflows/validate.yml): maintenance guidance, packaging note, and removal of plugin validation.
- [humanizer/scripts/validate-package.py](humanizer/scripts/validate-package.py): reject plugin metadata while preserving prompt, version, pattern, and documentation checks.
- [dist/humanizer.zip](dist/humanizer.zip) and [dist/humanizer-chat.txt](dist/humanizer-chat.txt): rebuilt standalone distributions.
- [tests/dist_tests.py](tests/dist_tests.py): regression checks for forbidden plugin manifests, archive integrity, source matching, text sections, and validation after extraction.
- [tests/installer.tests.ps1](tests/installer.tests.ps1): assert that Humanizer installs without plugin metadata for each provider.
- [AGENTS.md](AGENTS.md) and [README.md](README.md): require standalone skill packaging and distribution checks.
- [.gitignore](.gitignore): ignore Python test caches.

## Distribution status

Humanizer's ZIP contains all 11 current source files under one humanizer/ root, with forward slash paths and one SKILL.md. It contains no Claude or Cursor plugin metadata. The text bundle has updated upload guidance and exact SKILL.md and LICENSE sections, encoded as UTF-8 without a BOM.

The Humanizer prompt and license, Git worklog, Council, and their distribution files are unchanged. Humanizer's original upstream Git metadata remains preserved locally at .git/upstream-repositories/humanizer.git and is excluded from all packages.

## Verification

- Six distribution tests passed across all three skills. They check ZIP contents against source, reject plugin and Git metadata, and compare labeled text sections with required resources.
- The new archive check rejected the previous Humanizer ZIP before rebuilding, reproducing the reported plugin-manifest problem.
- The Humanizer validator passed both in the source folder and after extracting the corrected ZIP into a temporary directory.
- Nineteen installer tests passed using temporary profiles, including Humanizer installation without plugin metadata for all three simulated providers.
- Documentation links and staged Git whitespace checks passed. Git confirmed the Humanizer prompt and license and all Git worklog and Council files were unchanged.

The actual machine detects Claude Code and ChatGPT/Codex for local installation. Gemini desktop is detected, but Gemini CLI is absent. No real client profiles or account-level skills were modified.
