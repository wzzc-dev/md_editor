# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-01T12:32:53Z`
- 数据状态：`252 measured`，`0 skipped/error`；原始样本保留在 JSON。
- Host：`Windows-11-10.0.26200-SP0` / `AMD64` / `15.89 GiB`；GPU：`AMD Radeon RX 7800 XT`
- OS：`11`；CPU：`AMD64 Family 25 Model 33 Stepping 2, AuthenticAMD`；toolchains：`python=3.12.10, moon=moon 0.1.20260824 (dae026a 2026-08-24), rustc=rustc 1.92.0 (ded5c06cf 2025-12-08), cargo=cargo 1.92.0 (344c4567c 2025-10-21), node=v22.20.0`
- 统一配置：`1280x800 @ 60 Hz`；font `system-ui 16px`；line-height `1.55`；overscan `3`；fixed row `66px`；GPU backend `Direct3D`
- Fixture：`small=5KB/100 blocks`，`medium=50KB/1,000 blocks`，`large=500KB/10,000 blocks`，`stress=5MB/100,000 blocks`。
- 本次执行集合：`small, medium, large, stress`；未执行集合在矩阵中显示 `n/a`，不参与比较。
- 汇总口径：mean/P95 合并原始样本；每格 repetition `3`、process warm-up `1`；drop 为各 repetition dropped_display_frames 之和。
- 公平性口径：所有 ui-frame 记录使用相同 fixture、viewport、动作数、warm-up 和重复次数；数值来自框架真实渲染/提交回调。MoUI ui-frame 是 headless host-surface；GPUI 的 frame work 覆盖 request_layout→prepaint→paint，action dispatch 另列为诊断字段。不同框架的显示时间戳由各自平台 API 提供，因此报告不做跨时钟的综合排名。`n/a` 表示没有采集，绝不等同于 0。

<details><summary>原始 ui-frame 汇总（可审计）</summary>

| 实现 | 测试集合 | 场景 | 范围 | 工作均值/P95 | 仅分发均值/P95 | 帧间隔均值/P95 | 输入到可见均值/P95 | 离屏均值 | 回读均值 | 首次可交互 | 丢帧数 | 状态 |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| moui-skia-raster | small | open | ui-frame | 33.456/34.420 | - | - | - | 0.00 ms | 10.10 ms | 52.15 ms | n/a | measured |
| moui-skia-raster | small | input | ui-frame | 2.096/2.648 | - | 10.069/11.212 | 10.068/11.211 | 0.00 ms | 6.37 ms | 54.84 ms | n/a | measured |
| moui-skia-raster | small | scroll | ui-frame | 4.943/8.555 | - | 12.280/16.955 | - | 0.00 ms | 6.06 ms | 53.17 ms | n/a | measured |
| moui-skia-raster | medium | open | ui-frame | 33.902/34.364 | - | - | - | 0.00 ms | 9.91 ms | 54.52 ms | n/a | measured |
| moui-skia-raster | medium | input | ui-frame | 2.126/3.234 | - | 9.843/10.843 | 9.842/10.842 | 0.00 ms | 5.93 ms | 57.20 ms | n/a | measured |
| moui-skia-raster | medium | scroll | ui-frame | 4.929/8.357 | - | 12.134/16.471 | - | 0.00 ms | 5.84 ms | 56.89 ms | n/a | measured |
| moui-skia-raster | large | open | ui-frame | 35.633/40.325 | - | - | - | 0.00 ms | 10.09 ms | 85.23 ms | n/a | measured |
| moui-skia-raster | large | input | ui-frame | 2.049/2.470 | - | 10.535/11.619 | 10.534/11.619 | 0.00 ms | 5.69 ms | 86.62 ms | n/a | measured |
| moui-skia-raster | large | scroll | ui-frame | 4.946/8.674 | - | 11.861/16.948 | - | 0.00 ms | 5.59 ms | 86.13 ms | n/a | measured |
| moui-skia-raster | stress | open | ui-frame | 34.183/34.667 | - | - | - | 0.00 ms | 9.88 ms | 398.56 ms | n/a | measured |
| moui-skia-raster | stress | input | ui-frame | 2.127/2.549 | - | 22.209/24.643 | 22.208/24.641 | 0.00 ms | 5.79 ms | 394.57 ms | n/a | measured |
| moui-skia-raster | stress | scroll | ui-frame | 4.963/8.533 | - | 12.203/17.099 | - | 0.00 ms | 5.93 ms | 398.92 ms | n/a | measured |
| moui-skia-gpu | small | open | ui-frame | 33.302/38.268 | - | - | - | 0.00 ms | 77.91 ms | 118.72 ms | n/a | measured |
| moui-skia-gpu | small | input | ui-frame | 2.055/2.630 | - | 16.963/17.779 | 16.961/17.778 | 0.00 ms | 13.28 ms | 109.55 ms | n/a | measured |
| moui-skia-gpu | small | scroll | ui-frame | 4.942/8.366 | - | 11.824/16.878 | - | 0.00 ms | 5.54 ms | 108.47 ms | n/a | measured |
| moui-skia-gpu | medium | open | ui-frame | 33.072/33.763 | - | - | - | 0.00 ms | 69.95 ms | 114.36 ms | n/a | measured |
| moui-skia-gpu | medium | input | ui-frame | 2.151/3.134 | - | 17.952/20.633 | 17.951/20.631 | 0.00 ms | 14.01 ms | 115.02 ms | n/a | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 4.910/8.423 | - | 12.044/16.715 | - | 0.00 ms | 5.81 ms | 110.52 ms | n/a | measured |
| moui-skia-gpu | large | open | ui-frame | 32.963/34.126 | - | - | - | 0.00 ms | 68.93 ms | 144.13 ms | n/a | measured |
| moui-skia-gpu | large | input | ui-frame | 2.159/3.062 | - | 19.221/20.323 | 19.220/20.322 | 0.00 ms | 14.14 ms | 147.02 ms | n/a | measured |
| moui-skia-gpu | large | scroll | ui-frame | 4.963/8.603 | - | 12.188/16.952 | - | 0.00 ms | 5.89 ms | 146.70 ms | n/a | measured |
| moui-skia-gpu | stress | open | ui-frame | 32.344/33.632 | - | - | - | 0.00 ms | 72.07 ms | 457.37 ms | n/a | measured |
| moui-skia-gpu | stress | input | ui-frame | 2.314/3.143 | - | 32.622/35.866 | 32.620/35.865 | 0.00 ms | 14.67 ms | 456.84 ms | n/a | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 4.977/8.446 | - | 12.471/17.011 | - | 0.00 ms | 6.16 ms | 455.42 ms | n/a | measured |
| moui-wgpu | small | open | ui-frame | 193.187/196.820 | - | - | - | n/a | 0.00 ms | 200.97 ms | n/a | measured |
| moui-wgpu | small | input | ui-frame | 13.399/16.303 | - | 15.052/17.686 | 15.051/17.686 | n/a | 0.00 ms | 207.07 ms | n/a | measured |
| moui-wgpu | small | scroll | ui-frame | 11.110/14.887 | - | 12.372/17.044 | - | n/a | 0.00 ms | 200.86 ms | n/a | measured |
| moui-wgpu | medium | open | ui-frame | 200.860/207.039 | - | - | - | n/a | 0.00 ms | 210.71 ms | n/a | measured |
| moui-wgpu | medium | input | ui-frame | 13.564/15.331 | - | 15.329/17.075 | 15.328/17.074 | n/a | 0.00 ms | 209.87 ms | n/a | measured |
| moui-wgpu | medium | scroll | ui-frame | 10.996/14.714 | - | 12.267/16.936 | - | n/a | 0.00 ms | 208.55 ms | n/a | measured |
| moui-wgpu | large | open | ui-frame | 193.143/194.188 | - | - | - | n/a | 0.00 ms | 234.43 ms | n/a | measured |
| moui-wgpu | large | input | ui-frame | 13.014/14.747 | - | 15.600/17.367 | 15.598/17.366 | n/a | 0.00 ms | 244.66 ms | n/a | measured |
| moui-wgpu | large | scroll | ui-frame | 11.018/14.401 | - | 12.262/16.439 | - | n/a | 0.00 ms | 233.98 ms | n/a | measured |
| moui-wgpu | stress | open | ui-frame | 191.729/194.953 | - | - | - | n/a | 0.00 ms | 532.99 ms | n/a | measured |
| moui-wgpu | stress | input | ui-frame | 13.660/16.694 | - | 27.537/32.427 | 27.536/32.426 | n/a | 0.00 ms | 560.04 ms | n/a | measured |
| moui-wgpu | stress | scroll | ui-frame | 10.874/14.091 | - | 12.121/16.233 | - | n/a | 0.00 ms | 548.00 ms | n/a | measured |
| gpui | small | open | ui-frame | 5.125/5.794 | - | - | - | n/a | n/a | 510.70 ms | n/a | measured |
| gpui | small | input | ui-frame | 3.444/3.910 | 0.073/0.254 | 6.498/7.634 | 6.495/7.633 | n/a | n/a | 506.16 ms | n/a | measured |
| gpui | small | scroll | ui-frame | 3.194/3.661 | 0.002/0.003 | 6.912/7.657 | - | n/a | n/a | 501.68 ms | n/a | measured |
| gpui | medium | open | ui-frame | 4.725/5.346 | - | - | - | n/a | n/a | 503.53 ms | n/a | measured |
| gpui | medium | input | ui-frame | 3.510/4.532 | 0.080/0.271 | 6.645/7.625 | 6.642/7.621 | n/a | n/a | 502.80 ms | n/a | measured |
| gpui | medium | scroll | ui-frame | 3.206/3.696 | 0.002/0.003 | 6.901/7.554 | - | n/a | n/a | 504.54 ms | n/a | measured |
| gpui | large | open | ui-frame | 4.357/4.909 | - | - | - | n/a | n/a | 501.86 ms | n/a | measured |
| gpui | large | input | ui-frame | 3.534/4.362 | 0.080/0.317 | 6.588/7.471 | 6.585/7.470 | n/a | n/a | 503.09 ms | n/a | measured |
| gpui | large | scroll | ui-frame | 3.187/3.641 | 0.002/0.002 | 6.898/7.472 | - | n/a | n/a | 501.68 ms | n/a | measured |
| gpui | stress | open | ui-frame | 4.287/4.408 | - | - | - | n/a | n/a | 493.20 ms | n/a | measured |
| gpui | stress | input | ui-frame | 3.629/4.694 | 0.083/0.297 | 6.720/7.630 | 6.716/7.628 | n/a | n/a | 495.50 ms | n/a | measured |
| gpui | stress | scroll | ui-frame | 3.179/3.681 | 0.002/0.003 | 6.914/7.669 | - | n/a | n/a | 496.54 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 44.928/46.349 | - | - | - | n/a | n/a | 30.91 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 1.435/1.785 | - | 6.945/6.945 | 6.783/7.823 | n/a | n/a | 31.09 ms | 0 | measured |
| flutter-skia | small | scroll | ui-frame | 3.171/4.138 | - | 7.099/6.945 | - | n/a | n/a | 31.68 ms | 0 | measured |
| flutter-skia | medium | open | ui-frame | 44.342/47.177 | - | - | - | n/a | n/a | 31.00 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 1.431/1.703 | - | 6.945/6.945 | 6.889/7.901 | n/a | n/a | 30.41 ms | 0 | measured |
| flutter-skia | medium | scroll | ui-frame | 4.428/6.372 | - | 9.824/13.889 | - | n/a | n/a | 31.17 ms | 1 | measured |
| flutter-skia | large | open | ui-frame | 43.232/44.580 | - | - | - | n/a | n/a | 36.10 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 1.475/2.106 | - | 6.945/6.945 | 6.714/7.950 | n/a | n/a | 35.40 ms | 0 | measured |
| flutter-skia | large | scroll | ui-frame | 4.342/6.322 | - | 9.689/13.889 | - | n/a | n/a | 35.78 ms | 0 | measured |
| flutter-skia | stress | open | ui-frame | 44.807/46.618 | - | - | - | n/a | n/a | 87.73 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 1.373/1.655 | - | 6.945/6.945 | 6.978/8.013 | n/a | n/a | 88.18 ms | 0 | measured |
| flutter-skia | stress | scroll | ui-frame | 4.393/6.522 | - | 9.664/13.889 | - | n/a | n/a | 89.91 ms | 0 | measured |
| flutter-impeller | small | open | ui-frame | 22.708/24.506 | - | - | - | n/a | n/a | 31.38 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 2.303/3.020 | - | 6.762/6.945 | 6.707/8.266 | n/a | n/a | 32.28 ms | 0 | measured |
| flutter-impeller | small | scroll | ui-frame | 3.851/4.678 | - | 7.068/6.945 | - | n/a | n/a | 32.15 ms | 0 | measured |
| flutter-impeller | medium | open | ui-frame | 23.523/25.011 | - | - | - | n/a | n/a | 31.34 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 2.353/2.901 | - | 6.982/8.073 | 6.971/7.830 | n/a | n/a | 32.22 ms | 0 | measured |
| flutter-impeller | medium | scroll | ui-frame | 5.182/7.344 | - | 9.879/13.890 | - | n/a | n/a | 31.67 ms | 0 | measured |
| flutter-impeller | large | open | ui-frame | 24.702/26.750 | - | - | - | n/a | n/a | 37.40 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 2.275/2.789 | - | 6.993/7.644 | 6.939/8.838 | n/a | n/a | 37.82 ms | 0 | measured |
| flutter-impeller | large | scroll | ui-frame | 5.191/7.103 | - | 9.838/13.889 | - | n/a | n/a | 36.56 ms | 0 | measured |
| flutter-impeller | stress | open | ui-frame | 20.928/22.081 | - | - | - | n/a | n/a | 90.97 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 2.468/3.753 | - | 6.945/6.945 | 6.809/8.167 | n/a | n/a | 89.92 ms | 0 | measured |
| flutter-impeller | stress | scroll | ui-frame | 5.251/7.171 | - | 9.780/13.889 | - | n/a | n/a | 89.69 ms | 0 | measured |
| electron | small | open | ui-frame | 54.833/56.000 | - | - | - | n/a | n/a | 54.83 ms | 0 | measured |
| electron | small | input | ui-frame | 3.347/6.400 | - | 8.335/19.372 | 7.253/14.300 | n/a | n/a | 55.07 ms | 2 | measured |
| electron | small | scroll | ui-frame | 3.416/4.700 | - | 7.049/7.100 | - | n/a | n/a | 55.63 ms | 2 | measured |
| electron | medium | open | ui-frame | 54.767/55.300 | - | - | - | n/a | n/a | 54.77 ms | 0 | measured |
| electron | medium | input | ui-frame | 3.307/6.100 | - | 8.568/19.472 | 7.300/14.500 | n/a | n/a | 55.60 ms | 2 | measured |
| electron | medium | scroll | ui-frame | 3.611/5.100 | - | 7.029/7.100 | - | n/a | n/a | 55.80 ms | 1 | measured |
| electron | large | open | ui-frame | 58.867/60.800 | - | - | - | n/a | n/a | 58.87 ms | 0 | measured |
| electron | large | input | ui-frame | 3.393/4.600 | - | 7.779/13.900 | 7.183/16.800 | n/a | n/a | 58.83 ms | 0 | measured |
| electron | large | scroll | ui-frame | 3.652/5.000 | - | 7.022/7.000 | - | n/a | n/a | 56.80 ms | 2 | measured |
| electron | stress | open | ui-frame | 73.133/74.000 | - | - | - | n/a | n/a | 73.13 ms | 0 | measured |
| electron | stress | input | ui-frame | 3.297/4.600 | - | 8.144/20.800 | 7.450/18.800 | n/a | n/a | 73.63 ms | 2 | measured |
| electron | stress | scroll | ui-frame | 3.666/4.900 | - | 7.049/7.000 | - | n/a | n/a | 73.60 ms | 1 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 4.94/4.93/4.95 | 8.56/8.36/8.67 | 12.28/12.13/11.86 | 16.95/16.47/16.95 | n/a/n/a/n/a |
| MoUI Skia GPU | 4.94/4.91/4.96 | 8.37/8.42/8.60 | 11.82/12.04/12.19 | 16.88/16.71/16.95 | n/a/n/a/n/a |
| MoUI WGPU | 11.11/11.00/11.02 | 14.89/14.71/14.40 | 12.37/12.27/12.26 | 17.04/16.94/16.44 | n/a/n/a/n/a |
| GPUI | 3.19/3.21/3.19 | 3.66/3.70/3.64 | 6.91/6.90/6.90 | 7.66/7.55/7.47 | n/a/n/a/n/a |
| Flutter Skia | 3.17/4.43/4.34 | 4.14/6.37/6.32 | 7.10/9.82/9.69 | 6.95/13.89/13.89 | 0/1/0 |
| Flutter Impeller | 3.85/5.18/5.19 | 4.68/7.34/7.10 | 7.07/9.88/9.84 | 6.95/13.89/13.89 | 0/0/0 |
| Electron | 3.42/3.61/3.65 | 4.70/5.10/5.00 | 7.05/7.03/7.02 | 7.10/7.10/7.00 | 2/1/2 |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 4.96 | 8.53 | 12.20 | 17.10 | n/a |
| MoUI Skia GPU | 4.98 | 8.45 | 12.47 | 17.01 | n/a |
| MoUI WGPU | 10.87 | 14.09 | 12.12 | 16.23 | n/a |
| GPUI | 3.18 | 3.68 | 6.91 | 7.67 | n/a |
| Flutter Skia | 4.39 | 6.52 | 9.66 | 13.89 | 0 |
| Flutter Impeller | 5.25 | 7.17 | 9.78 | 13.89 | 0 |
| Electron | 3.67 | 4.90 | 7.05 | 7.00 | 1 |

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） |
| --- | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 10.07/9.84/10.53 | 11.21/10.84/11.62 | 2.10/2.13/2.05 | 2.65/3.23/2.47 |
| MoUI Skia GPU | 16.96/17.95/19.22 | 17.78/20.63/20.32 | 2.05/2.15/2.16 | 2.63/3.13/3.06 |
| MoUI WGPU | 15.05/15.33/15.60 | 17.69/17.07/17.37 | 13.40/13.56/13.01 | 16.30/15.33/14.75 |
| GPUI | 6.49/6.64/6.59 | 7.63/7.62/7.47 | 3.44/3.51/3.53 | 3.91/4.53/4.36 |
| Flutter Skia | 6.78/6.89/6.71 | 7.82/7.90/7.95 | 1.43/1.43/1.48 | 1.78/1.70/2.11 |
| Flutter Impeller | 6.71/6.97/6.94 | 8.27/7.83/8.84 | 2.30/2.35/2.27 | 3.02/2.90/2.79 |
| Electron | 7.25/7.30/7.18 | 14.30/14.50/16.80 | 3.35/3.31/3.39 | 6.40/6.10/4.60 |

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） |
| --- | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 22.21 | 24.64 | 2.13 | 2.55 |
| MoUI Skia GPU | 32.62 | 35.87 | 2.31 | 3.14 |
| MoUI WGPU | 27.54 | 32.43 | 13.66 | 16.69 |
| GPUI | 6.72 | 7.63 | 3.63 | 4.69 |
| Flutter Skia | 6.98 | 8.01 | 1.37 | 1.66 |
| Flutter Impeller | 6.81 | 8.17 | 2.47 | 3.75 |
| Electron | 7.45 | 18.80 | 3.30 | 4.60 |

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 52.15/54.52/85.23 | 55.07/55.63/90.94 | 33.46/33.90/35.63 | 34.42/34.36/40.32 | 0.18/0.69/4.26 | 0.19/0.80/4.29 |
| MoUI Skia GPU | 118.72/114.36/144.13 | 122.52/121.07/144.87 | 33.30/33.07/32.96 | 38.27/33.76/34.13 | 0.17/0.69/4.06 | 0.18/0.83/4.29 |
| MoUI WGPU | 200.97/210.71/234.43 | 204.32/217.49/235.37 | 193.19/200.86/193.14 | 196.82/207.04/194.19 | 0.19/0.67/3.79 | 0.20/0.72/3.94 |
| GPUI | 510.70/503.53/501.86 | 526.11/509.23/506.82 | 5.12/4.73/4.36 | 5.79/5.35/4.91 | 0.00/1.33/4.33 | 0.00/2.00/5.00 |
| Flutter Skia | 30.91/31.00/36.10 | 32.74/31.82/36.83 | 44.93/44.34/43.23 | 46.35/47.18/44.58 | 1.01/1.05/1.21 | 1.12/1.13/1.36 |
| Flutter Impeller | 31.38/31.34/37.40 | 32.99/33.11/39.42 | 22.71/23.52/24.70 | 24.51/25.01/26.75 | 0.96/1.06/1.36 | 1.01/1.15/1.50 |
| Electron | 54.83/54.77/58.87 | 56.00/55.30/60.80 | 54.83/54.77/58.87 | 56.00/55.30/60.80 | 3.55/3.73/3.85 | 4.14/4.09/4.22 |

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 398.56 | 410.30 | 34.18 | 34.67 | 43.72 | 45.31 |
| MoUI Skia GPU | 457.37 | 472.91 | 32.34 | 33.63 | 39.50 | 41.15 |
| MoUI WGPU | 532.99 | 536.10 | 191.73 | 194.95 | 39.50 | 41.37 |
| GPUI | 493.20 | 498.03 | 4.29 | 4.41 | 39.67 | 41.00 |
| Flutter Skia | 87.73 | 89.75 | 44.81 | 46.62 | 3.81 | 4.03 |
| Flutter Impeller | 90.97 | 99.49 | 20.93 | 22.08 | 4.68 | 5.03 |
| Electron | 73.13 | 74.00 | 73.13 | 74.00 | 9.87 | 10.22 |

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 离屏均值（ms） | 离屏 P95（ms） | 回读均值（ms） | 回读 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 4.94/4.93/4.95 | 8.56/8.36/8.67 | 12.28/12.13/11.86 | 16.95/16.47/16.95 | n/a/n/a/n/a | 0.00/0.00/0.00 | 0.00/0.00/0.00 | 6.06/5.84/5.59 | 7.39/7.29/6.65 |
| MoUI Skia GPU | 4.94/4.91/4.96 | 8.37/8.42/8.60 | 11.82/12.04/12.19 | 16.88/16.71/16.95 | n/a/n/a/n/a | 0.00/0.00/0.00 | 0.00/0.00/0.00 | 5.54/5.81/5.89 | 6.78/7.14/7.21 |
| MoUI WGPU | 11.11/11.00/11.02 | 14.89/14.71/14.40 | 12.37/12.27/12.26 | 17.04/16.94/16.44 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | 0.00/0.00/0.00 | 0.00/0.00/0.00 |
| GPUI | 3.19/3.21/3.19 | 3.66/3.70/3.64 | 6.91/6.90/6.90 | 7.66/7.55/7.47 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 3.17/4.43/4.34 | 4.14/6.37/6.32 | 7.10/9.82/9.69 | 6.95/13.89/13.89 | 0/1/0 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Impeller | 3.85/5.18/5.19 | 4.68/7.34/7.10 | 7.07/9.88/9.84 | 6.95/13.89/13.89 | 0/0/0 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Electron | 3.42/3.61/3.65 | 4.70/5.10/5.00 | 7.05/7.03/7.02 | 7.10/7.10/7.00 | 2/1/2 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 离屏均值（ms） | 离屏 P95（ms） | 回读均值（ms） | 回读 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 4.96 | 8.53 | 12.20 | 17.10 | n/a | 0.00 | 0.00 | 5.93 | 7.44 |
| MoUI Skia GPU | 4.98 | 8.45 | 12.47 | 17.01 | n/a | 0.00 | 0.00 | 6.16 | 7.54 |
| MoUI WGPU | 10.87 | 14.09 | 12.12 | 16.23 | n/a | n/a | n/a | 0.00 | 0.00 |
| GPUI | 3.18 | 3.68 | 6.91 | 7.67 | n/a | n/a | n/a | n/a | n/a |
| Flutter Skia | 4.39 | 6.52 | 9.66 | 13.89 | 0 | n/a | n/a | n/a | n/a |
| Flutter Impeller | 5.25 | 7.17 | 9.78 | 13.89 | 0 | n/a | n/a | n/a | n/a |
| Electron | 3.67 | 4.90 | 7.05 | 7.00 | 1 | n/a | n/a | n/a | n/a |

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoUI Skia Raster CPU stress 398.6 ms（max 410.3 ms）；MoUI Skia GPU small 118.7 ms（max 122.5 ms）；MoUI Skia GPU medium 114.4 ms（max 121.1 ms）；MoUI Skia GPU large 144.1 ms（max 144.9 ms）；MoUI Skia GPU stress 457.4 ms（max 472.9 ms）；MoUI WGPU small 201.0 ms（max 204.3 ms）；MoUI WGPU medium 210.7 ms（max 217.5 ms）；MoUI WGPU large 234.4 ms（max 235.4 ms）；MoUI WGPU stress 533.0 ms（max 536.1 ms）；GPUI small 510.7 ms（max 526.1 ms）；GPUI medium 503.5 ms（max 509.2 ms）；GPUI large 501.9 ms（max 506.8 ms）；GPUI stress 493.2 ms（max 498.0 ms）。
- P1 输入尾延迟：MoUI Skia Raster CPU stress P95 24.64 ms；MoUI Skia GPU small P95 17.78 ms；MoUI Skia GPU medium P95 20.63 ms；MoUI Skia GPU large P95 20.32 ms；MoUI Skia GPU stress P95 35.87 ms；MoUI WGPU small P95 17.69 ms；MoUI WGPU medium P95 17.07 ms；MoUI WGPU large P95 17.37 ms；MoUI WGPU stress P95 32.43 ms；Electron large P95 16.80 ms；Electron stress P95 18.80 ms。
- 长帧（超预算）：MoUI Skia Raster CPU: small/scroll 23 次，max 19.83 ms, medium/scroll 16 次，max 27.49 ms, large/scroll 21 次，max 23.19 ms, stress/input 30 次，max 25.71 ms, stress/scroll 23 次，max 19.98 ms；MoUI Skia GPU: small/input 19 次，max 17.80 ms, small/scroll 21 次，max 22.50 ms, medium/input 30 次，max 20.97 ms, medium/scroll 18 次，max 19.39 ms, large/input 30 次，max 21.18 ms, large/scroll 25 次，max 20.07 ms, stress/input 30 次，max 36.93 ms, stress/scroll 26 次，max 19.49 ms；MoUI WGPU: small/input 3 次，max 28.12 ms, small/scroll 23 次，max 24.81 ms, medium/input 2 次，max 20.49 ms, medium/scroll 20 次，max 20.40 ms, large/input 5 次，max 17.52 ms, large/scroll 14 次，max 19.65 ms, stress/input 30 次，max 33.23 ms, stress/scroll 11 次，max 18.59 ms；Flutter Skia: medium/scroll 1 次，max 27.78 ms；Electron: small/input 2 次，max 20.80 ms, small/scroll 2 次，max 20.90 ms, medium/input 2 次，max 20.80 ms, medium/scroll 1 次，max 19.37 ms, large/scroll 2 次，max 20.80 ms, stress/input 2 次，max 20.80 ms, stress/scroll 1 次，max 20.90 ms。
- 丢帧（优先处理）：Flutter Skia: medium/scroll 1 帧；Electron: small/input 2 帧, small/scroll 2 帧, medium/input 2 帧, medium/scroll 1 帧, large/scroll 2 帧, stress/input 2 帧, stress/scroll 1 帧。
- 解释：首帧异常优先检查窗口/渲染器初始化；输入尾延迟检查 action 到下一可见帧的调度与同步重建；长帧检查解析、布局、文本 shaping 和 GPU 提交；`n/a` 表示未埋点，不等于 0。
- 普通模式的长帧、帧间隔和输入延迟是各框架回调诊断，不能替代跨框架 compositor 排名；需要严格结论时运行 `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`。

## 采集口径

- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。
- `frame_work_ms` 对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧；严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代；打开场景没有前一帧，所以不计算 interval/drop。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。
