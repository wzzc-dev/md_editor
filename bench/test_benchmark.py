import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

from run_benchmark import run_command
from macos_display_trace import parse_exported_xml

ROOT = Path(__file__).resolve().parents[1]


class FixtureTests(unittest.TestCase):
    def test_system_trace_parser_filters_target_surface_and_counts_drops(self):
        xml = '''<?xml version="1.0"?>
<trace-query-result>
  <node><schema name="hitches-updates">
    <col><mnemonic>start</mnemonic></col><col><mnemonic>swap-id</mnemonic></col>
    <col><mnemonic>surface-id</mnemonic></col><col><mnemonic>process</mnemonic></col>
  </schema>
  <row><start-time id="1">100000000</start-time><uint32 id="2">11</uint32><uint32 id="3">7</uint32><process id="4"><pid>42</pid></process></row>
  <row><start-time id="5">200000000</start-time><uint32 id="6">12</uint32><uint32 id="7">7</uint32><process ref="4"/></row>
  <row><start-time id="8">300000000</start-time><uint32 id="9">99</uint32><uint32 id="10">8</uint32><process><pid>99</pid></process></row>
  </node>
  <node><schema name="display-surface-swap">
    <col><mnemonic>timestamp</mnemonic></col><col><mnemonic>surface-id</mnemonic></col><col><mnemonic>swap-id</mnemonic></col>
  </schema>
  <row><start-time id="20">110000000</start-time><displayed-surface-swap id="21">7</displayed-surface-swap><displayed-surface-swap id="22">11</displayed-surface-swap></row>
  <row><start-time id="23">280000000</start-time><displayed-surface-swap ref="21"/><displayed-surface-swap id="24">12</displayed-surface-swap></row>
  <row><start-time id="25">390000000</start-time><displayed-surface-swap id="26">8</displayed-surface-swap><displayed-surface-swap id="27">99</displayed-surface-swap></row>
  </node>
</trace-query-result>'''
        result = parse_exported_xml(xml, pid=42)
        self.assertEqual(result.status, "captured")
        self.assertEqual(result.surface_ids, [7])
        self.assertEqual(result.swap_ids, [11, 12])
        self.assertEqual(result.present_timestamps_ms, [110.0, 280.0])
        self.assertEqual(result.present_interval_samples_ms, [170.0])
        self.assertEqual(result.dropped_display_frames, 10)

    def test_system_trace_parser_rejects_unassociated_surface(self):
        xml = '''<trace-query-result><node><schema name="display-surface-swap">
          <col><mnemonic>timestamp</mnemonic></col><col><mnemonic>surface-id</mnemonic></col><col><mnemonic>swap-id</mnemonic></col>
        </schema><row><start-time>1</start-time><displayed-surface-swap>7</displayed-surface-swap><displayed-surface-swap>1</displayed-surface-swap></row></node></trace-query-result>'''
        result = parse_exported_xml(xml, pid=42, expected_samples=1)
        self.assertEqual(result.status, "no-target-surface")

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
        self.assertEqual(payload["schema"], "md-editor-benchmark/v2")
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
        self.assertIn("丢帧数", report)
        self.assertIn("首次可交互", report)
        self.assertIn("工作均值（ms）", report)
        self.assertIn("Metric definitions", report)
        for heading in (
            "## small / medium / large",
            "## stress 5MB",
        ):
            self.assertEqual(report.count(heading), 4)

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

    def test_runner_timeout_is_configurable(self):
        fixture = ROOT / "data" / "small.md"
        result = run_command("python3 -c 'import time; time.sleep(1)'", fixture, "open", "slow", 0.01)
        self.assertEqual(result[0]["status"], "error")
        self.assertIn("0.01 seconds", result[0]["error"])

    def test_ui_payload_shape_is_validated(self):
        fixture = ROOT / "data" / "small.md"
        command = (
            "python3 -c 'import json; print(json.dumps({{"
            "\"adapter\":\"electron\",\"measurement_scope\":\"ui-frame\","
            "\"scenario\":\"{scenario}\",\"frame_work_samples_ms\":[1]*120,\"frame_interval_samples_ms\":[1]*120,"
            "\"input_to_visible_samples_ms\":[],\"offscreen_samples_ms\":[0]*120,\"readback_samples_ms\":[0]*120,\"offscreen_readback_samples_ms\":[0]*120,"
            "\"frame_work_ms\":1,\"frame_interval_ms\":1,\"input_to_visible_ms\":None,\"offscreen_ms\":0,\"readback_ms\":0,"
            "\"dropped_display_frames\":0,"
            "\"document_load_ms\":1,\"first_interactive_ms\":1,"
            "\"viewport\":{{\"width\":1280,\"height\":800}}}}))'"
        )
        result = run_command(command, fixture, "scroll", "electron")
        self.assertEqual(result[0]["status"], "error")
        self.assertIn("warmup_action_count", result[0]["error"])

    def test_ui_payload_rejects_non_finite_samples(self):
        fixture = ROOT / "data" / "small.md"
        command = (
            "python3 -c 'import json; print(json.dumps({{"
            "\"adapter\":\"electron\",\"measurement_scope\":\"ui-frame\","
            "\"scenario\":\"{scenario}\",\"frame_work_samples_ms\":[float(\"nan\")],\"frame_interval_samples_ms\":[1],"
            "\"input_to_visible_samples_ms\":[],\"offscreen_samples_ms\":[0],\"readback_samples_ms\":[0],\"offscreen_readback_samples_ms\":[0],"
            "\"frame_work_ms\":1,\"frame_interval_ms\":1,\"input_to_visible_ms\":None,\"offscreen_ms\":0,\"readback_ms\":0,\"dropped_display_frames\":0,"
            "\"document_load_ms\":1,\"first_interactive_ms\":1,"
            "\"viewport\":{{\"width\":1280,\"height\":800}}}}))'"
        )
        result = run_command(command, fixture, "open", "electron")
        self.assertEqual(result[0]["status"], "error")
        self.assertIn("finite and nonnegative", result[0]["error"])

    def test_ui_payload_does_not_require_startup_proxy(self):
        fixture = ROOT / "data" / "small.md"
        command = (
            "python3 -c 'import json; print(json.dumps({{"
            "\"adapter\":\"electron\",\"measurement_scope\":\"ui-frame\","
            "\"scenario\":\"{scenario}\",\"frame_work_samples_ms\":[1],\"frame_interval_samples_ms\":[],"
            "\"input_to_visible_samples_ms\":[],\"offscreen_samples_ms\":[0],\"readback_samples_ms\":[0],\"offscreen_readback_samples_ms\":[0],"
            "\"frame_work_ms\":1,\"frame_interval_ms\":None,\"input_to_visible_ms\":None,\"offscreen_ms\":0,\"readback_ms\":0,\"dropped_display_frames\":0,"
            "\"action_count\":1,\"frame_sample_count\":0,\"warmup_action_count\":0,"
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
            "\"scenario\":\"{scenario}\",\"frame_work_samples_ms\":[1]*120,\"frame_interval_samples_ms\":[1]*120,"
            "\"input_to_visible_samples_ms\":[1]*120,\"offscreen_samples_ms\":[0]*120,\"readback_samples_ms\":[0]*120,\"offscreen_readback_samples_ms\":[0]*120,"
            "\"frame_work_ms\":1,\"frame_interval_ms\":1,\"input_to_visible_ms\":None,\"offscreen_ms\":0,\"readback_ms\":0,\"dropped_display_frames\":0,"
            "\"action_count\":120,\"frame_sample_count\":120,"
            "\"warmup_action_count\":1,\"input_latency_ms\":None,"
            "\"document_load_ms\":1,"
            "\"first_interactive_ms\":1,\"viewport\":{{\"width\":1280,\"height\":800}}"
            "}}))'"
        )
        result = run_command(command, fixture, "scroll", "gpui")
        self.assertEqual(result[0]["status"], "error")
        self.assertIn("must not contain input-to-visible samples", result[0]["error"])

    def test_report_pools_raw_samples_for_percentiles(self):
        records = []
        for samples in ([0.0] * 9 + [100.0], [10.0] * 10):
            records.append({
                "adapter": "electron",
                "fixture": "small",
                "scenario": "scroll",
                "measurement_scope": "ui-frame",
                "status": "measured",
                "frame_work_samples_ms": samples,
                "frame_interval_samples_ms": samples,
                "input_to_visible_samples_ms": [],
                "offscreen_samples_ms": [0.0] * 10,
                "readback_samples_ms": [0.0] * 10,
                "offscreen_readback_samples_ms": [0.0] * 10,
                "frame_work_ms": 0.0,
                "frame_interval_ms": 10.0,
                "input_to_visible_ms": None,
                "offscreen_ms": 0.0,
                "readback_ms": 0.0,
                "first_interactive_ms": 1.0,
                "action_count": 10,
                "dropped_display_frames": 1,
            })
        payload = {
            "schema": "md-editor-benchmark/v2",
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
        self.assertEqual(columns[4], "10.000/10.000")

    def test_report_error_rows_keep_the_table_shape(self):
        payload = {
            "schema": "md-editor-benchmark/v2",
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
        self.assertEqual(len(row.strip("|").split("|")), 13)

    def test_strict_report_never_falls_back_to_framework_intervals(self):
        record = {
            "adapter": "electron",
            "fixture": "small",
            "scenario": "scroll",
            "measurement_scope": "ui-frame",
            "status": "measured",
            "frame_work_samples_ms": [1.0],
            "frame_interval_samples_ms": [999.0],
            "input_to_visible_samples_ms": [],
            "offscreen_samples_ms": [None],
            "readback_samples_ms": [None],
            "offscreen_readback_samples_ms": [None],
            "dropped_display_frames": 58,
            "system_trace_status": "no-target-surface",
            "system_present_interval_samples_ms": [],
            "system_input_to_present_samples_ms": [],
            "system_dropped_display_frames": None,
        }
        payload = {
            "schema": "md-editor-benchmark/v2",
            "comparison_mode": "strict-system-present",
            "platform": "test",
            "machine": "test",
            "memory_gb": 16,
            "viewport": {"width": 1280, "height": 800, "refresh_hz": 60},
            "records": [record],
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
        self.assertIn("系统帧间隔均值（ms）", report)
        row = next(
            line for line in report.splitlines()
            if line.startswith("| Electron |") and "n/a" in line
        )
        self.assertNotIn("999.00", row)
        self.assertNotIn("58", row)


if __name__ == "__main__":
    unittest.main()
