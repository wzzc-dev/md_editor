# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-06T16:04:14Z`
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
| moui-skia-raster | small | open | ui-frame | 75.029/93.595 | - | - | - | 7.93 ms | 0.00 ms | 7.93 ms | 84.73 ms | n/a | measured |
| moui-skia-raster | small | input | ui-frame | 0.671/0.885 | - | 2.253/2.821 | 2.251/2.820 | 1.32 ms | 0.00 ms | 1.32 ms | 68.46 ms | n/a | measured |
| moui-skia-raster | small | scroll | ui-frame | 0.749/1.222 | - | 2.180/2.936 | - | 1.11 ms | 0.00 ms | 1.11 ms | 69.98 ms | n/a | measured |
| moui-skia-raster | medium | open | ui-frame | 66.447/72.105 | - | - | - | 5.61 ms | 0.00 ms | 5.61 ms | 73.78 ms | n/a | measured |
| moui-skia-raster | medium | input | ui-frame | 0.906/1.683 | - | 2.790/4.108 | 2.789/4.106 | 1.55 ms | 0.00 ms | 1.55 ms | 76.37 ms | n/a | measured |
| moui-skia-raster | medium | scroll | ui-frame | 0.692/0.999 | - | 1.969/2.543 | - | 0.99 ms | 0.00 ms | 0.99 ms | 64.72 ms | n/a | measured |
| moui-skia-raster | large | open | ui-frame | 56.499/57.001 | - | - | - | 5.58 ms | 0.00 ms | 5.58 ms | 65.43 ms | n/a | measured |
| moui-skia-raster | large | input | ui-frame | 0.652/0.792 | - | 2.312/2.794 | 2.312/2.794 | 1.18 ms | 0.00 ms | 1.18 ms | 68.06 ms | n/a | measured |
| moui-skia-raster | large | scroll | ui-frame | 0.660/0.936 | - | 1.883/2.370 | - | 0.96 ms | 0.00 ms | 0.96 ms | 68.50 ms | n/a | measured |
| moui-skia-raster | stress | open | ui-frame | 59.734/62.560 | - | - | - | 5.71 ms | 0.00 ms | 5.71 ms | 87.24 ms | n/a | measured |
| moui-skia-raster | stress | input | ui-frame | 0.829/1.217 | - | 5.906/7.272 | 5.905/7.271 | 1.25 ms | 0.00 ms | 1.25 ms | 82.90 ms | n/a | measured |
| moui-skia-raster | stress | scroll | ui-frame | 0.642/0.850 | - | 1.849/2.282 | - | 0.94 ms | 0.00 ms | 0.94 ms | 82.43 ms | n/a | measured |
| moui-skia-gpu | small | open | ui-frame | 55.782/57.443 | - | - | - | 18.24 ms | n/a | 0.00 ms | 75.48 ms | n/a | measured |
| moui-skia-gpu | small | input | ui-frame | 0.934/1.511 | - | 8.469/9.631 | 8.468/9.631 | 7.19 ms | n/a | 0.00 ms | 79.65 ms | n/a | measured |
| moui-skia-gpu | small | scroll | ui-frame | 0.736/0.969 | - | 8.330/9.315 | - | 7.19 ms | n/a | 0.00 ms | 73.01 ms | n/a | measured |
| moui-skia-gpu | medium | open | ui-frame | 69.465/102.808 | - | - | - | 15.45 ms | n/a | 0.00 ms | 86.37 ms | n/a | measured |
| moui-skia-gpu | medium | input | ui-frame | 0.800/0.971 | - | 8.370/9.538 | 8.368/9.535 | 7.22 ms | n/a | 0.00 ms | 71.88 ms | n/a | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 0.720/0.933 | - | 8.331/9.297 | - | 7.18 ms | n/a | 0.00 ms | 75.20 ms | n/a | measured |
| moui-skia-gpu | large | open | ui-frame | 55.310/57.137 | - | - | - | 19.19 ms | n/a | 0.00 ms | 77.72 ms | n/a | measured |
| moui-skia-gpu | large | input | ui-frame | 0.833/1.132 | - | 8.359/9.477 | 8.357/9.476 | 6.95 ms | n/a | 0.00 ms | 74.99 ms | n/a | measured |
| moui-skia-gpu | large | scroll | ui-frame | 0.710/0.892 | - | 8.333/9.332 | - | 7.21 ms | n/a | 0.00 ms | 76.72 ms | n/a | measured |
| moui-skia-gpu | stress | open | ui-frame | 53.246/53.390 | - | - | - | 15.71 ms | n/a | 0.00 ms | 89.06 ms | n/a | measured |
| moui-skia-gpu | stress | input | ui-frame | 1.002/1.749 | - | 10.183/17.079 | 10.182/17.077 | 4.72 ms | n/a | 0.00 ms | 93.79 ms | n/a | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 0.720/0.939 | - | 8.338/9.306 | - | 7.21 ms | n/a | 0.00 ms | 91.02 ms | n/a | measured |
| moui-wgpu | small | open | ui-frame | 55.477/60.758 | - | - | - | 11.57 ms | n/a | 0.00 ms | 68.42 ms | n/a | measured |
| moui-wgpu | small | input | ui-frame | 0.750/0.930 | - | 8.135/9.569 | 8.134/9.568 | 7.06 ms | n/a | 0.00 ms | 75.40 ms | n/a | measured |
| moui-wgpu | small | scroll | ui-frame | 0.794/1.063 | - | 8.331/9.581 | - | 7.11 ms | n/a | 0.00 ms | 71.92 ms | n/a | measured |
| moui-wgpu | medium | open | ui-frame | 65.917/69.047 | - | - | - | 12.78 ms | n/a | 0.00 ms | 80.28 ms | n/a | measured |
| moui-wgpu | medium | input | ui-frame | 1.062/1.869 | - | 8.123/10.025 | 8.122/10.023 | 6.62 ms | n/a | 0.00 ms | 73.64 ms | n/a | measured |
| moui-wgpu | medium | scroll | ui-frame | 0.848/1.219 | - | 8.326/9.539 | - | 7.05 ms | n/a | 0.00 ms | 74.53 ms | n/a | measured |
| moui-wgpu | large | open | ui-frame | 67.632/68.552 | - | - | - | 13.29 ms | n/a | 0.00 ms | 84.17 ms | n/a | measured |
| moui-wgpu | large | input | ui-frame | 0.920/1.294 | - | 8.032/10.869 | 8.031/10.869 | 6.35 ms | n/a | 0.00 ms | 88.45 ms | n/a | measured |
| moui-wgpu | large | scroll | ui-frame | 0.795/1.017 | - | 8.328/9.552 | - | 7.10 ms | n/a | 0.00 ms | 81.91 ms | n/a | measured |
| moui-wgpu | stress | open | ui-frame | 60.660/72.195 | - | - | - | 12.67 ms | n/a | 0.00 ms | 93.58 ms | n/a | measured |
| moui-wgpu | stress | input | ui-frame | 0.809/1.105 | - | 8.410/9.579 | 8.409/9.578 | 3.62 ms | n/a | 0.00 ms | 95.32 ms | n/a | measured |
| moui-wgpu | stress | scroll | ui-frame | 0.852/1.144 | - | 8.372/9.548 | - | 7.08 ms | n/a | 0.00 ms | 100.11 ms | n/a | measured |
| moui-md-skia-raster | small | open | ui-frame | 61.451/62.045 | - | - | - | 15.15 ms | 0.00 ms | 15.15 ms | 78.59 ms | n/a | measured |
| moui-md-skia-raster | small | input | ui-frame | 4.332/4.896 | - | 8.325/8.750 | 8.291/8.742 | 3.54 ms | 0.00 ms | 3.54 ms | 79.25 ms | n/a | measured |
| moui-md-skia-raster | small | scroll | ui-frame | 1.091/1.343 | - | 4.074/4.792 | - | 2.74 ms | 0.00 ms | 2.74 ms | 75.09 ms | n/a | measured |
| moui-md-skia-raster | medium | open | ui-frame | 63.472/64.455 | - | - | - | 15.51 ms | 0.00 ms | 15.51 ms | 82.28 ms | n/a | measured |
| moui-md-skia-raster | medium | input | ui-frame | 4.276/4.806 | - | 8.290/9.354 | 8.249/9.353 | 3.42 ms | 0.00 ms | 3.42 ms | 80.92 ms | n/a | measured |
| moui-md-skia-raster | medium | scroll | ui-frame | 1.070/1.313 | - | 4.081/4.792 | - | 2.77 ms | 0.00 ms | 2.77 ms | 77.13 ms | n/a | measured |
| moui-md-skia-raster | large | open | ui-frame | 63.186/64.237 | - | - | - | 15.32 ms | 0.00 ms | 15.32 ms | 94.84 ms | n/a | measured |
| moui-md-skia-raster | large | input | ui-frame | 4.830/5.415 | - | 10.661/12.067 | 10.606/12.065 | 3.52 ms | 0.00 ms | 3.52 ms | 94.67 ms | n/a | measured |
| moui-md-skia-raster | large | scroll | ui-frame | 1.102/1.385 | - | 4.189/4.989 | - | 2.83 ms | 0.00 ms | 2.83 ms | 91.11 ms | n/a | measured |
| moui-md-skia-raster | stress | open | ui-frame | 63.027/64.537 | - | - | - | 16.81 ms | 0.00 ms | 16.81 ms | 228.59 ms | n/a | measured |
| moui-md-skia-raster | stress | input | ui-frame | 4.624/5.280 | - | 28.683/31.167 | 28.378/30.734 | 3.84 ms | 0.00 ms | 3.84 ms | 222.57 ms | n/a | measured |
| moui-md-skia-raster | stress | scroll | ui-frame | 1.143/1.454 | - | 4.397/5.205 | - | 2.94 ms | 0.00 ms | 2.94 ms | 218.85 ms | n/a | measured |
| moui-md-skia-gpu | small | open | ui-frame | 55.504/56.661 | - | - | - | 48.78 ms | n/a | 0.00 ms | 106.24 ms | n/a | measured |
| moui-md-skia-gpu | small | input | ui-frame | 4.285/4.955 | - | 10.008/11.291 | 9.977/11.066 | 5.24 ms | n/a | 0.00 ms | 121.23 ms | n/a | measured |
| moui-md-skia-gpu | small | scroll | ui-frame | 1.192/1.583 | - | 8.376/9.403 | - | 6.87 ms | n/a | 0.00 ms | 124.01 ms | n/a | measured |
| moui-md-skia-gpu | medium | open | ui-frame | 55.900/56.498 | - | - | - | 54.80 ms | n/a | 0.00 ms | 114.00 ms | n/a | measured |
| moui-md-skia-gpu | medium | input | ui-frame | 4.266/4.766 | - | 9.972/11.044 | 9.939/11.042 | 5.05 ms | n/a | 0.00 ms | 116.49 ms | n/a | measured |
| moui-md-skia-gpu | medium | scroll | ui-frame | 1.210/1.578 | - | 8.488/9.702 | - | 6.95 ms | n/a | 0.00 ms | 119.09 ms | n/a | measured |
| moui-md-skia-gpu | large | open | ui-frame | 58.007/59.512 | - | - | - | 57.42 ms | n/a | 0.00 ms | 130.77 ms | n/a | measured |
| moui-md-skia-gpu | large | input | ui-frame | 4.274/4.531 | - | 9.994/11.017 | 9.935/10.971 | 3.48 ms | n/a | 0.00 ms | 124.60 ms | n/a | measured |
| moui-md-skia-gpu | large | scroll | ui-frame | 1.172/1.516 | - | 8.377/9.405 | - | 6.87 ms | n/a | 0.00 ms | 127.13 ms | n/a | measured |
| moui-md-skia-gpu | stress | open | ui-frame | 58.498/59.310 | - | - | - | 58.96 ms | n/a | 0.00 ms | 263.98 ms | n/a | measured |
| moui-md-skia-gpu | stress | input | ui-frame | 4.868/5.764 | - | 30.001/31.217 | 29.694/30.654 | 5.63 ms | n/a | 0.00 ms | 259.38 ms | n/a | measured |
| moui-md-skia-gpu | stress | scroll | ui-frame | 1.236/1.671 | - | 8.603/9.535 | - | 6.99 ms | n/a | 0.00 ms | 296.20 ms | n/a | measured |
| moui-md-wgpu | small | open | ui-frame | 64.832/65.893 | - | - | - | 18.93 ms | n/a | 0.00 ms | 85.77 ms | n/a | measured |
| moui-md-wgpu | small | input | ui-frame | 1.872/2.304 | - | 18.843/49.985 | 18.805/49.984 | 16.46 ms | n/a | 0.00 ms | 88.00 ms | n/a | measured |
| moui-md-wgpu | small | scroll | ui-frame | 1.549/2.063 | - | 22.886/33.170 | - | 20.94 ms | n/a | 0.00 ms | 81.88 ms | n/a | measured |
| moui-md-wgpu | medium | open | ui-frame | 71.091/72.897 | - | - | - | 19.69 ms | n/a | 0.00 ms | 93.71 ms | n/a | measured |
| moui-md-wgpu | medium | input | ui-frame | 2.021/3.076 | - | 20.011/56.325 | 19.974/56.325 | 17.31 ms | n/a | 0.00 ms | 89.39 ms | n/a | measured |
| moui-md-wgpu | medium | scroll | ui-frame | 1.569/2.024 | - | 23.339/32.501 | - | 21.34 ms | n/a | 0.00 ms | 89.45 ms | n/a | measured |
| moui-md-wgpu | large | open | ui-frame | 68.715/70.161 | - | - | - | 18.61 ms | n/a | 0.00 ms | 103.28 ms | n/a | measured |
| moui-md-wgpu | large | input | ui-frame | 1.897/2.362 | - | 15.474/30.188 | 15.401/30.186 | 11.11 ms | n/a | 0.00 ms | 110.11 ms | n/a | measured |
| moui-md-wgpu | large | scroll | ui-frame | 1.532/2.027 | - | 22.258/33.146 | - | 20.32 ms | n/a | 0.00 ms | 102.28 ms | n/a | measured |
| moui-md-wgpu | stress | open | ui-frame | 65.818/69.133 | - | - | - | 18.16 ms | n/a | 0.00 ms | 227.45 ms | n/a | measured |
| moui-md-wgpu | stress | input | ui-frame | 1.863/2.156 | - | 26.045/29.388 | 25.703/27.342 | 3.86 ms | n/a | 0.00 ms | 260.31 ms | n/a | measured |
| moui-md-wgpu | stress | scroll | ui-frame | 1.526/2.011 | - | 22.966/31.819 | - | 21.00 ms | n/a | 0.00 ms | 232.87 ms | n/a | measured |
| gpmark | small | open | ui-frame | 6.605/7.611 | - | - | - | n/a | n/a | n/a | 231.54 ms | n/a | measured |
| gpmark | small | input | ui-frame | 5.826/6.335 | 0.378/0.466 | 12.714/30.396 | 12.709/30.392 | n/a | n/a | n/a | 208.12 ms | n/a | measured |
| gpmark | small | scroll | ui-frame | 6.929/8.469 | 0.004/0.006 | 10.415/14.650 | - | n/a | n/a | n/a | 212.99 ms | n/a | measured |
| gpmark | medium | open | ui-frame | 6.735/7.054 | - | - | - | n/a | n/a | n/a | 203.71 ms | n/a | measured |
| gpmark | medium | input | ui-frame | 5.853/6.313 | 0.446/0.594 | 13.063/41.773 | 13.059/41.770 | n/a | n/a | n/a | 239.50 ms | n/a | measured |
| gpmark | medium | scroll | ui-frame | 6.930/8.355 | 0.004/0.007 | 10.329/12.637 | - | n/a | n/a | n/a | 226.83 ms | n/a | measured |
| gpmark | large | open | ui-frame | 6.421/6.742 | - | - | - | n/a | n/a | n/a | 212.43 ms | n/a | measured |
| gpmark | large | input | ui-frame | 5.895/6.372 | 0.941/1.436 | 13.477/33.338 | 13.473/33.335 | n/a | n/a | n/a | 230.20 ms | n/a | measured |
| gpmark | large | scroll | ui-frame | 7.003/8.613 | 0.003/0.006 | 10.403/14.575 | - | n/a | n/a | n/a | 208.36 ms | n/a | measured |
| gpmark | stress | open | ui-frame | 6.487/6.581 | - | - | - | n/a | n/a | n/a | 187.38 ms | n/a | measured |
| gpmark | stress | input | ui-frame | 5.872/6.410 | 5.842/7.569 | 16.190/37.343 | 16.186/37.337 | n/a | n/a | n/a | 187.38 ms | n/a | measured |
| gpmark | stress | scroll | ui-frame | 6.996/8.512 | 0.003/0.006 | 10.362/14.641 | - | n/a | n/a | n/a | 187.18 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 0.566/0.694 | - | - | - | 12.06 ms | n/a | n/a | 41.23 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 0.839/1.584 | - | 10.334/10.010 | 10.040/12.488 | 0.85 ms | n/a | n/a | 50.11 ms | 1 | measured |
| flutter-skia | small | scroll | ui-frame | 1.687/2.043 | - | 10.028/10.002 | - | 0.57 ms | n/a | n/a | 45.57 ms | 2 | measured |
| flutter-skia | medium | open | ui-frame | 0.420/0.590 | - | - | - | 11.32 ms | n/a | n/a | 44.95 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 0.771/1.119 | - | 10.000/10.002 | 10.057/17.305 | 0.79 ms | n/a | n/a | 42.32 ms | 0 | measured |
| flutter-skia | medium | scroll | ui-frame | 2.153/2.925 | - | 10.056/10.002 | - | 0.51 ms | n/a | n/a | 42.85 ms | 3 | measured |
| flutter-skia | large | open | ui-frame | 0.316/0.352 | - | - | - | 9.20 ms | n/a | n/a | 44.68 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 0.761/1.073 | - | 10.667/20.002 | 10.042/12.732 | 0.73 ms | n/a | n/a | 46.80 ms | 2 | measured |
| flutter-skia | large | scroll | ui-frame | 2.182/2.995 | - | 10.000/10.002 | - | 0.51 ms | n/a | n/a | 46.13 ms | 2 | measured |
| flutter-skia | stress | open | ui-frame | 0.603/0.776 | - | - | - | 12.49 ms | n/a | n/a | 83.99 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 0.850/1.271 | - | 10.667/20.000 | 10.746/20.444 | 0.79 ms | n/a | n/a | 84.46 ms | 2 | measured |
| flutter-skia | stress | scroll | ui-frame | 2.223/2.995 | - | 10.000/10.002 | - | 0.53 ms | n/a | n/a | 82.61 ms | 1 | measured |
| flutter-impeller | small | open | ui-frame | 0.480/0.562 | - | - | - | 7.90 ms | n/a | n/a | 43.36 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 0.809/1.072 | - | 10.000/10.006 | 10.390/17.299 | 0.94 ms | n/a | n/a | 46.42 ms | 1 | measured |
| flutter-impeller | small | scroll | ui-frame | 1.721/2.107 | - | 10.000/10.002 | - | 0.54 ms | n/a | n/a | 45.72 ms | 1 | measured |
| flutter-impeller | medium | open | ui-frame | 0.599/0.836 | - | - | - | 8.34 ms | n/a | n/a | 43.26 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 0.749/0.993 | - | 10.000/20.000 | 10.723/20.485 | 0.94 ms | n/a | n/a | 47.74 ms | 2 | measured |
| flutter-impeller | medium | scroll | ui-frame | 2.216/3.042 | - | 10.000/10.002 | - | 0.52 ms | n/a | n/a | 44.04 ms | 2 | measured |
| flutter-impeller | large | open | ui-frame | 0.572/0.630 | - | - | - | 8.66 ms | n/a | n/a | 47.53 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 0.857/1.153 | - | 10.667/10.003 | 9.996/12.530 | 0.80 ms | n/a | n/a | 47.29 ms | 1 | measured |
| flutter-impeller | large | scroll | ui-frame | 2.216/2.940 | - | 10.000/10.002 | - | 0.52 ms | n/a | n/a | 50.74 ms | 2 | measured |
| flutter-impeller | stress | open | ui-frame | 0.539/0.640 | - | - | - | 9.70 ms | n/a | n/a | 89.70 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 0.802/1.160 | - | 10.001/10.003 | 9.618/11.410 | 0.81 ms | n/a | n/a | 82.66 ms | 0 | measured |
| flutter-impeller | stress | scroll | ui-frame | 2.285/3.076 | - | 10.000/10.002 | - | 0.51 ms | n/a | n/a | 88.02 ms | 1 | measured |
| electron | small | open | ui-frame | 115.433/127.700 | - | - | - | n/a | n/a | n/a | 115.43 ms | 0 | measured |
| electron | small | input | ui-frame | 2.607/4.300 | - | 9.485/11.104 | 8.623/10.400 | n/a | n/a | n/a | 125.30 ms | 0 | measured |
| electron | small | scroll | ui-frame | 2.251/3.100 | - | 10.010/11.800 | - | n/a | n/a | n/a | 111.53 ms | 0 | measured |
| electron | medium | open | ui-frame | 97.167/107.100 | - | - | - | n/a | n/a | n/a | 97.17 ms | 0 | measured |
| electron | medium | input | ui-frame | 2.597/3.900 | - | 9.528/10.204 | 8.580/10.300 | n/a | n/a | n/a | 117.93 ms | 0 | measured |
| electron | medium | scroll | ui-frame | 2.311/2.900 | - | 9.995/11.900 | - | n/a | n/a | n/a | 120.17 ms | 2 | measured |
| electron | large | open | ui-frame | 96.900/102.900 | - | - | - | n/a | n/a | n/a | 96.90 ms | 0 | measured |
| electron | large | input | ui-frame | 2.410/2.900 | - | 9.563/10.104 | 8.700/10.400 | n/a | n/a | n/a | 109.83 ms | 0 | measured |
| electron | large | scroll | ui-frame | 2.317/3.000 | - | 9.930/11.500 | - | n/a | n/a | n/a | 114.60 ms | 0 | measured |
| electron | stress | open | ui-frame | 116.033/119.100 | - | - | - | n/a | n/a | n/a | 116.03 ms | 0 | measured |
| electron | stress | input | ui-frame | 2.480/3.500 | - | 9.718/10.800 | 8.927/10.900 | n/a | n/a | n/a | 112.93 ms | 1 | measured |
| electron | stress | scroll | ui-frame | 2.344/3.000 | - | 9.993/11.600 | - | n/a | n/a | n/a | 117.87 ms | 0 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.18/1.97/1.88 | 2.94/2.54/2.37 | n/a/n/a/n/a | 0.75/0.69/0.66 | 1.22/1.00/0.94 | 1.11/0.99/0.96 | 1.68/1.36/1.24 |
| MoUI Skia GPU | 8.33/8.33/8.33 | 9.32/9.30/9.33 | n/a/n/a/n/a | 0.74/0.72/0.71 | 0.97/0.93/0.89 | 7.19/7.18/7.21 | 8.13/8.11/8.14 |
| MoUI WGPU | 8.33/8.33/8.33 | 9.58/9.54/9.55 | n/a/n/a/n/a | 0.79/0.85/0.80 | 1.06/1.22/1.02 | 7.11/7.05/7.10 | 8.50/8.48/8.51 |
| MoMark Skia Raster | 4.07/4.08/4.19 | 4.79/4.79/4.99 | n/a/n/a/n/a | 1.09/1.07/1.10 | 1.34/1.31/1.38 | 2.74/2.77/2.83 | 3.24/3.32/3.39 |
| MoMark Skia GPU | 8.38/8.49/8.38 | 9.40/9.70/9.41 | n/a/n/a/n/a | 1.19/1.21/1.17 | 1.58/1.58/1.52 | 6.87/6.95/6.87 | 7.87/8.21/7.97 |
| MoMark WGPU | 22.89/23.34/22.26 | 33.17/32.50/33.15 | n/a/n/a/n/a | 1.55/1.57/1.53 | 2.06/2.02/2.03 | 20.94/21.34/20.32 | 31.50/30.03/31.21 |
| GpMark.mbt (GPUI) | 10.42/10.33/10.40 | 14.65/12.64/14.58 | n/a/n/a/n/a | 6.93/6.93/7.00 | 8.47/8.36/8.61 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 10.03/10.06/10.00 | 10.00/10.00/10.00 | 2/3/2 | 1.69/2.15/2.18 | 2.04/2.92/3.00 | 0.57/0.51/0.51 | 0.81/0.72/0.75 |
| Flutter Impeller | 10.00/10.00/10.00 | 10.00/10.00/10.00 | 1/2/2 | 1.72/2.22/2.22 | 2.11/3.04/2.94 | 0.54/0.52/0.52 | 0.78/0.75/0.96 |
| Electron | 10.01/10.00/9.93 | 11.80/11.90/11.50 | 0/2/0 | 2.25/2.31/2.32 | 3.10/2.90/3.00 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.85 | 2.28 | n/a | 0.64 | 0.85 | 0.94 | 1.25 |
| MoUI Skia GPU | 8.34 | 9.31 | n/a | 0.72 | 0.94 | 7.21 | 8.12 |
| MoUI WGPU | 8.37 | 9.55 | n/a | 0.85 | 1.14 | 7.08 | 8.52 |
| MoMark Skia Raster | 4.40 | 5.21 | n/a | 1.14 | 1.45 | 2.94 | 3.55 |
| MoMark Skia GPU | 8.60 | 9.53 | n/a | 1.24 | 1.67 | 6.99 | 8.02 |
| MoMark WGPU | 22.97 | 31.82 | n/a | 1.53 | 2.01 | 21.00 | 29.31 |
| GpMark.mbt (GPUI) | 10.36 | 14.64 | n/a | 7.00 | 8.51 | n/a | n/a |
| Flutter Skia | 10.00 | 10.00 | 1 | 2.22 | 3.00 | 0.53 | 0.91 |
| Flutter Impeller | 10.00 | 10.00 | 1 | 2.29 | 3.08 | 0.51 | 0.77 |
| Electron | 9.99 | 11.60 | 0 | 2.34 | 3.00 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.25/2.79/2.31 | 2.82/4.11/2.79 | 0.67/0.91/0.65 | 0.89/1.68/0.79 | 1.32/1.55/1.18 | 1.76/2.57/1.48 |
| MoUI Skia GPU | 8.47/8.37/8.36 | 9.63/9.53/9.48 | 0.93/0.80/0.83 | 1.51/0.97/1.13 | 7.19/7.22/6.95 | 8.54/8.42/8.26 |
| MoUI WGPU | 8.13/8.12/8.03 | 9.57/10.02/10.87 | 0.75/1.06/0.92 | 0.93/1.87/1.29 | 7.06/6.62/6.35 | 8.70/8.75/8.89 |
| MoMark Skia Raster | 8.29/8.25/10.61 | 8.74/9.35/12.07 | 4.33/4.28/4.83 | 4.90/4.81/5.42 | 3.54/3.42/3.52 | 3.93/4.36/4.65 |
| MoMark Skia GPU | 9.98/9.94/9.93 | 11.07/11.04/10.97 | 4.29/4.27/4.27 | 4.96/4.77/4.53 | 5.24/5.05/3.48 | 6.10/5.70/4.25 |
| MoMark WGPU | 18.80/19.97/15.40 | 49.98/56.32/30.19 | 1.87/2.02/1.90 | 2.30/3.08/2.36 | 16.46/17.31/11.11 | 48.10/53.51/25.39 |
| GpMark.mbt (GPUI) | 12.71/13.06/13.47 | 30.39/41.77/33.33 | 5.83/5.85/5.89 | 6.33/6.31/6.37 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 10.04/10.06/10.04 | 12.49/17.30/12.73 | 0.84/0.77/0.76 | 1.58/1.12/1.07 | 0.85/0.79/0.73 | 1.87/1.72/1.47 |
| Flutter Impeller | 10.39/10.72/10.00 | 17.30/20.48/12.53 | 0.81/0.75/0.86 | 1.07/0.99/1.15 | 0.94/0.94/0.80 | 1.69/1.89/1.41 |
| Electron | 8.62/8.58/8.70 | 10.40/10.30/10.40 | 2.61/2.60/2.41 | 4.30/3.90/2.90 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 5.91 | 7.27 | 0.83 | 1.22 | 1.25 | 1.51 |
| MoUI Skia GPU | 10.18 | 17.08 | 1.00 | 1.75 | 4.72 | 6.43 |
| MoUI WGPU | 8.41 | 9.58 | 0.81 | 1.10 | 3.62 | 5.54 |
| MoMark Skia Raster | 28.38 | 30.73 | 4.62 | 5.28 | 3.84 | 4.36 |
| MoMark Skia GPU | 29.69 | 30.65 | 4.87 | 5.76 | 5.63 | 7.72 |
| MoMark WGPU | 25.70 | 27.34 | 1.86 | 2.16 | 3.86 | 5.21 |
| GpMark.mbt (GPUI) | 16.19 | 37.34 | 5.87 | 6.41 | n/a | n/a |
| Flutter Skia | 10.75 | 20.44 | 0.85 | 1.27 | 0.79 | 1.66 |
| Flutter Impeller | 9.62 | 11.41 | 0.80 | 1.16 | 0.81 | 1.97 |
| Electron | 8.93 | 10.90 | 2.48 | 3.50 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 84.73/73.78/65.43 | 105.32/78.98/66.50 | 0.16/0.39/2.68 | 0.25/0.45/2.79 | 75.03/66.45/56.50 | 93.59/72.11/57.00 | 7.93/5.61/5.58 | 9.59/5.93/5.91 |
| MoUI Skia GPU | 75.48/86.37/77.72 | 80.20/118.28/77.99 | 0.15/0.35/2.69 | 0.20/0.39/2.83 | 55.78/69.46/55.31 | 57.44/102.81/57.14 | 18.24/15.45/19.19 | 21.15/16.65/20.69 |
| MoUI WGPU | 68.42/80.28/84.17 | 73.69/83.54/85.63 | 0.11/0.37/2.32 | 0.13/0.47/2.75 | 55.48/65.92/67.63 | 60.76/69.05/68.55 | 11.57/12.78/13.29 | 12.38/13.27/13.58 |
| MoMark Skia Raster | 78.59/82.28/94.84 | 79.36/84.20/96.32 | 0.10/0.30/2.69 | 0.12/0.36/2.83 | 61.45/63.47/63.19 | 62.05/64.45/64.24 | 15.15/15.51/15.32 | 15.48/16.61/16.72 |
| MoMark Skia GPU | 106.24/114.00/130.77 | 110.47/118.01/140.31 | 0.07/0.38/2.26 | 0.07/0.54/2.86 | 55.50/55.90/58.01 | 56.66/56.50/59.51 | 48.78/54.80/57.42 | 53.79/58.51/64.63 |
| MoMark WGPU | 85.77/93.71/103.28 | 86.87/95.86/105.29 | 0.12/0.29/2.65 | 0.14/0.32/2.72 | 64.83/71.09/68.72 | 65.89/72.90/70.16 | 18.93/19.69/18.61 | 19.55/20.11/18.95 |
| GpMark.mbt (GPUI) | 231.54/203.71/212.43 | 288.03/226.77/222.89 | 0.00/0.67/2.67 | 0.00/1.00/3.00 | 6.61/6.74/6.42 | 7.61/7.05/6.74 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 41.23/44.95/44.68 | 43.14/47.73/49.07 | 0.15/0.17/0.51 | 0.17/0.19/0.61 | 0.57/0.42/0.32 | 0.69/0.59/0.35 | 12.06/11.32/9.20 | 12.45/12.62/9.51 |
| Flutter Impeller | 43.36/43.26/47.53 | 46.97/45.81/49.62 | 0.12/0.17/0.53 | 0.13/0.20/0.55 | 0.48/0.60/0.57 | 0.56/0.84/0.63 | 7.90/8.34/8.66 | 9.68/9.77/9.08 |
| Electron | 115.43/97.17/96.90 | 127.70/107.10/102.90 | 9.97/12.49/13.23 | 12.85/12.97/13.82 | 115.43/97.17/96.90 | 127.70/107.10/102.90 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 87.24 | 90.71 | 25.91 | 26.52 | 59.73 | 62.56 | 5.71 | 6.98 |
| MoUI Skia GPU | 89.06 | 92.36 | 25.57 | 27.46 | 53.25 | 53.39 | 15.71 | 18.81 |
| MoUI WGPU | 93.58 | 108.82 | 29.61 | 37.50 | 60.66 | 72.19 | 12.67 | 15.68 |
| MoMark Skia Raster | 228.59 | 232.36 | 26.50 | 28.47 | 63.03 | 64.54 | 16.81 | 18.88 |
| MoMark Skia GPU | 263.98 | 272.64 | 23.87 | 28.56 | 58.50 | 59.31 | 58.96 | 67.67 |
| MoMark WGPU | 227.45 | 230.60 | 23.23 | 26.61 | 65.82 | 69.13 | 18.16 | 18.90 |
| GpMark.mbt (GPUI) | 187.38 | 206.64 | 28.00 | 31.00 | 6.49 | 6.58 | n/a | n/a |
| Flutter Skia | 83.99 | 86.63 | 3.37 | 3.54 | 0.60 | 0.78 | 12.49 | 12.67 |
| Flutter Impeller | 89.70 | 100.92 | 3.17 | 3.28 | 0.54 | 0.64 | 9.70 | 10.25 |
| Electron | 116.03 | 119.10 | 15.32 | 15.60 | 116.03 | 119.10 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.18/1.97/1.88 | 2.94/2.54/2.37 | n/a/n/a/n/a | 0.75/0.69/0.66 | 1.22/1.00/0.94 | 1.11/0.99/0.96 | 1.68/1.36/1.24 |
| MoUI Skia GPU | 8.33/8.33/8.33 | 9.32/9.30/9.33 | n/a/n/a/n/a | 0.74/0.72/0.71 | 0.97/0.93/0.89 | 7.19/7.18/7.21 | 8.13/8.11/8.14 |
| MoUI WGPU | 8.33/8.33/8.33 | 9.58/9.54/9.55 | n/a/n/a/n/a | 0.79/0.85/0.80 | 1.06/1.22/1.02 | 7.11/7.05/7.10 | 8.50/8.48/8.51 |
| MoMark Skia Raster | 4.07/4.08/4.19 | 4.79/4.79/4.99 | n/a/n/a/n/a | 1.09/1.07/1.10 | 1.34/1.31/1.38 | 2.74/2.77/2.83 | 3.24/3.32/3.39 |
| MoMark Skia GPU | 8.38/8.49/8.38 | 9.40/9.70/9.41 | n/a/n/a/n/a | 1.19/1.21/1.17 | 1.58/1.58/1.52 | 6.87/6.95/6.87 | 7.87/8.21/7.97 |
| MoMark WGPU | 22.89/23.34/22.26 | 33.17/32.50/33.15 | n/a/n/a/n/a | 1.55/1.57/1.53 | 2.06/2.02/2.03 | 20.94/21.34/20.32 | 31.50/30.03/31.21 |
| GpMark.mbt (GPUI) | 10.42/10.33/10.40 | 14.65/12.64/14.58 | n/a/n/a/n/a | 6.93/6.93/7.00 | 8.47/8.36/8.61 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 10.03/10.06/10.00 | 10.00/10.00/10.00 | 2/3/2 | 1.69/2.15/2.18 | 2.04/2.92/3.00 | 0.57/0.51/0.51 | 0.81/0.72/0.75 |
| Flutter Impeller | 10.00/10.00/10.00 | 10.00/10.00/10.00 | 1/2/2 | 1.72/2.22/2.22 | 2.11/3.04/2.94 | 0.54/0.52/0.52 | 0.78/0.75/0.96 |
| Electron | 10.01/10.00/9.93 | 11.80/11.90/11.50 | 0/2/0 | 2.25/2.31/2.32 | 3.10/2.90/3.00 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.85 | 2.28 | n/a | 0.64 | 0.85 | 0.94 | 1.25 |
| MoUI Skia GPU | 8.34 | 9.31 | n/a | 0.72 | 0.94 | 7.21 | 8.12 |
| MoUI WGPU | 8.37 | 9.55 | n/a | 0.85 | 1.14 | 7.08 | 8.52 |
| MoMark Skia Raster | 4.40 | 5.21 | n/a | 1.14 | 1.45 | 2.94 | 3.55 |
| MoMark Skia GPU | 8.60 | 9.53 | n/a | 1.24 | 1.67 | 6.99 | 8.02 |
| MoMark WGPU | 22.97 | 31.82 | n/a | 1.53 | 2.01 | 21.00 | 29.31 |
| GpMark.mbt (GPUI) | 10.36 | 14.64 | n/a | 7.00 | 8.51 | n/a | n/a |
| Flutter Skia | 10.00 | 10.00 | 1 | 2.22 | 3.00 | 0.53 | 0.91 |
| Flutter Impeller | 10.00 | 10.00 | 1 | 2.29 | 3.08 | 0.51 | 0.77 |
| Electron | 9.99 | 11.60 | 0 | 2.34 | 3.00 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoUI Skia Raster CPU small 84.7 ms（max 105.3 ms）；MoUI Skia GPU medium 86.4 ms（max 118.3 ms）；MoUI WGPU stress 93.6 ms（max 108.8 ms）；MoMark Skia Raster stress 228.6 ms（max 232.4 ms）；MoMark Skia GPU small 106.2 ms（max 110.5 ms）；MoMark Skia GPU medium 114.0 ms（max 118.0 ms）；MoMark Skia GPU large 130.8 ms（max 140.3 ms）；MoMark Skia GPU stress 264.0 ms（max 272.6 ms）；MoMark WGPU large 103.3 ms（max 105.3 ms）；MoMark WGPU stress 227.5 ms（max 230.6 ms）；GpMark.mbt (GPUI) small 231.5 ms（max 288.0 ms）；GpMark.mbt (GPUI) medium 203.7 ms（max 226.8 ms）；GpMark.mbt (GPUI) large 212.4 ms（max 222.9 ms）；GpMark.mbt (GPUI) stress 187.4 ms（max 206.6 ms）；Flutter Impeller stress 89.7 ms（max 100.9 ms）；Electron small 115.4 ms（max 127.7 ms）；Electron medium 97.2 ms（max 107.1 ms）；Electron large 96.9 ms（max 102.9 ms）；Electron stress 116.0 ms（max 119.1 ms）。
- P1 输入尾延迟：MoUI Skia GPU stress P95 17.08 ms；MoMark Skia Raster stress P95 30.73 ms；MoMark Skia GPU stress P95 30.65 ms；MoMark WGPU small P95 49.98 ms；MoMark WGPU medium P95 56.32 ms；MoMark WGPU large P95 30.19 ms；MoMark WGPU stress P95 27.34 ms；GpMark.mbt (GPUI) small P95 30.39 ms；GpMark.mbt (GPUI) medium P95 41.77 ms；GpMark.mbt (GPUI) large P95 33.33 ms；GpMark.mbt (GPUI) stress P95 37.34 ms；Flutter Skia medium P95 17.30 ms；Flutter Skia stress P95 20.44 ms；Flutter Impeller small P95 17.30 ms；Flutter Impeller medium P95 20.48 ms。
- 长帧（超预算）：MoUI Skia GPU: stress/input 2 次，max 17.90 ms；MoUI WGPU: stress/scroll 1 次，max 17.63 ms；MoMark Skia Raster: large/input 1 次，max 24.34 ms, stress/input 30 次，max 31.77 ms, stress/scroll 1 次，max 21.95 ms；MoMark Skia GPU: medium/scroll 2 次，max 18.65 ms, stress/input 30 次，max 31.61 ms, stress/scroll 3 次，max 29.66 ms；MoMark WGPU: small/input 9 次，max 102.45 ms, small/scroll 303 次，max 84.89 ms, medium/input 17 次，max 60.15 ms, medium/scroll 306 次，max 135.78 ms, large/input 11 次，max 32.29 ms, large/scroll 293 次，max 82.23 ms, stress/input 30 次，max 29.72 ms, stress/scroll 303 次，max 99.99 ms；GpMark.mbt (GPUI): small/input 5 次，max 32.85 ms, small/scroll 9 次，max 45.67 ms, medium/input 4 次，max 42.92 ms, medium/scroll 8 次，max 36.05 ms, large/input 4 次，max 50.96 ms, large/scroll 10 次，max 52.73 ms, stress/input 8 次，max 39.80 ms, stress/scroll 9 次，max 44.87 ms；Flutter Skia: small/input 1 次，max 20.00 ms, small/scroll 2 次，max 20.00 ms, medium/scroll 3 次，max 20.00 ms, large/input 2 次，max 20.01 ms, large/scroll 2 次，max 20.00 ms, stress/input 2 次，max 30.00 ms, stress/scroll 1 次，max 20.00 ms；Flutter Impeller: small/input 1 次，max 20.00 ms, small/scroll 1 次，max 20.00 ms, medium/input 2 次，max 20.00 ms, medium/scroll 2 次，max 20.00 ms, large/input 1 次，max 30.00 ms, large/scroll 2 次，max 20.00 ms, stress/scroll 1 次，max 20.00 ms；Electron: medium/scroll 2 次，max 20.10 ms。
- 丢帧（优先处理）：Flutter Skia: small/input 1 帧, small/scroll 2 帧, medium/scroll 3 帧, large/input 2 帧, large/scroll 2 帧, stress/input 2 帧, stress/scroll 1 帧；Flutter Impeller: small/input 1 帧, small/scroll 1 帧, medium/input 2 帧, medium/scroll 2 帧, large/input 1 帧, large/scroll 2 帧, stress/scroll 1 帧；Electron: medium/scroll 2 帧, stress/input 1 帧。
- 解释：首帧异常优先检查窗口/渲染器初始化；输入尾延迟检查 action 到下一可见帧的调度与同步重建；长帧检查解析、布局、文本 shaping 和 GPU 提交；`n/a` 表示未埋点，不等于 0。
- 普通模式的长帧、帧间隔和输入延迟是各框架回调诊断，不能替代跨框架 compositor 排名；需要严格结论时运行 `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`。

## 采集口径

- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。
- `frame_work_ms` 统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏；对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `device_present_ms`：设备/上屏侧统一字段。MoUI raster 为 Skia CPU 光栅化+像素回读整体；MoUI GPU/wgpu 为提交后同步等待设备完成（headless host-surface 逐帧同步，真实应用的 vsync 流水线可重叠掉一部分，该值应视为上屏成本上界）；窗口模式（`window_mode=native-window`）下 MoUI 由真实 AppKit 窗口上屏，适配器侧不单独计时，显示 `n/a`；Flutter 为 `FrameTiming.rasterDuration`（光栅线程任务时间，含显示列表光栅化与 GPU 提交、不含设备完成等待）；GPUI 与 Electron 适配器侧无法观测，显示 `n/a`。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧；窗口模式（MoUI `native-window`）取帧时钟观察到的首个窗口帧完成，含 AppKit 窗口创建成本；严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代；打开场景没有前一帧，所以不计算 interval/drop。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。
