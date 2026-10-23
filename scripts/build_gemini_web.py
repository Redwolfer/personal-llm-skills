"""Build self-contained SKILL.md uploads for Gemini web using the chat bundles."""

import argparse
import posixpath
from pathlib import Path
import re
from urllib.parse import unquote, urlsplit
from zipfile import ZIP_DEFLATED, ZipFile


ROOT = Path(__file__).resolve().parents[1]
SECTIONS = re.compile(
    r"(?ms)^===== BEGIN FILE: (.+?) =====\n\n(.*?)^===== END FILE: \1 =====$"
)
LINKS = re.compile(r"(?<!!)\[([^\]\n]+)\]\(([^)\n]+)\)")


def resource_id(name):
    return "resource-" + re.sub(r"[^a-z0-9]+", "-", name.lower()).strip("-")


def load_resources(root, name):
    if not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", name):
        raise ValueError(f"Invalid skill name: {name}")
    source = root / name
    if not (source / "SKILL.md").is_file():
        source = root / "skills" / name
    if not (source / "SKILL.md").is_file():
        raise ValueError(f"Skill source not found: {name}")
    text = (root / "dist" / f"{name}-chat.txt").read_text(encoding="utf-8")
    sections = SECTIONS.findall(text)
    names = [path for path, _ in sections]
    if len(names) != len(set(names)):
        raise ValueError(f"Duplicate sections in {name}'s text bundle")
    resources = {}
    for path, payload in sections:
        # Setup guides and provider metadata are not runtime instructions.
        if path in {"README.md", "AGENTS.md", "CHANGELOG.md"} or path.startswith("agents/"):
            continue
        resolved = (source / path).resolve()
        if not resolved.is_relative_to(source.resolve()):
            raise ValueError(f"Resource escaped the skill folder: {path}")
        original = resolved.read_text(encoding="utf-8").rstrip("\n")
        if payload.rstrip("\n") != original:
            raise ValueError(f"Rebuild the stale text section before exporting: {path}")
        resources[path] = original + "\n"
    if "SKILL.md" not in resources:
        raise ValueError(f"Missing SKILL.md section: {name}")
    identifiers = [resource_id(path) for path in resources]
    if len(identifiers) != len(set(identifiers)):
        raise ValueError(f"Ambiguous resource anchors: {name}")
    return resources


def rewrite_links(text, current, resources):
    def replace(match):
        label, target = match.groups()
        parsed = urlsplit(target)
        if parsed.scheme or parsed.netloc or target.startswith("#"):
            return match.group(0)
        relative = posixpath.normpath(posixpath.join(posixpath.dirname(current), unquote(parsed.path)))
        if relative not in resources:
            raise ValueError(f"Unbundled local link in {current}: {target}")
        return f"[{label}](#{resource_id(relative)})"

    # Keep code examples unchanged while converting actual reference links.
    parts = re.split(r"(?ms)(^```.*?^```[^\n]*\n?)", text)
    return "".join(part if index % 2 else LINKS.sub(replace, part)
                   for index, part in enumerate(parts))


def compile_skill(root, name):
    resources = load_resources(root, name)
    entry = resources["SKILL.md"]
    frontmatter = re.match(r"\A---\n(.*?)\n---\n", entry, re.S)
    declared_name = re.search(r'''(?m)^name:[ \t]*(["']?)([a-z0-9-]+)\1[ \t]*$''', frontmatter[1]) if frontmatter else None
    if not declared_name or declared_name[2] != name:
        raise ValueError(f"Invalid or mismatched skill metadata: {name}")
    notice = (
        "\n## Reference loading for Gemini web\n\n"
        "This file includes the entry point and all runtime references below. "
        "When the instructions name a file, read its bundled section in this document. "
        "Local reference links point to those sections; no separate reference files are needed. "
        "License sections preserve attribution and are not workflow instructions. "
        "Use only the tools available in the current Gemini session.\n\n"
    )
    output = [frontmatter[0], notice]
    output.append(f'<a id="{resource_id("SKILL.md")}"></a>\n\n')
    output.append(rewrite_links(entry[frontmatter.end():], "SKILL.md", resources).rstrip() + "\n")
    for path, payload in resources.items():
        if path == "SKILL.md":
            continue
        output.append(f'\n<a id="{resource_id(path)}"></a>\n\n## Bundled file: {path}\n\n')
        if "license" in Path(path).name.lower():
            output.append("```text\n" + payload.rstrip() + "\n```\n")
        else:
            output.append(rewrite_links(payload, path, resources).rstrip() + "\n")
    return "".join(output).encode("utf-8")


def export_skill(root, name, check=False):
    payload = compile_skill(root, name)
    destination = root / "dist" / "gemini-web" / name
    document = destination / "SKILL.md"
    archive_path = root / "dist" / f"{name}-gemini-web.zip"
    if not check:
        destination.mkdir(parents=True, exist_ok=True)
        if set(path.name for path in destination.iterdir()) - {"SKILL.md"}:
            raise ValueError(f"Remove unrelated files from the Gemini web export: {destination}")
        document.write_bytes(payload)
        with ZipFile(archive_path, "w", compression=ZIP_DEFLATED) as archive:
            archive.writestr("SKILL.md", payload)
    if document.read_bytes() != payload:
        raise ValueError(f"Stale Gemini web export: {name}")
    if {path.name for path in destination.iterdir()} != {"SKILL.md"}:
        raise ValueError(f"Unexpected files in Gemini web export: {name}")
    with ZipFile(archive_path) as archive:
        if archive.namelist() != ["SKILL.md"] or archive.read("SKILL.md") != payload:
            raise ValueError(f"Invalid Gemini web ZIP: {name}")
        if archive.testzip() is not None:
            raise ValueError(f"Corrupt Gemini web ZIP: {name}")
    return document


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("skills", nargs="*", help="Skill names; default: all skills in the collection")
    parser.add_argument("--check", action="store_true", help="Verify exports without writing files")
    args = parser.parse_args()
    names = args.skills
    if not names:
        candidates = list(ROOT.iterdir())
        if (ROOT / "skills").is_dir():
            candidates.extend((ROOT / "skills").iterdir())
        names = sorted(path.name for path in candidates if (path / "SKILL.md").is_file())
    for name in names:
        document = export_skill(ROOT, name, args.check)
        print(f"{'Verified' if args.check else 'Built'} {name}: {document}")


if __name__ == "__main__":
    main()
