# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-04T03:40:35Z`
- 数据状态：`216 measured`，`36 skipped/error`；原始样本保留在 JSON。
- Host：`Windows-11-10.0.26200-SP0` / `AMD64` / `15.89 GiB`；GPU：`OrayIddDriver Device`
- OS：`11`；CPU：`AMD64 Family 25 Model 33 Stepping 2, AuthenticAMD`；toolchains：`python=3.12.10, moon=moon 0.1.20260824 (dae026a 2026-08-24), rustc=rustc 1.92.0 (ded5c06cf 2025-12-08), cargo=cargo 1.92.0 (344c4567c 2025-10-21), node=v22.20.0`
- 统一配置：`1280x800 @ 60 Hz`；font `system-ui 16px`；line-height `1.55`；overscan `3`；fixed row `66px`；GPU backend `Direct3D`
- Fixture：`small=5KB/100 blocks`，`medium=50KB/1,000 blocks`，`large=500KB/10,000 blocks`，`stress=5MB/100,000 blocks`。
- 本次执行集合：`small, medium, large, stress`；未执行集合在矩阵中显示 `n/a`，不参与比较。
- 汇总口径：mean/P95 合并原始样本；每格 repetition `3`、process warm-up `1`；drop 为各 repetition dropped_display_frames 之和。
- 公平性口径：所有 ui-frame 记录使用相同 fixture、viewport、动作数、warm-up 和重复次数；数值来自框架真实渲染/提交回调。MoUI ui-frame 是 headless host-surface；GPUI 的 frame work 覆盖 request_layout→prepaint→paint，action dispatch 另列为诊断字段。不同框架的显示时间戳由各自平台 API 提供，因此报告不做跨时钟的综合排名。`n/a` 表示没有采集，绝不等同于 0。

<details><summary>原始 ui-frame 汇总（可审计）</summary>

| 实现 | 测试集合 | 场景 | 范围 | 工作均值/P95 | 仅分发均值/P95 | 帧间隔均值/P95 | 输入到可见均值/P95 | 离屏均值 | 回读均值 | 首次可交互 | 丢帧数 | 状态 |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| moui-skia-raster | small | open | ui-frame | 31.491/31.775 | - | - | - | 0.00 ms | 7.89 ms | 46.23 ms | n/a | measured |
| moui-skia-raster | small | input | ui-frame | 1.888/3.003 | - | 8.353/10.555 | 8.352/10.554 | 0.00 ms | 4.95 ms | 47.46 ms | n/a | measured |
| moui-skia-raster | small | scroll | ui-frame | 4.547/7.921 | - | 10.757/15.041 | - | 0.00 ms | 5.01 ms | 46.80 ms | n/a | measured |
| moui-skia-raster | medium | open | ui-frame | 33.330/35.277 | - | - | - | 0.00 ms | 8.44 ms | 51.05 ms | n/a | measured |
| moui-skia-raster | medium | input | ui-frame | 1.815/2.103 | - | 8.398/9.400 | 8.397/9.399 | 0.00 ms | 5.02 ms | 49.27 ms | n/a | measured |
| moui-skia-raster | medium | scroll | ui-frame | 4.526/7.827 | - | 10.679/15.149 | - | 0.00 ms | 4.94 ms | 49.54 ms | n/a | measured |
| moui-skia-raster | large | open | ui-frame | 31.750/33.166 | - | - | - | 0.00 ms | 8.94 ms | 77.74 ms | n/a | measured |
| moui-skia-raster | large | input | ui-frame | 2.040/3.095 | - | 9.841/13.126 | 9.839/13.124 | 0.00 ms | 5.23 ms | 84.03 ms | n/a | measured |
| moui-skia-raster | large | scroll | ui-frame | 4.610/7.776 | - | 10.896/15.330 | - | 0.00 ms | 5.07 ms | 79.39 ms | n/a | measured |
| moui-skia-raster | stress | open | ui-frame | 33.234/34.567 | - | - | - | 0.00 ms | 8.03 ms | 367.26 ms | n/a | measured |
| moui-skia-raster | stress | input | ui-frame | 2.071/3.411 | - | 19.463/23.565 | 19.462/23.565 | 0.00 ms | 5.34 ms | 364.62 ms | n/a | measured |
| moui-skia-raster | stress | scroll | ui-frame | 4.538/7.803 | - | 10.764/15.188 | - | 0.00 ms | 5.01 ms | 361.93 ms | n/a | measured |
| moui-skia-gpu | small | open | ui-frame | 30.031/31.163 | - | - | - | 0.00 ms | 63.45 ms | 99.50 ms | n/a | measured |
| moui-skia-gpu | small | input | ui-frame | 1.927/2.422 | - | 16.212/18.491 | 16.210/18.487 | 0.00 ms | 12.63 ms | 100.52 ms | n/a | measured |
| moui-skia-gpu | small | scroll | ui-frame | 4.531/8.019 | - | 10.695/15.456 | - | 0.00 ms | 4.93 ms | 100.81 ms | n/a | measured |
| moui-skia-gpu | medium | open | ui-frame | 29.458/30.766 | - | - | - | 0.00 ms | 61.94 ms | 100.81 ms | n/a | measured |
| moui-skia-gpu | medium | input | ui-frame | 1.962/3.227 | - | 16.001/18.523 | 15.999/18.522 | 0.00 ms | 12.31 ms | 106.12 ms | n/a | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 4.518/7.797 | - | 10.651/15.179 | - | 0.00 ms | 4.92 ms | 100.73 ms | n/a | measured |
| moui-skia-gpu | large | open | ui-frame | 30.682/33.015 | - | - | - | 0.00 ms | 62.63 ms | 131.05 ms | n/a | measured |
| moui-skia-gpu | large | input | ui-frame | 1.852/2.117 | - | 16.980/17.928 | 16.978/17.927 | 0.00 ms | 12.53 ms | 134.74 ms | n/a | measured |
| moui-skia-gpu | large | scroll | ui-frame | 4.577/8.007 | - | 10.765/15.432 | - | 0.00 ms | 4.94 ms | 126.41 ms | n/a | measured |
| moui-skia-gpu | stress | open | ui-frame | 30.085/30.590 | - | - | - | 0.00 ms | 62.43 ms | 420.79 ms | n/a | measured |
| moui-skia-gpu | stress | input | ui-frame | 2.049/3.258 | - | 26.627/29.355 | 26.625/29.355 | 0.00 ms | 12.82 ms | 422.50 ms | n/a | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 4.572/7.825 | - | 10.812/15.013 | - | 0.00 ms | 5.01 ms | 411.79 ms | n/a | measured |
| moui-wgpu | small | open | ui-frame | 189.039/190.963 | - | - | - | n/a | 0.00 ms | 195.55 ms | n/a | measured |
| moui-wgpu | small | input | ui-frame | 12.522/15.389 | - | 14.195/17.265 | 14.194/17.264 | n/a | 0.00 ms | 203.83 ms | n/a | measured |
| moui-wgpu | small | scroll | ui-frame | 10.405/14.412 | - | 11.603/16.120 | - | n/a | 0.00 ms | 208.40 ms | n/a | measured |
| moui-wgpu | medium | open | ui-frame | 194.346/196.213 | - | - | - | n/a | 0.00 ms | 203.42 ms | n/a | measured |
| moui-wgpu | medium | input | ui-frame | 13.327/15.930 | - | 15.013/18.017 | 15.012/18.016 | n/a | 0.00 ms | 207.44 ms | n/a | measured |
| moui-wgpu | medium | scroll | ui-frame | 10.399/13.711 | - | 11.591/15.655 | - | n/a | 0.00 ms | 202.43 ms | n/a | measured |
| moui-wgpu | large | open | ui-frame | 208.469/243.019 | - | - | - | n/a | 0.00 ms | 253.52 ms | n/a | measured |
| moui-wgpu | large | input | ui-frame | 12.098/14.062 | - | 14.416/17.473 | 14.415/17.472 | n/a | 0.00 ms | 239.86 ms | n/a | measured |
| moui-wgpu | large | scroll | ui-frame | 10.424/13.934 | - | 11.642/15.807 | - | n/a | 0.00 ms | 229.82 ms | n/a | measured |
| moui-wgpu | stress | open | ui-frame | 197.613/211.265 | - | - | - | n/a | 0.00 ms | 546.15 ms | n/a | measured |
| moui-wgpu | stress | input | ui-frame | 12.695/15.712 | - | 25.143/30.364 | 25.142/30.362 | n/a | 0.00 ms | 534.47 ms | n/a | measured |
| moui-wgpu | stress | scroll | ui-frame | 10.223/13.938 | - | 11.408/15.932 | - | n/a | 0.00 ms | 520.18 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 42.802/44.957 | - | - | - | n/a | n/a | 28.01 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 1.425/1.563 | - | 6.931/6.945 | 6.916/7.794 | n/a | n/a | 28.46 ms | 0 | measured |
| flutter-skia | small | scroll | ui-frame | 2.953/3.481 | - | 6.967/6.945 | - | n/a | n/a | 29.87 ms | 0 | measured |
| flutter-skia | medium | open | ui-frame | 43.368/44.910 | - | - | - | n/a | n/a | 28.52 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 1.358/1.607 | - | 6.945/6.945 | 6.962/7.666 | n/a | n/a | 28.75 ms | 0 | measured |
| flutter-skia | medium | scroll | ui-frame | 4.445/6.557 | - | 9.896/13.889 | - | n/a | n/a | 28.67 ms | 1 | measured |
| flutter-skia | large | open | ui-frame | 43.204/43.548 | - | - | - | n/a | n/a | 36.85 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 1.369/1.563 | - | 6.945/6.945 | 6.943/7.877 | n/a | n/a | 35.11 ms | 0 | measured |
| flutter-skia | large | scroll | ui-frame | 4.399/6.547 | - | 9.819/13.889 | - | n/a | n/a | 35.06 ms | 0 | measured |
| flutter-skia | stress | open | ui-frame | 44.459/47.064 | - | - | - | n/a | n/a | 90.09 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 1.556/1.843 | - | 6.942/6.945 | 6.861/8.036 | n/a | n/a | 91.07 ms | 0 | measured |
| flutter-skia | stress | scroll | ui-frame | 4.762/7.236 | - | 10.243/13.889 | - | n/a | n/a | 95.14 ms | 1 | measured |
| flutter-impeller | small | open | ui-frame | 22.232/24.562 | - | - | - | n/a | n/a | 30.83 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 2.356/2.743 | - | 6.932/6.945 | 6.983/7.897 | n/a | n/a | 34.16 ms | 0 | measured |
| flutter-impeller | small | scroll | ui-frame | 4.334/6.077 | - | 7.422/13.889 | - | n/a | n/a | 32.93 ms | 0 | measured |
| flutter-impeller | medium | open | ui-frame | 23.263/25.102 | - | - | - | n/a | n/a | 31.52 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 2.431/3.113 | - | 6.920/6.945 | 7.006/8.557 | n/a | n/a | 30.94 ms | 0 | measured |
| flutter-impeller | medium | scroll | ui-frame | 5.441/8.123 | - | 10.359/13.889 | - | n/a | n/a | 32.20 ms | 0 | measured |
| flutter-impeller | large | open | ui-frame | 22.762/23.821 | - | - | - | n/a | n/a | 37.82 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 2.288/2.704 | - | 6.871/6.945 | 7.018/8.999 | n/a | n/a | 35.10 ms | 0 | measured |
| flutter-impeller | large | scroll | ui-frame | 5.238/7.145 | - | 9.719/13.889 | - | n/a | n/a | 35.10 ms | 0 | measured |
| flutter-impeller | stress | open | ui-frame | 20.503/24.642 | - | - | - | n/a | n/a | 86.83 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 2.200/2.725 | - | 6.848/6.945 | 6.918/8.004 | n/a | n/a | 89.29 ms | 0 | measured |
| flutter-impeller | stress | scroll | ui-frame | 5.256/7.226 | - | 9.621/13.889 | - | n/a | n/a | 87.91 ms | 0 | measured |
| electron | small | open | ui-frame | 29.233/51.600 | - | - | - | n/a | n/a | 29.23 ms | 0 | measured |
| electron | small | input | ui-frame | 3.020/5.000 | - | 7.727/13.900 | 6.820/13.200 | n/a | n/a | 41.97 ms | 0 | measured |
| electron | small | scroll | ui-frame | 3.349/4.800 | - | 7.026/7.100 | - | n/a | n/a | 41.57 ms | 0 | measured |
| electron | medium | open | ui-frame | 18.133/19.800 | - | - | - | n/a | n/a | 18.13 ms | 0 | measured |
| electron | medium | input | ui-frame | 3.067/4.500 | - | 8.102/13.800 | 6.997/14.100 | n/a | n/a | 17.83 ms | 0 | measured |
| electron | medium | scroll | ui-frame | 3.462/4.700 | - | 6.991/7.000 | - | n/a | n/a | 18.10 ms | 0 | measured |
| electron | large | open | ui-frame | 20.600/21.800 | - | - | - | n/a | n/a | 20.60 ms | 0 | measured |
| electron | large | input | ui-frame | 3.107/4.400 | - | 8.105/13.900 | 7.010/14.000 | n/a | n/a | 19.73 ms | 1 | measured |
| electron | large | scroll | ui-frame | 3.515/4.600 | - | 7.022/7.000 | - | n/a | n/a | 20.37 ms | 0 | measured |
| electron | stress | open | ui-frame | 35.633/36.500 | - | - | - | n/a | n/a | 35.63 ms | 0 | measured |
| electron | stress | input | ui-frame | 2.953/3.800 | - | 8.427/14.000 | 6.933/16.200 | n/a | n/a | 37.07 ms | 0 | measured |
| electron | stress | scroll | ui-frame | 3.488/4.800 | - | 6.991/7.000 | - | n/a | n/a | 35.90 ms | 1 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 4.55/4.53/4.61 | 7.92/7.83/7.78 | 10.76/10.68/10.90 | 15.04/15.15/15.33 | n/a/n/a/n/a |
| MoUI Skia GPU | 4.53/4.52/4.58 | 8.02/7.80/8.01 | 10.69/10.65/10.76 | 15.46/15.18/15.43 | n/a/n/a/n/a |
| MoUI WGPU | 10.41/10.40/10.42 | 14.41/13.71/13.93 | 11.60/11.59/11.64 | 16.12/15.66/15.81 | n/a/n/a/n/a |
| GPUI (md_mbt) | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 2.95/4.44/4.40 | 3.48/6.56/6.55 | 6.97/9.90/9.82 | 6.95/13.89/13.89 | 0/1/0 |
| Flutter Impeller | 4.33/5.44/5.24 | 6.08/8.12/7.14 | 7.42/10.36/9.72 | 13.89/13.89/13.89 | 0/0/0 |
| Electron | 3.35/3.46/3.52 | 4.80/4.70/4.60 | 7.03/6.99/7.02 | 7.10/7.00/7.00 | 0/0/0 |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 4.54 | 7.80 | 10.76 | 15.19 | n/a |
| MoUI Skia GPU | 4.57 | 7.82 | 10.81 | 15.01 | n/a |
| MoUI WGPU | 10.22 | 13.94 | 11.41 | 15.93 | n/a |
| GPUI (md_mbt) | n/a | n/a | n/a | n/a | n/a |
| Flutter Skia | 4.76 | 7.24 | 10.24 | 13.89 | 1 |
| Flutter Impeller | 5.26 | 7.23 | 9.62 | 13.89 | 0 |
| Electron | 3.49 | 4.80 | 6.99 | 7.00 | 1 |

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） |
| --- | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 8.35/8.40/9.84 | 10.55/9.40/13.12 | 1.89/1.81/2.04 | 3.00/2.10/3.09 |
| MoUI Skia GPU | 16.21/16.00/16.98 | 18.49/18.52/17.93 | 1.93/1.96/1.85 | 2.42/3.23/2.12 |
| MoUI WGPU | 14.19/15.01/14.42 | 17.26/18.02/17.47 | 12.52/13.33/12.10 | 15.39/15.93/14.06 |
| GPUI (md_mbt) | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 6.92/6.96/6.94 | 7.79/7.67/7.88 | 1.43/1.36/1.37 | 1.56/1.61/1.56 |
| Flutter Impeller | 6.98/7.01/7.02 | 7.90/8.56/9.00 | 2.36/2.43/2.29 | 2.74/3.11/2.70 |
| Electron | 6.82/7.00/7.01 | 13.20/14.10/14.00 | 3.02/3.07/3.11 | 5.00/4.50/4.40 |

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） |
| --- | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 19.46 | 23.56 | 2.07 | 3.41 |
| MoUI Skia GPU | 26.63 | 29.35 | 2.05 | 3.26 |
| MoUI WGPU | 25.14 | 30.36 | 12.69 | 15.71 |
| GPUI (md_mbt) | n/a | n/a | n/a | n/a |
| Flutter Skia | 6.86 | 8.04 | 1.56 | 1.84 |
| Flutter Impeller | 6.92 | 8.00 | 2.20 | 2.73 |
| Electron | 6.93 | 16.20 | 2.95 | 3.80 |

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 46.23/51.05/77.74 | 46.34/53.71/79.37 | 31.49/33.33/31.75 | 31.77/35.28/33.17 | 0.17/0.68/3.41 | 0.19/0.74/3.48 |
| MoUI Skia GPU | 99.50/100.81/131.05 | 103.39/101.63/135.43 | 30.03/29.46/30.68 | 31.16/30.77/33.02 | 0.18/0.59/3.33 | 0.20/0.63/3.37 |
| MoUI WGPU | 195.55/203.42/253.52 | 197.11/205.63/297.02 | 189.04/194.35/208.47 | 190.96/196.21/243.02 | 0.16/0.76/3.99 | 0.17/1.01/4.14 |
| GPUI (md_mbt) | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 28.01/28.52/36.85 | 28.47/29.72/42.14 | 42.80/43.37/43.20 | 44.96/44.91/43.55 | 0.76/0.86/1.17 | 0.94/0.92/1.39 |
| Flutter Impeller | 30.83/31.52/37.82 | 31.61/33.36/41.22 | 22.23/23.26/22.76 | 24.56/25.10/23.82 | 0.80/0.87/1.07 | 0.81/0.95/1.19 |
| Electron | 29.23/18.13/20.60 | 51.60/19.80/21.80 | 29.23/18.13/20.60 | 51.60/19.80/21.80 | 3.57/3.20/4.20 | 3.79/3.57/4.61 |

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 367.26 | 369.47 | 33.23 | 34.57 | 37.26 | 37.57 |
| MoUI Skia GPU | 420.79 | 434.31 | 30.09 | 30.59 | 38.88 | 40.33 |
| MoUI WGPU | 546.15 | 581.22 | 197.61 | 211.26 | 42.41 | 49.55 |
| GPUI (md_mbt) | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Skia | 90.09 | 92.96 | 44.46 | 47.06 | 3.49 | 3.56 |
| Flutter Impeller | 86.83 | 90.64 | 20.50 | 24.64 | 3.37 | 3.57 |
| Electron | 35.63 | 36.50 | 35.63 | 36.50 | 10.04 | 10.42 |

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 离屏均值（ms） | 离屏 P95（ms） | 回读均值（ms） | 回读 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 4.55/4.53/4.61 | 7.92/7.83/7.78 | 10.76/10.68/10.90 | 15.04/15.15/15.33 | n/a/n/a/n/a | 0.00/0.00/0.00 | 0.00/0.00/0.00 | 5.01/4.94/5.07 | 6.10/5.96/6.34 |
| MoUI Skia GPU | 4.53/4.52/4.58 | 8.02/7.80/8.01 | 10.69/10.65/10.76 | 15.46/15.18/15.43 | n/a/n/a/n/a | 0.00/0.00/0.00 | 0.00/0.00/0.00 | 4.93/4.92/4.94 | 6.19/6.26/6.21 |
| MoUI WGPU | 10.41/10.40/10.42 | 14.41/13.71/13.93 | 11.60/11.59/11.64 | 16.12/15.66/15.81 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | 0.00/0.00/0.00 | 0.00/0.00/0.00 |
| GPUI (md_mbt) | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 2.95/4.44/4.40 | 3.48/6.56/6.55 | 6.97/9.90/9.82 | 6.95/13.89/13.89 | 0/1/0 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Impeller | 4.33/5.44/5.24 | 6.08/8.12/7.14 | 7.42/10.36/9.72 | 13.89/13.89/13.89 | 0/0/0 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Electron | 3.35/3.46/3.52 | 4.80/4.70/4.60 | 7.03/6.99/7.02 | 7.10/7.00/7.00 | 0/0/0 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 离屏均值（ms） | 离屏 P95（ms） | 回读均值（ms） | 回读 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 4.54 | 7.80 | 10.76 | 15.19 | n/a | 0.00 | 0.00 | 5.01 | 6.06 |
| MoUI Skia GPU | 4.57 | 7.82 | 10.81 | 15.01 | n/a | 0.00 | 0.00 | 5.01 | 6.44 |
| MoUI WGPU | 10.22 | 13.94 | 11.41 | 15.93 | n/a | n/a | n/a | 0.00 | 0.00 |
| GPUI (md_mbt) | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Skia | 4.76 | 7.24 | 10.24 | 13.89 | 1 | n/a | n/a | n/a | n/a |
| Flutter Impeller | 5.26 | 7.23 | 9.62 | 13.89 | 0 | n/a | n/a | n/a | n/a |
| Electron | 3.49 | 4.80 | 6.99 | 7.00 | 1 | n/a | n/a | n/a | n/a |

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoUI Skia Raster CPU stress 367.3 ms（max 369.5 ms）；MoUI Skia GPU small 99.5 ms（max 103.4 ms）；MoUI Skia GPU medium 100.8 ms（max 101.6 ms）；MoUI Skia GPU large 131.0 ms（max 135.4 ms）；MoUI Skia GPU stress 420.8 ms（max 434.3 ms）；MoUI WGPU small 195.5 ms（max 197.1 ms）；MoUI WGPU medium 203.4 ms（max 205.6 ms）；MoUI WGPU large 253.5 ms（max 297.0 ms）；MoUI WGPU stress 546.1 ms（max 581.2 ms）。
- P1 输入尾延迟：MoUI Skia Raster CPU stress P95 23.56 ms；MoUI Skia GPU small P95 18.49 ms；MoUI Skia GPU medium P95 18.52 ms；MoUI Skia GPU large P95 17.93 ms；MoUI Skia GPU stress P95 29.35 ms；MoUI WGPU small P95 17.26 ms；MoUI WGPU medium P95 18.02 ms；MoUI WGPU large P95 17.47 ms；MoUI WGPU stress P95 30.36 ms。
- 长帧（超预算）：MoUI Skia Raster CPU: small/scroll 5 次，max 18.82 ms, medium/scroll 6 次，max 21.54 ms, large/scroll 2 次，max 17.57 ms, stress/input 30 次，max 24.08 ms, stress/scroll 4 次，max 19.31 ms；MoUI Skia GPU: small/input 7 次，max 19.39 ms, small/scroll 3 次，max 19.86 ms, medium/input 4 次，max 19.85 ms, medium/scroll 4 次，max 19.93 ms, large/input 17 次，max 18.09 ms, large/scroll 9 次，max 20.27 ms, stress/input 30 次，max 30.22 ms, stress/scroll 4 次，max 24.22 ms；MoUI WGPU: small/input 2 次，max 18.37 ms, small/scroll 13 次，max 21.88 ms, medium/input 4 次，max 18.11 ms, medium/scroll 10 次，max 22.39 ms, large/input 2 次，max 20.76 ms, large/scroll 5 次，max 18.67 ms, stress/input 30 次，max 32.17 ms, stress/scroll 12 次，max 19.92 ms；Flutter Skia: medium/scroll 1 次，max 27.78 ms, stress/scroll 1 次，max 27.78 ms；Electron: large/input 1 次，max 19.47 ms, stress/scroll 1 次，max 20.80 ms。
- 丢帧（优先处理）：Flutter Skia: medium/scroll 1 帧, stress/scroll 1 帧；Electron: large/input 1 帧, stress/scroll 1 帧。
- 解释：首帧异常优先检查窗口/渲染器初始化；输入尾延迟检查 action 到下一可见帧的调度与同步重建；长帧检查解析、布局、文本 shaping 和 GPU 提交；`n/a` 表示未埋点，不等于 0。
- 普通模式的长帧、帧间隔和输入延迟是各框架回调诊断，不能替代跨框架 compositor 排名；需要严格结论时运行 `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`。

## 采集口径

- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。
- `frame_work_ms` 对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧；严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代；打开场景没有前一帧，所以不计算 interval/drop。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。
