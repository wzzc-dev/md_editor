#!/usr/bin/env python3
"""Convert the v2 benchmark protocol into a compact Markdown report."""

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


def samples(records: list[dict], field: str) -> list[float]:
    return [value for record in records for value in record.get(field, [])]


def fmt(value: float | None) -> str:
    return "-" if value is None else f"{value:.3f}"


def metric(records: list[dict], field: str) -> tuple[float | None, float | None, float | None]:
    values = samples(records, field + "_samples_ms")
    return average(values), percentile(values, 0.95), percentile(values, 0.99)


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
    viewport = payload["viewport"]
    print(f"- Viewport: `{viewport['width']}x{viewport['height']} @ {viewport['refresh_hz']} Hz`; font: `system-ui 16px`; line height: `1.55`; overscan: `3`; list: `fixed 66px`; GPU: `{payload.get('gpu_backend', 'Metal')}`\n")
    grouped = defaultdict(list)
    for record in payload["records"]:
        scope = record.get("measurement_scope") or record.get("status") or ""
        grouped[(record["adapter"], record["fixture"], record["scenario"], scope)].append(record)
    print("| Adapter | Fixture | Scenario | Scope | Work mean/P95 | Interval mean/P95 | Input->visible mean/P95 | Offscreen mean | Readback mean | First interactive | Dropped display frames | Status |")
    print("| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |")
    for key in sorted(grouped):
        records = grouped[key]
        measured = [record for record in records if record.get("status") == "measured"]
        scope = key[3] or "-"
        if not measured or scope != "ui-frame":
            status = records[0].get("status", "skipped")
            reason = records[0].get("reason", records[0].get("error", ""))
            suffix = f" ({reason})" if reason else ""
            print(f"| {key[0]} | {key[1]} | {key[2]} | {scope} | - | - | - | - | - | - | - | {status}{suffix} |")
            continue
        work = metric(measured, "frame_work")
        interval = metric(measured, "frame_interval")
        input_visible = metric(measured, "input_to_visible")
        offscreen = metric(measured, "offscreen")
        readback = metric(measured, "readback")
        interactive = average([record["first_interactive_ms"] for record in measured if record.get("first_interactive_ms") is not None])
        dropped = sum(record.get("dropped_display_frames", 0) for record in measured)
        print(f"| {key[0]} | {key[1]} | {key[2]} | {scope} | {fmt(work[0])}/{fmt(work[1])} | {fmt(interval[0])}/{fmt(interval[1])} | {fmt(input_visible[0])}/{fmt(input_visible[1])} | {fmt(offscreen[0])} | {fmt(readback[0])} | {fmt(interactive)} | {dropped} | measured |")

    print("\nMetric definitions: `frame_work_ms` is framework build/layout/paint/draw work; `frame_interval_ms` is the interval between displayed frames; `input_to_visible_ms` is action-to-visible completion; `dropped_display_frames` counts refresh slots missed from displayed intervals. WGPU and Skia GPU report offscreen and CPU readback separately. `first_interactive_ms` is measured from adapter initialization to the first interactive frame; process lifetime is not used as a startup proxy.")


if __name__ == "__main__":
    main()
