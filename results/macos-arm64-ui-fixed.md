# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-08-31T15:28:30Z`
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
| moui-skia-raster | small | open | ui-frame | 47.197/47.341 | - | - | - | 0.00 ms | 5.82 ms | 54.75 ms | n/a | measured |
| moui-skia-raster | small | input | ui-frame | 0.476/0.519 | - | 4.712/4.954 | 4.712/4.954 | 0.00 ms | 3.92 ms | 54.92 ms | n/a | measured |
| moui-skia-raster | small | scroll | ui-frame | 2.163/4.891 | - | 6.899/10.499 | - | 0.00 ms | 4.12 ms | 56.17 ms | n/a | measured |
| moui-skia-raster | medium | open | ui-frame | 46.838/47.701 | - | - | - | 0.00 ms | 6.02 ms | 54.81 ms | n/a | measured |
| moui-skia-raster | medium | input | ui-frame | 0.492/0.579 | - | 4.782/5.072 | 4.782/5.072 | 0.00 ms | 3.94 ms | 56.50 ms | n/a | measured |
| moui-skia-raster | medium | scroll | ui-frame | 2.073/4.703 | - | 6.653/10.141 | - | 0.00 ms | 4.00 ms | 54.55 ms | n/a | measured |
| moui-skia-raster | large | open | ui-frame | 46.192/46.696 | - | - | - | 0.00 ms | 5.70 ms | 55.41 ms | n/a | measured |
| moui-skia-raster | large | input | ui-frame | 0.473/0.519 | - | 4.814/4.998 | 4.813/4.997 | 0.00 ms | 3.87 ms | 56.07 ms | n/a | measured |
| moui-skia-raster | large | scroll | ui-frame | 2.080/4.762 | - | 6.607/10.073 | - | 0.00 ms | 3.95 ms | 55.81 ms | n/a | measured |
| moui-skia-raster | stress | open | ui-frame | 46.173/46.397 | - | - | - | 0.00 ms | 5.56 ms | 71.48 ms | n/a | measured |
| moui-skia-raster | stress | input | ui-frame | 0.550/0.634 | - | 7.080/7.919 | 7.080/7.918 | 0.00 ms | 3.95 ms | 73.15 ms | n/a | measured |
| moui-skia-raster | stress | scroll | ui-frame | 2.091/4.750 | - | 6.623/9.976 | - | 0.00 ms | 3.96 ms | 71.72 ms | n/a | measured |
| moui-skia-gpu | small | open | ui-frame | 59.296/60.121 | - | - | - | n/a | 0.00 ms | 61.07 ms | n/a | measured |
| moui-skia-gpu | small | input | ui-frame | 8.143/9.168 | - | 8.494/9.524 | 8.493/9.523 | n/a | 0.00 ms | 60.01 ms | n/a | measured |
| moui-skia-gpu | small | scroll | ui-frame | 7.984/9.136 | - | 8.594/9.794 | - | n/a | 0.00 ms | 199.81 ms | n/a | measured |
| moui-skia-gpu | medium | open | ui-frame | 89.305/151.848 | - | - | - | n/a | 0.00 ms | 91.23 ms | n/a | measured |
| moui-skia-gpu | medium | input | ui-frame | 8.144/9.099 | - | 8.520/9.472 | 8.518/9.470 | n/a | 0.00 ms | 62.35 ms | n/a | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 7.981/9.007 | - | 8.589/9.848 | - | n/a | 0.00 ms | 61.00 ms | n/a | measured |
| moui-skia-gpu | large | open | ui-frame | 58.440/60.642 | - | - | - | n/a | 0.00 ms | 61.97 ms | n/a | measured |
| moui-skia-gpu | large | input | ui-frame | 8.286/9.808 | - | 8.830/10.346 | 8.829/10.345 | n/a | 0.00 ms | 62.78 ms | n/a | measured |
| moui-skia-gpu | large | scroll | ui-frame | 7.994/8.979 | - | 8.613/9.850 | - | n/a | 0.00 ms | 62.80 ms | n/a | measured |
| moui-skia-gpu | stress | open | ui-frame | 57.312/59.108 | - | - | - | n/a | 0.00 ms | 76.88 ms | n/a | measured |
| moui-skia-gpu | stress | input | ui-frame | 6.334/8.215 | - | 9.052/10.529 | 9.051/10.529 | n/a | 0.00 ms | 80.38 ms | n/a | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 7.980/8.972 | - | 8.586/9.771 | - | n/a | 0.00 ms | 78.29 ms | n/a | measured |
| moui-wgpu | small | open | ui-frame | 52.030/52.445 | - | - | - | n/a | 0.00 ms | 53.69 ms | n/a | measured |
| moui-wgpu | small | input | ui-frame | 7.914/9.074 | - | 8.285/9.386 | 8.284/9.386 | n/a | 0.00 ms | 54.25 ms | n/a | measured |
| moui-wgpu | small | scroll | ui-frame | 7.674/8.954 | - | 8.351/9.444 | - | n/a | 0.00 ms | 54.56 ms | n/a | measured |
| moui-wgpu | medium | open | ui-frame | 51.850/52.359 | - | - | - | n/a | 0.00 ms | 53.74 ms | n/a | measured |
| moui-wgpu | medium | input | ui-frame | 7.852/8.983 | - | 8.232/9.354 | 8.232/9.354 | n/a | 0.00 ms | 55.39 ms | n/a | measured |
| moui-wgpu | medium | scroll | ui-frame | 7.674/8.967 | - | 8.331/9.464 | - | n/a | 0.00 ms | 54.39 ms | n/a | measured |
| moui-wgpu | large | open | ui-frame | 52.314/52.713 | - | - | - | n/a | 0.00 ms | 55.78 ms | n/a | measured |
| moui-wgpu | large | input | ui-frame | 7.611/9.092 | - | 8.150/9.632 | 8.150/9.632 | n/a | 0.00 ms | 56.25 ms | n/a | measured |
| moui-wgpu | large | scroll | ui-frame | 7.662/8.907 | - | 8.330/9.361 | - | n/a | 0.00 ms | 56.33 ms | n/a | measured |
| moui-wgpu | stress | open | ui-frame | 52.182/52.543 | - | - | - | n/a | 0.00 ms | 72.02 ms | n/a | measured |
| moui-wgpu | stress | input | ui-frame | 5.639/6.865 | - | 8.320/9.333 | 8.319/9.332 | n/a | 0.00 ms | 73.32 ms | n/a | measured |
| moui-wgpu | stress | scroll | ui-frame | 7.668/9.054 | - | 8.330/9.518 | - | n/a | 0.00 ms | 72.65 ms | n/a | measured |
| gpui | small | open | ui-frame | 2.355/2.853 | - | - | - | n/a | n/a | 136.08 ms | n/a | measured |
| gpui | small | input | ui-frame | 1.849/2.013 | 0.059/0.158 | 10.350/17.891 | 10.348/17.890 | n/a | n/a | 128.38 ms | n/a | measured |
| gpui | small | scroll | ui-frame | 2.291/3.304 | 0.003/0.005 | 10.027/11.550 | - | n/a | n/a | 141.83 ms | n/a | measured |
| gpui | medium | open | ui-frame | 2.165/2.251 | - | - | - | n/a | n/a | 143.62 ms | n/a | measured |
| gpui | medium | input | ui-frame | 1.844/1.991 | 0.062/0.216 | 9.805/15.995 | 9.802/15.989 | n/a | n/a | 132.28 ms | n/a | measured |
| gpui | medium | scroll | ui-frame | 2.498/3.166 | 0.002/0.004 | 10.050/10.776 | - | n/a | n/a | 152.27 ms | n/a | measured |
| gpui | large | open | ui-frame | 2.174/2.208 | - | - | - | n/a | n/a | 125.35 ms | n/a | measured |
| gpui | large | input | ui-frame | 1.852/1.958 | 0.057/0.173 | 9.755/18.499 | 9.753/18.498 | n/a | n/a | 140.47 ms | n/a | measured |
| gpui | large | scroll | ui-frame | 2.450/3.131 | 0.003/0.005 | 10.024/11.146 | - | n/a | n/a | 142.36 ms | n/a | measured |
| gpui | stress | open | ui-frame | 2.244/2.481 | - | - | - | n/a | n/a | 123.28 ms | n/a | measured |
| gpui | stress | input | ui-frame | 1.877/2.012 | 0.061/0.171 | 10.396/18.695 | 10.393/18.693 | n/a | n/a | 124.23 ms | n/a | measured |
| gpui | stress | scroll | ui-frame | 2.492/3.224 | 0.003/0.004 | 10.032/10.462 | - | n/a | n/a | 132.68 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 9.535/10.139 | - | - | - | n/a | n/a | 62.16 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 1.375/2.932 | - | 9.667/10.010 | 10.848/15.852 | n/a | n/a | 66.02 ms | 1 | measured |
| flutter-skia | small | scroll | ui-frame | 2.070/2.774 | - | 10.139/10.001 | - | n/a | n/a | 63.96 ms | 4 | measured |
| flutter-skia | medium | open | ui-frame | 9.954/10.675 | - | - | - | n/a | n/a | 64.02 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 1.236/2.274 | - | 11.667/30.003 | 11.033/18.031 | n/a | n/a | 61.52 ms | 3 | measured |
| flutter-skia | medium | scroll | ui-frame | 2.529/4.142 | - | 10.083/10.001 | - | n/a | n/a | 66.16 ms | 3 | measured |
| flutter-skia | large | open | ui-frame | 9.645/9.797 | - | - | - | n/a | n/a | 65.30 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 1.128/1.745 | - | 11.000/20.000 | 10.599/14.786 | n/a | n/a | 65.44 ms | 2 | measured |
| flutter-skia | large | scroll | ui-frame | 2.476/4.055 | - | 10.111/10.001 | - | n/a | n/a | 63.37 ms | 4 | measured |
| flutter-skia | stress | open | ui-frame | 9.394/9.887 | - | - | - | n/a | n/a | 94.45 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 1.213/2.063 | - | 11.334/30.001 | 10.768/16.081 | n/a | n/a | 94.47 ms | 5 | measured |
| flutter-skia | stress | scroll | ui-frame | 2.585/4.230 | - | 10.000/10.001 | - | n/a | n/a | 94.40 ms | 2 | measured |
| flutter-impeller | small | open | ui-frame | 7.415/7.516 | - | - | - | n/a | n/a | 66.00 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 1.182/2.313 | - | 10.000/10.003 | 10.985/16.075 | n/a | n/a | 60.99 ms | 1 | measured |
| flutter-impeller | small | scroll | ui-frame | 2.224/2.946 | - | 10.111/10.001 | - | n/a | n/a | 62.82 ms | 3 | measured |
| flutter-impeller | medium | open | ui-frame | 7.682/8.169 | - | - | - | n/a | n/a | 63.40 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 1.190/2.113 | - | 10.333/30.001 | 10.760/16.799 | n/a | n/a | 67.26 ms | 2 | measured |
| flutter-impeller | medium | scroll | ui-frame | 2.571/4.208 | - | 10.083/10.001 | - | n/a | n/a | 60.09 ms | 3 | measured |
| flutter-impeller | large | open | ui-frame | 9.863/14.681 | - | - | - | n/a | n/a | 65.98 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 1.152/2.255 | - | 11.333/30.004 | 11.071/16.399 | n/a | n/a | 63.39 ms | 3 | measured |
| flutter-impeller | large | scroll | ui-frame | 2.649/4.326 | - | 10.083/10.001 | - | n/a | n/a | 64.25 ms | 4 | measured |
| flutter-impeller | stress | open | ui-frame | 6.866/7.243 | - | - | - | n/a | n/a | 92.27 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 1.128/1.528 | - | 11.667/30.001 | 9.795/14.509 | n/a | n/a | 98.38 ms | 3 | measured |
| flutter-impeller | stress | scroll | ui-frame | 2.688/4.353 | - | 10.028/10.001 | - | n/a | n/a | 94.86 ms | 2 | measured |
| electron | small | open | ui-frame | 15.200/15.500 | - | - | - | n/a | n/a | 15.20 ms | 0 | measured |
| electron | small | input | ui-frame | 1.673/3.200 | - | 10.334/13.336 | 8.717/11.800 | n/a | n/a | 15.07 ms | 0 | measured |
| electron | small | scroll | ui-frame | 1.828/2.400 | - | 9.922/11.600 | - | n/a | n/a | 15.60 ms | 0 | measured |
| electron | medium | open | ui-frame | 15.233/15.400 | - | - | - | n/a | n/a | 15.23 ms | 0 | measured |
| electron | medium | input | ui-frame | 1.737/3.400 | - | 9.228/11.700 | 8.647/11.800 | n/a | n/a | 15.43 ms | 0 | measured |
| electron | medium | scroll | ui-frame | 1.926/2.500 | - | 9.941/11.900 | - | n/a | n/a | 15.70 ms | 0 | measured |
| electron | large | open | ui-frame | 17.300/18.000 | - | - | - | n/a | n/a | 17.30 ms | 0 | measured |
| electron | large | input | ui-frame | 1.643/2.800 | - | 9.559/11.900 | 9.057/11.600 | n/a | n/a | 16.80 ms | 1 | measured |
| electron | large | scroll | ui-frame | 1.918/2.500 | - | 9.963/11.900 | - | n/a | n/a | 16.93 ms | 0 | measured |
| electron | stress | open | ui-frame | 25.800/26.800 | - | - | - | n/a | n/a | 25.80 ms | 0 | measured |
| electron | stress | input | ui-frame | 1.533/2.000 | - | 9.795/13.336 | 8.727/11.900 | n/a | n/a | 25.07 ms | 0 | measured |
| electron | stress | scroll | ui-frame | 1.924/2.400 | - | 9.959/11.900 | - | n/a | n/a | 26.03 ms | 0 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.16/2.07/2.08 | 4.89/4.70/4.76 | 6.90/6.65/6.61 | 10.50/10.14/10.07 | n/a/n/a/n/a |
| MoUI Skia GPU | 7.98/7.98/7.99 | 9.14/9.01/8.98 | 8.59/8.59/8.61 | 9.79/9.85/9.85 | n/a/n/a/n/a |
| MoUI WGPU | 7.67/7.67/7.66 | 8.95/8.97/8.91 | 8.35/8.33/8.33 | 9.44/9.46/9.36 | n/a/n/a/n/a |
| GPUI | 2.29/2.50/2.45 | 3.30/3.17/3.13 | 10.03/10.05/10.02 | 11.55/10.78/11.15 | n/a/n/a/n/a |
| Flutter Skia | 2.07/2.53/2.48 | 2.77/4.14/4.05 | 10.14/10.08/10.11 | 10.00/10.00/10.00 | 4/3/4 |
| Flutter Impeller | 2.22/2.57/2.65 | 2.95/4.21/4.33 | 10.11/10.08/10.08 | 10.00/10.00/10.00 | 3/3/4 |
| Electron | 1.83/1.93/1.92 | 2.40/2.50/2.50 | 9.92/9.94/9.96 | 11.60/11.90/11.90 | 0/0/0 |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.09 | 4.75 | 6.62 | 9.98 | n/a |
| MoUI Skia GPU | 7.98 | 8.97 | 8.59 | 9.77 | n/a |
| MoUI WGPU | 7.67 | 9.05 | 8.33 | 9.52 | n/a |
| GPUI | 2.49 | 3.22 | 10.03 | 10.46 | n/a |
| Flutter Skia | 2.58 | 4.23 | 10.00 | 10.00 | 2 |
| Flutter Impeller | 2.69 | 4.35 | 10.03 | 10.00 | 2 |
| Electron | 1.92 | 2.40 | 9.96 | 11.90 | 0 |

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） |
| --- | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 4.71/4.78/4.81 | 4.95/5.07/5.00 | 0.48/0.49/0.47 | 0.52/0.58/0.52 |
| MoUI Skia GPU | 8.49/8.52/8.83 | 9.52/9.47/10.35 | 8.14/8.14/8.29 | 9.17/9.10/9.81 |
| MoUI WGPU | 8.28/8.23/8.15 | 9.39/9.35/9.63 | 7.91/7.85/7.61 | 9.07/8.98/9.09 |
| GPUI | 10.35/9.80/9.75 | 17.89/15.99/18.50 | 1.85/1.84/1.85 | 2.01/1.99/1.96 |
| Flutter Skia | 10.85/11.03/10.60 | 15.85/18.03/14.79 | 1.37/1.24/1.13 | 2.93/2.27/1.75 |
| Flutter Impeller | 10.99/10.76/11.07 | 16.07/16.80/16.40 | 1.18/1.19/1.15 | 2.31/2.11/2.25 |
| Electron | 8.72/8.65/9.06 | 11.80/11.80/11.60 | 1.67/1.74/1.64 | 3.20/3.40/2.80 |

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） |
| --- | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 7.08 | 7.92 | 0.55 | 0.63 |
| MoUI Skia GPU | 9.05 | 10.53 | 6.33 | 8.22 |
| MoUI WGPU | 8.32 | 9.33 | 5.64 | 6.86 |
| GPUI | 10.39 | 18.69 | 1.88 | 2.01 |
| Flutter Skia | 10.77 | 16.08 | 1.21 | 2.06 |
| Flutter Impeller | 9.80 | 14.51 | 1.13 | 1.53 |
| Electron | 8.73 | 11.90 | 1.53 | 2.00 |

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 54.75/54.81/55.41 | 55.04/55.51/55.75 | 47.20/46.84/46.19 | 47.34/47.70/46.70 | 0.06/0.29/2.12 | 0.07/0.29/2.45 |
| MoUI Skia GPU | 61.07/91.23/61.97 | 61.83/153.72/64.14 | 59.30/89.31/58.44 | 60.12/151.85/60.64 | 0.07/0.29/2.12 | 0.07/0.30/2.49 |
| MoUI WGPU | 53.69/53.74/55.78 | 54.12/54.18/56.18 | 52.03/51.85/52.31 | 52.44/52.36/52.71 | 0.07/0.29/2.39 | 0.08/0.31/2.42 |
| GPUI | 136.08/143.62/125.35 | 145.26/167.74/127.75 | 2.35/2.16/2.17 | 2.85/2.25/2.21 | 0.00/0.33/2.33 | 0.00/1.00/3.00 |
| Flutter Skia | 62.16/64.02/65.30 | 64.98/65.41/68.72 | 9.54/9.95/9.65 | 10.14/10.68/9.80 | 0.11/0.15/0.57 | 0.13/0.20/0.80 |
| Flutter Impeller | 66.00/63.40/65.98 | 68.08/66.92/76.26 | 7.41/7.68/9.86 | 7.52/8.17/14.68 | 0.09/0.15/0.40 | 0.11/0.21/0.43 |
| Electron | 15.20/15.23/17.30 | 15.50/15.40/18.00 | 15.20/15.23/17.30 | 15.50/15.40/18.00 | 2.74/2.32/2.87 | 2.98/2.79/2.98 |

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 71.48 | 72.01 | 46.17 | 46.40 | 25.56 | 25.87 |
| MoUI Skia GPU | 76.88 | 78.59 | 57.31 | 59.11 | 25.33 | 25.45 |
| MoUI WGPU | 72.02 | 72.12 | 52.18 | 52.54 | 19.75 | 24.80 |
| GPUI | 123.28 | 124.53 | 2.24 | 2.48 | 26.00 | 28.00 |
| Flutter Skia | 94.45 | 95.91 | 9.39 | 9.89 | 3.12 | 3.16 |
| Flutter Impeller | 92.27 | 93.86 | 6.87 | 7.24 | 3.09 | 3.30 |
| Electron | 25.80 | 26.80 | 25.80 | 26.80 | 4.37 | 4.86 |

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 离屏均值（ms） | 离屏 P95（ms） | 回读均值（ms） | 回读 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.16/2.07/2.08 | 4.89/4.70/4.76 | 6.90/6.65/6.61 | 10.50/10.14/10.07 | n/a/n/a/n/a | 0.00/0.00/0.00 | 0.00/0.00/0.00 | 4.12/4.00/3.95 | 4.67/4.52/4.44 |
| MoUI Skia GPU | 7.98/7.98/7.99 | 9.14/9.01/8.98 | 8.59/8.59/8.61 | 9.79/9.85/9.85 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | 0.00/0.00/0.00 | 0.00/0.00/0.00 |
| MoUI WGPU | 7.67/7.67/7.66 | 8.95/8.97/8.91 | 8.35/8.33/8.33 | 9.44/9.46/9.36 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | 0.00/0.00/0.00 | 0.00/0.00/0.00 |
| GPUI | 2.29/2.50/2.45 | 3.30/3.17/3.13 | 10.03/10.05/10.02 | 11.55/10.78/11.15 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 2.07/2.53/2.48 | 2.77/4.14/4.05 | 10.14/10.08/10.11 | 10.00/10.00/10.00 | 4/3/4 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Impeller | 2.22/2.57/2.65 | 2.95/4.21/4.33 | 10.11/10.08/10.08 | 10.00/10.00/10.00 | 3/3/4 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Electron | 1.83/1.93/1.92 | 2.40/2.50/2.50 | 9.92/9.94/9.96 | 11.60/11.90/11.90 | 0/0/0 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 离屏均值（ms） | 离屏 P95（ms） | 回读均值（ms） | 回读 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.09 | 4.75 | 6.62 | 9.98 | n/a | 0.00 | 0.00 | 3.96 | 4.47 |
| MoUI Skia GPU | 7.98 | 8.97 | 8.59 | 9.77 | n/a | n/a | n/a | 0.00 | 0.00 |
| MoUI WGPU | 7.67 | 9.05 | 8.33 | 9.52 | n/a | n/a | n/a | 0.00 | 0.00 |
| GPUI | 2.49 | 3.22 | 10.03 | 10.46 | n/a | n/a | n/a | n/a | n/a |
| Flutter Skia | 2.58 | 4.23 | 10.00 | 10.00 | 2 | n/a | n/a | n/a | n/a |
| Flutter Impeller | 2.69 | 4.35 | 10.03 | 10.00 | 2 | n/a | n/a | n/a | n/a |
| Electron | 1.92 | 2.40 | 9.96 | 11.90 | 0 | n/a | n/a | n/a | n/a |

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoUI Skia GPU medium 91.2 ms（max 153.7 ms）；GPUI small 136.1 ms（max 145.3 ms）；GPUI medium 143.6 ms（max 167.7 ms）；GPUI large 125.3 ms（max 127.8 ms）；GPUI stress 123.3 ms（max 124.5 ms）。
- P1 输入尾延迟：GPUI small P95 17.89 ms；GPUI large P95 18.50 ms；GPUI stress P95 18.69 ms；Flutter Skia medium P95 18.03 ms；Flutter Impeller medium P95 16.80 ms。
- 长帧（超预算）：MoUI Skia Raster CPU: small/scroll 3 次，max 22.88 ms；GPUI: small/input 2 次，max 19.80 ms, small/scroll 3 次，max 22.78 ms, medium/input 1 次，max 17.49 ms, medium/scroll 3 次，max 26.28 ms, large/input 2 次，max 18.83 ms, large/scroll 1 次，max 18.04 ms, stress/input 3 次，max 18.74 ms, stress/scroll 2 次，max 20.30 ms；Flutter Skia: small/input 1 次，max 30.00 ms, small/scroll 4 次，max 30.00 ms, medium/input 3 次，max 30.00 ms, medium/scroll 3 次，max 20.00 ms, large/input 2 次，max 30.00 ms, large/scroll 4 次，max 30.00 ms, stress/input 5 次，max 30.00 ms, stress/scroll 2 次，max 20.00 ms；Flutter Impeller: small/input 1 次，max 30.00 ms, small/scroll 3 次，max 30.00 ms, medium/input 2 次，max 30.00 ms, medium/scroll 3 次，max 20.00 ms, large/input 3 次，max 30.00 ms, large/scroll 4 次，max 20.00 ms, stress/input 3 次，max 30.00 ms, stress/scroll 2 次，max 20.00 ms。
- 丢帧（优先处理）：Flutter Skia: small/input 1 帧, small/scroll 4 帧, medium/input 3 帧, medium/scroll 3 帧, large/input 2 帧, large/scroll 4 帧, stress/input 5 帧, stress/scroll 2 帧；Flutter Impeller: small/input 1 帧, small/scroll 3 帧, medium/input 2 帧, medium/scroll 3 帧, large/input 3 帧, large/scroll 4 帧, stress/input 3 帧, stress/scroll 2 帧；Electron: large/input 1 帧。
- 解释：首帧异常优先检查窗口/渲染器初始化；输入尾延迟检查 action 到下一可见帧的调度与同步重建；长帧检查解析、布局、文本 shaping 和 GPU 提交；`n/a` 表示未埋点，不等于 0。
- 普通模式的长帧、帧间隔和输入延迟是各框架回调诊断，不能替代跨框架 compositor 排名；需要严格结论时运行 `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`。

## 采集口径

- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。
- `frame_work_ms` 对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧；严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代；打开场景没有前一帧，所以不计算 interval/drop。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。
