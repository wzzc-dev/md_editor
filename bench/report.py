#!/usr/bin/env python3
"""Render an auditable, fixture-first report for the v2 UI benchmark."""

from __future__ import annotations

import json
import sys
from collections import defaultdict
from pathlib import Path
from typing import Any


FIXTURES = ("small", "medium", "large", "stress")
FIXTURE_GROUPS = (
    (
        "small / medium / large",
        ("small", "medium", "large"),
        "值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）",
    ),
    ("stress 5MB", ("stress",), ""),
)
ADAPTERS = (
    "moui-skia-raster",
    "moui-skia-gpu",
    "moui-wgpu",
    "gpui",
    "flutter-skia",
    "flutter-impeller",
    "electron",
)
LABELS = {
    "moui-skia-raster": "MoUI Skia Raster CPU",
    "moui-skia-gpu": "MoUI Skia GPU",
    "moui-wgpu": "MoUI WGPU",
    "gpui": "GPUI",
    "flutter-skia": "Flutter Skia",
    "flutter-impeller": "Flutter Impeller",
    "electron": "Electron",
}


def numeric(values: Any) -> list[float]:
    if not isinstance(values, list):
        return []
    return [
        float(value)
        for value in values
        if isinstance(value, (int, float)) and not isinstance(value, bool)
    ]


def average(values: list[float]) -> float | None:
    return sum(values) / len(values) if values else None


def percentile(values: list[float], ratio: float) -> float | None:
    if not values:
        return None
    ordered = sorted(values)
    return ordered[round((len(ordered) - 1) * ratio)]


def samples(records: list[dict], field: str) -> list[float]:
    return [value for record in records for value in numeric(record.get(field + "_samples_ms"))]


def metric(records: list[dict], field: str) -> tuple[float | None, float | None]:
    values = samples(records, field)
    return average(values), percentile(values, 0.95)


def system_metric(records: list[dict], field: str) -> tuple[float | None, float | None]:
    """Aggregate only compositor samples; never fall back to callback data."""
    return metric(records, field)


def scalar_values(records: list[dict], field: str) -> list[float]:
    return [
        float(record[field])
        for record in records
        if isinstance(record.get(field), (int, float)) and not isinstance(record.get(field), bool)
    ]


def fmt(value: float | None) -> str:
    return "n/a" if value is None else f"{value:.2f} ms"


def fmt_number(value: float | None) -> str:
    return "n/a" if value is None else f"{value:.2f}"


def audit_pair(values: tuple[float | None, float | None]) -> str:
    if values[0] is None:
        return "-"
    return f"{values[0]:.3f}/{values[1]:.3f}" if values[1] is not None else f"{values[0]:.3f}/-"


def grouped_records(payload: dict) -> dict[tuple[str, str, str], list[dict]]:
    grouped: dict[tuple[str, str, str], list[dict]] = defaultdict(list)
    for record in payload.get("records", []):
        if record.get("measurement_scope") == "ui-frame":
            key = (record.get("adapter", "?"), record.get("fixture", "?"), record.get("scenario", "?"))
            grouped[key].append(record)
    return grouped


def measured(records: list[dict]) -> list[dict]:
    return [record for record in records if record.get("status", "measured") == "measured"]


def first(records: list[dict], field: str) -> float | None:
    return average(scalar_values(records, field))


def scalar_metric(records: list[dict], field: str) -> tuple[float | None, float | None]:
    values = scalar_values(records, field)
    return average(values), percentile(values, 0.95)


def work_metric(records: list[dict]) -> tuple[float | None, float | None]:
    # GPUI's current hook surrounds only action dispatch; exposing that tiny
    # number as complete paint work would create a false cross-framework win.
    if records and all(record.get("work_scope") == "action-dispatch-only" for record in records):
        return None, None
    return metric(records, "frame_work")


def dropped(records: list[dict]) -> int | None:
    values = [record.get("dropped_display_frames") for record in records]
    if not values or any(not isinstance(value, int) or isinstance(value, bool) for value in values):
        return None
    return sum(values)


def system_dropped(records: list[dict]) -> int | None:
    values = [record.get("system_dropped_display_frames") for record in records]
    if not values or any(not isinstance(value, int) or isinstance(value, bool) for value in values):
        return None
    return sum(values)


def status_text(records: list[dict]) -> str:
    if not records:
        return "n/a"
    valid = measured(records)
    if valid:
        return "measured"
    record = records[0]
    reason = record.get("reason") or record.get("error")
    return f"{record.get('status', 'skipped')}: {reason}" if reason else str(record.get("status", "skipped"))


SECTION_HEADERS = {
    "frame": ("工作均值（ms）", "工作 P95（ms）", "帧间隔均值（ms）", "帧间隔 P95（ms）", "丢帧数"),
    "input": ("可见延迟均值（ms）", "可见延迟 P95（ms）", "工作均值（ms）", "工作 P95（ms）"),
    "open": ("首次可交互均值（ms）", "首次可交互 P95（ms）", "工作均值（ms）", "工作 P95（ms）", "文档加载均值（ms）", "文档加载 P95（ms）"),
    "scroll": ("工作均值（ms）", "工作 P95（ms）", "帧间隔均值（ms）", "帧间隔 P95（ms）", "丢帧数", "离屏均值（ms）", "离屏 P95（ms）", "回读均值（ms）", "回读 P95（ms）"),
}


def section_headers(kind: str, strict_system: bool) -> tuple[str, ...]:
    headers = SECTION_HEADERS[kind]
    if not strict_system:
        return headers
    replacements = {
        "帧间隔均值（ms）": "系统帧间隔均值（ms）",
        "帧间隔 P95（ms）": "系统帧间隔 P95（ms）",
        "丢帧数": "系统丢帧数",
        "可见延迟均值（ms）": "系统可见延迟均值（ms）",
        "可见延迟 P95（ms）": "系统可见延迟 P95（ms）",
        "首次可交互均值（ms）": "系统首帧显示均值（ms）",
        "首次可交互 P95（ms）": "系统首帧显示 P95（ms）",
    }
    return tuple(replacements.get(header, header) for header in headers)


def metric_cells(
    grouped: dict[tuple[str, str, str], list[dict]],
    adapter: str,
    fixture: str,
    scenario: str,
    kind: str,
    strict_system: bool = False,
) -> list[str]:
    records = grouped.get((adapter, fixture, scenario), [])
    valid = measured(records)
    if not valid:
        count = len(section_headers(kind, strict_system))
        return [status_text(records)] + ["n/a"] * (count - 1)
    work = work_metric(valid)
    interval = system_metric(valid, "system_present_interval") if strict_system else metric(valid, "frame_interval")
    drop_count = system_dropped(valid) if strict_system else dropped(valid)
    if kind == "frame":
        return [fmt_number(work[0]), fmt_number(work[1]), fmt_number(interval[0]), fmt_number(interval[1]), str(drop_count) if drop_count is not None else "n/a"]
    if kind == "input":
        visible = system_metric(valid, "system_input_to_present") if strict_system else metric(valid, "input_to_visible")
        return [fmt_number(visible[0]), fmt_number(visible[1]), fmt_number(work[0]), fmt_number(work[1])]
    if kind == "open":
        interactive = scalar_metric(valid, "system_first_present_ms") if strict_system else scalar_metric(valid, "first_interactive_ms")
        load = scalar_metric(valid, "document_load_ms")
        return [fmt_number(interactive[0]), fmt_number(interactive[1]), fmt_number(work[0]), fmt_number(work[1]), fmt_number(load[0]), fmt_number(load[1])]
    offscreen = metric(valid, "offscreen")
    readback = metric(valid, "readback")
    return [
        fmt_number(work[0]), fmt_number(work[1]), fmt_number(interval[0]), fmt_number(interval[1]), str(drop_count) if drop_count is not None else "n/a",
        fmt_number(offscreen[0]), fmt_number(offscreen[1]), fmt_number(readback[0]), fmt_number(readback[1]),
    ]


def print_section(
    title: str,
    scenario: str,
    kind: str,
    grouped: dict[tuple[str, str, str], list[dict]],
    strict_system: bool = False,
) -> None:
    print(f"# {title}\n")
    for group_label, fixtures, note in FIXTURE_GROUPS:
        print(f"## {group_label}\n")
        if note:
            print(f"{note}\n")
        headers = section_headers(kind, strict_system)
        print("| 实现 | " + " | ".join(headers) + " |")
        print("| --- | " + " | ".join("---:" for _ in headers) + " |")
        for adapter in ADAPTERS:
            per_fixture = [metric_cells(grouped, adapter, fixture, scenario, kind, strict_system) for fixture in fixtures]
            values = ["/".join(row[index] for row in per_fixture) for index in range(len(headers))]
            print(f"| {LABELS[adapter]} | " + " | ".join(values) + " |")
        print()


def print_audit_table(grouped: dict[tuple[str, str, str], list[dict]]) -> None:
    """Keep a compact raw-sample audit table for scripts and reviewers."""
    print("<details><summary>原始 ui-frame 汇总（可审计）</summary>\n")
    print("| 实现 | 测试集合 | 场景 | 范围 | 工作均值/P95 | 仅分发均值/P95 | 帧间隔均值/P95 | 输入到可见均值/P95 | 离屏均值 | 回读均值 | 首次可交互 | 丢帧数 | 状态 |")
    print("| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |")
    keys = [
        (adapter, fixture, scenario)
        for adapter in ADAPTERS
        for fixture in FIXTURES
        for scenario in ("open", "input", "scroll")
        if (adapter, fixture, scenario) in grouped
    ]
    # Keep a visible skipped matrix when a run supplied no UI records at all.
    if not keys:
        keys = [(adapter, fixture, scenario) for adapter in ADAPTERS for fixture in FIXTURES for scenario in ("open", "input", "scroll")]
    for adapter, fixture, scenario in keys:
        records = grouped.get((adapter, fixture, scenario), [])
        valid = measured(records)
        work = work_metric(valid) if valid else (None, None)
        dispatch = metric(valid, "frame_work") if valid and all(
            record.get("work_scope") == "action-dispatch-only" for record in valid
        ) else (None, None)
        interval = metric(valid, "frame_interval") if valid else (None, None)
        input_visible = metric(valid, "input_to_visible") if valid else (None, None)
        offscreen = metric(valid, "offscreen") if valid else (None, None)
        readback = metric(valid, "readback") if valid else (None, None)
        interactive = first(valid, "first_interactive_ms") if valid else None
        print(
            f"| {adapter} | {fixture} | {scenario} | ui-frame | "
            f"{audit_pair(work)} | {audit_pair(dispatch)} | {audit_pair(interval)} | {audit_pair(input_visible)} | "
            f"{fmt(offscreen[0])} | {fmt(readback[0])} | {fmt(interactive)} | "
            f"{dropped(valid) if valid else '-'} | {status_text(records)} |"
        )
    print("\n</details>\n")


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("usage: report.py results/benchmark.json")
    payload = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
    strict_system = payload.get("comparison_mode") == "strict-system-present"
    grouped = grouped_records(payload)
    records = payload.get("records", [])
    measured_count = sum(record.get("status", "measured") == "measured" for record in records)
    failed_count = len(records) - measured_count

    print("# Markdown editor benchmark report\n")
    print(f"- Schema：`{payload.get('schema', '-')}`；生成时间：`{payload.get('generated_at_utc', '-')}`")
    print(f"- 数据状态：`{measured_count} measured`，`{failed_count} skipped/error`；原始样本保留在 JSON。")
    print(f"- Host：`{payload.get('platform', '-')}` / `{payload.get('machine', '-')}` / `{payload.get('memory_gb', '-')} GiB`；GPU：`{payload.get('gpu') or 'unknown'}`")
    print(f"- OS：`{payload.get('os_release', '-')}`；CPU：`{payload.get('cpu', '-')}`；toolchains：`{', '.join(f'{name}={version}' for name, version in payload.get('toolchains', {}).items()) or '-'}`")
    viewport = payload.get("viewport", {})
    print(f"- 统一配置：`{viewport.get('width', 1280)}x{viewport.get('height', 800)} @ {viewport.get('refresh_hz', 60)} Hz`；font `system-ui 16px`；line-height `1.55`；overscan `3`；fixed row `66px`；GPU backend `{payload.get('gpu_backend', 'unknown')}`")
    print("- Fixture：`small=5KB/100 blocks`，`medium=50KB/1,000 blocks`，`large=500KB/10,000 blocks`，`stress=5MB/100,000 blocks`。")
    repetitions = sorted({record.get("repetitions") for record in records if isinstance(record.get("repetitions"), int)})
    warmups = sorted({record.get("warmups") for record in records if isinstance(record.get("warmups"), int)})
    repetition_text = repetitions[0] if len(repetitions) == 1 else repetitions
    warmup_text = warmups[0] if len(warmups) == 1 else warmups
    print(f"- 汇总口径：mean/P95 合并原始样本；每格 repetition `{repetition_text}`、process warm-up `{warmup_text}`；drop 为各 repetition {'system_dropped_display_frames' if strict_system else 'dropped_display_frames'} 之和。")
    if strict_system:
        print("- 公平性口径：严格模式的帧间隔、丢帧和首帧显示只来自 macOS compositor `xctrace Animation Hitches/display-surface-swap`；系统 trace 无法关联目标 surface 时显示 `n/a`，绝不回退到框架回调。工作时间仍保留各框架的内部 phase 诊断，不能与系统 present 时间相加。\n")
    else:
        print("- 公平性口径：所有 ui-frame 记录使用相同 fixture、viewport、动作数、warm-up 和重复次数；数值来自框架真实渲染/提交回调。MoUI ui-frame 是 headless host-surface，GPUI 的 work 当前只覆盖 action dispatch；不同框架的显示时间戳由各自平台 API 提供，因此报告不做跨时钟的综合排名。`n/a` 表示没有采集，绝不等同于 0。\n")

    # Put the audit table first so command-line consumers can locate the
    # legacy-compatible raw summary without parsing the fixture matrix.
    print_audit_table(grouped)
    print_section("帧性能", "scroll", "frame", grouped, strict_system)
    print_section("输入延迟", "input", "input", grouped, strict_system)
    print_section("打开性能", "open", "open", grouped, strict_system)
    print_section("滚动性能", "scroll", "scroll", grouped, strict_system)
    print("## 采集口径\n")
    print("- Metric definitions：`frame_work_ms` 是适配器声明的构建/布局/绘制工作范围；严格模式的 `system_present_interval_samples_ms` 是 macOS compositor 相邻显示时间戳间隔，普通模式的 `frame_interval_ms` 仍是适配器帧回调间隔。")
    print("- GPUI 的当前 hook 只有 action dispatch 计时，未覆盖 GPUI draw/paint，因此主表的 work 显示 `n/a`；其原始 dispatch 样本仍在审计 JSON/表中。")
    print("- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式只有 trace 能关联目标 update/swap 时才填 `system_input_to_present_samples_ms`，否则为 `n/a`。`dropped_display_frames` 使用对应系统 present 间隔按 `max(ceil(interval / 16.667) - 1, 0)` 计算。")
    print("- `first_interactive_ms` 是首个可交互帧；严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代；打开场景没有前一帧，所以不计算 interval/drop。")
    print("- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段：GPU 直出路径的 CPU readback 为测得的 `0`；未埋点的 offscreen 或非该路径显示为 `n/a`。")


if __name__ == "__main__":
    main()
