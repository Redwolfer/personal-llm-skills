# Guide for agents

This file explains how to change Humanizer without breaking its package or prompt.

## What this repo contains

Humanizer is an agent skill written in Markdown. `SKILL.md` is the prompt that agents read. The collection builds ZIP and text distributions in its root `dist/` folder.

Keep the skill portable. Do not write instructions that limit it to one or two agent tools.

## Key files

- `SKILL.md` is the source of truth and the repo's only skill file. It contains portable YAML metadata, an account of why AI text sounds the way it does, and numbered patterns grouped in six sections and ordered by strength and frequency.
- `README.md` explains installation, use, and patterns.
- `CHANGELOG.md` holds the release notes, newest first. Old notes keep the pattern numbers their release used.
- `agents/openai.yaml` holds the display name, short description, and default prompt for OpenAI-compatible agents.
- `scripts/validate-package.py` checks package files and shared values.

## Rules for changes

Keep `SKILL.md` and `README.md` in sync.

- **Patterns:** Patterns are numbered from 1 without gaps, strongest and most frequent first. A new tell earns a pattern only when no existing pattern already implies it; prefer folding it into an existing pattern. If you add, remove, or renumber a pattern, update the README tables, the README section title, and every §reference. The validator derives the count from the headings and checks that README pattern names match them.
- **Version:** Keep the same version in `SKILL.md` under `metadata.version` and the first `CHANGELOG.md` heading. Do not add a top-level `version` field to the skill.
- **Compatibility:** Keep the prompt portable across Claude, ChatGPT/Codex, and Gemini. Keep provider plugin manifests out of the skill folder and ZIP; Claude rejects them in skill uploads.
- **Description:** Keep the description focused on rewriting prose while preserving its meaning.
- **Length:** Every word of `SKILL.md` is read on each use. The validator caps it at 5,500 words; a change that adds words should earn them.
- **History:** Add a short `CHANGELOG.md` note for any behavior change or non-obvious fix.
- **Checks:** Run `python3 scripts/validate-package.py` from this folder. From the collection root, run `python -m unittest discover -s tests -p dist_tests.py` to check ZIP and text artifacts. Rebuild both Humanizer distributions after changing package files. Do not use plugin validation for this standalone skill.

## Writing style

Use Plain Language in code comments, prompts, documentation, descriptions, validation messages, and progress reports.

- Lead with the main point.
- Use common words and active voice.
- Keep sentences and paragraphs short.
- Use one term for the same item.
- Use `must` for requirements.
- Use headings, lists, and tables when they help the reader.
- Remove repeated or unnecessary words.
- Limit acronyms and explain technical terms.
- Avoid double negatives.
- Keep exact identifiers, commands, paths, schema fields, quotations, watched phrases, and behavior-bearing examples.
- Keep the full technical meaning.

## Editing the skill

- Keep the YAML metadata valid.
- Treat the prompt below the metadata as the product.
- Prefer a short, clear instruction over another exception or repeated explanation.
