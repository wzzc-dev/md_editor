# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-07T12:45:23Z`
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
| moui-skia-raster | small | open | ui-frame | 55.508/56.512 | - | - | - | 5.22 ms | 0.00 ms | 5.22 ms | 62.09 ms | n/a | measured |
| moui-skia-raster | small | input | ui-frame | 0.589/0.858 | - | 1.754/2.308 | 1.754/2.307 | 0.99 ms | 0.00 ms | 0.99 ms | 61.60 ms | n/a | measured |
| moui-skia-raster | small | scroll | ui-frame | 0.575/0.716 | - | 1.492/1.839 | - | 0.71 ms | 0.00 ms | 0.71 ms | 60.73 ms | n/a | measured |
| moui-skia-raster | medium | open | ui-frame | 54.083/54.849 | - | - | - | 4.95 ms | 0.00 ms | 4.95 ms | 60.64 ms | n/a | measured |
| moui-skia-raster | medium | input | ui-frame | 0.559/0.665 | - | 1.706/2.118 | 1.706/2.117 | 0.95 ms | 0.00 ms | 0.95 ms | 60.36 ms | n/a | measured |
| moui-skia-raster | medium | scroll | ui-frame | 0.595/0.774 | - | 1.566/2.016 | - | 0.75 ms | 0.00 ms | 0.75 ms | 60.69 ms | n/a | measured |
| moui-skia-raster | large | open | ui-frame | 57.176/61.811 | - | - | - | 5.21 ms | 0.00 ms | 5.21 ms | 66.65 ms | n/a | measured |
| moui-skia-raster | large | input | ui-frame | 0.604/0.783 | - | 2.060/2.458 | 2.060/2.458 | 1.06 ms | 0.00 ms | 1.06 ms | 63.79 ms | n/a | measured |
| moui-skia-raster | large | scroll | ui-frame | 0.576/0.715 | - | 1.489/1.837 | - | 0.71 ms | 0.00 ms | 0.71 ms | 62.09 ms | n/a | measured |
| moui-skia-raster | stress | open | ui-frame | 53.642/54.343 | - | - | - | 4.73 ms | 0.00 ms | 4.73 ms | 78.07 ms | n/a | measured |
| moui-skia-raster | stress | input | ui-frame | 0.730/1.256 | - | 4.620/6.430 | 4.619/6.428 | 0.95 ms | 0.00 ms | 0.95 ms | 78.67 ms | n/a | measured |
| moui-skia-raster | stress | scroll | ui-frame | 0.596/0.801 | - | 1.571/2.030 | - | 0.75 ms | 0.00 ms | 0.75 ms | 79.99 ms | n/a | measured |
| moui-skia-gpu | small | open | ui-frame | 53.239/54.063 | - | - | - | 19.26 ms | n/a | 0.00 ms | 74.01 ms | n/a | measured |
| moui-skia-gpu | small | input | ui-frame | 0.753/1.238 | - | 8.731/9.607 | 8.730/9.606 | 7.67 ms | n/a | 0.00 ms | 74.59 ms | n/a | measured |
| moui-skia-gpu | small | scroll | ui-frame | 0.866/1.587 | - | 8.334/9.108 | - | 7.04 ms | n/a | 0.00 ms | 70.77 ms | n/a | measured |
| moui-skia-gpu | medium | open | ui-frame | 52.304/53.600 | - | - | - | 17.83 ms | n/a | 0.00 ms | 71.59 ms | n/a | measured |
| moui-skia-gpu | medium | input | ui-frame | 0.743/1.151 | - | 8.462/9.317 | 8.461/9.316 | 7.43 ms | n/a | 0.00 ms | 70.56 ms | n/a | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 0.850/1.643 | - | 8.331/9.122 | - | 7.05 ms | n/a | 0.00 ms | 69.11 ms | n/a | measured |
| moui-skia-gpu | large | open | ui-frame | 50.237/50.877 | - | - | - | 15.98 ms | n/a | 0.00 ms | 69.27 ms | n/a | measured |
| moui-skia-gpu | large | input | ui-frame | 0.696/0.831 | - | 8.448/9.453 | 8.447/9.452 | 7.22 ms | n/a | 0.00 ms | 70.54 ms | n/a | measured |
| moui-skia-gpu | large | scroll | ui-frame | 0.831/1.512 | - | 8.334/9.108 | - | 7.08 ms | n/a | 0.00 ms | 68.06 ms | n/a | measured |
| moui-skia-gpu | stress | open | ui-frame | 51.070/51.485 | - | - | - | 18.75 ms | n/a | 0.00 ms | 89.75 ms | n/a | measured |
| moui-skia-gpu | stress | input | ui-frame | 0.713/0.875 | - | 9.897/11.032 | 9.896/11.031 | 6.20 ms | n/a | 0.00 ms | 89.59 ms | n/a | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 0.811/1.613 | - | 8.336/9.110 | - | 7.10 ms | n/a | 0.00 ms | 90.31 ms | n/a | measured |
| moui-wgpu | small | open | ui-frame | 48.412/48.982 | - | - | - | 11.23 ms | n/a | 0.00 ms | 61.16 ms | n/a | measured |
| moui-wgpu | small | input | ui-frame | 0.754/1.066 | - | 8.118/9.388 | 8.117/9.387 | 7.07 ms | n/a | 0.00 ms | 68.70 ms | n/a | measured |
| moui-wgpu | small | scroll | ui-frame | 0.848/1.469 | - | 8.331/9.320 | - | 7.09 ms | n/a | 0.00 ms | 64.08 ms | n/a | measured |
| moui-wgpu | medium | open | ui-frame | 53.030/53.481 | - | - | - | 11.05 ms | n/a | 0.00 ms | 65.57 ms | n/a | measured |
| moui-wgpu | medium | input | ui-frame | 0.716/0.970 | - | 8.141/10.031 | 8.140/10.030 | 7.11 ms | n/a | 0.00 ms | 65.15 ms | n/a | measured |
| moui-wgpu | medium | scroll | ui-frame | 0.860/1.487 | - | 8.332/9.378 | - | 7.06 ms | n/a | 0.00 ms | 61.64 ms | n/a | measured |
| moui-wgpu | large | open | ui-frame | 47.406/47.968 | - | - | - | 11.09 ms | n/a | 0.00 ms | 61.66 ms | n/a | measured |
| moui-wgpu | large | input | ui-frame | 0.711/1.075 | - | 8.097/9.248 | 8.096/9.248 | 6.84 ms | n/a | 0.00 ms | 66.44 ms | n/a | measured |
| moui-wgpu | large | scroll | ui-frame | 0.876/1.555 | - | 8.327/9.390 | - | 7.04 ms | n/a | 0.00 ms | 64.63 ms | n/a | measured |
| moui-wgpu | stress | open | ui-frame | 52.210/54.002 | - | - | - | 11.39 ms | n/a | 0.00 ms | 84.32 ms | n/a | measured |
| moui-wgpu | stress | input | ui-frame | 0.718/0.882 | - | 8.215/9.291 | 8.215/9.291 | 3.98 ms | n/a | 0.00 ms | 85.43 ms | n/a | measured |
| moui-wgpu | stress | scroll | ui-frame | 0.858/1.498 | - | 8.331/9.384 | - | 7.07 ms | n/a | 0.00 ms | 83.72 ms | n/a | measured |
| moui-md-skia-raster | small | open | ui-frame | 57.495/60.780 | - | - | - | 13.61 ms | 0.00 ms | 13.61 ms | 73.01 ms | n/a | measured |
| moui-md-skia-raster | small | input | ui-frame | 3.624/4.158 | - | 6.964/7.505 | 6.936/7.504 | 2.97 ms | 0.00 ms | 2.97 ms | 73.71 ms | n/a | measured |
| moui-md-skia-raster | small | scroll | ui-frame | 1.033/1.299 | - | 3.827/4.686 | - | 2.60 ms | 0.00 ms | 2.60 ms | 69.87 ms | n/a | measured |
| moui-md-skia-raster | medium | open | ui-frame | 55.306/56.026 | - | - | - | 13.24 ms | 0.00 ms | 13.24 ms | 71.63 ms | n/a | measured |
| moui-md-skia-raster | medium | input | ui-frame | 3.680/4.170 | - | 7.247/7.689 | 7.220/7.664 | 3.05 ms | 0.00 ms | 3.05 ms | 74.25 ms | n/a | measured |
| moui-md-skia-raster | medium | scroll | ui-frame | 1.031/1.270 | - | 3.778/4.493 | - | 2.56 ms | 0.00 ms | 2.56 ms | 74.60 ms | n/a | measured |
| moui-md-skia-raster | large | open | ui-frame | 56.473/57.831 | - | - | - | 13.80 ms | 0.00 ms | 13.80 ms | 85.33 ms | n/a | measured |
| moui-md-skia-raster | large | input | ui-frame | 3.825/4.398 | - | 8.748/9.478 | 8.698/9.462 | 3.01 ms | 0.00 ms | 3.01 ms | 85.49 ms | n/a | measured |
| moui-md-skia-raster | large | scroll | ui-frame | 1.037/1.339 | - | 3.781/4.518 | - | 2.54 ms | 0.00 ms | 2.54 ms | 85.72 ms | n/a | measured |
| moui-md-skia-raster | stress | open | ui-frame | 55.069/55.777 | - | - | - | 13.62 ms | 0.00 ms | 13.62 ms | 212.83 ms | n/a | measured |
| moui-md-skia-raster | stress | input | ui-frame | 4.330/4.832 | - | 26.326/29.181 | 26.022/27.635 | 3.38 ms | 0.00 ms | 3.38 ms | 215.02 ms | n/a | measured |
| moui-md-skia-raster | stress | scroll | ui-frame | 1.048/1.337 | - | 3.856/4.624 | - | 2.57 ms | 0.00 ms | 2.57 ms | 205.52 ms | n/a | measured |
| moui-md-skia-gpu | small | open | ui-frame | 54.016/54.261 | - | - | - | 64.55 ms | n/a | 0.00 ms | 120.32 ms | n/a | measured |
| moui-md-skia-gpu | small | input | ui-frame | 3.556/3.767 | - | 10.290/11.560 | 10.260/11.558 | 6.37 ms | n/a | 0.00 ms | 118.23 ms | n/a | measured |
| moui-md-skia-gpu | small | scroll | ui-frame | 1.246/1.797 | - | 8.695/9.904 | - | 7.17 ms | n/a | 0.00 ms | 129.61 ms | n/a | measured |
| moui-md-skia-gpu | medium | open | ui-frame | 55.427/58.288 | - | - | - | 66.44 ms | n/a | 0.00 ms | 124.92 ms | n/a | measured |
| moui-md-skia-gpu | medium | input | ui-frame | 3.599/3.992 | - | 9.961/10.427 | 9.932/10.426 | 5.85 ms | n/a | 0.00 ms | 133.88 ms | n/a | measured |
| moui-md-skia-gpu | medium | scroll | ui-frame | 1.237/1.769 | - | 8.705/9.962 | - | 7.19 ms | n/a | 0.00 ms | 124.12 ms | n/a | measured |
| moui-md-skia-gpu | large | open | ui-frame | 53.890/55.757 | - | - | - | 67.50 ms | n/a | 0.00 ms | 136.63 ms | n/a | measured |
| moui-md-skia-gpu | large | input | ui-frame | 3.834/4.274 | - | 10.287/10.642 | 10.232/10.640 | 4.57 ms | n/a | 0.00 ms | 140.87 ms | n/a | measured |
| moui-md-skia-gpu | large | scroll | ui-frame | 1.243/1.683 | - | 8.761/10.065 | - | 7.23 ms | n/a | 0.00 ms | 141.69 ms | n/a | measured |
| moui-md-skia-gpu | stress | open | ui-frame | 53.209/55.707 | - | - | - | 68.31 ms | n/a | 0.00 ms | 261.43 ms | n/a | measured |
| moui-md-skia-gpu | stress | input | ui-frame | 4.126/4.655 | - | 29.943/30.349 | 29.643/30.348 | 6.73 ms | n/a | 0.00 ms | 274.47 ms | n/a | measured |
| moui-md-skia-gpu | stress | scroll | ui-frame | 1.247/1.718 | - | 8.775/9.958 | - | 7.22 ms | n/a | 0.00 ms | 265.32 ms | n/a | measured |
| moui-md-wgpu | small | open | ui-frame | 50.763/52.727 | - | - | - | 17.01 ms | n/a | 0.00 ms | 69.62 ms | n/a | measured |
| moui-md-wgpu | small | input | ui-frame | 1.629/1.891 | - | 12.594/25.770 | 12.558/25.767 | 10.55 ms | n/a | 0.00 ms | 66.26 ms | n/a | measured |
| moui-md-wgpu | small | scroll | ui-frame | 1.398/1.823 | - | 15.560/27.035 | - | 13.84 ms | n/a | 0.00 ms | 68.61 ms | n/a | measured |
| moui-md-wgpu | medium | open | ui-frame | 50.865/51.002 | - | - | - | 15.02 ms | n/a | 0.00 ms | 69.16 ms | n/a | measured |
| moui-md-wgpu | medium | input | ui-frame | 1.774/2.581 | - | 11.044/25.864 | 11.011/25.864 | 8.67 ms | n/a | 0.00 ms | 68.83 ms | n/a | measured |
| moui-md-wgpu | medium | scroll | ui-frame | 1.421/1.725 | - | 15.584/27.220 | - | 13.85 ms | n/a | 0.00 ms | 66.74 ms | n/a | measured |
| moui-md-wgpu | large | open | ui-frame | 48.297/50.261 | - | - | - | 16.10 ms | n/a | 0.00 ms | 79.78 ms | n/a | measured |
| moui-md-wgpu | large | input | ui-frame | 1.694/2.042 | - | 11.550/24.515 | 11.486/24.513 | 7.66 ms | n/a | 0.00 ms | 83.49 ms | n/a | measured |
| moui-md-wgpu | large | scroll | ui-frame | 1.446/1.838 | - | 15.758/27.309 | - | 13.98 ms | n/a | 0.00 ms | 82.52 ms | n/a | measured |
| moui-md-wgpu | stress | open | ui-frame | 50.934/52.181 | - | - | - | 15.46 ms | n/a | 0.00 ms | 207.62 ms | n/a | measured |
| moui-md-wgpu | stress | input | ui-frame | 1.739/1.983 | - | 23.672/27.213 | 23.353/24.634 | 2.84 ms | n/a | 0.00 ms | 208.14 ms | n/a | measured |
| moui-md-wgpu | stress | scroll | ui-frame | 1.432/1.774 | - | 15.529/27.069 | - | 13.73 ms | n/a | 0.00 ms | 205.81 ms | n/a | measured |
| gpmark | small | open | ui-frame | 5.426/5.587 | - | - | - | n/a | n/a | n/a | 230.10 ms | n/a | measured |
| gpmark | small | input | ui-frame | 5.494/5.745 | 0.323/0.396 | 11.362/23.195 | 11.359/23.193 | n/a | n/a | n/a | 224.78 ms | n/a | measured |
| gpmark | small | scroll | ui-frame | 6.514/7.920 | 0.002/0.004 | 10.241/15.383 | - | n/a | n/a | n/a | 215.99 ms | n/a | measured |
| gpmark | medium | open | ui-frame | 5.279/5.293 | - | - | - | n/a | n/a | n/a | 219.41 ms | n/a | measured |
| gpmark | medium | input | ui-frame | 5.581/5.846 | 0.353/0.440 | 11.566/25.828 | 11.563/25.826 | n/a | n/a | n/a | 227.33 ms | n/a | measured |
| gpmark | medium | scroll | ui-frame | 6.521/7.857 | 0.002/0.004 | 10.163/14.527 | - | n/a | n/a | n/a | 217.75 ms | n/a | measured |
| gpmark | large | open | ui-frame | 5.402/5.445 | - | - | - | n/a | n/a | n/a | 235.11 ms | n/a | measured |
| gpmark | large | input | ui-frame | 5.545/5.955 | 0.729/0.901 | 11.686/31.753 | 11.683/31.751 | n/a | n/a | n/a | 215.19 ms | n/a | measured |
| gpmark | large | scroll | ui-frame | 6.564/7.915 | 0.003/0.005 | 10.239/13.674 | - | n/a | n/a | n/a | 237.54 ms | n/a | measured |
| gpmark | stress | open | ui-frame | 5.318/5.531 | - | - | - | n/a | n/a | n/a | 220.57 ms | n/a | measured |
| gpmark | stress | input | ui-frame | 5.564/5.883 | 5.386/6.351 | 14.233/22.834 | 14.230/22.833 | n/a | n/a | n/a | 217.74 ms | n/a | measured |
| gpmark | stress | scroll | ui-frame | 6.582/7.941 | 0.003/0.006 | 10.227/14.338 | - | n/a | n/a | n/a | 211.28 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 0.342/0.395 | - | - | - | 9.64 ms | n/a | n/a | 83.40 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 0.610/0.870 | - | 11.334/20.004 | 9.797/10.293 | 0.67 ms | n/a | n/a | 88.12 ms | 4 | measured |
| flutter-skia | small | scroll | ui-frame | 1.473/2.808 | - | 10.000/10.002 | - | 0.42 ms | n/a | n/a | 82.36 ms | 0 | measured |
| flutter-skia | medium | open | ui-frame | 0.433/0.555 | - | - | - | 9.85 ms | n/a | n/a | 80.74 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 0.638/0.973 | - | 10.667/20.005 | 10.333/17.353 | 0.72 ms | n/a | n/a | 87.95 ms | 4 | measured |
| flutter-skia | medium | scroll | ui-frame | 1.875/2.630 | - | 10.084/10.002 | - | 0.45 ms | n/a | n/a | 88.20 ms | 5 | measured |
| flutter-skia | large | open | ui-frame | 0.333/0.347 | - | - | - | 10.03 ms | n/a | n/a | 79.83 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 0.619/0.971 | - | 11.334/20.009 | 9.566/10.417 | 0.71 ms | n/a | n/a | 93.27 ms | 6 | measured |
| flutter-skia | large | scroll | ui-frame | 1.870/2.735 | - | 10.083/10.002 | - | 0.42 ms | n/a | n/a | 86.55 ms | 2 | measured |
| flutter-skia | stress | open | ui-frame | 0.424/0.507 | - | - | - | 9.30 ms | n/a | n/a | 116.43 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 0.598/0.885 | - | 10.001/19.998 | 9.590/10.358 | 0.75 ms | n/a | n/a | 140.33 ms | 3 | measured |
| flutter-skia | stress | scroll | ui-frame | 1.888/2.674 | - | 10.000/10.002 | - | 0.43 ms | n/a | n/a | 132.49 ms | 2 | measured |
| flutter-impeller | small | open | ui-frame | 0.456/0.532 | - | - | - | 7.69 ms | n/a | n/a | 77.70 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 0.664/0.978 | - | 11.667/29.999 | 10.470/10.411 | 0.65 ms | n/a | n/a | 80.77 ms | 3 | measured |
| flutter-impeller | small | scroll | ui-frame | 1.546/2.826 | - | 10.083/10.002 | - | 0.44 ms | n/a | n/a | 83.48 ms | 3 | measured |
| flutter-impeller | medium | open | ui-frame | 0.353/0.407 | - | - | - | 7.26 ms | n/a | n/a | 78.53 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 0.666/0.914 | - | 11.667/30.002 | 9.774/10.560 | 0.68 ms | n/a | n/a | 83.31 ms | 4 | measured |
| flutter-impeller | medium | scroll | ui-frame | 1.876/2.679 | - | 10.000/10.002 | - | 0.42 ms | n/a | n/a | 83.88 ms | 1 | measured |
| flutter-impeller | large | open | ui-frame | 0.427/0.511 | - | - | - | 7.65 ms | n/a | n/a | 88.88 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 0.637/0.980 | - | 11.334/20.005 | 9.582/10.338 | 0.73 ms | n/a | n/a | 90.06 ms | 5 | measured |
| flutter-impeller | large | scroll | ui-frame | 1.954/2.799 | - | 10.056/10.002 | - | 0.45 ms | n/a | n/a | 94.40 ms | 3 | measured |
| flutter-impeller | stress | open | ui-frame | 0.440/0.549 | - | - | - | 7.63 ms | n/a | n/a | 126.96 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 0.735/1.013 | - | 10.667/20.002 | 10.880/23.822 | 0.90 ms | n/a | n/a | 124.19 ms | 3 | measured |
| flutter-impeller | stress | scroll | ui-frame | 1.947/2.675 | - | 10.056/10.002 | - | 0.42 ms | n/a | n/a | 148.96 ms | 3 | measured |
| electron | small | open | ui-frame | 105.967/124.800 | - | - | - | n/a | n/a | n/a | 105.97 ms | 0 | measured |
| electron | small | input | ui-frame | 2.177/4.000 | - | 9.559/11.800 | 8.843/10.900 | n/a | n/a | n/a | 107.40 ms | 1 | measured |
| electron | small | scroll | ui-frame | 1.952/2.400 | - | 9.957/10.800 | - | n/a | n/a | n/a | 110.10 ms | 0 | measured |
| electron | medium | open | ui-frame | 113.000/125.700 | - | - | - | n/a | n/a | n/a | 113.00 ms | 0 | measured |
| electron | medium | input | ui-frame | 2.153/3.500 | - | 10.004/13.336 | 8.753/10.900 | n/a | n/a | n/a | 101.03 ms | 0 | measured |
| electron | medium | scroll | ui-frame | 2.036/2.500 | - | 9.959/12.000 | - | n/a | n/a | n/a | 96.43 ms | 0 | measured |
| electron | large | open | ui-frame | 110.967/121.200 | - | - | - | n/a | n/a | n/a | 110.97 ms | 0 | measured |
| electron | large | input | ui-frame | 1.980/2.700 | - | 10.131/12.000 | 8.770/10.100 | n/a | n/a | n/a | 106.53 ms | 0 | measured |
| electron | large | scroll | ui-frame | 2.053/2.600 | - | 9.944/11.800 | - | n/a | n/a | n/a | 117.67 ms | 0 | measured |
| electron | stress | open | ui-frame | 110.233/115.000 | - | - | - | n/a | n/a | n/a | 110.23 ms | 0 | measured |
| electron | stress | input | ui-frame | 2.143/4.100 | - | 8.889/10.100 | 8.633/10.100 | n/a | n/a | n/a | 113.07 ms | 0 | measured |
| electron | stress | scroll | ui-frame | 2.035/2.600 | - | 9.949/11.600 | - | n/a | n/a | n/a | 116.03 ms | 0 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.49/1.57/1.49 | 1.84/2.02/1.84 | n/a/n/a/n/a | 0.58/0.60/0.58 | 0.72/0.77/0.71 | 0.71/0.75/0.71 | 1.01/1.07/0.98 |
| MoUI Skia GPU | 8.33/8.33/8.33 | 9.11/9.12/9.11 | n/a/n/a/n/a | 0.87/0.85/0.83 | 1.59/1.64/1.51 | 7.04/7.05/7.08 | 8.05/8.02/8.03 |
| MoUI WGPU | 8.33/8.33/8.33 | 9.32/9.38/9.39 | n/a/n/a/n/a | 0.85/0.86/0.88 | 1.47/1.49/1.56 | 7.09/7.06/7.04 | 8.33/8.40/8.40 |
| MoMark Skia Raster | 3.83/3.78/3.78 | 4.69/4.49/4.52 | n/a/n/a/n/a | 1.03/1.03/1.04 | 1.30/1.27/1.34 | 2.60/2.56/2.54 | 3.24/3.13/3.09 |
| MoMark Skia GPU | 8.70/8.71/8.76 | 9.90/9.96/10.07 | n/a/n/a/n/a | 1.25/1.24/1.24 | 1.80/1.77/1.68 | 7.17/7.19/7.23 | 8.26/8.28/8.40 |
| MoMark WGPU | 15.56/15.58/15.76 | 27.04/27.22/27.31 | n/a/n/a/n/a | 1.40/1.42/1.45 | 1.82/1.72/1.84 | 13.84/13.85/13.98 | 25.43/25.73/25.72 |
| GpMark.mbt (GPUI) | 10.24/10.16/10.24 | 15.38/14.53/13.67 | n/a/n/a/n/a | 6.51/6.52/6.56 | 7.92/7.86/7.92 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 10.00/10.08/10.08 | 10.00/10.00/10.00 | 0/5/2 | 1.47/1.88/1.87 | 2.81/2.63/2.73 | 0.42/0.45/0.42 | 0.75/0.74/0.68 |
| Flutter Impeller | 10.08/10.00/10.06 | 10.00/10.00/10.00 | 3/1/3 | 1.55/1.88/1.95 | 2.83/2.68/2.80 | 0.44/0.42/0.45 | 0.83/0.68/0.80 |
| Electron | 9.96/9.96/9.94 | 10.80/12.00/11.80 | 0/0/0 | 1.95/2.04/2.05 | 2.40/2.50/2.60 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.57 | 2.03 | n/a | 0.60 | 0.80 | 0.75 | 1.06 |
| MoUI Skia GPU | 8.34 | 9.11 | n/a | 0.81 | 1.61 | 7.10 | 8.02 |
| MoUI WGPU | 8.33 | 9.38 | n/a | 0.86 | 1.50 | 7.07 | 8.40 |
| MoMark Skia Raster | 3.86 | 4.62 | n/a | 1.05 | 1.34 | 2.57 | 3.15 |
| MoMark Skia GPU | 8.77 | 9.96 | n/a | 1.25 | 1.72 | 7.22 | 8.31 |
| MoMark WGPU | 15.53 | 27.07 | n/a | 1.43 | 1.77 | 13.73 | 25.32 |
| GpMark.mbt (GPUI) | 10.23 | 14.34 | n/a | 6.58 | 7.94 | n/a | n/a |
| Flutter Skia | 10.00 | 10.00 | 2 | 1.89 | 2.67 | 0.43 | 0.68 |
| Flutter Impeller | 10.06 | 10.00 | 3 | 1.95 | 2.67 | 0.42 | 0.62 |
| Electron | 9.95 | 11.60 | 0 | 2.03 | 2.60 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.75/1.71/2.06 | 2.31/2.12/2.46 | 0.59/0.56/0.60 | 0.86/0.66/0.78 | 0.99/0.95/1.06 | 1.46/1.30/1.42 |
| MoUI Skia GPU | 8.73/8.46/8.45 | 9.61/9.32/9.45 | 0.75/0.74/0.70 | 1.24/1.15/0.83 | 7.67/7.43/7.22 | 8.58/8.44/8.31 |
| MoUI WGPU | 8.12/8.14/8.10 | 9.39/10.03/9.25 | 0.75/0.72/0.71 | 1.07/0.97/1.07 | 7.07/7.11/6.84 | 8.45/9.00/8.28 |
| MoMark Skia Raster | 6.94/7.22/8.70 | 7.50/7.66/9.46 | 3.62/3.68/3.83 | 4.16/4.17/4.40 | 2.97/3.05/3.01 | 3.73/3.48/3.51 |
| MoMark Skia GPU | 10.26/9.93/10.23 | 11.56/10.43/10.64 | 3.56/3.60/3.83 | 3.77/3.99/4.27 | 6.37/5.85/4.57 | 6.93/6.30/5.01 |
| MoMark WGPU | 12.56/11.01/11.49 | 25.77/25.86/24.51 | 1.63/1.77/1.69 | 1.89/2.58/2.04 | 10.55/8.67/7.66 | 23.52/23.77/20.99 |
| GpMark.mbt (GPUI) | 11.36/11.56/11.68 | 23.19/25.83/31.75 | 5.49/5.58/5.55 | 5.75/5.85/5.95 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 9.80/10.33/9.57 | 10.29/17.35/10.42 | 0.61/0.64/0.62 | 0.87/0.97/0.97 | 0.67/0.72/0.71 | 1.28/1.38/1.38 |
| Flutter Impeller | 10.47/9.77/9.58 | 10.41/10.56/10.34 | 0.66/0.67/0.64 | 0.98/0.91/0.98 | 0.65/0.68/0.73 | 1.16/1.44/1.63 |
| Electron | 8.84/8.75/8.77 | 10.90/10.90/10.10 | 2.18/2.15/1.98 | 4.00/3.50/2.70 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 4.62 | 6.43 | 0.73 | 1.26 | 0.95 | 1.28 |
| MoUI Skia GPU | 9.90 | 11.03 | 0.71 | 0.88 | 6.20 | 7.66 |
| MoUI WGPU | 8.21 | 9.29 | 0.72 | 0.88 | 3.98 | 4.95 |
| MoMark Skia Raster | 26.02 | 27.63 | 4.33 | 4.83 | 3.38 | 4.24 |
| MoMark Skia GPU | 29.64 | 30.35 | 4.13 | 4.66 | 6.73 | 9.15 |
| MoMark WGPU | 23.35 | 24.63 | 1.74 | 1.98 | 2.84 | 3.80 |
| GpMark.mbt (GPUI) | 14.23 | 22.83 | 5.56 | 5.88 | n/a | n/a |
| Flutter Skia | 9.59 | 10.36 | 0.60 | 0.89 | 0.75 | 1.84 |
| Flutter Impeller | 10.88 | 23.82 | 0.73 | 1.01 | 0.90 | 2.28 |
| Electron | 8.63 | 10.10 | 2.14 | 4.10 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 62.09/60.64/66.65 | 63.31/61.36/73.77 | 0.13/0.34/2.98 | 0.19/0.40/3.64 | 55.51/54.08/57.18 | 56.51/54.85/61.81 | 5.22/4.95/5.21 | 5.52/4.97/5.49 |
| MoUI Skia GPU | 74.01/71.59/69.27 | 76.63/72.59/69.73 | 0.12/0.33/2.80 | 0.21/0.36/2.92 | 53.24/52.30/50.24 | 54.06/53.60/50.88 | 19.26/17.83/15.98 | 21.49/18.12/16.16 |
| MoUI WGPU | 61.16/65.57/61.66 | 61.84/66.19/62.14 | 0.14/0.43/2.56 | 0.23/0.63/2.65 | 48.41/53.03/47.41 | 48.98/53.48/47.97 | 11.23/11.05/11.09 | 11.46/11.33/11.48 |
| MoMark Skia Raster | 73.01/71.63/85.33 | 75.38/72.30/86.94 | 0.07/0.29/2.30 | 0.10/0.30/2.78 | 57.49/55.31/56.47 | 60.78/56.03/57.83 | 13.61/13.24/13.80 | 15.14/13.58/14.64 |
| MoMark Skia GPU | 120.32/124.92/136.63 | 123.99/133.59/141.22 | 0.07/0.30/2.52 | 0.09/0.31/2.60 | 54.02/55.43/53.89 | 54.26/58.29/55.76 | 64.55/66.44/67.50 | 68.23/72.26/70.91 |
| MoMark WGPU | 69.62/69.16/79.78 | 71.26/69.37/82.22 | 0.09/0.45/2.76 | 0.12/0.49/2.86 | 50.76/50.86/48.30 | 52.73/51.00/50.26 | 17.01/15.02/16.10 | 17.97/15.29/16.32 |
| GpMark.mbt (GPUI) | 230.10/219.41/235.11 | 236.89/234.98/236.28 | 0.33/0.33/2.33 | 1.00/1.00/3.00 | 5.43/5.28/5.40 | 5.59/5.29/5.44 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 83.40/80.74/79.83 | 99.19/87.52/86.97 | 0.09/0.15/0.43 | 0.10/0.19/0.51 | 0.34/0.43/0.33 | 0.40/0.56/0.35 | 9.64/9.85/10.03 | 9.91/10.00/10.42 |
| Flutter Impeller | 77.70/78.53/88.88 | 87.03/87.67/105.72 | 0.11/0.12/0.40 | 0.16/0.16/0.44 | 0.46/0.35/0.43 | 0.53/0.41/0.51 | 7.69/7.26/7.65 | 7.72/7.58/8.10 |
| Electron | 105.97/113.00/110.97 | 124.80/125.70/121.20 | 11.34/7.88/11.72 | 22.26/14.66/15.91 | 105.97/113.00/110.97 | 124.80/125.70/121.20 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 78.07 | 78.76 | 23.53 | 26.96 | 53.64 | 54.34 | 4.73 | 5.00 |
| MoUI Skia GPU | 89.75 | 92.68 | 23.73 | 31.82 | 51.07 | 51.48 | 18.75 | 21.49 |
| MoUI WGPU | 84.32 | 86.08 | 25.26 | 27.11 | 52.21 | 54.00 | 11.39 | 11.50 |
| MoMark Skia Raster | 212.83 | 219.58 | 26.87 | 27.16 | 55.07 | 55.78 | 13.62 | 14.74 |
| MoMark Skia GPU | 261.43 | 262.27 | 24.39 | 27.47 | 53.21 | 55.71 | 68.31 | 71.10 |
| MoMark WGPU | 207.62 | 213.73 | 24.51 | 27.42 | 50.93 | 52.18 | 15.46 | 15.64 |
| GpMark.mbt (GPUI) | 220.57 | 225.83 | 23.67 | 27.00 | 5.32 | 5.53 | n/a | n/a |
| Flutter Skia | 116.43 | 136.42 | 2.90 | 3.00 | 0.42 | 0.51 | 9.30 | 9.37 |
| Flutter Impeller | 126.96 | 133.38 | 2.96 | 3.14 | 0.44 | 0.55 | 7.63 | 7.76 |
| Electron | 110.23 | 115.00 | 6.67 | 6.81 | 110.23 | 115.00 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.49/1.57/1.49 | 1.84/2.02/1.84 | n/a/n/a/n/a | 0.58/0.60/0.58 | 0.72/0.77/0.71 | 0.71/0.75/0.71 | 1.01/1.07/0.98 |
| MoUI Skia GPU | 8.33/8.33/8.33 | 9.11/9.12/9.11 | n/a/n/a/n/a | 0.87/0.85/0.83 | 1.59/1.64/1.51 | 7.04/7.05/7.08 | 8.05/8.02/8.03 |
| MoUI WGPU | 8.33/8.33/8.33 | 9.32/9.38/9.39 | n/a/n/a/n/a | 0.85/0.86/0.88 | 1.47/1.49/1.56 | 7.09/7.06/7.04 | 8.33/8.40/8.40 |
| MoMark Skia Raster | 3.83/3.78/3.78 | 4.69/4.49/4.52 | n/a/n/a/n/a | 1.03/1.03/1.04 | 1.30/1.27/1.34 | 2.60/2.56/2.54 | 3.24/3.13/3.09 |
| MoMark Skia GPU | 8.70/8.71/8.76 | 9.90/9.96/10.07 | n/a/n/a/n/a | 1.25/1.24/1.24 | 1.80/1.77/1.68 | 7.17/7.19/7.23 | 8.26/8.28/8.40 |
| MoMark WGPU | 15.56/15.58/15.76 | 27.04/27.22/27.31 | n/a/n/a/n/a | 1.40/1.42/1.45 | 1.82/1.72/1.84 | 13.84/13.85/13.98 | 25.43/25.73/25.72 |
| GpMark.mbt (GPUI) | 10.24/10.16/10.24 | 15.38/14.53/13.67 | n/a/n/a/n/a | 6.51/6.52/6.56 | 7.92/7.86/7.92 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 10.00/10.08/10.08 | 10.00/10.00/10.00 | 0/5/2 | 1.47/1.88/1.87 | 2.81/2.63/2.73 | 0.42/0.45/0.42 | 0.75/0.74/0.68 |
| Flutter Impeller | 10.08/10.00/10.06 | 10.00/10.00/10.00 | 3/1/3 | 1.55/1.88/1.95 | 2.83/2.68/2.80 | 0.44/0.42/0.45 | 0.83/0.68/0.80 |
| Electron | 9.96/9.96/9.94 | 10.80/12.00/11.80 | 0/0/0 | 1.95/2.04/2.05 | 2.40/2.50/2.60 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.57 | 2.03 | n/a | 0.60 | 0.80 | 0.75 | 1.06 |
| MoUI Skia GPU | 8.34 | 9.11 | n/a | 0.81 | 1.61 | 7.10 | 8.02 |
| MoUI WGPU | 8.33 | 9.38 | n/a | 0.86 | 1.50 | 7.07 | 8.40 |
| MoMark Skia Raster | 3.86 | 4.62 | n/a | 1.05 | 1.34 | 2.57 | 3.15 |
| MoMark Skia GPU | 8.77 | 9.96 | n/a | 1.25 | 1.72 | 7.22 | 8.31 |
| MoMark WGPU | 15.53 | 27.07 | n/a | 1.43 | 1.77 | 13.73 | 25.32 |
| GpMark.mbt (GPUI) | 10.23 | 14.34 | n/a | 6.58 | 7.94 | n/a | n/a |
| Flutter Skia | 10.00 | 10.00 | 2 | 1.89 | 2.67 | 0.43 | 0.68 |
| Flutter Impeller | 10.06 | 10.00 | 3 | 1.95 | 2.67 | 0.42 | 0.62 |
| Electron | 9.95 | 11.60 | 0 | 2.03 | 2.60 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoMark Skia Raster stress 212.8 ms（max 219.6 ms）；MoMark Skia GPU small 120.3 ms（max 124.0 ms）；MoMark Skia GPU medium 124.9 ms（max 133.6 ms）；MoMark Skia GPU large 136.6 ms（max 141.2 ms）；MoMark Skia GPU stress 261.4 ms（max 262.3 ms）；MoMark WGPU stress 207.6 ms（max 213.7 ms）；GpMark.mbt (GPUI) small 230.1 ms（max 236.9 ms）；GpMark.mbt (GPUI) medium 219.4 ms（max 235.0 ms）；GpMark.mbt (GPUI) large 235.1 ms（max 236.3 ms）；GpMark.mbt (GPUI) stress 220.6 ms（max 225.8 ms）；Flutter Skia stress 116.4 ms（max 136.4 ms）；Flutter Impeller large 88.9 ms（max 105.7 ms）；Flutter Impeller stress 127.0 ms（max 133.4 ms）；Electron small 106.0 ms（max 124.8 ms）；Electron medium 113.0 ms（max 125.7 ms）；Electron large 111.0 ms（max 121.2 ms）；Electron stress 110.2 ms（max 115.0 ms）。
- P1 输入尾延迟：MoMark Skia Raster stress P95 27.63 ms；MoMark Skia GPU stress P95 30.35 ms；MoMark WGPU small P95 25.77 ms；MoMark WGPU medium P95 25.86 ms；MoMark WGPU large P95 24.51 ms；MoMark WGPU stress P95 24.63 ms；GpMark.mbt (GPUI) small P95 23.19 ms；GpMark.mbt (GPUI) medium P95 25.83 ms；GpMark.mbt (GPUI) large P95 31.75 ms；GpMark.mbt (GPUI) stress P95 22.83 ms；Flutter Skia medium P95 17.35 ms；Flutter Impeller stress P95 23.82 ms。
- 长帧（超预算）：MoMark Skia Raster: stress/input 30 次，max 30.55 ms；MoMark Skia GPU: small/input 1 次，max 18.37 ms, large/input 1 次，max 19.26 ms, large/scroll 1 次，max 20.88 ms, stress/input 30 次，max 30.43 ms, stress/scroll 2 次，max 22.03 ms；MoMark WGPU: small/input 8 次，max 26.62 ms, small/scroll 151 次，max 35.91 ms, medium/input 5 次，max 27.16 ms, medium/scroll 157 次，max 34.21 ms, large/input 5 次，max 25.50 ms, large/scroll 149 次，max 29.07 ms, stress/input 30 次，max 42.81 ms, stress/scroll 148 次，max 34.70 ms；GpMark.mbt (GPUI): small/input 3 次，max 32.48 ms, small/scroll 6 次，max 38.74 ms, medium/input 4 次，max 30.57 ms, medium/scroll 5 次，max 31.05 ms, large/input 3 次，max 34.44 ms, large/scroll 6 次，max 36.69 ms, stress/input 5 次，max 22.98 ms, stress/scroll 5 次，max 39.54 ms；Flutter Skia: small/input 4 次，max 30.00 ms, medium/input 4 次，max 30.00 ms, medium/scroll 5 次，max 20.01 ms, large/input 6 次，max 30.00 ms, large/scroll 2 次，max 30.00 ms, stress/input 3 次，max 20.00 ms, stress/scroll 2 次，max 20.00 ms；Flutter Impeller: small/input 3 次，max 30.00 ms, small/scroll 3 次，max 30.00 ms, medium/input 4 次，max 30.01 ms, medium/scroll 1 次，max 20.00 ms, large/input 5 次，max 30.00 ms, large/scroll 3 次，max 30.00 ms, stress/input 3 次，max 30.00 ms, stress/scroll 3 次，max 30.00 ms；Electron: small/input 1 次，max 20.00 ms。
- 丢帧（优先处理）：Flutter Skia: small/input 4 帧, medium/input 4 帧, medium/scroll 5 帧, large/input 6 帧, large/scroll 2 帧, stress/input 3 帧, stress/scroll 2 帧；Flutter Impeller: small/input 3 帧, small/scroll 3 帧, medium/input 4 帧, medium/scroll 1 帧, large/input 5 帧, large/scroll 3 帧, stress/input 3 帧, stress/scroll 3 帧；Electron: small/input 1 帧。
- 解释：首帧异常优先检查窗口/渲染器初始化；输入尾延迟检查 action 到下一可见帧的调度与同步重建；长帧检查解析、布局、文本 shaping 和 GPU 提交；`n/a` 表示未埋点，不等于 0。
- 普通模式的长帧、帧间隔和输入延迟是各框架回调诊断，不能替代跨框架 compositor 排名；需要严格结论时运行 `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`。

## 采集口径

- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。
- `frame_work_ms` 统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏；对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `device_present_ms`：设备/上屏侧统一字段。MoUI raster 为 Skia CPU 光栅化+像素回读整体；MoUI GPU/wgpu 为提交后同步等待设备完成（headless host-surface 逐帧同步，真实应用的 vsync 流水线可重叠掉一部分，该值应视为上屏成本上界）；窗口模式（`window_mode=native-window`）下 MoUI 由真实 AppKit 窗口上屏，适配器侧不单独计时，显示 `n/a`；Flutter 为 `FrameTiming.rasterDuration`（光栅线程任务时间，含显示列表光栅化与 GPU 提交、不含设备完成等待）；GPUI 与 Electron 适配器侧无法观测，显示 `n/a`。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧；窗口模式（MoUI `native-window`）取帧时钟观察到的首个窗口帧完成，含 AppKit 窗口创建成本；严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代；打开场景没有前一帧，所以不计算 interval/drop。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。
