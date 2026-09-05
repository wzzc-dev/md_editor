# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-05T14:03:04Z`
- 数据状态：`27 measured`，`3 skipped/error`；原始样本保留在 JSON。
- Host：`Windows-11-10.0.26200-SP0` / `AMD64` / `15.89 GiB`；GPU：`OrayIddDriver Device`
- OS：`11`；CPU：`AMD64 Family 25 Model 33 Stepping 2, AuthenticAMD`；toolchains：`python=3.12.10, moon=moon 0.1.20260824 (dae026a 2026-08-24), rustc=rustc 1.92.0 (ded5c06cf 2025-12-08), cargo=cargo 1.92.0 (344c4567c 2025-10-21), node=v22.20.0`
- 统一配置：`1280x800 @ 60 Hz`；font `system-ui 16px`；line-height `1.55`；overscan `3`；fixed row `66px`；GPU backend `Direct3D`
- Fixture：`small=5KB/100 blocks`，`medium=50KB/1,000 blocks`，`large=500KB/10,000 blocks`，`stress=5MB/100,000 blocks`。
- 本次执行集合：`small`；未执行集合在矩阵中显示 `n/a`，不参与比较。
- 汇总口径：mean/P95 合并原始样本；每格 repetition `1`、process warm-up `0`；drop 为各 repetition dropped_display_frames 之和。
- 公平性口径：所有 ui-frame 记录使用相同 fixture、viewport、动作数、warm-up 和重复次数。`工作`（frame_work）统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏：MoUI 为 build+layout+paint+draw，Flutter 为 UI 线程 buildDuration，GPUI 为 request_layout→prepaint→paint，Electron 为 JS 可见的 DOM 更新+layout。设备光栅化与上屏统一单列为 `设备侧`（device_present）：MoUI 为同步光栅化/present 完成（无头 harness 逐帧同步，无流水线重叠），Flutter 为光栅线程 rasterDuration（不含设备完成等待），GPUI 与 Electron 无法在适配器侧观测显示链路，显示 `n/a`。MoUI ui-frame 是 headless host-surface；GPUI 的 action dispatch 另列为诊断字段。不同框架的显示时间戳由各自平台 API 提供，帧间隔覆盖完整链路，报告不做跨时钟的综合排名。`n/a` 表示没有采集，绝不等同于 0。

- `moui-md-*` 行来自 `momark`（MoMark，原 `vendor/MoUI/examples/markdown_editor`）官方示例应用：fixture 通过应用自身的 `OpenRecentDocument` 服务路径打开，渲染经过示例自己的虚拟滚动与富文本缓存实现，不套用简化基准应用的 `fixed row 66px` 统一行高；viewport、fixture、动作数、warm-up 与重复次数与其他行完全一致。严格模式（`UI_BENCHMARK_SYSTEM_TRACE=1`）目前不为 `moui-md-*` 行采集系统 present，这些行会显示 error。

<details><summary>原始 ui-frame 汇总（可审计）</summary>

| 实现 | 测试集合 | 场景 | 范围 | 工作均值/P95 | 仅分发均值/P95 | 帧间隔均值/P95 | 输入到可见均值/P95 | 设备侧均值 | 离屏均值 | 回读均值 | 首次可交互 | 丢帧数 | 状态 |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| moui-skia-raster | small | open | ui-frame | 33.195/33.195 | - | - | - | 7.78 ms | 0.00 ms | 7.78 ms | 45.47 ms | n/a | measured |
| moui-skia-raster | small | input | ui-frame | 1.711/1.916 | - | 4.195/4.691 | 4.194/4.689 | 1.99 ms | 0.00 ms | 1.99 ms | 45.99 ms | n/a | measured |
| moui-skia-raster | small | scroll | ui-frame | 3.452/6.088 | - | 6.560/10.185 | - | 1.98 ms | 0.00 ms | 1.98 ms | 49.43 ms | n/a | measured |
| moui-skia-gpu | small | open | ui-frame | 29.886/29.886 | - | - | - | 66.41 ms | 0.00 ms | 66.41 ms | 100.62 ms | n/a | measured |
| moui-skia-gpu | small | input | ui-frame | 1.980/2.421 | - | 12.771/15.207 | 12.769/15.207 | 10.18 ms | 0.00 ms | 10.18 ms | 97.22 ms | n/a | measured |
| moui-skia-gpu | small | scroll | ui-frame | 3.454/6.067 | - | 6.949/10.643 | - | 2.39 ms | 0.00 ms | 2.39 ms | 92.80 ms | n/a | measured |
| moui-wgpu | small | open | ui-frame | 140.156/140.156 | - | - | - | 41.98 ms | n/a | 0.00 ms | 188.60 ms | n/a | measured |
| moui-wgpu | small | input | ui-frame | 5.014/6.592 | - | 11.113/13.933 | 11.112/13.933 | 5.48 ms | n/a | 0.00 ms | 173.27 ms | n/a | measured |
| moui-wgpu | small | scroll | ui-frame | 3.983/6.236 | - | 9.037/12.276 | - | 3.86 ms | n/a | 0.00 ms | 179.48 ms | n/a | measured |
| moui-md-skia-raster | small | open | ui-frame | 42.801/42.801 | - | - | - | 12.88 ms | 0.00 ms | 12.88 ms | 63.01 ms | n/a | measured |
| moui-md-skia-raster | small | input | ui-frame | 5.650/6.553 | - | 12.699/13.824 | 12.616/13.823 | 6.11 ms | 0.00 ms | 6.11 ms | 67.32 ms | n/a | measured |
| moui-md-skia-raster | small | scroll | ui-frame | 3.371/4.309 | - | 9.944/11.882 | - | 6.04 ms | 0.00 ms | 6.04 ms | 61.31 ms | n/a | measured |
| moui-md-skia-gpu | small | open | ui-frame | 47.487/47.487 | - | - | - | 308.39 ms | 0.00 ms | 308.39 ms | 362.12 ms | n/a | measured |
| moui-md-skia-gpu | small | input | ui-frame | 5.391/6.215 | - | 38.322/39.414 | 38.236/39.411 | 31.87 ms | 0.00 ms | 31.87 ms | 280.40 ms | n/a | measured |
| moui-md-skia-gpu | small | scroll | ui-frame | 3.499/4.528 | - | 28.519/31.088 | - | 24.42 ms | 0.00 ms | 24.42 ms | 262.37 ms | n/a | measured |
| moui-md-wgpu | small | open | ui-frame | 156.079/156.079 | - | - | - | 45.87 ms | n/a | 0.00 ms | 207.89 ms | n/a | measured |
| moui-md-wgpu | small | input | ui-frame | 24.011/27.763 | - | 31.765/35.376 | 31.678/35.375 | 6.78 ms | n/a | 0.00 ms | 217.40 ms | n/a | measured |
| moui-md-wgpu | small | scroll | ui-frame | 4.437/5.707 | - | 11.540/13.922 | - | 6.59 ms | n/a | 0.00 ms | 203.98 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 0.526/0.526 | - | - | - | 41.91 ms | n/a | n/a | 28.81 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 0.841/0.974 | - | 6.945/6.945 | 6.919/7.907 | 0.58 ms | n/a | n/a | 29.47 ms | 0 | measured |
| flutter-skia | small | scroll | ui-frame | 2.426/3.208 | - | 7.002/6.945 | - | 0.53 ms | n/a | n/a | 29.00 ms | 0 | measured |
| flutter-impeller | small | open | ui-frame | 0.393/0.393 | - | - | - | 22.76 ms | n/a | n/a | 30.50 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 0.866/1.241 | - | 6.944/6.945 | 7.088/8.090 | 1.61 ms | n/a | n/a | 29.96 ms | 0 | measured |
| flutter-impeller | small | scroll | ui-frame | 2.621/3.458 | - | 7.060/6.945 | - | 1.20 ms | n/a | n/a | 29.63 ms | 0 | measured |
| electron | small | open | ui-frame | 55.600/55.600 | - | - | - | n/a | n/a | n/a | 55.60 ms | 0 | measured |
| electron | small | input | ui-frame | 3.130/4.300 | - | 8.887/19.472 | 7.180/13.800 | n/a | n/a | n/a | 50.90 ms | 1 | measured |
| electron | small | scroll | ui-frame | 3.301/4.600 | - | 6.991/7.000 | - | n/a | n/a | n/a | 17.90 ms | 0 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 3.45/n/a/n/a | 6.09/n/a/n/a | 1.98/n/a/n/a | 2.52/n/a/n/a | 6.56/n/a/n/a | 10.19/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 3.45/n/a/n/a | 6.07/n/a/n/a | 2.39/n/a/n/a | 5.37/n/a/n/a | 6.95/n/a/n/a | 10.64/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 3.98/n/a/n/a | 6.24/n/a/n/a | 3.86/n/a/n/a | 5.29/n/a/n/a | 9.04/n/a/n/a | 12.28/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 3.37/n/a/n/a | 4.31/n/a/n/a | 6.04/n/a/n/a | 7.33/n/a/n/a | 9.94/n/a/n/a | 11.88/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 3.50/n/a/n/a | 4.53/n/a/n/a | 24.42/n/a/n/a | 27.00/n/a/n/a | 28.52/n/a/n/a | 31.09/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 4.44/n/a/n/a | 5.71/n/a/n/a | 6.59/n/a/n/a | 7.92/n/a/n/a | 11.54/n/a/n/a | 13.92/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 2.43/n/a/n/a | 3.21/n/a/n/a | 0.53/n/a/n/a | 0.69/n/a/n/a | 7.00/n/a/n/a | 6.95/n/a/n/a | 0/n/a/n/a |
| Flutter Impeller | 2.62/n/a/n/a | 3.46/n/a/n/a | 1.20/n/a/n/a | 1.53/n/a/n/a | 7.06/n/a/n/a | 6.95/n/a/n/a | 0/n/a/n/a |
| Electron | 3.30/n/a/n/a | 4.60/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | 6.99/n/a/n/a | 7.00/n/a/n/a | 0/n/a/n/a |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
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

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 4.19/n/a/n/a | 4.69/n/a/n/a | 1.71/n/a/n/a | 1.92/n/a/n/a | 1.99/n/a/n/a | 2.12/n/a/n/a |
| MoUI Skia GPU | 12.77/n/a/n/a | 15.21/n/a/n/a | 1.98/n/a/n/a | 2.42/n/a/n/a | 10.18/n/a/n/a | 12.72/n/a/n/a |
| MoUI WGPU | 11.11/n/a/n/a | 13.93/n/a/n/a | 5.01/n/a/n/a | 6.59/n/a/n/a | 5.48/n/a/n/a | 7.17/n/a/n/a |
| MoMark Skia Raster | 12.62/n/a/n/a | 13.82/n/a/n/a | 5.65/n/a/n/a | 6.55/n/a/n/a | 6.11/n/a/n/a | 7.65/n/a/n/a |
| MoMark Skia GPU | 38.24/n/a/n/a | 39.41/n/a/n/a | 5.39/n/a/n/a | 6.21/n/a/n/a | 31.87/n/a/n/a | 32.78/n/a/n/a |
| MoMark WGPU | 31.68/n/a/n/a | 35.38/n/a/n/a | 24.01/n/a/n/a | 27.76/n/a/n/a | 6.78/n/a/n/a | 7.48/n/a/n/a |
| GpMark.mbt (GPUI) | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 6.92/n/a/n/a | 7.91/n/a/n/a | 0.84/n/a/n/a | 0.97/n/a/n/a | 0.58/n/a/n/a | 0.72/n/a/n/a |
| Flutter Impeller | 7.09/n/a/n/a | 8.09/n/a/n/a | 0.87/n/a/n/a | 1.24/n/a/n/a | 1.61/n/a/n/a | 2.52/n/a/n/a |
| Electron | 7.18/n/a/n/a | 13.80/n/a/n/a | 3.13/n/a/n/a | 4.30/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） |
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

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 45.47/n/a/n/a | 45.47/n/a/n/a | 33.19/n/a/n/a | 33.19/n/a/n/a | 7.78/n/a/n/a | 7.78/n/a/n/a | 0.16/n/a/n/a | 0.16/n/a/n/a |
| MoUI Skia GPU | 100.62/n/a/n/a | 100.62/n/a/n/a | 29.89/n/a/n/a | 29.89/n/a/n/a | 66.41/n/a/n/a | 66.41/n/a/n/a | 0.17/n/a/n/a | 0.17/n/a/n/a |
| MoUI WGPU | 188.60/n/a/n/a | 188.60/n/a/n/a | 140.16/n/a/n/a | 140.16/n/a/n/a | 41.98/n/a/n/a | 41.98/n/a/n/a | 0.22/n/a/n/a | 0.22/n/a/n/a |
| MoMark Skia Raster | 63.01/n/a/n/a | 63.01/n/a/n/a | 42.80/n/a/n/a | 42.80/n/a/n/a | 12.88/n/a/n/a | 12.88/n/a/n/a | 0.15/n/a/n/a | 0.15/n/a/n/a |
| MoMark Skia GPU | 362.12/n/a/n/a | 362.12/n/a/n/a | 47.49/n/a/n/a | 47.49/n/a/n/a | 308.39/n/a/n/a | 308.39/n/a/n/a | 0.17/n/a/n/a | 0.17/n/a/n/a |
| MoMark WGPU | 207.89/n/a/n/a | 207.89/n/a/n/a | 156.08/n/a/n/a | 156.08/n/a/n/a | 45.87/n/a/n/a | 45.87/n/a/n/a | 0.20/n/a/n/a | 0.20/n/a/n/a |
| GpMark.mbt (GPUI) | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 28.81/n/a/n/a | 28.81/n/a/n/a | 0.53/n/a/n/a | 0.53/n/a/n/a | 41.91/n/a/n/a | 41.91/n/a/n/a | 0.95/n/a/n/a | 0.95/n/a/n/a |
| Flutter Impeller | 30.50/n/a/n/a | 30.50/n/a/n/a | 0.39/n/a/n/a | 0.39/n/a/n/a | 22.76/n/a/n/a | 22.76/n/a/n/a | 0.84/n/a/n/a | 0.84/n/a/n/a |
| Electron | 55.60/n/a/n/a | 55.60/n/a/n/a | 55.60/n/a/n/a | 55.60/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | 3.47/n/a/n/a | 3.47/n/a/n/a |

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
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

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 3.45/n/a/n/a | 6.09/n/a/n/a | 1.98/n/a/n/a | 2.52/n/a/n/a | 6.56/n/a/n/a | 10.19/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 3.45/n/a/n/a | 6.07/n/a/n/a | 2.39/n/a/n/a | 5.37/n/a/n/a | 6.95/n/a/n/a | 10.64/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 3.98/n/a/n/a | 6.24/n/a/n/a | 3.86/n/a/n/a | 5.29/n/a/n/a | 9.04/n/a/n/a | 12.28/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 3.37/n/a/n/a | 4.31/n/a/n/a | 6.04/n/a/n/a | 7.33/n/a/n/a | 9.94/n/a/n/a | 11.88/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 3.50/n/a/n/a | 4.53/n/a/n/a | 24.42/n/a/n/a | 27.00/n/a/n/a | 28.52/n/a/n/a | 31.09/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 4.44/n/a/n/a | 5.71/n/a/n/a | 6.59/n/a/n/a | 7.92/n/a/n/a | 11.54/n/a/n/a | 13.92/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 2.43/n/a/n/a | 3.21/n/a/n/a | 0.53/n/a/n/a | 0.69/n/a/n/a | 7.00/n/a/n/a | 6.95/n/a/n/a | 0/n/a/n/a |
| Flutter Impeller | 2.62/n/a/n/a | 3.46/n/a/n/a | 1.20/n/a/n/a | 1.53/n/a/n/a | 7.06/n/a/n/a | 6.95/n/a/n/a | 0/n/a/n/a |
| Electron | 3.30/n/a/n/a | 4.60/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | 6.99/n/a/n/a | 7.00/n/a/n/a | 0/n/a/n/a |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
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

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoUI Skia GPU small 100.6 ms（max 100.6 ms）；MoUI WGPU small 188.6 ms（max 188.6 ms）；MoMark Skia GPU small 362.1 ms（max 362.1 ms）；MoMark WGPU small 207.9 ms（max 207.9 ms）。
- P1 输入尾延迟：MoMark Skia GPU small P95 39.41 ms；MoMark WGPU small P95 35.38 ms。
- 长帧（超预算）：MoMark Skia GPU: small/input 10 次，max 39.41 ms, small/scroll 120 次，max 32.94 ms；MoMark WGPU: small/input 10 次，max 35.38 ms；Electron: small/input 1 次，max 19.47 ms。
- 丢帧（优先处理）：Electron: small/input 1 帧。
- 解释：首帧异常优先检查窗口/渲染器初始化；输入尾延迟检查 action 到下一可见帧的调度与同步重建；长帧检查解析、布局、文本 shaping 和 GPU 提交；`n/a` 表示未埋点，不等于 0。
- 普通模式的长帧、帧间隔和输入延迟是各框架回调诊断，不能替代跨框架 compositor 排名；需要严格结论时运行 `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`。

## 采集口径

- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。
- `frame_work_ms` 统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏；对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `device_present_ms`：设备/上屏侧统一字段。MoUI raster 为 Skia CPU 光栅化+像素回读整体；MoUI GPU/wgpu 为提交后同步等待设备完成（headless host-surface 逐帧同步，真实应用的 vsync 流水线可重叠掉一部分，该值应视为上屏成本上界）；Flutter 为 `FrameTiming.rasterDuration`（光栅线程任务时间，含显示列表光栅化与 GPU 提交、不含设备完成等待）；GPUI 与 Electron 适配器侧无法观测，显示 `n/a`。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧；严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代；打开场景没有前一帧，所以不计算 interval/drop。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。
