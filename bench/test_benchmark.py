import json
import subprocess
import sys
import tempfile
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
            self.assertEqual(content.count("Block "), int(blocks), name)

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
        self.assertIn("Document load ms", report)
        self.assertIn("Timing sources remain framework-specific", report)

    def test_adapter_emitted_name_is_authoritative(self):
        fixture = ROOT / "data" / "small.md"
        command = (
            "python3 -c 'import json; print(json.dumps({{\"adapter\":\"generic\","
            "\"measurement_scope\":\"headless-render\",\"scenario\":\"{scenario}\","
            "\"samples_ms\":[1],\"mean_ms\":1,\"p95_ms\":1,\"p99_ms\":1,"
            "\"dropped_frames\":0}}))'"
        )
        result = run_command(command, fixture, "open", "flutter-impeller")
        # run_command returns a list of records; the adapter-emitted `adapter`
        # field is authoritative so a single command can back multiple scopes.
        self.assertEqual(len(result), 1)
        self.assertEqual(result[0]["status"], "measured")
        self.assertEqual(result[0]["adapter"], "generic")
        self.assertEqual(result[0]["action_count"], 1)
        self.assertEqual(result[0]["frame_sample_count"], 1)
        self.assertEqual(result[0]["warmup_action_count"], 0)

    def test_adapter_multi_scope_output(self):
        fixture = ROOT / "data" / "small.md"
        command = (
            "python3 -c 'import json; print(json.dumps({{\"adapter\":\"moui-skia-raster\","
            "\"measurement_scope\":\"headless-render\",\"scenario\":\"{scenario}\","
            "\"samples_ms\":[1],\"mean_ms\":1,\"p95_ms\":1,\"p99_ms\":1,"
            "\"dropped_frames\":0}})); "
            "print(json.dumps({{\"adapter\":\"moui-skia-raster-full\","
            "\"measurement_scope\":\"richtext-full\",\"scenario\":\"{scenario}\","
            "\"samples_ms\":[2],\"mean_ms\":2,\"p95_ms\":2,\"p99_ms\":2,"
            "\"dropped_frames\":0}}))'"
        )
        result = run_command(command, fixture, "open", "moui-skia-raster")
        self.assertEqual(len(result), 2)
        self.assertEqual(result[0]["measurement_scope"], "headless-render")
        self.assertEqual(result[1]["measurement_scope"], "richtext-full")
        self.assertEqual(result[0]["adapter"], "moui-skia-raster")
        self.assertEqual(result[1]["adapter"], "moui-skia-raster-full")

    def test_adapter_environment_assignment_is_forwarded(self):
        fixture = ROOT / "data" / "small.md"
        command = (
            "TEST_RENDERER=impeller python3 -c 'import json,os; print(json.dumps({{"
            "\"adapter\":os.environ[\"TEST_RENDERER\"],\"scenario\":\"{scenario}\","
            "\"samples_ms\":[1],\"mean_ms\":1,\"p95_ms\":1,\"p99_ms\":1,"
            "\"dropped_frames\":0}}))'"
        )
        result = run_command(command, fixture, "open", "flutter-impeller")
        self.assertEqual(result[0]["adapter"], "impeller")

    def test_adapter_error_status_is_not_relabelled_as_measured(self):
        fixture = ROOT / "data" / "small.md"
        command = (
            "python3 -c 'import json; print(json.dumps({{"
            "\"status\":\"error\",\"error\":\"renderer failed\"}}))'"
        )
        result = run_command(command, fixture, "open", "electron")
        self.assertEqual(result[0]["status"], "error")
        self.assertEqual(result[0]["error"], "renderer failed")

    def test_ui_payload_shape_is_validated(self):
        fixture = ROOT / "data" / "small.md"
        command = (
            "python3 -c 'import json; print(json.dumps({{"
            "\"adapter\":\"electron\",\"measurement_scope\":\"ui-frame\","
            "\"scenario\":\"{scenario}\",\"samples_ms\":[1],\"mean_ms\":1,"
            "\"p95_ms\":1,\"p99_ms\":1,\"dropped_frames\":0,"
            "\"viewport\":{{\"width\":1280,\"height\":800}}}}))'"
        )
        result = run_command(command, fixture, "scroll", "electron")
        self.assertEqual(result[0]["status"], "error")
        self.assertIn("120 samples", result[0]["error"])

    def test_ui_payload_rejects_non_finite_samples(self):
        fixture = ROOT / "data" / "small.md"
        command = (
            "python3 -c 'import json; print(json.dumps({{"
            "\"adapter\":\"electron\",\"measurement_scope\":\"ui-frame\","
            "\"scenario\":\"{scenario}\",\"samples_ms\":[float(\"nan\")],"
            "\"mean_ms\":1,\"p95_ms\":1,\"p99_ms\":1,\"dropped_frames\":0,"
            "\"document_load_ms\":1,\"first_interactive_ms\":1,"
            "\"viewport\":{{\"width\":1280,\"height\":800}}}}))'"
        )
        result = run_command(command, fixture, "open", "electron")
        self.assertEqual(result[0]["status"], "error")
        self.assertIn("finite and nonnegative", result[0]["error"])

    def test_ui_payload_requires_startup_only_for_open(self):
        fixture = ROOT / "data" / "small.md"
        command = (
            "python3 -c 'import json; print(json.dumps({{"
            "\"adapter\":\"electron\",\"measurement_scope\":\"ui-frame\","
            "\"scenario\":\"{scenario}\",\"samples_ms\":[1],\"mean_ms\":1,"
            "\"p95_ms\":1,\"p99_ms\":1,\"dropped_frames\":0,"
            "\"action_count\":1,\"frame_sample_count\":1,\"warmup_action_count\":0,"
            "\"document_load_ms\":1,\"first_interactive_ms\":1,"
            "\"startup_ms\":1,\"viewport\":{{\"width\":1280,\"height\":800}}}}))'"
        )
        result = run_command(command, fixture, "open", "electron")
        self.assertEqual(result[0]["status"], "measured")
        command = command.replace('\\\"startup_ms\\\":1,', '')
        result = run_command(command, fixture, "open", "electron")
        self.assertEqual(result[0]["status"], "measured")

    def test_ui_payload_rejects_input_latency_on_non_input_scenarios(self):
        fixture = ROOT / "data" / "small.md"
        command = (
            "python3 -c 'import json; print(json.dumps({{"
            "\"adapter\":\"gpui\",\"measurement_scope\":\"ui-frame\","
            "\"scenario\":\"{scenario}\",\"samples_ms\":[1]*120,"
            "\"mean_ms\":1,\"p95_ms\":1,\"p99_ms\":1,\"dropped_frames\":0,"
            "\"action_count\":120,\"frame_sample_count\":120,"
            "\"warmup_action_count\":1,\"input_latency_ms\":None,"
            "\"input_latency_samples_ms\":[1]*120,\"document_load_ms\":1,"
            "\"first_interactive_ms\":1,\"viewport\":{{\"width\":1280,\"height\":800}}"
            "}}))'"
        )
        result = run_command(command, fixture, "scroll", "gpui")
        self.assertEqual(result[0]["status"], "error")
        self.assertIn("must not contain input latency samples", result[0]["error"])

    def test_report_pools_raw_samples_for_percentiles(self):
        records = []
        for samples in ([0.0] * 9 + [100.0], [10.0] * 10):
            records.append({
                "adapter": "electron",
                "fixture": "small",
                "scenario": "scroll",
                "measurement_scope": "ui-frame",
                "status": "measured",
                "samples_ms": samples,
                "p95_ms": 55.0,
                "p99_ms": 55.0,
                "action_count": 10,
                "dropped_frames": 1,
            })
        payload = {
            "schema": "md-editor-benchmark/v1",
            "platform": "test",
            "machine": "test",
            "memory_gb": 16,
            "viewport": {"width": 1280, "height": 800, "refresh_hz": 60},
            "records": records,
        }
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "benchmark.json"
            path.write_text(json.dumps(payload), encoding="utf-8")
            report = subprocess.run(
                [sys.executable, str(ROOT / "bench" / "report.py"), str(path)],
                check=True,
                capture_output=True,
                text=True,
            ).stdout
        row = next(line for line in report.splitlines() if line.startswith("| electron |"))
        columns = [column.strip() for column in row.strip("|").split("|")]
        self.assertEqual(columns[4], "10.000")
        self.assertEqual(columns[5], "10.000")
        self.assertEqual(columns[6], "100.000")

    def test_report_error_rows_keep_the_table_shape(self):
        payload = {
            "schema": "md-editor-benchmark/v1",
            "platform": "test",
            "machine": "test",
            "memory_gb": 16,
            "viewport": {"width": 1280, "height": 800, "refresh_hz": 60},
            "records": [{
                "adapter": "electron",
                "fixture": "small",
                "scenario": "open",
                "status": "error",
                "error": "failed",
            }],
        }
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "benchmark.json"
            path.write_text(json.dumps(payload), encoding="utf-8")
            report = subprocess.run(
                [sys.executable, str(ROOT / "bench" / "report.py"), str(path)],
                check=True,
                capture_output=True,
                text=True,
            ).stdout
        row = next(line for line in report.splitlines() if line.startswith("| electron |"))
        self.assertEqual(len(row.strip("|").split("|")), 16)


if __name__ == "__main__":
    unittest.main()
