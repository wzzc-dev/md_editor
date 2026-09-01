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


def system_action_metric(records: list[dict]) -> tuple[float | None, float | None]:
    """Common end-to-end action-to-next-compositor-present metric."""
    return metric(records, "system_action_to_present")


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


def system_budget(records: list[dict]) -> tuple[float | None, float | None]:
    """Summarize the budget measured in the compositor trace."""
    return scalar_metric(records, "system_frame_budget_ms")


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

STRICT_FRAME_HEADERS = (
    "动作到显示均值（ms）",
    "动作到显示 P95（ms）",
    "系统帧间隔均值（ms）",
    "系统帧间隔 P95（ms）",
    "系统丢帧数",
    "框架工作均值（诊断）（ms）",
    "框架工作 P95（诊断）（ms）",
)

STRICT_SCROLL_HEADERS = STRICT_FRAME_HEADERS + (
    "离屏均值（诊断）（ms）",
    "离屏 P95（诊断）（ms）",
    "回读均值（诊断）（ms）",
    "回读 P95（诊断）（ms）",
)


def section_headers(kind: str, strict_system: bool) -> tuple[str, ...]:
    headers = SECTION_HEADERS[kind]
    if not strict_system:
        return headers
    if kind == "frame":
        return STRICT_FRAME_HEADERS
    if kind == "scroll":
        return STRICT_SCROLL_HEADERS
    if kind == "input":
        replacements = {
            "可见延迟均值（ms）": "动作到显示均值（ms）",
            "可见延迟 P95（ms）": "动作到显示 P95（ms）",
            "工作均值（ms）": "框架工作均值（诊断）（ms）",
            "工作 P95（ms）": "框架工作 P95（诊断）（ms）",
        }
    else:
        replacements = {
            "首次可交互均值（ms）": "系统首帧显示均值（ms）",
            "首次可交互 P95（ms）": "系统首帧显示 P95（ms）",
            "工作均值（ms）": "框架工作均值（诊断）（ms）",
            "工作 P95（ms）": "框架工作 P95（诊断）（ms）",
        }
    replacements.update({
        "帧间隔均值（ms）": "系统帧间隔均值（ms）",
        "帧间隔 P95（ms）": "系统帧间隔 P95（ms）",
        "丢帧数": "系统丢帧数",
    })
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
    diagnostic_work = work_metric(valid)
    interval = system_metric(valid, "system_present_interval") if strict_system else metric(valid, "frame_interval")
    drop_count = system_dropped(valid) if strict_system else dropped(valid)
    action_to_present = system_action_metric(valid) if strict_system else (None, None)
    if kind == "frame" and strict_system:
        return [
            fmt_number(action_to_present[0]), fmt_number(action_to_present[1]),
            fmt_number(interval[0]), fmt_number(interval[1]),
            str(drop_count) if drop_count is not None else "n/a",
            fmt_number(diagnostic_work[0]), fmt_number(diagnostic_work[1]),
        ]
    if kind == "frame":
        return [fmt_number(work[0]), fmt_number(work[1]), fmt_number(interval[0]), fmt_number(interval[1]), str(drop_count) if drop_count is not None else "n/a"]
    if kind == "input":
        visible = system_metric(valid, "system_input_to_present") if strict_system else metric(valid, "input_to_visible")
        if strict_system:
            return [fmt_number(visible[0]), fmt_number(visible[1]), fmt_number(diagnostic_work[0]), fmt_number(diagnostic_work[1])]
        return [fmt_number(visible[0]), fmt_number(visible[1]), fmt_number(work[0]), fmt_number(work[1])]
    if kind == "open":
        interactive = scalar_metric(valid, "system_first_present_ms") if strict_system else scalar_metric(valid, "first_interactive_ms")
        load = scalar_metric(valid, "document_load_ms")
        return [fmt_number(interactive[0]), fmt_number(interactive[1]), fmt_number(diagnostic_work[0]), fmt_number(diagnostic_work[1]), fmt_number(load[0]), fmt_number(load[1])]
    offscreen = metric(valid, "offscreen")
    readback = metric(valid, "readback")
    if strict_system:
        return [
            fmt_number(action_to_present[0]), fmt_number(action_to_present[1]),
            fmt_number(interval[0]), fmt_number(interval[1]),
            str(drop_count) if drop_count is not None else "n/a",
            fmt_number(diagnostic_work[0]), fmt_number(diagnostic_work[1]),
            fmt_number(offscreen[0]), fmt_number(offscreen[1]),
            fmt_number(readback[0]), fmt_number(readback[1]),
        ]
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


def print_audit_table(
    grouped: dict[tuple[str, str, str], list[dict]],
    strict_system: bool = False,
) -> None:
    """Keep a compact raw-sample audit table for scripts and reviewers."""
    print("<details><summary>原始 ui-frame 汇总（可审计）</summary>\n")
    if strict_system:
        print("| 实现 | 测试集合 | 场景 | 范围 | 动作到显示均值/P95 | 框架工作均值/P95（诊断） | 系统帧间隔均值/P95 | 系统丢帧数 | 系统首帧显示 | 离屏均值（诊断） | 回读均值（诊断） | 状态 |")
        print("| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |")
    else:
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
        dispatch_values = [
            value for record in valid for value in numeric(record.get("dispatch_work_samples_ms"))
        ]
        dispatch = (average(dispatch_values), percentile(dispatch_values, 0.95))
        interval = metric(valid, "frame_interval") if valid else (None, None)
        input_visible = metric(valid, "input_to_visible") if valid else (None, None)
        system_interval = system_metric(valid, "system_present_interval") if strict_system and valid else (None, None)
        action_to_present = system_action_metric(valid) if strict_system and valid else (None, None)
        offscreen = metric(valid, "offscreen") if valid else (None, None)
        readback = metric(valid, "readback") if valid else (None, None)
        if strict_system:
            interactive = first(valid, "system_first_present_ms") if valid else None
            print(
                f"| {adapter} | {fixture} | {scenario} | ui-frame | "
                f"{audit_pair(action_to_present)} | {audit_pair(work)} | {audit_pair(system_interval)} | "
                f"{system_dropped(valid) if valid and system_dropped(valid) is not None else '-'} | {fmt(interactive)} | "
                f"{fmt(offscreen[0])} | {fmt(readback[0])} | {status_text(records)} |"
            )
        else:
            interactive = first(valid, "first_interactive_ms") if valid else None
            drop_count = dropped(valid) if valid else None
            print(
                f"| {adapter} | {fixture} | {scenario} | ui-frame | "
                f"{audit_pair(work)} | {audit_pair(dispatch)} | {audit_pair(interval)} | {audit_pair(input_visible)} | "
                f"{fmt(offscreen[0])} | {fmt(readback[0])} | {fmt(interactive)} | "
                f"{drop_count if drop_count is not None else 'n/a'} | {status_text(records)} |"
            )
    print("\n</details>\n")


def print_anomalies(
    payload: dict,
    grouped: dict[tuple[str, str, str], list[dict]],
    strict_system: bool,
) -> None:
    """Summarize threshold breaches without turning them into pass/fail claims."""
    viewport = payload.get("viewport", {})
    budget = viewport.get("frame_budget_ms")
    if strict_system:
        trace_budgets = scalar_values(
            [record for records in grouped.values() for record in records],
            "system_frame_budget_ms",
        )
        if trace_budgets:
            budget = average(trace_budgets)
    if not isinstance(budget, (int, float)) or isinstance(budget, bool) or budget <= 0:
        refresh = viewport.get("refresh_hz", 60)
        budget = 1000.0 / refresh if isinstance(refresh, (int, float)) and refresh > 0 else 16.667
    interval_field = "system_present_interval" if strict_system else "frame_interval"
    startup_field = "system_first_present_ms" if strict_system else "first_interactive_ms"
    input_field = "system_action_to_present" if strict_system else "input_to_visible"
    drop_fn = system_dropped if strict_system else dropped
    source = "系统 compositor trace" if strict_system else "框架回调诊断（非 compositor 时钟）"
    threshold = budget + 0.1  # absorb timestamp quantization around the budget
    startup: list[str] = []
    input_tail: list[str] = []
    long_frames: dict[str, list[str]] = defaultdict(list)
    drops: dict[str, list[str]] = defaultdict(list)
    for adapter in ADAPTERS:
        for fixture in FIXTURES:
            open_records = measured(grouped.get((adapter, fixture, "open"), []))
            startup_values = scalar_values(open_records, startup_field)
            if startup_values and max(startup_values) > 100.0:
                startup.append(
                    f"{LABELS[adapter]} {fixture} {average(startup_values):.1f} ms（max {max(startup_values):.1f} ms）"
                )
            input_records = measured(grouped.get((adapter, fixture, "input"), []))
            input_values = samples(input_records, input_field)
            input_p95 = percentile(input_values, 0.95)
            if input_p95 is not None and input_p95 > threshold:
                input_tail.append(f"{LABELS[adapter]} {fixture} P95 {input_p95:.2f} ms")
            for scenario in ("input", "scroll"):
                records = measured(grouped.get((adapter, fixture, scenario), []))
                values = samples(records, interval_field)
                breaches = [value for value in values if value > threshold]
                if breaches:
                    long_frames[LABELS[adapter]].append(
                        f"{fixture}/{scenario} {len(breaches)} 次，max {max(breaches):.2f} ms"
                    )
                drop_count = drop_fn(records) if records else None
                if drop_count is not None and drop_count > 0:
                    drops[LABELS[adapter]].append(f"{fixture}/{scenario} {drop_count} 帧")

    print("# 异常项与优化优先级\n")
    print(
        f"- 参考帧预算：`{budget:.3f} ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：{source}。"
    )
    print("- P1 首帧：" + ("；".join(startup) if startup else "未发现 >100 ms 的首帧") + "。")
    print("- P1 输入尾延迟：" + ("；".join(input_tail) if input_tail else "未发现超过一帧预算的输入 P95") + "。")
    long_text = "；".join(
        f"{adapter}: {', '.join(details)}" for adapter, details in long_frames.items()
    )
    drop_text = "；".join(
        f"{adapter}: {', '.join(details)}" for adapter, details in drops.items()
    )
    print("- 长帧（超预算）：" + (long_text if long_text else "未发现超过一帧预算的间隔") + "。")
    print("- 丢帧（优先处理）：" + (drop_text if drop_text else "未发现可测丢帧") + "。")
    print(
        "- 解释：首帧异常优先检查窗口/渲染器初始化；输入尾延迟检查 action 到下一可见帧的调度与同步重建；"
        "长帧检查解析、布局、文本 shaping 和 GPU 提交；`n/a` 表示未埋点，不等于 0。"
    )
    if not strict_system:
        print(
            "- 普通模式的长帧、帧间隔和输入延迟是各框架回调诊断，不能替代跨框架 compositor 排名；"
            "需要严格结论时运行 `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`。"
        )
    print()


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
    refresh = viewport.get("refresh_hz", 60)
    refresh_text = f"{refresh} Hz" if refresh is not None else "trace-derived refresh"
    print(f"- 统一配置：`{viewport.get('width', 1280)}x{viewport.get('height', 800)} @ {refresh_text}`；font `system-ui 16px`；line-height `1.55`；overscan `3`；fixed row `66px`；GPU backend `{payload.get('gpu_backend', 'unknown')}`")
    print("- Fixture：`small=5KB/100 blocks`，`medium=50KB/1,000 blocks`，`large=500KB/10,000 blocks`，`stress=5MB/100,000 blocks`。")
    observed_fixtures = [fixture for fixture in FIXTURES if any(record.get("fixture") == fixture for record in records)]
    print(f"- 本次执行集合：`{', '.join(observed_fixtures) if observed_fixtures else 'none'}`；未执行集合在矩阵中显示 `n/a`，不参与比较。")
    repetitions = sorted({record.get("repetitions") for record in records if isinstance(record.get("repetitions"), int)})
    warmups = sorted({record.get("warmups") for record in records if isinstance(record.get("warmups"), int)})
    repetition_text = repetitions[0] if len(repetitions) == 1 else repetitions
    warmup_text = warmups[0] if len(warmups) == 1 else warmups
    print(f"- 汇总口径：mean/P95 合并原始样本；每格 repetition `{repetition_text}`、process warm-up `{warmup_text}`；drop 为各 repetition {'system_dropped_display_frames' if strict_system else 'dropped_display_frames'} 之和。")
    if strict_system:
        budgets = sorted({round(value, 3) for record in records for value in numeric([record.get("system_frame_budget_ms")])})
        budget_text = ", ".join(f"{value:.3f} ms" for value in budgets) or "n/a"
        print("- 公平性口径：严格模式的帧间隔、丢帧、动作到下一次显示和首帧显示只来自 macOS compositor/display trace；目标 surface 无法被 xctrace 明确关联时显示 `n/a`，绝不回退到框架回调。当前 trace 推导的显示预算：" + budget_text + "。表中的 `动作到显示` 是统一端到端边界；框架内部 work 仅作为诊断，不参与跨实现排名。\n")
    else:
        print("- 公平性口径：所有 ui-frame 记录使用相同 fixture、viewport、动作数、warm-up 和重复次数；数值来自框架真实渲染/提交回调。MoUI ui-frame 是 headless host-surface；GPUI 的 frame work 覆盖 request_layout→prepaint→paint，action dispatch 另列为诊断字段。不同框架的显示时间戳由各自平台 API 提供，因此报告不做跨时钟的综合排名。`n/a` 表示没有采集，绝不等同于 0。\n")

    # Put the audit table first so command-line consumers can locate the
    # legacy-compatible raw summary without parsing the fixture matrix.
    print_audit_table(grouped, strict_system)
    print_section("帧性能", "scroll", "frame", grouped, strict_system)
    print_section("输入延迟", "input", "input", grouped, strict_system)
    print_section("打开性能", "open", "open", grouped, strict_system)
    print_section("滚动性能", "scroll", "scroll", grouped, strict_system)
    print_anomalies(payload, grouped, strict_system)
    print("## 采集口径\n")
    print("- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。")
    print("- `frame_work_ms` 对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。")
    print("- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。")
    print("- `first_interactive_ms` 是首个可交互帧；严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代；打开场景没有前一帧，所以不计算 interval/drop。")
    print("- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。")


if __name__ == "__main__":
    main()
