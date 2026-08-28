#!/usr/bin/env python3
"""Convert benchmark JSON into a compact Markdown report."""

from __future__ import annotations

import json
import sys
from collections import defaultdict
from pathlib import Path


def average(values: list[float]) -> float | None:
    return sum(values) / len(values) if values else None


def percentile(values: list[float], ratio: float) -> float | None:
    if not values:
        return None
    ordered = sorted(values)
    return ordered[round((len(ordered) - 1) * ratio)]


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("usage: report.py results/benchmark.json")
    payload = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
    print("# Markdown editor benchmark report\n")
    print(f"- Schema: `{payload['schema']}`")
    print(f"- Host: `{payload['platform']}` / `{payload['machine']}` / `{payload['memory_gb']} GiB`")
    print(f"- OS release: `{payload.get('os_release', '-')}`; GPU: `{payload.get('gpu') or 'unknown'}`")
    toolchains = ", ".join(f"{name}={version}" for name, version in payload.get("toolchains", {}).items())
    if toolchains:
        print(f"- Toolchains: `{toolchains}`")
    if payload.get("renderer_env"):
        print(f"- Renderer environment: `{payload['renderer_env']}`")
    print(f"- Viewport: `{payload['viewport']['width']}x{payload['viewport']['height']} @ {payload['viewport']['refresh_hz']} Hz`\n")
    grouped = defaultdict(list)
    for record in payload["records"]:
        scope = record.get("measurement_scope") or record.get("status") or ""
        grouped[(record["adapter"], record["fixture"], record["scenario"], scope)].append(record)
    print("| Adapter | Fixture | Scenario | Scope | Mean ms | P95 ms | P99 ms | Input ms | Document load ms | Interactive ms | Startup ms | Actions | Frames | Dropped | Drop rate | Status |")
    print("| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |")
    for key in sorted(grouped):
        records = grouped[key]
        measured = [record for record in records if record.get("status") == "measured"]
        scope = key[3] or "-"
        if not measured:
            print(f"| {key[0]} | {key[1]} | {key[2]} | {scope} | - | - | - | - | - | - | - | - | - | - | - | {records[0].get('status')} ({records[0].get('reason', records[0].get('error', ''))}) |")
            continue
        frame_samples = [value for record in measured for value in record.get("samples_ms", [])]
        latency_samples = [
            value for record in measured for value in record.get("input_latency_samples_ms", [])
        ]
        if not latency_samples:
            latency_samples = [
                record["input_latency_ms"]
                for record in measured
                if record.get("input_latency_ms") is not None
            ]
        document_load = [record.get("document_load_ms") for record in measured if record.get("document_load_ms") is not None]
        interactive = [record.get("first_interactive_ms") for record in measured if record.get("first_interactive_ms") is not None]
        startup = [record.get("startup_ms") for record in measured if record.get("startup_ms") is not None]
        dropped = sum(record.get("dropped_frames", 0) for record in measured)
        samples = sum(len(record.get("samples_ms", [])) for record in measured)
        actions = sum(record.get("action_count", 0) for record in measured)
        fmt = lambda value: "-" if value is None else f"{value:.3f}"
        drop_rate = (100.0 * dropped / samples) if samples else None
        print(f"| {key[0]} | {key[1]} | {key[2]} | {scope} | {fmt(average(frame_samples))} | {fmt(percentile(frame_samples, 0.95))} | {fmt(percentile(frame_samples, 0.99))} | {fmt(average(latency_samples))} | {fmt(average(document_load))} | {fmt(average(interactive))} | {fmt(average(startup))} | {actions} | {samples} | {dropped} | {fmt(drop_rate)}% | measured |")

    averages = {}
    for key, records in grouped.items():
        measured = [record for record in records if record.get("status") == "measured"]
        if key[3] != "ui-frame" or not measured:
            continue
        frame_samples = [value for record in measured for value in record.get("samples_ms", [])]
        latency_samples = [
            value for record in measured for value in record.get("input_latency_samples_ms", [])
        ]
        if not latency_samples:
            latency_samples = [
                record["input_latency_ms"]
                for record in measured
                if record.get("input_latency_ms") is not None
            ]
        averages[key[:3]] = {
            "mean_ms": average(frame_samples),
            "p95_ms": percentile(frame_samples, 0.95),
            "p99_ms": percentile(frame_samples, 0.99),
            "input_latency_ms": average(latency_samples),
            "document_load_ms": average([
                record["document_load_ms"] for record in measured if record.get("document_load_ms") is not None
            ]),
            "first_interactive_ms": average([
                record["first_interactive_ms"] for record in measured if record.get("first_interactive_ms") is not None
            ]),
            "startup_ms": average([
                record["startup_ms"] for record in measured if record.get("startup_ms") is not None
            ]),
        }

    screens = []
    metrics = (
        ("Frame mean", "mean_ms"),
        ("Frame P95", "p95_ms"),
        ("Frame P99", "p99_ms"),
        ("Input latency", "input_latency_ms"),
        ("Document load", "document_load_ms"),
        ("First interactive", "first_interactive_ms"),
        ("Startup", "startup_ms"),
    )
    for target in ("moui-skia-raster", "moui-skia-gpu", "moui-wgpu", "gpui"):
        for baseline in ("flutter-skia", "flutter-impeller", "electron"):
            for label, field in metrics:
                ratios = []
                for (adapter, fixture, scenario), values in averages.items():
                    if adapter != target or values.get(field) is None:
                        continue
                    comparison = averages.get((baseline, fixture, scenario), {}).get(field)
                    if comparison is not None and comparison > 0:
                        ratios.append((values[field] / comparison, fixture, scenario))
                if ratios:
                    screens.append((target, baseline, label, max(ratios)))
    if screens:
        print("\n## Matching UI 2x screen\n")
        print("| Target | Baseline | Metric | Worst ratio | Fixture / scenario | Screen |")
        print("| --- | --- | --- | ---: | --- | --- |")
        for target, baseline, label, (ratio, fixture, scenario) in screens:
            outcome = "within 2x" if ratio <= 2 else "over 2x"
            print(f"| {target} | {baseline} | {label} | {ratio:.3f}x | {fixture} / {scenario} | {outcome} |")

    print("\nRaw samples are retained in the input JSON. The screen above uses only matching `ui-frame` rows with the same fixture and scenario. Verify viewport, repetitions and warm-ups in the raw records before treating a ratio as comparable. Timing sources remain framework-specific and are not compositor-equivalent.")


if __name__ == "__main__":
    main()
