# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-08-28T16:43:56Z`
- 数据状态：`252 measured`，`0 skipped/error`；原始样本保留在 JSON。
- Host：`macOS-26.3-arm64-arm-64bit` / `arm64` / `16.0 GiB`；GPU：`Apple M4`
- OS：`25.3.0`；CPU：`arm`；toolchains：`python=3.12.11, moon=moon 0.1.20260824 (dae026a 2026-08-24), rustc=rustc 1.94.0 (4a4ef493e 2026-03-02), cargo=cargo 1.94.0 (85eff7c80 2026-01-15), node=v25.2.1, npm=11.6.2, flutter=Flutter 3.47.1 • channel stable • https://github.com/flutter/flutter.git`
- 统一配置：`1280x800 @ 60 Hz`；font `system-ui 16px`；line-height `1.55`；overscan `3`；fixed row `66px`；GPU backend `Metal`
- Fixture：`small=5KB/100 blocks`，`medium=50KB/1,000 blocks`，`large=500KB/10,000 blocks`，`stress=5MB/100,000 blocks`。
- 汇总口径：mean/P95 合并原始样本；每格 repetition `3`、process warm-up `1`；drop 为各 repetition dropped_display_frames 之和。
- 公平性口径：所有 ui-frame 记录使用相同 fixture、viewport、动作数、warm-up 和重复次数；数值来自框架真实渲染/提交回调。MoUI ui-frame 是 headless host-surface，GPUI 的 work 当前只覆盖 action dispatch；不同框架的显示时间戳由各自平台 API 提供，因此报告不做跨时钟的综合排名。`n/a` 表示没有采集，绝不等同于 0。

<details><summary>原始 ui-frame 汇总（可审计）</summary>

| 实现 | 测试集合 | 场景 | 范围 | 工作均值/P95 | 仅分发均值/P95 | 帧间隔均值/P95 | 输入到可见均值/P95 | 离屏均值 | 回读均值 | 首次可交互 | 丢帧数 | 状态 |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| moui-skia-raster | small | open | ui-frame | 46.775/47.416 | - | - | - | 0.00 ms | 6.05 ms | 54.51 ms | 0 | measured |
| moui-skia-raster | small | input | ui-frame | 0.515/0.616 | - | 5.020/5.762 | 5.020/5.758 | 0.00 ms | 4.15 ms | 55.07 ms | 0 | measured |
| moui-skia-raster | small | scroll | ui-frame | 2.106/4.655 | - | 6.834/10.132 | - | 0.00 ms | 4.14 ms | 53.71 ms | 0 | measured |
| moui-skia-raster | medium | open | ui-frame | 46.461/47.435 | - | - | - | 0.00 ms | 6.21 ms | 54.62 ms | 0 | measured |
| moui-skia-raster | medium | input | ui-frame | 0.508/0.613 | - | 4.854/5.230 | 4.854/5.230 | 0.00 ms | 4.01 ms | 54.48 ms | 0 | measured |
| moui-skia-raster | medium | scroll | ui-frame | 2.161/4.895 | - | 6.842/10.515 | - | 0.00 ms | 4.08 ms | 54.13 ms | 0 | measured |
| moui-skia-raster | large | open | ui-frame | 47.126/47.726 | - | - | - | 0.00 ms | 6.13 ms | 57.36 ms | 0 | measured |
| moui-skia-raster | large | input | ui-frame | 0.497/0.531 | - | 4.987/5.328 | 4.987/5.327 | 0.00 ms | 4.00 ms | 55.48 ms | 0 | measured |
| moui-skia-raster | large | scroll | ui-frame | 2.139/4.942 | - | 6.812/10.477 | - | 0.00 ms | 4.08 ms | 55.86 ms | 0 | measured |
| moui-skia-raster | stress | open | ui-frame | 46.814/47.463 | - | - | - | 0.00 ms | 5.66 ms | 79.33 ms | 0 | measured |
| moui-skia-raster | stress | input | ui-frame | 0.556/0.628 | - | 7.309/8.446 | 7.308/8.445 | 0.00 ms | 4.07 ms | 78.02 ms | 0 | measured |
| moui-skia-raster | stress | scroll | ui-frame | 2.234/4.954 | - | 7.048/10.396 | - | 0.00 ms | 4.21 ms | 77.79 ms | 4 | measured |
| moui-skia-gpu | small | open | ui-frame | 59.365/62.507 | - | - | - | n/a | 0.00 ms | 61.01 ms | 0 | measured |
| moui-skia-gpu | small | input | ui-frame | 8.206/9.272 | - | 8.560/9.592 | 8.558/9.592 | n/a | 0.00 ms | 60.52 ms | 0 | measured |
| moui-skia-gpu | small | scroll | ui-frame | 7.963/8.969 | - | 8.581/9.714 | - | n/a | 0.00 ms | 59.32 ms | 0 | measured |
| moui-skia-gpu | medium | open | ui-frame | 57.721/61.917 | - | - | - | n/a | 0.00 ms | 59.60 ms | 0 | measured |
| moui-skia-gpu | medium | input | ui-frame | 8.379/10.354 | - | 8.751/10.709 | 8.750/10.708 | n/a | 0.00 ms | 59.09 ms | 0 | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 7.994/9.004 | - | 8.611/9.957 | - | n/a | 0.00 ms | 60.89 ms | 0 | measured |
| moui-skia-gpu | large | open | ui-frame | 59.976/62.136 | - | - | - | n/a | 0.00 ms | 64.11 ms | 0 | measured |
| moui-skia-gpu | large | input | ui-frame | 8.218/10.140 | - | 8.780/10.715 | 8.779/10.715 | n/a | 0.00 ms | 64.64 ms | 0 | measured |
| moui-skia-gpu | large | scroll | ui-frame | 7.981/9.038 | - | 8.606/9.859 | - | n/a | 0.00 ms | 61.02 ms | 0 | measured |
| moui-skia-gpu | stress | open | ui-frame | 55.746/56.265 | - | - | - | n/a | 0.00 ms | 82.07 ms | 0 | measured |
| moui-skia-gpu | stress | input | ui-frame | 6.725/8.107 | - | 9.381/10.363 | 9.380/10.363 | n/a | 0.00 ms | 83.06 ms | 0 | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 8.001/8.980 | - | 8.615/9.877 | - | n/a | 0.00 ms | 83.55 ms | 0 | measured |
| moui-wgpu | small | open | ui-frame | 55.987/57.451 | - | - | - | n/a | 0.00 ms | 57.62 ms | 0 | measured |
| moui-wgpu | small | input | ui-frame | 7.786/9.140 | - | 8.169/9.522 | 8.169/9.521 | n/a | 0.00 ms | 57.80 ms | 0 | measured |
| moui-wgpu | small | scroll | ui-frame | 7.686/9.007 | - | 8.332/9.443 | - | n/a | 0.00 ms | 59.01 ms | 0 | measured |
| moui-wgpu | medium | open | ui-frame | 55.389/56.755 | - | - | - | n/a | 0.00 ms | 57.27 ms | 0 | measured |
| moui-wgpu | medium | input | ui-frame | 7.765/9.161 | - | 8.142/9.532 | 8.141/9.532 | n/a | 0.00 ms | 58.14 ms | 0 | measured |
| moui-wgpu | medium | scroll | ui-frame | 7.676/8.973 | - | 8.334/9.439 | - | n/a | 0.00 ms | 56.93 ms | 0 | measured |
| moui-wgpu | large | open | ui-frame | 55.165/55.526 | - | - | - | n/a | 0.00 ms | 59.41 ms | 0 | measured |
| moui-wgpu | large | input | ui-frame | 7.610/9.059 | - | 8.172/9.630 | 8.171/9.630 | n/a | 0.00 ms | 59.90 ms | 0 | measured |
| moui-wgpu | large | scroll | ui-frame | 7.673/8.975 | - | 8.332/9.426 | - | n/a | 0.00 ms | 59.82 ms | 0 | measured |
| moui-wgpu | stress | open | ui-frame | 55.114/55.256 | - | - | - | n/a | 0.00 ms | 82.14 ms | 0 | measured |
| moui-wgpu | stress | input | ui-frame | 5.482/6.688 | - | 8.327/9.231 | 8.326/9.230 | n/a | 0.00 ms | 103.54 ms | 0 | measured |
| moui-wgpu | stress | scroll | ui-frame | 7.672/8.890 | - | 8.331/9.365 | - | n/a | 0.00 ms | 81.33 ms | 0 | measured |
| gpui | small | open | ui-frame | 0.000/0.000 | - | - | - | n/a | n/a | 170.91 ms | 0 | measured |
| gpui | small | input | ui-frame | 0.145/0.171 | - | 10.372/17.218 | 10.369/17.216 | n/a | n/a | 152.51 ms | 3 | measured |
| gpui | small | scroll | ui-frame | 0.003/0.004 | - | 10.010/11.612 | - | n/a | n/a | 141.68 ms | 2 | measured |
| gpui | medium | open | ui-frame | 0.000/0.000 | - | - | - | n/a | n/a | 149.14 ms | 0 | measured |
| gpui | medium | input | ui-frame | 0.144/0.187 | - | 10.585/17.450 | 10.582/17.449 | n/a | n/a | 139.20 ms | 2 | measured |
| gpui | medium | scroll | ui-frame | 0.003/0.005 | - | 10.036/11.977 | - | n/a | n/a | 136.11 ms | 3 | measured |
| gpui | large | open | ui-frame | 0.000/0.000 | - | - | - | n/a | n/a | 135.13 ms | 0 | measured |
| gpui | large | input | ui-frame | 0.151/0.206 | - | 10.286/18.014 | 10.284/18.013 | n/a | n/a | 132.91 ms | 3 | measured |
| gpui | large | scroll | ui-frame | 0.003/0.004 | - | 9.964/11.817 | - | n/a | n/a | 137.05 ms | 2 | measured |
| gpui | stress | open | ui-frame | 0.000/0.000 | - | - | - | n/a | n/a | 125.06 ms | 0 | measured |
| gpui | stress | input | ui-frame | 0.138/0.164 | - | 10.182/16.357 | 10.180/16.354 | n/a | n/a | 124.77 ms | 2 | measured |
| gpui | stress | scroll | ui-frame | 0.003/0.004 | - | 9.963/11.998 | - | n/a | n/a | 128.37 ms | 2 | measured |
| flutter-skia | small | open | ui-frame | 65.230/67.412 | - | - | - | n/a | n/a | 65.23 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 1.751/2.734 | - | 11.333/30.001 | 10.027/14.764 | n/a | n/a | 64.04 ms | 2 | measured |
| flutter-skia | small | scroll | ui-frame | 1.898/2.619 | - | 10.111/10.002 | - | n/a | n/a | 59.73 ms | 3 | measured |
| flutter-skia | medium | open | ui-frame | 60.742/62.940 | - | - | - | n/a | n/a | 60.74 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 1.769/2.768 | - | 10.667/10.002 | 9.954/10.367 | n/a | n/a | 58.28 ms | 1 | measured |
| flutter-skia | medium | scroll | ui-frame | 2.333/3.721 | - | 10.056/10.001 | - | n/a | n/a | 63.26 ms | 2 | measured |
| flutter-skia | large | open | ui-frame | 62.719/65.721 | - | - | - | n/a | n/a | 62.72 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 1.848/3.453 | - | 12.000/30.001 | 9.980/12.949 | n/a | n/a | 63.09 ms | 3 | measured |
| flutter-skia | large | scroll | ui-frame | 2.233/3.792 | - | 10.056/10.002 | - | n/a | n/a | 63.61 ms | 2 | measured |
| flutter-skia | stress | open | ui-frame | 92.953/95.960 | - | - | - | n/a | n/a | 92.95 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 1.795/2.938 | - | 11.667/20.001 | 10.572/15.062 | n/a | n/a | 90.39 ms | 5 | measured |
| flutter-skia | stress | scroll | ui-frame | 2.317/3.674 | - | 10.000/10.001 | - | n/a | n/a | 90.31 ms | 0 | measured |
| flutter-impeller | small | open | ui-frame | 66.991/68.688 | - | - | - | n/a | n/a | 66.99 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 1.687/2.423 | - | 11.334/20.000 | 10.042/13.242 | n/a | n/a | 62.75 ms | 3 | measured |
| flutter-impeller | small | scroll | ui-frame | 2.013/2.759 | - | 10.111/10.001 | - | n/a | n/a | 64.05 ms | 3 | measured |
| flutter-impeller | medium | open | ui-frame | 45.634/64.825 | - | - | - | n/a | n/a | 64.97 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 1.755/2.487 | - | 10.333/10.004 | 9.900/13.733 | n/a | n/a | 61.47 ms | 1 | measured |
| flutter-impeller | medium | scroll | ui-frame | 2.313/3.738 | - | 10.056/10.001 | - | n/a | n/a | 62.31 ms | 2 | measured |
| flutter-impeller | large | open | ui-frame | 64.068/65.518 | - | - | - | n/a | n/a | 64.07 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 1.784/2.839 | - | 11.334/30.001 | 9.819/13.551 | n/a | n/a | 65.77 ms | 2 | measured |
| flutter-impeller | large | scroll | ui-frame | 2.327/3.814 | - | 10.056/10.001 | - | n/a | n/a | 64.52 ms | 2 | measured |
| flutter-impeller | stress | open | ui-frame | 96.197/102.744 | - | - | - | n/a | n/a | 96.20 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 1.829/2.689 | - | 10.667/19.999 | 10.074/14.732 | n/a | n/a | 90.97 ms | 2 | measured |
| flutter-impeller | stress | scroll | ui-frame | 2.342/3.786 | - | 10.028/10.001 | - | n/a | n/a | 91.60 ms | 1 | measured |
| electron | small | open | ui-frame | 87.633/92.400 | - | - | - | n/a | n/a | 87.63 ms | 0 | measured |
| electron | small | input | ui-frame | 1.597/2.000 | - | 10.063/12.000 | 9.633/11.900 | n/a | n/a | 84.17 ms | 0 | measured |
| electron | small | scroll | ui-frame | 1.764/2.400 | - | 10.002/11.900 | - | n/a | n/a | 85.33 ms | 0 | measured |
| electron | medium | open | ui-frame | 86.333/89.900 | - | - | - | n/a | n/a | 86.33 ms | 0 | measured |
| electron | medium | input | ui-frame | 1.593/1.900 | - | 9.917/12.000 | 9.653/12.100 | n/a | n/a | 91.20 ms | 0 | measured |
| electron | medium | scroll | ui-frame | 1.907/2.400 | - | 9.994/12.000 | - | n/a | n/a | 84.47 ms | 0 | measured |
| electron | large | open | ui-frame | 86.733/89.700 | - | - | - | n/a | n/a | 86.73 ms | 0 | measured |
| electron | large | input | ui-frame | 1.563/1.900 | - | 9.920/11.900 | 9.510/12.000 | n/a | n/a | 86.27 ms | 0 | measured |
| electron | large | scroll | ui-frame | 1.910/2.400 | - | 9.997/11.900 | - | n/a | n/a | 87.47 ms | 0 | measured |
| electron | stress | open | ui-frame | 97.333/97.900 | - | - | - | n/a | n/a | 97.33 ms | 0 | measured |
| electron | stress | input | ui-frame | 1.617/2.000 | - | 10.337/12.000 | 9.890/12.000 | n/a | n/a | 98.03 ms | 1 | measured |
| electron | stress | scroll | ui-frame | 1.912/2.400 | - | 10.000/12.000 | - | n/a | n/a | 97.33 ms | 0 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.11/2.16/2.14 | 4.66/4.90/4.94 | 6.83/6.84/6.81 | 10.13/10.52/10.48 | 0/0/0 |
| MoUI Skia GPU | 7.96/7.99/7.98 | 8.97/9.00/9.04 | 8.58/8.61/8.61 | 9.71/9.96/9.86 | 0/0/0 |
| MoUI WGPU | 7.69/7.68/7.67 | 9.01/8.97/8.98 | 8.33/8.33/8.33 | 9.44/9.44/9.43 | 0/0/0 |
| GPUI | 0.00/0.00/0.00 | 0.00/0.00/0.00 | 10.01/10.04/9.96 | 11.61/11.98/11.82 | 2/3/2 |
| Flutter Skia | 1.90/2.33/2.23 | 2.62/3.72/3.79 | 10.11/10.06/10.06 | 10.00/10.00/10.00 | 3/2/2 |
| Flutter Impeller | 2.01/2.31/2.33 | 2.76/3.74/3.81 | 10.11/10.06/10.06 | 10.00/10.00/10.00 | 3/2/2 |
| Electron | 1.76/1.91/1.91 | 2.40/2.40/2.40 | 10.00/9.99/10.00 | 11.90/12.00/11.90 | 0/0/0 |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.23 | 4.95 | 7.05 | 10.40 | 4 |
| MoUI Skia GPU | 8.00 | 8.98 | 8.62 | 9.88 | 0 |
| MoUI WGPU | 7.67 | 8.89 | 8.33 | 9.36 | 0 |
| GPUI | 0.00 | 0.00 | 9.96 | 12.00 | 2 |
| Flutter Skia | 2.32 | 3.67 | 10.00 | 10.00 | 0 |
| Flutter Impeller | 2.34 | 3.79 | 10.03 | 10.00 | 1 |
| Electron | 1.91 | 2.40 | 10.00 | 12.00 | 0 |

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） |
| --- | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 5.02/4.85/4.99 | 5.76/5.23/5.33 | 0.51/0.51/0.50 | 0.62/0.61/0.53 |
| MoUI Skia GPU | 8.56/8.75/8.78 | 9.59/10.71/10.71 | 8.21/8.38/8.22 | 9.27/10.35/10.14 |
| MoUI WGPU | 8.17/8.14/8.17 | 9.52/9.53/9.63 | 7.79/7.77/7.61 | 9.14/9.16/9.06 |
| GPUI | 10.37/10.58/10.28 | 17.22/17.45/18.01 | 0.14/0.14/0.15 | 0.17/0.19/0.21 |
| Flutter Skia | 10.03/9.95/9.98 | 14.76/10.37/12.95 | 1.75/1.77/1.85 | 2.73/2.77/3.45 |
| Flutter Impeller | 10.04/9.90/9.82 | 13.24/13.73/13.55 | 1.69/1.75/1.78 | 2.42/2.49/2.84 |
| Electron | 9.63/9.65/9.51 | 11.90/12.10/12.00 | 1.60/1.59/1.56 | 2.00/1.90/1.90 |

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） |
| --- | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 7.31 | 8.44 | 0.56 | 0.63 |
| MoUI Skia GPU | 9.38 | 10.36 | 6.72 | 8.11 |
| MoUI WGPU | 8.33 | 9.23 | 5.48 | 6.69 |
| GPUI | 10.18 | 16.35 | 0.14 | 0.16 |
| Flutter Skia | 10.57 | 15.06 | 1.79 | 2.94 |
| Flutter Impeller | 10.07 | 14.73 | 1.83 | 2.69 |
| Electron | 9.89 | 12.00 | 1.62 | 2.00 |

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 54.51/54.62/57.36 | 55.00/55.74/57.86 | 46.78/46.46/47.13 | 47.42/47.44/47.73 | 0.07/0.30/1.83 | 0.08/0.33/2.55 |
| MoUI Skia GPU | 61.01/59.60/64.11 | 64.12/63.78/66.19 | 59.36/57.72/59.98 | 62.51/61.92/62.14 | 0.06/0.31/2.53 | 0.07/0.32/2.61 |
| MoUI WGPU | 57.62/57.27/59.41 | 59.10/58.62/59.75 | 55.99/55.39/55.16 | 57.45/56.75/55.53 | 0.07/0.29/2.46 | 0.08/0.31/2.51 |
| GPUI | 170.91/149.14/135.13 | 208.36/183.06/139.86 | 0.00/0.00/0.00 | 0.00/0.00/0.00 | 0.00/0.00/4.33 | 0.00/0.00/6.00 |
| Flutter Skia | 65.23/60.74/62.72 | 67.41/62.94/65.72 | 65.23/60.74/62.72 | 67.41/62.94/65.72 | 0.09/0.12/0.49 | 0.12/0.12/0.72 |
| Flutter Impeller | 66.99/64.97/64.07 | 68.69/65.36/65.52 | 66.99/45.63/64.07 | 68.69/64.83/65.52 | 0.10/0.18/0.40 | 0.14/0.22/0.42 |
| Electron | 87.63/86.33/86.73 | 92.40/89.90/89.70 | 87.63/86.33/86.73 | 92.40/89.90/89.70 | 2.83/2.45/2.39 | 2.87/2.93/2.89 |

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 79.33 | 80.33 | 46.81 | 47.46 | 23.33 | 26.27 |
| MoUI Skia GPU | 82.07 | 82.86 | 55.75 | 56.26 | 21.06 | 26.55 |
| MoUI WGPU | 82.14 | 83.39 | 55.11 | 55.26 | 25.58 | 25.93 |
| GPUI | 125.06 | 130.55 | 0.00 | 0.00 | 29.00 | 32.00 |
| Flutter Skia | 92.95 | 95.96 | 92.95 | 95.96 | 3.10 | 3.33 |
| Flutter Impeller | 96.20 | 102.74 | 96.20 | 102.74 | 3.35 | 3.50 |
| Electron | 97.33 | 97.90 | 97.33 | 97.90 | 4.57 | 5.01 |

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 离屏均值（ms） | 离屏 P95（ms） | 回读均值（ms） | 回读 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.11/2.16/2.14 | 4.66/4.90/4.94 | 6.83/6.84/6.81 | 10.13/10.52/10.48 | 0/0/0 | 0.00/0.00/0.00 | 0.00/0.00/0.00 | 4.14/4.08/4.08 | 4.62/4.59/4.60 |
| MoUI Skia GPU | 7.96/7.99/7.98 | 8.97/9.00/9.04 | 8.58/8.61/8.61 | 9.71/9.96/9.86 | 0/0/0 | n/a/n/a/n/a | n/a/n/a/n/a | 0.00/0.00/0.00 | 0.00/0.00/0.00 |
| MoUI WGPU | 7.69/7.68/7.67 | 9.01/8.97/8.98 | 8.33/8.33/8.33 | 9.44/9.44/9.43 | 0/0/0 | n/a/n/a/n/a | n/a/n/a/n/a | 0.00/0.00/0.00 | 0.00/0.00/0.00 |
| GPUI | 0.00/0.00/0.00 | 0.00/0.00/0.00 | 10.01/10.04/9.96 | 11.61/11.98/11.82 | 2/3/2 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 1.90/2.33/2.23 | 2.62/3.72/3.79 | 10.11/10.06/10.06 | 10.00/10.00/10.00 | 3/2/2 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Impeller | 2.01/2.31/2.33 | 2.76/3.74/3.81 | 10.11/10.06/10.06 | 10.00/10.00/10.00 | 3/2/2 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Electron | 1.76/1.91/1.91 | 2.40/2.40/2.40 | 10.00/9.99/10.00 | 11.90/12.00/11.90 | 0/0/0 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 离屏均值（ms） | 离屏 P95（ms） | 回读均值（ms） | 回读 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.23 | 4.95 | 7.05 | 10.40 | 4 | 0.00 | 0.00 | 4.21 | 5.01 |
| MoUI Skia GPU | 8.00 | 8.98 | 8.62 | 9.88 | 0 | n/a | n/a | 0.00 | 0.00 |
| MoUI WGPU | 7.67 | 8.89 | 8.33 | 9.36 | 0 | n/a | n/a | 0.00 | 0.00 |
| GPUI | 0.00 | 0.00 | 9.96 | 12.00 | 2 | n/a | n/a | n/a | n/a |
| Flutter Skia | 2.32 | 3.67 | 10.00 | 10.00 | 0 | n/a | n/a | n/a | n/a |
| Flutter Impeller | 2.34 | 3.79 | 10.03 | 10.00 | 1 | n/a | n/a | n/a | n/a |
| Electron | 1.91 | 2.40 | 10.00 | 12.00 | 0 | n/a | n/a | n/a | n/a |

## 采集口径

- Metric definitions：`frame_work_ms` 是适配器声明的构建/布局/绘制工作范围；严格模式的 `system_present_interval_samples_ms` 是 macOS compositor 相邻显示时间戳间隔，普通模式的 `frame_interval_ms` 仍是适配器帧回调间隔。
- `frame_work_ms` 对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式只有同一系统 trace 同时包含 HID/os_signpost 动作时间和目标 surface 的逐刷新 present 时才填 `system_input_to_present_samples_ms`。当前适配器的 wall-clock 动作标记仅用于裁剪 trace 窗口，因此严格输入延迟为 `n/a`。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧；严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代；打开场景没有前一帧，所以不计算 interval/drop。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。
