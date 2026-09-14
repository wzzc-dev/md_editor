# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-14T14:07:41Z`
- 数据状态：`360 measured`，`0 skipped/error`；原始样本保留在 JSON。
- Host：`macOS-26.3-arm64-arm-64bit` / `arm64` / `16.0 GiB`；GPU：`Apple M4`
- OS：`25.3.0`；CPU：`arm`；toolchains：`python=3.12.11, moon=moon 0.1.20260824 (dae026a 2026-08-24), rustc=rustc 1.94.0 (4a4ef493e 2026-03-02), cargo=cargo 1.94.0 (85eff7c80 2026-01-15), node=v25.2.1, npm=11.6.2, flutter=Flutter 3.47.1 • channel stable • https://github.com/flutter/flutter.git`
- 统一配置：`1280x800 @ 60 Hz`；font `system-ui 16px`；line-height `1.55`；overscan `3`；fixed row `66px`；GPU backend `Metal`
- Fixture：`small=5KB/100 blocks`，`medium=50KB/1,000 blocks`，`large=500KB/10,000 blocks`，`stress=5MB/100,000 blocks`。
- 本次执行集合：`small, medium, large, stress`；未执行集合在矩阵中显示 `n/a`，不参与比较。
- 汇总口径：mean/P95 合并原始样本；每格 repetition `3`、process warm-up `1`；drop 为各 repetition dropped_display_frames 之和。
- 公平性口径：所有 ui-frame 记录使用相同 fixture、viewport、动作数、warm-up 和重复次数。`工作`（frame_work）统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏：MoUI 为 build+layout+paint+draw，Flutter 为 UI 线程 buildDuration，GPUI 为 request_layout→prepaint→paint，Electron 为 JS 可见的 DOM 更新+layout。设备光栅化与上屏统一单列为 `设备侧`（device_present）：窗口模式（`UI_BENCHMARK_WINDOWED=1`）下 MoUI 在真实 AppKit 窗口上屏，适配器侧不单独计时设备光栅化，显示 `n/a`，Flutter 为光栅线程 rasterDuration（不含设备完成等待），GPUI 与 Electron 无法在适配器侧观测显示链路，显示 `n/a`。MoUI ui-frame 运行在真实 AppKit 窗口（`native-window`），其帧间隔/输入延迟是动作到原生帧观察的 wall-clock 采样（观察节奏约 12 ms），与 GPUI 的 `on_next_frame`、Flutter 的 vsyncStart、Electron 的 rAF 同属框架回调诊断；GPUI 的 action dispatch 另列为诊断字段。不同框架的显示时间戳由各自平台 API 提供，帧间隔覆盖完整链路，报告不做跨时钟的综合排名。`n/a` 表示没有采集，绝不等同于 0。下方各对比表把同平台跨框架可比列（帧间隔/可见延迟/首次可交互/丢帧数等）排在前面，框架内部诊断列（`工作`/`设备侧`）排在后面并标注 `†`。

- `moui-md-*` 行来自 `momark`（MoMark，原 `vendor/MoUI/examples/markdown_editor`）官方示例应用：fixture 通过应用自身的 `OpenRecentDocument` 服务路径打开，渲染经过示例自己的虚拟滚动与富文本缓存实现，不套用简化基准应用的 `fixed row 66px` 统一行高；viewport、fixture、动作数、warm-up 与重复次数与其他行完全一致。严格模式（`UI_BENCHMARK_SYSTEM_TRACE=1`）目前不为 `moui-md-*` 行采集系统 present，这些行会显示 error。

<details><summary>原始 ui-frame 汇总（可审计）</summary>

| 实现 | 测试集合 | 场景 | 范围 | 工作均值/P95 | 仅分发均值/P95 | 帧间隔均值/P95 | 输入到可见均值/P95 | 设备侧均值 | 离屏均值 | 回读均值 | 首次可交互 | 丢帧数 | 状态 |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| moui-skia-raster | small | open | ui-frame | 0.018/0.028 | - | - | - | n/a | n/a | n/a | 258.71 ms | 0 | measured |
| moui-skia-raster | small | input | ui-frame | 0.766/0.908 | - | 27.089/29.923 | 27.027/29.862 | n/a | n/a | n/a | 274.52 ms | 31 | measured |
| moui-skia-raster | small | scroll | ui-frame | 0.553/0.655 | - | 25.421/28.143 | - | n/a | n/a | n/a | 252.17 ms | 364 | measured |
| moui-skia-raster | medium | open | ui-frame | 0.017/0.023 | - | - | - | n/a | n/a | n/a | 244.79 ms | 0 | measured |
| moui-skia-raster | medium | input | ui-frame | 0.780/0.952 | - | 26.585/29.375 | 26.523/29.319 | n/a | n/a | n/a | 259.97 ms | 29 | measured |
| moui-skia-raster | medium | scroll | ui-frame | 0.547/0.659 | - | 25.172/26.915 | - | n/a | n/a | n/a | 257.85 ms | 360 | measured |
| moui-skia-raster | large | open | ui-frame | 0.011/0.013 | - | - | - | n/a | n/a | n/a | 259.63 ms | 0 | measured |
| moui-skia-raster | large | input | ui-frame | 0.766/0.901 | - | 26.617/36.805 | 26.555/36.733 | n/a | n/a | n/a | 279.46 ms | 30 | measured |
| moui-skia-raster | large | scroll | ui-frame | 0.545/0.673 | - | 25.109/26.822 | - | n/a | n/a | n/a | 264.51 ms | 360 | measured |
| moui-skia-raster | stress | open | ui-frame | 0.016/0.020 | - | - | - | n/a | n/a | n/a | 304.62 ms | 0 | measured |
| moui-skia-raster | stress | input | ui-frame | 0.787/1.015 | - | 26.976/28.739 | 26.912/28.662 | n/a | n/a | n/a | 309.09 ms | 30 | measured |
| moui-skia-raster | stress | scroll | ui-frame | 0.535/0.633 | - | 25.124/26.719 | - | n/a | n/a | n/a | 280.30 ms | 361 | measured |
| moui-skia-gpu | small | open | ui-frame | 0.010/0.012 | - | - | - | n/a | n/a | n/a | 254.39 ms | 0 | measured |
| moui-skia-gpu | small | input | ui-frame | 0.739/0.886 | - | 13.902/19.649 | 13.821/19.644 | n/a | n/a | n/a | 237.12 ms | 4 | measured |
| moui-skia-gpu | small | scroll | ui-frame | 0.645/1.246 | - | 12.926/13.841 | - | n/a | n/a | n/a | 258.85 ms | 5 | measured |
| moui-skia-gpu | medium | open | ui-frame | 0.011/0.011 | - | - | - | n/a | n/a | n/a | 251.96 ms | 0 | measured |
| moui-skia-gpu | medium | input | ui-frame | 0.753/0.884 | - | 13.926/19.965 | 13.854/19.887 | n/a | n/a | n/a | 258.30 ms | 4 | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 0.637/1.238 | - | 12.893/13.866 | - | n/a | n/a | n/a | 264.70 ms | 10 | measured |
| moui-skia-gpu | large | open | ui-frame | 0.012/0.014 | - | - | - | n/a | n/a | n/a | 263.34 ms | 0 | measured |
| moui-skia-gpu | large | input | ui-frame | 0.770/0.890 | - | 14.037/19.995 | 13.975/19.907 | n/a | n/a | n/a | 229.89 ms | 6 | measured |
| moui-skia-gpu | large | scroll | ui-frame | 0.798/1.484 | - | 12.994/14.598 | - | n/a | n/a | n/a | 263.03 ms | 8 | measured |
| moui-skia-gpu | stress | open | ui-frame | 0.018/0.024 | - | - | - | n/a | n/a | n/a | 295.24 ms | 0 | measured |
| moui-skia-gpu | stress | input | ui-frame | 0.760/0.894 | - | 17.175/23.599 | 17.079/23.471 | n/a | n/a | n/a | 278.66 ms | 12 | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 0.822/1.537 | - | 13.344/14.879 | - | n/a | n/a | n/a | 293.47 ms | 6 | measured |
| moui-wgpu | small | open | ui-frame | 0.013/0.019 | - | - | - | n/a | n/a | n/a | 284.38 ms | 0 | measured |
| moui-wgpu | small | input | ui-frame | 0.821/1.366 | - | 14.381/20.013 | 14.304/19.945 | n/a | n/a | n/a | 285.40 ms | 5 | measured |
| moui-wgpu | small | scroll | ui-frame | 0.792/1.464 | - | 13.489/15.959 | - | n/a | n/a | n/a | 283.01 ms | 11 | measured |
| moui-wgpu | medium | open | ui-frame | 0.010/0.012 | - | - | - | n/a | n/a | n/a | 278.78 ms | 0 | measured |
| moui-wgpu | medium | input | ui-frame | 0.722/0.842 | - | 14.850/20.008 | 14.777/19.951 | n/a | n/a | n/a | 279.02 ms | 7 | measured |
| moui-wgpu | medium | scroll | ui-frame | 0.788/1.451 | - | 13.309/15.260 | - | n/a | n/a | n/a | 286.24 ms | 8 | measured |
| moui-wgpu | large | open | ui-frame | 0.028/0.040 | - | - | - | n/a | n/a | n/a | 275.21 ms | 0 | measured |
| moui-wgpu | large | input | ui-frame | 0.710/0.832 | - | 14.688/20.000 | 14.609/19.936 | n/a | n/a | n/a | 282.22 ms | 7 | measured |
| moui-wgpu | large | scroll | ui-frame | 0.784/1.476 | - | 13.265/15.286 | - | n/a | n/a | n/a | 284.94 ms | 12 | measured |
| moui-wgpu | stress | open | ui-frame | 0.014/0.018 | - | - | - | n/a | n/a | n/a | 327.40 ms | 0 | measured |
| moui-wgpu | stress | input | ui-frame | 0.712/0.803 | - | 16.751/21.439 | 16.671/21.370 | n/a | n/a | n/a | 318.77 ms | 9 | measured |
| moui-wgpu | stress | scroll | ui-frame | 0.804/1.472 | - | 13.429/15.538 | - | n/a | n/a | n/a | 321.64 ms | 13 | measured |
| moui-md-skia-raster | small | open | ui-frame | 0.019/0.026 | - | - | - | n/a | n/a | n/a | 293.59 ms | 0 | measured |
| moui-md-skia-raster | small | input | ui-frame | 2.210/2.347 | - | 35.913/38.207 | 35.847/38.148 | n/a | n/a | n/a | 296.33 ms | 58 | measured |
| moui-md-skia-raster | small | scroll | ui-frame | 1.714/2.068 | - | 35.509/38.024 | - | n/a | n/a | n/a | 294.24 ms | 710 | measured |
| moui-md-skia-raster | medium | open | ui-frame | 0.017/0.019 | - | - | - | n/a | n/a | n/a | 294.97 ms | 0 | measured |
| moui-md-skia-raster | medium | input | ui-frame | 2.285/2.560 | - | 38.288/40.387 | 38.233/40.339 | n/a | n/a | n/a | 296.71 ms | 61 | measured |
| moui-md-skia-raster | medium | scroll | ui-frame | 1.712/2.056 | - | 35.213/37.285 | - | n/a | n/a | n/a | 293.75 ms | 706 | measured |
| moui-md-skia-raster | large | open | ui-frame | 0.016/0.019 | - | - | - | n/a | n/a | n/a | 304.56 ms | 0 | measured |
| moui-md-skia-raster | large | input | ui-frame | 2.657/2.818 | - | 42.539/54.399 | 42.473/54.394 | n/a | n/a | n/a | 301.07 ms | 63 | measured |
| moui-md-skia-raster | large | scroll | ui-frame | 1.689/2.039 | - | 35.460/38.079 | - | n/a | n/a | n/a | 311.31 ms | 705 | measured |
| moui-md-skia-raster | stress | open | ui-frame | 0.010/0.011 | - | - | - | n/a | n/a | n/a | 407.68 ms | 0 | measured |
| moui-md-skia-raster | stress | input | ui-frame | 5.019/5.323 | - | 100.787/105.299 | 100.728/105.235 | n/a | n/a | n/a | 389.45 ms | 170 | measured |
| moui-md-skia-raster | stress | scroll | ui-frame | 1.714/2.067 | - | 35.637/38.881 | - | n/a | n/a | n/a | 410.30 ms | 707 | measured |
| moui-md-skia-gpu | small | open | ui-frame | 0.018/0.025 | - | - | - | n/a | n/a | n/a | 300.40 ms | 0 | measured |
| moui-md-skia-gpu | small | input | ui-frame | 2.198/2.382 | - | 17.160/19.994 | 17.097/19.944 | n/a | n/a | n/a | 257.69 ms | 20 | measured |
| moui-md-skia-gpu | small | scroll | ui-frame | 1.814/2.240 | - | 15.018/17.048 | - | n/a | n/a | n/a | 316.35 ms | 61 | measured |
| moui-md-skia-gpu | medium | open | ui-frame | 0.014/0.019 | - | - | - | n/a | n/a | n/a | 297.95 ms | 0 | measured |
| moui-md-skia-gpu | medium | input | ui-frame | 2.211/2.371 | - | 18.929/20.021 | 18.877/19.971 | n/a | n/a | n/a | 292.96 ms | 28 | measured |
| moui-md-skia-gpu | medium | scroll | ui-frame | 1.856/2.291 | - | 15.066/17.110 | - | n/a | n/a | n/a | 264.67 ms | 58 | measured |
| moui-md-skia-gpu | large | open | ui-frame | 0.017/0.022 | - | - | - | n/a | n/a | n/a | 296.29 ms | 0 | measured |
| moui-md-skia-gpu | large | input | ui-frame | 2.473/2.658 | - | 21.082/27.717 | 21.027/27.712 | n/a | n/a | n/a | 295.54 ms | 30 | measured |
| moui-md-skia-gpu | large | scroll | ui-frame | 1.865/2.306 | - | 15.064/17.117 | - | n/a | n/a | n/a | 290.23 ms | 53 | measured |
| moui-md-skia-gpu | stress | open | ui-frame | 0.024/0.026 | - | - | - | n/a | n/a | n/a | 413.90 ms | 0 | measured |
| moui-md-skia-gpu | stress | input | ui-frame | 4.994/5.212 | - | 80.275/86.329 | 80.217/86.277 | n/a | n/a | n/a | 414.23 ms | 127 | measured |
| moui-md-skia-gpu | stress | scroll | ui-frame | 1.888/2.373 | - | 15.010/17.240 | - | n/a | n/a | n/a | 397.78 ms | 59 | measured |
| moui-md-wgpu | small | open | ui-frame | 0.013/0.015 | - | - | - | n/a | n/a | n/a | 293.31 ms | 0 | measured |
| moui-md-wgpu | small | input | ui-frame | 1.950/2.928 | - | 20.236/25.415 | 20.162/25.364 | n/a | n/a | n/a | 265.13 ms | 27 | measured |
| moui-md-wgpu | small | scroll | ui-frame | 2.376/2.920 | - | 20.799/27.669 | - | n/a | n/a | n/a | 286.92 ms | 344 | measured |
| moui-md-wgpu | medium | open | ui-frame | 0.012/0.012 | - | - | - | n/a | n/a | n/a | 261.57 ms | 0 | measured |
| moui-md-wgpu | medium | input | ui-frame | 1.890/2.297 | - | 21.025/27.286 | 20.935/27.281 | n/a | n/a | n/a | 284.44 ms | 29 | measured |
| moui-md-wgpu | medium | scroll | ui-frame | 2.342/2.890 | - | 20.783/28.869 | - | n/a | n/a | n/a | 292.92 ms | 344 | measured |
| moui-md-wgpu | large | open | ui-frame | 0.014/0.020 | - | - | - | n/a | n/a | n/a | 292.51 ms | 0 | measured |
| moui-md-wgpu | large | input | ui-frame | 1.930/2.157 | - | 23.347/26.167 | 23.238/26.030 | n/a | n/a | n/a | 293.46 ms | 30 | measured |
| moui-md-wgpu | large | scroll | ui-frame | 2.363/2.914 | - | 20.773/27.366 | - | n/a | n/a | n/a | 305.91 ms | 345 | measured |
| moui-md-wgpu | stress | open | ui-frame | 0.021/0.022 | - | - | - | n/a | n/a | n/a | 396.90 ms | 0 | measured |
| moui-md-wgpu | stress | input | ui-frame | 4.224/4.333 | - | 83.847/90.114 | 83.794/90.040 | n/a | n/a | n/a | 393.82 ms | 139 | measured |
| moui-md-wgpu | stress | scroll | ui-frame | 2.396/2.984 | - | 20.678/27.207 | - | n/a | n/a | n/a | 409.41 ms | 343 | measured |
| gpmark | small | open | ui-frame | 6.134/6.629 | - | - | - | n/a | n/a | n/a | 150.94 ms | n/a | measured |
| gpmark | small | input | ui-frame | 5.515/5.759 | 0.359/0.403 | 9.846/10.779 | 9.842/10.775 | n/a | n/a | n/a | 151.99 ms | n/a | measured |
| gpmark | small | scroll | ui-frame | 6.398/7.787 | 0.003/0.005 | 9.987/11.234 | - | n/a | n/a | n/a | 147.60 ms | n/a | measured |
| gpmark | medium | open | ui-frame | 6.581/7.408 | - | - | - | n/a | n/a | n/a | 151.26 ms | n/a | measured |
| gpmark | medium | input | ui-frame | 5.549/5.804 | 0.395/0.493 | 9.755/11.334 | 9.752/11.328 | n/a | n/a | n/a | 150.42 ms | n/a | measured |
| gpmark | medium | scroll | ui-frame | 6.629/8.104 | 0.003/0.005 | 9.984/11.413 | - | n/a | n/a | n/a | 154.87 ms | n/a | measured |
| gpmark | large | open | ui-frame | 6.071/6.169 | - | - | - | n/a | n/a | n/a | 170.34 ms | n/a | measured |
| gpmark | large | input | ui-frame | 5.502/5.932 | 0.739/1.585 | 9.614/10.739 | 9.610/10.736 | n/a | n/a | n/a | 165.19 ms | n/a | measured |
| gpmark | large | scroll | ui-frame | 6.456/7.929 | 0.003/0.005 | 10.015/11.091 | - | n/a | n/a | n/a | 167.50 ms | n/a | measured |
| gpmark | stress | open | ui-frame | 7.282/8.105 | - | - | - | n/a | n/a | n/a | 254.29 ms | n/a | measured |
| gpmark | stress | input | ui-frame | 5.556/5.790 | 3.572/5.121 | 10.497/12.275 | 10.494/12.265 | n/a | n/a | n/a | 256.03 ms | n/a | measured |
| gpmark | stress | scroll | ui-frame | 6.417/7.819 | 0.003/0.006 | 10.006/11.210 | - | n/a | n/a | n/a | 249.10 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 0.430/0.518 | - | - | - | 9.55 ms | n/a | n/a | 194.00 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 0.562/0.764 | - | 12.001/40.001 | 9.938/10.509 | 0.67 ms | n/a | n/a | 196.33 ms | 4 | measured |
| flutter-skia | small | scroll | ui-frame | 1.453/2.789 | - | 10.056/10.003 | - | 0.44 ms | n/a | n/a | 190.00 ms | 2 | measured |
| flutter-skia | medium | open | ui-frame | 0.438/0.506 | - | - | - | 9.66 ms | n/a | n/a | 194.67 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 0.560/0.753 | - | 11.667/30.001 | 9.958/10.709 | 0.67 ms | n/a | n/a | 191.00 ms | 3 | measured |
| flutter-skia | medium | scroll | ui-frame | 1.837/3.553 | - | 9.972/10.003 | - | 0.42 ms | n/a | n/a | 189.33 ms | 0 | measured |
| flutter-skia | large | open | ui-frame | 0.310/0.322 | - | - | - | 9.68 ms | n/a | n/a | 197.00 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 0.570/0.643 | - | 11.667/30.002 | 9.972/10.152 | 0.63 ms | n/a | n/a | 196.33 ms | 3 | measured |
| flutter-skia | large | scroll | ui-frame | 1.823/2.776 | - | 10.028/10.003 | - | 0.42 ms | n/a | n/a | 191.67 ms | 2 | measured |
| flutter-skia | stress | open | ui-frame | 0.354/0.379 | - | - | - | 9.58 ms | n/a | n/a | 228.33 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 0.554/0.739 | - | 12.334/30.003 | 9.763/10.293 | 0.65 ms | n/a | n/a | 227.33 ms | 4 | measured |
| flutter-skia | stress | scroll | ui-frame | 1.806/2.814 | - | 10.000/10.003 | - | 0.42 ms | n/a | n/a | 228.67 ms | 1 | measured |
| flutter-impeller | small | open | ui-frame | 0.426/0.620 | - | - | - | 7.45 ms | n/a | n/a | 197.67 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 0.551/0.680 | - | 10.667/10.003 | 9.964/10.276 | 0.61 ms | n/a | n/a | 191.00 ms | 1 | measured |
| flutter-impeller | small | scroll | ui-frame | 1.535/2.867 | - | 9.945/10.003 | - | 0.44 ms | n/a | n/a | 194.67 ms | 0 | measured |
| flutter-impeller | medium | open | ui-frame | 0.542/0.582 | - | - | - | 7.16 ms | n/a | n/a | 205.67 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 0.593/0.702 | - | 10.000/10.004 | 9.994/10.378 | 0.67 ms | n/a | n/a | 194.33 ms | 0 | measured |
| flutter-impeller | medium | scroll | ui-frame | 1.886/2.909 | - | 10.056/10.003 | - | 0.41 ms | n/a | n/a | 199.67 ms | 3 | measured |
| flutter-impeller | large | open | ui-frame | 0.365/0.431 | - | - | - | 7.40 ms | n/a | n/a | 193.00 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 0.577/0.690 | - | 12.001/40.003 | 10.012/10.268 | 0.62 ms | n/a | n/a | 203.33 ms | 4 | measured |
| flutter-impeller | large | scroll | ui-frame | 1.890/3.045 | - | 9.972/10.002 | - | 0.41 ms | n/a | n/a | 205.67 ms | 0 | measured |
| flutter-impeller | stress | open | ui-frame | 0.372/0.403 | - | - | - | 7.54 ms | n/a | n/a | 238.33 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 0.598/0.861 | - | 11.667/30.002 | 10.013/10.140 | 0.57 ms | n/a | n/a | 236.67 ms | 3 | measured |
| flutter-impeller | stress | scroll | ui-frame | 1.880/2.799 | - | 10.195/10.003 | - | 0.41 ms | n/a | n/a | 235.00 ms | 5 | measured |
| electron | small | open | ui-frame | 383.333/388.000 | - | - | - | n/a | n/a | n/a | 383.33 ms | 0 | measured |
| electron | small | input | ui-frame | 2.250/3.500 | - | 9.559/11.900 | 8.733/11.300 | n/a | n/a | n/a | 389.67 ms | 0 | measured |
| electron | small | scroll | ui-frame | 1.955/2.600 | - | 9.941/11.400 | - | n/a | n/a | n/a | 360.67 ms | 0 | measured |
| electron | medium | open | ui-frame | 353.000/356.000 | - | - | - | n/a | n/a | n/a | 353.00 ms | 0 | measured |
| electron | medium | input | ui-frame | 2.360/3.700 | - | 9.509/13.336 | 8.953/11.900 | n/a | n/a | n/a | 368.00 ms | 0 | measured |
| electron | medium | scroll | ui-frame | 2.071/2.700 | - | 9.948/11.700 | - | n/a | n/a | n/a | 364.67 ms | 0 | measured |
| electron | large | open | ui-frame | 372.667/381.000 | - | - | - | n/a | n/a | n/a | 372.67 ms | 0 | measured |
| electron | large | input | ui-frame | 2.167/2.900 | - | 10.115/12.836 | 8.960/11.300 | n/a | n/a | n/a | 383.00 ms | 0 | measured |
| electron | large | scroll | ui-frame | 2.012/2.700 | - | 9.958/11.500 | - | n/a | n/a | n/a | 374.67 ms | 0 | measured |
| electron | stress | open | ui-frame | 392.667/399.000 | - | - | - | n/a | n/a | n/a | 392.67 ms | 0 | measured |
| electron | stress | input | ui-frame | 2.283/4.200 | - | 10.105/13.936 | 8.927/11.700 | n/a | n/a | n/a | 390.67 ms | 1 | measured |
| electron | stress | scroll | ui-frame | 2.060/2.800 | - | 9.939/11.500 | - | n/a | n/a | n/a | 397.00 ms | 0 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 25.42/25.17/25.11 | 28.14/26.91/26.82 | 364/360/360 | 0.55/0.55/0.55 | 0.66/0.66/0.67 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 12.93/12.89/12.99 | 13.84/13.87/14.60 | 5/10/8 | 0.64/0.64/0.80 | 1.25/1.24/1.48 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 13.49/13.31/13.26 | 15.96/15.26/15.29 | 11/8/12 | 0.79/0.79/0.78 | 1.46/1.45/1.48 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 35.51/35.21/35.46 | 38.02/37.28/38.08 | 710/706/705 | 1.71/1.71/1.69 | 2.07/2.06/2.04 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 15.02/15.07/15.06 | 17.05/17.11/17.12 | 61/58/53 | 1.81/1.86/1.86 | 2.24/2.29/2.31 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 20.80/20.78/20.77 | 27.67/28.87/27.37 | 344/344/345 | 2.38/2.34/2.36 | 2.92/2.89/2.91 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 9.99/9.98/10.02 | 11.23/11.41/11.09 | n/a/n/a/n/a | 6.40/6.63/6.46 | 7.79/8.10/7.93 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 10.06/9.97/10.03 | 10.00/10.00/10.00 | 2/0/2 | 1.45/1.84/1.82 | 2.79/3.55/2.78 | 0.44/0.42/0.42 | 0.75/0.62/0.58 |
| Flutter Impeller | 9.94/10.06/9.97 | 10.00/10.00/10.00 | 0/3/0 | 1.54/1.89/1.89 | 2.87/2.91/3.04 | 0.44/0.41/0.41 | 0.80/0.69/0.67 |
| Electron | 9.94/9.95/9.96 | 11.40/11.70/11.50 | 0/0/0 | 1.96/2.07/2.01 | 2.60/2.70/2.70 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 25.12 | 26.72 | 361 | 0.54 | 0.63 | n/a | n/a |
| MoUI Skia GPU | 13.34 | 14.88 | 6 | 0.82 | 1.54 | n/a | n/a |
| MoUI WGPU | 13.43 | 15.54 | 13 | 0.80 | 1.47 | n/a | n/a |
| MoMark Skia Raster | 35.64 | 38.88 | 707 | 1.71 | 2.07 | n/a | n/a |
| MoMark Skia GPU | 15.01 | 17.24 | 59 | 1.89 | 2.37 | n/a | n/a |
| MoMark WGPU | 20.68 | 27.21 | 343 | 2.40 | 2.98 | n/a | n/a |
| GpMark.mbt (GPUI) | 10.01 | 11.21 | n/a | 6.42 | 7.82 | n/a | n/a |
| Flutter Skia | 10.00 | 10.00 | 1 | 1.81 | 2.81 | 0.42 | 0.66 |
| Flutter Impeller | 10.19 | 10.00 | 5 | 1.88 | 2.80 | 0.41 | 0.58 |
| Electron | 9.94 | 11.50 | 0 | 2.06 | 2.80 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 27.03/26.52/26.56 | 29.86/29.32/36.73 | 0.77/0.78/0.77 | 0.91/0.95/0.90 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 13.82/13.85/13.98 | 19.64/19.89/19.91 | 0.74/0.75/0.77 | 0.89/0.88/0.89 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 14.30/14.78/14.61 | 19.95/19.95/19.94 | 0.82/0.72/0.71 | 1.37/0.84/0.83 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 35.85/38.23/42.47 | 38.15/40.34/54.39 | 2.21/2.28/2.66 | 2.35/2.56/2.82 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 17.10/18.88/21.03 | 19.94/19.97/27.71 | 2.20/2.21/2.47 | 2.38/2.37/2.66 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 20.16/20.94/23.24 | 25.36/27.28/26.03 | 1.95/1.89/1.93 | 2.93/2.30/2.16 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 9.84/9.75/9.61 | 10.78/11.33/10.74 | 5.52/5.55/5.50 | 5.76/5.80/5.93 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 9.94/9.96/9.97 | 10.51/10.71/10.15 | 0.56/0.56/0.57 | 0.76/0.75/0.64 | 0.67/0.67/0.63 | 1.49/1.58/1.56 |
| Flutter Impeller | 9.96/9.99/10.01 | 10.28/10.38/10.27 | 0.55/0.59/0.58 | 0.68/0.70/0.69 | 0.61/0.67/0.62 | 1.38/1.50/1.23 |
| Electron | 8.73/8.95/8.96 | 11.30/11.90/11.30 | 2.25/2.36/2.17 | 3.50/3.70/2.90 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 26.91 | 28.66 | 0.79 | 1.02 | n/a | n/a |
| MoUI Skia GPU | 17.08 | 23.47 | 0.76 | 0.89 | n/a | n/a |
| MoUI WGPU | 16.67 | 21.37 | 0.71 | 0.80 | n/a | n/a |
| MoMark Skia Raster | 100.73 | 105.23 | 5.02 | 5.32 | n/a | n/a |
| MoMark Skia GPU | 80.22 | 86.28 | 4.99 | 5.21 | n/a | n/a |
| MoMark WGPU | 83.79 | 90.04 | 4.22 | 4.33 | n/a | n/a |
| GpMark.mbt (GPUI) | 10.49 | 12.27 | 5.56 | 5.79 | n/a | n/a |
| Flutter Skia | 9.76 | 10.29 | 0.55 | 0.74 | 0.65 | 1.55 |
| Flutter Impeller | 10.01 | 10.14 | 0.60 | 0.86 | 0.57 | 1.25 |
| Electron | 8.93 | 11.70 | 2.28 | 4.20 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 258.71/244.79/259.63 | 262.92/270.75/263.38 | 0.08/0.41/2.73 | 0.10/0.48/2.84 | 0.02/0.02/0.01 | 0.03/0.02/0.01 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 254.39/251.96/263.34 | 262.21/259.87/270.32 | 0.10/0.39/2.72 | 0.11/0.44/2.76 | 0.01/0.01/0.01 | 0.01/0.01/0.01 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 284.38/278.78/275.21 | 288.82/283.27/283.46 | 0.08/0.45/2.46 | 0.08/0.61/2.96 | 0.01/0.01/0.03 | 0.02/0.01/0.04 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 293.59/294.97/304.56 | 296.44/298.73/311.46 | 0.12/0.34/2.27 | 0.15/0.35/2.65 | 0.02/0.02/0.02 | 0.03/0.02/0.02 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 300.40/297.95/296.29 | 304.20/306.12/321.79 | 0.12/0.31/2.32 | 0.17/0.36/2.56 | 0.02/0.01/0.02 | 0.03/0.02/0.02 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 293.31/261.57/292.51 | 301.41/282.81/299.11 | 0.09/0.31/2.80 | 0.11/0.34/3.05 | 0.01/0.01/0.01 | 0.01/0.01/0.02 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 150.94/151.26/170.34 | 151.46/157.75/175.35 | 0.00/0.33/2.67 | 0.00/1.00/3.00 | 6.13/6.58/6.07 | 6.63/7.41/6.17 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 194.00/194.67/197.00 | 204.00/199.00/198.00 | 0.14/0.18/0.40 | 0.22/0.21/0.42 | 0.43/0.44/0.31 | 0.52/0.51/0.32 | 9.55/9.66/9.68 | 9.65/10.02/9.71 |
| Flutter Impeller | 197.67/205.67/193.00 | 203.00/207.00/199.00 | 0.17/0.17/0.53 | 0.30/0.21/0.71 | 0.43/0.54/0.36 | 0.62/0.58/0.43 | 7.45/7.16/7.40 | 7.64/7.22/7.89 |
| Electron | 383.33/353.00/372.67 | 388.00/356.00/381.00 | 9.47/8.74/9.16 | 10.02/9.65/10.30 | 383.33/353.00/372.67 | 388.00/356.00/381.00 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 304.62 | 313.73 | 25.03 | 28.49 | 0.02 | 0.02 | n/a | n/a |
| MoUI Skia GPU | 295.24 | 303.22 | 25.09 | 28.01 | 0.02 | 0.02 | n/a | n/a |
| MoUI WGPU | 327.40 | 330.77 | 26.94 | 27.96 | 0.01 | 0.02 | n/a | n/a |
| MoMark Skia Raster | 407.68 | 412.52 | 26.39 | 28.08 | 0.01 | 0.01 | n/a | n/a |
| MoMark Skia GPU | 413.90 | 431.15 | 25.75 | 27.30 | 0.02 | 0.03 | n/a | n/a |
| MoMark WGPU | 396.90 | 402.10 | 28.22 | 28.67 | 0.02 | 0.02 | n/a | n/a |
| GpMark.mbt (GPUI) | 254.29 | 258.08 | 24.67 | 26.00 | 7.28 | 8.11 | n/a | n/a |
| Flutter Skia | 228.33 | 229.00 | 4.29 | 5.46 | 0.35 | 0.38 | 9.58 | 9.76 |
| Flutter Impeller | 238.33 | 239.00 | 4.71 | 6.09 | 0.37 | 0.40 | 7.54 | 7.77 |
| Electron | 392.67 | 399.00 | 11.46 | 11.77 | 392.67 | 399.00 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 25.42/25.17/25.11 | 28.14/26.91/26.82 | 364/360/360 | 0.55/0.55/0.55 | 0.66/0.66/0.67 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 12.93/12.89/12.99 | 13.84/13.87/14.60 | 5/10/8 | 0.64/0.64/0.80 | 1.25/1.24/1.48 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 13.49/13.31/13.26 | 15.96/15.26/15.29 | 11/8/12 | 0.79/0.79/0.78 | 1.46/1.45/1.48 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 35.51/35.21/35.46 | 38.02/37.28/38.08 | 710/706/705 | 1.71/1.71/1.69 | 2.07/2.06/2.04 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 15.02/15.07/15.06 | 17.05/17.11/17.12 | 61/58/53 | 1.81/1.86/1.86 | 2.24/2.29/2.31 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 20.80/20.78/20.77 | 27.67/28.87/27.37 | 344/344/345 | 2.38/2.34/2.36 | 2.92/2.89/2.91 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 9.99/9.98/10.02 | 11.23/11.41/11.09 | n/a/n/a/n/a | 6.40/6.63/6.46 | 7.79/8.10/7.93 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 10.06/9.97/10.03 | 10.00/10.00/10.00 | 2/0/2 | 1.45/1.84/1.82 | 2.79/3.55/2.78 | 0.44/0.42/0.42 | 0.75/0.62/0.58 |
| Flutter Impeller | 9.94/10.06/9.97 | 10.00/10.00/10.00 | 0/3/0 | 1.54/1.89/1.89 | 2.87/2.91/3.04 | 0.44/0.41/0.41 | 0.80/0.69/0.67 |
| Electron | 9.94/9.95/9.96 | 11.40/11.70/11.50 | 0/0/0 | 1.96/2.07/2.01 | 2.60/2.70/2.70 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 25.12 | 26.72 | 361 | 0.54 | 0.63 | n/a | n/a |
| MoUI Skia GPU | 13.34 | 14.88 | 6 | 0.82 | 1.54 | n/a | n/a |
| MoUI WGPU | 13.43 | 15.54 | 13 | 0.80 | 1.47 | n/a | n/a |
| MoMark Skia Raster | 35.64 | 38.88 | 707 | 1.71 | 2.07 | n/a | n/a |
| MoMark Skia GPU | 15.01 | 17.24 | 59 | 1.89 | 2.37 | n/a | n/a |
| MoMark WGPU | 20.68 | 27.21 | 343 | 2.40 | 2.98 | n/a | n/a |
| GpMark.mbt (GPUI) | 10.01 | 11.21 | n/a | 6.42 | 7.82 | n/a | n/a |
| Flutter Skia | 10.00 | 10.00 | 1 | 1.81 | 2.81 | 0.42 | 0.66 |
| Flutter Impeller | 10.19 | 10.00 | 5 | 1.88 | 2.80 | 0.41 | 0.58 |
| Electron | 9.94 | 11.50 | 0 | 2.06 | 2.80 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoUI Skia Raster CPU small 258.7 ms（max 262.9 ms）；MoUI Skia Raster CPU medium 244.8 ms（max 270.8 ms）；MoUI Skia Raster CPU large 259.6 ms（max 263.4 ms）；MoUI Skia Raster CPU stress 304.6 ms（max 313.7 ms）；MoUI Skia GPU small 254.4 ms（max 262.2 ms）；MoUI Skia GPU medium 252.0 ms（max 259.9 ms）；MoUI Skia GPU large 263.3 ms（max 270.3 ms）；MoUI Skia GPU stress 295.2 ms（max 303.2 ms）；MoUI WGPU small 284.4 ms（max 288.8 ms）；MoUI WGPU medium 278.8 ms（max 283.3 ms）；MoUI WGPU large 275.2 ms（max 283.5 ms）；MoUI WGPU stress 327.4 ms（max 330.8 ms）；MoMark Skia Raster small 293.6 ms（max 296.4 ms）；MoMark Skia Raster medium 295.0 ms（max 298.7 ms）；MoMark Skia Raster large 304.6 ms（max 311.5 ms）；MoMark Skia Raster stress 407.7 ms（max 412.5 ms）；MoMark Skia GPU small 300.4 ms（max 304.2 ms）；MoMark Skia GPU medium 297.9 ms（max 306.1 ms）；MoMark Skia GPU large 296.3 ms（max 321.8 ms）；MoMark Skia GPU stress 413.9 ms（max 431.2 ms）；MoMark WGPU small 293.3 ms（max 301.4 ms）；MoMark WGPU medium 261.6 ms（max 282.8 ms）；MoMark WGPU large 292.5 ms（max 299.1 ms）；MoMark WGPU stress 396.9 ms（max 402.1 ms）；GpMark.mbt (GPUI) small 150.9 ms（max 151.5 ms）；GpMark.mbt (GPUI) medium 151.3 ms（max 157.7 ms）；GpMark.mbt (GPUI) large 170.3 ms（max 175.4 ms）；GpMark.mbt (GPUI) stress 254.3 ms（max 258.1 ms）；Flutter Skia small 194.0 ms（max 204.0 ms）；Flutter Skia medium 194.7 ms（max 199.0 ms）；Flutter Skia large 197.0 ms（max 198.0 ms）；Flutter Skia stress 228.3 ms（max 229.0 ms）；Flutter Impeller small 197.7 ms（max 203.0 ms）；Flutter Impeller medium 205.7 ms（max 207.0 ms）；Flutter Impeller large 193.0 ms（max 199.0 ms）；Flutter Impeller stress 238.3 ms（max 239.0 ms）；Electron small 383.3 ms（max 388.0 ms）；Electron medium 353.0 ms（max 356.0 ms）；Electron large 372.7 ms（max 381.0 ms）；Electron stress 392.7 ms（max 399.0 ms）。
- P1 输入尾延迟：MoUI Skia Raster CPU small P95 29.86 ms；MoUI Skia Raster CPU medium P95 29.32 ms；MoUI Skia Raster CPU large P95 36.73 ms；MoUI Skia Raster CPU stress P95 28.66 ms；MoUI Skia GPU small P95 19.64 ms；MoUI Skia GPU medium P95 19.89 ms；MoUI Skia GPU large P95 19.91 ms；MoUI Skia GPU stress P95 23.47 ms；MoUI WGPU small P95 19.95 ms；MoUI WGPU medium P95 19.95 ms；MoUI WGPU large P95 19.94 ms；MoUI WGPU stress P95 21.37 ms；MoMark Skia Raster small P95 38.15 ms；MoMark Skia Raster medium P95 40.34 ms；MoMark Skia Raster large P95 54.39 ms；MoMark Skia Raster stress P95 105.23 ms；MoMark Skia GPU small P95 19.94 ms；MoMark Skia GPU medium P95 19.97 ms；MoMark Skia GPU large P95 27.71 ms；MoMark Skia GPU stress P95 86.28 ms；MoMark WGPU small P95 25.36 ms；MoMark WGPU medium P95 27.28 ms；MoMark WGPU large P95 26.03 ms；MoMark WGPU stress P95 90.04 ms。
- 长帧（超预算）：MoUI Skia Raster CPU: small/input 30 次，max 38.66 ms, small/scroll 357 次，max 39.43 ms, medium/input 29 次，max 29.89 ms, medium/scroll 358 次，max 39.23 ms, large/input 28 次，max 40.38 ms, large/scroll 359 次，max 36.92 ms, stress/input 30 次，max 29.08 ms, stress/scroll 360 次，max 37.57 ms；MoUI Skia GPU: small/input 4 次，max 19.99 ms, small/scroll 5 次，max 20.03 ms, medium/input 4 次，max 20.01 ms, medium/scroll 9 次，max 20.00 ms, large/input 6 次，max 20.00 ms, large/scroll 8 次，max 20.02 ms, stress/input 12 次，max 27.25 ms, stress/scroll 6 次，max 19.99 ms；MoUI WGPU: small/input 5 次，max 20.02 ms, small/scroll 11 次，max 20.00 ms, medium/input 7 次，max 20.02 ms, medium/scroll 8 次，max 20.40 ms, large/input 7 次，max 20.03 ms, large/scroll 11 次，max 20.00 ms, stress/input 8 次，max 23.53 ms, stress/scroll 12 次，max 20.08 ms；MoMark Skia Raster: small/input 30 次，max 38.32 ms, small/scroll 360 次，max 50.51 ms, medium/input 30 次，max 51.46 ms, medium/scroll 360 次，max 40.00 ms, large/input 30 次，max 54.92 ms, large/scroll 360 次，max 40.70 ms, stress/input 30 次，max 110.60 ms, stress/scroll 360 次，max 50.03 ms；MoMark Skia GPU: small/input 20 次，max 20.43 ms, small/scroll 49 次，max 20.01 ms, medium/input 28 次，max 20.53 ms, medium/scroll 48 次，max 20.25 ms, large/input 30 次，max 30.01 ms, large/scroll 41 次，max 20.02 ms, stress/input 30 次，max 87.40 ms, stress/scroll 50 次，max 19.96 ms；MoMark WGPU: small/input 27 次，max 28.14 ms, small/scroll 338 次，max 44.08 ms, medium/input 29 次，max 29.97 ms, medium/scroll 338 次，max 37.35 ms, large/input 30 次，max 27.61 ms, large/scroll 340 次，max 38.49 ms, stress/input 30 次，max 90.85 ms, stress/scroll 336 次，max 34.15 ms；GpMark.mbt (GPUI): large/scroll 1 次，max 17.62 ms；Flutter Skia: small/input 2 次，max 40.00 ms, small/scroll 1 次，max 40.00 ms, medium/input 2 次，max 40.00 ms, large/input 2 次，max 40.00 ms, large/scroll 2 次，max 30.00 ms, stress/input 3 次，max 40.00 ms, stress/scroll 1 次，max 30.00 ms；Flutter Impeller: small/input 1 次，max 30.00 ms, medium/scroll 1 次，max 50.00 ms, large/input 2 次，max 40.00 ms, stress/input 2 次，max 40.00 ms, stress/scroll 3 次，max 40.01 ms。
- 丢帧（优先处理）：MoUI Skia Raster CPU: small/input 31 帧, small/scroll 364 帧, medium/input 29 帧, medium/scroll 360 帧, large/input 30 帧, large/scroll 360 帧, stress/input 30 帧, stress/scroll 361 帧；MoUI Skia GPU: small/input 4 帧, small/scroll 5 帧, medium/input 4 帧, medium/scroll 10 帧, large/input 6 帧, large/scroll 8 帧, stress/input 12 帧, stress/scroll 6 帧；MoUI WGPU: small/input 5 帧, small/scroll 11 帧, medium/input 7 帧, medium/scroll 8 帧, large/input 7 帧, large/scroll 12 帧, stress/input 9 帧, stress/scroll 13 帧；MoMark Skia Raster: small/input 58 帧, small/scroll 710 帧, medium/input 61 帧, medium/scroll 706 帧, large/input 63 帧, large/scroll 705 帧, stress/input 170 帧, stress/scroll 707 帧；MoMark Skia GPU: small/input 20 帧, small/scroll 61 帧, medium/input 28 帧, medium/scroll 58 帧, large/input 30 帧, large/scroll 53 帧, stress/input 127 帧, stress/scroll 59 帧；MoMark WGPU: small/input 27 帧, small/scroll 344 帧, medium/input 29 帧, medium/scroll 344 帧, large/input 30 帧, large/scroll 345 帧, stress/input 139 帧, stress/scroll 343 帧；Flutter Skia: small/input 4 帧, small/scroll 2 帧, medium/input 3 帧, large/input 3 帧, large/scroll 2 帧, stress/input 4 帧, stress/scroll 1 帧；Flutter Impeller: small/input 1 帧, medium/scroll 3 帧, large/input 4 帧, stress/input 3 帧, stress/scroll 5 帧；Electron: stress/input 1 帧。
- 解释：首帧异常优先检查窗口/渲染器初始化；输入尾延迟检查 action 到下一可见帧的调度与同步重建；长帧检查解析、布局、文本 shaping 和 GPU 提交；`n/a` 表示未埋点，不等于 0。
- 普通模式的长帧、帧间隔和输入延迟是各框架回调诊断，不能替代跨框架 compositor 排名；需要严格结论时运行 `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`。

## 采集口径

- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。
- `frame_work_ms` 统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏；对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `device_present_ms`：设备/上屏侧统一字段。MoUI raster 为 Skia CPU 光栅化+像素回读整体；MoUI GPU/wgpu 为提交后同步等待设备完成（headless host-surface 逐帧同步，真实应用的 vsync 流水线可重叠掉一部分，该值应视为上屏成本上界）；窗口模式（`window_mode=native-window`）下 MoUI 由真实 AppKit 窗口上屏，适配器侧不单独计时，显示 `n/a`；Flutter 为 `FrameTiming.rasterDuration`（光栅线程任务时间，含显示列表光栅化与 GPU 提交、不含设备完成等待）；GPUI 与 Electron 适配器侧无法观测，显示 `n/a`。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧，统一口径为「进程起点 → 首帧可交互」（全包含）：MoUI 在 main 入口打点（含渲染器构建，headless 无平台窗口成本）；Flutter 优先取 runner 在进程起点打点的 epoch（env 缺失时退回 Dart 最早时刻，Flutter 引擎与原生窗口创建计入）；Electron 取 main.js 首个 JS 时刻（Chromium 主进程初始化、窗口创建与页面加载计入）；GPUI 从 MoonBit main 入口打点（AppKit 初始化、Metal 渲染器与首帧计入）。打开场景没有前一帧，所以不计算 interval/drop。严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代。
- 跨框架比较注意：MoUI/MoMark 系列与 Flutter/Electron/GPUI 现默认同为原生窗口（native-window）模式，时钟同为进程起点 → 首帧可交互；旧 headless host-surface 模式可用 `UI_BENCHMARK_HEADLESS=1` 复现（无真实窗口/合成器成本，帧间隔为未同步的帧生产耗时，与窗口模式的 vsync 间隔语义不同）。GPUI 另可用 `GPUI_OPEN_TRACE=1` 输出启动分相（应用初始化 / 窗口创建 / 首帧）。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。
