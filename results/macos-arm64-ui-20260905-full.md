# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-05T14:08:01Z`
- 数据状态：`360 measured`，`0 skipped/error`；原始样本保留在 JSON。
- Host：`macOS-26.3-arm64-arm-64bit` / `arm64` / `16.0 GiB`；GPU：`Apple M4`
- OS：`25.3.0`；CPU：`arm`；toolchains：`python=3.12.11, moon=moon 0.1.20260824 (dae026a 2026-08-24), rustc=rustc 1.94.0 (4a4ef493e 2026-03-02), cargo=cargo 1.94.0 (85eff7c80 2026-01-15), node=v25.2.1, npm=11.6.2, flutter=Flutter 3.47.1 • channel stable • https://github.com/flutter/flutter.git`
- 统一配置：`1280x800 @ 60 Hz`；font `system-ui 16px`；line-height `1.55`；overscan `3`；fixed row `66px`；GPU backend `Metal`
- Fixture：`small=5KB/100 blocks`，`medium=50KB/1,000 blocks`，`large=500KB/10,000 blocks`，`stress=5MB/100,000 blocks`。
- 本次执行集合：`small, medium, large, stress`；未执行集合在矩阵中显示 `n/a`，不参与比较。
- 汇总口径：mean/P95 合并原始样本；每格 repetition `3`、process warm-up `1`；drop 为各 repetition dropped_display_frames 之和。
- 公平性口径：所有 ui-frame 记录使用相同 fixture、viewport、动作数、warm-up 和重复次数。`工作`（frame_work）统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏：MoUI 为 build+layout+paint+draw，Flutter 为 UI 线程 buildDuration，GPUI 为 request_layout→prepaint→paint，Electron 为 JS 可见的 DOM 更新+layout。设备光栅化与上屏统一单列为 `设备侧`（device_present）：MoUI 为同步光栅化/present 完成（无头 harness 逐帧同步，无流水线重叠），Flutter 为光栅线程 rasterDuration（不含设备完成等待），GPUI 与 Electron 无法在适配器侧观测显示链路，显示 `n/a`。MoUI ui-frame 是 headless host-surface；GPUI 的 action dispatch 另列为诊断字段。不同框架的显示时间戳由各自平台 API 提供，帧间隔覆盖完整链路，报告不做跨时钟的综合排名。`n/a` 表示没有采集，绝不等同于 0。

- `moui-md-*` 行来自 `momark`（MoMark，原 `vendor/MoUI/examples/markdown_editor`）官方示例应用：fixture 通过应用自身的 `OpenRecentDocument` 服务路径打开，渲染经过示例自己的虚拟滚动与富文本缓存实现，不套用简化基准应用的 `fixed row 66px` 统一行高；viewport、fixture、动作数、warm-up 与重复次数与其他行完全一致。严格模式（`UI_BENCHMARK_SYSTEM_TRACE=1`）目前不为 `moui-md-*` 行采集系统 present，这些行会显示 error。

<details><summary>原始 ui-frame 汇总（可审计）</summary>

| 实现 | 测试集合 | 场景 | 范围 | 工作均值/P95 | 仅分发均值/P95 | 帧间隔均值/P95 | 输入到可见均值/P95 | 设备侧均值 | 离屏均值 | 回读均值 | 首次可交互 | 丢帧数 | 状态 |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| moui-skia-raster | small | open | ui-frame | 53.663/56.661 | - | - | - | 5.26 ms | 0.00 ms | 5.26 ms | 60.17 ms | n/a | measured |
| moui-skia-raster | small | input | ui-frame | 0.551/0.601 | - | 1.699/1.909 | 1.698/1.909 | 0.98 ms | 0.00 ms | 0.98 ms | 58.95 ms | n/a | measured |
| moui-skia-raster | small | scroll | ui-frame | 1.619/3.296 | - | 3.058/5.366 | - | 0.85 ms | 0.00 ms | 0.85 ms | 60.16 ms | n/a | measured |
| moui-skia-raster | medium | open | ui-frame | 56.184/60.053 | - | - | - | 5.49 ms | 0.00 ms | 5.49 ms | 63.20 ms | n/a | measured |
| moui-skia-raster | medium | input | ui-frame | 0.599/0.872 | - | 1.885/2.475 | 1.884/2.474 | 1.08 ms | 0.00 ms | 1.08 ms | 64.52 ms | n/a | measured |
| moui-skia-raster | medium | scroll | ui-frame | 1.581/3.299 | - | 2.933/5.422 | - | 0.78 ms | 0.00 ms | 0.78 ms | 58.76 ms | n/a | measured |
| moui-skia-raster | large | open | ui-frame | 54.886/56.686 | - | - | - | 5.67 ms | 0.00 ms | 5.67 ms | 63.76 ms | n/a | measured |
| moui-skia-raster | large | input | ui-frame | 0.938/3.347 | - | 3.465/9.279 | 3.464/9.279 | 1.92 ms | 0.00 ms | 1.92 ms | 68.90 ms | n/a | measured |
| moui-skia-raster | large | scroll | ui-frame | 1.598/3.333 | - | 2.955/5.238 | - | 0.78 ms | 0.00 ms | 0.78 ms | 67.05 ms | n/a | measured |
| moui-skia-raster | stress | open | ui-frame | 55.793/58.348 | - | - | - | 4.82 ms | 0.00 ms | 4.82 ms | 80.89 ms | n/a | measured |
| moui-skia-raster | stress | input | ui-frame | 0.799/1.256 | - | 6.304/8.764 | 6.303/8.762 | 1.24 ms | 0.00 ms | 1.24 ms | 79.60 ms | n/a | measured |
| moui-skia-raster | stress | scroll | ui-frame | 1.619/3.355 | - | 3.042/5.412 | - | 0.84 ms | 0.00 ms | 0.84 ms | 82.20 ms | n/a | measured |
| moui-skia-gpu | small | open | ui-frame | 49.237/49.858 | - | - | - | 15.93 ms | n/a | 0.00 ms | 66.41 ms | n/a | measured |
| moui-skia-gpu | small | input | ui-frame | 0.695/0.828 | - | 8.275/9.502 | 8.273/9.502 | 7.33 ms | n/a | 0.00 ms | 66.32 ms | n/a | measured |
| moui-skia-gpu | small | scroll | ui-frame | 1.720/3.391 | - | 8.331/9.291 | - | 5.93 ms | n/a | 0.00 ms | 67.79 ms | n/a | measured |
| moui-skia-gpu | medium | open | ui-frame | 50.222/51.628 | - | - | - | 13.12 ms | n/a | 0.00 ms | 64.75 ms | n/a | measured |
| moui-skia-gpu | medium | input | ui-frame | 0.688/0.872 | - | 8.344/9.505 | 8.343/9.503 | 7.40 ms | n/a | 0.00 ms | 65.76 ms | n/a | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 1.757/3.338 | - | 8.334/9.293 | - | 5.88 ms | n/a | 0.00 ms | 67.46 ms | n/a | measured |
| moui-skia-gpu | large | open | ui-frame | 49.062/51.189 | - | - | - | 14.26 ms | n/a | 0.00 ms | 66.53 ms | n/a | measured |
| moui-skia-gpu | large | input | ui-frame | 0.760/0.898 | - | 8.360/9.264 | 8.358/9.264 | 7.08 ms | n/a | 0.00 ms | 86.45 ms | n/a | measured |
| moui-skia-gpu | large | scroll | ui-frame | 1.716/3.271 | - | 8.335/9.269 | - | 5.94 ms | n/a | 0.00 ms | 65.50 ms | n/a | measured |
| moui-skia-gpu | stress | open | ui-frame | 51.153/52.179 | - | - | - | 13.70 ms | n/a | 0.00 ms | 84.82 ms | n/a | measured |
| moui-skia-gpu | stress | input | ui-frame | 0.747/0.909 | - | 8.971/10.160 | 8.970/10.160 | 4.71 ms | n/a | 0.00 ms | 87.17 ms | n/a | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 1.757/3.592 | - | 8.333/9.369 | - | 5.88 ms | n/a | 0.00 ms | 83.74 ms | n/a | measured |
| moui-wgpu | small | open | ui-frame | 58.821/59.485 | - | - | - | 11.66 ms | n/a | 0.00 ms | 71.88 ms | n/a | measured |
| moui-wgpu | small | input | ui-frame | 0.704/0.878 | - | 8.041/9.616 | 8.040/9.615 | 7.04 ms | n/a | 0.00 ms | 64.62 ms | n/a | measured |
| moui-wgpu | small | scroll | ui-frame | 1.808/3.404 | - | 8.335/9.449 | - | 5.82 ms | n/a | 0.00 ms | 67.43 ms | n/a | measured |
| moui-wgpu | medium | open | ui-frame | 57.490/57.753 | - | - | - | 12.52 ms | n/a | 0.00 ms | 71.78 ms | n/a | measured |
| moui-wgpu | medium | input | ui-frame | 0.708/0.905 | - | 8.231/9.397 | 8.230/9.397 | 7.23 ms | n/a | 0.00 ms | 65.07 ms | n/a | measured |
| moui-wgpu | medium | scroll | ui-frame | 1.792/3.424 | - | 8.320/9.413 | - | 5.83 ms | n/a | 0.00 ms | 64.70 ms | n/a | measured |
| moui-wgpu | large | open | ui-frame | 56.219/56.600 | - | - | - | 11.72 ms | n/a | 0.00 ms | 71.16 ms | n/a | measured |
| moui-wgpu | large | input | ui-frame | 0.701/0.899 | - | 8.109/9.465 | 8.108/9.465 | 6.89 ms | n/a | 0.00 ms | 74.56 ms | n/a | measured |
| moui-wgpu | large | scroll | ui-frame | 1.790/3.382 | - | 8.331/9.526 | - | 5.85 ms | n/a | 0.00 ms | 67.32 ms | n/a | measured |
| moui-wgpu | stress | open | ui-frame | 51.832/54.705 | - | - | - | 11.16 ms | n/a | 0.00 ms | 83.02 ms | n/a | measured |
| moui-wgpu | stress | input | ui-frame | 0.677/0.870 | - | 8.329/9.532 | 8.329/9.532 | 4.59 ms | n/a | 0.00 ms | 85.94 ms | n/a | measured |
| moui-wgpu | stress | scroll | ui-frame | 1.769/3.404 | - | 8.331/9.423 | - | 5.88 ms | n/a | 0.00 ms | 88.83 ms | n/a | measured |
| moui-md-skia-raster | small | open | ui-frame | 54.294/56.950 | - | - | - | 13.17 ms | 0.00 ms | 13.17 ms | 69.37 ms | n/a | measured |
| moui-md-skia-raster | small | input | ui-frame | 3.881/4.694 | - | 7.416/9.147 | 7.386/9.145 | 3.09 ms | 0.00 ms | 3.09 ms | 72.92 ms | n/a | measured |
| moui-md-skia-raster | small | scroll | ui-frame | 1.023/1.254 | - | 3.590/4.419 | - | 2.39 ms | 0.00 ms | 2.39 ms | 77.90 ms | n/a | measured |
| moui-md-skia-raster | medium | open | ui-frame | 54.898/55.518 | - | - | - | 13.68 ms | 0.00 ms | 13.68 ms | 72.22 ms | n/a | measured |
| moui-md-skia-raster | medium | input | ui-frame | 3.801/4.296 | - | 7.676/8.352 | 7.648/8.351 | 2.91 ms | 0.00 ms | 2.91 ms | 72.17 ms | n/a | measured |
| moui-md-skia-raster | medium | scroll | ui-frame | 1.053/1.447 | - | 3.838/4.923 | - | 2.56 ms | 0.00 ms | 2.56 ms | 75.13 ms | n/a | measured |
| moui-md-skia-raster | large | open | ui-frame | 55.070/57.721 | - | - | - | 14.46 ms | 0.00 ms | 14.46 ms | 88.74 ms | n/a | measured |
| moui-md-skia-raster | large | input | ui-frame | 4.894/5.356 | - | 14.907/15.844 | 14.882/15.844 | 3.01 ms | 0.00 ms | 3.01 ms | 89.20 ms | n/a | measured |
| moui-md-skia-raster | large | scroll | ui-frame | 1.042/1.426 | - | 3.946/4.879 | - | 2.48 ms | 0.00 ms | 2.48 ms | 91.90 ms | n/a | measured |
| moui-md-skia-raster | stress | open | ui-frame | 63.730/64.274 | - | - | - | 12.44 ms | 0.00 ms | 12.44 ms | 255.48 ms | n/a | measured |
| moui-md-skia-raster | stress | input | ui-frame | 13.045/13.903 | - | 90.204/98.813 | 90.179/98.813 | 3.26 ms | 0.00 ms | 3.26 ms | 270.05 ms | n/a | measured |
| moui-md-skia-raster | stress | scroll | ui-frame | 1.098/1.375 | - | 6.620/8.076 | - | 2.58 ms | 0.00 ms | 2.58 ms | 269.14 ms | n/a | measured |
| moui-md-skia-gpu | small | open | ui-frame | 56.172/63.437 | - | - | - | 37.41 ms | n/a | 0.00 ms | 95.55 ms | n/a | measured |
| moui-md-skia-gpu | small | input | ui-frame | 3.769/4.491 | - | 9.490/11.361 | 9.455/11.360 | 5.24 ms | n/a | 0.00 ms | 89.73 ms | n/a | measured |
| moui-md-skia-gpu | small | scroll | ui-frame | 1.198/1.741 | - | 8.351/9.337 | - | 6.87 ms | n/a | 0.00 ms | 100.43 ms | n/a | measured |
| moui-md-skia-gpu | medium | open | ui-frame | 54.224/55.631 | - | - | - | 46.39 ms | n/a | 0.00 ms | 104.22 ms | n/a | measured |
| moui-md-skia-gpu | medium | input | ui-frame | 3.908/4.160 | - | 9.858/11.146 | 9.829/11.145 | 4.56 ms | n/a | 0.00 ms | 106.02 ms | n/a | measured |
| moui-md-skia-gpu | medium | scroll | ui-frame | 1.196/1.713 | - | 8.353/9.457 | - | 6.86 ms | n/a | 0.00 ms | 108.03 ms | n/a | measured |
| moui-md-skia-gpu | large | open | ui-frame | 49.981/51.216 | - | - | - | 25.29 ms | n/a | 0.00 ms | 94.23 ms | n/a | measured |
| moui-md-skia-gpu | large | input | ui-frame | 5.409/6.015 | - | 17.352/20.904 | 17.315/20.904 | 5.01 ms | n/a | 0.00 ms | 122.91 ms | n/a | measured |
| moui-md-skia-gpu | large | scroll | ui-frame | 1.155/1.687 | - | 8.351/9.307 | - | 6.65 ms | n/a | 0.00 ms | 124.12 ms | n/a | measured |
| moui-md-skia-gpu | stress | open | ui-frame | 59.850/63.837 | - | - | - | 37.03 ms | n/a | 0.00 ms | 278.13 ms | n/a | measured |
| moui-md-skia-gpu | stress | input | ui-frame | 13.628/16.666 | - | 97.166/109.026 | 97.138/109.025 | 3.98 ms | n/a | 0.00 ms | 296.39 ms | n/a | measured |
| moui-md-skia-gpu | stress | scroll | ui-frame | 1.098/1.343 | - | 9.716/10.525 | - | 5.15 ms | n/a | 0.00 ms | 270.06 ms | n/a | measured |
| moui-md-wgpu | small | open | ui-frame | 58.269/60.191 | - | - | - | 16.91 ms | n/a | 0.00 ms | 77.39 ms | n/a | measured |
| moui-md-wgpu | small | input | ui-frame | 1.752/2.071 | - | 12.088/27.718 | 12.048/27.717 | 9.81 ms | n/a | 0.00 ms | 78.79 ms | n/a | measured |
| moui-md-wgpu | small | scroll | ui-frame | 1.377/1.751 | - | 11.185/26.907 | - | 9.50 ms | n/a | 0.00 ms | 77.86 ms | n/a | measured |
| moui-md-wgpu | medium | open | ui-frame | 56.409/56.640 | - | - | - | 16.55 ms | n/a | 0.00 ms | 76.65 ms | n/a | measured |
| moui-md-wgpu | medium | input | ui-frame | 1.889/2.425 | - | 11.268/26.563 | 11.232/26.561 | 8.19 ms | n/a | 0.00 ms | 78.39 ms | n/a | measured |
| moui-md-wgpu | medium | scroll | ui-frame | 1.592/1.910 | - | 11.832/26.774 | - | 9.86 ms | n/a | 0.00 ms | 77.80 ms | n/a | measured |
| moui-md-wgpu | large | open | ui-frame | 56.575/58.324 | - | - | - | 15.92 ms | n/a | 0.00 ms | 91.54 ms | n/a | measured |
| moui-md-wgpu | large | input | ui-frame | 2.457/2.855 | - | 12.463/14.467 | 12.434/14.467 | 2.69 ms | n/a | 0.00 ms | 99.70 ms | n/a | measured |
| moui-md-wgpu | large | scroll | ui-frame | 1.416/1.814 | - | 11.355/26.699 | - | 9.38 ms | n/a | 0.00 ms | 94.41 ms | n/a | measured |
| moui-md-wgpu | stress | open | ui-frame | 65.078/66.879 | - | - | - | 15.81 ms | n/a | 0.00 ms | 264.13 ms | n/a | measured |
| moui-md-wgpu | stress | input | ui-frame | 10.176/10.512 | - | 93.899/104.084 | 93.869/104.083 | 2.77 ms | n/a | 0.00 ms | 267.95 ms | n/a | measured |
| moui-md-wgpu | stress | scroll | ui-frame | 1.466/1.829 | - | 12.746/28.083 | - | 7.56 ms | n/a | 0.00 ms | 266.31 ms | n/a | measured |
| gpmark | small | open | ui-frame | 7.854/8.146 | - | - | - | n/a | n/a | n/a | 155.15 ms | n/a | measured |
| gpmark | small | input | ui-frame | 7.278/7.680 | 0.433/0.531 | 10.907/20.888 | 10.904/20.887 | n/a | n/a | n/a | 150.54 ms | n/a | measured |
| gpmark | small | scroll | ui-frame | 8.549/10.546 | 0.002/0.004 | 10.551/13.236 | - | n/a | n/a | n/a | 157.23 ms | n/a | measured |
| gpmark | medium | open | ui-frame | 7.999/8.566 | - | - | - | n/a | n/a | n/a | 160.11 ms | n/a | measured |
| gpmark | medium | input | ui-frame | 7.242/7.685 | 0.463/0.572 | 11.094/20.279 | 11.091/20.275 | n/a | n/a | n/a | 158.59 ms | n/a | measured |
| gpmark | medium | scroll | ui-frame | 8.401/10.494 | 0.002/0.004 | 10.429/12.645 | - | n/a | n/a | n/a | 159.98 ms | n/a | measured |
| gpmark | large | open | ui-frame | 8.533/9.048 | - | - | - | n/a | n/a | n/a | 163.03 ms | n/a | measured |
| gpmark | large | input | ui-frame | 7.520/7.934 | 0.939/1.573 | 11.154/20.014 | 11.151/20.012 | n/a | n/a | n/a | 162.80 ms | n/a | measured |
| gpmark | large | scroll | ui-frame | 8.414/10.489 | 0.002/0.004 | 10.388/12.808 | - | n/a | n/a | n/a | 177.80 ms | n/a | measured |
| gpmark | stress | open | ui-frame | 7.896/8.317 | - | - | - | n/a | n/a | n/a | 156.92 ms | n/a | measured |
| gpmark | stress | input | ui-frame | 7.434/7.826 | 5.557/6.543 | 15.866/26.708 | 15.863/26.707 | n/a | n/a | n/a | 154.86 ms | n/a | measured |
| gpmark | stress | scroll | ui-frame | 8.512/10.633 | 0.002/0.004 | 10.608/12.919 | - | n/a | n/a | n/a | 187.50 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 0.344/0.443 | - | - | - | 10.75 ms | n/a | n/a | 77.21 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 0.647/0.984 | - | 10.334/20.002 | 10.531/16.271 | 0.95 ms | n/a | n/a | 84.43 ms | 3 | measured |
| flutter-skia | small | scroll | ui-frame | 1.249/1.847 | - | 10.000/10.003 | - | 0.40 ms | n/a | n/a | 81.01 ms | 1 | measured |
| flutter-skia | medium | open | ui-frame | 0.409/0.533 | - | - | - | 11.18 ms | n/a | n/a | 87.21 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 0.623/1.020 | - | 10.667/20.000 | 11.366/20.767 | 0.75 ms | n/a | n/a | 92.05 ms | 4 | measured |
| flutter-skia | medium | scroll | ui-frame | 1.723/2.454 | - | 10.028/10.003 | - | 0.42 ms | n/a | n/a | 90.71 ms | 1 | measured |
| flutter-skia | large | open | ui-frame | 0.455/0.506 | - | - | - | 10.31 ms | n/a | n/a | 83.20 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 0.577/0.837 | - | 10.667/19.998 | 11.092/20.545 | 0.68 ms | n/a | n/a | 72.96 ms | 2 | measured |
| flutter-skia | large | scroll | ui-frame | 1.792/2.586 | - | 10.000/10.002 | - | 0.43 ms | n/a | n/a | 86.10 ms | 2 | measured |
| flutter-skia | stress | open | ui-frame | 0.361/0.374 | - | - | - | 10.29 ms | n/a | n/a | 113.95 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 0.589/0.788 | - | 10.667/20.004 | 10.397/13.182 | 0.75 ms | n/a | n/a | 116.91 ms | 5 | measured |
| flutter-skia | stress | scroll | ui-frame | 1.728/2.427 | - | 10.000/10.002 | - | 0.44 ms | n/a | n/a | 113.74 ms | 3 | measured |
| flutter-impeller | small | open | ui-frame | 0.492/0.654 | - | - | - | 7.43 ms | n/a | n/a | 79.68 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 0.600/0.915 | - | 10.334/20.002 | 10.613/18.060 | 0.70 ms | n/a | n/a | 89.20 ms | 2 | measured |
| flutter-impeller | small | scroll | ui-frame | 1.387/2.321 | - | 10.056/10.002 | - | 0.46 ms | n/a | n/a | 94.86 ms | 4 | measured |
| flutter-impeller | medium | open | ui-frame | 0.547/0.649 | - | - | - | 7.57 ms | n/a | n/a | 83.39 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 0.581/0.990 | - | 10.000/20.001 | 11.062/20.588 | 0.82 ms | n/a | n/a | 80.23 ms | 3 | measured |
| flutter-impeller | medium | scroll | ui-frame | 1.675/2.443 | - | 10.000/10.002 | - | 0.39 ms | n/a | n/a | 85.84 ms | 0 | measured |
| flutter-impeller | large | open | ui-frame | 0.379/0.485 | - | - | - | 7.41 ms | n/a | n/a | 87.37 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 0.620/0.930 | - | 10.000/20.001 | 10.705/19.611 | 0.75 ms | n/a | n/a | 79.96 ms | 2 | measured |
| flutter-impeller | large | scroll | ui-frame | 1.739/2.464 | - | 10.000/10.002 | - | 0.43 ms | n/a | n/a | 86.84 ms | 2 | measured |
| flutter-impeller | stress | open | ui-frame | 0.408/0.453 | - | - | - | 7.76 ms | n/a | n/a | 114.50 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 0.619/0.887 | - | 11.334/20.005 | 9.561/10.239 | 0.75 ms | n/a | n/a | 113.50 ms | 4 | measured |
| flutter-impeller | stress | scroll | ui-frame | 1.764/2.465 | - | 10.083/10.002 | - | 0.44 ms | n/a | n/a | 132.92 ms | 4 | measured |
| electron | small | open | ui-frame | 14.633/17.000 | - | - | - | n/a | n/a | n/a | 14.63 ms | 0 | measured |
| electron | small | input | ui-frame | 2.497/3.800 | - | 9.670/11.700 | 8.990/11.600 | n/a | n/a | n/a | 16.60 ms | 0 | measured |
| electron | small | scroll | ui-frame | 1.966/2.700 | - | 9.959/10.700 | - | n/a | n/a | n/a | 14.27 ms | 0 | measured |
| electron | medium | open | ui-frame | 14.967/18.100 | - | - | - | n/a | n/a | n/a | 14.97 ms | 0 | measured |
| electron | medium | input | ui-frame | 2.480/4.100 | - | 9.893/11.900 | 8.860/11.000 | n/a | n/a | n/a | 14.10 ms | 0 | measured |
| electron | medium | scroll | ui-frame | 2.089/2.900 | - | 9.972/10.700 | - | n/a | n/a | n/a | 12.03 ms | 1 | measured |
| electron | large | open | ui-frame | 11.533/12.400 | - | - | - | n/a | n/a | n/a | 11.53 ms | 0 | measured |
| electron | large | input | ui-frame | 2.330/4.000 | - | 9.845/13.336 | 8.663/11.800 | n/a | n/a | n/a | 11.00 ms | 0 | measured |
| electron | large | scroll | ui-frame | 2.168/3.500 | - | 9.944/10.400 | - | n/a | n/a | n/a | 11.10 ms | 0 | measured |
| electron | stress | open | ui-frame | 19.733/20.300 | - | - | - | n/a | n/a | n/a | 19.73 ms | 0 | measured |
| electron | stress | input | ui-frame | 2.247/3.100 | - | 9.586/12.000 | 8.747/11.900 | n/a | n/a | n/a | 19.67 ms | 0 | measured |
| electron | stress | scroll | ui-frame | 2.073/2.900 | - | 10.010/11.800 | - | n/a | n/a | n/a | 19.80 ms | 0 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.62/1.58/1.60 | 3.30/3.30/3.33 | 0.85/0.78/0.78 | 1.35/1.19/1.20 | 3.06/2.93/2.96 | 5.37/5.42/5.24 | n/a/n/a/n/a |
| MoUI Skia GPU | 1.72/1.76/1.72 | 3.39/3.34/3.27 | 5.93/5.88/5.94 | 7.97/7.93/7.98 | 8.33/8.33/8.34 | 9.29/9.29/9.27 | n/a/n/a/n/a |
| MoUI WGPU | 1.81/1.79/1.79 | 3.40/3.42/3.38 | 5.82/5.83/5.85 | 8.18/8.15/8.19 | 8.33/8.32/8.33 | 9.45/9.41/9.53 | n/a/n/a/n/a |
| MoMark Skia Raster | 1.02/1.05/1.04 | 1.25/1.45/1.43 | 2.39/2.56/2.48 | 3.03/3.38/3.19 | 3.59/3.84/3.95 | 4.42/4.92/4.88 | n/a/n/a/n/a |
| MoMark Skia GPU | 1.20/1.20/1.15 | 1.74/1.71/1.69 | 6.87/6.86/6.65 | 8.09/8.08/7.81 | 8.35/8.35/8.35 | 9.34/9.46/9.31 | n/a/n/a/n/a |
| MoMark WGPU | 1.38/1.59/1.42 | 1.75/1.91/1.81 | 9.50/9.86/9.38 | 25.36/24.74/24.97 | 11.19/11.83/11.36 | 26.91/26.77/26.70 | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 8.55/8.40/8.41 | 10.55/10.49/10.49 | n/a/n/a/n/a | n/a/n/a/n/a | 10.55/10.43/10.39 | 13.24/12.65/12.81 | n/a/n/a/n/a |
| Flutter Skia | 1.25/1.72/1.79 | 1.85/2.45/2.59 | 0.40/0.42/0.43 | 0.58/0.56/0.61 | 10.00/10.03/10.00 | 10.00/10.00/10.00 | 1/1/2 |
| Flutter Impeller | 1.39/1.68/1.74 | 2.32/2.44/2.46 | 0.46/0.39/0.43 | 0.74/0.51/0.63 | 10.06/10.00/10.00 | 10.00/10.00/10.00 | 4/0/2 |
| Electron | 1.97/2.09/2.17 | 2.70/2.90/3.50 | n/a/n/a/n/a | n/a/n/a/n/a | 9.96/9.97/9.94 | 10.70/10.70/10.40 | 0/1/0 |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.62 | 3.35 | 0.84 | 1.27 | 3.04 | 5.41 | n/a |
| MoUI Skia GPU | 1.76 | 3.59 | 5.88 | 7.96 | 8.33 | 9.37 | n/a |
| MoUI WGPU | 1.77 | 3.40 | 5.88 | 8.17 | 8.33 | 9.42 | n/a |
| MoMark Skia Raster | 1.10 | 1.37 | 2.58 | 3.25 | 6.62 | 8.08 | n/a |
| MoMark Skia GPU | 1.10 | 1.34 | 5.15 | 6.01 | 9.72 | 10.52 | n/a |
| MoMark WGPU | 1.47 | 1.83 | 7.56 | 22.88 | 12.75 | 28.08 | n/a |
| GpMark.mbt (GPUI) | 8.51 | 10.63 | n/a | n/a | 10.61 | 12.92 | n/a |
| Flutter Skia | 1.73 | 2.43 | 0.44 | 0.63 | 10.00 | 10.00 | 3 |
| Flutter Impeller | 1.76 | 2.46 | 0.44 | 0.59 | 10.08 | 10.00 | 4 |
| Electron | 2.07 | 2.90 | n/a | n/a | 10.01 | 11.80 | 0 |

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.70/1.88/3.46 | 1.91/2.47/9.28 | 0.55/0.60/0.94 | 0.60/0.87/3.35 | 0.98/1.08/1.92 | 1.19/1.48/6.44 |
| MoUI Skia GPU | 8.27/8.34/8.36 | 9.50/9.50/9.26 | 0.70/0.69/0.76 | 0.83/0.87/0.90 | 7.33/7.40/7.08 | 8.59/8.38/7.95 |
| MoUI WGPU | 8.04/8.23/8.11 | 9.62/9.40/9.46 | 0.70/0.71/0.70 | 0.88/0.91/0.90 | 7.04/7.23/6.89 | 8.64/8.44/8.31 |
| MoMark Skia Raster | 7.39/7.65/14.88 | 9.15/8.35/15.84 | 3.88/3.80/4.89 | 4.69/4.30/5.36 | 3.09/2.91/3.01 | 3.72/3.40/3.31 |
| MoMark Skia GPU | 9.46/9.83/17.32 | 11.36/11.14/20.90 | 3.77/3.91/5.41 | 4.49/4.16/6.02 | 5.24/4.56/5.01 | 6.61/5.55/7.48 |
| MoMark WGPU | 12.05/11.23/12.43 | 27.72/26.56/14.47 | 1.75/1.89/2.46 | 2.07/2.42/2.86 | 9.81/8.19/2.69 | 25.58/23.11/4.25 |
| GpMark.mbt (GPUI) | 10.90/11.09/11.15 | 20.89/20.28/20.01 | 7.28/7.24/7.52 | 7.68/7.68/7.93 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 10.53/11.37/11.09 | 16.27/20.77/20.55 | 0.65/0.62/0.58 | 0.98/1.02/0.84 | 0.95/0.75/0.68 | 2.09/1.44/1.28 |
| Flutter Impeller | 10.61/11.06/10.70 | 18.06/20.59/19.61 | 0.60/0.58/0.62 | 0.92/0.99/0.93 | 0.70/0.82/0.75 | 1.28/1.66/1.54 |
| Electron | 8.99/8.86/8.66 | 11.60/11.00/11.80 | 2.50/2.48/2.33 | 3.80/4.10/4.00 | n/a/n/a/n/a | n/a/n/a/n/a |

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.30 | 8.76 | 0.80 | 1.26 | 1.24 | 1.87 |
| MoUI Skia GPU | 8.97 | 10.16 | 0.75 | 0.91 | 4.71 | 5.69 |
| MoUI WGPU | 8.33 | 9.53 | 0.68 | 0.87 | 4.59 | 6.06 |
| MoMark Skia Raster | 90.18 | 98.81 | 13.05 | 13.90 | 3.26 | 4.05 |
| MoMark Skia GPU | 97.14 | 109.02 | 13.63 | 16.67 | 3.98 | 6.94 |
| MoMark WGPU | 93.87 | 104.08 | 10.18 | 10.51 | 2.77 | 3.94 |
| GpMark.mbt (GPUI) | 15.86 | 26.71 | 7.43 | 7.83 | n/a | n/a |
| Flutter Skia | 10.40 | 13.18 | 0.59 | 0.79 | 0.75 | 1.74 |
| Flutter Impeller | 9.56 | 10.24 | 0.62 | 0.89 | 0.75 | 1.63 |
| Electron | 8.75 | 11.90 | 2.25 | 3.10 | n/a | n/a |

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 60.17/63.20/63.76 | 62.72/66.98/65.68 | 53.66/56.18/54.89 | 56.66/60.05/56.69 | 5.26/5.49/5.67 | 5.69/5.72/5.74 | 0.07/0.34/2.82 | 0.09/0.42/2.94 |
| MoUI Skia GPU | 66.41/64.75/66.53 | 69.28/67.10/72.08 | 49.24/50.22/49.06 | 49.86/51.63/51.19 | 15.93/13.12/14.26 | 18.28/14.34/17.37 | 0.08/0.29/2.82 | 0.11/0.30/3.08 |
| MoUI WGPU | 71.88/71.78/71.16 | 72.60/72.27/71.59 | 58.82/57.49/56.22 | 59.48/57.75/56.60 | 11.66/12.52/11.72 | 12.06/12.72/12.21 | 0.08/0.24/2.75 | 0.10/0.29/2.91 |
| MoMark Skia Raster | 69.37/72.22/88.74 | 72.43/72.85/91.20 | 54.29/54.90/55.07 | 56.95/55.52/57.72 | 13.17/13.68/14.46 | 13.67/13.84/16.17 | 0.07/0.33/2.34 | 0.09/0.40/2.86 |
| MoMark Skia GPU | 95.55/104.22/94.23 | 101.92/114.52/95.08 | 56.17/54.22/49.98 | 63.44/55.63/51.22 | 37.41/46.39/25.29 | 47.27/54.83/26.27 | 0.07/0.27/2.51 | 0.09/0.31/2.56 |
| MoMark WGPU | 77.39/76.65/91.54 | 80.00/78.37/93.17 | 58.27/56.41/56.58 | 60.19/56.64/58.32 | 16.91/16.55/15.92 | 17.33/17.98/16.27 | 0.10/0.40/2.38 | 0.12/0.42/2.79 |
| GpMark.mbt (GPUI) | 155.15/160.11/163.03 | 166.81/175.82/172.57 | 7.85/8.00/8.53 | 8.15/8.57/9.05 | n/a/n/a/n/a | n/a/n/a/n/a | 0.00/1.00/3.00 | 0.00/1.00/4.00 |
| Flutter Skia | 77.21/87.21/83.20 | 97.58/91.79/89.67 | 0.34/0.41/0.46 | 0.44/0.53/0.51 | 10.75/11.18/10.31 | 13.01/12.54/10.72 | 0.13/0.19/0.44 | 0.15/0.20/0.51 |
| Flutter Impeller | 79.68/83.39/87.37 | 84.73/86.96/109.70 | 0.49/0.55/0.38 | 0.65/0.65/0.48 | 7.43/7.57/7.41 | 7.86/7.83/7.81 | 0.16/0.24/0.61 | 0.18/0.33/0.81 |
| Electron | 14.63/14.97/11.53 | 17.00/18.10/12.40 | 14.63/14.97/11.53 | 17.00/18.10/12.40 | n/a/n/a/n/a | n/a/n/a/n/a | 3.89/8.82/6.01 | 4.20/11.28/10.17 |

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 80.89 | 83.05 | 55.79 | 58.35 | 4.82 | 4.87 | 23.67 | 28.84 |
| MoUI Skia GPU | 84.82 | 88.47 | 51.15 | 52.18 | 13.70 | 16.27 | 27.34 | 27.82 |
| MoUI WGPU | 83.02 | 85.45 | 51.83 | 54.71 | 11.16 | 11.35 | 24.26 | 26.85 |
| MoMark Skia Raster | 255.48 | 259.05 | 63.73 | 64.27 | 12.44 | 12.83 | 24.87 | 27.85 |
| MoMark Skia GPU | 278.13 | 298.98 | 59.85 | 63.84 | 37.03 | 51.21 | 24.49 | 26.35 |
| MoMark WGPU | 264.13 | 265.22 | 65.08 | 66.88 | 15.81 | 16.40 | 24.45 | 24.92 |
| GpMark.mbt (GPUI) | 156.92 | 163.69 | 7.90 | 8.32 | n/a | n/a | 27.67 | 30.00 |
| Flutter Skia | 113.95 | 118.37 | 0.36 | 0.37 | 10.29 | 10.50 | 3.65 | 3.92 |
| Flutter Impeller | 114.50 | 121.73 | 0.41 | 0.45 | 7.76 | 7.95 | 3.99 | 4.62 |
| Electron | 19.73 | 20.30 | 19.73 | 20.30 | n/a | n/a | 8.19 | 12.91 |

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.62/1.58/1.60 | 3.30/3.30/3.33 | 0.85/0.78/0.78 | 1.35/1.19/1.20 | 3.06/2.93/2.96 | 5.37/5.42/5.24 | n/a/n/a/n/a |
| MoUI Skia GPU | 1.72/1.76/1.72 | 3.39/3.34/3.27 | 5.93/5.88/5.94 | 7.97/7.93/7.98 | 8.33/8.33/8.34 | 9.29/9.29/9.27 | n/a/n/a/n/a |
| MoUI WGPU | 1.81/1.79/1.79 | 3.40/3.42/3.38 | 5.82/5.83/5.85 | 8.18/8.15/8.19 | 8.33/8.32/8.33 | 9.45/9.41/9.53 | n/a/n/a/n/a |
| MoMark Skia Raster | 1.02/1.05/1.04 | 1.25/1.45/1.43 | 2.39/2.56/2.48 | 3.03/3.38/3.19 | 3.59/3.84/3.95 | 4.42/4.92/4.88 | n/a/n/a/n/a |
| MoMark Skia GPU | 1.20/1.20/1.15 | 1.74/1.71/1.69 | 6.87/6.86/6.65 | 8.09/8.08/7.81 | 8.35/8.35/8.35 | 9.34/9.46/9.31 | n/a/n/a/n/a |
| MoMark WGPU | 1.38/1.59/1.42 | 1.75/1.91/1.81 | 9.50/9.86/9.38 | 25.36/24.74/24.97 | 11.19/11.83/11.36 | 26.91/26.77/26.70 | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 8.55/8.40/8.41 | 10.55/10.49/10.49 | n/a/n/a/n/a | n/a/n/a/n/a | 10.55/10.43/10.39 | 13.24/12.65/12.81 | n/a/n/a/n/a |
| Flutter Skia | 1.25/1.72/1.79 | 1.85/2.45/2.59 | 0.40/0.42/0.43 | 0.58/0.56/0.61 | 10.00/10.03/10.00 | 10.00/10.00/10.00 | 1/1/2 |
| Flutter Impeller | 1.39/1.68/1.74 | 2.32/2.44/2.46 | 0.46/0.39/0.43 | 0.74/0.51/0.63 | 10.06/10.00/10.00 | 10.00/10.00/10.00 | 4/0/2 |
| Electron | 1.97/2.09/2.17 | 2.70/2.90/3.50 | n/a/n/a/n/a | n/a/n/a/n/a | 9.96/9.97/9.94 | 10.70/10.70/10.40 | 0/1/0 |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.62 | 3.35 | 0.84 | 1.27 | 3.04 | 5.41 | n/a |
| MoUI Skia GPU | 1.76 | 3.59 | 5.88 | 7.96 | 8.33 | 9.37 | n/a |
| MoUI WGPU | 1.77 | 3.40 | 5.88 | 8.17 | 8.33 | 9.42 | n/a |
| MoMark Skia Raster | 1.10 | 1.37 | 2.58 | 3.25 | 6.62 | 8.08 | n/a |
| MoMark Skia GPU | 1.10 | 1.34 | 5.15 | 6.01 | 9.72 | 10.52 | n/a |
| MoMark WGPU | 1.47 | 1.83 | 7.56 | 22.88 | 12.75 | 28.08 | n/a |
| GpMark.mbt (GPUI) | 8.51 | 10.63 | n/a | n/a | 10.61 | 12.92 | n/a |
| Flutter Skia | 1.73 | 2.43 | 0.44 | 0.63 | 10.00 | 10.00 | 3 |
| Flutter Impeller | 1.76 | 2.46 | 0.44 | 0.59 | 10.08 | 10.00 | 4 |
| Electron | 2.07 | 2.90 | n/a | n/a | 10.01 | 11.80 | 0 |

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoMark Skia Raster stress 255.5 ms（max 259.0 ms）；MoMark Skia GPU small 95.5 ms（max 101.9 ms）；MoMark Skia GPU medium 104.2 ms（max 114.5 ms）；MoMark Skia GPU stress 278.1 ms（max 299.0 ms）；MoMark WGPU stress 264.1 ms（max 265.2 ms）；GpMark.mbt (GPUI) small 155.1 ms（max 166.8 ms）；GpMark.mbt (GPUI) medium 160.1 ms（max 175.8 ms）；GpMark.mbt (GPUI) large 163.0 ms（max 172.6 ms）；GpMark.mbt (GPUI) stress 156.9 ms（max 163.7 ms）；Flutter Skia stress 114.0 ms（max 118.4 ms）；Flutter Impeller large 87.4 ms（max 109.7 ms）；Flutter Impeller stress 114.5 ms（max 121.7 ms）。
- P1 输入尾延迟：MoMark Skia Raster stress P95 98.81 ms；MoMark Skia GPU large P95 20.90 ms；MoMark Skia GPU stress P95 109.02 ms；MoMark WGPU small P95 27.72 ms；MoMark WGPU medium P95 26.56 ms；MoMark WGPU stress P95 104.08 ms；GpMark.mbt (GPUI) small P95 20.89 ms；GpMark.mbt (GPUI) medium P95 20.28 ms；GpMark.mbt (GPUI) large P95 20.01 ms；GpMark.mbt (GPUI) stress P95 26.71 ms；Flutter Skia medium P95 20.77 ms；Flutter Skia large P95 20.55 ms；Flutter Impeller small P95 18.06 ms；Flutter Impeller medium P95 20.59 ms；Flutter Impeller large P95 19.61 ms。
- 长帧（超预算）：MoMark Skia Raster: small/scroll 1 次，max 17.90 ms, large/input 1 次，max 16.77 ms, stress/input 30 次，max 99.47 ms；MoMark Skia GPU: large/input 20 次，max 23.08 ms, stress/input 30 次，max 220.82 ms；MoMark WGPU: small/input 4 次，max 67.70 ms, small/scroll 58 次，max 32.36 ms, medium/input 5 次，max 26.82 ms, medium/scroll 71 次，max 58.58 ms, large/scroll 65 次，max 29.72 ms, stress/input 30 次，max 188.49 ms, stress/scroll 70 次，max 31.20 ms；GpMark.mbt (GPUI): small/input 3 次，max 20.92 ms, small/scroll 3 次，max 24.47 ms, medium/input 3 次，max 29.14 ms, medium/scroll 4 次，max 27.59 ms, large/input 2 次，max 21.44 ms, large/scroll 2 次，max 23.83 ms, stress/input 4 次，max 35.67 ms, stress/scroll 6 次，max 30.62 ms；Flutter Skia: small/input 3 次，max 30.00 ms, small/scroll 1 次，max 20.00 ms, medium/input 4 次，max 20.00 ms, medium/scroll 1 次，max 20.00 ms, large/input 2 次，max 20.00 ms, large/scroll 2 次，max 20.01 ms, stress/input 5 次，max 20.00 ms, stress/scroll 3 次，max 20.00 ms；Flutter Impeller: small/input 2 次，max 20.00 ms, small/scroll 4 次，max 30.00 ms, medium/input 3 次，max 20.00 ms, large/input 2 次，max 20.00 ms, large/scroll 2 次，max 20.00 ms, stress/input 4 次，max 30.00 ms, stress/scroll 4 次，max 20.00 ms；Electron: medium/scroll 1 次，max 20.00 ms。
- 丢帧（优先处理）：Flutter Skia: small/input 3 帧, small/scroll 1 帧, medium/input 4 帧, medium/scroll 1 帧, large/input 2 帧, large/scroll 2 帧, stress/input 5 帧, stress/scroll 3 帧；Flutter Impeller: small/input 2 帧, small/scroll 4 帧, medium/input 3 帧, large/input 2 帧, large/scroll 2 帧, stress/input 4 帧, stress/scroll 4 帧；Electron: medium/scroll 1 帧。
- 解释：首帧异常优先检查窗口/渲染器初始化；输入尾延迟检查 action 到下一可见帧的调度与同步重建；长帧检查解析、布局、文本 shaping 和 GPU 提交；`n/a` 表示未埋点，不等于 0。
- 普通模式的长帧、帧间隔和输入延迟是各框架回调诊断，不能替代跨框架 compositor 排名；需要严格结论时运行 `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`。

## 采集口径

- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。
- `frame_work_ms` 统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏；对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `device_present_ms`：设备/上屏侧统一字段。MoUI raster 为 Skia CPU 光栅化+像素回读整体；MoUI GPU/wgpu 为提交后同步等待设备完成（headless host-surface 逐帧同步，真实应用的 vsync 流水线可重叠掉一部分，该值应视为上屏成本上界）；Flutter 为 `FrameTiming.rasterDuration`（光栅线程任务时间，含显示列表光栅化与 GPU 提交、不含设备完成等待）；GPUI 与 Electron 适配器侧无法观测，显示 `n/a`。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧；严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代；打开场景没有前一帧，所以不计算 interval/drop。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。
