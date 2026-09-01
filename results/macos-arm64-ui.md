# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-01T17:33:04Z`
- 数据状态：`288 measured`，`0 skipped/error`；原始样本保留在 JSON。
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
| moui-skia-raster | small | open | ui-frame | 44.690/46.538 | - | - | - | 0.00 ms | 5.50 ms | 51.91 ms | n/a | measured |
| moui-skia-raster | small | input | ui-frame | 0.506/0.721 | - | 4.790/5.308 | 4.790/5.307 | 0.00 ms | 3.96 ms | 55.26 ms | n/a | measured |
| moui-skia-raster | small | scroll | ui-frame | 2.123/4.750 | - | 6.851/10.227 | - | 0.00 ms | 4.12 ms | 54.47 ms | n/a | measured |
| moui-skia-raster | medium | open | ui-frame | 45.461/46.620 | - | - | - | 0.00 ms | 5.87 ms | 53.26 ms | n/a | measured |
| moui-skia-raster | medium | input | ui-frame | 0.473/0.512 | - | 4.688/4.953 | 4.687/4.953 | 0.00 ms | 3.88 ms | 52.73 ms | n/a | measured |
| moui-skia-raster | medium | scroll | ui-frame | 2.141/4.849 | - | 6.825/10.224 | - | 0.00 ms | 4.08 ms | 53.05 ms | n/a | measured |
| moui-skia-raster | large | open | ui-frame | 45.754/46.336 | - | - | - | 0.00 ms | 5.90 ms | 55.30 ms | n/a | measured |
| moui-skia-raster | large | input | ui-frame | 0.498/0.572 | - | 5.014/5.376 | 5.014/5.375 | 0.00 ms | 4.00 ms | 57.39 ms | n/a | measured |
| moui-skia-raster | large | scroll | ui-frame | 2.209/4.959 | - | 7.005/10.694 | - | 0.00 ms | 4.17 ms | 54.60 ms | n/a | measured |
| moui-skia-raster | stress | open | ui-frame | 64.316/101.278 | - | - | - | 0.00 ms | 6.54 ms | 100.80 ms | n/a | measured |
| moui-skia-raster | stress | input | ui-frame | 0.594/0.856 | - | 7.537/8.504 | 7.537/8.504 | 0.00 ms | 4.23 ms | 73.54 ms | n/a | measured |
| moui-skia-raster | stress | scroll | ui-frame | 2.309/5.183 | - | 7.299/11.320 | - | 0.00 ms | 4.33 ms | 76.66 ms | n/a | measured |
| moui-skia-gpu | small | open | ui-frame | 59.008/59.489 | - | - | - | n/a | 0.00 ms | 60.79 ms | n/a | measured |
| moui-skia-gpu | small | input | ui-frame | 8.161/9.134 | - | 8.548/9.492 | 8.547/9.491 | n/a | 0.00 ms | 65.49 ms | n/a | measured |
| moui-skia-gpu | small | scroll | ui-frame | 8.150/9.427 | - | 8.853/10.837 | - | n/a | 0.00 ms | 62.45 ms | n/a | measured |
| moui-skia-gpu | medium | open | ui-frame | 62.359/66.167 | - | - | - | n/a | 0.00 ms | 64.35 ms | n/a | measured |
| moui-skia-gpu | medium | input | ui-frame | 8.300/9.610 | - | 8.705/10.037 | 8.705/10.036 | n/a | 0.00 ms | 67.04 ms | n/a | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 8.025/9.087 | - | 8.695/10.079 | - | n/a | 0.00 ms | 69.57 ms | n/a | measured |
| moui-skia-gpu | large | open | ui-frame | 57.039/58.354 | - | - | - | n/a | 0.00 ms | 60.51 ms | n/a | measured |
| moui-skia-gpu | large | input | ui-frame | 8.133/9.160 | - | 8.639/9.712 | 8.638/9.711 | n/a | 0.00 ms | 59.16 ms | n/a | measured |
| moui-skia-gpu | large | scroll | ui-frame | 8.033/9.131 | - | 8.662/9.925 | - | n/a | 0.00 ms | 60.12 ms | n/a | measured |
| moui-skia-gpu | stress | open | ui-frame | 56.472/56.691 | - | - | - | n/a | 0.00 ms | 76.01 ms | n/a | measured |
| moui-skia-gpu | stress | input | ui-frame | 7.021/8.355 | - | 9.483/10.618 | 9.483/10.618 | n/a | 0.00 ms | 78.85 ms | n/a | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 8.013/9.060 | - | 8.634/10.020 | - | n/a | 0.00 ms | 76.46 ms | n/a | measured |
| moui-wgpu | small | open | ui-frame | 46.637/47.209 | - | - | - | n/a | 0.00 ms | 48.41 ms | n/a | measured |
| moui-wgpu | small | input | ui-frame | 7.862/9.880 | - | 8.210/10.196 | 8.209/10.196 | n/a | 0.00 ms | 48.72 ms | n/a | measured |
| moui-wgpu | small | scroll | ui-frame | 7.721/9.032 | - | 8.331/9.421 | - | n/a | 0.00 ms | 48.64 ms | n/a | measured |
| moui-wgpu | medium | open | ui-frame | 52.668/62.053 | - | - | - | n/a | 0.00 ms | 54.59 ms | n/a | measured |
| moui-wgpu | medium | input | ui-frame | 7.870/9.393 | - | 8.247/9.714 | 8.247/9.714 | n/a | 0.00 ms | 49.71 ms | n/a | measured |
| moui-wgpu | medium | scroll | ui-frame | 7.731/8.936 | - | 8.335/9.361 | - | n/a | 0.00 ms | 48.94 ms | n/a | measured |
| moui-wgpu | large | open | ui-frame | 46.910/47.234 | - | - | - | n/a | 0.00 ms | 50.49 ms | n/a | measured |
| moui-wgpu | large | input | ui-frame | 7.672/9.105 | - | 8.197/9.583 | 8.197/9.582 | n/a | 0.00 ms | 50.69 ms | n/a | measured |
| moui-wgpu | large | scroll | ui-frame | 7.711/9.049 | - | 8.325/9.479 | - | n/a | 0.00 ms | 50.98 ms | n/a | measured |
| moui-wgpu | stress | open | ui-frame | 47.964/48.133 | - | - | - | n/a | 0.00 ms | 67.56 ms | n/a | measured |
| moui-wgpu | stress | input | ui-frame | 5.594/6.941 | - | 8.267/9.263 | 8.266/9.263 | n/a | 0.00 ms | 69.24 ms | n/a | measured |
| moui-wgpu | stress | scroll | ui-frame | 7.733/8.963 | - | 8.347/9.443 | - | n/a | 0.00 ms | 67.98 ms | n/a | measured |
| gpui | small | open | ui-frame | 2.014/2.176 | - | - | - | n/a | n/a | 113.40 ms | n/a | measured |
| gpui | small | input | ui-frame | 1.962/2.121 | 0.060/0.158 | 9.567/11.997 | 9.565/11.995 | n/a | n/a | 111.63 ms | n/a | measured |
| gpui | small | scroll | ui-frame | 2.232/2.932 | 0.003/0.005 | 9.952/11.933 | - | n/a | n/a | 114.65 ms | n/a | measured |
| gpui | medium | open | ui-frame | 2.018/2.058 | - | - | - | n/a | n/a | 114.75 ms | n/a | measured |
| gpui | medium | input | ui-frame | 1.874/2.026 | 0.056/0.160 | 9.660/12.010 | 9.657/12.007 | n/a | n/a | 111.19 ms | n/a | measured |
| gpui | medium | scroll | ui-frame | 2.335/3.005 | 0.003/0.004 | 10.014/11.869 | - | n/a | n/a | 108.60 ms | n/a | measured |
| gpui | large | open | ui-frame | 2.065/2.089 | - | - | - | n/a | n/a | 106.80 ms | n/a | measured |
| gpui | large | input | ui-frame | 1.916/2.057 | 0.058/0.165 | 9.306/12.075 | 9.303/12.073 | n/a | n/a | 105.89 ms | n/a | measured |
| gpui | large | scroll | ui-frame | 2.338/3.139 | 0.003/0.005 | 9.966/10.707 | - | n/a | n/a | 105.88 ms | n/a | measured |
| gpui | stress | open | ui-frame | 2.055/2.115 | - | - | - | n/a | n/a | 109.53 ms | n/a | measured |
| gpui | stress | input | ui-frame | 1.920/2.057 | 0.063/0.188 | 9.512/10.756 | 9.509/10.754 | n/a | n/a | 119.40 ms | n/a | measured |
| gpui | stress | scroll | ui-frame | 1.986/2.963 | 0.003/0.004 | 9.988/11.214 | - | n/a | n/a | 108.51 ms | n/a | measured |
| gpui2 | small | open | ui-frame | 17.970/18.455 | - | - | - | n/a | n/a | 143.84 ms | n/a | measured |
| gpui2 | small | input | ui-frame | 16.307/17.191 | 0.648/0.857 | 20.297/25.171 | 20.295/25.169 | n/a | n/a | 139.40 ms | n/a | measured |
| gpui2 | small | scroll | ui-frame | 17.771/20.746 | 0.002/0.003 | 20.830/24.241 | - | n/a | n/a | 136.09 ms | n/a | measured |
| gpui2 | medium | open | ui-frame | 17.355/17.371 | - | - | - | n/a | n/a | 134.77 ms | n/a | measured |
| gpui2 | medium | input | ui-frame | 16.315/16.683 | 1.549/1.642 | 21.323/28.164 | 21.320/28.163 | n/a | n/a | 140.05 ms | n/a | measured |
| gpui2 | medium | scroll | ui-frame | 17.733/20.631 | 0.002/0.003 | 21.190/24.623 | - | n/a | n/a | 138.72 ms | n/a | measured |
| gpui2 | large | open | ui-frame | 17.694/17.763 | - | - | - | n/a | n/a | 137.34 ms | n/a | measured |
| gpui2 | large | input | ui-frame | 16.354/16.820 | 10.971/11.479 | 29.762/37.278 | 29.759/37.276 | n/a | n/a | 135.70 ms | n/a | measured |
| gpui2 | large | scroll | ui-frame | 17.683/20.503 | 0.002/0.003 | 25.052/28.430 | - | n/a | n/a | 145.34 ms | n/a | measured |
| gpui2 | stress | open | ui-frame | 17.668/17.889 | - | - | - | n/a | n/a | 165.22 ms | n/a | measured |
| gpui2 | stress | input | ui-frame | 15.799/16.240 | 110.979/115.856 | 118.387/135.075 | 118.385/135.072 | n/a | n/a | 161.30 ms | n/a | measured |
| gpui2 | stress | scroll | ui-frame | 17.681/20.428 | 0.002/0.003 | 63.267/67.293 | - | n/a | n/a | 155.72 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 8.224/8.779 | - | - | - | n/a | n/a | 54.54 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 1.078/1.482 | - | 10.000/10.003 | 10.285/13.436 | n/a | n/a | 55.73 ms | 0 | measured |
| flutter-skia | small | scroll | ui-frame | 1.586/2.457 | - | 10.000/10.001 | - | n/a | n/a | 54.88 ms | 2 | measured |
| flutter-skia | medium | open | ui-frame | 7.983/8.238 | - | - | - | n/a | n/a | 53.90 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 1.081/1.518 | - | 9.667/10.002 | 10.826/17.028 | n/a | n/a | 56.63 ms | 0 | measured |
| flutter-skia | medium | scroll | ui-frame | 1.915/2.733 | - | 10.000/10.001 | - | n/a | n/a | 53.88 ms | 1 | measured |
| flutter-skia | large | open | ui-frame | 8.222/8.732 | - | - | - | n/a | n/a | 55.40 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 1.048/1.485 | - | 10.000/10.002 | 10.562/15.475 | n/a | n/a | 56.11 ms | 0 | measured |
| flutter-skia | large | scroll | ui-frame | 1.958/2.723 | - | 9.972/10.001 | - | n/a | n/a | 56.03 ms | 1 | measured |
| flutter-skia | stress | open | ui-frame | 7.944/8.200 | - | - | - | n/a | n/a | 85.46 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 1.078/1.403 | - | 10.000/10.002 | 10.037/11.803 | n/a | n/a | 86.54 ms | 0 | measured |
| flutter-skia | stress | scroll | ui-frame | 1.973/2.775 | - | 9.972/10.001 | - | n/a | n/a | 87.54 ms | 0 | measured |
| flutter-impeller | small | open | ui-frame | 6.467/6.562 | - | - | - | n/a | n/a | 56.09 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 1.029/1.516 | - | 9.667/10.002 | 10.884/19.795 | n/a | n/a | 55.34 ms | 0 | measured |
| flutter-impeller | small | scroll | ui-frame | 1.514/1.846 | - | 10.028/10.001 | - | n/a | n/a | 55.48 ms | 1 | measured |
| flutter-impeller | medium | open | ui-frame | 6.637/6.953 | - | - | - | n/a | n/a | 53.81 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 1.147/2.083 | - | 9.000/10.001 | 10.850/15.888 | n/a | n/a | 54.96 ms | 0 | measured |
| flutter-impeller | medium | scroll | ui-frame | 1.966/2.771 | - | 10.028/10.001 | - | n/a | n/a | 54.69 ms | 1 | measured |
| flutter-impeller | large | open | ui-frame | 6.274/6.389 | - | - | - | n/a | n/a | 59.56 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 1.147/2.019 | - | 9.000/10.001 | 10.830/15.185 | n/a | n/a | 58.70 ms | 0 | measured |
| flutter-impeller | large | scroll | ui-frame | 1.945/2.825 | - | 10.028/10.001 | - | n/a | n/a | 57.48 ms | 1 | measured |
| flutter-impeller | stress | open | ui-frame | 6.149/6.253 | - | - | - | n/a | n/a | 85.50 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 1.074/1.377 | - | 10.000/10.001 | 10.138/14.941 | n/a | n/a | 86.26 ms | 0 | measured |
| flutter-impeller | stress | scroll | ui-frame | 2.014/2.798 | - | 10.000/10.001 | - | n/a | n/a | 86.77 ms | 0 | measured |
| electron | small | open | ui-frame | 12.533/14.900 | - | - | - | n/a | n/a | 12.53 ms | 0 | measured |
| electron | small | input | ui-frame | 1.780/3.300 | - | 9.334/11.800 | 8.360/11.800 | n/a | n/a | 12.40 ms | 0 | measured |
| electron | small | scroll | ui-frame | 1.733/2.100 | - | 9.940/11.700 | - | n/a | n/a | 10.73 ms | 0 | measured |
| electron | medium | open | ui-frame | 12.400/14.700 | - | - | - | n/a | n/a | 12.40 ms | 0 | measured |
| electron | medium | input | ui-frame | 1.723/2.300 | - | 10.054/14.436 | 8.660/11.700 | n/a | n/a | 8.67 ms | 0 | measured |
| electron | medium | scroll | ui-frame | 1.835/2.300 | - | 9.943/11.400 | - | n/a | n/a | 8.77 ms | 0 | measured |
| electron | large | open | ui-frame | 11.900/15.800 | - | - | - | n/a | n/a | 11.90 ms | 0 | measured |
| electron | large | input | ui-frame | 1.710/2.600 | - | 9.775/11.900 | 8.573/11.800 | n/a | n/a | 9.73 ms | 0 | measured |
| electron | large | scroll | ui-frame | 1.793/2.200 | - | 9.909/11.600 | - | n/a | n/a | 10.03 ms | 0 | measured |
| electron | stress | open | ui-frame | 18.100/18.300 | - | - | - | n/a | n/a | 18.10 ms | 0 | measured |
| electron | stress | input | ui-frame | 1.653/2.100 | - | 8.997/11.000 | 8.603/11.000 | n/a | n/a | 17.60 ms | 0 | measured |
| electron | stress | scroll | ui-frame | 1.832/2.300 | - | 9.917/11.500 | - | n/a | n/a | 17.87 ms | 0 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.12/2.14/2.21 | 4.75/4.85/4.96 | 6.85/6.82/7.00 | 10.23/10.22/10.69 | n/a/n/a/n/a |
| MoUI Skia GPU | 8.15/8.03/8.03 | 9.43/9.09/9.13 | 8.85/8.69/8.66 | 10.84/10.08/9.93 | n/a/n/a/n/a |
| MoUI WGPU | 7.72/7.73/7.71 | 9.03/8.94/9.05 | 8.33/8.34/8.33 | 9.42/9.36/9.48 | n/a/n/a/n/a |
| GPUI | 2.23/2.34/2.34 | 2.93/3.00/3.14 | 9.95/10.01/9.97 | 11.93/11.87/10.71 | n/a/n/a/n/a |
| GPUI2 (md_mbt) | 17.77/17.73/17.68 | 20.75/20.63/20.50 | 20.83/21.19/25.05 | 24.24/24.62/28.43 | n/a/n/a/n/a |
| Flutter Skia | 1.59/1.92/1.96 | 2.46/2.73/2.72 | 10.00/10.00/9.97 | 10.00/10.00/10.00 | 2/1/1 |
| Flutter Impeller | 1.51/1.97/1.94 | 1.85/2.77/2.83 | 10.03/10.03/10.03 | 10.00/10.00/10.00 | 1/1/1 |
| Electron | 1.73/1.84/1.79 | 2.10/2.30/2.20 | 9.94/9.94/9.91 | 11.70/11.40/11.60 | 0/0/0 |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.31 | 5.18 | 7.30 | 11.32 | n/a |
| MoUI Skia GPU | 8.01 | 9.06 | 8.63 | 10.02 | n/a |
| MoUI WGPU | 7.73 | 8.96 | 8.35 | 9.44 | n/a |
| GPUI | 1.99 | 2.96 | 9.99 | 11.21 | n/a |
| GPUI2 (md_mbt) | 17.68 | 20.43 | 63.27 | 67.29 | n/a |
| Flutter Skia | 1.97 | 2.77 | 9.97 | 10.00 | 0 |
| Flutter Impeller | 2.01 | 2.80 | 10.00 | 10.00 | 0 |
| Electron | 1.83 | 2.30 | 9.92 | 11.50 | 0 |

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） |
| --- | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 4.79/4.69/5.01 | 5.31/4.95/5.38 | 0.51/0.47/0.50 | 0.72/0.51/0.57 |
| MoUI Skia GPU | 8.55/8.70/8.64 | 9.49/10.04/9.71 | 8.16/8.30/8.13 | 9.13/9.61/9.16 |
| MoUI WGPU | 8.21/8.25/8.20 | 10.20/9.71/9.58 | 7.86/7.87/7.67 | 9.88/9.39/9.11 |
| GPUI | 9.56/9.66/9.30 | 11.99/12.01/12.07 | 1.96/1.87/1.92 | 2.12/2.03/2.06 |
| GPUI2 (md_mbt) | 20.29/21.32/29.76 | 25.17/28.16/37.28 | 16.31/16.31/16.35 | 17.19/16.68/16.82 |
| Flutter Skia | 10.28/10.83/10.56 | 13.44/17.03/15.47 | 1.08/1.08/1.05 | 1.48/1.52/1.49 |
| Flutter Impeller | 10.88/10.85/10.83 | 19.80/15.89/15.19 | 1.03/1.15/1.15 | 1.52/2.08/2.02 |
| Electron | 8.36/8.66/8.57 | 11.80/11.70/11.80 | 1.78/1.72/1.71 | 3.30/2.30/2.60 |

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） |
| --- | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 7.54 | 8.50 | 0.59 | 0.86 |
| MoUI Skia GPU | 9.48 | 10.62 | 7.02 | 8.35 |
| MoUI WGPU | 8.27 | 9.26 | 5.59 | 6.94 |
| GPUI | 9.51 | 10.75 | 1.92 | 2.06 |
| GPUI2 (md_mbt) | 118.39 | 135.07 | 15.80 | 16.24 |
| Flutter Skia | 10.04 | 11.80 | 1.08 | 1.40 |
| Flutter Impeller | 10.14 | 14.94 | 1.07 | 1.38 |
| Electron | 8.60 | 11.00 | 1.65 | 2.10 |

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 51.91/53.26/55.30 | 53.63/54.90/55.41 | 44.69/45.46/45.75 | 46.54/46.62/46.34 | 0.05/0.30/2.38 | 0.06/0.32/2.46 |
| MoUI Skia GPU | 60.79/64.35/60.51 | 61.22/68.27/61.85 | 59.01/62.36/57.04 | 59.49/66.17/58.35 | 0.07/0.29/2.36 | 0.07/0.30/2.40 |
| MoUI WGPU | 48.41/54.59/50.49 | 48.90/64.00/50.78 | 46.64/52.67/46.91 | 47.21/62.05/47.23 | 0.06/0.28/2.46 | 0.06/0.30/2.51 |
| GPUI | 113.40/114.75/106.80 | 123.47/124.83/108.61 | 2.01/2.02/2.06 | 2.18/2.06/2.09 | 0.00/0.33/2.67 | 0.00/1.00/3.00 |
| GPUI2 (md_mbt) | 143.84/134.77/137.34 | 147.66/135.60/140.51 | 17.97/17.36/17.69 | 18.46/17.37/17.76 | 0.00/1.00/2.67 | 0.00/1.00/3.00 |
| Flutter Skia | 54.54/53.90/55.40 | 55.04/55.01/57.57 | 8.22/7.98/8.22 | 8.78/8.24/8.73 | 0.11/0.10/0.38 | 0.17/0.11/0.46 |
| Flutter Impeller | 56.09/53.81/59.56 | 56.96/57.26/60.20 | 6.47/6.64/6.27 | 6.56/6.95/6.39 | 0.11/0.14/0.43 | 0.16/0.16/0.47 |
| Electron | 12.53/12.40/11.90 | 14.90/14.70/15.80 | 12.53/12.40/11.90 | 14.90/14.70/15.80 | 2.57/2.75/2.56 | 2.70/2.99/2.64 |

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 100.80 | 157.89 | 64.32 | 101.28 | 26.37 | 30.29 |
| MoUI Skia GPU | 76.01 | 76.14 | 56.47 | 56.69 | 24.25 | 24.91 |
| MoUI WGPU | 67.56 | 67.87 | 47.96 | 48.13 | 24.09 | 24.81 |
| GPUI | 109.53 | 113.36 | 2.06 | 2.11 | 25.00 | 27.00 |
| GPUI2 (md_mbt) | 165.22 | 174.47 | 17.67 | 17.89 | 25.67 | 27.00 |
| Flutter Skia | 85.46 | 87.20 | 7.94 | 8.20 | 2.65 | 2.68 |
| Flutter Impeller | 85.50 | 88.56 | 6.15 | 6.25 | 2.70 | 2.72 |
| Electron | 18.10 | 18.30 | 18.10 | 18.30 | 4.93 | 5.07 |

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 离屏均值（ms） | 离屏 P95（ms） | 回读均值（ms） | 回读 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.12/2.14/2.21 | 4.75/4.85/4.96 | 6.85/6.82/7.00 | 10.23/10.22/10.69 | n/a/n/a/n/a | 0.00/0.00/0.00 | 0.00/0.00/0.00 | 4.12/4.08/4.17 | 4.76/4.73/4.99 |
| MoUI Skia GPU | 8.15/8.03/8.03 | 9.43/9.09/9.13 | 8.85/8.69/8.66 | 10.84/10.08/9.93 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | 0.00/0.00/0.00 | 0.00/0.00/0.00 |
| MoUI WGPU | 7.72/7.73/7.71 | 9.03/8.94/9.05 | 8.33/8.34/8.33 | 9.42/9.36/9.48 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | 0.00/0.00/0.00 | 0.00/0.00/0.00 |
| GPUI | 2.23/2.34/2.34 | 2.93/3.00/3.14 | 9.95/10.01/9.97 | 11.93/11.87/10.71 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| GPUI2 (md_mbt) | 17.77/17.73/17.68 | 20.75/20.63/20.50 | 20.83/21.19/25.05 | 24.24/24.62/28.43 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 1.59/1.92/1.96 | 2.46/2.73/2.72 | 10.00/10.00/9.97 | 10.00/10.00/10.00 | 2/1/1 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Impeller | 1.51/1.97/1.94 | 1.85/2.77/2.83 | 10.03/10.03/10.03 | 10.00/10.00/10.00 | 1/1/1 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Electron | 1.73/1.84/1.79 | 2.10/2.30/2.20 | 9.94/9.94/9.91 | 11.70/11.40/11.60 | 0/0/0 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 离屏均值（ms） | 离屏 P95（ms） | 回读均值（ms） | 回读 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.31 | 5.18 | 7.30 | 11.32 | n/a | 0.00 | 0.00 | 4.33 | 5.11 |
| MoUI Skia GPU | 8.01 | 9.06 | 8.63 | 10.02 | n/a | n/a | n/a | 0.00 | 0.00 |
| MoUI WGPU | 7.73 | 8.96 | 8.35 | 9.44 | n/a | n/a | n/a | 0.00 | 0.00 |
| GPUI | 1.99 | 2.96 | 9.99 | 11.21 | n/a | n/a | n/a | n/a | n/a |
| GPUI2 (md_mbt) | 17.68 | 20.43 | 63.27 | 67.29 | n/a | n/a | n/a | n/a | n/a |
| Flutter Skia | 1.97 | 2.77 | 9.97 | 10.00 | 0 | n/a | n/a | n/a | n/a |
| Flutter Impeller | 2.01 | 2.80 | 10.00 | 10.00 | 0 | n/a | n/a | n/a | n/a |
| Electron | 1.83 | 2.30 | 9.92 | 11.50 | 0 | n/a | n/a | n/a | n/a |

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoUI Skia Raster CPU stress 100.8 ms（max 157.9 ms）；GPUI small 113.4 ms（max 123.5 ms）；GPUI medium 114.7 ms（max 124.8 ms）；GPUI large 106.8 ms（max 108.6 ms）；GPUI stress 109.5 ms（max 113.4 ms）；GPUI2 (md_mbt) small 143.8 ms（max 147.7 ms）；GPUI2 (md_mbt) medium 134.8 ms（max 135.6 ms）；GPUI2 (md_mbt) large 137.3 ms（max 140.5 ms）；GPUI2 (md_mbt) stress 165.2 ms（max 174.5 ms）。
- P1 输入尾延迟：GPUI2 (md_mbt) small P95 25.17 ms；GPUI2 (md_mbt) medium P95 28.16 ms；GPUI2 (md_mbt) large P95 37.28 ms；GPUI2 (md_mbt) stress P95 135.07 ms；Flutter Skia medium P95 17.03 ms；Flutter Impeller small P95 19.80 ms。
- 长帧（超预算）：MoUI Skia Raster CPU: stress/scroll 2 次，max 18.12 ms；MoUI Skia GPU: small/scroll 1 次，max 24.74 ms, large/scroll 1 次，max 19.12 ms；GPUI: medium/scroll 1 次，max 18.06 ms, large/input 1 次，max 17.99 ms；GPUI2 (md_mbt): small/input 30 次，max 28.21 ms, small/scroll 360 次，max 30.93 ms, medium/input 30 次，max 28.30 ms, medium/scroll 360 次，max 30.65 ms, large/input 30 次，max 37.96 ms, large/scroll 360 次，max 35.53 ms, stress/input 30 次，max 138.91 ms, stress/scroll 360 次，max 70.57 ms；Flutter Skia: small/scroll 2 次，max 20.00 ms, medium/scroll 1 次，max 20.00 ms, large/scroll 1 次，max 20.00 ms；Flutter Impeller: small/scroll 1 次，max 20.00 ms, medium/scroll 1 次，max 20.00 ms, large/scroll 1 次，max 20.00 ms。
- 丢帧（优先处理）：Flutter Skia: small/scroll 2 帧, medium/scroll 1 帧, large/scroll 1 帧；Flutter Impeller: small/scroll 1 帧, medium/scroll 1 帧, large/scroll 1 帧。
- 解释：首帧异常优先检查窗口/渲染器初始化；输入尾延迟检查 action 到下一可见帧的调度与同步重建；长帧检查解析、布局、文本 shaping 和 GPU 提交；`n/a` 表示未埋点，不等于 0。
- 普通模式的长帧、帧间隔和输入延迟是各框架回调诊断，不能替代跨框架 compositor 排名；需要严格结论时运行 `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`。

## 采集口径

- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。
- `frame_work_ms` 对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧；严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代；打开场景没有前一帧，所以不计算 interval/drop。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。
