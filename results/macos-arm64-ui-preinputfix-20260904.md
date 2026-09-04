# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-04T04:06:35Z`
- 数据状态：`360 measured`，`0 skipped/error`；原始样本保留在 JSON。
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
| moui-skia-raster | small | open | ui-frame | 46.225/46.566 | - | - | - | 5.15 ms | 0.00 ms | 5.15 ms | 52.86 ms | n/a | measured |
| moui-skia-raster | small | input | ui-frame | 0.518/0.547 | - | 4.005/4.241 | 4.005/4.239 | 3.20 ms | 0.00 ms | 3.20 ms | 53.80 ms | n/a | measured |
| moui-skia-raster | small | scroll | ui-frame | 1.638/3.618 | - | 5.632/8.542 | - | 3.42 ms | 0.00 ms | 3.42 ms | 53.45 ms | n/a | measured |
| moui-skia-raster | medium | open | ui-frame | 46.597/47.316 | - | - | - | 5.02 ms | 0.00 ms | 5.02 ms | 53.20 ms | n/a | measured |
| moui-skia-raster | medium | input | ui-frame | 0.524/0.560 | - | 4.064/4.325 | 4.064/4.324 | 3.23 ms | 0.00 ms | 3.23 ms | 57.74 ms | n/a | measured |
| moui-skia-raster | medium | scroll | ui-frame | 1.634/3.617 | - | 5.554/8.361 | - | 3.34 ms | 0.00 ms | 3.34 ms | 52.07 ms | n/a | measured |
| moui-skia-raster | large | open | ui-frame | 45.138/46.017 | - | - | - | 4.90 ms | 0.00 ms | 4.90 ms | 53.33 ms | n/a | measured |
| moui-skia-raster | large | input | ui-frame | 0.520/0.550 | - | 4.177/4.335 | 4.177/4.335 | 3.21 ms | 0.00 ms | 3.21 ms | 59.50 ms | n/a | measured |
| moui-skia-raster | large | scroll | ui-frame | 1.646/3.682 | - | 5.675/8.493 | - | 3.44 ms | 0.00 ms | 3.44 ms | 53.85 ms | n/a | measured |
| moui-skia-raster | stress | open | ui-frame | 45.933/46.804 | - | - | - | 4.88 ms | 0.00 ms | 4.88 ms | 70.76 ms | n/a | measured |
| moui-skia-raster | stress | input | ui-frame | 0.643/0.791 | - | 6.863/8.188 | 6.862/8.187 | 3.54 ms | 0.00 ms | 3.54 ms | 78.12 ms | n/a | measured |
| moui-skia-raster | stress | scroll | ui-frame | 1.677/3.757 | - | 5.738/8.940 | - | 3.46 ms | 0.00 ms | 3.46 ms | 74.39 ms | n/a | measured |
| moui-skia-gpu | small | open | ui-frame | 44.163/45.515 | - | - | - | 11.37 ms | n/a | 0.00 ms | 56.94 ms | n/a | measured |
| moui-skia-gpu | small | input | ui-frame | 0.558/0.625 | - | 8.356/9.273 | 8.355/9.273 | 7.45 ms | n/a | 0.00 ms | 58.87 ms | n/a | measured |
| moui-skia-gpu | small | scroll | ui-frame | 1.651/3.642 | - | 8.399/9.277 | - | 6.14 ms | n/a | 0.00 ms | 60.53 ms | n/a | measured |
| moui-skia-gpu | medium | open | ui-frame | 42.669/44.848 | - | - | - | 15.59 ms | n/a | 0.00 ms | 59.91 ms | n/a | measured |
| moui-skia-gpu | medium | input | ui-frame | 0.571/0.695 | - | 8.366/9.042 | 8.365/9.042 | 7.42 ms | n/a | 0.00 ms | 60.47 ms | n/a | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 1.639/3.539 | - | 8.386/9.283 | - | 6.15 ms | n/a | 0.00 ms | 59.18 ms | n/a | measured |
| moui-skia-gpu | large | open | ui-frame | 43.299/43.780 | - | - | - | 11.00 ms | n/a | 0.00 ms | 57.67 ms | n/a | measured |
| moui-skia-gpu | large | input | ui-frame | 0.582/0.695 | - | 8.441/9.406 | 8.440/9.406 | 7.33 ms | n/a | 0.00 ms | 63.88 ms | n/a | measured |
| moui-skia-gpu | large | scroll | ui-frame | 1.719/3.729 | - | 8.557/9.470 | - | 6.20 ms | n/a | 0.00 ms | 62.02 ms | n/a | measured |
| moui-skia-gpu | stress | open | ui-frame | 43.249/43.728 | - | - | - | 10.98 ms | n/a | 0.00 ms | 73.76 ms | n/a | measured |
| moui-skia-gpu | stress | input | ui-frame | 0.585/0.624 | - | 8.434/9.130 | 8.433/9.129 | 5.40 ms | n/a | 0.00 ms | 78.73 ms | n/a | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 1.695/3.704 | - | 8.430/9.280 | - | 6.11 ms | n/a | 0.00 ms | 84.88 ms | n/a | measured |
| moui-wgpu | small | open | ui-frame | 43.588/47.275 | - | - | - | 9.77 ms | n/a | 0.00 ms | 54.81 ms | n/a | measured |
| moui-wgpu | small | input | ui-frame | 0.569/0.644 | - | 8.179/9.244 | 8.179/9.243 | 7.26 ms | n/a | 0.00 ms | 52.07 ms | n/a | measured |
| moui-wgpu | small | scroll | ui-frame | 1.898/3.431 | - | 8.340/9.345 | - | 5.69 ms | n/a | 0.00 ms | 84.62 ms | n/a | measured |
| moui-wgpu | medium | open | ui-frame | 40.141/41.120 | - | - | - | 9.44 ms | n/a | 0.00 ms | 51.17 ms | n/a | measured |
| moui-wgpu | medium | input | ui-frame | 0.502/0.574 | - | 8.174/9.330 | 8.174/9.329 | 7.33 ms | n/a | 0.00 ms | 52.46 ms | n/a | measured |
| moui-wgpu | medium | scroll | ui-frame | 2.132/3.518 | - | 8.337/9.336 | - | 5.45 ms | n/a | 0.00 ms | 51.34 ms | n/a | measured |
| moui-wgpu | large | open | ui-frame | 39.601/39.919 | - | - | - | 9.33 ms | n/a | 0.00 ms | 52.35 ms | n/a | measured |
| moui-wgpu | large | input | ui-frame | 0.562/0.654 | - | 8.190/9.741 | 8.190/9.740 | 7.06 ms | n/a | 0.00 ms | 53.26 ms | n/a | measured |
| moui-wgpu | large | scroll | ui-frame | 2.108/3.372 | - | 8.328/9.308 | - | 5.48 ms | n/a | 0.00 ms | 52.81 ms | n/a | measured |
| moui-wgpu | stress | open | ui-frame | 41.278/42.081 | - | - | - | 9.48 ms | n/a | 0.00 ms | 70.51 ms | n/a | measured |
| moui-wgpu | stress | input | ui-frame | 0.619/1.029 | - | 8.496/10.894 | 8.494/10.894 | 4.73 ms | n/a | 0.00 ms | 76.01 ms | n/a | measured |
| moui-wgpu | stress | scroll | ui-frame | 2.101/3.429 | - | 8.332/9.266 | - | 5.49 ms | n/a | 0.00 ms | 71.31 ms | n/a | measured |
| moui-md-skia-raster | small | open | ui-frame | 47.863/48.864 | - | - | - | 12.97 ms | 0.00 ms | 12.97 ms | 66.03 ms | n/a | measured |
| moui-md-skia-raster | small | input | ui-frame | 3.799/4.385 | - | 25.533/28.668 | 25.457/28.668 | 4.38 ms | 0.00 ms | 4.38 ms | 68.09 ms | n/a | measured |
| moui-md-skia-raster | small | scroll | ui-frame | 1.310/1.546 | - | 3.760/4.406 | - | 2.30 ms | 0.00 ms | 2.30 ms | 69.10 ms | n/a | measured |
| moui-md-skia-raster | medium | open | ui-frame | 53.830/54.217 | - | - | - | 13.21 ms | 0.00 ms | 13.21 ms | 103.21 ms | n/a | measured |
| moui-md-skia-raster | medium | input | ui-frame | 7.545/7.883 | - | 181.663/198.820 | 181.072/197.760 | 4.33 ms | 0.00 ms | 4.33 ms | 113.11 ms | n/a | measured |
| moui-md-skia-raster | medium | scroll | ui-frame | 5.179/5.808 | - | 7.975/9.029 | - | 2.44 ms | 0.00 ms | 2.44 ms | 104.15 ms | n/a | measured |
| moui-md-skia-raster | large | open | ui-frame | 116.319/118.154 | - | - | - | 12.97 ms | 0.00 ms | 12.97 ms | 478.49 ms | n/a | measured |
| moui-md-skia-raster | large | input | ui-frame | 44.030/45.311 | - | 1771.965/1858.129 | 1766.149/1816.361 | 4.77 ms | 0.00 ms | 4.77 ms | 587.74 ms | n/a | measured |
| moui-md-skia-raster | large | scroll | ui-frame | 42.926/47.367 | - | 47.749/52.534 | - | 2.54 ms | 0.00 ms | 2.54 ms | 479.38 ms | n/a | measured |
| moui-md-skia-raster | stress | open | ui-frame | 768.673/779.965 | - | - | - | 13.11 ms | 0.00 ms | 13.11 ms | 4307.34 ms | n/a | measured |
| moui-md-skia-raster | stress | input | ui-frame | 401.410/411.569 | - | 17789.760/19919.207 | 17732.512/19346.656 | 4.73 ms | 0.00 ms | 4.73 ms | 5133.81 ms | n/a | measured |
| moui-md-skia-raster | stress | scroll | ui-frame | 422.227/458.639 | - | 446.936/481.657 | - | 2.59 ms | 0.00 ms | 2.59 ms | 4209.24 ms | n/a | measured |
| moui-md-skia-gpu | small | open | ui-frame | 43.885/43.969 | - | - | - | 26.46 ms | n/a | 0.00 ms | 75.48 ms | n/a | measured |
| moui-md-skia-gpu | small | input | ui-frame | 3.361/3.593 | - | 24.045/28.102 | 23.968/28.101 | 3.90 ms | n/a | 0.00 ms | 77.98 ms | n/a | measured |
| moui-md-skia-gpu | small | scroll | ui-frame | 1.890/2.472 | - | 8.344/9.157 | - | 6.24 ms | n/a | 0.00 ms | 76.84 ms | n/a | measured |
| moui-md-skia-gpu | medium | open | ui-frame | 50.473/50.878 | - | - | - | 26.23 ms | n/a | 0.00 ms | 112.44 ms | n/a | measured |
| moui-md-skia-gpu | medium | input | ui-frame | 7.057/7.407 | - | 182.587/184.338 | 182.001/184.338 | 4.06 ms | n/a | 0.00 ms | 122.70 ms | n/a | measured |
| moui-md-skia-gpu | medium | scroll | ui-frame | 4.962/5.502 | - | 8.416/9.470 | - | 3.12 ms | n/a | 0.00 ms | 111.63 ms | n/a | measured |
| moui-md-skia-gpu | large | open | ui-frame | 113.160/113.193 | - | - | - | 26.26 ms | n/a | 0.00 ms | 478.86 ms | n/a | measured |
| moui-md-skia-gpu | large | input | ui-frame | 41.794/41.981 | - | 1696.127/1749.752 | 1690.459/1707.402 | 4.22 ms | n/a | 0.00 ms | 563.47 ms | n/a | measured |
| moui-md-skia-gpu | large | scroll | ui-frame | 41.821/45.749 | - | 45.682/50.930 | - | 1.72 ms | n/a | 0.00 ms | 480.98 ms | n/a | measured |
| moui-md-skia-gpu | stress | open | ui-frame | 749.116/749.933 | - | - | - | 25.06 ms | n/a | 0.00 ms | 4201.97 ms | n/a | measured |
| moui-md-skia-gpu | stress | input | ui-frame | 395.908/397.005 | - | 17268.933/17816.613 | 17211.519/17363.850 | 5.29 ms | n/a | 0.00 ms | 5112.02 ms | n/a | measured |
| moui-md-skia-gpu | stress | scroll | ui-frame | 421.163/457.753 | - | 444.560/480.049 | - | 1.91 ms | n/a | 0.00 ms | 4220.63 ms | n/a | measured |
| moui-md-wgpu | small | open | ui-frame | 36.213/36.525 | - | - | - | 12.28 ms | n/a | 0.00 ms | 53.61 ms | n/a | measured |
| moui-md-wgpu | small | input | ui-frame | 1.634/1.731 | - | 20.416/21.241 | 20.334/21.162 | 1.79 ms | n/a | 0.00 ms | 57.10 ms | n/a | measured |
| moui-md-wgpu | small | scroll | ui-frame | 1.624/1.897 | - | 8.310/9.416 | - | 6.51 ms | n/a | 0.00 ms | 55.73 ms | n/a | measured |
| moui-md-wgpu | medium | open | ui-frame | 43.891/44.366 | - | - | - | 12.59 ms | n/a | 0.00 ms | 91.90 ms | n/a | measured |
| moui-md-wgpu | medium | input | ui-frame | 5.168/5.254 | - | 172.203/177.222 | 171.586/173.317 | 1.98 ms | n/a | 0.00 ms | 101.68 ms | n/a | measured |
| moui-md-wgpu | medium | scroll | ui-frame | 5.482/5.976 | - | 8.486/9.852 | - | 2.64 ms | n/a | 0.00 ms | 91.46 ms | n/a | measured |
| moui-md-wgpu | large | open | ui-frame | 106.088/106.593 | - | - | - | 12.51 ms | n/a | 0.00 ms | 456.66 ms | n/a | measured |
| moui-md-wgpu | large | input | ui-frame | 39.624/40.100 | - | 1698.654/1743.213 | 1692.900/1713.113 | 3.86 ms | n/a | 0.00 ms | 544.55 ms | n/a | measured |
| moui-md-wgpu | large | scroll | ui-frame | 42.252/45.983 | - | 46.759/50.567 | - | 2.04 ms | n/a | 0.00 ms | 458.16 ms | n/a | measured |
| moui-md-wgpu | stress | open | ui-frame | 740.369/742.279 | - | - | - | 12.13 ms | n/a | 0.00 ms | 4179.91 ms | n/a | measured |
| moui-md-wgpu | stress | input | ui-frame | 393.393/395.224 | - | 17189.614/17800.823 | 17132.272/17237.303 | 4.16 ms | n/a | 0.00 ms | 5076.87 ms | n/a | measured |
| moui-md-wgpu | stress | scroll | ui-frame | 421.041/458.149 | - | 445.053/479.652 | - | 2.36 ms | n/a | 0.00 ms | 4195.11 ms | n/a | measured |
| gpui | small | open | ui-frame | 16.966/17.046 | - | - | - | n/a | n/a | n/a | 111.61 ms | n/a | measured |
| gpui | small | input | ui-frame | 15.867/16.511 | 0.786/0.876 | 20.005/25.196 | 20.004/25.195 | n/a | n/a | n/a | 113.02 ms | n/a | measured |
| gpui | small | scroll | ui-frame | 17.502/20.107 | 0.001/0.002 | 20.626/23.642 | - | n/a | n/a | n/a | 114.48 ms | n/a | measured |
| gpui | medium | open | ui-frame | 16.557/16.792 | - | - | - | n/a | n/a | n/a | 111.63 ms | n/a | measured |
| gpui | medium | input | ui-frame | 15.887/16.539 | 1.601/1.702 | 21.013/25.682 | 21.012/25.681 | n/a | n/a | n/a | 111.16 ms | n/a | measured |
| gpui | medium | scroll | ui-frame | 17.520/20.096 | 0.001/0.002 | 21.030/24.033 | - | n/a | n/a | n/a | 109.92 ms | n/a | measured |
| gpui | large | open | ui-frame | 16.344/16.372 | - | - | - | n/a | n/a | n/a | 121.63 ms | n/a | measured |
| gpui | large | input | ui-frame | 15.917/16.590 | 10.098/10.546 | 28.028/32.908 | 28.026/32.907 | n/a | n/a | n/a | 115.37 ms | n/a | measured |
| gpui | large | scroll | ui-frame | 17.591/20.156 | 0.001/0.002 | 25.068/27.886 | - | n/a | n/a | n/a | 118.01 ms | n/a | measured |
| gpui | stress | open | ui-frame | 16.638/16.900 | - | - | - | n/a | n/a | n/a | 121.16 ms | n/a | measured |
| gpui | stress | input | ui-frame | 15.772/16.454 | 104.586/108.575 | 113.042/128.826 | 113.040/128.820 | n/a | n/a | n/a | 116.80 ms | n/a | measured |
| gpui | stress | scroll | ui-frame | 17.749/20.084 | 0.002/0.003 | 64.548/67.961 | - | n/a | n/a | n/a | 119.13 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 0.195/0.208 | - | - | - | 9.60 ms | n/a | n/a | 29.33 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 0.385/0.508 | - | 16.667/16.667 | 16.679/24.502 | 0.33 ms | n/a | n/a | 29.83 ms | 0 | measured |
| flutter-skia | small | scroll | ui-frame | 3.665/4.773 | - | 16.667/16.669 | - | 0.84 ms | n/a | n/a | 29.20 ms | 72 | measured |
| flutter-skia | medium | open | ui-frame | 0.197/0.214 | - | - | - | 9.47 ms | n/a | n/a | 29.26 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 0.381/0.527 | - | 16.667/16.667 | 16.685/21.793 | 0.33 ms | n/a | n/a | 29.39 ms | 1 | measured |
| flutter-skia | medium | scroll | ui-frame | 3.616/6.566 | - | 16.667/16.671 | - | 0.46 ms | n/a | n/a | 28.96 ms | 107 | measured |
| flutter-skia | large | open | ui-frame | 0.212/0.234 | - | - | - | 9.62 ms | n/a | n/a | 31.79 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 0.405/0.544 | - | 16.667/16.667 | 16.675/23.032 | 0.33 ms | n/a | n/a | 31.97 ms | 1 | measured |
| flutter-skia | large | scroll | ui-frame | 3.505/6.540 | - | 16.574/16.671 | - | 0.45 ms | n/a | n/a | 31.87 ms | 111 | measured |
| flutter-skia | stress | open | ui-frame | 0.252/0.327 | - | - | - | 10.12 ms | n/a | n/a | 57.62 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 0.375/0.557 | - | 16.667/16.667 | 16.670/18.951 | 0.31 ms | n/a | n/a | 55.63 ms | 1 | measured |
| flutter-skia | stress | scroll | ui-frame | 3.567/6.387 | - | 16.620/16.671 | - | 0.45 ms | n/a | n/a | 58.38 ms | 109 | measured |
| flutter-impeller | small | open | ui-frame | 0.237/0.283 | - | - | - | 8.09 ms | n/a | n/a | 25.06 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 0.384/0.569 | - | 16.667/16.667 | 16.657/20.644 | 0.38 ms | n/a | n/a | 29.31 ms | 0 | measured |
| flutter-impeller | small | scroll | ui-frame | 3.641/4.818 | - | 16.667/16.670 | - | 0.76 ms | n/a | n/a | 28.07 ms | 91 | measured |
| flutter-impeller | medium | open | ui-frame | 0.218/0.229 | - | - | - | 7.78 ms | n/a | n/a | 28.73 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 0.410/0.619 | - | 16.667/16.668 | 16.646/20.524 | 0.39 ms | n/a | n/a | 31.08 ms | 2 | measured |
| flutter-impeller | medium | scroll | ui-frame | 3.640/6.661 | - | 16.620/16.671 | - | 0.52 ms | n/a | n/a | 30.68 ms | 110 | measured |
| flutter-impeller | large | open | ui-frame | 0.202/0.204 | - | - | - | 7.81 ms | n/a | n/a | 31.92 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 0.397/0.520 | - | 16.667/16.667 | 16.661/20.530 | 0.37 ms | n/a | n/a | 29.31 ms | 0 | measured |
| flutter-impeller | large | scroll | ui-frame | 3.675/6.655 | - | 16.667/16.671 | - | 0.50 ms | n/a | n/a | 31.67 ms | 107 | measured |
| flutter-impeller | stress | open | ui-frame | 0.221/0.226 | - | - | - | 7.76 ms | n/a | n/a | 59.46 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 0.370/0.473 | - | 16.667/16.668 | 16.701/26.181 | 0.34 ms | n/a | n/a | 62.85 ms | 3 | measured |
| flutter-impeller | stress | scroll | ui-frame | 3.651/6.428 | - | 16.667/16.671 | - | 0.50 ms | n/a | n/a | 59.67 ms | 115 | measured |
| electron | small | open | ui-frame | 13.967/14.100 | - | - | - | n/a | n/a | n/a | 13.97 ms | 0 | measured |
| electron | small | input | ui-frame | 1.517/3.000 | - | 15.007/16.800 | 14.703/16.800 | n/a | n/a | n/a | 14.70 ms | 16 | measured |
| electron | small | scroll | ui-frame | 2.139/3.500 | - | 16.666/17.300 | - | n/a | n/a | n/a | 13.47 ms | 215 | measured |
| electron | medium | open | ui-frame | 14.567/15.800 | - | - | - | n/a | n/a | n/a | 14.57 ms | 0 | measured |
| electron | medium | input | ui-frame | 1.413/2.400 | - | 14.997/16.700 | 14.730/16.700 | n/a | n/a | n/a | 15.57 ms | 17 | measured |
| electron | medium | scroll | ui-frame | 2.256/3.700 | - | 16.667/17.900 | - | n/a | n/a | n/a | 17.30 ms | 222 | measured |
| electron | large | open | ui-frame | 14.933/15.000 | - | - | - | n/a | n/a | n/a | 14.93 ms | 0 | measured |
| electron | large | input | ui-frame | 1.487/2.400 | - | 15.000/16.800 | 14.697/16.800 | n/a | n/a | n/a | 16.43 ms | 15 | measured |
| electron | large | scroll | ui-frame | 2.149/3.400 | - | 16.665/16.800 | - | n/a | n/a | n/a | 16.60 ms | 218 | measured |
| electron | stress | open | ui-frame | 22.300/22.300 | - | - | - | n/a | n/a | n/a | 22.30 ms | 0 | measured |
| electron | stress | input | ui-frame | 1.310/1.700 | - | 15.007/16.700 | 14.457/16.800 | n/a | n/a | n/a | 22.23 ms | 18 | measured |
| electron | stress | scroll | ui-frame | 2.513/4.100 | - | 16.570/17.900 | - | n/a | n/a | n/a | 22.30 ms | 212 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.64/1.63/1.65 | 3.62/3.62/3.68 | 3.42/3.34/3.44 | 4.02/3.92/4.09 | 5.63/5.55/5.67 | 8.54/8.36/8.49 | n/a/n/a/n/a |
| MoUI Skia GPU | 1.65/1.64/1.72 | 3.64/3.54/3.73 | 6.14/6.15/6.20 | 7.72/7.78/7.79 | 8.40/8.39/8.56 | 9.28/9.28/9.47 | n/a/n/a/n/a |
| MoUI WGPU | 1.90/2.13/2.11 | 3.43/3.52/3.37 | 5.69/5.45/5.48 | 8.14/8.04/8.07 | 8.34/8.34/8.33 | 9.34/9.34/9.31 | n/a/n/a/n/a |
| MoUI 示例编辑器 Skia Raster | 1.31/5.18/42.93 | 1.55/5.81/47.37 | 2.30/2.44/2.54 | 2.72/2.84/2.94 | 3.76/7.97/47.75 | 4.41/9.03/52.53 | n/a/n/a/n/a |
| MoUI 示例编辑器 Skia GPU | 1.89/4.96/41.82 | 2.47/5.50/45.75 | 6.24/3.12/1.72 | 7.42/3.70/5.10 | 8.34/8.42/45.68 | 9.16/9.47/50.93 | n/a/n/a/n/a |
| MoUI 示例编辑器 WGPU | 1.62/5.48/42.25 | 1.90/5.98/45.98 | 6.51/2.64/2.04 | 7.88/3.56/2.41 | 8.31/8.49/46.76 | 9.42/9.85/50.57 | n/a/n/a/n/a |
| GPUI (md_mbt) | 17.50/17.52/17.59 | 20.11/20.10/20.16 | n/a/n/a/n/a | n/a/n/a/n/a | 20.63/21.03/25.07 | 23.64/24.03/27.89 | n/a/n/a/n/a |
| Flutter Skia | 3.67/3.62/3.51 | 4.77/6.57/6.54 | 0.84/0.46/0.45 | 1.18/0.73/0.64 | 16.67/16.67/16.57 | 16.67/16.67/16.67 | 72/107/111 |
| Flutter Impeller | 3.64/3.64/3.68 | 4.82/6.66/6.66 | 0.76/0.52/0.50 | 1.17/0.83/0.82 | 16.67/16.62/16.67 | 16.67/16.67/16.67 | 91/110/107 |
| Electron | 2.14/2.26/2.15 | 3.50/3.70/3.40 | n/a/n/a/n/a | n/a/n/a/n/a | 16.67/16.67/16.66 | 17.30/17.90/16.80 | 215/222/218 |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.68 | 3.76 | 3.46 | 4.14 | 5.74 | 8.94 | n/a |
| MoUI Skia GPU | 1.70 | 3.70 | 6.11 | 7.76 | 8.43 | 9.28 | n/a |
| MoUI WGPU | 2.10 | 3.43 | 5.49 | 8.01 | 8.33 | 9.27 | n/a |
| MoUI 示例编辑器 Skia Raster | 422.23 | 458.64 | 2.59 | 3.13 | 446.94 | 481.66 | n/a |
| MoUI 示例编辑器 Skia GPU | 421.16 | 457.75 | 1.91 | 4.58 | 444.56 | 480.05 | n/a |
| MoUI 示例编辑器 WGPU | 421.04 | 458.15 | 2.36 | 2.71 | 445.05 | 479.65 | n/a |
| GPUI (md_mbt) | 17.75 | 20.08 | n/a | n/a | 64.55 | 67.96 | n/a |
| Flutter Skia | 3.57 | 6.39 | 0.45 | 0.69 | 16.62 | 16.67 | 109 |
| Flutter Impeller | 3.65 | 6.43 | 0.50 | 0.73 | 16.67 | 16.67 | 115 |
| Electron | 2.51 | 4.10 | n/a | n/a | 16.57 | 17.90 | 212 |

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 4.00/4.06/4.18 | 4.24/4.32/4.33 | 0.52/0.52/0.52 | 0.55/0.56/0.55 | 3.20/3.23/3.21 | 3.45/3.50/3.39 |
| MoUI Skia GPU | 8.36/8.36/8.44 | 9.27/9.04/9.41 | 0.56/0.57/0.58 | 0.62/0.69/0.70 | 7.45/7.42/7.33 | 8.34/8.19/8.28 |
| MoUI WGPU | 8.18/8.17/8.19 | 9.24/9.33/9.74 | 0.57/0.50/0.56 | 0.64/0.57/0.65 | 7.26/7.33/7.06 | 8.39/8.48/8.56 |
| MoUI 示例编辑器 Skia Raster | 25.46/181.07/1766.15 | 28.67/197.76/1816.36 | 3.80/7.55/44.03 | 4.39/7.88/45.31 | 4.38/4.33/4.77 | 5.06/4.61/5.52 |
| MoUI 示例编辑器 Skia GPU | 23.97/182.00/1690.46 | 28.10/184.34/1707.40 | 3.36/7.06/41.79 | 3.59/7.41/41.98 | 3.90/4.06/4.22 | 7.90/7.19/6.79 |
| MoUI 示例编辑器 WGPU | 20.33/171.59/1692.90 | 21.16/173.32/1713.11 | 1.63/5.17/39.62 | 1.73/5.25/40.10 | 1.79/1.98/3.86 | 2.49/2.68/4.40 |
| GPUI (md_mbt) | 20.00/21.01/28.03 | 25.19/25.68/32.91 | 15.87/15.89/15.92 | 16.51/16.54/16.59 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 16.68/16.69/16.68 | 24.50/21.79/23.03 | 0.38/0.38/0.41 | 0.51/0.53/0.54 | 0.33/0.33/0.33 | 0.46/0.48/0.41 |
| Flutter Impeller | 16.66/16.65/16.66 | 20.64/20.52/20.53 | 0.38/0.41/0.40 | 0.57/0.62/0.52 | 0.38/0.39/0.37 | 0.55/0.53/0.57 |
| Electron | 14.70/14.73/14.70 | 16.80/16.70/16.80 | 1.52/1.41/1.49 | 3.00/2.40/2.40 | n/a/n/a/n/a | n/a/n/a/n/a |

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.86 | 8.19 | 0.64 | 0.79 | 3.54 | 4.18 |
| MoUI Skia GPU | 8.43 | 9.13 | 0.58 | 0.62 | 5.40 | 6.19 |
| MoUI WGPU | 8.49 | 10.89 | 0.62 | 1.03 | 4.73 | 5.93 |
| MoUI 示例编辑器 Skia Raster | 17732.51 | 19346.66 | 401.41 | 411.57 | 4.73 | 6.24 |
| MoUI 示例编辑器 Skia GPU | 17211.52 | 17363.85 | 395.91 | 397.00 | 5.29 | 8.92 |
| MoUI 示例编辑器 WGPU | 17132.27 | 17237.30 | 393.39 | 395.22 | 4.16 | 4.98 |
| GPUI (md_mbt) | 113.04 | 128.82 | 15.77 | 16.45 | n/a | n/a |
| Flutter Skia | 16.67 | 18.95 | 0.38 | 0.56 | 0.31 | 0.58 |
| Flutter Impeller | 16.70 | 26.18 | 0.37 | 0.47 | 0.34 | 0.49 |
| Electron | 14.46 | 16.80 | 1.31 | 1.70 | n/a | n/a |

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 52.86/53.20/53.33 | 53.27/54.11/54.06 | 46.23/46.60/45.14 | 46.57/47.32/46.02 | 5.15/5.02/4.90 | 5.25/5.20/4.94 | 0.07/0.29/2.09 | 0.09/0.31/2.41 |
| MoUI Skia GPU | 56.94/59.91/57.67 | 58.59/62.36/58.75 | 44.16/42.67/43.30 | 45.52/44.85/43.78 | 11.37/15.59/11.00 | 11.76/19.13/11.42 | 0.06/0.27/2.46 | 0.07/0.29/2.49 |
| MoUI WGPU | 54.81/51.17/52.35 | 58.57/52.12/52.98 | 43.59/40.14/39.60 | 47.27/41.12/39.92 | 9.77/9.44/9.33 | 9.87/9.55/9.72 | 0.06/0.25/2.34 | 0.06/0.30/2.37 |
| MoUI 示例编辑器 Skia Raster | 66.03/103.21/478.49 | 66.61/104.01/494.38 | 47.86/53.83/116.32 | 48.86/54.22/118.15 | 12.97/13.21/12.97 | 13.71/13.83/13.52 | 0.06/0.29/2.37 | 0.07/0.32/2.40 |
| MoUI 示例编辑器 Skia GPU | 75.48/112.44/478.86 | 76.33/114.50/481.65 | 43.89/50.47/113.16 | 43.97/50.88/113.19 | 26.46/26.23/26.26 | 27.42/27.58/26.89 | 0.05/0.29/1.71 | 0.06/0.31/2.27 |
| MoUI 示例编辑器 WGPU | 53.61/91.90/456.66 | 53.74/92.34/457.75 | 36.21/43.89/106.09 | 36.53/44.37/106.59 | 12.28/12.59/12.51 | 12.44/12.68/12.62 | 0.04/0.26/2.32 | 0.05/0.27/2.38 |
| GPUI (md_mbt) | 111.61/111.63/121.63 | 113.57/115.31/126.16 | 16.97/16.56/16.34 | 17.05/16.79/16.37 | n/a/n/a/n/a | n/a/n/a/n/a | 0.00/0.00/2.67 | 0.00/0.00/3.00 |
| Flutter Skia | 29.33/29.26/31.79 | 29.57/29.34/31.88 | 0.20/0.20/0.21 | 0.21/0.21/0.23 | 9.60/9.47/9.62 | 9.66/9.54/9.90 | 0.06/0.08/0.29 | 0.06/0.09/0.32 |
| Flutter Impeller | 25.06/28.73/31.92 | 28.77/33.85/32.04 | 0.24/0.22/0.20 | 0.28/0.23/0.20 | 8.09/7.78/7.81 | 8.35/8.00/7.88 | 0.06/0.08/0.30 | 0.06/0.08/0.32 |
| Electron | 13.97/14.57/14.93 | 14.10/15.80/15.00 | 13.97/14.57/14.93 | 14.10/15.80/15.00 | n/a/n/a/n/a | n/a/n/a/n/a | 3.67/2.29/2.81 | 5.77/2.67/2.87 |

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 70.76 | 72.63 | 45.93 | 46.80 | 4.88 | 5.01 | 22.27 | 25.27 |
| MoUI Skia GPU | 73.76 | 74.42 | 43.25 | 43.73 | 10.98 | 11.06 | 24.71 | 25.90 |
| MoUI WGPU | 70.51 | 71.82 | 41.28 | 42.08 | 9.48 | 9.76 | 24.78 | 25.52 |
| MoUI 示例编辑器 Skia Raster | 4307.34 | 4351.07 | 768.67 | 779.96 | 13.11 | 13.41 | 25.71 | 25.84 |
| MoUI 示例编辑器 Skia GPU | 4201.97 | 4212.59 | 749.12 | 749.93 | 25.06 | 26.27 | 17.40 | 23.28 |
| MoUI 示例编辑器 WGPU | 4179.91 | 4185.80 | 740.37 | 742.28 | 12.13 | 12.24 | 21.21 | 24.76 |
| GPUI (md_mbt) | 121.16 | 127.05 | 16.64 | 16.90 | n/a | n/a | 25.00 | 26.00 |
| Flutter Skia | 57.62 | 58.69 | 0.25 | 0.33 | 10.12 | 10.60 | 2.42 | 2.44 |
| Flutter Impeller | 59.46 | 65.27 | 0.22 | 0.23 | 7.76 | 7.95 | 2.35 | 2.37 |
| Electron | 22.30 | 22.30 | 22.30 | 22.30 | n/a | n/a | 4.54 | 5.06 |

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.64/1.63/1.65 | 3.62/3.62/3.68 | 3.42/3.34/3.44 | 4.02/3.92/4.09 | 5.63/5.55/5.67 | 8.54/8.36/8.49 | n/a/n/a/n/a |
| MoUI Skia GPU | 1.65/1.64/1.72 | 3.64/3.54/3.73 | 6.14/6.15/6.20 | 7.72/7.78/7.79 | 8.40/8.39/8.56 | 9.28/9.28/9.47 | n/a/n/a/n/a |
| MoUI WGPU | 1.90/2.13/2.11 | 3.43/3.52/3.37 | 5.69/5.45/5.48 | 8.14/8.04/8.07 | 8.34/8.34/8.33 | 9.34/9.34/9.31 | n/a/n/a/n/a |
| MoUI 示例编辑器 Skia Raster | 1.31/5.18/42.93 | 1.55/5.81/47.37 | 2.30/2.44/2.54 | 2.72/2.84/2.94 | 3.76/7.97/47.75 | 4.41/9.03/52.53 | n/a/n/a/n/a |
| MoUI 示例编辑器 Skia GPU | 1.89/4.96/41.82 | 2.47/5.50/45.75 | 6.24/3.12/1.72 | 7.42/3.70/5.10 | 8.34/8.42/45.68 | 9.16/9.47/50.93 | n/a/n/a/n/a |
| MoUI 示例编辑器 WGPU | 1.62/5.48/42.25 | 1.90/5.98/45.98 | 6.51/2.64/2.04 | 7.88/3.56/2.41 | 8.31/8.49/46.76 | 9.42/9.85/50.57 | n/a/n/a/n/a |
| GPUI (md_mbt) | 17.50/17.52/17.59 | 20.11/20.10/20.16 | n/a/n/a/n/a | n/a/n/a/n/a | 20.63/21.03/25.07 | 23.64/24.03/27.89 | n/a/n/a/n/a |
| Flutter Skia | 3.67/3.62/3.51 | 4.77/6.57/6.54 | 0.84/0.46/0.45 | 1.18/0.73/0.64 | 16.67/16.67/16.57 | 16.67/16.67/16.67 | 72/107/111 |
| Flutter Impeller | 3.64/3.64/3.68 | 4.82/6.66/6.66 | 0.76/0.52/0.50 | 1.17/0.83/0.82 | 16.67/16.62/16.67 | 16.67/16.67/16.67 | 91/110/107 |
| Electron | 2.14/2.26/2.15 | 3.50/3.70/3.40 | n/a/n/a/n/a | n/a/n/a/n/a | 16.67/16.67/16.66 | 17.30/17.90/16.80 | 215/222/218 |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.68 | 3.76 | 3.46 | 4.14 | 5.74 | 8.94 | n/a |
| MoUI Skia GPU | 1.70 | 3.70 | 6.11 | 7.76 | 8.43 | 9.28 | n/a |
| MoUI WGPU | 2.10 | 3.43 | 5.49 | 8.01 | 8.33 | 9.27 | n/a |
| MoUI 示例编辑器 Skia Raster | 422.23 | 458.64 | 2.59 | 3.13 | 446.94 | 481.66 | n/a |
| MoUI 示例编辑器 Skia GPU | 421.16 | 457.75 | 1.91 | 4.58 | 444.56 | 480.05 | n/a |
| MoUI 示例编辑器 WGPU | 421.04 | 458.15 | 2.36 | 2.71 | 445.05 | 479.65 | n/a |
| GPUI (md_mbt) | 17.75 | 20.08 | n/a | n/a | 64.55 | 67.96 | n/a |
| Flutter Skia | 3.57 | 6.39 | 0.45 | 0.69 | 16.62 | 16.67 | 109 |
| Flutter Impeller | 3.65 | 6.43 | 0.50 | 0.73 | 16.67 | 16.67 | 115 |
| Electron | 2.51 | 4.10 | n/a | n/a | 16.57 | 17.90 | 212 |

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoUI 示例编辑器 Skia Raster medium 103.2 ms（max 104.0 ms）；MoUI 示例编辑器 Skia Raster large 478.5 ms（max 494.4 ms）；MoUI 示例编辑器 Skia Raster stress 4307.3 ms（max 4351.1 ms）；MoUI 示例编辑器 Skia GPU medium 112.4 ms（max 114.5 ms）；MoUI 示例编辑器 Skia GPU large 478.9 ms（max 481.6 ms）；MoUI 示例编辑器 Skia GPU stress 4202.0 ms（max 4212.6 ms）；MoUI 示例编辑器 WGPU large 456.7 ms（max 457.8 ms）；MoUI 示例编辑器 WGPU stress 4179.9 ms（max 4185.8 ms）；GPUI (md_mbt) small 111.6 ms（max 113.6 ms）；GPUI (md_mbt) medium 111.6 ms（max 115.3 ms）；GPUI (md_mbt) large 121.6 ms（max 126.2 ms）；GPUI (md_mbt) stress 121.2 ms（max 127.0 ms）。
- P1 输入尾延迟：MoUI 示例编辑器 Skia Raster small P95 28.67 ms；MoUI 示例编辑器 Skia Raster medium P95 197.76 ms；MoUI 示例编辑器 Skia Raster large P95 1816.36 ms；MoUI 示例编辑器 Skia Raster stress P95 19346.66 ms；MoUI 示例编辑器 Skia GPU small P95 28.10 ms；MoUI 示例编辑器 Skia GPU medium P95 184.34 ms；MoUI 示例编辑器 Skia GPU large P95 1707.40 ms；MoUI 示例编辑器 Skia GPU stress P95 17363.85 ms；MoUI 示例编辑器 WGPU small P95 21.16 ms；MoUI 示例编辑器 WGPU medium P95 173.32 ms；MoUI 示例编辑器 WGPU large P95 1713.11 ms；MoUI 示例编辑器 WGPU stress P95 17237.30 ms；GPUI (md_mbt) small P95 25.19 ms；GPUI (md_mbt) medium P95 25.68 ms；GPUI (md_mbt) large P95 32.91 ms；GPUI (md_mbt) stress P95 128.82 ms；Flutter Skia small P95 24.50 ms；Flutter Skia medium P95 21.79 ms；Flutter Skia large P95 23.03 ms；Flutter Skia stress P95 18.95 ms；Flutter Impeller small P95 20.64 ms；Flutter Impeller medium P95 20.52 ms；Flutter Impeller large P95 20.53 ms；Flutter Impeller stress P95 26.18 ms；Electron small P95 16.80 ms；Electron large P95 16.80 ms；Electron stress P95 16.80 ms。
- 长帧（超预算）：MoUI Skia Raster CPU: small/scroll 1 次，max 17.30 ms；MoUI Skia GPU: large/scroll 1 次，max 28.08 ms；MoUI 示例编辑器 Skia Raster: small/input 30 次，max 30.91 ms, medium/input 30 次，max 199.77 ms, medium/scroll 2 次，max 17.58 ms, large/input 30 次，max 1859.00 ms, large/scroll 360 次，max 75.78 ms, stress/input 30 次，max 23545.39 ms, stress/scroll 360 次，max 736.46 ms；MoUI 示例编辑器 Skia GPU: small/input 30 次，max 28.54 ms, medium/input 30 次，max 361.94 ms, large/input 30 次，max 1750.64 ms, large/scroll 360 次，max 77.51 ms, stress/input 30 次，max 17830.04 ms, stress/scroll 360 次，max 730.81 ms；MoUI 示例编辑器 WGPU: small/input 30 次，max 21.40 ms, medium/input 30 次，max 177.84 ms, large/input 30 次，max 1754.57 ms, large/scroll 360 次，max 76.08 ms, stress/input 30 次，max 17803.18 ms, stress/scroll 360 次，max 730.76 ms；GPUI (md_mbt): small/input 30 次，max 25.75 ms, small/scroll 360 次，max 33.15 ms, medium/input 30 次，max 26.04 ms, medium/scroll 360 次，max 32.81 ms, large/input 30 次，max 33.10 ms, large/scroll 360 次，max 33.94 ms, stress/input 30 次，max 131.29 ms, stress/scroll 360 次，max 69.10 ms；Electron: small/input 2 次，max 18.30 ms, small/scroll 49 次，max 18.60 ms, medium/scroll 49 次，max 18.60 ms, large/input 2 次，max 16.80 ms, large/scroll 39 次，max 18.50 ms, stress/input 1 次，max 16.80 ms, stress/scroll 51 次，max 18.60 ms。
- 丢帧（优先处理）：Flutter Skia: small/scroll 72 帧, medium/input 1 帧, medium/scroll 107 帧, large/input 1 帧, large/scroll 111 帧, stress/input 1 帧, stress/scroll 109 帧；Flutter Impeller: small/scroll 91 帧, medium/input 2 帧, medium/scroll 110 帧, large/scroll 107 帧, stress/input 3 帧, stress/scroll 115 帧；Electron: small/input 16 帧, small/scroll 215 帧, medium/input 17 帧, medium/scroll 222 帧, large/input 15 帧, large/scroll 218 帧, stress/input 18 帧, stress/scroll 212 帧。
- 解释：首帧异常优先检查窗口/渲染器初始化；输入尾延迟检查 action 到下一可见帧的调度与同步重建；长帧检查解析、布局、文本 shaping 和 GPU 提交；`n/a` 表示未埋点，不等于 0。
- 普通模式的长帧、帧间隔和输入延迟是各框架回调诊断，不能替代跨框架 compositor 排名；需要严格结论时运行 `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`。

## 采集口径

- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。
- `frame_work_ms` 统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏；对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `device_present_ms`：设备/上屏侧统一字段。MoUI raster 为 Skia CPU 光栅化+像素回读整体；MoUI GPU/wgpu 为提交后同步等待设备完成（headless host-surface 逐帧同步，真实应用的 vsync 流水线可重叠掉一部分，该值应视为上屏成本上界）；Flutter 为 `FrameTiming.rasterDuration`（光栅线程任务时间，含显示列表光栅化与 GPU 提交、不含设备完成等待）；GPUI 与 Electron 适配器侧无法观测，显示 `n/a`。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧；严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代；打开场景没有前一帧，所以不计算 interval/drop。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。
