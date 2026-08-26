#!/usr/bin/env python3
"""Convert benchmark JSON into a compact Markdown report."""

from __future__ import annotations

import json
import sys
from collections import defaultdict
from pathlib import Path


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
    print("| Adapter | Fixture | Scenario | Scope | Mean ms | P95 ms | P99 ms | Input ms | Startup ms | Samples | Dropped | Drop rate | Status |")
    print("| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |")
    for key in sorted(grouped):
        records = grouped[key]
        measured = [record for record in records if record.get("status") == "measured"]
        scope = key[3] or "-"
        if not measured:
            print(f"| {key[0]} | {key[1]} | {key[2]} | {scope} | - | - | - | - | - | - | - | - | {records[0].get('status')} ({records[0].get('reason', records[0].get('error', ''))}) |")
            continue
        means = [record.get("mean_ms") for record in measured if record.get("mean_ms") is not None]
        p95 = [record.get("p95_ms") for record in measured if record.get("p95_ms") is not None]
        p99 = [record.get("p99_ms") for record in measured if record.get("p99_ms") is not None]
        input_latency = [record.get("input_latency_ms") for record in measured if record.get("input_latency_ms") is not None]
        startup = [record.get("startup_ms") for record in measured if record.get("startup_ms") is not None]
        dropped = sum(record.get("dropped_frames", 0) for record in measured)
        samples = sum(len(record.get("samples_ms", [])) for record in measured)
        avg = lambda values: sum(values) / len(values) if values else None
        fmt = lambda value: "-" if value is None else f"{value:.3f}"
        drop_rate = (100.0 * dropped / samples) if samples else None
        print(f"| {key[0]} | {key[1]} | {key[2]} | {scope} | {fmt(avg(means))} | {fmt(avg(p95))} | {fmt(avg(p99))} | {fmt(avg(input_latency))} | {fmt(avg(startup))} | {samples} | {dropped} | {fmt(drop_rate)}% | measured |")
    print("\nRaw samples are retained in the input JSON. Do not compare rows with different fixture, renderer, viewport or repetition settings.")


if __name__ == "__main__":
    main()
