"""Check Markdown-only Gemini web exports and embedded reference loading."""

from pathlib import Path
import sys
import tempfile
import unittest
from zipfile import ZipFile


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
from build_gemini_web import compile_skill, export_skill, load_resources


class GeminiWebTests(unittest.TestCase):
    def fixture(self, temporary):
        root = Path(temporary)
        files = {
            "SKILL.md": "---\nname: 'sample-skill'\ndescription: Compare supplied options.\n---\n\n# Sample\n\nAsk for the author and date range before reading history.\nUse [Quick](Workflows/Quick.md).\n",
            "Workflows/Quick.md": "# Quick\n\nKeep 20 requests and Rp500.000 unchanged. Read [Humanizer](../references/humanizer.md).\n",
            "references/humanizer.md": "# Humanizer\n\nKeep the facts. Use [license](humanizer.LICENSE).\n",
            "references/humanizer.LICENSE": "MIT License\n\nCopyright (c) Fixture Author\n",
        }
        sections = ["Sample upload instructions.\n\n"]
        for name, text in files.items():
            destination = root / "sample-skill" / name
            destination.parent.mkdir(parents=True, exist_ok=True)
            destination.write_text(text, encoding="utf-8")
            sections.append(f"===== BEGIN FILE: {name} =====\n\n{text}\n\n===== END FILE: {name} =====\n\n")
        (root / "dist").mkdir()
        (root / "dist/sample-skill-chat.txt").write_text("".join(sections), encoding="utf-8")
        return root

    def test_export_is_one_markdown_file_with_root_metadata(self):
        with tempfile.TemporaryDirectory(prefix="gemini-web-export-") as temporary:
            root = self.fixture(temporary)
            document = export_skill(root, "sample-skill")
            text = document.read_text(encoding="utf-8")
            self.assertTrue(text.startswith("---\nname: 'sample-skill'\n"))
            self.assertIn("Ask for the author and date range before reading history.", text)
            self.assertIn("20 requests and Rp500.000", text)
            self.assertIn("MIT License\n\nCopyright (c) Fixture Author", text)
            self.assertEqual(list(document.parent.iterdir()), [document])
            with ZipFile(root / "dist/sample-skill-gemini-web.zip") as archive:
                self.assertEqual(archive.namelist(), ["SKILL.md"])
                self.assertEqual(archive.read("SKILL.md"), document.read_bytes())

    def test_nested_links_point_to_embedded_sections(self):
        with tempfile.TemporaryDirectory(prefix="gemini-web-links-") as temporary:
            root = self.fixture(temporary)
            text = compile_skill(root, "sample-skill").decode("utf-8")
            self.assertIn("[Quick](#resource-workflows-quick-md)", text)
            self.assertIn("[Humanizer](#resource-references-humanizer-md)", text)
            self.assertIn("[license](#resource-references-humanizer-license)", text)
            self.assertIn('id="resource-references-humanizer-license"', text)

    def test_source_changes_require_rebuilding_the_text_bundle(self):
        with tempfile.TemporaryDirectory(prefix="gemini-web-stale-") as temporary:
            root = self.fixture(temporary)
            export_skill(root, "sample-skill")
            (root / "sample-skill/Workflows/Quick.md").write_text("Changed scope.\n", encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "stale text section"):
                export_skill(root, "sample-skill", check=True)

    def test_unrelated_files_are_rejected_before_upload(self):
        with tempfile.TemporaryDirectory(prefix="gemini-web-extra-") as temporary:
            root = self.fixture(temporary)
            document = export_skill(root, "sample-skill")
            (document.parent / "LICENSE").write_text("Unsupported extension.\n", encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "Unexpected files"):
                export_skill(root, "sample-skill", check=True)

    def test_actual_collection_exports_are_current(self):
        sources = [path for path in ROOT.iterdir() if (path / "SKILL.md").is_file()]
        self.assertTrue(sources)
        for source in sources:
            with self.subTest(skill=source.name):
                document = export_skill(ROOT, source.name, check=True)
                text = document.read_text(encoding="utf-8")
                self.assertFalse(document.read_bytes().startswith(b"\xef\xbb\xbf"))
                self.assertIn("MIT License", text)
                for name in load_resources(ROOT, source.name):
                    if name != "SKILL.md":
                        self.assertIn(f"## Bundled file: {name}\n", text)


if __name__ == "__main__":
    unittest.main()
