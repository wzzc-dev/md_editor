# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-05T10:08:13Z`
- 数据状态：`144 measured`，`72 skipped/error`；原始样本保留在 JSON。
- Host：`macOS-26.3-arm64-arm-64bit` / `arm64` / `16.0 GiB`；GPU：`Apple M4`
- OS：`25.3.0`；CPU：`arm`；toolchains：`python=3.12.11, moon=moon 0.1.20260824 (dae026a 2026-08-24), rustc=rustc 1.94.0 (4a4ef493e 2026-03-02), cargo=cargo 1.94.0 (85eff7c80 2026-01-15), node=v25.2.1, npm=11.6.2, flutter=Flutter 3.47.1 • channel stable • https://github.com/flutter/flutter.git`
- 统一配置：`1280x800 @ 60 Hz`；font `system-ui 16px`；line-height `1.55`；overscan `3`；fixed row `66px`；GPU backend `Metal`
- Fixture：`small=5KB/100 blocks`，`medium=50KB/1,000 blocks`，`large=500KB/10,000 blocks`，`stress=5MB/100,000 blocks`。
- 本次执行集合：`small, medium, large, stress`；未执行集合在矩阵中显示 `n/a`，不参与比较。
- 汇总口径：mean/P95 合并原始样本；每格 repetition `3`、process warm-up `1`；drop 为各 repetition dropped_display_frames 之和。
- 公平性口径：所有 ui-frame 记录使用相同 fixture、viewport、动作数、warm-up 和重复次数。`工作`（frame_work）统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏：MoUI 为 build+layout+paint+draw，Flutter 为 UI 线程 buildDuration，GPUI 为 request_layout→prepaint→paint，Electron 为 JS 可见的 DOM 更新+layout。设备光栅化与上屏统一单列为 `设备侧`（device_present）：MoUI 为同步光栅化/present 完成（无头 harness 逐帧同步，无流水线重叠），Flutter 为光栅线程 rasterDuration（不含设备完成等待），GPUI 与 Electron 无法在适配器侧观测显示链路，显示 `n/a`。MoUI ui-frame 是 headless host-surface；GPUI 的 action dispatch 另列为诊断字段。不同框架的显示时间戳由各自平台 API 提供，帧间隔覆盖完整链路，报告不做跨时钟的综合排名。`n/a` 表示没有采集，绝不等同于 0。

- `moui-md-*` 行来自 `vendor/MoUI/examples/markdown_editor` 官方示例应用：fixture 通过应用自身的 `OpenRecentDocument` 服务路径打开，渲染经过示例自己的虚拟滚动与富文本缓存实现，不套用简化基准应用的 `fixed row 66px` 统一行高；viewport、fixture、动作数、warm-up 与重复次数与其他行完全一致。严格模式（`UI_BENCHMARK_SYSTEM_TRACE=1`）目前不为 `moui-md-*` 行采集系统 present，这些行会显示 error。

<details><summary>原始 ui-frame 汇总（可审计）</summary>

| 实现 | 测试集合 | 场景 | 范围 | 工作均值/P95 | 仅分发均值/P95 | 帧间隔均值/P95 | 输入到可见均值/P95 | 设备侧均值 | 离屏均值 | 回读均值 | 首次可交互 | 丢帧数 | 状态 |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| moui-md-skia-raster | small | open | ui-frame | 54.824/57.251 | - | - | - | 14.78 ms | 0.00 ms | 14.78 ms | 71.72 ms | n/a | measured |
| moui-md-skia-raster | small | input | ui-frame | 3.539/4.428 | - | 6.625/8.810 | 6.601/8.809 | 2.71 ms | 0.00 ms | 2.71 ms | 72.04 ms | n/a | measured |
| moui-md-skia-raster | small | scroll | ui-frame | 1.000/1.300 | - | 3.446/4.517 | - | 2.28 ms | 0.00 ms | 2.28 ms | 74.09 ms | n/a | measured |
| moui-md-skia-raster | medium | open | ui-frame | 52.464/53.196 | - | - | - | 12.47 ms | 0.00 ms | 12.47 ms | 68.35 ms | n/a | measured |
| moui-md-skia-raster | medium | input | ui-frame | 4.146/5.854 | - | 8.247/11.364 | 8.223/11.363 | 3.09 ms | 0.00 ms | 3.09 ms | 77.97 ms | n/a | measured |
| moui-md-skia-raster | medium | scroll | ui-frame | 1.032/1.543 | - | 3.628/5.641 | - | 2.38 ms | 0.00 ms | 2.38 ms | 66.25 ms | n/a | measured |
| moui-md-skia-raster | large | open | ui-frame | 63.928/67.654 | - | - | - | 15.61 ms | 0.00 ms | 15.61 ms | 100.96 ms | n/a | measured |
| moui-md-skia-raster | large | input | ui-frame | 5.448/6.536 | - | 16.482/19.098 | 16.452/18.870 | 3.47 ms | 0.00 ms | 3.47 ms | 102.59 ms | n/a | measured |
| moui-md-skia-raster | large | scroll | ui-frame | 1.095/1.554 | - | 4.079/5.647 | - | 2.54 ms | 0.00 ms | 2.54 ms | 93.13 ms | n/a | measured |
| moui-md-skia-raster | stress | open | ui-frame | 65.520/73.376 | - | - | - | 12.48 ms | 0.00 ms | 12.48 ms | 256.56 ms | n/a | measured |
| moui-md-skia-raster | stress | input | ui-frame | 13.867/15.002 | - | 95.727/106.756 | 95.699/106.431 | 3.78 ms | 0.00 ms | 3.78 ms | 292.54 ms | n/a | measured |
| moui-md-skia-raster | stress | scroll | ui-frame | 1.188/1.746 | - | 7.048/8.700 | - | 2.81 ms | 0.00 ms | 2.81 ms | 274.90 ms | n/a | measured |
| moui-md-skia-gpu | small | open | ui-frame | 57.744/59.866 | - | - | - | 57.51 ms | n/a | 0.00 ms | 117.23 ms | n/a | measured |
| moui-md-skia-gpu | small | input | ui-frame | 4.459/5.333 | - | 13.732/20.978 | 13.698/20.977 | 8.76 ms | n/a | 0.00 ms | 111.54 ms | n/a | measured |
| moui-md-skia-gpu | small | scroll | ui-frame | 1.214/1.768 | - | 9.615/10.898 | - | 8.10 ms | n/a | 0.00 ms | 112.01 ms | n/a | measured |
| moui-md-skia-gpu | medium | open | ui-frame | 56.633/60.556 | - | - | - | 64.25 ms | n/a | 0.00 ms | 124.24 ms | n/a | measured |
| moui-md-skia-gpu | medium | input | ui-frame | 4.592/5.536 | - | 13.781/20.036 | 13.746/20.035 | 8.07 ms | n/a | 0.00 ms | 133.52 ms | n/a | measured |
| moui-md-skia-gpu | medium | scroll | ui-frame | 1.127/1.447 | - | 9.342/10.760 | - | 7.92 ms | n/a | 0.00 ms | 128.18 ms | n/a | measured |
| moui-md-skia-gpu | large | open | ui-frame | 87.783/127.722 | - | - | - | 66.92 ms | n/a | 0.00 ms | 187.87 ms | n/a | measured |
| moui-md-skia-gpu | large | input | ui-frame | 5.898/7.135 | - | 22.896/29.658 | 22.867/29.657 | 9.70 ms | n/a | 0.00 ms | 148.17 ms | n/a | measured |
| moui-md-skia-gpu | large | scroll | ui-frame | 1.255/1.885 | - | 9.730/11.169 | - | 7.87 ms | n/a | 0.00 ms | 139.82 ms | n/a | measured |
| moui-md-skia-gpu | stress | open | ui-frame | 74.314/88.372 | - | - | - | 62.51 ms | n/a | 0.00 ms | 322.80 ms | n/a | measured |
| moui-md-skia-gpu | stress | input | ui-frame | 13.740/14.999 | - | 105.470/117.043 | 105.436/117.042 | 10.50 ms | n/a | 0.00 ms | 319.65 ms | n/a | measured |
| moui-md-skia-gpu | stress | scroll | ui-frame | 1.268/2.005 | - | 11.179/19.329 | - | 6.86 ms | n/a | 0.00 ms | 312.97 ms | n/a | measured |
| moui-md-wgpu | small | open | ui-frame | 57.884/61.790 | - | - | - | 17.28 ms | n/a | 0.00 ms | 77.64 ms | n/a | measured |
| moui-md-wgpu | small | input | ui-frame | 1.789/2.470 | - | 9.830/24.434 | 9.802/24.433 | 7.53 ms | n/a | 0.00 ms | 99.44 ms | n/a | measured |
| moui-md-wgpu | small | scroll | ui-frame | 1.503/2.144 | - | 10.903/27.321 | - | 9.05 ms | n/a | 0.00 ms | 74.89 ms | n/a | measured |
| moui-md-wgpu | medium | open | ui-frame | 73.216/105.248 | - | - | - | 18.75 ms | n/a | 0.00 ms | 98.59 ms | n/a | measured |
| moui-md-wgpu | medium | input | ui-frame | 1.885/2.685 | - | 9.525/26.138 | 9.497/26.137 | 6.49 ms | n/a | 0.00 ms | 78.02 ms | n/a | measured |
| moui-md-wgpu | medium | scroll | ui-frame | 1.635/2.504 | - | 11.021/26.755 | - | 9.01 ms | n/a | 0.00 ms | 77.15 ms | n/a | measured |
| moui-md-wgpu | large | open | ui-frame | 56.358/58.947 | - | - | - | 17.48 ms | n/a | 0.00 ms | 94.87 ms | n/a | measured |
| moui-md-wgpu | large | input | ui-frame | 2.734/3.315 | - | 14.029/15.852 | 14.001/15.653 | 3.65 ms | n/a | 0.00 ms | 95.43 ms | n/a | measured |
| moui-md-wgpu | large | scroll | ui-frame | 1.639/2.367 | - | 11.668/27.969 | - | 9.32 ms | n/a | 0.00 ms | 96.03 ms | n/a | measured |
| moui-md-wgpu | stress | open | ui-frame | 64.335/72.559 | - | - | - | 17.02 ms | n/a | 0.00 ms | 274.09 ms | n/a | measured |
| moui-md-wgpu | stress | input | ui-frame | 11.290/18.205 | - | 100.027/116.201 | 99.980/116.200 | 3.17 ms | n/a | 0.00 ms | 277.27 ms | n/a | measured |
| moui-md-wgpu | stress | scroll | ui-frame | 1.536/2.289 | - | 9.421/11.839 | - | 4.42 ms | n/a | 0.00 ms | 306.08 ms | n/a | measured |
| gpui | small | open | ui-frame | 8.492/9.748 | - | - | - | n/a | n/a | n/a | 228.83 ms | n/a | measured |
| gpui | small | input | ui-frame | 9.476/17.790 | 0.525/1.018 | 14.404/25.597 | 14.401/25.594 | n/a | n/a | n/a | 263.54 ms | n/a | measured |
| gpui | small | scroll | ui-frame | 8.990/11.173 | 0.003/0.006 | 11.725/15.423 | - | n/a | n/a | n/a | 225.48 ms | n/a | measured |
| gpui | medium | open | ui-frame | 9.230/12.176 | - | - | - | n/a | n/a | n/a | 213.49 ms | n/a | measured |
| gpui | medium | input | ui-frame | 8.326/10.137 | 0.541/0.748 | 15.106/38.321 | 15.102/38.318 | n/a | n/a | n/a | 239.86 ms | n/a | measured |
| gpui | medium | scroll | ui-frame | 9.228/11.867 | 0.003/0.006 | 12.172/17.307 | - | n/a | n/a | n/a | 203.13 ms | n/a | measured |
| gpui | large | open | ui-frame | 9.048/10.044 | - | - | - | n/a | n/a | n/a | 242.06 ms | n/a | measured |
| gpui | large | input | ui-frame | 7.809/8.358 | 1.018/1.238 | 14.057/32.082 | 14.054/32.080 | n/a | n/a | n/a | 263.88 ms | n/a | measured |
| gpui | large | scroll | ui-frame | 9.019/11.240 | 0.003/0.006 | 11.687/15.201 | - | n/a | n/a | n/a | 227.28 ms | n/a | measured |
| gpui | stress | open | ui-frame | 7.719/7.876 | - | - | - | n/a | n/a | n/a | 218.03 ms | n/a | measured |
| gpui | stress | input | ui-frame | 7.725/8.259 | 6.178/7.568 | 17.931/43.598 | 17.928/43.596 | n/a | n/a | n/a | 224.36 ms | n/a | measured |
| gpui | stress | scroll | ui-frame | 9.126/11.451 | 0.003/0.006 | 11.941/17.337 | - | n/a | n/a | n/a | 250.13 ms | n/a | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI 示例编辑器 Skia Raster | 1.00/1.03/1.09 | 1.30/1.54/1.55 | 2.28/2.38/2.54 | 3.10/3.78/3.61 | 3.45/3.63/4.08 | 4.52/5.64/5.65 | n/a/n/a/n/a |
| MoUI 示例编辑器 Skia GPU | 1.21/1.13/1.25 | 1.77/1.45/1.88 | 8.10/7.92/7.87 | 9.37/9.50/9.63 | 9.62/9.34/9.73 | 10.90/10.76/11.17 | n/a/n/a/n/a |
| MoUI 示例编辑器 WGPU | 1.50/1.64/1.64 | 2.14/2.50/2.37 | 9.05/9.01/9.32 | 25.60/24.99/25.43 | 10.90/11.02/11.67 | 27.32/26.75/27.97 | n/a/n/a/n/a |
| GPUI (md_mbt) | 8.99/9.23/9.02 | 11.17/11.87/11.24 | n/a/n/a/n/a | n/a/n/a/n/a | 11.73/12.17/11.69 | 15.42/17.31/15.20 | n/a/n/a/n/a |
| Flutter Skia | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Impeller | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Electron | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI Skia GPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI WGPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI 示例编辑器 Skia Raster | 1.19 | 1.75 | 2.81 | 3.78 | 7.05 | 8.70 | n/a |
| MoUI 示例编辑器 Skia GPU | 1.27 | 2.00 | 6.86 | 14.84 | 11.18 | 19.33 | n/a |
| MoUI 示例编辑器 WGPU | 1.54 | 2.29 | 4.42 | 7.52 | 9.42 | 11.84 | n/a |
| GPUI (md_mbt) | 9.13 | 11.45 | n/a | n/a | 11.94 | 17.34 | n/a |
| Flutter Skia | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Impeller | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Electron | n/a | n/a | n/a | n/a | n/a | n/a | n/a |

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI 示例编辑器 Skia Raster | 6.60/8.22/16.45 | 8.81/11.36/18.87 | 3.54/4.15/5.45 | 4.43/5.85/6.54 | 2.71/3.09/3.47 | 3.93/4.84/4.70 |
| MoUI 示例编辑器 Skia GPU | 13.70/13.75/22.87 | 20.98/20.04/29.66 | 4.46/4.59/5.90 | 5.33/5.54/7.14 | 8.76/8.07/9.70 | 16.54/14.51/17.20 |
| MoUI 示例编辑器 WGPU | 9.80/9.50/14.00 | 24.43/26.14/15.65 | 1.79/1.88/2.73 | 2.47/2.68/3.32 | 7.53/6.49/3.65 | 22.27/22.67/4.94 |
| GPUI (md_mbt) | 14.40/15.10/14.05 | 25.59/38.32/32.08 | 9.48/8.33/7.81 | 17.79/10.14/8.36 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Impeller | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Electron | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI Skia GPU | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI WGPU | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI 示例编辑器 Skia Raster | 95.70 | 106.43 | 13.87 | 15.00 | 3.78 | 5.09 |
| MoUI 示例编辑器 Skia GPU | 105.44 | 117.04 | 13.74 | 15.00 | 10.50 | 17.94 |
| MoUI 示例编辑器 WGPU | 99.98 | 116.20 | 11.29 | 18.20 | 3.17 | 4.49 |
| GPUI (md_mbt) | 17.93 | 43.60 | 7.72 | 8.26 | n/a | n/a |
| Flutter Skia | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Impeller | n/a | n/a | n/a | n/a | n/a | n/a |
| Electron | n/a | n/a | n/a | n/a | n/a | n/a |

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI 示例编辑器 Skia Raster | 71.72/68.35/100.96 | 75.24/70.28/104.61 | 54.82/52.46/63.93 | 57.25/53.20/67.65 | 14.78/12.47/15.61 | 15.80/13.60/16.17 | 0.10/0.28/2.55 | 0.13/0.36/3.17 |
| MoUI 示例编辑器 Skia GPU | 117.23/124.24/187.87 | 134.38/137.33/252.42 | 57.74/56.63/87.78 | 59.87/60.56/127.72 | 57.51/64.25/66.92 | 74.51/79.56/71.70 | 0.12/0.31/3.49 | 0.18/0.34/5.42 |
| MoUI 示例编辑器 WGPU | 77.64/98.59/94.87 | 82.95/134.14/97.29 | 57.88/73.22/56.36 | 61.79/105.25/58.95 | 17.28/18.75/17.48 | 17.81/20.01/17.83 | 0.08/0.93/2.79 | 0.10/2.19/2.96 |
| GPUI (md_mbt) | 228.83/213.49/242.06 | 245.45/234.29/260.11 | 8.49/9.23/9.05 | 9.75/12.18/10.04 | n/a/n/a/n/a | n/a/n/a/n/a | 0.00/0.33/2.67 | 0.00/1.00/3.00 |
| Flutter Skia | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Impeller | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Electron | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI Skia GPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI WGPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI 示例编辑器 Skia Raster | 256.56 | 263.06 | 65.52 | 73.38 | 12.48 | 14.40 | 23.67 | 25.23 |
| MoUI 示例编辑器 Skia GPU | 322.80 | 340.19 | 74.31 | 88.37 | 62.51 | 72.06 | 21.59 | 22.91 |
| MoUI 示例编辑器 WGPU | 274.09 | 285.44 | 64.33 | 72.56 | 17.02 | 18.70 | 28.56 | 29.80 |
| GPUI (md_mbt) | 218.03 | 228.31 | 7.72 | 7.88 | n/a | n/a | 29.00 | 33.00 |
| Flutter Skia | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Impeller | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Electron | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI 示例编辑器 Skia Raster | 1.00/1.03/1.09 | 1.30/1.54/1.55 | 2.28/2.38/2.54 | 3.10/3.78/3.61 | 3.45/3.63/4.08 | 4.52/5.64/5.65 | n/a/n/a/n/a |
| MoUI 示例编辑器 Skia GPU | 1.21/1.13/1.25 | 1.77/1.45/1.88 | 8.10/7.92/7.87 | 9.37/9.50/9.63 | 9.62/9.34/9.73 | 10.90/10.76/11.17 | n/a/n/a/n/a |
| MoUI 示例编辑器 WGPU | 1.50/1.64/1.64 | 2.14/2.50/2.37 | 9.05/9.01/9.32 | 25.60/24.99/25.43 | 10.90/11.02/11.67 | 27.32/26.75/27.97 | n/a/n/a/n/a |
| GPUI (md_mbt) | 8.99/9.23/9.02 | 11.17/11.87/11.24 | n/a/n/a/n/a | n/a/n/a/n/a | 11.73/12.17/11.69 | 15.42/17.31/15.20 | n/a/n/a/n/a |
| Flutter Skia | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Impeller | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Electron | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI Skia GPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI WGPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI 示例编辑器 Skia Raster | 1.19 | 1.75 | 2.81 | 3.78 | 7.05 | 8.70 | n/a |
| MoUI 示例编辑器 Skia GPU | 1.27 | 2.00 | 6.86 | 14.84 | 11.18 | 19.33 | n/a |
| MoUI 示例编辑器 WGPU | 1.54 | 2.29 | 4.42 | 7.52 | 9.42 | 11.84 | n/a |
| GPUI (md_mbt) | 9.13 | 11.45 | n/a | n/a | 11.94 | 17.34 | n/a |
| Flutter Skia | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Impeller | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Electron | n/a | n/a | n/a | n/a | n/a | n/a | n/a |

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoUI 示例编辑器 Skia Raster large 101.0 ms（max 104.6 ms）；MoUI 示例编辑器 Skia Raster stress 256.6 ms（max 263.1 ms）；MoUI 示例编辑器 Skia GPU small 117.2 ms（max 134.4 ms）；MoUI 示例编辑器 Skia GPU medium 124.2 ms（max 137.3 ms）；MoUI 示例编辑器 Skia GPU large 187.9 ms（max 252.4 ms）；MoUI 示例编辑器 Skia GPU stress 322.8 ms（max 340.2 ms）；MoUI 示例编辑器 WGPU medium 98.6 ms（max 134.1 ms）；MoUI 示例编辑器 WGPU stress 274.1 ms（max 285.4 ms）；GPUI (md_mbt) small 228.8 ms（max 245.4 ms）；GPUI (md_mbt) medium 213.5 ms（max 234.3 ms）；GPUI (md_mbt) large 242.1 ms（max 260.1 ms）；GPUI (md_mbt) stress 218.0 ms（max 228.3 ms）。
- P1 输入尾延迟：MoUI 示例编辑器 Skia Raster large P95 18.87 ms；MoUI 示例编辑器 Skia Raster stress P95 106.43 ms；MoUI 示例编辑器 Skia GPU small P95 20.98 ms；MoUI 示例编辑器 Skia GPU medium P95 20.04 ms；MoUI 示例编辑器 Skia GPU large P95 29.66 ms；MoUI 示例编辑器 Skia GPU stress P95 117.04 ms；MoUI 示例编辑器 WGPU small P95 24.43 ms；MoUI 示例编辑器 WGPU medium P95 26.14 ms；MoUI 示例编辑器 WGPU stress P95 116.20 ms；GPUI (md_mbt) small P95 25.59 ms；GPUI (md_mbt) medium P95 38.32 ms；GPUI (md_mbt) large P95 32.08 ms；GPUI (md_mbt) stress P95 43.60 ms。
- 长帧（超预算）：MoUI 示例编辑器 Skia Raster: large/input 13 次，max 19.84 ms, stress/input 30 次，max 116.78 ms, stress/scroll 6 次，max 41.70 ms；MoUI 示例编辑器 Skia GPU: small/input 11 次，max 22.12 ms, small/scroll 5 次，max 32.54 ms, medium/input 10 次，max 24.36 ms, medium/scroll 3 次，max 20.25 ms, large/input 25 次，max 30.52 ms, large/scroll 10 次，max 22.43 ms, stress/input 30 次，max 197.97 ms, stress/scroll 39 次，max 36.98 ms；MoUI 示例编辑器 WGPU: small/input 3 次，max 27.04 ms, small/scroll 53 次，max 33.77 ms, medium/input 2 次，max 26.32 ms, medium/scroll 55 次，max 40.93 ms, large/scroll 63 次，max 45.93 ms, stress/input 30 次，max 171.51 ms, stress/scroll 1 次，max 29.34 ms；GPUI (md_mbt): small/input 10 次，max 32.03 ms, small/scroll 15 次，max 32.05 ms, medium/input 8 次，max 41.68 ms, medium/scroll 22 次，max 44.43 ms, large/input 6 次，max 32.76 ms, large/scroll 8 次，max 39.07 ms, stress/input 7 次，max 46.49 ms, stress/scroll 22 次，max 29.89 ms。
- 丢帧（优先处理）：未发现可测丢帧。
- 解释：首帧异常优先检查窗口/渲染器初始化；输入尾延迟检查 action 到下一可见帧的调度与同步重建；长帧检查解析、布局、文本 shaping 和 GPU 提交；`n/a` 表示未埋点，不等于 0。
- 普通模式的长帧、帧间隔和输入延迟是各框架回调诊断，不能替代跨框架 compositor 排名；需要严格结论时运行 `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`。

## 采集口径

- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。
- `frame_work_ms` 统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏；对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `device_present_ms`：设备/上屏侧统一字段。MoUI raster 为 Skia CPU 光栅化+像素回读整体；MoUI GPU/wgpu 为提交后同步等待设备完成（headless host-surface 逐帧同步，真实应用的 vsync 流水线可重叠掉一部分，该值应视为上屏成本上界）；Flutter 为 `FrameTiming.rasterDuration`（光栅线程任务时间，含显示列表光栅化与 GPU 提交、不含设备完成等待）；GPUI 与 Electron 适配器侧无法观测，显示 `n/a`。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧；严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代；打开场景没有前一帧，所以不计算 interval/drop。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。
