import json
import subprocess
import sys
import unittest
from pathlib import Path

from run_benchmark import run_command

ROOT = Path(__file__).resolve().parents[1]


class FixtureTests(unittest.TestCase):
    def test_fixtures_have_contract_sizes(self):
        subprocess.run([sys.executable, str(ROOT / "scripts/generate_fixtures.py")], check=True)
        manifest = (ROOT / "data" / "MANIFEST.tsv").read_text(encoding="utf-8").splitlines()[1:]
        for line in manifest:
            name, size, blocks, filename = line.split("\t")
            content = (ROOT / "data" / filename).read_text(encoding="utf-8")
            self.assertEqual((ROOT / "data" / filename).stat().st_size, int(size), name)
            self.assertEqual(content.count("## Block "), int(blocks), name)

    def test_runner_schema_with_no_commands(self):
        out = ROOT / "results" / "test.json"
        subprocess.run([sys.executable, str(ROOT / "bench" / "run_benchmark.py"), "--fixture", "small", "--out", str(out)], check=True)
        payload = json.loads(out.read_text(encoding="utf-8"))
        self.assertEqual(payload["schema"], "md-editor-benchmark/v1")
        self.assertIn("os_release", payload)
        self.assertIn("gpu", payload)
        self.assertIn("renderer_env", payload)
        self.assertIn("toolchains", payload)
        self.assertTrue(all(record["status"] == "skipped" for record in payload["records"]))
        report = subprocess.run(
            [sys.executable, str(ROOT / "bench" / "report.py"), str(out)],
            check=True,
            capture_output=True,
            text=True,
        ).stdout
        self.assertIn("Drop rate", report)

    def test_adapter_matrix_name_overrides_payload(self):
        fixture = ROOT / "data" / "small.md"
        command = (
            "python3 -c 'import json; print(json.dumps({{\"adapter\":\"generic\","
            "\"measurement_scope\":\"headless-render\",\"scenario\":\"{scenario}\","
            "\"samples_ms\":[1],\"mean_ms\":1,\"p95_ms\":1,\"p99_ms\":1,"
            "\"dropped_frames\":0}}))'"
        )
        result = run_command(command, fixture, "open", "flutter-impeller")
        self.assertEqual(result["status"], "measured")
        self.assertEqual(result["adapter"], "flutter-impeller")


if __name__ == "__main__":
    unittest.main()
