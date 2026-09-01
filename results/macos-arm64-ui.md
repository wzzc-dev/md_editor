# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-08-31T11:23:20Z`
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
| moui-skia-raster | small | open | ui-frame | 44.349/46.025 | - | - | - | 0.00 ms | 5.62 ms | 51.69 ms | n/a | measured |
| moui-skia-raster | small | input | ui-frame | 0.465/0.485 | - | 4.639/4.841 | 4.638/4.840 | 0.00 ms | 3.87 ms | 51.85 ms | n/a | measured |
| moui-skia-raster | small | scroll | ui-frame | 2.031/4.666 | - | 6.446/9.794 | - | 0.00 ms | 3.86 ms | 50.54 ms | n/a | measured |
| moui-skia-raster | medium | open | ui-frame | 44.004/44.391 | - | - | - | 0.00 ms | 5.89 ms | 51.68 ms | n/a | measured |
| moui-skia-raster | medium | input | ui-frame | 0.472/0.526 | - | 4.605/4.828 | 4.605/4.828 | 0.00 ms | 3.82 ms | 51.93 ms | n/a | measured |
| moui-skia-raster | medium | scroll | ui-frame | 2.046/4.589 | - | 6.483/9.756 | - | 0.00 ms | 3.88 ms | 51.24 ms | n/a | measured |
| moui-skia-raster | large | open | ui-frame | 44.788/46.419 | - | - | - | 0.00 ms | 5.74 ms | 54.04 ms | n/a | measured |
| moui-skia-raster | large | input | ui-frame | 0.469/0.495 | - | 4.747/4.992 | 4.746/4.992 | 0.00 ms | 3.81 ms | 52.95 ms | n/a | measured |
| moui-skia-raster | large | scroll | ui-frame | 2.057/4.722 | - | 6.518/9.858 | - | 0.00 ms | 3.90 ms | 52.68 ms | n/a | measured |
| moui-skia-raster | stress | open | ui-frame | 43.484/43.885 | - | - | - | 0.00 ms | 5.26 ms | 68.39 ms | n/a | measured |
| moui-skia-raster | stress | input | ui-frame | 0.515/0.571 | - | 6.770/7.613 | 6.770/7.612 | 0.00 ms | 3.84 ms | 69.75 ms | n/a | measured |
| moui-skia-raster | stress | scroll | ui-frame | 2.043/4.635 | - | 6.478/9.845 | - | 0.00 ms | 3.88 ms | 69.15 ms | n/a | measured |
| moui-skia-gpu | small | open | ui-frame | 53.625/53.785 | - | - | - | n/a | 0.00 ms | 55.26 ms | n/a | measured |
| moui-skia-gpu | small | input | ui-frame | 8.393/9.766 | - | 8.770/10.090 | 8.769/10.089 | n/a | 0.00 ms | 55.99 ms | n/a | measured |
| moui-skia-gpu | small | scroll | ui-frame | 7.968/9.016 | - | 8.549/9.746 | - | n/a | 0.00 ms | 55.15 ms | n/a | measured |
| moui-skia-gpu | medium | open | ui-frame | 53.596/54.029 | - | - | - | n/a | 0.00 ms | 55.35 ms | n/a | measured |
| moui-skia-gpu | medium | input | ui-frame | 8.362/9.499 | - | 8.703/9.840 | 8.702/9.839 | n/a | 0.00 ms | 55.55 ms | n/a | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 7.970/9.052 | - | 8.550/9.800 | - | n/a | 0.00 ms | 54.76 ms | n/a | measured |
| moui-skia-gpu | large | open | ui-frame | 52.743/53.025 | - | - | - | n/a | 0.00 ms | 56.10 ms | n/a | measured |
| moui-skia-gpu | large | input | ui-frame | 8.169/9.222 | - | 8.650/9.737 | 8.650/9.736 | n/a | 0.00 ms | 56.39 ms | n/a | measured |
| moui-skia-gpu | large | scroll | ui-frame | 8.023/9.070 | - | 8.623/9.781 | - | n/a | 0.00 ms | 58.03 ms | n/a | measured |
| moui-skia-gpu | stress | open | ui-frame | 53.773/55.429 | - | - | - | n/a | 0.00 ms | 73.40 ms | n/a | measured |
| moui-skia-gpu | stress | input | ui-frame | 7.211/8.776 | - | 9.616/11.008 | 9.615/11.008 | n/a | 0.00 ms | 73.07 ms | n/a | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 7.971/9.160 | - | 8.560/9.765 | - | n/a | 0.00 ms | 76.87 ms | n/a | measured |
| moui-wgpu | small | open | ui-frame | 50.617/51.770 | - | - | - | n/a | 0.00 ms | 52.30 ms | n/a | measured |
| moui-wgpu | small | input | ui-frame | 7.954/9.235 | - | 8.310/9.583 | 8.309/9.582 | n/a | 0.00 ms | 53.18 ms | n/a | measured |
| moui-wgpu | small | scroll | ui-frame | 7.671/9.053 | - | 8.333/9.503 | - | n/a | 0.00 ms | 52.47 ms | n/a | measured |
| moui-wgpu | medium | open | ui-frame | 50.896/51.412 | - | - | - | n/a | 0.00 ms | 52.75 ms | n/a | measured |
| moui-wgpu | medium | input | ui-frame | 7.893/9.132 | - | 8.256/9.445 | 8.255/9.444 | n/a | 0.00 ms | 53.24 ms | n/a | measured |
| moui-wgpu | medium | scroll | ui-frame | 7.669/8.921 | - | 8.329/9.367 | - | n/a | 0.00 ms | 52.68 ms | n/a | measured |
| moui-wgpu | large | open | ui-frame | 52.163/53.790 | - | - | - | n/a | 0.00 ms | 55.70 ms | n/a | measured |
| moui-wgpu | large | input | ui-frame | 7.703/8.995 | - | 8.232/9.481 | 8.232/9.480 | n/a | 0.00 ms | 54.69 ms | n/a | measured |
| moui-wgpu | large | scroll | ui-frame | 7.669/8.927 | - | 8.329/9.347 | - | n/a | 0.00 ms | 54.56 ms | n/a | measured |
| moui-wgpu | stress | open | ui-frame | 51.024/51.142 | - | - | - | n/a | 0.00 ms | 70.76 ms | n/a | measured |
| moui-wgpu | stress | input | ui-frame | 5.691/6.833 | - | 8.350/9.432 | 8.349/9.431 | n/a | 0.00 ms | 71.34 ms | n/a | measured |
| moui-wgpu | stress | scroll | ui-frame | 7.671/8.928 | - | 8.328/9.448 | - | n/a | 0.00 ms | 73.35 ms | n/a | measured |
| gpui | small | open | ui-frame | 1.892/1.944 | - | - | - | n/a | n/a | 121.71 ms | n/a | measured |
| gpui | small | input | ui-frame | 1.768/1.961 | 0.140/0.178 | 10.178/18.734 | 10.176/18.730 | n/a | n/a | 122.21 ms | n/a | measured |
| gpui | small | scroll | ui-frame | 2.351/3.182 | 0.002/0.004 | 9.966/11.943 | - | n/a | n/a | 141.50 ms | n/a | measured |
| gpui | medium | open | ui-frame | 1.995/2.064 | - | - | - | n/a | n/a | 119.84 ms | n/a | measured |
| gpui | medium | input | ui-frame | 1.775/1.963 | 0.138/0.161 | 9.847/15.948 | 9.844/15.947 | n/a | n/a | 119.44 ms | n/a | measured |
| gpui | medium | scroll | ui-frame | 2.402/3.223 | 0.002/0.004 | 9.972/11.935 | - | n/a | n/a | 138.00 ms | n/a | measured |
| gpui | large | open | ui-frame | 1.957/1.984 | - | - | - | n/a | n/a | 119.42 ms | n/a | measured |
| gpui | large | input | ui-frame | 1.767/1.937 | 0.147/0.178 | 10.283/16.423 | 10.281/16.421 | n/a | n/a | 119.43 ms | n/a | measured |
| gpui | large | scroll | ui-frame | 2.433/3.200 | 0.002/0.004 | 10.022/11.934 | - | n/a | n/a | 142.78 ms | n/a | measured |
| gpui | stress | open | ui-frame | 1.931/2.028 | - | - | - | n/a | n/a | 119.72 ms | n/a | measured |
| gpui | stress | input | ui-frame | 1.821/2.107 | 0.146/0.216 | 10.184/20.050 | 10.181/20.049 | n/a | n/a | 119.19 ms | n/a | measured |
| gpui | stress | scroll | ui-frame | 2.416/3.166 | 0.002/0.004 | 10.032/11.943 | - | n/a | n/a | 126.07 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 8.807/8.981 | - | - | - | n/a | n/a | 30.42 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 0.890/1.665 | - | 10.000/10.001 | 9.968/10.195 | n/a | n/a | 26.55 ms | 0 | measured |
| flutter-skia | small | scroll | ui-frame | 2.108/2.868 | - | 10.056/10.002 | - | n/a | n/a | 31.87 ms | 2 | measured |
| flutter-skia | medium | open | ui-frame | 8.318/8.625 | - | - | - | n/a | n/a | 29.00 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 0.849/1.477 | - | 10.000/10.001 | 9.977/10.198 | n/a | n/a | 28.21 ms | 0 | measured |
| flutter-skia | medium | scroll | ui-frame | 2.519/4.053 | - | 9.972/10.001 | - | n/a | n/a | 32.45 ms | 1 | measured |
| flutter-skia | large | open | ui-frame | 8.245/8.382 | - | - | - | n/a | n/a | 28.95 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 0.880/1.422 | - | 10.000/10.002 | 9.982/10.208 | n/a | n/a | 30.16 ms | 0 | measured |
| flutter-skia | large | scroll | ui-frame | 2.454/4.108 | - | 10.028/10.001 | - | n/a | n/a | 33.35 ms | 1 | measured |
| flutter-skia | stress | open | ui-frame | 7.752/7.998 | - | - | - | n/a | n/a | 64.43 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 0.868/1.367 | - | 10.000/10.002 | 10.498/17.626 | n/a | n/a | 63.12 ms | 0 | measured |
| flutter-skia | stress | scroll | ui-frame | 2.376/4.014 | - | 10.028/10.001 | - | n/a | n/a | 63.85 ms | 1 | measured |
| flutter-impeller | small | open | ui-frame | 6.564/6.721 | - | - | - | n/a | n/a | 30.32 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 1.003/1.696 | - | 10.000/10.002 | 9.979/10.134 | n/a | n/a | 30.99 ms | 0 | measured |
| flutter-impeller | small | scroll | ui-frame | 2.154/2.858 | - | 9.944/10.001 | - | n/a | n/a | 31.50 ms | 0 | measured |
| flutter-impeller | medium | open | ui-frame | 6.446/6.472 | - | - | - | n/a | n/a | 30.59 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 1.009/1.868 | - | 10.000/10.002 | 9.982/10.110 | n/a | n/a | 29.95 ms | 0 | measured |
| flutter-impeller | medium | scroll | ui-frame | 2.499/3.948 | - | 10.056/10.001 | - | n/a | n/a | 28.66 ms | 1 | measured |
| flutter-impeller | large | open | ui-frame | 6.860/7.287 | - | - | - | n/a | n/a | 32.67 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 1.016/1.461 | - | 10.000/10.003 | 10.351/10.161 | n/a | n/a | 33.40 ms | 0 | measured |
| flutter-impeller | large | scroll | ui-frame | 2.549/4.034 | - | 10.000/10.001 | - | n/a | n/a | 30.44 ms | 1 | measured |
| flutter-impeller | stress | open | ui-frame | 6.390/6.678 | - | - | - | n/a | n/a | 61.16 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 1.079/1.903 | - | 9.333/10.002 | 10.375/16.777 | n/a | n/a | 61.25 ms | 0 | measured |
| flutter-impeller | stress | scroll | ui-frame | 2.555/4.071 | - | 10.000/10.001 | - | n/a | n/a | 61.50 ms | 0 | measured |
| electron | small | open | ui-frame | 82.533/82.900 | - | - | - | n/a | n/a | 82.53 ms | 0 | measured |
| electron | small | input | ui-frame | 1.583/2.100 | - | 9.867/12.000 | 9.287/12.100 | n/a | n/a | 82.80 ms | 0 | measured |
| electron | small | scroll | ui-frame | 1.871/2.400 | - | 10.001/11.900 | - | n/a | n/a | 85.40 ms | 0 | measured |
| electron | medium | open | ui-frame | 82.900/83.600 | - | - | - | n/a | n/a | 82.90 ms | 0 | measured |
| electron | medium | input | ui-frame | 1.630/2.400 | - | 9.967/11.900 | 9.290/11.900 | n/a | n/a | 87.90 ms | 0 | measured |
| electron | medium | scroll | ui-frame | 1.854/2.400 | - | 9.994/11.900 | - | n/a | n/a | 83.10 ms | 0 | measured |
| electron | large | open | ui-frame | 88.500/96.600 | - | - | - | n/a | n/a | 88.50 ms | 0 | measured |
| electron | large | input | ui-frame | 1.620/2.000 | - | 9.893/11.800 | 9.680/11.900 | n/a | n/a | 84.70 ms | 0 | measured |
| electron | large | scroll | ui-frame | 1.885/2.400 | - | 9.995/11.900 | - | n/a | n/a | 88.43 ms | 0 | measured |
| electron | stress | open | ui-frame | 107.367/108.300 | - | - | - | n/a | n/a | 107.37 ms | 0 | measured |
| electron | stress | input | ui-frame | 1.630/2.200 | - | 10.027/12.000 | 9.487/12.000 | n/a | n/a | 98.77 ms | 0 | measured |
| electron | stress | scroll | ui-frame | 1.931/2.400 | - | 9.994/11.900 | - | n/a | n/a | 99.33 ms | 0 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.03/2.05/2.06 | 4.67/4.59/4.72 | 6.45/6.48/6.52 | 9.79/9.76/9.86 | n/a/n/a/n/a |
| MoUI Skia GPU | 7.97/7.97/8.02 | 9.02/9.05/9.07 | 8.55/8.55/8.62 | 9.75/9.80/9.78 | n/a/n/a/n/a |
| MoUI WGPU | 7.67/7.67/7.67 | 9.05/8.92/8.93 | 8.33/8.33/8.33 | 9.50/9.37/9.35 | n/a/n/a/n/a |
| GPUI | 2.35/2.40/2.43 | 3.18/3.22/3.20 | 9.97/9.97/10.02 | 11.94/11.94/11.93 | n/a/n/a/n/a |
| Flutter Skia | 2.11/2.52/2.45 | 2.87/4.05/4.11 | 10.06/9.97/10.03 | 10.00/10.00/10.00 | 2/1/1 |
| Flutter Impeller | 2.15/2.50/2.55 | 2.86/3.95/4.03 | 9.94/10.06/10.00 | 10.00/10.00/10.00 | 0/1/1 |
| Electron | 1.87/1.85/1.89 | 2.40/2.40/2.40 | 10.00/9.99/9.99 | 11.90/11.90/11.90 | 0/0/0 |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.04 | 4.63 | 6.48 | 9.84 | n/a |
| MoUI Skia GPU | 7.97 | 9.16 | 8.56 | 9.77 | n/a |
| MoUI WGPU | 7.67 | 8.93 | 8.33 | 9.45 | n/a |
| GPUI | 2.42 | 3.17 | 10.03 | 11.94 | n/a |
| Flutter Skia | 2.38 | 4.01 | 10.03 | 10.00 | 1 |
| Flutter Impeller | 2.55 | 4.07 | 10.00 | 10.00 | 0 |
| Electron | 1.93 | 2.40 | 9.99 | 11.90 | 0 |

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） |
| --- | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 4.64/4.61/4.75 | 4.84/4.83/4.99 | 0.47/0.47/0.47 | 0.48/0.53/0.49 |
| MoUI Skia GPU | 8.77/8.70/8.65 | 10.09/9.84/9.74 | 8.39/8.36/8.17 | 9.77/9.50/9.22 |
| MoUI WGPU | 8.31/8.26/8.23 | 9.58/9.44/9.48 | 7.95/7.89/7.70 | 9.24/9.13/8.99 |
| GPUI | 10.18/9.84/10.28 | 18.73/15.95/16.42 | 1.77/1.78/1.77 | 1.96/1.96/1.94 |
| Flutter Skia | 9.97/9.98/9.98 | 10.20/10.20/10.21 | 0.89/0.85/0.88 | 1.67/1.48/1.42 |
| Flutter Impeller | 9.98/9.98/10.35 | 10.13/10.11/10.16 | 1.00/1.01/1.02 | 1.70/1.87/1.46 |
| Electron | 9.29/9.29/9.68 | 12.10/11.90/11.90 | 1.58/1.63/1.62 | 2.10/2.40/2.00 |

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） |
| --- | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.77 | 7.61 | 0.52 | 0.57 |
| MoUI Skia GPU | 9.62 | 11.01 | 7.21 | 8.78 |
| MoUI WGPU | 8.35 | 9.43 | 5.69 | 6.83 |
| GPUI | 10.18 | 20.05 | 1.82 | 2.11 |
| Flutter Skia | 10.50 | 17.63 | 0.87 | 1.37 |
| Flutter Impeller | 10.38 | 16.78 | 1.08 | 1.90 |
| Electron | 9.49 | 12.00 | 1.63 | 2.20 |

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 51.69/51.68/54.04 | 53.55/52.19/55.62 | 44.35/44.00/44.79 | 46.02/44.39/46.42 | 0.06/0.26/2.11 | 0.06/0.33/2.45 |
| MoUI Skia GPU | 55.26/55.35/56.10 | 55.41/55.79/56.40 | 53.62/53.60/52.74 | 53.78/54.03/53.03 | 0.06/0.29/2.10 | 0.07/0.30/2.48 |
| MoUI WGPU | 52.30/52.75/55.70 | 53.42/53.24/57.34 | 50.62/50.90/52.16 | 51.77/51.41/53.79 | 0.05/0.27/1.70 | 0.06/0.29/2.36 |
| GPUI | 121.71/119.84/119.42 | 122.01/120.81/119.88 | 1.89/1.99/1.96 | 1.94/2.06/1.98 | 0.00/0.33/2.67 | 0.00/1.00/3.00 |
| Flutter Skia | 30.42/29.00/28.95 | 33.86/31.30/31.61 | 8.81/8.32/8.25 | 8.98/8.62/8.38 | 0.07/0.09/0.33 | 0.07/0.09/0.38 |
| Flutter Impeller | 30.32/30.59/32.67 | 31.16/32.93/35.95 | 6.56/6.45/6.86 | 6.72/6.47/7.29 | 0.08/0.10/0.33 | 0.10/0.10/0.33 |
| Electron | 82.53/82.90/88.50 | 82.90/83.60/96.60 | 82.53/82.90/88.50 | 82.90/83.60/96.60 | 2.13/2.18/2.77 | 2.63/2.63/2.83 |

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 68.39 | 68.85 | 43.48 | 43.88 | 24.55 | 24.86 |
| MoUI Skia GPU | 73.40 | 75.08 | 53.77 | 55.43 | 25.12 | 25.83 |
| MoUI WGPU | 70.76 | 71.04 | 51.02 | 51.14 | 23.02 | 25.71 |
| GPUI | 119.72 | 123.38 | 1.93 | 2.03 | 20.67 | 26.00 |
| Flutter Skia | 64.43 | 66.61 | 7.75 | 8.00 | 2.56 | 2.60 |
| Flutter Impeller | 61.16 | 63.76 | 6.39 | 6.68 | 2.57 | 2.63 |
| Electron | 107.37 | 108.30 | 107.37 | 108.30 | 4.48 | 4.60 |

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 离屏均值（ms） | 离屏 P95（ms） | 回读均值（ms） | 回读 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.03/2.05/2.06 | 4.67/4.59/4.72 | 6.45/6.48/6.52 | 9.79/9.76/9.86 | n/a/n/a/n/a | 0.00/0.00/0.00 | 0.00/0.00/0.00 | 3.86/3.88/3.90 | 4.34/4.37/4.40 |
| MoUI Skia GPU | 7.97/7.97/8.02 | 9.02/9.05/9.07 | 8.55/8.55/8.62 | 9.75/9.80/9.78 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | 0.00/0.00/0.00 | 0.00/0.00/0.00 |
| MoUI WGPU | 7.67/7.67/7.67 | 9.05/8.92/8.93 | 8.33/8.33/8.33 | 9.50/9.37/9.35 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | 0.00/0.00/0.00 | 0.00/0.00/0.00 |
| GPUI | 2.35/2.40/2.43 | 3.18/3.22/3.20 | 9.97/9.97/10.02 | 11.94/11.94/11.93 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 2.11/2.52/2.45 | 2.87/4.05/4.11 | 10.06/9.97/10.03 | 10.00/10.00/10.00 | 2/1/1 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Impeller | 2.15/2.50/2.55 | 2.86/3.95/4.03 | 9.94/10.06/10.00 | 10.00/10.00/10.00 | 0/1/1 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Electron | 1.87/1.85/1.89 | 2.40/2.40/2.40 | 10.00/9.99/9.99 | 11.90/11.90/11.90 | 0/0/0 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 离屏均值（ms） | 离屏 P95（ms） | 回读均值（ms） | 回读 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.04 | 4.63 | 6.48 | 9.84 | n/a | 0.00 | 0.00 | 3.88 | 4.35 |
| MoUI Skia GPU | 7.97 | 9.16 | 8.56 | 9.77 | n/a | n/a | n/a | 0.00 | 0.00 |
| MoUI WGPU | 7.67 | 8.93 | 8.33 | 9.45 | n/a | n/a | n/a | 0.00 | 0.00 |
| GPUI | 2.42 | 3.17 | 10.03 | 11.94 | n/a | n/a | n/a | n/a | n/a |
| Flutter Skia | 2.38 | 4.01 | 10.03 | 10.00 | 1 | n/a | n/a | n/a | n/a |
| Flutter Impeller | 2.55 | 4.07 | 10.00 | 10.00 | 0 | n/a | n/a | n/a | n/a |
| Electron | 1.93 | 2.40 | 9.99 | 11.90 | 0 | n/a | n/a | n/a | n/a |

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：GPUI small 121.7 ms（max 122.0 ms）；GPUI medium 119.8 ms（max 120.8 ms）；GPUI large 119.4 ms（max 119.9 ms）；GPUI stress 119.7 ms（max 123.4 ms）；Electron stress 107.4 ms（max 108.3 ms）。
- P1 输入尾延迟：GPUI small P95 18.73 ms；GPUI stress P95 20.05 ms；Flutter Skia stress P95 17.63 ms；Flutter Impeller stress P95 16.78 ms。
- 长帧（超预算）：MoUI Skia GPU: large/scroll 2 次，max 17.90 ms；GPUI: small/input 3 次，max 23.78 ms, small/scroll 1 次，max 17.28 ms, medium/input 1 次，max 16.86 ms, medium/scroll 3 次，max 18.01 ms, large/input 1 次，max 26.41 ms, large/scroll 2 次，max 26.71 ms, stress/input 3 次，max 25.15 ms, stress/scroll 1 次，max 19.87 ms；Flutter Skia: small/scroll 2 次，max 20.00 ms, medium/scroll 1 次，max 20.00 ms, large/scroll 1 次，max 20.00 ms, stress/scroll 1 次，max 20.00 ms；Flutter Impeller: medium/scroll 1 次，max 30.00 ms, large/scroll 1 次，max 20.00 ms。
- 丢帧（优先处理）：Flutter Skia: small/scroll 2 帧, medium/scroll 1 帧, large/scroll 1 帧, stress/scroll 1 帧；Flutter Impeller: medium/scroll 1 帧, large/scroll 1 帧。
- 解释：首帧异常优先检查窗口/渲染器初始化；输入尾延迟检查 action 到下一可见帧的调度与同步重建；长帧检查解析、布局、文本 shaping 和 GPU 提交；`n/a` 表示未埋点，不等于 0。
- 普通模式的长帧、帧间隔和输入延迟是各框架回调诊断，不能替代跨框架 compositor 排名；需要严格结论时运行 `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`。

## 采集口径

- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。
- `frame_work_ms` 对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧；严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代；打开场景没有前一帧，所以不计算 interval/drop。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。
