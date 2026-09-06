# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-06T11:31:10Z`
- 数据状态：`360 measured`，`0 skipped/error`；原始样本保留在 JSON。
- Host：`macOS-26.3-arm64-arm-64bit` / `arm64` / `16.0 GiB`；GPU：`Apple M4`
- OS：`25.3.0`；CPU：`arm`；toolchains：`python=3.12.11, moon=moon 0.1.20260824 (dae026a 2026-08-24), rustc=rustc 1.94.0 (4a4ef493e 2026-03-02), cargo=cargo 1.94.0 (85eff7c80 2026-01-15), node=v25.2.1, npm=11.6.2, flutter=Flutter 3.47.1 • channel stable • https://github.com/flutter/flutter.git`
- 统一配置：`1280x800 @ 60 Hz`；font `system-ui 16px`；line-height `1.55`；overscan `3`；fixed row `66px`；GPU backend `Metal`
- Fixture：`small=5KB/100 blocks`，`medium=50KB/1,000 blocks`，`large=500KB/10,000 blocks`，`stress=5MB/100,000 blocks`。
- 本次执行集合：`small, medium, large, stress`；未执行集合在矩阵中显示 `n/a`，不参与比较。
- 汇总口径：mean/P95 合并原始样本；每格 repetition `3`、process warm-up `1`；drop 为各 repetition dropped_display_frames 之和。
- 公平性口径：所有 ui-frame 记录使用相同 fixture、viewport、动作数、warm-up 和重复次数。`工作`（frame_work）统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏：MoUI 为 build+layout+paint+draw，Flutter 为 UI 线程 buildDuration，GPUI 为 request_layout→prepaint→paint，Electron 为 JS 可见的 DOM 更新+layout。设备光栅化与上屏统一单列为 `设备侧`（device_present）：MoUI 为同步光栅化/present 完成（无头 harness 逐帧同步，无流水线重叠），Flutter 为光栅线程 rasterDuration（不含设备完成等待），GPUI 与 Electron 无法在适配器侧观测显示链路，显示 `n/a`。MoUI ui-frame 是 headless host-surface；GPUI 的 action dispatch 另列为诊断字段。不同框架的显示时间戳由各自平台 API 提供，帧间隔覆盖完整链路，报告不做跨时钟的综合排名。`n/a` 表示没有采集，绝不等同于 0。下方各对比表把同平台跨框架可比列（帧间隔/可见延迟/首次可交互/丢帧数等）排在前面，框架内部诊断列（`工作`/`设备侧`）排在后面并标注 `†`。

- `moui-md-*` 行来自 `momark`（MoMark，原 `vendor/MoUI/examples/markdown_editor`）官方示例应用：fixture 通过应用自身的 `OpenRecentDocument` 服务路径打开，渲染经过示例自己的虚拟滚动与富文本缓存实现，不套用简化基准应用的 `fixed row 66px` 统一行高；viewport、fixture、动作数、warm-up 与重复次数与其他行完全一致。严格模式（`UI_BENCHMARK_SYSTEM_TRACE=1`）目前不为 `moui-md-*` 行采集系统 present，这些行会显示 error。

<details><summary>原始 ui-frame 汇总（可审计）</summary>

| 实现 | 测试集合 | 场景 | 范围 | 工作均值/P95 | 仅分发均值/P95 | 帧间隔均值/P95 | 输入到可见均值/P95 | 设备侧均值 | 离屏均值 | 回读均值 | 首次可交互 | 丢帧数 | 状态 |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| moui-skia-raster | small | open | ui-frame | 53.481/55.047 | - | - | - | 4.97 ms | 0.00 ms | 4.97 ms | 59.71 ms | n/a | measured |
| moui-skia-raster | small | input | ui-frame | 0.567/0.706 | - | 1.754/2.280 | 1.754/2.279 | 1.01 ms | 0.00 ms | 1.01 ms | 61.92 ms | n/a | measured |
| moui-skia-raster | small | scroll | ui-frame | 0.571/0.715 | - | 1.470/1.787 | - | 0.70 ms | 0.00 ms | 0.70 ms | 57.90 ms | n/a | measured |
| moui-skia-raster | medium | open | ui-frame | 52.468/53.721 | - | - | - | 4.73 ms | 0.00 ms | 4.73 ms | 58.76 ms | n/a | measured |
| moui-skia-raster | medium | input | ui-frame | 0.539/0.579 | - | 1.664/1.957 | 1.664/1.957 | 0.95 ms | 0.00 ms | 0.95 ms | 59.71 ms | n/a | measured |
| moui-skia-raster | medium | scroll | ui-frame | 0.579/0.785 | - | 1.479/1.958 | - | 0.69 ms | 0.00 ms | 0.69 ms | 60.35 ms | n/a | measured |
| moui-skia-raster | large | open | ui-frame | 51.767/53.105 | - | - | - | 4.82 ms | 0.00 ms | 4.82 ms | 59.77 ms | n/a | measured |
| moui-skia-raster | large | input | ui-frame | 0.625/0.925 | - | 2.096/2.928 | 2.096/2.928 | 1.06 ms | 0.00 ms | 1.06 ms | 64.71 ms | n/a | measured |
| moui-skia-raster | large | scroll | ui-frame | 0.570/0.710 | - | 1.476/1.819 | - | 0.70 ms | 0.00 ms | 0.70 ms | 60.07 ms | n/a | measured |
| moui-skia-raster | stress | open | ui-frame | 52.765/54.351 | - | - | - | 4.46 ms | 0.00 ms | 4.46 ms | 76.89 ms | n/a | measured |
| moui-skia-raster | stress | input | ui-frame | 0.791/1.485 | - | 4.838/6.245 | 4.838/6.244 | 1.01 ms | 0.00 ms | 1.01 ms | 78.10 ms | n/a | measured |
| moui-skia-raster | stress | scroll | ui-frame | 0.588/0.748 | - | 1.496/1.953 | - | 0.70 ms | 0.00 ms | 0.70 ms | 79.94 ms | n/a | measured |
| moui-skia-gpu | small | open | ui-frame | 49.745/50.614 | - | - | - | 13.43 ms | n/a | 0.00 ms | 64.58 ms | n/a | measured |
| moui-skia-gpu | small | input | ui-frame | 0.715/0.918 | - | 8.330/9.284 | 8.329/9.283 | 7.35 ms | n/a | 0.00 ms | 67.67 ms | n/a | measured |
| moui-skia-gpu | small | scroll | ui-frame | 0.771/1.391 | - | 8.334/9.079 | - | 7.18 ms | n/a | 0.00 ms | 67.34 ms | n/a | measured |
| moui-skia-gpu | medium | open | ui-frame | 52.977/54.064 | - | - | - | 14.93 ms | n/a | 0.00 ms | 69.37 ms | n/a | measured |
| moui-skia-gpu | medium | input | ui-frame | 0.725/0.972 | - | 8.334/9.239 | 8.333/9.239 | 7.31 ms | n/a | 0.00 ms | 69.04 ms | n/a | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 0.783/1.497 | - | 8.333/9.065 | - | 7.16 ms | n/a | 0.00 ms | 65.17 ms | n/a | measured |
| moui-skia-gpu | large | open | ui-frame | 50.878/51.322 | - | - | - | 13.87 ms | n/a | 0.00 ms | 67.86 ms | n/a | measured |
| moui-skia-gpu | large | input | ui-frame | 0.699/0.857 | - | 8.306/9.200 | 8.305/9.198 | 7.11 ms | n/a | 0.00 ms | 68.31 ms | n/a | measured |
| moui-skia-gpu | large | scroll | ui-frame | 0.770/1.343 | - | 8.336/9.136 | - | 7.19 ms | n/a | 0.00 ms | 65.82 ms | n/a | measured |
| moui-skia-gpu | stress | open | ui-frame | 49.880/51.493 | - | - | - | 15.38 ms | n/a | 0.00 ms | 85.55 ms | n/a | measured |
| moui-skia-gpu | stress | input | ui-frame | 0.713/0.822 | - | 8.646/9.870 | 8.645/9.869 | 4.45 ms | n/a | 0.00 ms | 85.11 ms | n/a | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 0.737/1.276 | - | 8.335/9.148 | - | 7.24 ms | n/a | 0.00 ms | 86.37 ms | n/a | measured |
| moui-wgpu | small | open | ui-frame | 56.087/56.637 | - | - | - | 12.34 ms | n/a | 0.00 ms | 69.76 ms | n/a | measured |
| moui-wgpu | small | input | ui-frame | 0.652/0.798 | - | 8.254/9.265 | 8.254/9.264 | 7.33 ms | n/a | 0.00 ms | 70.90 ms | n/a | measured |
| moui-wgpu | small | scroll | ui-frame | 0.787/1.195 | - | 8.327/9.405 | - | 7.17 ms | n/a | 0.00 ms | 61.31 ms | n/a | measured |
| moui-wgpu | medium | open | ui-frame | 56.601/58.137 | - | - | - | 11.91 ms | n/a | 0.00 ms | 70.29 ms | n/a | measured |
| moui-wgpu | medium | input | ui-frame | 0.676/0.875 | - | 8.256/9.313 | 8.256/9.312 | 7.28 ms | n/a | 0.00 ms | 65.18 ms | n/a | measured |
| moui-wgpu | medium | scroll | ui-frame | 0.851/1.434 | - | 8.326/9.359 | - | 7.09 ms | n/a | 0.00 ms | 67.40 ms | n/a | measured |
| moui-wgpu | large | open | ui-frame | 54.546/55.026 | - | - | - | 11.21 ms | n/a | 0.00 ms | 68.97 ms | n/a | measured |
| moui-wgpu | large | input | ui-frame | 0.698/0.938 | - | 8.204/9.229 | 8.204/9.229 | 6.98 ms | n/a | 0.00 ms | 66.44 ms | n/a | measured |
| moui-wgpu | large | scroll | ui-frame | 0.878/1.563 | - | 8.342/9.452 | - | 7.06 ms | n/a | 0.00 ms | 65.57 ms | n/a | measured |
| moui-wgpu | stress | open | ui-frame | 58.311/60.211 | - | - | - | 11.80 ms | n/a | 0.00 ms | 90.15 ms | n/a | measured |
| moui-wgpu | stress | input | ui-frame | 0.727/0.970 | - | 8.302/9.228 | 8.301/9.228 | 4.08 ms | n/a | 0.00 ms | 90.72 ms | n/a | measured |
| moui-wgpu | stress | scroll | ui-frame | 0.780/1.139 | - | 8.329/9.312 | - | 7.19 ms | n/a | 0.00 ms | 89.31 ms | n/a | measured |
| moui-md-skia-raster | small | open | ui-frame | 52.313/54.367 | - | - | - | 13.12 ms | 0.00 ms | 13.12 ms | 67.31 ms | n/a | measured |
| moui-md-skia-raster | small | input | ui-frame | 3.629/4.051 | - | 6.951/7.557 | 6.925/7.557 | 2.95 ms | 0.00 ms | 2.95 ms | 72.37 ms | n/a | measured |
| moui-md-skia-raster | small | scroll | ui-frame | 1.010/1.268 | - | 3.658/4.569 | - | 2.46 ms | 0.00 ms | 2.46 ms | 99.87 ms | n/a | measured |
| moui-md-skia-raster | medium | open | ui-frame | 54.804/55.365 | - | - | - | 12.76 ms | 0.00 ms | 12.76 ms | 70.83 ms | n/a | measured |
| moui-md-skia-raster | medium | input | ui-frame | 3.489/4.050 | - | 6.832/7.582 | 6.803/7.424 | 2.86 ms | 0.00 ms | 2.86 ms | 70.88 ms | n/a | measured |
| moui-md-skia-raster | medium | scroll | ui-frame | 1.002/1.295 | - | 3.702/4.525 | - | 2.50 ms | 0.00 ms | 2.50 ms | 73.45 ms | n/a | measured |
| moui-md-skia-raster | large | open | ui-frame | 55.331/59.622 | - | - | - | 12.80 ms | 0.00 ms | 12.80 ms | 84.55 ms | n/a | measured |
| moui-md-skia-raster | large | input | ui-frame | 3.794/4.474 | - | 8.682/9.437 | 8.628/9.149 | 2.90 ms | 0.00 ms | 2.90 ms | 85.17 ms | n/a | measured |
| moui-md-skia-raster | large | scroll | ui-frame | 1.007/1.243 | - | 3.694/4.509 | - | 2.49 ms | 0.00 ms | 2.49 ms | 85.07 ms | n/a | measured |
| moui-md-skia-raster | stress | open | ui-frame | 54.703/55.242 | - | - | - | 12.77 ms | 0.00 ms | 12.77 ms | 243.36 ms | n/a | measured |
| moui-md-skia-raster | stress | input | ui-frame | 4.335/4.859 | - | 26.518/28.222 | 26.206/27.775 | 3.41 ms | 0.00 ms | 3.41 ms | 230.23 ms | n/a | measured |
| moui-md-skia-raster | stress | scroll | ui-frame | 1.013/1.264 | - | 3.710/4.528 | - | 2.48 ms | 0.00 ms | 2.48 ms | 223.37 ms | n/a | measured |
| moui-md-skia-gpu | small | open | ui-frame | 52.679/52.806 | - | - | - | 41.37 ms | n/a | 0.00 ms | 95.86 ms | n/a | measured |
| moui-md-skia-gpu | small | input | ui-frame | 3.767/4.159 | - | 9.766/10.688 | 9.739/10.686 | 5.61 ms | n/a | 0.00 ms | 93.90 ms | n/a | measured |
| moui-md-skia-gpu | small | scroll | ui-frame | 1.142/1.557 | - | 8.339/9.132 | - | 6.92 ms | n/a | 0.00 ms | 96.88 ms | n/a | measured |
| moui-md-skia-gpu | medium | open | ui-frame | 61.548/81.526 | - | - | - | 35.40 ms | n/a | 0.00 ms | 101.37 ms | n/a | measured |
| moui-md-skia-gpu | medium | input | ui-frame | 3.664/3.978 | - | 9.522/10.876 | 9.489/10.874 | 5.24 ms | n/a | 0.00 ms | 99.19 ms | n/a | measured |
| moui-md-skia-gpu | medium | scroll | ui-frame | 1.172/1.731 | - | 8.340/9.184 | - | 6.90 ms | n/a | 0.00 ms | 91.37 ms | n/a | measured |
| moui-md-skia-gpu | large | open | ui-frame | 53.888/54.418 | - | - | - | 47.21 ms | n/a | 0.00 ms | 118.26 ms | n/a | measured |
| moui-md-skia-gpu | large | input | ui-frame | 3.683/3.952 | - | 9.768/10.601 | 9.714/10.601 | 4.06 ms | n/a | 0.00 ms | 121.92 ms | n/a | measured |
| moui-md-skia-gpu | large | scroll | ui-frame | 1.209/1.717 | - | 8.425/9.224 | - | 6.93 ms | n/a | 0.00 ms | 117.01 ms | n/a | measured |
| moui-md-skia-gpu | stress | open | ui-frame | 53.015/54.350 | - | - | - | 42.74 ms | n/a | 0.00 ms | 253.39 ms | n/a | measured |
| moui-md-skia-gpu | stress | input | ui-frame | 4.166/4.599 | - | 25.474/29.295 | 25.174/28.466 | 2.75 ms | n/a | 0.00 ms | 248.55 ms | n/a | measured |
| moui-md-skia-gpu | stress | scroll | ui-frame | 1.150/1.654 | - | 8.339/9.257 | - | 6.89 ms | n/a | 0.00 ms | 244.17 ms | n/a | measured |
| moui-md-wgpu | small | open | ui-frame | 55.812/56.249 | - | - | - | 16.43 ms | n/a | 0.00 ms | 74.15 ms | n/a | measured |
| moui-md-wgpu | small | input | ui-frame | 1.721/2.024 | - | 10.866/24.903 | 10.837/24.903 | 8.66 ms | n/a | 0.00 ms | 75.46 ms | n/a | measured |
| moui-md-wgpu | small | scroll | ui-frame | 1.392/1.764 | - | 12.354/28.129 | - | 10.63 ms | n/a | 0.00 ms | 74.76 ms | n/a | measured |
| moui-md-wgpu | medium | open | ui-frame | 50.580/55.029 | - | - | - | 16.03 ms | n/a | 0.00 ms | 69.81 ms | n/a | measured |
| moui-md-wgpu | medium | input | ui-frame | 1.704/2.233 | - | 10.430/26.484 | 10.396/26.484 | 8.17 ms | n/a | 0.00 ms | 76.68 ms | n/a | measured |
| moui-md-wgpu | medium | scroll | ui-frame | 1.418/1.842 | - | 12.100/28.026 | - | 10.36 ms | n/a | 0.00 ms | 79.66 ms | n/a | measured |
| moui-md-wgpu | large | open | ui-frame | 50.197/54.713 | - | - | - | 15.69 ms | n/a | 0.00 ms | 82.31 ms | n/a | measured |
| moui-md-wgpu | large | input | ui-frame | 1.749/2.022 | - | 10.524/26.858 | 10.466/26.857 | 6.52 ms | n/a | 0.00 ms | 84.46 ms | n/a | measured |
| moui-md-wgpu | large | scroll | ui-frame | 1.390/1.702 | - | 11.589/26.976 | - | 9.88 ms | n/a | 0.00 ms | 82.60 ms | n/a | measured |
| moui-md-wgpu | stress | open | ui-frame | 59.193/60.901 | - | - | - | 16.26 ms | n/a | 0.00 ms | 230.12 ms | n/a | measured |
| moui-md-wgpu | stress | input | ui-frame | 1.696/2.095 | - | 23.606/27.704 | 23.286/25.717 | 2.85 ms | n/a | 0.00 ms | 233.43 ms | n/a | measured |
| moui-md-wgpu | stress | scroll | ui-frame | 1.400/1.784 | - | 11.722/27.198 | - | 9.96 ms | n/a | 0.00 ms | 220.71 ms | n/a | measured |
| gpmark | small | open | ui-frame | 6.022/6.333 | - | - | - | n/a | n/a | n/a | 174.95 ms | n/a | measured |
| gpmark | small | input | ui-frame | 5.616/5.902 | 0.346/0.460 | 10.529/22.486 | 10.526/22.485 | n/a | n/a | n/a | 171.30 ms | n/a | measured |
| gpmark | small | scroll | ui-frame | 6.710/8.057 | 0.004/0.008 | 10.218/12.751 | - | n/a | n/a | n/a | 167.45 ms | n/a | measured |
| gpmark | medium | open | ui-frame | 5.896/6.111 | - | - | - | n/a | n/a | n/a | 172.85 ms | n/a | measured |
| gpmark | medium | input | ui-frame | 5.659/6.177 | 0.385/0.469 | 11.012/23.631 | 11.008/23.630 | n/a | n/a | n/a | 167.28 ms | n/a | measured |
| gpmark | medium | scroll | ui-frame | 6.579/8.003 | 0.004/0.008 | 10.150/11.245 | - | n/a | n/a | n/a | 148.31 ms | n/a | measured |
| gpmark | large | open | ui-frame | 5.663/5.861 | - | - | - | n/a | n/a | n/a | 161.45 ms | n/a | measured |
| gpmark | large | input | ui-frame | 5.686/6.233 | 0.883/1.413 | 11.219/23.372 | 11.215/23.370 | n/a | n/a | n/a | 163.90 ms | n/a | measured |
| gpmark | large | scroll | ui-frame | 6.626/8.061 | 0.004/0.009 | 10.153/12.836 | - | n/a | n/a | n/a | 152.65 ms | n/a | measured |
| gpmark | stress | open | ui-frame | 5.738/5.830 | - | - | - | n/a | n/a | n/a | 165.02 ms | n/a | measured |
| gpmark | stress | input | ui-frame | 5.766/6.266 | 5.745/6.897 | 14.757/29.577 | 14.754/29.571 | n/a | n/a | n/a | 167.41 ms | n/a | measured |
| gpmark | stress | scroll | ui-frame | 6.612/8.161 | 0.004/0.008 | 10.122/11.610 | - | n/a | n/a | n/a | 173.34 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 0.479/0.631 | - | - | - | 11.41 ms | n/a | n/a | 98.16 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 0.619/0.921 | - | 10.000/20.001 | 11.026/20.019 | 0.78 ms | n/a | n/a | 84.19 ms | 3 | measured |
| flutter-skia | small | scroll | ui-frame | 1.228/1.571 | - | 10.000/10.002 | - | 0.40 ms | n/a | n/a | 85.87 ms | 0 | measured |
| flutter-skia | medium | open | ui-frame | 0.452/0.538 | - | - | - | 10.81 ms | n/a | n/a | 90.39 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 0.626/0.892 | - | 10.667/20.004 | 10.647/18.611 | 0.76 ms | n/a | n/a | 82.69 ms | 4 | measured |
| flutter-skia | medium | scroll | ui-frame | 1.690/2.463 | - | 10.000/10.002 | - | 0.39 ms | n/a | n/a | 85.17 ms | 0 | measured |
| flutter-skia | large | open | ui-frame | 0.476/0.540 | - | - | - | 10.57 ms | n/a | n/a | 84.47 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 0.664/1.074 | - | 10.667/20.002 | 11.356/22.870 | 0.75 ms | n/a | n/a | 84.79 ms | 4 | measured |
| flutter-skia | large | scroll | ui-frame | 1.726/2.499 | - | 10.000/10.003 | - | 0.41 ms | n/a | n/a | 84.11 ms | 1 | measured |
| flutter-skia | stress | open | ui-frame | 0.398/0.485 | - | - | - | 10.33 ms | n/a | n/a | 118.21 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 0.619/0.868 | - | 11.001/20.003 | 9.467/10.531 | 0.78 ms | n/a | n/a | 113.62 ms | 5 | measured |
| flutter-skia | stress | scroll | ui-frame | 1.792/2.565 | - | 10.028/10.003 | - | 0.44 ms | n/a | n/a | 112.96 ms | 3 | measured |
| flutter-impeller | small | open | ui-frame | 0.453/0.554 | - | - | - | 8.14 ms | n/a | n/a | 85.96 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 0.684/0.890 | - | 12.000/20.000 | 10.959/18.817 | 0.67 ms | n/a | n/a | 87.35 ms | 5 | measured |
| flutter-impeller | small | scroll | ui-frame | 1.372/2.491 | - | 10.000/10.003 | - | 0.40 ms | n/a | n/a | 91.87 ms | 0 | measured |
| flutter-impeller | medium | open | ui-frame | 0.445/0.652 | - | - | - | 8.61 ms | n/a | n/a | 87.37 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 0.700/0.949 | - | 12.000/30.000 | 11.062/21.851 | 0.74 ms | n/a | n/a | 99.45 ms | 5 | measured |
| flutter-impeller | medium | scroll | ui-frame | 1.764/2.551 | - | 10.000/10.002 | - | 0.40 ms | n/a | n/a | 85.26 ms | 0 | measured |
| flutter-impeller | large | open | ui-frame | 0.593/0.601 | - | - | - | 8.01 ms | n/a | n/a | 86.71 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 0.674/0.927 | - | 11.667/30.000 | 11.699/27.464 | 0.68 ms | n/a | n/a | 85.92 ms | 4 | measured |
| flutter-impeller | large | scroll | ui-frame | 1.751/2.514 | - | 10.000/10.002 | - | 0.39 ms | n/a | n/a | 82.68 ms | 1 | measured |
| flutter-impeller | stress | open | ui-frame | 0.442/0.503 | - | - | - | 7.93 ms | n/a | n/a | 110.28 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 0.753/1.627 | - | 11.001/20.004 | 9.633/10.570 | 0.90 ms | n/a | n/a | 119.07 ms | 5 | measured |
| flutter-impeller | stress | scroll | ui-frame | 1.727/2.504 | - | 10.028/10.003 | - | 0.39 ms | n/a | n/a | 117.90 ms | 1 | measured |
| electron | small | open | ui-frame | 110.833/115.600 | - | - | - | n/a | n/a | n/a | 110.83 ms | 0 | measured |
| electron | small | input | ui-frame | 2.743/4.400 | - | 9.715/12.100 | 8.683/11.000 | n/a | n/a | n/a | 108.33 ms | 1 | measured |
| electron | small | scroll | ui-frame | 2.107/2.900 | - | 9.954/10.100 | - | n/a | n/a | n/a | 107.80 ms | 0 | measured |
| electron | medium | open | ui-frame | 92.867/98.200 | - | - | - | n/a | n/a | n/a | 92.87 ms | 0 | measured |
| electron | medium | input | ui-frame | 2.420/4.400 | - | 9.226/11.700 | 8.560/11.700 | n/a | n/a | n/a | 105.00 ms | 0 | measured |
| electron | medium | scroll | ui-frame | 2.190/3.100 | - | 10.001/10.400 | - | n/a | n/a | n/a | 98.57 ms | 1 | measured |
| electron | large | open | ui-frame | 96.500/101.300 | - | - | - | n/a | n/a | n/a | 96.50 ms | 0 | measured |
| electron | large | input | ui-frame | 2.167/3.100 | - | 9.670/11.600 | 8.677/11.600 | n/a | n/a | n/a | 98.17 ms | 0 | measured |
| electron | large | scroll | ui-frame | 2.188/3.000 | - | 9.973/11.800 | - | n/a | n/a | n/a | 113.13 ms | 1 | measured |
| electron | stress | open | ui-frame | 109.367/122.300 | - | - | - | n/a | n/a | n/a | 109.37 ms | 0 | measured |
| electron | stress | input | ui-frame | 2.270/2.900 | - | 9.111/10.900 | 8.650/11.200 | n/a | n/a | n/a | 108.73 ms | 0 | measured |
| electron | stress | scroll | ui-frame | 2.237/3.100 | - | 10.009/11.900 | - | n/a | n/a | n/a | 122.13 ms | 2 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.47/1.48/1.48 | 1.79/1.96/1.82 | n/a/n/a/n/a | 0.57/0.58/0.57 | 0.72/0.79/0.71 | 0.70/0.69/0.70 | 0.99/1.05/0.98 |
| MoUI Skia GPU | 8.33/8.33/8.34 | 9.08/9.07/9.14 | n/a/n/a/n/a | 0.77/0.78/0.77 | 1.39/1.50/1.34 | 7.18/7.16/7.19 | 8.01/8.00/8.02 |
| MoUI WGPU | 8.33/8.33/8.34 | 9.41/9.36/9.45 | n/a/n/a/n/a | 0.79/0.85/0.88 | 1.19/1.43/1.56 | 7.17/7.09/7.06 | 8.42/8.38/8.41 |
| MoMark Skia Raster | 3.66/3.70/3.69 | 4.57/4.52/4.51 | n/a/n/a/n/a | 1.01/1.00/1.01 | 1.27/1.29/1.24 | 2.46/2.50/2.49 | 3.18/3.22/3.18 |
| MoMark Skia GPU | 8.34/8.34/8.43 | 9.13/9.18/9.22 | n/a/n/a/n/a | 1.14/1.17/1.21 | 1.56/1.73/1.72 | 6.92/6.90/6.93 | 7.83/7.78/7.89 |
| MoMark WGPU | 12.35/12.10/11.59 | 28.13/28.03/26.98 | n/a/n/a/n/a | 1.39/1.42/1.39 | 1.76/1.84/1.70 | 10.63/10.36/9.88 | 26.37/26.26/25.44 |
| GpMark.mbt (GPUI) | 10.22/10.15/10.15 | 12.75/11.25/12.84 | n/a/n/a/n/a | 6.71/6.58/6.63 | 8.06/8.00/8.06 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 10.00/10.00/10.00 | 10.00/10.00/10.00 | 0/0/1 | 1.23/1.69/1.73 | 1.57/2.46/2.50 | 0.40/0.39/0.41 | 0.52/0.53/0.55 |
| Flutter Impeller | 10.00/10.00/10.00 | 10.00/10.00/10.00 | 0/0/1 | 1.37/1.76/1.75 | 2.49/2.55/2.51 | 0.40/0.40/0.39 | 0.68/0.57/0.53 |
| Electron | 9.95/10.00/9.97 | 10.10/10.40/11.80 | 0/1/1 | 2.11/2.19/2.19 | 2.90/3.10/3.00 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.50 | 1.95 | n/a | 0.59 | 0.75 | 0.70 | 1.06 |
| MoUI Skia GPU | 8.34 | 9.15 | n/a | 0.74 | 1.28 | 7.24 | 8.02 |
| MoUI WGPU | 8.33 | 9.31 | n/a | 0.78 | 1.14 | 7.19 | 8.42 |
| MoMark Skia Raster | 3.71 | 4.53 | n/a | 1.01 | 1.26 | 2.48 | 3.13 |
| MoMark Skia GPU | 8.34 | 9.26 | n/a | 1.15 | 1.65 | 6.89 | 8.04 |
| MoMark WGPU | 11.72 | 27.20 | n/a | 1.40 | 1.78 | 9.96 | 25.48 |
| GpMark.mbt (GPUI) | 10.12 | 11.61 | n/a | 6.61 | 8.16 | n/a | n/a |
| Flutter Skia | 10.03 | 10.00 | 3 | 1.79 | 2.56 | 0.44 | 0.67 |
| Flutter Impeller | 10.03 | 10.00 | 1 | 1.73 | 2.50 | 0.39 | 0.52 |
| Electron | 10.01 | 11.90 | 2 | 2.24 | 3.10 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.75/1.66/2.10 | 2.28/1.96/2.93 | 0.57/0.54/0.63 | 0.71/0.58/0.93 | 1.01/0.95/1.06 | 1.46/1.25/1.42 |
| MoUI Skia GPU | 8.33/8.33/8.30 | 9.28/9.24/9.20 | 0.72/0.72/0.70 | 0.92/0.97/0.86 | 7.35/7.31/7.11 | 8.24/8.34/8.14 |
| MoUI WGPU | 8.25/8.26/8.20 | 9.26/9.31/9.23 | 0.65/0.68/0.70 | 0.80/0.88/0.94 | 7.33/7.28/6.98 | 8.46/8.35/8.15 |
| MoMark Skia Raster | 6.93/6.80/8.63 | 7.56/7.42/9.15 | 3.63/3.49/3.79 | 4.05/4.05/4.47 | 2.95/2.86/2.90 | 3.64/3.44/3.46 |
| MoMark Skia GPU | 9.74/9.49/9.71 | 10.69/10.87/10.60 | 3.77/3.66/3.68 | 4.16/3.98/3.95 | 5.61/5.24/4.06 | 6.69/6.42/5.02 |
| MoMark WGPU | 10.84/10.40/10.47 | 24.90/26.48/26.86 | 1.72/1.70/1.75 | 2.02/2.23/2.02 | 8.66/8.17/6.52 | 22.99/24.12/23.29 |
| GpMark.mbt (GPUI) | 10.53/11.01/11.22 | 22.49/23.63/23.37 | 5.62/5.66/5.69 | 5.90/6.18/6.23 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 11.03/10.65/11.36 | 20.02/18.61/22.87 | 0.62/0.63/0.66 | 0.92/0.89/1.07 | 0.78/0.76/0.75 | 1.79/1.49/1.63 |
| Flutter Impeller | 10.96/11.06/11.70 | 18.82/21.85/27.46 | 0.68/0.70/0.67 | 0.89/0.95/0.93 | 0.67/0.74/0.68 | 1.39/1.29/1.92 |
| Electron | 8.68/8.56/8.68 | 11.00/11.70/11.60 | 2.74/2.42/2.17 | 4.40/4.40/3.10 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 4.84 | 6.24 | 0.79 | 1.48 | 1.01 | 1.45 |
| MoUI Skia GPU | 8.65 | 9.87 | 0.71 | 0.82 | 4.45 | 5.81 |
| MoUI WGPU | 8.30 | 9.23 | 0.73 | 0.97 | 4.08 | 6.04 |
| MoMark Skia Raster | 26.21 | 27.77 | 4.34 | 4.86 | 3.41 | 4.15 |
| MoMark Skia GPU | 25.17 | 28.47 | 4.17 | 4.60 | 2.75 | 5.92 |
| MoMark WGPU | 23.29 | 25.72 | 1.70 | 2.09 | 2.85 | 4.11 |
| GpMark.mbt (GPUI) | 14.75 | 29.57 | 5.77 | 6.27 | n/a | n/a |
| Flutter Skia | 9.47 | 10.53 | 0.62 | 0.87 | 0.78 | 1.69 |
| Flutter Impeller | 9.63 | 10.57 | 0.75 | 1.63 | 0.90 | 2.00 |
| Electron | 8.65 | 11.20 | 2.27 | 2.90 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 59.71/58.76/59.77 | 61.59/60.51/61.59 | 0.07/0.37/2.72 | 0.08/0.44/2.94 | 53.48/52.47/51.77 | 55.05/53.72/53.11 | 4.97/4.73/4.82 | 5.29/5.06/5.14 |
| MoUI Skia GPU | 64.58/69.37/67.86 | 66.99/73.04/69.03 | 0.09/0.34/2.21 | 0.12/0.41/2.51 | 49.75/52.98/50.88 | 50.61/54.06/51.32 | 13.43/14.93/13.87 | 15.08/17.40/14.58 |
| MoUI WGPU | 69.76/70.29/68.97 | 70.44/71.56/69.71 | 0.08/0.36/2.62 | 0.10/0.39/2.76 | 56.09/56.60/54.55 | 56.64/58.14/55.03 | 12.34/11.91/11.21 | 12.46/12.29/11.40 |
| MoMark Skia Raster | 67.31/70.83/84.55 | 70.88/71.63/89.88 | 0.07/0.33/2.31 | 0.10/0.40/2.78 | 52.31/54.80/55.33 | 54.37/55.37/59.62 | 13.12/12.76/12.80 | 14.61/12.90/13.90 |
| MoMark Skia GPU | 95.86/101.37/118.26 | 99.22/133.50/126.27 | 0.07/0.35/2.48 | 0.07/0.44/2.54 | 52.68/61.55/53.89 | 52.81/81.53/54.42 | 41.37/35.40/47.21 | 44.77/44.91/54.57 |
| MoMark WGPU | 74.15/69.81/82.31 | 75.10/75.54/86.87 | 0.10/0.35/2.28 | 0.12/0.40/2.80 | 55.81/50.58/50.20 | 56.25/55.03/54.71 | 16.43/16.03/15.69 | 16.82/17.20/16.06 |
| GpMark.mbt (GPUI) | 174.95/172.85/161.45 | 183.07/176.93/181.87 | 0.00/0.33/2.67 | 0.00/1.00/3.00 | 6.02/5.90/5.66 | 6.33/6.11/5.86 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 98.16/90.39/84.47 | 125.36/99.90/89.25 | 0.21/0.18/0.45 | 0.42/0.25/0.56 | 0.48/0.45/0.48 | 0.63/0.54/0.54 | 11.41/10.81/10.57 | 12.81/11.94/11.07 |
| Flutter Impeller | 85.96/87.37/86.71 | 87.89/92.93/87.49 | 0.12/0.15/0.52 | 0.14/0.18/0.61 | 0.45/0.45/0.59 | 0.55/0.65/0.60 | 8.14/8.61/8.01 | 8.34/9.48/8.58 |
| Electron | 110.83/92.87/96.50 | 115.60/98.20/101.30 | 11.92/7.59/5.66 | 12.85/9.86/9.89 | 110.83/92.87/96.50 | 115.60/98.20/101.30 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 76.89 | 78.86 | 24.26 | 26.22 | 52.77 | 54.35 | 4.46 | 4.96 |
| MoUI Skia GPU | 85.55 | 87.60 | 23.90 | 27.48 | 49.88 | 51.49 | 15.38 | 16.85 |
| MoUI WGPU | 90.15 | 92.25 | 25.17 | 27.55 | 58.31 | 60.21 | 11.80 | 12.21 |
| MoMark Skia Raster | 243.36 | 285.12 | 25.31 | 28.30 | 54.70 | 55.24 | 12.77 | 13.37 |
| MoMark Skia GPU | 253.39 | 258.67 | 25.85 | 27.28 | 53.01 | 54.35 | 42.74 | 44.80 |
| MoMark WGPU | 230.12 | 236.75 | 24.30 | 28.53 | 59.19 | 60.90 | 16.26 | 16.36 |
| GpMark.mbt (GPUI) | 165.02 | 170.30 | 28.67 | 30.00 | 5.74 | 5.83 | n/a | n/a |
| Flutter Skia | 118.21 | 118.33 | 3.58 | 3.79 | 0.40 | 0.48 | 10.33 | 10.73 |
| Flutter Impeller | 110.28 | 118.55 | 3.91 | 4.56 | 0.44 | 0.50 | 7.93 | 8.29 |
| Electron | 109.37 | 122.30 | 11.44 | 14.10 | 109.37 | 122.30 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.47/1.48/1.48 | 1.79/1.96/1.82 | n/a/n/a/n/a | 0.57/0.58/0.57 | 0.72/0.79/0.71 | 0.70/0.69/0.70 | 0.99/1.05/0.98 |
| MoUI Skia GPU | 8.33/8.33/8.34 | 9.08/9.07/9.14 | n/a/n/a/n/a | 0.77/0.78/0.77 | 1.39/1.50/1.34 | 7.18/7.16/7.19 | 8.01/8.00/8.02 |
| MoUI WGPU | 8.33/8.33/8.34 | 9.41/9.36/9.45 | n/a/n/a/n/a | 0.79/0.85/0.88 | 1.19/1.43/1.56 | 7.17/7.09/7.06 | 8.42/8.38/8.41 |
| MoMark Skia Raster | 3.66/3.70/3.69 | 4.57/4.52/4.51 | n/a/n/a/n/a | 1.01/1.00/1.01 | 1.27/1.29/1.24 | 2.46/2.50/2.49 | 3.18/3.22/3.18 |
| MoMark Skia GPU | 8.34/8.34/8.43 | 9.13/9.18/9.22 | n/a/n/a/n/a | 1.14/1.17/1.21 | 1.56/1.73/1.72 | 6.92/6.90/6.93 | 7.83/7.78/7.89 |
| MoMark WGPU | 12.35/12.10/11.59 | 28.13/28.03/26.98 | n/a/n/a/n/a | 1.39/1.42/1.39 | 1.76/1.84/1.70 | 10.63/10.36/9.88 | 26.37/26.26/25.44 |
| GpMark.mbt (GPUI) | 10.22/10.15/10.15 | 12.75/11.25/12.84 | n/a/n/a/n/a | 6.71/6.58/6.63 | 8.06/8.00/8.06 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 10.00/10.00/10.00 | 10.00/10.00/10.00 | 0/0/1 | 1.23/1.69/1.73 | 1.57/2.46/2.50 | 0.40/0.39/0.41 | 0.52/0.53/0.55 |
| Flutter Impeller | 10.00/10.00/10.00 | 10.00/10.00/10.00 | 0/0/1 | 1.37/1.76/1.75 | 2.49/2.55/2.51 | 0.40/0.40/0.39 | 0.68/0.57/0.53 |
| Electron | 9.95/10.00/9.97 | 10.10/10.40/11.80 | 0/1/1 | 2.11/2.19/2.19 | 2.90/3.10/3.00 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.50 | 1.95 | n/a | 0.59 | 0.75 | 0.70 | 1.06 |
| MoUI Skia GPU | 8.34 | 9.15 | n/a | 0.74 | 1.28 | 7.24 | 8.02 |
| MoUI WGPU | 8.33 | 9.31 | n/a | 0.78 | 1.14 | 7.19 | 8.42 |
| MoMark Skia Raster | 3.71 | 4.53 | n/a | 1.01 | 1.26 | 2.48 | 3.13 |
| MoMark Skia GPU | 8.34 | 9.26 | n/a | 1.15 | 1.65 | 6.89 | 8.04 |
| MoMark WGPU | 11.72 | 27.20 | n/a | 1.40 | 1.78 | 9.96 | 25.48 |
| GpMark.mbt (GPUI) | 10.12 | 11.61 | n/a | 6.61 | 8.16 | n/a | n/a |
| Flutter Skia | 10.03 | 10.00 | 3 | 1.79 | 2.56 | 0.44 | 0.67 |
| Flutter Impeller | 10.03 | 10.00 | 1 | 1.73 | 2.50 | 0.39 | 0.52 |
| Electron | 10.01 | 11.90 | 2 | 2.24 | 3.10 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoMark Skia Raster stress 243.4 ms（max 285.1 ms）；MoMark Skia GPU medium 101.4 ms（max 133.5 ms）；MoMark Skia GPU large 118.3 ms（max 126.3 ms）；MoMark Skia GPU stress 253.4 ms（max 258.7 ms）；MoMark WGPU stress 230.1 ms（max 236.7 ms）；GpMark.mbt (GPUI) small 175.0 ms（max 183.1 ms）；GpMark.mbt (GPUI) medium 172.8 ms（max 176.9 ms）；GpMark.mbt (GPUI) large 161.5 ms（max 181.9 ms）；GpMark.mbt (GPUI) stress 165.0 ms（max 170.3 ms）；Flutter Skia small 98.2 ms（max 125.4 ms）；Flutter Skia stress 118.2 ms（max 118.3 ms）；Flutter Impeller stress 110.3 ms（max 118.5 ms）；Electron small 110.8 ms（max 115.6 ms）；Electron large 96.5 ms（max 101.3 ms）；Electron stress 109.4 ms（max 122.3 ms）。
- P1 输入尾延迟：MoMark Skia Raster stress P95 27.77 ms；MoMark Skia GPU stress P95 28.47 ms；MoMark WGPU small P95 24.90 ms；MoMark WGPU medium P95 26.48 ms；MoMark WGPU large P95 26.86 ms；MoMark WGPU stress P95 25.72 ms；GpMark.mbt (GPUI) small P95 22.49 ms；GpMark.mbt (GPUI) medium P95 23.63 ms；GpMark.mbt (GPUI) large P95 23.37 ms；GpMark.mbt (GPUI) stress P95 29.57 ms；Flutter Skia small P95 20.02 ms；Flutter Skia medium P95 18.61 ms；Flutter Skia large P95 22.87 ms；Flutter Impeller small P95 18.82 ms；Flutter Impeller medium P95 21.85 ms；Flutter Impeller large P95 27.46 ms。
- 长帧（超预算）：MoMark Skia Raster: stress/input 30 次，max 29.38 ms；MoMark Skia GPU: large/scroll 2 次，max 19.61 ms, stress/input 30 次，max 29.38 ms；MoMark WGPU: small/input 5 次，max 26.00 ms, small/scroll 86 次，max 30.36 ms, medium/input 4 次，max 26.56 ms, medium/scroll 81 次，max 30.52 ms, large/input 3 次，max 27.83 ms, large/scroll 70 次，max 29.21 ms, stress/input 30 次，max 27.78 ms, stress/scroll 72 次，max 30.05 ms；GpMark.mbt (GPUI): small/input 3 次，max 22.64 ms, small/scroll 5 次，max 36.54 ms, medium/input 3 次，max 29.94 ms, medium/scroll 4 次，max 23.64 ms, large/input 3 次，max 31.10 ms, large/scroll 5 次，max 23.10 ms, stress/input 6 次，max 30.20 ms, stress/scroll 4 次，max 24.67 ms；Flutter Skia: small/input 3 次，max 20.00 ms, medium/input 4 次，max 20.01 ms, large/input 4 次，max 20.00 ms, large/scroll 1 次，max 20.00 ms, stress/input 5 次，max 20.01 ms, stress/scroll 3 次，max 20.00 ms；Flutter Impeller: small/input 5 次，max 30.00 ms, medium/input 5 次，max 30.00 ms, large/input 4 次，max 30.00 ms, large/scroll 1 次，max 20.00 ms, stress/input 5 次，max 20.01 ms, stress/scroll 1 次，max 20.00 ms；Electron: medium/scroll 1 次，max 20.00 ms, large/scroll 1 次，max 20.00 ms, stress/scroll 2 次，max 20.00 ms。
- 丢帧（优先处理）：Flutter Skia: small/input 3 帧, medium/input 4 帧, large/input 4 帧, large/scroll 1 帧, stress/input 5 帧, stress/scroll 3 帧；Flutter Impeller: small/input 5 帧, medium/input 5 帧, large/input 4 帧, large/scroll 1 帧, stress/input 5 帧, stress/scroll 1 帧；Electron: small/input 1 帧, medium/scroll 1 帧, large/scroll 1 帧, stress/scroll 2 帧。
- 解释：首帧异常优先检查窗口/渲染器初始化；输入尾延迟检查 action 到下一可见帧的调度与同步重建；长帧检查解析、布局、文本 shaping 和 GPU 提交；`n/a` 表示未埋点，不等于 0。
- 普通模式的长帧、帧间隔和输入延迟是各框架回调诊断，不能替代跨框架 compositor 排名；需要严格结论时运行 `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`。

## 采集口径

- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。
- `frame_work_ms` 统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏；对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `device_present_ms`：设备/上屏侧统一字段。MoUI raster 为 Skia CPU 光栅化+像素回读整体；MoUI GPU/wgpu 为提交后同步等待设备完成（headless host-surface 逐帧同步，真实应用的 vsync 流水线可重叠掉一部分，该值应视为上屏成本上界）；Flutter 为 `FrameTiming.rasterDuration`（光栅线程任务时间，含显示列表光栅化与 GPU 提交、不含设备完成等待）；GPUI 与 Electron 适配器侧无法观测，显示 `n/a`。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧；严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代；打开场景没有前一帧，所以不计算 interval/drop。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。
