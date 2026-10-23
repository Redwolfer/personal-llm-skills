"""Check standalone skill archives and their labeled text bundles."""

from pathlib import Path, PurePosixPath
import re
import subprocess
import sys
import tempfile
import unittest
from zipfile import ZipFile


ROOT = Path(__file__).resolve().parents[1]
PLUGIN_FOLDERS = {".claude-plugin", ".cursor-plugin"}


def check_standalone_members(names: list[str], skill: str) -> None:
    if len(names) != len(set(names)):
        raise ValueError("Duplicate ZIP entries")
    for name in names:
        path = PurePosixPath(name)
        if "\\" in name or path.is_absolute() or ".." in path.parts:
            raise ValueError(f"Invalid ZIP path: {name}")
        if not path.parts or path.parts[0] != skill:
            raise ValueError(f"Wrong skill root: {name}")
        if any(part.lower() in PLUGIN_FOLDERS for part in path.parts):
            raise ValueError(f"Plugin metadata is not allowed in a skill ZIP: {name}")
        if ".git" in path.parts:
            raise ValueError(f"Git metadata is not allowed: {name}")
    if [name for name in names if name.endswith("/SKILL.md")] != [f"{skill}/SKILL.md"]:
        raise ValueError("A skill ZIP must contain one root SKILL.md")


class DistributionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        candidates = list(ROOT.iterdir())
        if (ROOT / "skills").is_dir():
            candidates.extend((ROOT / "skills").iterdir())
        cls.skills = sorted(path for path in candidates if (path / "SKILL.md").is_file())

    def test_each_skill_has_both_distributions(self):
        self.assertTrue(self.skills)
        for source in self.skills:
            for suffix in (".zip", "-chat.txt"):
                with self.subTest(skill=source.name, suffix=suffix):
                    self.assertTrue((ROOT / "dist" / (source.name + suffix)).is_file())

    def test_skill_zips_have_no_plugin_or_git_metadata(self):
        for source in self.skills:
            with self.subTest(skill=source.name), ZipFile(ROOT / "dist" / f"{source.name}.zip") as archive:
                check_standalone_members(archive.namelist(), source.name)
                self.assertIsNone(archive.testzip())

    def test_zip_payloads_match_complete_skill_source(self):
        for source in self.skills:
            with self.subTest(skill=source.name), ZipFile(ROOT / "dist" / f"{source.name}.zip") as archive:
                expected = {
                    f"{source.name}/{path.relative_to(source).as_posix()}": path
                    for path in source.rglob("*")
                    if path.is_file() and not any(
                        part in {".git", "__pycache__", "dist"}
                        for part in path.relative_to(source).parts
                    )
                }
                self.assertEqual(set(archive.namelist()), set(expected))
                for name, path in expected.items():
                    self.assertEqual(archive.read(name), path.read_bytes(), name)

    def test_text_sections_preserve_source_and_required_resources(self):
        for source in self.skills:
            with self.subTest(skill=source.name):
                raw = (ROOT / "dist" / f"{source.name}-chat.txt").read_bytes()
                self.assertFalse(raw.startswith(b"\xef\xbb\xbf"))
                text = raw.decode("utf-8").replace("\r\n", "\n")
                sections = re.findall(
                    r"(?ms)^===== BEGIN FILE: (.+?) =====\n\n(.*?)^===== END FILE: \1 =====$", text
                )
                names = [name for name, _ in sections]
                self.assertEqual(len(names), len(set(names)))
                required = {"SKILL.md"}
                required.update(path.name for path in source.glob("LICENSE*") if path.is_file())
                if (source / "references").is_dir():
                    required.update(path.relative_to(source).as_posix()
                                    for path in (source / "references").rglob("*") if path.is_file())
                required.update(path.name for path in source.glob("*.md")
                                if path.name not in {"README.md", "AGENTS.md", "CHANGELOG.md"})
                if (source / "Workflows").is_dir():
                    required.update(path.relative_to(source).as_posix()
                                    for path in (source / "Workflows").rglob("*.md"))
                self.assertTrue(required.issubset(names), required - set(names))
                for name, body in sections:
                    relative = PurePosixPath(name)
                    self.assertFalse(relative.is_absolute() or ".." in relative.parts)
                    self.assertFalse(any(part.lower() in PLUGIN_FOLDERS for part in relative.parts))
                    original = (source / name).read_text(encoding="utf-8")
                    self.assertEqual(body.rstrip("\n"), original.rstrip("\n"), name)

    def test_humanizer_validator_runs_from_extracted_skill(self):
        with tempfile.TemporaryDirectory(prefix="humanizer-package-check-") as temporary:
            with ZipFile(ROOT / "dist" / "humanizer.zip") as archive:
                check_standalone_members(archive.namelist(), "humanizer")
                archive.extractall(temporary)
            validator = Path(temporary) / "humanizer" / "scripts" / "validate-package.py"
            result = subprocess.run([sys.executable, str(validator)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_rejects_the_reported_claude_upload_failure(self):
        with tempfile.TemporaryDirectory(prefix="skill-manifest-regression-") as temporary:
            archive_path = Path(temporary) / "humanizer.zip"
            with ZipFile(archive_path, "w") as archive:
                archive.writestr("humanizer/SKILL.md", "---\nname: humanizer\n---\n")
                archive.writestr("humanizer/.claude-plugin/plugin.json", '{"name":"humanizer"}')
            with ZipFile(archive_path) as archive:
                with self.assertRaisesRegex(ValueError, "Plugin metadata"):
                    check_standalone_members(archive.namelist(), "humanizer")


if __name__ == "__main__":
    unittest.main()
