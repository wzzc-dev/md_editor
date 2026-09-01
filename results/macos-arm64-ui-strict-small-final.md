# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-08-30T17:15:27Z`
- 数据状态：`21 measured`，`0 skipped/error`；原始样本保留在 JSON。
- Host：`macOS-26.3-arm64-arm-64bit` / `arm64` / `16.0 GiB`；GPU：`Apple M4`
- OS：`25.3.0`；CPU：`arm`；toolchains：`python=3.12.11, moon=moon 0.1.20260824 (dae026a 2026-08-24), rustc=rustc 1.94.0 (4a4ef493e 2026-03-02), cargo=cargo 1.94.0 (85eff7c80 2026-01-15), node=v25.2.1, npm=11.6.2, flutter=Flutter 3.47.1 • channel stable • https://github.com/flutter/flutter.git`
- 统一配置：`1280x800 @ trace-derived refresh`；font `system-ui 16px`；line-height `1.55`；overscan `3`；fixed row `66px`；GPU backend `Metal`
- Fixture：`small=5KB/100 blocks`，`medium=50KB/1,000 blocks`，`large=500KB/10,000 blocks`，`stress=5MB/100,000 blocks`。
- 本次执行集合：`small`；未执行集合在矩阵中显示 `n/a`，不参与比较。
- 汇总口径：mean/P95 合并原始样本；每格 repetition `1`、process warm-up `0`；drop 为各 repetition system_dropped_display_frames 之和。
- 公平性口径：严格模式的帧间隔、丢帧、动作到下一次显示和首帧显示只来自 macOS compositor/display trace；目标 surface 无法被 xctrace 明确关联时显示 `n/a`，绝不回退到框架回调。当前 trace 推导的显示预算：10.000 ms。表中的 `动作到显示` 是统一端到端边界；框架内部 work 仅作为诊断，不参与跨实现排名。

<details><summary>原始 ui-frame 汇总（可审计）</summary>

| 实现 | 测试集合 | 场景 | 范围 | 动作到显示均值/P95 | 框架工作均值/P95（诊断） | 系统帧间隔均值/P95 | 系统丢帧数 | 系统首帧显示 | 离屏均值（诊断） | 回读均值（诊断） | 状态 |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| moui-skia-raster | small | open | ui-frame | - | 0.025/0.025 | - | 0 | 1002.62 ms | n/a | n/a | measured |
| moui-skia-raster | small | input | ui-frame | 5.417/9.353 | 0.695/0.831 | 10.000/10.000 | 0 | 930.63 ms | n/a | n/a | measured |
| moui-skia-raster | small | scroll | ui-frame | 6.973/9.350 | 0.522/0.583 | 10.055/10.000 | 2 | 943.58 ms | n/a | n/a | measured |
| moui-skia-gpu | small | open | ui-frame | - | 0.011/0.011 | - | 0 | 677.49 ms | n/a | n/a | measured |
| moui-skia-gpu | small | input | ui-frame | 5.555/9.341 | 0.737/0.879 | 10.000/10.000 | 0 | 1145.22 ms | n/a | n/a | measured |
| moui-skia-gpu | small | scroll | ui-frame | 5.808/9.373 | 0.529/0.619 | 10.000/10.000 | 0 | 953.23 ms | n/a | n/a | measured |
| moui-wgpu | small | open | ui-frame | - | 212.588/212.588 | - | 0 | 957.76 ms | n/a | n/a | measured |
| moui-wgpu | small | input | ui-frame | 4.510/8.467 | 0.884/0.992 | 10.000/10.000 | 0 | 902.69 ms | n/a | n/a | measured |
| moui-wgpu | small | scroll | ui-frame | 5.927/9.392 | 0.842/1.306 | 10.000/10.000 | 0 | 1094.76 ms | n/a | n/a | measured |
| gpui | small | open | ui-frame | - | 30.342/30.342 | - | 0 | 1844.69 ms | n/a | n/a | measured |
| gpui | small | input | ui-frame | 2.858/4.932 | 1.908/2.108 | 10.000/10.000 | 0 | 737.84 ms | n/a | n/a | measured |
| gpui | small | scroll | ui-frame | 3.580/4.946 | 2.410/3.374 | 10.173/10.000 | 2 | 953.26 ms | n/a | n/a | measured |
| flutter-skia | small | open | ui-frame | - | 90.763/90.763 | - | 0 | 1073.35 ms | n/a | n/a | measured |
| flutter-skia | small | input | ui-frame | 8.357/8.911 | 2.040/3.384 | 10.000/10.000 | 0 | 802.32 ms | n/a | n/a | measured |
| flutter-skia | small | scroll | ui-frame | 8.341/8.742 | 1.575/3.060 | 10.000/10.000 | 0 | 1017.36 ms | n/a | n/a | measured |
| flutter-impeller | small | open | ui-frame | - | 118.390/118.390 | - | 0 | 717.21 ms | n/a | n/a | measured |
| flutter-impeller | small | input | ui-frame | 6.880/8.681 | 2.161/2.771 | 10.000/10.000 | 0 | 996.32 ms | n/a | n/a | measured |
| flutter-impeller | small | scroll | ui-frame | 446.181/967.415 | 1.519/2.122 | 10.000/10.000 | 0 | 1928.72 ms | n/a | n/a | measured |
| electron | small | open | ui-frame | - | 104.700/104.700 | - | 0 | 1124.85 ms | n/a | n/a | measured |
| electron | small | input | ui-frame | 2.997/3.263 | 2.100/2.500 | 10.000/10.000 | 0 | 1093.94 ms | n/a | n/a | measured |
| electron | small | scroll | ui-frame | 2.805/4.641 | 1.868/2.400 | 10.000/10.000 | 0 | 1303.38 ms | n/a | n/a | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 动作到显示均值（ms） | 动作到显示 P95（ms） | 系统帧间隔均值（ms） | 系统帧间隔 P95（ms） | 系统丢帧数 | 框架工作均值（诊断）（ms） | 框架工作 P95（诊断）（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.97/n/a/n/a | 9.35/n/a/n/a | 10.06/n/a/n/a | 10.00/n/a/n/a | 2/n/a/n/a | 0.52/n/a/n/a | 0.58/n/a/n/a |
| MoUI Skia GPU | 5.81/n/a/n/a | 9.37/n/a/n/a | 10.00/n/a/n/a | 10.00/n/a/n/a | 0/n/a/n/a | 0.53/n/a/n/a | 0.62/n/a/n/a |
| MoUI WGPU | 5.93/n/a/n/a | 9.39/n/a/n/a | 10.00/n/a/n/a | 10.00/n/a/n/a | 0/n/a/n/a | 0.84/n/a/n/a | 1.31/n/a/n/a |
| GPUI | 3.58/n/a/n/a | 4.95/n/a/n/a | 10.17/n/a/n/a | 10.00/n/a/n/a | 2/n/a/n/a | 2.41/n/a/n/a | 3.37/n/a/n/a |
| Flutter Skia | 8.34/n/a/n/a | 8.74/n/a/n/a | 10.00/n/a/n/a | 10.00/n/a/n/a | 0/n/a/n/a | 1.57/n/a/n/a | 3.06/n/a/n/a |
| Flutter Impeller | 446.18/n/a/n/a | 967.41/n/a/n/a | 10.00/n/a/n/a | 10.00/n/a/n/a | 0/n/a/n/a | 1.52/n/a/n/a | 2.12/n/a/n/a |
| Electron | 2.81/n/a/n/a | 4.64/n/a/n/a | 10.00/n/a/n/a | 10.00/n/a/n/a | 0/n/a/n/a | 1.87/n/a/n/a | 2.40/n/a/n/a |

## stress 5MB

| 实现 | 动作到显示均值（ms） | 动作到显示 P95（ms） | 系统帧间隔均值（ms） | 系统帧间隔 P95（ms） | 系统丢帧数 | 框架工作均值（诊断）（ms） | 框架工作 P95（诊断）（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI Skia GPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI WGPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| GPUI | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Skia | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Impeller | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Electron | n/a | n/a | n/a | n/a | n/a | n/a | n/a |

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 动作到显示均值（ms） | 动作到显示 P95（ms） | 框架工作均值（诊断）（ms） | 框架工作 P95（诊断）（ms） |
| --- | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 5.42/n/a/n/a | 9.35/n/a/n/a | 0.69/n/a/n/a | 0.83/n/a/n/a |
| MoUI Skia GPU | 5.56/n/a/n/a | 9.34/n/a/n/a | 0.74/n/a/n/a | 0.88/n/a/n/a |
| MoUI WGPU | 4.51/n/a/n/a | 8.47/n/a/n/a | 0.88/n/a/n/a | 0.99/n/a/n/a |
| GPUI | 2.86/n/a/n/a | 4.93/n/a/n/a | 1.91/n/a/n/a | 2.11/n/a/n/a |
| Flutter Skia | 8.36/n/a/n/a | 8.91/n/a/n/a | 2.04/n/a/n/a | 3.38/n/a/n/a |
| Flutter Impeller | 6.88/n/a/n/a | 8.68/n/a/n/a | 2.16/n/a/n/a | 2.77/n/a/n/a |
| Electron | 3.00/n/a/n/a | 3.26/n/a/n/a | 2.10/n/a/n/a | 2.50/n/a/n/a |

## stress 5MB

| 实现 | 动作到显示均值（ms） | 动作到显示 P95（ms） | 框架工作均值（诊断）（ms） | 框架工作 P95（诊断）（ms） |
| --- | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | n/a | n/a | n/a | n/a |
| MoUI Skia GPU | n/a | n/a | n/a | n/a |
| MoUI WGPU | n/a | n/a | n/a | n/a |
| GPUI | n/a | n/a | n/a | n/a |
| Flutter Skia | n/a | n/a | n/a | n/a |
| Flutter Impeller | n/a | n/a | n/a | n/a |
| Electron | n/a | n/a | n/a | n/a |

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 系统首帧显示均值（ms） | 系统首帧显示 P95（ms） | 框架工作均值（诊断）（ms） | 框架工作 P95（诊断）（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1002.62/n/a/n/a | 1002.62/n/a/n/a | 0.03/n/a/n/a | 0.03/n/a/n/a | 0.64/n/a/n/a | 0.64/n/a/n/a |
| MoUI Skia GPU | 677.49/n/a/n/a | 677.49/n/a/n/a | 0.01/n/a/n/a | 0.01/n/a/n/a | 0.36/n/a/n/a | 0.36/n/a/n/a |
| MoUI WGPU | 957.76/n/a/n/a | 957.76/n/a/n/a | 212.59/n/a/n/a | 212.59/n/a/n/a | 0.33/n/a/n/a | 0.33/n/a/n/a |
| GPUI | 1844.69/n/a/n/a | 1844.69/n/a/n/a | 30.34/n/a/n/a | 30.34/n/a/n/a | 1.00/n/a/n/a | 1.00/n/a/n/a |
| Flutter Skia | 1073.35/n/a/n/a | 1073.35/n/a/n/a | 90.76/n/a/n/a | 90.76/n/a/n/a | 0.42/n/a/n/a | 0.42/n/a/n/a |
| Flutter Impeller | 717.21/n/a/n/a | 717.21/n/a/n/a | 118.39/n/a/n/a | 118.39/n/a/n/a | 0.41/n/a/n/a | 0.41/n/a/n/a |
| Electron | 1124.85/n/a/n/a | 1124.85/n/a/n/a | 104.70/n/a/n/a | 104.70/n/a/n/a | 29.14/n/a/n/a | 29.14/n/a/n/a |

## stress 5MB

| 实现 | 系统首帧显示均值（ms） | 系统首帧显示 P95（ms） | 框架工作均值（诊断）（ms） | 框架工作 P95（诊断）（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI Skia GPU | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI WGPU | n/a | n/a | n/a | n/a | n/a | n/a |
| GPUI | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Skia | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Impeller | n/a | n/a | n/a | n/a | n/a | n/a |
| Electron | n/a | n/a | n/a | n/a | n/a | n/a |

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 动作到显示均值（ms） | 动作到显示 P95（ms） | 系统帧间隔均值（ms） | 系统帧间隔 P95（ms） | 系统丢帧数 | 框架工作均值（诊断）（ms） | 框架工作 P95（诊断）（ms） | 离屏均值（诊断）（ms） | 离屏 P95（诊断）（ms） | 回读均值（诊断）（ms） | 回读 P95（诊断）（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.97/n/a/n/a | 9.35/n/a/n/a | 10.06/n/a/n/a | 10.00/n/a/n/a | 2/n/a/n/a | 0.52/n/a/n/a | 0.58/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 5.81/n/a/n/a | 9.37/n/a/n/a | 10.00/n/a/n/a | 10.00/n/a/n/a | 0/n/a/n/a | 0.53/n/a/n/a | 0.62/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 5.93/n/a/n/a | 9.39/n/a/n/a | 10.00/n/a/n/a | 10.00/n/a/n/a | 0/n/a/n/a | 0.84/n/a/n/a | 1.31/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| GPUI | 3.58/n/a/n/a | 4.95/n/a/n/a | 10.17/n/a/n/a | 10.00/n/a/n/a | 2/n/a/n/a | 2.41/n/a/n/a | 3.37/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 8.34/n/a/n/a | 8.74/n/a/n/a | 10.00/n/a/n/a | 10.00/n/a/n/a | 0/n/a/n/a | 1.57/n/a/n/a | 3.06/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Impeller | 446.18/n/a/n/a | 967.41/n/a/n/a | 10.00/n/a/n/a | 10.00/n/a/n/a | 0/n/a/n/a | 1.52/n/a/n/a | 2.12/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Electron | 2.81/n/a/n/a | 4.64/n/a/n/a | 10.00/n/a/n/a | 10.00/n/a/n/a | 0/n/a/n/a | 1.87/n/a/n/a | 2.40/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |

## stress 5MB

| 实现 | 动作到显示均值（ms） | 动作到显示 P95（ms） | 系统帧间隔均值（ms） | 系统帧间隔 P95（ms） | 系统丢帧数 | 框架工作均值（诊断）（ms） | 框架工作 P95（诊断）（ms） | 离屏均值（诊断）（ms） | 离屏 P95（诊断）（ms） | 回读均值（诊断）（ms） | 回读 P95（诊断）（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI Skia GPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI WGPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| GPUI | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Skia | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Impeller | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Electron | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |

## 采集口径

- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。
- `frame_work_ms` 对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧；严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代；打开场景没有前一帧，所以不计算 interval/drop。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。
