# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-03T10:41:43Z`
- 数据状态：`252 measured`，`0 skipped/error`；原始样本保留在 JSON。
- Host：`macOS-26.3-arm64-arm-64bit` / `arm64` / `16.0 GiB`；GPU：`Apple M4`
- OS：`25.3.0`；CPU：`arm`；toolchains：`python=3.12.11, moon=moon 0.1.20260824 (dae026a 2026-08-24), rustc=rustc 1.94.0 (4a4ef493e 2026-03-02), cargo=cargo 1.94.0 (85eff7c80 2026-01-15), node=v25.2.1, npm=11.6.2, flutter=Flutter 3.47.1 • channel stable • https://github.com/flutter/flutter.git`
- 统一配置：`1280x800 @ 60 Hz`；font `system-ui 16px`；line-height `1.55`；overscan `3`；fixed row `66px`；GPU backend `Metal`
- Fixture：`small=5KB/100 blocks`，`medium=50KB/1,000 blocks`，`large=500KB/10,000 blocks`，`stress=5MB/100,000 blocks`。
- 本次执行集合：`small, medium, large, stress`；未执行集合在矩阵中显示 `n/a`，不参与比较。
- 汇总口径：mean/P95 合并原始样本；每格 repetition `3`、process warm-up `1`；drop 为各 repetition dropped_display_frames 之和。
- 公平性口径：所有 ui-frame 记录使用相同 fixture、viewport、动作数、warm-up 和重复次数；数值来自框架真实渲染/提交回调。MoUI ui-frame 是 headless host-surface；GPUI 的 frame work 覆盖 request_layout→prepaint→paint，action dispatch 另列为诊断字段。不同框架的显示时间戳由各自平台 API 提供，因此报告不做跨时钟的综合排名。`n/a` 表示没有采集，绝不等同于 0。

<details><summary>原始 ui-frame 汇总（可审计）</summary>

| 实现 | 测试集合 | 场景 | 范围 | 工作均值/P95 | 仅分发均值/P95 | 帧间隔均值/P95 | 输入到可见均值/P95 | 离屏均值 | 回读均值 | 首次可交互 | 丢帧数 | 状态 |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| moui-skia-raster | small | open | ui-frame | 46.698/46.800 | - | - | - | 0.00 ms | 6.18 ms | 54.61 ms | n/a | measured |
| moui-skia-raster | small | input | ui-frame | 0.515/0.565 | - | 5.143/6.301 | 5.143/6.300 | 0.00 ms | 4.27 ms | 55.19 ms | n/a | measured |
| moui-skia-raster | small | scroll | ui-frame | 2.082/4.728 | - | 6.670/10.175 | - | 0.00 ms | 4.00 ms | 53.58 ms | n/a | measured |
| moui-skia-raster | medium | open | ui-frame | 45.711/47.261 | - | - | - | 0.00 ms | 6.08 ms | 53.66 ms | n/a | measured |
| moui-skia-raster | medium | input | ui-frame | 0.485/0.557 | - | 4.696/4.941 | 4.696/4.940 | 0.00 ms | 3.88 ms | 54.62 ms | n/a | measured |
| moui-skia-raster | medium | scroll | ui-frame | 2.166/4.881 | - | 6.948/10.495 | - | 0.00 ms | 4.15 ms | 54.76 ms | n/a | measured |
| moui-skia-raster | large | open | ui-frame | 46.166/46.823 | - | - | - | 0.00 ms | 5.82 ms | 55.50 ms | n/a | measured |
| moui-skia-raster | large | input | ui-frame | 0.500/0.601 | - | 5.045/5.902 | 5.045/5.902 | 0.00 ms | 4.02 ms | 56.23 ms | n/a | measured |
| moui-skia-raster | large | scroll | ui-frame | 2.101/4.803 | - | 6.676/10.105 | - | 0.00 ms | 4.00 ms | 55.86 ms | n/a | measured |
| moui-skia-raster | stress | open | ui-frame | 46.855/48.230 | - | - | - | 0.00 ms | 5.68 ms | 72.16 ms | n/a | measured |
| moui-skia-raster | stress | input | ui-frame | 0.540/0.618 | - | 7.038/8.088 | 7.037/8.086 | 0.00 ms | 3.93 ms | 71.88 ms | n/a | measured |
| moui-skia-raster | stress | scroll | ui-frame | 2.086/4.730 | - | 6.672/10.021 | - | 0.00 ms | 4.01 ms | 78.70 ms | n/a | measured |
| moui-skia-gpu | small | open | ui-frame | 55.702/56.941 | - | - | - | n/a | 0.00 ms | 57.46 ms | n/a | measured |
| moui-skia-gpu | small | input | ui-frame | 8.427/10.474 | - | 8.770/10.808 | 8.769/10.807 | n/a | 0.00 ms | 60.24 ms | n/a | measured |
| moui-skia-gpu | small | scroll | ui-frame | 7.995/8.964 | - | 8.610/9.782 | - | n/a | 0.00 ms | 59.47 ms | n/a | measured |
| moui-skia-gpu | medium | open | ui-frame | 56.945/57.609 | - | - | - | n/a | 0.00 ms | 58.89 ms | n/a | measured |
| moui-skia-gpu | medium | input | ui-frame | 8.163/9.440 | - | 8.510/9.791 | 8.510/9.790 | n/a | 0.00 ms | 58.44 ms | n/a | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 8.209/9.086 | - | 8.857/10.210 | - | n/a | 0.00 ms | 58.11 ms | n/a | measured |
| moui-skia-gpu | large | open | ui-frame | 56.856/58.954 | - | - | - | n/a | 0.00 ms | 60.32 ms | n/a | measured |
| moui-skia-gpu | large | input | ui-frame | 7.934/8.933 | - | 8.473/9.446 | 8.473/9.446 | n/a | 0.00 ms | 63.55 ms | n/a | measured |
| moui-skia-gpu | large | scroll | ui-frame | 7.979/9.047 | - | 8.599/9.835 | - | n/a | 0.00 ms | 62.31 ms | n/a | measured |
| moui-skia-gpu | stress | open | ui-frame | 57.574/58.725 | - | - | - | n/a | 0.00 ms | 77.67 ms | n/a | measured |
| moui-skia-gpu | stress | input | ui-frame | 6.643/8.888 | - | 9.157/11.193 | 9.157/11.193 | n/a | 0.00 ms | 79.16 ms | n/a | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 7.990/9.115 | - | 8.614/9.815 | - | n/a | 0.00 ms | 76.42 ms | n/a | measured |
| moui-wgpu | small | open | ui-frame | 57.895/60.515 | - | - | - | n/a | 0.00 ms | 59.66 ms | n/a | measured |
| moui-wgpu | small | input | ui-frame | 7.810/9.133 | - | 8.196/9.511 | 8.196/9.511 | n/a | 0.00 ms | 58.21 ms | n/a | measured |
| moui-wgpu | small | scroll | ui-frame | 7.695/9.010 | - | 8.330/9.392 | - | n/a | 0.00 ms | 56.95 ms | n/a | measured |
| moui-wgpu | medium | open | ui-frame | 54.681/54.965 | - | - | - | n/a | 0.00 ms | 56.56 ms | n/a | measured |
| moui-wgpu | medium | input | ui-frame | 7.795/9.087 | - | 8.205/9.459 | 8.205/9.458 | n/a | 0.00 ms | 56.17 ms | n/a | measured |
| moui-wgpu | medium | scroll | ui-frame | 7.708/9.024 | - | 8.327/9.455 | - | n/a | 0.00 ms | 55.65 ms | n/a | measured |
| moui-wgpu | large | open | ui-frame | 53.569/54.172 | - | - | - | n/a | 0.00 ms | 57.13 ms | n/a | measured |
| moui-wgpu | large | input | ui-frame | 7.567/8.929 | - | 8.165/9.431 | 8.164/9.430 | n/a | 0.00 ms | 58.90 ms | n/a | measured |
| moui-wgpu | large | scroll | ui-frame | 7.753/9.085 | - | 8.377/9.579 | - | n/a | 0.00 ms | 56.57 ms | n/a | measured |
| moui-wgpu | stress | open | ui-frame | 53.948/55.823 | - | - | - | n/a | 0.00 ms | 74.07 ms | n/a | measured |
| moui-wgpu | stress | input | ui-frame | 5.511/6.774 | - | 8.298/9.136 | 8.297/9.136 | n/a | 0.00 ms | 73.96 ms | n/a | measured |
| moui-wgpu | stress | scroll | ui-frame | 7.711/9.015 | - | 8.327/9.377 | - | n/a | 0.00 ms | 72.58 ms | n/a | measured |
| gpui | small | open | ui-frame | 17.666/17.772 | - | - | - | n/a | n/a | 140.20 ms | n/a | measured |
| gpui | small | input | ui-frame | 16.850/17.184 | 0.869/0.984 | 21.365/26.957 | 21.363/26.955 | n/a | n/a | 128.19 ms | n/a | measured |
| gpui | small | scroll | ui-frame | 18.338/21.231 | 0.002/0.003 | 21.870/25.284 | - | n/a | n/a | 134.33 ms | n/a | measured |
| gpui | medium | open | ui-frame | 17.636/17.915 | - | - | - | n/a | n/a | 129.66 ms | n/a | measured |
| gpui | medium | input | ui-frame | 16.942/17.344 | 1.745/1.896 | 22.211/29.183 | 22.208/29.182 | n/a | n/a | 134.38 ms | n/a | measured |
| gpui | medium | scroll | ui-frame | 18.359/21.400 | 0.002/0.003 | 22.271/25.889 | - | n/a | n/a | 137.64 ms | n/a | measured |
| gpui | large | open | ui-frame | 18.423/19.333 | - | - | - | n/a | n/a | 134.98 ms | n/a | measured |
| gpui | large | input | ui-frame | 16.806/17.207 | 11.206/11.840 | 30.319/35.355 | 30.316/35.354 | n/a | n/a | 131.91 ms | n/a | measured |
| gpui | large | scroll | ui-frame | 18.337/21.243 | 0.002/0.004 | 26.213/29.634 | - | n/a | n/a | 138.29 ms | n/a | measured |
| gpui | stress | open | ui-frame | 17.724/17.873 | - | - | - | n/a | n/a | 160.01 ms | n/a | measured |
| gpui | stress | input | ui-frame | 16.469/16.842 | 112.417/115.626 | 120.817/138.041 | 120.815/138.032 | n/a | n/a | 159.70 ms | n/a | measured |
| gpui | stress | scroll | ui-frame | 18.317/21.125 | 0.002/0.003 | 66.095/70.166 | - | n/a | n/a | 141.17 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 9.000/9.662 | - | - | - | n/a | n/a | 32.45 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 0.940/1.234 | - | 10.000/10.003 | 10.030/10.389 | n/a | n/a | 30.94 ms | 0 | measured |
| flutter-skia | small | scroll | ui-frame | 2.043/3.032 | - | 10.028/10.001 | - | n/a | n/a | 33.40 ms | 1 | measured |
| flutter-skia | medium | open | ui-frame | 8.888/9.253 | - | - | - | n/a | n/a | 32.48 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 0.906/1.129 | - | 10.000/10.002 | 10.033/10.329 | n/a | n/a | 32.54 ms | 0 | measured |
| flutter-skia | medium | scroll | ui-frame | 2.087/3.889 | - | 9.972/10.001 | - | n/a | n/a | 31.19 ms | 1 | measured |
| flutter-skia | large | open | ui-frame | 8.692/8.934 | - | - | - | n/a | n/a | 31.31 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 0.917/1.447 | - | 10.000/10.002 | 10.032/10.425 | n/a | n/a | 32.98 ms | 0 | measured |
| flutter-skia | large | scroll | ui-frame | 2.329/3.907 | - | 10.000/10.001 | - | n/a | n/a | 34.80 ms | 1 | measured |
| flutter-skia | stress | open | ui-frame | 8.731/8.789 | - | - | - | n/a | n/a | 65.40 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 0.905/1.189 | - | 10.000/10.002 | 10.224/17.225 | n/a | n/a | 64.88 ms | 0 | measured |
| flutter-skia | stress | scroll | ui-frame | 2.396/3.979 | - | 9.945/10.002 | - | n/a | n/a | 67.11 ms | 0 | measured |
| flutter-impeller | small | open | ui-frame | 7.276/7.397 | - | - | - | n/a | n/a | 33.45 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 0.970/1.587 | - | 10.000/10.002 | 10.039/10.453 | n/a | n/a | 32.97 ms | 0 | measured |
| flutter-impeller | small | scroll | ui-frame | 2.146/3.005 | - | 9.972/10.002 | - | n/a | n/a | 34.30 ms | 0 | measured |
| flutter-impeller | medium | open | ui-frame | 7.059/7.260 | - | - | - | n/a | n/a | 31.92 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 0.956/1.621 | - | 10.000/10.002 | 10.028/10.423 | n/a | n/a | 32.93 ms | 0 | measured |
| flutter-impeller | medium | scroll | ui-frame | 2.456/3.985 | - | 10.028/10.001 | - | n/a | n/a | 31.76 ms | 1 | measured |
| flutter-impeller | large | open | ui-frame | 7.372/7.626 | - | - | - | n/a | n/a | 31.69 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 1.002/1.286 | - | 10.000/10.003 | 10.023/10.401 | n/a | n/a | 33.86 ms | 0 | measured |
| flutter-impeller | large | scroll | ui-frame | 2.517/4.114 | - | 10.028/10.001 | - | n/a | n/a | 37.32 ms | 1 | measured |
| flutter-impeller | stress | open | ui-frame | 6.974/7.132 | - | - | - | n/a | n/a | 62.53 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 0.833/1.286 | - | 10.000/10.001 | 10.237/15.611 | n/a | n/a | 61.81 ms | 0 | measured |
| flutter-impeller | stress | scroll | ui-frame | 2.426/3.940 | - | 10.028/10.001 | - | n/a | n/a | 66.09 ms | 1 | measured |
| electron | small | open | ui-frame | 15.367/15.400 | - | - | - | n/a | n/a | 15.37 ms | 0 | measured |
| electron | small | input | ui-frame | 1.740/3.100 | - | 9.819/12.000 | 8.773/11.900 | n/a | n/a | 15.23 ms | 0 | measured |
| electron | small | scroll | ui-frame | 1.762/2.300 | - | 9.891/11.900 | - | n/a | n/a | 14.90 ms | 0 | measured |
| electron | medium | open | ui-frame | 16.000/17.600 | - | - | - | n/a | n/a | 16.00 ms | 0 | measured |
| electron | medium | input | ui-frame | 1.723/3.000 | - | 9.644/11.700 | 8.693/11.800 | n/a | n/a | 15.70 ms | 0 | measured |
| electron | medium | scroll | ui-frame | 1.817/2.400 | - | 9.963/11.600 | - | n/a | n/a | 15.40 ms | 0 | measured |
| electron | large | open | ui-frame | 16.733/16.900 | - | - | - | n/a | n/a | 16.73 ms | 0 | measured |
| electron | large | input | ui-frame | 1.720/2.600 | - | 9.893/11.900 | 8.870/11.700 | n/a | n/a | 16.53 ms | 0 | measured |
| electron | large | scroll | ui-frame | 1.814/2.400 | - | 9.908/11.600 | - | n/a | n/a | 16.70 ms | 0 | measured |
| electron | stress | open | ui-frame | 25.433/25.900 | - | - | - | n/a | n/a | 25.43 ms | 0 | measured |
| electron | stress | input | ui-frame | 1.650/2.100 | - | 9.276/11.900 | 8.560/11.400 | n/a | n/a | 25.13 ms | 0 | measured |
| electron | stress | scroll | ui-frame | 1.766/2.400 | - | 9.930/12.000 | - | n/a | n/a | 25.03 ms | 0 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.08/2.17/2.10 | 4.73/4.88/4.80 | 6.67/6.95/6.68 | 10.18/10.50/10.10 | n/a/n/a/n/a |
| MoUI Skia GPU | 7.99/8.21/7.98 | 8.96/9.09/9.05 | 8.61/8.86/8.60 | 9.78/10.21/9.84 | n/a/n/a/n/a |
| MoUI WGPU | 7.70/7.71/7.75 | 9.01/9.02/9.08 | 8.33/8.33/8.38 | 9.39/9.46/9.58 | n/a/n/a/n/a |
| GPUI (md_mbt) | 18.34/18.36/18.34 | 21.23/21.40/21.24 | 21.87/22.27/26.21 | 25.28/25.89/29.63 | n/a/n/a/n/a |
| Flutter Skia | 2.04/2.09/2.33 | 3.03/3.89/3.91 | 10.03/9.97/10.00 | 10.00/10.00/10.00 | 1/1/1 |
| Flutter Impeller | 2.15/2.46/2.52 | 3.00/3.98/4.11 | 9.97/10.03/10.03 | 10.00/10.00/10.00 | 0/1/1 |
| Electron | 1.76/1.82/1.81 | 2.30/2.40/2.40 | 9.89/9.96/9.91 | 11.90/11.60/11.60 | 0/0/0 |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.09 | 4.73 | 6.67 | 10.02 | n/a |
| MoUI Skia GPU | 7.99 | 9.11 | 8.61 | 9.81 | n/a |
| MoUI WGPU | 7.71 | 9.01 | 8.33 | 9.38 | n/a |
| GPUI (md_mbt) | 18.32 | 21.13 | 66.10 | 70.17 | n/a |
| Flutter Skia | 2.40 | 3.98 | 9.94 | 10.00 | 0 |
| Flutter Impeller | 2.43 | 3.94 | 10.03 | 10.00 | 1 |
| Electron | 1.77 | 2.40 | 9.93 | 12.00 | 0 |

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） |
| --- | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 5.14/4.70/5.04 | 6.30/4.94/5.90 | 0.51/0.48/0.50 | 0.57/0.56/0.60 |
| MoUI Skia GPU | 8.77/8.51/8.47 | 10.81/9.79/9.45 | 8.43/8.16/7.93 | 10.47/9.44/8.93 |
| MoUI WGPU | 8.20/8.20/8.16 | 9.51/9.46/9.43 | 7.81/7.80/7.57 | 9.13/9.09/8.93 |
| GPUI (md_mbt) | 21.36/22.21/30.32 | 26.95/29.18/35.35 | 16.85/16.94/16.81 | 17.18/17.34/17.21 |
| Flutter Skia | 10.03/10.03/10.03 | 10.39/10.33/10.43 | 0.94/0.91/0.92 | 1.23/1.13/1.45 |
| Flutter Impeller | 10.04/10.03/10.02 | 10.45/10.42/10.40 | 0.97/0.96/1.00 | 1.59/1.62/1.29 |
| Electron | 8.77/8.69/8.87 | 11.90/11.80/11.70 | 1.74/1.72/1.72 | 3.10/3.00/2.60 |

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） |
| --- | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 7.04 | 8.09 | 0.54 | 0.62 |
| MoUI Skia GPU | 9.16 | 11.19 | 6.64 | 8.89 |
| MoUI WGPU | 8.30 | 9.14 | 5.51 | 6.77 |
| GPUI (md_mbt) | 120.81 | 138.03 | 16.47 | 16.84 |
| Flutter Skia | 10.22 | 17.23 | 0.90 | 1.19 |
| Flutter Impeller | 10.24 | 15.61 | 0.83 | 1.29 |
| Electron | 8.56 | 11.40 | 1.65 | 2.10 |

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 54.61/53.66/55.50 | 54.84/55.62/55.91 | 46.70/45.71/46.17 | 46.80/47.26/46.82 | 0.06/0.29/2.43 | 0.07/0.31/2.50 |
| MoUI Skia GPU | 57.46/58.89/60.32 | 58.89/59.46/62.50 | 55.70/56.95/56.86 | 56.94/57.61/58.95 | 0.08/0.30/2.49 | 0.09/0.30/2.56 |
| MoUI WGPU | 59.66/56.56/57.13 | 62.42/56.83/57.73 | 57.89/54.68/53.57 | 60.51/54.97/54.17 | 0.06/0.32/2.48 | 0.06/0.43/2.53 |
| GPUI (md_mbt) | 140.20/129.66/134.98 | 154.27/135.13/139.67 | 17.67/17.64/18.42 | 17.77/17.91/19.33 | 0.33/0.33/2.00 | 1.00/1.00/2.00 |
| Flutter Skia | 32.45/32.48/31.31 | 33.24/33.05/35.07 | 9.00/8.89/8.69 | 9.66/9.25/8.93 | 0.07/0.11/0.37 | 0.08/0.11/0.38 |
| Flutter Impeller | 33.45/31.92/31.69 | 34.96/32.36/35.67 | 7.28/7.06/7.37 | 7.40/7.26/7.63 | 0.09/0.10/0.35 | 0.13/0.10/0.38 |
| Electron | 15.37/16.00/16.73 | 15.40/17.60/16.90 | 15.37/16.00/16.73 | 15.40/17.60/16.90 | 3.35/2.87/3.04 | 5.24/2.98/3.22 |

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 72.16 | 74.47 | 46.85 | 48.23 | 24.65 | 25.57 |
| MoUI Skia GPU | 77.67 | 78.89 | 57.57 | 58.73 | 20.92 | 25.44 |
| MoUI WGPU | 74.07 | 75.72 | 53.95 | 55.82 | 25.58 | 25.85 |
| GPUI (md_mbt) | 160.01 | 164.94 | 17.72 | 17.87 | 23.33 | 28.00 |
| Flutter Skia | 65.40 | 65.61 | 8.73 | 8.79 | 2.59 | 2.67 |
| Flutter Impeller | 62.53 | 64.67 | 6.97 | 7.13 | 2.58 | 2.63 |
| Electron | 25.43 | 25.90 | 25.43 | 25.90 | 5.19 | 6.48 |

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 离屏均值（ms） | 离屏 P95（ms） | 回读均值（ms） | 回读 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.08/2.17/2.10 | 4.73/4.88/4.80 | 6.67/6.95/6.68 | 10.18/10.50/10.10 | n/a/n/a/n/a | 0.00/0.00/0.00 | 0.00/0.00/0.00 | 4.00/4.15/4.00 | 4.60/4.69/4.57 |
| MoUI Skia GPU | 7.99/8.21/7.98 | 8.96/9.09/9.05 | 8.61/8.86/8.60 | 9.78/10.21/9.84 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | 0.00/0.00/0.00 | 0.00/0.00/0.00 |
| MoUI WGPU | 7.70/7.71/7.75 | 9.01/9.02/9.08 | 8.33/8.33/8.38 | 9.39/9.46/9.58 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | 0.00/0.00/0.00 | 0.00/0.00/0.00 |
| GPUI (md_mbt) | 18.34/18.36/18.34 | 21.23/21.40/21.24 | 21.87/22.27/26.21 | 25.28/25.89/29.63 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 2.04/2.09/2.33 | 3.03/3.89/3.91 | 10.03/9.97/10.00 | 10.00/10.00/10.00 | 1/1/1 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Impeller | 2.15/2.46/2.52 | 3.00/3.98/4.11 | 9.97/10.03/10.03 | 10.00/10.00/10.00 | 0/1/1 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Electron | 1.76/1.82/1.81 | 2.30/2.40/2.40 | 9.89/9.96/9.91 | 11.90/11.60/11.60 | 0/0/0 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 离屏均值（ms） | 离屏 P95（ms） | 回读均值（ms） | 回读 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.09 | 4.73 | 6.67 | 10.02 | n/a | 0.00 | 0.00 | 4.01 | 4.68 |
| MoUI Skia GPU | 7.99 | 9.11 | 8.61 | 9.81 | n/a | n/a | n/a | 0.00 | 0.00 |
| MoUI WGPU | 7.71 | 9.01 | 8.33 | 9.38 | n/a | n/a | n/a | 0.00 | 0.00 |
| GPUI (md_mbt) | 18.32 | 21.13 | 66.10 | 70.17 | n/a | n/a | n/a | n/a | n/a |
| Flutter Skia | 2.40 | 3.98 | 9.94 | 10.00 | 0 | n/a | n/a | n/a | n/a |
| Flutter Impeller | 2.43 | 3.94 | 10.03 | 10.00 | 1 | n/a | n/a | n/a | n/a |
| Electron | 1.77 | 2.40 | 9.93 | 12.00 | 0 | n/a | n/a | n/a | n/a |

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：GPUI (md_mbt) small 140.2 ms（max 154.3 ms）；GPUI (md_mbt) medium 129.7 ms（max 135.1 ms）；GPUI (md_mbt) large 135.0 ms（max 139.7 ms）；GPUI (md_mbt) stress 160.0 ms（max 164.9 ms）。
- P1 输入尾延迟：GPUI (md_mbt) small P95 26.95 ms；GPUI (md_mbt) medium P95 29.18 ms；GPUI (md_mbt) large P95 35.35 ms；GPUI (md_mbt) stress P95 138.03 ms；Flutter Skia stress P95 17.23 ms。
- 长帧（超预算）：MoUI Skia Raster CPU: medium/scroll 5 次，max 29.81 ms；MoUI Skia GPU: medium/scroll 4 次，max 33.46 ms；GPUI (md_mbt): small/input 30 次，max 28.38 ms, small/scroll 360 次，max 31.56 ms, medium/input 30 次，max 30.04 ms, medium/scroll 360 次，max 31.40 ms, large/input 30 次，max 37.53 ms, large/scroll 360 次，max 33.30 ms, stress/input 30 次，max 138.27 ms, stress/scroll 360 次，max 76.29 ms；Flutter Skia: small/scroll 1 次，max 20.00 ms, medium/scroll 1 次，max 20.00 ms, large/scroll 1 次，max 20.00 ms；Flutter Impeller: medium/scroll 1 次，max 20.00 ms, large/scroll 1 次，max 20.00 ms, stress/scroll 1 次，max 20.00 ms。
- 丢帧（优先处理）：Flutter Skia: small/scroll 1 帧, medium/scroll 1 帧, large/scroll 1 帧；Flutter Impeller: medium/scroll 1 帧, large/scroll 1 帧, stress/scroll 1 帧。
- 解释：首帧异常优先检查窗口/渲染器初始化；输入尾延迟检查 action 到下一可见帧的调度与同步重建；长帧检查解析、布局、文本 shaping 和 GPU 提交；`n/a` 表示未埋点，不等于 0。
- 普通模式的长帧、帧间隔和输入延迟是各框架回调诊断，不能替代跨框架 compositor 排名；需要严格结论时运行 `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`。

## 采集口径

- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。
- `frame_work_ms` 对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧；严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代；打开场景没有前一帧，所以不计算 interval/drop。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。
