# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-07T16:43:35Z`
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
| moui-skia-raster | small | open | ui-frame | 46.469/47.653 | - | - | - | 4.42 ms | 0.00 ms | 4.42 ms | 52.03 ms | n/a | measured |
| moui-skia-raster | small | input | ui-frame | 0.514/0.710 | - | 1.367/1.746 | 1.367/1.745 | 0.72 ms | 0.00 ms | 0.72 ms | 52.75 ms | n/a | measured |
| moui-skia-raster | small | scroll | ui-frame | 0.545/0.670 | - | 1.230/1.507 | - | 0.51 ms | 0.00 ms | 0.51 ms | 52.17 ms | n/a | measured |
| moui-skia-raster | medium | open | ui-frame | 45.742/45.822 | - | - | - | 4.41 ms | 0.00 ms | 4.41 ms | 51.53 ms | n/a | measured |
| moui-skia-raster | medium | input | ui-frame | 0.493/0.543 | - | 1.307/1.552 | 1.307/1.552 | 0.67 ms | 0.00 ms | 0.67 ms | 52.04 ms | n/a | measured |
| moui-skia-raster | medium | scroll | ui-frame | 0.531/0.645 | - | 1.203/1.402 | - | 0.50 ms | 0.00 ms | 0.50 ms | 51.19 ms | n/a | measured |
| moui-skia-raster | large | open | ui-frame | 46.973/47.046 | - | - | - | 4.36 ms | 0.00 ms | 4.36 ms | 54.36 ms | n/a | measured |
| moui-skia-raster | large | input | ui-frame | 0.510/0.656 | - | 1.495/1.941 | 1.495/1.941 | 0.69 ms | 0.00 ms | 0.69 ms | 54.33 ms | n/a | measured |
| moui-skia-raster | large | scroll | ui-frame | 0.547/0.719 | - | 1.235/1.548 | - | 0.51 ms | 0.00 ms | 0.51 ms | 59.51 ms | n/a | measured |
| moui-skia-raster | stress | open | ui-frame | 46.406/47.816 | - | - | - | 4.19 ms | 0.00 ms | 4.19 ms | 70.47 ms | n/a | measured |
| moui-skia-raster | stress | input | ui-frame | 0.579/0.718 | - | 3.535/4.377 | 3.534/4.377 | 0.78 ms | 0.00 ms | 0.78 ms | 69.89 ms | n/a | measured |
| moui-skia-raster | stress | scroll | ui-frame | 0.536/0.658 | - | 1.209/1.390 | - | 0.50 ms | 0.00 ms | 0.50 ms | 69.46 ms | n/a | measured |
| moui-skia-gpu | small | open | ui-frame | 44.225/44.357 | - | - | - | 11.97 ms | n/a | 0.00 ms | 57.35 ms | n/a | measured |
| moui-skia-gpu | small | input | ui-frame | 0.589/0.678 | - | 8.383/9.001 | 8.382/9.000 | 7.58 ms | n/a | 0.00 ms | 57.94 ms | n/a | measured |
| moui-skia-gpu | small | scroll | ui-frame | 1.049/1.617 | - | 8.332/9.183 | - | 6.84 ms | n/a | 0.00 ms | 60.66 ms | n/a | measured |
| moui-skia-gpu | medium | open | ui-frame | 44.373/45.523 | - | - | - | 11.22 ms | n/a | 0.00 ms | 56.96 ms | n/a | measured |
| moui-skia-gpu | medium | input | ui-frame | 0.580/0.674 | - | 8.364/9.132 | 8.362/9.122 | 7.56 ms | n/a | 0.00 ms | 60.92 ms | n/a | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 1.115/1.646 | - | 8.330/9.203 | - | 6.75 ms | n/a | 0.00 ms | 60.38 ms | n/a | measured |
| moui-skia-gpu | large | open | ui-frame | 43.959/46.337 | - | - | - | 11.17 ms | n/a | 0.00 ms | 58.21 ms | n/a | measured |
| moui-skia-gpu | large | input | ui-frame | 0.595/0.689 | - | 8.358/9.399 | 8.357/9.398 | 7.34 ms | n/a | 0.00 ms | 58.52 ms | n/a | measured |
| moui-skia-gpu | large | scroll | ui-frame | 1.149/1.720 | - | 8.334/9.115 | - | 6.73 ms | n/a | 0.00 ms | 64.34 ms | n/a | measured |
| moui-skia-gpu | stress | open | ui-frame | 44.620/45.078 | - | - | - | 11.34 ms | n/a | 0.00 ms | 76.01 ms | n/a | measured |
| moui-skia-gpu | stress | input | ui-frame | 0.600/0.681 | - | 8.505/9.224 | 8.504/9.223 | 5.44 ms | n/a | 0.00 ms | 75.83 ms | n/a | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 1.113/1.697 | - | 8.329/9.136 | - | 6.77 ms | n/a | 0.00 ms | 103.67 ms | n/a | measured |
| moui-wgpu | small | open | ui-frame | 39.463/40.270 | - | - | - | 9.76 ms | n/a | 0.00 ms | 50.46 ms | n/a | measured |
| moui-wgpu | small | input | ui-frame | 0.563/0.680 | - | 8.275/9.040 | 8.274/9.040 | 7.51 ms | n/a | 0.00 ms | 54.19 ms | n/a | measured |
| moui-wgpu | small | scroll | ui-frame | 1.175/1.702 | - | 8.330/9.294 | - | 6.73 ms | n/a | 0.00 ms | 63.15 ms | n/a | measured |
| moui-wgpu | medium | open | ui-frame | 38.771/39.026 | - | - | - | 9.71 ms | n/a | 0.00 ms | 49.91 ms | n/a | measured |
| moui-wgpu | medium | input | ui-frame | 0.554/0.646 | - | 8.234/9.120 | 8.234/9.120 | 7.47 ms | n/a | 0.00 ms | 50.25 ms | n/a | measured |
| moui-wgpu | medium | scroll | ui-frame | 1.170/1.680 | - | 8.328/9.296 | - | 6.72 ms | n/a | 0.00 ms | 60.96 ms | n/a | measured |
| moui-wgpu | large | open | ui-frame | 38.869/40.371 | - | - | - | 9.83 ms | n/a | 0.00 ms | 51.91 ms | n/a | measured |
| moui-wgpu | large | input | ui-frame | 0.567/0.658 | - | 8.273/9.291 | 8.273/9.291 | 7.33 ms | n/a | 0.00 ms | 53.25 ms | n/a | measured |
| moui-wgpu | large | scroll | ui-frame | 1.122/1.530 | - | 8.327/9.275 | - | 6.79 ms | n/a | 0.00 ms | 62.80 ms | n/a | measured |
| moui-wgpu | stress | open | ui-frame | 39.474/41.148 | - | - | - | 9.56 ms | n/a | 0.00 ms | 68.88 ms | n/a | measured |
| moui-wgpu | stress | input | ui-frame | 0.614/0.826 | - | 8.476/9.906 | 8.475/9.905 | 5.14 ms | n/a | 0.00 ms | 67.99 ms | n/a | measured |
| moui-wgpu | stress | scroll | ui-frame | 1.108/1.607 | - | 8.331/9.271 | - | 6.80 ms | n/a | 0.00 ms | 77.52 ms | n/a | measured |
| moui-md-skia-raster | small | open | ui-frame | 46.615/48.154 | - | - | - | 10.96 ms | 0.00 ms | 10.96 ms | 59.27 ms | n/a | measured |
| moui-md-skia-raster | small | input | ui-frame | 3.003/3.292 | - | 5.500/5.836 | 5.475/5.835 | 2.25 ms | 0.00 ms | 2.25 ms | 60.50 ms | n/a | measured |
| moui-md-skia-raster | small | scroll | ui-frame | 0.898/1.108 | - | 3.017/3.756 | - | 2.00 ms | 0.00 ms | 2.00 ms | 60.01 ms | n/a | measured |
| moui-md-skia-raster | medium | open | ui-frame | 47.911/48.674 | - | - | - | 11.19 ms | 0.00 ms | 11.19 ms | 61.91 ms | n/a | measured |
| moui-md-skia-raster | medium | input | ui-frame | 3.171/4.160 | - | 5.960/7.108 | 5.930/7.015 | 2.40 ms | 0.00 ms | 2.40 ms | 63.36 ms | n/a | measured |
| moui-md-skia-raster | medium | scroll | ui-frame | 0.909/1.126 | - | 2.971/3.551 | - | 1.95 ms | 0.00 ms | 1.95 ms | 60.86 ms | n/a | measured |
| moui-md-skia-raster | large | open | ui-frame | 47.975/49.493 | - | - | - | 11.48 ms | 0.00 ms | 11.48 ms | 73.02 ms | n/a | measured |
| moui-md-skia-raster | large | input | ui-frame | 3.082/3.370 | - | 6.959/7.376 | 6.912/7.096 | 2.29 ms | 0.00 ms | 2.29 ms | 74.94 ms | n/a | measured |
| moui-md-skia-raster | large | scroll | ui-frame | 0.898/1.077 | - | 2.984/3.644 | - | 1.97 ms | 0.00 ms | 1.97 ms | 77.24 ms | n/a | measured |
| moui-md-skia-raster | stress | open | ui-frame | 47.446/49.053 | - | - | - | 11.11 ms | 0.00 ms | 11.11 ms | 186.34 ms | n/a | measured |
| moui-md-skia-raster | stress | input | ui-frame | 3.421/3.980 | - | 21.490/24.406 | 21.200/22.014 | 2.57 ms | 0.00 ms | 2.57 ms | 193.03 ms | n/a | measured |
| moui-md-skia-raster | stress | scroll | ui-frame | 0.904/1.098 | - | 3.005/3.615 | - | 1.97 ms | 0.00 ms | 1.97 ms | 181.84 ms | n/a | measured |
| moui-md-skia-gpu | small | open | ui-frame | 45.961/47.318 | - | - | - | 33.19 ms | n/a | 0.00 ms | 80.85 ms | n/a | measured |
| moui-md-skia-gpu | small | input | ui-frame | 3.167/3.470 | - | 8.738/10.107 | 8.713/10.106 | 5.27 ms | n/a | 0.00 ms | 82.90 ms | n/a | measured |
| moui-md-skia-gpu | small | scroll | ui-frame | 1.528/2.137 | - | 8.369/9.208 | - | 6.56 ms | n/a | 0.00 ms | 87.36 ms | n/a | measured |
| moui-md-skia-gpu | medium | open | ui-frame | 45.577/47.386 | - | - | - | 32.76 ms | n/a | 0.00 ms | 81.13 ms | n/a | measured |
| moui-md-skia-gpu | medium | input | ui-frame | 3.096/3.407 | - | 8.763/10.340 | 8.735/10.061 | 5.26 ms | n/a | 0.00 ms | 80.13 ms | n/a | measured |
| moui-md-skia-gpu | medium | scroll | ui-frame | 1.573/2.202 | - | 8.374/9.191 | - | 6.53 ms | n/a | 0.00 ms | 87.39 ms | n/a | measured |
| moui-md-skia-gpu | large | open | ui-frame | 45.780/46.171 | - | - | - | 31.17 ms | n/a | 0.00 ms | 91.38 ms | n/a | measured |
| moui-md-skia-gpu | large | input | ui-frame | 3.158/3.504 | - | 9.443/11.087 | 9.392/11.087 | 4.60 ms | n/a | 0.00 ms | 95.72 ms | n/a | measured |
| moui-md-skia-gpu | large | scroll | ui-frame | 1.563/2.198 | - | 8.362/9.269 | - | 6.52 ms | n/a | 0.00 ms | 105.35 ms | n/a | measured |
| moui-md-skia-gpu | stress | open | ui-frame | 44.983/46.440 | - | - | - | 35.63 ms | n/a | 0.00 ms | 200.48 ms | n/a | measured |
| moui-md-skia-gpu | stress | input | ui-frame | 3.455/3.945 | - | 21.487/28.584 | 21.199/25.717 | 2.72 ms | n/a | 0.00 ms | 220.38 ms | n/a | measured |
| moui-md-skia-gpu | stress | scroll | ui-frame | 1.544/2.100 | - | 8.348/9.237 | - | 6.50 ms | n/a | 0.00 ms | 210.65 ms | n/a | measured |
| moui-md-wgpu | small | open | ui-frame | 42.843/52.005 | - | - | - | 12.98 ms | n/a | 0.00 ms | 57.80 ms | n/a | measured |
| moui-md-wgpu | small | input | ui-frame | 1.533/1.745 | - | 8.032/9.860 | 8.004/9.859 | 6.17 ms | n/a | 0.00 ms | 55.68 ms | n/a | measured |
| moui-md-wgpu | small | scroll | ui-frame | 1.309/1.588 | - | 8.313/9.497 | - | 6.77 ms | n/a | 0.00 ms | 53.56 ms | n/a | measured |
| moui-md-wgpu | medium | open | ui-frame | 39.525/41.676 | - | - | - | 13.27 ms | n/a | 0.00 ms | 55.79 ms | n/a | measured |
| moui-md-wgpu | medium | input | ui-frame | 1.545/1.802 | - | 8.093/9.430 | 8.061/9.429 | 6.07 ms | n/a | 0.00 ms | 55.47 ms | n/a | measured |
| moui-md-wgpu | medium | scroll | ui-frame | 1.353/1.769 | - | 8.304/9.852 | - | 6.69 ms | n/a | 0.00 ms | 60.69 ms | n/a | measured |
| moui-md-wgpu | large | open | ui-frame | 40.296/42.235 | - | - | - | 13.05 ms | n/a | 0.00 ms | 66.95 ms | n/a | measured |
| moui-md-wgpu | large | input | ui-frame | 1.549/1.669 | - | 8.335/9.729 | 8.282/9.728 | 4.80 ms | n/a | 0.00 ms | 68.87 ms | n/a | measured |
| moui-md-wgpu | large | scroll | ui-frame | 1.315/1.574 | - | 8.308/9.429 | - | 6.75 ms | n/a | 0.00 ms | 67.76 ms | n/a | measured |
| moui-md-wgpu | stress | open | ui-frame | 38.683/39.125 | - | - | - | 13.33 ms | n/a | 0.00 ms | 176.26 ms | n/a | measured |
| moui-md-wgpu | stress | input | ui-frame | 1.424/1.658 | - | 19.089/21.781 | 18.788/19.638 | 2.05 ms | n/a | 0.00 ms | 187.02 ms | n/a | measured |
| moui-md-wgpu | stress | scroll | ui-frame | 1.329/1.696 | - | 8.300/9.482 | - | 6.71 ms | n/a | 0.00 ms | 181.12 ms | n/a | measured |
| gpmark | small | open | ui-frame | 5.414/5.608 | - | - | - | n/a | n/a | n/a | 118.97 ms | n/a | measured |
| gpmark | small | input | ui-frame | 5.195/5.437 | 0.277/0.315 | 9.539/11.959 | 9.537/11.957 | n/a | n/a | n/a | 117.37 ms | n/a | measured |
| gpmark | small | scroll | ui-frame | 5.977/7.383 | 0.002/0.004 | 9.997/11.415 | - | n/a | n/a | n/a | 112.92 ms | n/a | measured |
| gpmark | medium | open | ui-frame | 5.269/5.291 | - | - | - | n/a | n/a | n/a | 117.32 ms | n/a | measured |
| gpmark | medium | input | ui-frame | 5.226/5.567 | 0.308/0.356 | 9.372/13.665 | 9.369/13.657 | n/a | n/a | n/a | 113.76 ms | n/a | measured |
| gpmark | medium | scroll | ui-frame | 5.948/7.312 | 0.002/0.004 | 9.965/11.948 | - | n/a | n/a | n/a | 117.38 ms | n/a | measured |
| gpmark | large | open | ui-frame | 5.295/5.391 | - | - | - | n/a | n/a | n/a | 118.58 ms | n/a | measured |
| gpmark | large | input | ui-frame | 5.162/5.422 | 0.653/0.943 | 9.639/13.422 | 9.637/13.421 | n/a | n/a | n/a | 115.59 ms | n/a | measured |
| gpmark | large | scroll | ui-frame | 5.941/7.357 | 0.002/0.004 | 10.009/11.926 | - | n/a | n/a | n/a | 116.66 ms | n/a | measured |
| gpmark | stress | open | ui-frame | 5.247/5.286 | - | - | - | n/a | n/a | n/a | 125.93 ms | n/a | measured |
| gpmark | stress | input | ui-frame | 5.261/5.449 | 4.344/4.746 | 11.347/14.321 | 11.345/14.320 | n/a | n/a | n/a | 128.51 ms | n/a | measured |
| gpmark | stress | scroll | ui-frame | 5.892/7.341 | 0.002/0.004 | 10.018/11.963 | - | n/a | n/a | n/a | 121.34 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 0.307/0.318 | - | - | - | 9.02 ms | n/a | n/a | 56.94 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 0.528/0.668 | - | 10.000/10.003 | 10.403/13.377 | 0.55 ms | n/a | n/a | 57.16 ms | 0 | measured |
| flutter-skia | small | scroll | ui-frame | 1.706/2.406 | - | 10.000/10.002 | - | 0.46 ms | n/a | n/a | 58.39 ms | 0 | measured |
| flutter-skia | medium | open | ui-frame | 0.313/0.335 | - | - | - | 8.67 ms | n/a | n/a | 56.45 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 0.535/0.631 | - | 10.000/10.004 | 10.506/14.688 | 0.54 ms | n/a | n/a | 56.25 ms | 0 | measured |
| flutter-skia | medium | scroll | ui-frame | 2.094/3.458 | - | 9.972/10.002 | - | 0.47 ms | n/a | n/a | 59.06 ms | 0 | measured |
| flutter-skia | large | open | ui-frame | 0.340/0.384 | - | - | - | 8.58 ms | n/a | n/a | 60.67 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 0.538/0.636 | - | 9.334/10.004 | 10.599/15.241 | 0.61 ms | n/a | n/a | 61.15 ms | 0 | measured |
| flutter-skia | large | scroll | ui-frame | 2.042/3.524 | - | 10.056/10.001 | - | 0.46 ms | n/a | n/a | 60.11 ms | 2 | measured |
| flutter-skia | stress | open | ui-frame | 0.303/0.315 | - | - | - | 8.62 ms | n/a | n/a | 89.66 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 0.529/0.638 | - | 10.000/10.003 | 9.980/11.631 | 0.56 ms | n/a | n/a | 89.27 ms | 0 | measured |
| flutter-skia | stress | scroll | ui-frame | 2.049/3.462 | - | 9.945/10.002 | - | 0.47 ms | n/a | n/a | 91.11 ms | 0 | measured |
| flutter-impeller | small | open | ui-frame | 0.355/0.380 | - | - | - | 6.94 ms | n/a | n/a | 56.90 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 0.551/0.694 | - | 9.000/10.003 | 10.932/15.495 | 0.68 ms | n/a | n/a | 59.87 ms | 0 | measured |
| flutter-impeller | small | scroll | ui-frame | 1.742/2.495 | - | 10.000/10.002 | - | 0.46 ms | n/a | n/a | 56.87 ms | 0 | measured |
| flutter-impeller | medium | open | ui-frame | 0.372/0.497 | - | - | - | 6.60 ms | n/a | n/a | 59.36 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 0.542/0.672 | - | 9.334/10.004 | 11.125/19.149 | 0.63 ms | n/a | n/a | 58.33 ms | 0 | measured |
| flutter-impeller | medium | scroll | ui-frame | 2.106/3.484 | - | 9.972/10.002 | - | 0.45 ms | n/a | n/a | 58.27 ms | 0 | measured |
| flutter-impeller | large | open | ui-frame | 0.293/0.310 | - | - | - | 6.64 ms | n/a | n/a | 59.03 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 0.549/0.714 | - | 9.334/10.004 | 10.866/16.124 | 0.61 ms | n/a | n/a | 62.39 ms | 0 | measured |
| flutter-impeller | large | scroll | ui-frame | 2.071/3.419 | - | 10.028/10.002 | - | 0.44 ms | n/a | n/a | 59.30 ms | 1 | measured |
| flutter-impeller | stress | open | ui-frame | 0.333/0.356 | - | - | - | 6.70 ms | n/a | n/a | 89.54 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 0.529/0.643 | - | 10.000/10.002 | 10.037/10.814 | 0.58 ms | n/a | n/a | 88.69 ms | 0 | measured |
| flutter-impeller | stress | scroll | ui-frame | 2.100/3.460 | - | 9.944/10.002 | - | 0.46 ms | n/a | n/a | 88.18 ms | 0 | measured |
| electron | small | open | ui-frame | 84.333/85.500 | - | - | - | n/a | n/a | n/a | 84.33 ms | 0 | measured |
| electron | small | input | ui-frame | 1.833/3.000 | - | 9.778/12.000 | 8.690/11.900 | n/a | n/a | n/a | 90.77 ms | 0 | measured |
| electron | small | scroll | ui-frame | 1.944/2.500 | - | 9.962/11.400 | - | n/a | n/a | n/a | 87.90 ms | 0 | measured |
| electron | medium | open | ui-frame | 87.967/90.800 | - | - | - | n/a | n/a | n/a | 87.97 ms | 0 | measured |
| electron | medium | input | ui-frame | 1.840/3.200 | - | 10.108/13.236 | 8.773/11.500 | n/a | n/a | n/a | 93.40 ms | 0 | measured |
| electron | medium | scroll | ui-frame | 2.013/2.600 | - | 9.916/11.500 | - | n/a | n/a | n/a | 84.77 ms | 0 | measured |
| electron | large | open | ui-frame | 85.767/86.800 | - | - | - | n/a | n/a | n/a | 85.77 ms | 0 | measured |
| electron | large | input | ui-frame | 1.770/2.500 | - | 9.771/13.436 | 8.610/11.700 | n/a | n/a | n/a | 88.77 ms | 0 | measured |
| electron | large | scroll | ui-frame | 2.032/2.500 | - | 9.957/11.400 | - | n/a | n/a | n/a | 95.57 ms | 0 | measured |
| electron | stress | open | ui-frame | 99.467/108.200 | - | - | - | n/a | n/a | n/a | 99.47 ms | 0 | measured |
| electron | stress | input | ui-frame | 1.747/2.300 | - | 8.607/11.800 | 8.327/11.700 | n/a | n/a | n/a | 94.97 ms | 0 | measured |
| electron | stress | scroll | ui-frame | 2.053/2.700 | - | 9.964/11.600 | - | n/a | n/a | n/a | 94.90 ms | 0 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.23/1.20/1.24 | 1.51/1.40/1.55 | n/a/n/a/n/a | 0.54/0.53/0.55 | 0.67/0.64/0.72 | 0.51/0.50/0.51 | 0.68/0.68/0.68 |
| MoUI Skia GPU | 8.33/8.33/8.33 | 9.18/9.20/9.12 | n/a/n/a/n/a | 1.05/1.11/1.15 | 1.62/1.65/1.72 | 6.84/6.75/6.73 | 7.97/7.95/7.94 |
| MoUI WGPU | 8.33/8.33/8.33 | 9.29/9.30/9.28 | n/a/n/a/n/a | 1.17/1.17/1.12 | 1.70/1.68/1.53 | 6.73/6.72/6.79 | 8.19/8.23/8.14 |
| MoMark Skia Raster | 3.02/2.97/2.98 | 3.76/3.55/3.64 | n/a/n/a/n/a | 0.90/0.91/0.90 | 1.11/1.13/1.08 | 2.00/1.95/1.97 | 2.56/2.35/2.41 |
| MoMark Skia GPU | 8.37/8.37/8.36 | 9.21/9.19/9.27 | n/a/n/a/n/a | 1.53/1.57/1.56 | 2.14/2.20/2.20 | 6.56/6.53/6.52 | 7.52/7.47/7.46 |
| MoMark WGPU | 8.31/8.30/8.31 | 9.50/9.85/9.43 | n/a/n/a/n/a | 1.31/1.35/1.32 | 1.59/1.77/1.57 | 6.77/6.69/6.75 | 7.83/7.99/7.77 |
| GpMark.mbt (GPUI) | 10.00/9.96/10.01 | 11.41/11.95/11.93 | n/a/n/a/n/a | 5.98/5.95/5.94 | 7.38/7.31/7.36 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 10.00/9.97/10.06 | 10.00/10.00/10.00 | 0/0/2 | 1.71/2.09/2.04 | 2.41/3.46/3.52 | 0.46/0.47/0.46 | 0.65/0.72/0.71 |
| Flutter Impeller | 10.00/9.97/10.03 | 10.00/10.00/10.00 | 0/0/1 | 1.74/2.11/2.07 | 2.50/3.48/3.42 | 0.46/0.45/0.44 | 0.63/0.67/0.64 |
| Electron | 9.96/9.92/9.96 | 11.40/11.50/11.40 | 0/0/0 | 1.94/2.01/2.03 | 2.50/2.60/2.50 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.21 | 1.39 | n/a | 0.54 | 0.66 | 0.50 | 0.64 |
| MoUI Skia GPU | 8.33 | 9.14 | n/a | 1.11 | 1.70 | 6.77 | 7.94 |
| MoUI WGPU | 8.33 | 9.27 | n/a | 1.11 | 1.61 | 6.80 | 8.23 |
| MoMark Skia Raster | 3.00 | 3.62 | n/a | 0.90 | 1.10 | 1.97 | 2.41 |
| MoMark Skia GPU | 8.35 | 9.24 | n/a | 1.54 | 2.10 | 6.50 | 7.54 |
| MoMark WGPU | 8.30 | 9.48 | n/a | 1.33 | 1.70 | 6.71 | 8.00 |
| GpMark.mbt (GPUI) | 10.02 | 11.96 | n/a | 5.89 | 7.34 | n/a | n/a |
| Flutter Skia | 9.94 | 10.00 | 0 | 2.05 | 3.46 | 0.47 | 0.71 |
| Flutter Impeller | 9.94 | 10.00 | 0 | 2.10 | 3.46 | 0.46 | 0.72 |
| Electron | 9.96 | 11.60 | 0 | 2.05 | 2.70 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.37/1.31/1.49 | 1.75/1.55/1.94 | 0.51/0.49/0.51 | 0.71/0.54/0.66 | 0.72/0.67/0.69 | 1.11/0.84/0.94 |
| MoUI Skia GPU | 8.38/8.36/8.36 | 9.00/9.12/9.40 | 0.59/0.58/0.59 | 0.68/0.67/0.69 | 7.58/7.56/7.34 | 8.21/8.26/8.40 |
| MoUI WGPU | 8.27/8.23/8.27 | 9.04/9.12/9.29 | 0.56/0.55/0.57 | 0.68/0.65/0.66 | 7.51/7.47/7.33 | 8.28/8.37/8.33 |
| MoMark Skia Raster | 5.47/5.93/6.91 | 5.84/7.01/7.10 | 3.00/3.17/3.08 | 3.29/4.16/3.37 | 2.25/2.40/2.29 | 2.71/3.18/2.73 |
| MoMark Skia GPU | 8.71/8.74/9.39 | 10.11/10.06/11.09 | 3.17/3.10/3.16 | 3.47/3.41/3.50 | 5.27/5.26/4.60 | 6.64/6.64/6.48 |
| MoMark WGPU | 8.00/8.06/8.28 | 9.86/9.43/9.73 | 1.53/1.55/1.55 | 1.74/1.80/1.67 | 6.17/6.07/4.80 | 8.14/7.50/6.43 |
| GpMark.mbt (GPUI) | 9.54/9.37/9.64 | 11.96/13.66/13.42 | 5.19/5.23/5.16 | 5.44/5.57/5.42 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 10.40/10.51/10.60 | 13.38/14.69/15.24 | 0.53/0.54/0.54 | 0.67/0.63/0.64 | 0.55/0.54/0.61 | 1.09/1.00/1.34 |
| Flutter Impeller | 10.93/11.13/10.87 | 15.49/19.15/16.12 | 0.55/0.54/0.55 | 0.69/0.67/0.71 | 0.68/0.63/0.61 | 1.63/1.48/1.51 |
| Electron | 8.69/8.77/8.61 | 11.90/11.50/11.70 | 1.83/1.84/1.77 | 3.00/3.20/2.50 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 3.53 | 4.38 | 0.58 | 0.72 | 0.78 | 1.08 |
| MoUI Skia GPU | 8.50 | 9.22 | 0.60 | 0.68 | 5.44 | 6.53 |
| MoUI WGPU | 8.48 | 9.91 | 0.61 | 0.83 | 5.14 | 6.58 |
| MoMark Skia Raster | 21.20 | 22.01 | 3.42 | 3.98 | 2.57 | 3.08 |
| MoMark Skia GPU | 21.20 | 25.72 | 3.45 | 3.94 | 2.72 | 7.24 |
| MoMark WGPU | 18.79 | 19.64 | 1.42 | 1.66 | 2.05 | 2.78 |
| GpMark.mbt (GPUI) | 11.34 | 14.32 | 5.26 | 5.45 | n/a | n/a |
| Flutter Skia | 9.98 | 11.63 | 0.53 | 0.64 | 0.56 | 1.16 |
| Flutter Impeller | 10.04 | 10.81 | 0.53 | 0.64 | 0.58 | 1.08 |
| Electron | 8.33 | 11.70 | 1.75 | 2.30 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 52.03/51.53/54.36 | 52.95/51.67/54.53 | 0.06/0.26/2.41 | 0.07/0.30/2.46 | 46.47/45.74/46.97 | 47.65/45.82/47.05 | 4.42/4.41/4.36 | 4.61/4.50/4.44 |
| MoUI Skia GPU | 57.35/56.96/58.21 | 58.07/57.91/61.16 | 0.07/0.30/2.47 | 0.10/0.33/2.50 | 44.22/44.37/43.96 | 44.36/45.52/46.34 | 11.97/11.22/11.17 | 12.67/12.47/11.55 |
| MoUI WGPU | 50.46/49.91/51.91 | 51.16/50.42/53.44 | 0.07/0.31/2.31 | 0.07/0.32/2.34 | 39.46/38.77/38.87 | 40.27/39.03/40.37 | 9.76/9.71/9.83 | 9.85/10.02/9.90 |
| MoMark Skia Raster | 59.27/61.91/73.02 | 60.86/62.89/73.89 | 0.06/0.28/2.01 | 0.07/0.30/2.37 | 46.62/47.91/47.98 | 48.15/48.67/49.49 | 10.96/11.19/11.48 | 11.10/11.33/11.71 |
| MoMark Skia GPU | 80.85/81.13/91.38 | 81.21/82.48/92.82 | 0.08/0.28/2.43 | 0.09/0.28/2.51 | 45.96/45.58/45.78 | 47.32/47.39/46.17 | 33.19/32.76/31.17 | 34.28/35.40/32.15 |
| MoMark WGPU | 57.80/55.79/66.95 | 66.44/57.52/69.17 | 0.08/0.26/2.10 | 0.15/0.35/2.51 | 42.84/39.53/40.30 | 52.01/41.68/42.24 | 12.98/13.27/13.05 | 13.30/13.54/13.40 |
| GpMark.mbt (GPUI) | 118.97/117.32/118.58 | 121.20/120.19/121.04 | 0.33/0.00/2.33 | 1.00/0.00/3.00 | 5.41/5.27/5.29 | 5.61/5.29/5.39 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 56.94/56.45/60.67 | 57.76/56.78/61.60 | 0.09/0.15/0.35 | 0.10/0.21/0.36 | 0.31/0.31/0.34 | 0.32/0.34/0.38 | 9.02/8.67/8.58 | 9.31/8.87/8.79 |
| Flutter Impeller | 56.90/59.36/59.03 | 58.35/59.61/61.40 | 0.08/0.11/0.39 | 0.09/0.11/0.43 | 0.36/0.37/0.29 | 0.38/0.50/0.31 | 6.94/6.60/6.64 | 7.21/6.65/7.15 |
| Electron | 84.33/87.97/85.77 | 85.50/90.80/86.80 | 5.20/5.21/5.34 | 6.07/6.34/6.01 | 84.33/87.97/85.77 | 85.50/90.80/86.80 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 70.47 | 71.49 | 24.15 | 25.79 | 46.41 | 47.82 | 4.19 | 4.31 |
| MoUI Skia GPU | 76.01 | 77.79 | 22.68 | 25.47 | 44.62 | 45.08 | 11.34 | 12.67 |
| MoUI WGPU | 68.88 | 70.89 | 20.27 | 24.50 | 39.47 | 41.15 | 9.56 | 9.62 |
| MoMark Skia Raster | 186.34 | 186.81 | 24.65 | 25.35 | 47.45 | 49.05 | 11.11 | 11.34 |
| MoMark Skia GPU | 200.48 | 208.68 | 16.61 | 19.75 | 44.98 | 46.44 | 35.63 | 39.70 |
| MoMark WGPU | 176.26 | 182.78 | 20.19 | 25.50 | 38.68 | 39.12 | 13.33 | 13.81 |
| GpMark.mbt (GPUI) | 125.93 | 128.60 | 25.67 | 27.00 | 5.25 | 5.29 | n/a | n/a |
| Flutter Skia | 89.66 | 92.67 | 2.87 | 2.99 | 0.30 | 0.32 | 8.62 | 8.72 |
| Flutter Impeller | 89.54 | 90.87 | 3.11 | 3.28 | 0.33 | 0.36 | 6.70 | 7.04 |
| Electron | 99.47 | 108.20 | 6.36 | 7.81 | 99.47 | 108.20 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.23/1.20/1.24 | 1.51/1.40/1.55 | n/a/n/a/n/a | 0.54/0.53/0.55 | 0.67/0.64/0.72 | 0.51/0.50/0.51 | 0.68/0.68/0.68 |
| MoUI Skia GPU | 8.33/8.33/8.33 | 9.18/9.20/9.12 | n/a/n/a/n/a | 1.05/1.11/1.15 | 1.62/1.65/1.72 | 6.84/6.75/6.73 | 7.97/7.95/7.94 |
| MoUI WGPU | 8.33/8.33/8.33 | 9.29/9.30/9.28 | n/a/n/a/n/a | 1.17/1.17/1.12 | 1.70/1.68/1.53 | 6.73/6.72/6.79 | 8.19/8.23/8.14 |
| MoMark Skia Raster | 3.02/2.97/2.98 | 3.76/3.55/3.64 | n/a/n/a/n/a | 0.90/0.91/0.90 | 1.11/1.13/1.08 | 2.00/1.95/1.97 | 2.56/2.35/2.41 |
| MoMark Skia GPU | 8.37/8.37/8.36 | 9.21/9.19/9.27 | n/a/n/a/n/a | 1.53/1.57/1.56 | 2.14/2.20/2.20 | 6.56/6.53/6.52 | 7.52/7.47/7.46 |
| MoMark WGPU | 8.31/8.30/8.31 | 9.50/9.85/9.43 | n/a/n/a/n/a | 1.31/1.35/1.32 | 1.59/1.77/1.57 | 6.77/6.69/6.75 | 7.83/7.99/7.77 |
| GpMark.mbt (GPUI) | 10.00/9.96/10.01 | 11.41/11.95/11.93 | n/a/n/a/n/a | 5.98/5.95/5.94 | 7.38/7.31/7.36 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 10.00/9.97/10.06 | 10.00/10.00/10.00 | 0/0/2 | 1.71/2.09/2.04 | 2.41/3.46/3.52 | 0.46/0.47/0.46 | 0.65/0.72/0.71 |
| Flutter Impeller | 10.00/9.97/10.03 | 10.00/10.00/10.00 | 0/0/1 | 1.74/2.11/2.07 | 2.50/3.48/3.42 | 0.46/0.45/0.44 | 0.63/0.67/0.64 |
| Electron | 9.96/9.92/9.96 | 11.40/11.50/11.40 | 0/0/0 | 1.94/2.01/2.03 | 2.50/2.60/2.50 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.21 | 1.39 | n/a | 0.54 | 0.66 | 0.50 | 0.64 |
| MoUI Skia GPU | 8.33 | 9.14 | n/a | 1.11 | 1.70 | 6.77 | 7.94 |
| MoUI WGPU | 8.33 | 9.27 | n/a | 1.11 | 1.61 | 6.80 | 8.23 |
| MoMark Skia Raster | 3.00 | 3.62 | n/a | 0.90 | 1.10 | 1.97 | 2.41 |
| MoMark Skia GPU | 8.35 | 9.24 | n/a | 1.54 | 2.10 | 6.50 | 7.54 |
| MoMark WGPU | 8.30 | 9.48 | n/a | 1.33 | 1.70 | 6.71 | 8.00 |
| GpMark.mbt (GPUI) | 10.02 | 11.96 | n/a | 5.89 | 7.34 | n/a | n/a |
| Flutter Skia | 9.94 | 10.00 | 0 | 2.05 | 3.46 | 0.47 | 0.71 |
| Flutter Impeller | 9.94 | 10.00 | 0 | 2.10 | 3.46 | 0.46 | 0.72 |
| Electron | 9.96 | 11.60 | 0 | 2.05 | 2.70 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoMark Skia Raster stress 186.3 ms（max 186.8 ms）；MoMark Skia GPU stress 200.5 ms（max 208.7 ms）；MoMark WGPU stress 176.3 ms（max 182.8 ms）；GpMark.mbt (GPUI) small 119.0 ms（max 121.2 ms）；GpMark.mbt (GPUI) medium 117.3 ms（max 120.2 ms）；GpMark.mbt (GPUI) large 118.6 ms（max 121.0 ms）；GpMark.mbt (GPUI) stress 125.9 ms（max 128.6 ms）；Electron stress 99.5 ms（max 108.2 ms）。
- P1 输入尾延迟：MoMark Skia Raster stress P95 22.01 ms；MoMark Skia GPU stress P95 25.72 ms；MoMark WGPU stress P95 19.64 ms；Flutter Impeller medium P95 19.15 ms。
- 长帧（超预算）：MoMark Skia Raster: stress/input 30 次，max 24.58 ms；MoMark Skia GPU: stress/input 30 次，max 29.56 ms；MoMark WGPU: stress/input 30 次，max 22.07 ms；GpMark.mbt (GPUI): small/scroll 1 次，max 17.93 ms, large/scroll 2 次，max 18.08 ms, stress/input 1 次，max 19.63 ms, stress/scroll 2 次，max 18.19 ms；Flutter Skia: large/scroll 2 次，max 20.00 ms；Flutter Impeller: large/scroll 1 次，max 20.00 ms。
- 丢帧（优先处理）：Flutter Skia: large/scroll 2 帧；Flutter Impeller: large/scroll 1 帧。
- 解释：首帧异常优先检查窗口/渲染器初始化；输入尾延迟检查 action 到下一可见帧的调度与同步重建；长帧检查解析、布局、文本 shaping 和 GPU 提交；`n/a` 表示未埋点，不等于 0。
- 普通模式的长帧、帧间隔和输入延迟是各框架回调诊断，不能替代跨框架 compositor 排名；需要严格结论时运行 `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`。

## 采集口径

- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。
- `frame_work_ms` 统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏；对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `device_present_ms`：设备/上屏侧统一字段。MoUI raster 为 Skia CPU 光栅化+像素回读整体；MoUI GPU/wgpu 为提交后同步等待设备完成（headless host-surface 逐帧同步，真实应用的 vsync 流水线可重叠掉一部分，该值应视为上屏成本上界）；窗口模式（`window_mode=native-window`）下 MoUI 由真实 AppKit 窗口上屏，适配器侧不单独计时，显示 `n/a`；Flutter 为 `FrameTiming.rasterDuration`（光栅线程任务时间，含显示列表光栅化与 GPU 提交、不含设备完成等待）；GPUI 与 Electron 适配器侧无法观测，显示 `n/a`。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧；窗口模式（MoUI `native-window`）取帧时钟观察到的首个窗口帧完成，含 AppKit 窗口创建成本；严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代；打开场景没有前一帧，所以不计算 interval/drop。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。
