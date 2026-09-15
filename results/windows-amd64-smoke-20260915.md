# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-14T18:30:54Z`
- 数据状态：`30 measured`，`0 skipped/error`；原始样本保留在 JSON。
- Host：`Windows-11-10.0.26200-SP0` / `AMD64` / `15.89 GiB`；GPU：`OrayIddDriver Device`
- OS：`11`；CPU：`AMD64 Family 25 Model 33 Stepping 2, AuthenticAMD`；toolchains：`python=3.12.10, moon=moon 0.1.20260824 (dae026a 2026-08-24), rustc=rustc 1.92.0 (ded5c06cf 2025-12-08), cargo=cargo 1.92.0 (344c4567c 2025-10-21), node=v22.20.0`
- 统一配置：`1280x800 @ 60 Hz`；font `system-ui 16px`；line-height `1.55`；overscan `3`；fixed row `66px`；GPU backend `Direct3D`
- Fixture：`small=5KB/100 blocks`，`medium=50KB/1,000 blocks`，`large=500KB/10,000 blocks`，`stress=5MB/100,000 blocks`。
- 本次执行集合：`small`；未执行集合在矩阵中显示 `n/a`，不参与比较。
- 汇总口径：mean/P95 合并原始样本；每格 repetition `1`、process warm-up `0`；drop 为各 repetition dropped_display_frames 之和。
- 公平性口径：所有 ui-frame 记录使用相同 fixture、viewport、动作数、warm-up 和重复次数。`工作`（frame_work）统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏：MoUI 为 build+layout+paint+draw，Flutter 为 UI 线程 buildDuration，GPUI 为 request_layout→prepaint→paint，Electron 为 JS 可见的 DOM 更新+layout。设备光栅化与上屏统一单列为 `设备侧`（device_present）：native-window 模式下 MoUI 在真实 Win32 窗口上屏，适配器侧不单独计时设备光栅化，显示 `n/a`，Flutter 为光栅线程 rasterDuration（不含设备完成等待），GPUI 与 Electron 无法在适配器侧观测显示链路，显示 `n/a`。MoUI ui-frame 运行在真实 Win32 窗口（`native-window`），其帧间隔/输入延迟是动作到原生帧观察的 wall-clock 采样（观察节奏约 12 ms），与 GPUI 的 `on_next_frame`、Flutter 的 vsyncStart、Electron 的 rAF 同属框架回调诊断；GPUI 的 action dispatch 另列为诊断字段。不同框架的显示时间戳由各自平台 API 提供，帧间隔覆盖完整链路，报告不做跨时钟的综合排名。`n/a` 表示没有采集，绝不等同于 0。下方各对比表把同平台跨框架可比列（帧间隔/可见延迟/首次可交互/丢帧数等）排在前面，框架内部诊断列（`工作`/`设备侧`）排在后面并标注 `†`。

- `moui-md-*` 行来自 `momark`（MoMark，原 `vendor/MoUI/examples/markdown_editor`）官方示例应用：fixture 通过应用自身的 `OpenRecentDocument` 服务路径打开，渲染经过示例自己的虚拟滚动与富文本缓存实现，不套用简化基准应用的 `fixed row 66px` 统一行高；viewport、fixture、动作数、warm-up 与重复次数与其他行完全一致。严格模式（`UI_BENCHMARK_SYSTEM_TRACE=1`）目前不为 `moui-md-*` 行采集系统 present，这些行会显示 error。

<details><summary>原始 ui-frame 汇总（可审计）</summary>

| 实现 | 测试集合 | 场景 | 范围 | 工作均值/P95 | 仅分发均值/P95 | 帧间隔均值/P95 | 输入到可见均值/P95 | 设备侧均值 | 离屏均值 | 回读均值 | 首次可交互 | 丢帧数 | 状态 |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| moui-skia-raster | small | open | ui-frame | 10.010/10.010 | - | - | - | n/a | n/a | n/a | 63.96 ms | 0 | measured |
| moui-skia-raster | small | input | ui-frame | 2.287/2.484 | - | 30.760/32.620 | 30.659/32.514 | n/a | n/a | n/a | 60.61 ms | 10 | measured |
| moui-skia-raster | small | scroll | ui-frame | 2.606/3.272 | - | 30.668/32.091 | - | n/a | n/a | n/a | 62.28 ms | 120 | measured |
| moui-skia-gpu | small | open | ui-frame | 12.163/12.163 | - | - | - | n/a | n/a | n/a | 803.34 ms | 0 | measured |
| moui-skia-gpu | small | input | ui-frame | 2.469/3.332 | - | 30.472/32.287 | 30.358/32.177 | n/a | n/a | n/a | 809.33 ms | 10 | measured |
| moui-skia-gpu | small | scroll | ui-frame | 2.600/3.546 | - | 29.988/32.362 | - | n/a | n/a | n/a | 813.86 ms | 118 | measured |
| moui-wgpu | small | open | ui-frame | 40.997/40.997 | - | - | - | n/a | n/a | n/a | 1179.44 ms | 0 | measured |
| moui-wgpu | small | input | ui-frame | 5.618/6.777 | - | 30.678/33.024 | 30.576/32.914 | n/a | n/a | n/a | 1184.20 ms | 10 | measured |
| moui-wgpu | small | scroll | ui-frame | 2.941/3.637 | - | 30.583/32.704 | - | n/a | n/a | n/a | 1199.89 ms | 123 | measured |
| moui-md-skia-raster | small | open | ui-frame | 16.089/16.089 | - | - | - | n/a | n/a | n/a | 80.88 ms | 0 | measured |
| moui-md-skia-raster | small | input | ui-frame | 4.208/4.654 | - | 30.451/32.048 | 30.365/31.957 | n/a | n/a | n/a | 79.48 ms | 10 | measured |
| moui-md-skia-raster | small | scroll | ui-frame | 5.078/6.455 | - | 30.702/34.030 | - | n/a | n/a | n/a | 77.22 ms | 134 | measured |
| moui-md-skia-gpu | small | open | ui-frame | 14.711/14.711 | - | - | - | n/a | n/a | n/a | 994.36 ms | 0 | measured |
| moui-md-skia-gpu | small | input | ui-frame | 4.241/7.100 | - | 59.565/67.573 | 59.470/67.572 | n/a | n/a | n/a | 988.36 ms | 30 | measured |
| moui-md-skia-gpu | small | scroll | ui-frame | 5.234/6.583 | - | 46.209/50.372 | - | n/a | n/a | n/a | 970.29 ms | 249 | measured |
| moui-md-wgpu | small | open | ui-frame | 53.442/53.442 | - | - | - | n/a | n/a | n/a | 1231.98 ms | 0 | measured |
| moui-md-wgpu | small | input | ui-frame | 7.877/8.855 | - | 30.460/32.350 | 30.364/32.239 | n/a | n/a | n/a | 1239.45 ms | 10 | measured |
| moui-md-wgpu | small | scroll | ui-frame | 6.401/8.349 | - | 31.600/38.585 | - | n/a | n/a | n/a | 1252.87 ms | 180 | measured |
| gpmark | small | open | ui-frame | 1.149/1.149 | - | - | - | n/a | n/a | n/a | 241.81 ms | n/a | measured |
| gpmark | small | input | ui-frame | 1.225/1.395 | 0.443/0.544 | 30.740/32.660 | 30.738/32.657 | n/a | n/a | n/a | 246.66 ms | n/a | measured |
| gpmark | small | scroll | ui-frame | 1.746/2.199 | 0.001/0.001 | 30.684/31.757 | - | n/a | n/a | n/a | 246.47 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 0.512/0.512 | - | - | - | 75.59 ms | n/a | n/a | 29.00 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 0.845/1.009 | - | 6.945/6.945 | 7.128/9.396 | 0.53 ms | n/a | n/a | 31.00 ms | 0 | measured |
| flutter-skia | small | scroll | ui-frame | 2.463/3.192 | - | 7.060/6.945 | - | 0.47 ms | n/a | n/a | 30.00 ms | 0 | measured |
| flutter-impeller | small | open | ui-frame | 0.489/0.489 | - | - | - | 57.79 ms | n/a | n/a | 35.00 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 0.826/0.986 | - | 6.945/6.945 | 7.215/8.546 | 1.43 ms | n/a | n/a | 29.00 ms | 0 | measured |
| flutter-impeller | small | scroll | ui-frame | 2.645/3.456 | - | 7.060/6.945 | - | 1.17 ms | n/a | n/a | 31.00 ms | 0 | measured |
| electron | small | open | ui-frame | 1359.000/1359.000 | - | - | - | n/a | n/a | n/a | 1359.00 ms | 0 | measured |
| electron | small | input | ui-frame | 3.180/5.000 | - | 8.461/14.900 | 7.610/14.700 | n/a | n/a | n/a | 1285.00 ms | 0 | measured |
| electron | small | scroll | ui-frame | 3.168/4.600 | - | 7.740/7.700 | - | n/a | n/a | n/a | 1266.00 ms | 0 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 30.67/n/a/n/a | 32.09/n/a/n/a | 120/n/a/n/a | 2.61/n/a/n/a | 3.27/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 29.99/n/a/n/a | 32.36/n/a/n/a | 118/n/a/n/a | 2.60/n/a/n/a | 3.55/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 30.58/n/a/n/a | 32.70/n/a/n/a | 123/n/a/n/a | 2.94/n/a/n/a | 3.64/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 30.70/n/a/n/a | 34.03/n/a/n/a | 134/n/a/n/a | 5.08/n/a/n/a | 6.46/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 46.21/n/a/n/a | 50.37/n/a/n/a | 249/n/a/n/a | 5.23/n/a/n/a | 6.58/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 31.60/n/a/n/a | 38.58/n/a/n/a | 180/n/a/n/a | 6.40/n/a/n/a | 8.35/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 30.68/n/a/n/a | 31.76/n/a/n/a | n/a/n/a/n/a | 1.75/n/a/n/a | 2.20/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.06/n/a/n/a | 6.95/n/a/n/a | 0/n/a/n/a | 2.46/n/a/n/a | 3.19/n/a/n/a | 0.47/n/a/n/a | 0.60/n/a/n/a |
| Flutter Impeller | 7.06/n/a/n/a | 6.95/n/a/n/a | 0/n/a/n/a | 2.64/n/a/n/a | 3.46/n/a/n/a | 1.17/n/a/n/a | 1.38/n/a/n/a |
| Electron | 7.74/n/a/n/a | 7.70/n/a/n/a | 0/n/a/n/a | 3.17/n/a/n/a | 4.60/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI Skia GPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI WGPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoMark Skia Raster | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoMark Skia GPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoMark WGPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| GpMark.mbt (GPUI) | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Skia | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Impeller | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Electron | n/a | n/a | n/a | n/a | n/a | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 30.66/n/a/n/a | 32.51/n/a/n/a | 2.29/n/a/n/a | 2.48/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 30.36/n/a/n/a | 32.18/n/a/n/a | 2.47/n/a/n/a | 3.33/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 30.58/n/a/n/a | 32.91/n/a/n/a | 5.62/n/a/n/a | 6.78/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 30.37/n/a/n/a | 31.96/n/a/n/a | 4.21/n/a/n/a | 4.65/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 59.47/n/a/n/a | 67.57/n/a/n/a | 4.24/n/a/n/a | 7.10/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 30.36/n/a/n/a | 32.24/n/a/n/a | 7.88/n/a/n/a | 8.85/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 30.74/n/a/n/a | 32.66/n/a/n/a | 1.22/n/a/n/a | 1.39/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.13/n/a/n/a | 9.40/n/a/n/a | 0.84/n/a/n/a | 1.01/n/a/n/a | 0.53/n/a/n/a | 0.64/n/a/n/a |
| Flutter Impeller | 7.22/n/a/n/a | 8.55/n/a/n/a | 0.83/n/a/n/a | 0.99/n/a/n/a | 1.43/n/a/n/a | 2.17/n/a/n/a |
| Electron | 7.61/n/a/n/a | 14.70/n/a/n/a | 3.18/n/a/n/a | 5.00/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI Skia GPU | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI WGPU | n/a | n/a | n/a | n/a | n/a | n/a |
| MoMark Skia Raster | n/a | n/a | n/a | n/a | n/a | n/a |
| MoMark Skia GPU | n/a | n/a | n/a | n/a | n/a | n/a |
| MoMark WGPU | n/a | n/a | n/a | n/a | n/a | n/a |
| GpMark.mbt (GPUI) | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Skia | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Impeller | n/a | n/a | n/a | n/a | n/a | n/a |
| Electron | n/a | n/a | n/a | n/a | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 63.96/n/a/n/a | 63.96/n/a/n/a | 0.30/n/a/n/a | 0.30/n/a/n/a | 10.01/n/a/n/a | 10.01/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 803.34/n/a/n/a | 803.34/n/a/n/a | 0.16/n/a/n/a | 0.16/n/a/n/a | 12.16/n/a/n/a | 12.16/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 1179.44/n/a/n/a | 1179.44/n/a/n/a | 0.17/n/a/n/a | 0.17/n/a/n/a | 41.00/n/a/n/a | 41.00/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 80.88/n/a/n/a | 80.88/n/a/n/a | 0.13/n/a/n/a | 0.13/n/a/n/a | 16.09/n/a/n/a | 16.09/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 994.36/n/a/n/a | 994.36/n/a/n/a | 0.13/n/a/n/a | 0.13/n/a/n/a | 14.71/n/a/n/a | 14.71/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 1231.98/n/a/n/a | 1231.98/n/a/n/a | 0.14/n/a/n/a | 0.14/n/a/n/a | 53.44/n/a/n/a | 53.44/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 241.81/n/a/n/a | 241.81/n/a/n/a | 0.00/n/a/n/a | 0.00/n/a/n/a | 1.15/n/a/n/a | 1.15/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 29.00/n/a/n/a | 29.00/n/a/n/a | 0.75/n/a/n/a | 0.75/n/a/n/a | 0.51/n/a/n/a | 0.51/n/a/n/a | 75.59/n/a/n/a | 75.59/n/a/n/a |
| Flutter Impeller | 35.00/n/a/n/a | 35.00/n/a/n/a | 0.92/n/a/n/a | 0.92/n/a/n/a | 0.49/n/a/n/a | 0.49/n/a/n/a | 57.79/n/a/n/a | 57.79/n/a/n/a |
| Electron | 1359.00/n/a/n/a | 1359.00/n/a/n/a | 3.46/n/a/n/a | 3.46/n/a/n/a | 1359.00/n/a/n/a | 1359.00/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI Skia GPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI WGPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoMark Skia Raster | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoMark Skia GPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoMark WGPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| GpMark.mbt (GPUI) | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Skia | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Impeller | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Electron | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 30.67/n/a/n/a | 32.09/n/a/n/a | 120/n/a/n/a | 2.61/n/a/n/a | 3.27/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 29.99/n/a/n/a | 32.36/n/a/n/a | 118/n/a/n/a | 2.60/n/a/n/a | 3.55/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 30.58/n/a/n/a | 32.70/n/a/n/a | 123/n/a/n/a | 2.94/n/a/n/a | 3.64/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 30.70/n/a/n/a | 34.03/n/a/n/a | 134/n/a/n/a | 5.08/n/a/n/a | 6.46/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 46.21/n/a/n/a | 50.37/n/a/n/a | 249/n/a/n/a | 5.23/n/a/n/a | 6.58/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 31.60/n/a/n/a | 38.58/n/a/n/a | 180/n/a/n/a | 6.40/n/a/n/a | 8.35/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 30.68/n/a/n/a | 31.76/n/a/n/a | n/a/n/a/n/a | 1.75/n/a/n/a | 2.20/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.06/n/a/n/a | 6.95/n/a/n/a | 0/n/a/n/a | 2.46/n/a/n/a | 3.19/n/a/n/a | 0.47/n/a/n/a | 0.60/n/a/n/a |
| Flutter Impeller | 7.06/n/a/n/a | 6.95/n/a/n/a | 0/n/a/n/a | 2.64/n/a/n/a | 3.46/n/a/n/a | 1.17/n/a/n/a | 1.38/n/a/n/a |
| Electron | 7.74/n/a/n/a | 7.70/n/a/n/a | 0/n/a/n/a | 3.17/n/a/n/a | 4.60/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI Skia GPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI WGPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoMark Skia Raster | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoMark Skia GPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoMark WGPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| GpMark.mbt (GPUI) | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Skia | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Impeller | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Electron | n/a | n/a | n/a | n/a | n/a | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoUI Skia GPU small 803.3 ms（max 803.3 ms）；MoUI WGPU small 1179.4 ms（max 1179.4 ms）；MoMark Skia GPU small 994.4 ms（max 994.4 ms）；MoMark WGPU small 1232.0 ms（max 1232.0 ms）；GpMark.mbt (GPUI) small 241.8 ms（max 241.8 ms）；Electron small 1359.0 ms（max 1359.0 ms）。
- P1 输入尾延迟：MoUI Skia Raster CPU small P95 32.51 ms；MoUI Skia GPU small P95 32.18 ms；MoUI WGPU small P95 32.91 ms；MoMark Skia Raster small P95 31.96 ms；MoMark Skia GPU small P95 67.57 ms；MoMark WGPU small P95 32.24 ms；GpMark.mbt (GPUI) small P95 32.66 ms。
- 长帧（超预算）：MoUI Skia Raster CPU: small/input 10 次，max 32.62 ms, small/scroll 120 次，max 32.96 ms；MoUI Skia GPU: small/input 10 次，max 32.29 ms, small/scroll 116 次，max 33.72 ms；MoUI WGPU: small/input 10 次，max 33.02 ms, small/scroll 120 次，max 35.66 ms；MoMark Skia Raster: small/input 10 次，max 32.05 ms, small/scroll 120 次，max 37.03 ms；MoMark Skia GPU: small/input 10 次，max 67.57 ms, small/scroll 120 次，max 57.27 ms；MoMark WGPU: small/input 10 次，max 32.35 ms, small/scroll 120 次，max 43.62 ms；GpMark.mbt (GPUI): small/input 10 次，max 32.66 ms, small/scroll 120 次，max 32.74 ms。
- 丢帧（优先处理）：MoUI Skia Raster CPU: small/input 10 帧, small/scroll 120 帧；MoUI Skia GPU: small/input 10 帧, small/scroll 118 帧；MoUI WGPU: small/input 10 帧, small/scroll 123 帧；MoMark Skia Raster: small/input 10 帧, small/scroll 134 帧；MoMark Skia GPU: small/input 30 帧, small/scroll 249 帧；MoMark WGPU: small/input 10 帧, small/scroll 180 帧。
- 解释：首帧异常优先检查窗口/渲染器初始化；输入尾延迟检查 action 到下一可见帧的调度与同步重建；长帧检查解析、布局、文本 shaping 和 GPU 提交；`n/a` 表示未埋点，不等于 0。
- 普通模式的长帧、帧间隔和输入延迟是各框架回调诊断，不能替代跨框架 compositor 排名；需要严格结论时运行 `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`。

## 采集口径

- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。
- `frame_work_ms` 统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏；对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `device_present_ms`：设备/上屏侧统一字段。MoUI raster 为 Skia CPU 光栅化+像素回读整体；MoUI GPU/wgpu 为提交后同步等待设备完成（headless host-surface 逐帧同步，真实应用的 vsync 流水线可重叠掉一部分，该值应视为上屏成本上界）；窗口模式（`window_mode=native-window`）下 MoUI 由真实 Win32 窗口上屏，适配器侧不单独计时，显示 `n/a`；Flutter 为 `FrameTiming.rasterDuration`（光栅线程任务时间，含显示列表光栅化与 GPU 提交、不含设备完成等待）；GPUI 与 Electron 适配器侧无法观测，显示 `n/a`。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧，统一口径为「进程起点 → 首帧可交互」（全包含）：MoUI 在 main 入口打点（含渲染器构建，headless 无平台窗口成本）；Flutter 优先取 runner 在进程起点打点的 epoch（env 缺失时退回 Dart 最早时刻，Flutter 引擎与原生窗口创建计入）；Electron 取 main.js 首个 JS 时刻（Chromium 主进程初始化、窗口创建与页面加载计入）；GPUI 从 MoonBit main 入口打点（Win32 初始化、Direct3D 渲染器与首帧计入）。打开场景没有前一帧，所以不计算 interval/drop。严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代。
- 跨框架比较注意：MoUI/MoMark 系列与 Flutter/Electron/GPUI 现默认同为原生窗口（native-window）模式，时钟同为进程起点 → 首帧可交互；旧 headless host-surface 模式可用 `UI_BENCHMARK_HEADLESS=1` 复现（无真实窗口/合成器成本，帧间隔为未同步的帧生产耗时，与窗口模式的 vsync 间隔语义不同）。GPUI 另可用 `GPUI_OPEN_TRACE=1` 输出启动分相（应用初始化 / 窗口创建 / 首帧）。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。
