# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-13T14:46:18Z`
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
| moui-skia-raster | small | open | ui-frame | 56.021/67.878 | - | - | - | 5.06 ms | 0.00 ms | 5.06 ms | 62.65 ms | n/a | measured |
| moui-skia-raster | small | input | ui-frame | 0.529/0.623 | - | 1.450/1.801 | 1.450/1.801 | 0.77 ms | 0.00 ms | 0.77 ms | 56.06 ms | n/a | measured |
| moui-skia-raster | small | scroll | ui-frame | 0.593/0.749 | - | 1.409/1.854 | - | 0.61 ms | 0.00 ms | 0.61 ms | 58.86 ms | n/a | measured |
| moui-skia-raster | medium | open | ui-frame | 48.280/48.750 | - | - | - | 4.68 ms | 0.00 ms | 4.68 ms | 54.37 ms | n/a | measured |
| moui-skia-raster | medium | input | ui-frame | 0.521/0.569 | - | 1.405/1.639 | 1.405/1.639 | 0.73 ms | 0.00 ms | 0.73 ms | 53.55 ms | n/a | measured |
| moui-skia-raster | medium | scroll | ui-frame | 0.547/0.678 | - | 1.258/1.417 | - | 0.53 ms | 0.00 ms | 0.53 ms | 53.39 ms | n/a | measured |
| moui-skia-raster | large | open | ui-frame | 47.850/49.290 | - | - | - | 4.50 ms | 0.00 ms | 4.50 ms | 55.36 ms | n/a | measured |
| moui-skia-raster | large | input | ui-frame | 0.525/0.635 | - | 1.626/1.965 | 1.626/1.965 | 0.80 ms | 0.00 ms | 0.80 ms | 55.92 ms | n/a | measured |
| moui-skia-raster | large | scroll | ui-frame | 0.556/0.678 | - | 1.289/1.538 | - | 0.55 ms | 0.00 ms | 0.55 ms | 55.41 ms | n/a | measured |
| moui-skia-raster | stress | open | ui-frame | 49.805/54.287 | - | - | - | 4.36 ms | 0.00 ms | 4.36 ms | 81.03 ms | n/a | measured |
| moui-skia-raster | stress | input | ui-frame | 0.587/0.654 | - | 3.594/4.611 | 3.594/4.610 | 0.78 ms | 0.00 ms | 0.78 ms | 74.43 ms | n/a | measured |
| moui-skia-raster | stress | scroll | ui-frame | 0.544/0.671 | - | 1.239/1.379 | - | 0.52 ms | 0.00 ms | 0.52 ms | 70.59 ms | n/a | measured |
| moui-skia-gpu | small | open | ui-frame | 44.593/45.032 | - | - | - | 11.48 ms | n/a | 0.00 ms | 57.32 ms | n/a | measured |
| moui-skia-gpu | small | input | ui-frame | 0.595/0.709 | - | 8.267/9.488 | 8.265/9.487 | 7.45 ms | n/a | 0.00 ms | 58.51 ms | n/a | measured |
| moui-skia-gpu | small | scroll | ui-frame | 0.944/1.459 | - | 8.330/9.323 | - | 7.00 ms | n/a | 0.00 ms | 62.10 ms | n/a | measured |
| moui-skia-gpu | medium | open | ui-frame | 45.896/46.832 | - | - | - | 11.15 ms | n/a | 0.00 ms | 58.52 ms | n/a | measured |
| moui-skia-gpu | medium | input | ui-frame | 0.565/0.631 | - | 8.269/9.126 | 8.268/9.126 | 7.49 ms | n/a | 0.00 ms | 57.12 ms | n/a | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 0.948/1.430 | - | 8.336/9.391 | - | 7.00 ms | n/a | 0.00 ms | 163.85 ms | n/a | measured |
| moui-skia-gpu | large | open | ui-frame | 44.287/44.978 | - | - | - | 10.71 ms | n/a | 0.00 ms | 58.01 ms | n/a | measured |
| moui-skia-gpu | large | input | ui-frame | 0.669/0.987 | - | 8.368/9.309 | 8.367/9.308 | 7.21 ms | n/a | 0.00 ms | 59.56 ms | n/a | measured |
| moui-skia-gpu | large | scroll | ui-frame | 0.932/1.463 | - | 8.333/9.401 | - | 7.02 ms | n/a | 0.00 ms | 62.31 ms | n/a | measured |
| moui-skia-gpu | stress | open | ui-frame | 45.415/45.574 | - | - | - | 11.12 ms | n/a | 0.00 ms | 76.43 ms | n/a | measured |
| moui-skia-gpu | stress | input | ui-frame | 0.597/0.674 | - | 8.319/9.338 | 8.318/9.338 | 5.32 ms | n/a | 0.00 ms | 76.46 ms | n/a | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 0.942/1.464 | - | 8.331/9.348 | - | 7.00 ms | n/a | 0.00 ms | 77.33 ms | n/a | measured |
| moui-wgpu | small | open | ui-frame | 42.074/43.159 | - | - | - | 10.20 ms | n/a | 0.00 ms | 53.51 ms | n/a | measured |
| moui-wgpu | small | input | ui-frame | 0.568/0.696 | - | 8.252/9.281 | 8.251/9.281 | 7.48 ms | n/a | 0.00 ms | 53.31 ms | n/a | measured |
| moui-wgpu | small | scroll | ui-frame | 0.987/1.483 | - | 8.331/9.416 | - | 6.99 ms | n/a | 0.00 ms | 66.47 ms | n/a | measured |
| moui-wgpu | medium | open | ui-frame | 41.987/44.363 | - | - | - | 9.76 ms | n/a | 0.00 ms | 53.11 ms | n/a | measured |
| moui-wgpu | medium | input | ui-frame | 0.562/0.750 | - | 8.232/9.538 | 8.232/9.538 | 7.46 ms | n/a | 0.00 ms | 55.53 ms | n/a | measured |
| moui-wgpu | medium | scroll | ui-frame | 1.011/1.553 | - | 8.330/9.650 | - | 6.94 ms | n/a | 0.00 ms | 62.41 ms | n/a | measured |
| moui-wgpu | large | open | ui-frame | 43.437/44.354 | - | - | - | 10.15 ms | n/a | 0.00 ms | 56.76 ms | n/a | measured |
| moui-wgpu | large | input | ui-frame | 0.582/0.651 | - | 8.229/9.988 | 8.229/9.988 | 7.26 ms | n/a | 0.00 ms | 54.99 ms | n/a | measured |
| moui-wgpu | large | scroll | ui-frame | 0.968/1.492 | - | 8.330/9.423 | - | 7.01 ms | n/a | 0.00 ms | 68.27 ms | n/a | measured |
| moui-wgpu | stress | open | ui-frame | 40.793/41.268 | - | - | - | 9.83 ms | n/a | 0.00 ms | 70.16 ms | n/a | measured |
| moui-wgpu | stress | input | ui-frame | 0.586/0.707 | - | 8.291/9.093 | 8.291/9.093 | 5.07 ms | n/a | 0.00 ms | 70.26 ms | n/a | measured |
| moui-wgpu | stress | scroll | ui-frame | 1.018/1.529 | - | 8.334/9.480 | - | 6.93 ms | n/a | 0.00 ms | 80.29 ms | n/a | measured |
| moui-md-skia-raster | small | open | ui-frame | 58.769/59.784 | - | - | - | 14.79 ms | 0.00 ms | 14.79 ms | 78.79 ms | n/a | measured |
| moui-md-skia-raster | small | input | ui-frame | 3.229/3.641 | - | 5.857/6.423 | 5.830/6.180 | 2.36 ms | 0.00 ms | 2.36 ms | 78.72 ms | n/a | measured |
| moui-md-skia-raster | small | scroll | ui-frame | 1.557/1.903 | - | 4.054/4.574 | - | 2.37 ms | 0.00 ms | 2.37 ms | 78.73 ms | n/a | measured |
| moui-md-skia-raster | medium | open | ui-frame | 59.865/64.677 | - | - | - | 16.62 ms | 0.00 ms | 16.62 ms | 83.96 ms | n/a | measured |
| moui-md-skia-raster | medium | input | ui-frame | 3.796/6.292 | - | 7.057/11.648 | 7.027/11.646 | 2.77 ms | 0.00 ms | 2.77 ms | 80.14 ms | n/a | measured |
| moui-md-skia-raster | medium | scroll | ui-frame | 1.574/1.995 | - | 4.120/4.622 | - | 2.41 ms | 0.00 ms | 2.41 ms | 78.90 ms | n/a | measured |
| moui-md-skia-raster | large | open | ui-frame | 57.779/58.916 | - | - | - | 14.49 ms | 0.00 ms | 14.49 ms | 89.58 ms | n/a | measured |
| moui-md-skia-raster | large | input | ui-frame | 3.277/3.554 | - | 7.401/8.064 | 7.346/7.709 | 2.49 ms | 0.00 ms | 2.49 ms | 91.35 ms | n/a | measured |
| moui-md-skia-raster | large | scroll | ui-frame | 1.551/1.923 | - | 4.063/4.545 | - | 2.38 ms | 0.00 ms | 2.38 ms | 89.33 ms | n/a | measured |
| moui-md-skia-raster | stress | open | ui-frame | 56.384/56.910 | - | - | - | 14.72 ms | 0.00 ms | 14.72 ms | 202.36 ms | n/a | measured |
| moui-md-skia-raster | stress | input | ui-frame | 3.688/3.964 | - | 21.384/24.453 | 21.096/21.768 | 2.58 ms | 0.00 ms | 2.58 ms | 221.65 ms | n/a | measured |
| moui-md-skia-raster | stress | scroll | ui-frame | 1.575/1.919 | - | 4.067/4.521 | - | 2.35 ms | 0.00 ms | 2.35 ms | 205.90 ms | n/a | measured |
| moui-md-skia-gpu | small | open | ui-frame | 63.133/80.599 | - | - | - | 43.58 ms | n/a | 0.00 ms | 111.88 ms | n/a | measured |
| moui-md-skia-gpu | small | input | ui-frame | 3.456/4.088 | - | 9.001/10.217 | 8.974/10.216 | 5.23 ms | n/a | 0.00 ms | 105.77 ms | n/a | measured |
| moui-md-skia-gpu | small | scroll | ui-frame | 2.023/2.705 | - | 8.355/9.220 | - | 6.11 ms | n/a | 0.00 ms | 98.86 ms | n/a | measured |
| moui-md-skia-gpu | medium | open | ui-frame | 55.101/56.321 | - | - | - | 40.55 ms | n/a | 0.00 ms | 101.90 ms | n/a | measured |
| moui-md-skia-gpu | medium | input | ui-frame | 3.362/3.764 | - | 9.544/10.718 | 9.516/10.718 | 5.75 ms | n/a | 0.00 ms | 106.68 ms | n/a | measured |
| moui-md-skia-gpu | medium | scroll | ui-frame | 2.041/2.690 | - | 8.356/9.452 | - | 6.08 ms | n/a | 0.00 ms | 100.52 ms | n/a | measured |
| moui-md-skia-gpu | large | open | ui-frame | 56.410/58.644 | - | - | - | 42.30 ms | n/a | 0.00 ms | 115.62 ms | n/a | measured |
| moui-md-skia-gpu | large | input | ui-frame | 3.675/7.372 | - | 10.165/14.240 | 10.109/14.239 | 4.72 ms | n/a | 0.00 ms | 115.20 ms | n/a | measured |
| moui-md-skia-gpu | large | scroll | ui-frame | 2.052/2.741 | - | 8.343/9.316 | - | 6.06 ms | n/a | 0.00 ms | 113.72 ms | n/a | measured |
| moui-md-skia-gpu | stress | open | ui-frame | 55.159/55.350 | - | - | - | 43.24 ms | n/a | 0.00 ms | 227.00 ms | n/a | measured |
| moui-md-skia-gpu | stress | input | ui-frame | 3.668/4.102 | - | 21.450/25.785 | 21.156/25.203 | 2.56 ms | n/a | 0.00 ms | 237.60 ms | n/a | measured |
| moui-md-skia-gpu | stress | scroll | ui-frame | 1.990/2.599 | - | 8.416/9.560 | - | 6.18 ms | n/a | 0.00 ms | 233.52 ms | n/a | measured |
| moui-md-wgpu | small | open | ui-frame | 42.505/42.921 | - | - | - | 17.30 ms | n/a | 0.00 ms | 65.05 ms | n/a | measured |
| moui-md-wgpu | small | input | ui-frame | 1.798/1.929 | - | 8.116/9.194 | 8.081/9.194 | 5.94 ms | n/a | 0.00 ms | 67.02 ms | n/a | measured |
| moui-md-wgpu | small | scroll | ui-frame | 2.133/2.677 | - | 8.341/10.857 | - | 5.95 ms | n/a | 0.00 ms | 65.00 ms | n/a | measured |
| moui-md-wgpu | medium | open | ui-frame | 42.753/43.718 | - | - | - | 16.70 ms | n/a | 0.00 ms | 65.69 ms | n/a | measured |
| moui-md-wgpu | medium | input | ui-frame | 1.880/2.200 | - | 8.128/9.537 | 8.093/9.536 | 5.74 ms | n/a | 0.00 ms | 68.42 ms | n/a | measured |
| moui-md-wgpu | medium | scroll | ui-frame | 2.143/2.642 | - | 8.327/10.865 | - | 5.93 ms | n/a | 0.00 ms | 66.62 ms | n/a | measured |
| moui-md-wgpu | large | open | ui-frame | 42.525/42.826 | - | - | - | 17.47 ms | n/a | 0.00 ms | 77.20 ms | n/a | measured |
| moui-md-wgpu | large | input | ui-frame | 1.823/2.009 | - | 8.306/9.693 | 8.244/9.692 | 4.58 ms | n/a | 0.00 ms | 80.03 ms | n/a | measured |
| moui-md-wgpu | large | scroll | ui-frame | 2.314/3.103 | - | 8.531/11.122 | - | 5.93 ms | n/a | 0.00 ms | 77.45 ms | n/a | measured |
| moui-md-wgpu | stress | open | ui-frame | 43.197/43.449 | - | - | - | 17.48 ms | n/a | 0.00 ms | 191.68 ms | n/a | measured |
| moui-md-wgpu | stress | input | ui-frame | 1.621/1.705 | - | 20.190/22.984 | 19.870/20.876 | 3.12 ms | n/a | 0.00 ms | 201.65 ms | n/a | measured |
| moui-md-wgpu | stress | scroll | ui-frame | 2.219/2.741 | - | 8.469/11.017 | - | 5.96 ms | n/a | 0.00 ms | 191.60 ms | n/a | measured |
| gpmark | small | open | ui-frame | 5.297/5.508 | - | - | - | n/a | n/a | n/a | 110.67 ms | n/a | measured |
| gpmark | small | input | ui-frame | 5.199/5.433 | 0.291/0.318 | 9.383/10.094 | 9.380/10.091 | n/a | n/a | n/a | 106.32 ms | n/a | measured |
| gpmark | small | scroll | ui-frame | 5.647/7.095 | 0.001/0.003 | 9.982/10.702 | - | n/a | n/a | n/a | 124.55 ms | n/a | measured |
| gpmark | medium | open | ui-frame | 5.374/5.519 | - | - | - | n/a | n/a | n/a | 107.63 ms | n/a | measured |
| gpmark | medium | input | ui-frame | 5.138/5.344 | 0.316/0.359 | 9.771/11.492 | 9.768/11.490 | n/a | n/a | n/a | 106.85 ms | n/a | measured |
| gpmark | medium | scroll | ui-frame | 5.679/7.269 | 0.001/0.003 | 9.988/10.567 | - | n/a | n/a | n/a | 111.08 ms | n/a | measured |
| gpmark | large | open | ui-frame | 5.331/5.395 | - | - | - | n/a | n/a | n/a | 111.85 ms | n/a | measured |
| gpmark | large | input | ui-frame | 5.188/5.534 | 0.687/0.880 | 9.869/11.477 | 9.866/11.475 | n/a | n/a | n/a | 114.40 ms | n/a | measured |
| gpmark | large | scroll | ui-frame | 5.655/7.140 | 0.001/0.003 | 9.983/11.046 | - | n/a | n/a | n/a | 115.62 ms | n/a | measured |
| gpmark | stress | open | ui-frame | 5.239/5.313 | - | - | - | n/a | n/a | n/a | 129.93 ms | n/a | measured |
| gpmark | stress | input | ui-frame | 5.165/5.522 | 4.331/5.173 | 10.509/12.308 | 10.507/12.304 | n/a | n/a | n/a | 132.95 ms | n/a | measured |
| gpmark | stress | scroll | ui-frame | 5.646/7.167 | 0.001/0.003 | 9.990/11.225 | - | n/a | n/a | n/a | 129.66 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 0.291/0.309 | - | - | - | 8.54 ms | n/a | n/a | 58.52 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 0.431/0.590 | - | 10.000/10.003 | 10.027/10.367 | 0.48 ms | n/a | n/a | 57.23 ms | 0 | measured |
| flutter-skia | small | scroll | ui-frame | 1.873/3.696 | - | 10.028/10.004 | - | 0.38 ms | n/a | n/a | 58.60 ms | 1 | measured |
| flutter-skia | medium | open | ui-frame | 0.279/0.293 | - | - | - | 8.27 ms | n/a | n/a | 55.44 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 0.459/0.639 | - | 10.000/10.001 | 10.027/10.450 | 0.47 ms | n/a | n/a | 56.49 ms | 0 | measured |
| flutter-skia | medium | scroll | ui-frame | 2.091/3.720 | - | 10.000/10.001 | - | 0.40 ms | n/a | n/a | 57.02 ms | 1 | measured |
| flutter-skia | large | open | ui-frame | 0.270/0.290 | - | - | - | 8.01 ms | n/a | n/a | 57.48 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 0.439/0.565 | - | 10.000/10.001 | 10.022/10.455 | 0.49 ms | n/a | n/a | 57.08 ms | 0 | measured |
| flutter-skia | large | scroll | ui-frame | 2.026/3.614 | - | 9.972/10.001 | - | 0.39 ms | n/a | n/a | 58.90 ms | 0 | measured |
| flutter-skia | stress | open | ui-frame | 0.291/0.364 | - | - | - | 8.15 ms | n/a | n/a | 86.24 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 0.380/0.530 | - | 10.000/10.002 | 10.209/10.591 | 0.42 ms | n/a | n/a | 86.05 ms | 0 | measured |
| flutter-skia | stress | scroll | ui-frame | 1.997/3.530 | - | 10.000/10.001 | - | 0.39 ms | n/a | n/a | 86.17 ms | 0 | measured |
| flutter-impeller | small | open | ui-frame | 0.312/0.321 | - | - | - | 6.91 ms | n/a | n/a | 57.75 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 0.421/0.583 | - | 10.000/10.002 | 10.159/11.190 | 0.46 ms | n/a | n/a | 56.23 ms | 0 | measured |
| flutter-impeller | small | scroll | ui-frame | 1.857/3.644 | - | 10.000/10.004 | - | 0.42 ms | n/a | n/a | 60.87 ms | 0 | measured |
| flutter-impeller | medium | open | ui-frame | 0.272/0.279 | - | - | - | 6.45 ms | n/a | n/a | 56.42 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 0.433/0.609 | - | 10.000/10.001 | 10.080/10.550 | 0.46 ms | n/a | n/a | 58.41 ms | 0 | measured |
| flutter-impeller | medium | scroll | ui-frame | 2.049/3.739 | - | 10.000/10.001 | - | 0.40 ms | n/a | n/a | 58.23 ms | 0 | measured |
| flutter-impeller | large | open | ui-frame | 0.292/0.319 | - | - | - | 6.68 ms | n/a | n/a | 57.37 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 0.448/0.623 | - | 10.000/10.002 | 10.025/10.402 | 0.50 ms | n/a | n/a | 60.19 ms | 0 | measured |
| flutter-impeller | large | scroll | ui-frame | 2.066/3.664 | - | 10.000/10.001 | - | 0.40 ms | n/a | n/a | 59.44 ms | 0 | measured |
| flutter-impeller | stress | open | ui-frame | 0.250/0.264 | - | - | - | 6.47 ms | n/a | n/a | 89.06 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 0.462/0.691 | - | 10.000/10.001 | 10.024/10.433 | 0.56 ms | n/a | n/a | 89.28 ms | 0 | measured |
| flutter-impeller | stress | scroll | ui-frame | 2.039/3.621 | - | 9.972/10.001 | - | 0.42 ms | n/a | n/a | 86.68 ms | 0 | measured |
| electron | small | open | ui-frame | 84.367/86.000 | - | - | - | n/a | n/a | n/a | 84.37 ms | 0 | measured |
| electron | small | input | ui-frame | 1.630/2.700 | - | 9.284/11.500 | 8.760/11.500 | n/a | n/a | n/a | 79.13 ms | 0 | measured |
| electron | small | scroll | ui-frame | 1.720/2.300 | - | 9.981/11.500 | - | n/a | n/a | n/a | 80.43 ms | 0 | measured |
| electron | medium | open | ui-frame | 80.067/80.600 | - | - | - | n/a | n/a | n/a | 80.07 ms | 0 | measured |
| electron | medium | input | ui-frame | 1.540/2.700 | - | 9.310/11.900 | 8.553/11.800 | n/a | n/a | n/a | 80.33 ms | 0 | measured |
| electron | medium | scroll | ui-frame | 1.771/2.300 | - | 9.932/11.700 | - | n/a | n/a | n/a | 81.03 ms | 0 | measured |
| electron | large | open | ui-frame | 80.333/81.300 | - | - | - | n/a | n/a | n/a | 80.33 ms | 0 | measured |
| electron | large | input | ui-frame | 1.583/2.500 | - | 9.624/10.700 | 8.623/10.100 | n/a | n/a | n/a | 80.93 ms | 0 | measured |
| electron | large | scroll | ui-frame | 1.769/2.300 | - | 9.963/11.600 | - | n/a | n/a | n/a | 80.60 ms | 0 | measured |
| electron | stress | open | ui-frame | 87.833/88.600 | - | - | - | n/a | n/a | n/a | 87.83 ms | 0 | measured |
| electron | stress | input | ui-frame | 1.543/2.000 | - | 9.445/11.700 | 8.617/11.500 | n/a | n/a | n/a | 90.17 ms | 0 | measured |
| electron | stress | scroll | ui-frame | 1.817/2.400 | - | 9.948/11.300 | - | n/a | n/a | n/a | 89.33 ms | 0 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.41/1.26/1.29 | 1.85/1.42/1.54 | n/a/n/a/n/a | 0.59/0.55/0.56 | 0.75/0.68/0.68 | 0.61/0.53/0.55 | 0.88/0.66/0.69 |
| MoUI Skia GPU | 8.33/8.34/8.33 | 9.32/9.39/9.40 | n/a/n/a/n/a | 0.94/0.95/0.93 | 1.46/1.43/1.46 | 7.00/7.00/7.02 | 8.00/7.97/7.98 |
| MoUI WGPU | 8.33/8.33/8.33 | 9.42/9.65/9.42 | n/a/n/a/n/a | 0.99/1.01/0.97 | 1.48/1.55/1.49 | 6.99/6.94/7.01 | 8.28/8.40/8.27 |
| MoMark Skia Raster | 4.05/4.12/4.06 | 4.57/4.62/4.54 | n/a/n/a/n/a | 1.56/1.57/1.55 | 1.90/2.00/1.92 | 2.37/2.41/2.38 | 2.58/2.64/2.56 |
| MoMark Skia GPU | 8.36/8.36/8.34 | 9.22/9.45/9.32 | n/a/n/a/n/a | 2.02/2.04/2.05 | 2.70/2.69/2.74 | 6.11/6.08/6.06 | 7.13/7.15/7.14 |
| MoMark WGPU | 8.34/8.33/8.53 | 10.86/10.87/11.12 | n/a/n/a/n/a | 2.13/2.14/2.31 | 2.68/2.64/3.10 | 5.95/5.93/5.93 | 8.02/7.99/8.26 |
| GpMark.mbt (GPUI) | 9.98/9.99/9.98 | 10.70/10.57/11.05 | n/a/n/a/n/a | 5.65/5.68/5.65 | 7.09/7.27/7.14 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 10.03/10.00/9.97 | 10.00/10.00/10.00 | 1/1/0 | 1.87/2.09/2.03 | 3.70/3.72/3.61 | 0.38/0.40/0.39 | 0.70/0.70/0.67 |
| Flutter Impeller | 10.00/10.00/10.00 | 10.00/10.00/10.00 | 0/0/0 | 1.86/2.05/2.07 | 3.64/3.74/3.66 | 0.42/0.40/0.40 | 0.73/0.62/0.67 |
| Electron | 9.98/9.93/9.96 | 11.50/11.70/11.60 | 0/0/0 | 1.72/1.77/1.77 | 2.30/2.30/2.30 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.24 | 1.38 | n/a | 0.54 | 0.67 | 0.52 | 0.62 |
| MoUI Skia GPU | 8.33 | 9.35 | n/a | 0.94 | 1.46 | 7.00 | 8.01 |
| MoUI WGPU | 8.33 | 9.48 | n/a | 1.02 | 1.53 | 6.93 | 8.29 |
| MoMark Skia Raster | 4.07 | 4.52 | n/a | 1.58 | 1.92 | 2.35 | 2.55 |
| MoMark Skia GPU | 8.42 | 9.56 | n/a | 1.99 | 2.60 | 6.18 | 7.30 |
| MoMark WGPU | 8.47 | 11.02 | n/a | 2.22 | 2.74 | 5.96 | 8.15 |
| GpMark.mbt (GPUI) | 9.99 | 11.22 | n/a | 5.65 | 7.17 | n/a | n/a |
| Flutter Skia | 10.00 | 10.00 | 0 | 2.00 | 3.53 | 0.39 | 0.74 |
| Flutter Impeller | 9.97 | 10.00 | 0 | 2.04 | 3.62 | 0.42 | 0.69 |
| Electron | 9.95 | 11.30 | 0 | 1.82 | 2.40 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.45/1.40/1.63 | 1.80/1.64/1.97 | 0.53/0.52/0.52 | 0.62/0.57/0.64 | 0.77/0.73/0.80 | 1.04/0.90/1.13 |
| MoUI Skia GPU | 8.27/8.27/8.37 | 9.49/9.13/9.31 | 0.59/0.56/0.67 | 0.71/0.63/0.99 | 7.45/7.49/7.21 | 8.71/8.35/8.26 |
| MoUI WGPU | 8.25/8.23/8.23 | 9.28/9.54/9.99 | 0.57/0.56/0.58 | 0.70/0.75/0.65 | 7.48/7.46/7.26 | 8.45/8.85/9.09 |
| MoMark Skia Raster | 5.83/7.03/7.35 | 6.18/11.65/7.71 | 3.23/3.80/3.28 | 3.64/6.29/3.55 | 2.36/2.77/2.49 | 2.58/4.71/2.77 |
| MoMark Skia GPU | 8.97/9.52/10.11 | 10.22/10.72/14.24 | 3.46/3.36/3.68 | 4.09/3.76/7.37 | 5.23/5.75/4.72 | 6.33/6.87/6.59 |
| MoMark WGPU | 8.08/8.09/8.24 | 9.19/9.54/9.69 | 1.80/1.88/1.82 | 1.93/2.20/2.01 | 5.94/5.74/4.58 | 7.23/7.08/6.20 |
| GpMark.mbt (GPUI) | 9.38/9.77/9.87 | 10.09/11.49/11.48 | 5.20/5.14/5.19 | 5.43/5.34/5.53 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 10.03/10.03/10.02 | 10.37/10.45/10.46 | 0.43/0.46/0.44 | 0.59/0.64/0.56 | 0.48/0.47/0.49 | 1.05/0.96/0.94 |
| Flutter Impeller | 10.16/10.08/10.03 | 11.19/10.55/10.40 | 0.42/0.43/0.45 | 0.58/0.61/0.62 | 0.46/0.46/0.50 | 1.08/0.97/1.07 |
| Electron | 8.76/8.55/8.62 | 11.50/11.80/10.10 | 1.63/1.54/1.58 | 2.70/2.70/2.50 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 3.59 | 4.61 | 0.59 | 0.65 | 0.78 | 0.91 |
| MoUI Skia GPU | 8.32 | 9.34 | 0.60 | 0.67 | 5.32 | 6.37 |
| MoUI WGPU | 8.29 | 9.09 | 0.59 | 0.71 | 5.07 | 5.96 |
| MoMark Skia Raster | 21.10 | 21.77 | 3.69 | 3.96 | 2.58 | 3.00 |
| MoMark Skia GPU | 21.16 | 25.20 | 3.67 | 4.10 | 2.56 | 6.27 |
| MoMark WGPU | 19.87 | 20.88 | 1.62 | 1.71 | 3.12 | 3.75 |
| GpMark.mbt (GPUI) | 10.51 | 12.30 | 5.17 | 5.52 | n/a | n/a |
| Flutter Skia | 10.21 | 10.59 | 0.38 | 0.53 | 0.42 | 1.01 |
| Flutter Impeller | 10.02 | 10.43 | 0.46 | 0.69 | 0.56 | 1.21 |
| Electron | 8.62 | 11.50 | 1.54 | 2.00 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 62.65/54.37/55.36 | 75.05/55.04/56.71 | 0.06/0.31/2.13 | 0.06/0.31/2.47 | 56.02/48.28/47.85 | 67.88/48.75/49.29 | 5.06/4.68/4.50 | 5.10/4.86/4.70 |
| MoUI Skia GPU | 57.32/58.52/58.01 | 57.74/59.15/58.71 | 0.06/0.27/2.45 | 0.06/0.30/2.49 | 44.59/45.90/44.29 | 45.03/46.83/44.98 | 11.48/11.15/10.71 | 12.36/11.63/10.75 |
| MoUI WGPU | 53.51/53.11/56.76 | 55.04/55.72/58.03 | 0.07/0.25/2.53 | 0.08/0.28/2.72 | 42.07/41.99/43.44 | 43.16/44.36/44.35 | 10.20/9.76/10.15 | 10.62/9.96/10.48 |
| MoMark Skia Raster | 78.79/83.96/89.58 | 79.81/91.04/90.80 | 0.06/0.33/2.16 | 0.07/0.46/2.50 | 58.77/59.87/57.78 | 59.78/64.68/58.92 | 14.79/16.62/14.49 | 15.08/19.75/14.56 |
| MoMark Skia GPU | 111.88/101.90/115.62 | 134.14/102.51/123.43 | 0.06/0.27/1.75 | 0.06/0.28/2.37 | 63.13/55.10/56.41 | 80.60/56.32/58.64 | 43.58/40.55/42.30 | 48.34/42.03/48.14 |
| MoMark WGPU | 65.05/65.69/77.20 | 65.57/67.26/77.72 | 0.11/0.24/2.10 | 0.15/0.27/2.61 | 42.51/42.75/42.52 | 42.92/43.72/42.83 | 17.30/16.70/17.47 | 17.48/17.09/17.74 |
| GpMark.mbt (GPUI) | 110.67/107.63/111.85 | 115.98/109.57/119.46 | 0.00/0.33/2.33 | 0.00/1.00/3.00 | 5.30/5.37/5.33 | 5.51/5.52/5.39 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 58.52/55.44/57.48 | 60.45/56.41/61.12 | 0.11/0.11/0.40 | 0.16/0.12/0.43 | 0.29/0.28/0.27 | 0.31/0.29/0.29 | 8.54/8.27/8.01 | 8.73/8.34/8.17 |
| Flutter Impeller | 57.75/56.42/57.37 | 61.79/58.54/57.98 | 0.12/0.13/0.40 | 0.15/0.17/0.44 | 0.31/0.27/0.29 | 0.32/0.28/0.32 | 6.91/6.45/6.68 | 7.10/6.55/7.05 |
| Electron | 84.37/80.07/80.33 | 86.00/80.60/81.30 | 3.87/2.90/3.18 | 6.00/3.69/4.19 | 84.37/80.07/80.33 | 86.00/80.60/81.30 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 81.03 | 100.39 | 25.44 | 27.54 | 49.81 | 54.29 | 4.36 | 4.55 |
| MoUI Skia GPU | 76.43 | 77.28 | 21.16 | 23.45 | 45.41 | 45.57 | 11.12 | 11.62 |
| MoUI WGPU | 70.16 | 71.10 | 21.04 | 21.55 | 40.79 | 41.27 | 9.83 | 10.19 |
| MoMark Skia Raster | 202.36 | 203.82 | 21.86 | 23.54 | 56.38 | 56.91 | 14.72 | 15.11 |
| MoMark Skia GPU | 227.00 | 229.46 | 19.49 | 21.77 | 55.16 | 55.35 | 43.24 | 49.05 |
| MoMark WGPU | 191.68 | 194.53 | 23.28 | 26.15 | 43.20 | 43.45 | 17.48 | 17.56 |
| GpMark.mbt (GPUI) | 129.93 | 138.62 | 19.67 | 25.00 | 5.24 | 5.31 | n/a | n/a |
| Flutter Skia | 86.24 | 87.42 | 3.02 | 3.25 | 0.29 | 0.36 | 8.15 | 8.22 |
| Flutter Impeller | 89.06 | 92.79 | 2.95 | 3.10 | 0.25 | 0.26 | 6.47 | 6.62 |
| Electron | 87.83 | 88.60 | 5.37 | 6.00 | 87.83 | 88.60 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.41/1.26/1.29 | 1.85/1.42/1.54 | n/a/n/a/n/a | 0.59/0.55/0.56 | 0.75/0.68/0.68 | 0.61/0.53/0.55 | 0.88/0.66/0.69 |
| MoUI Skia GPU | 8.33/8.34/8.33 | 9.32/9.39/9.40 | n/a/n/a/n/a | 0.94/0.95/0.93 | 1.46/1.43/1.46 | 7.00/7.00/7.02 | 8.00/7.97/7.98 |
| MoUI WGPU | 8.33/8.33/8.33 | 9.42/9.65/9.42 | n/a/n/a/n/a | 0.99/1.01/0.97 | 1.48/1.55/1.49 | 6.99/6.94/7.01 | 8.28/8.40/8.27 |
| MoMark Skia Raster | 4.05/4.12/4.06 | 4.57/4.62/4.54 | n/a/n/a/n/a | 1.56/1.57/1.55 | 1.90/2.00/1.92 | 2.37/2.41/2.38 | 2.58/2.64/2.56 |
| MoMark Skia GPU | 8.36/8.36/8.34 | 9.22/9.45/9.32 | n/a/n/a/n/a | 2.02/2.04/2.05 | 2.70/2.69/2.74 | 6.11/6.08/6.06 | 7.13/7.15/7.14 |
| MoMark WGPU | 8.34/8.33/8.53 | 10.86/10.87/11.12 | n/a/n/a/n/a | 2.13/2.14/2.31 | 2.68/2.64/3.10 | 5.95/5.93/5.93 | 8.02/7.99/8.26 |
| GpMark.mbt (GPUI) | 9.98/9.99/9.98 | 10.70/10.57/11.05 | n/a/n/a/n/a | 5.65/5.68/5.65 | 7.09/7.27/7.14 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 10.03/10.00/9.97 | 10.00/10.00/10.00 | 1/1/0 | 1.87/2.09/2.03 | 3.70/3.72/3.61 | 0.38/0.40/0.39 | 0.70/0.70/0.67 |
| Flutter Impeller | 10.00/10.00/10.00 | 10.00/10.00/10.00 | 0/0/0 | 1.86/2.05/2.07 | 3.64/3.74/3.66 | 0.42/0.40/0.40 | 0.73/0.62/0.67 |
| Electron | 9.98/9.93/9.96 | 11.50/11.70/11.60 | 0/0/0 | 1.72/1.77/1.77 | 2.30/2.30/2.30 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.24 | 1.38 | n/a | 0.54 | 0.67 | 0.52 | 0.62 |
| MoUI Skia GPU | 8.33 | 9.35 | n/a | 0.94 | 1.46 | 7.00 | 8.01 |
| MoUI WGPU | 8.33 | 9.48 | n/a | 1.02 | 1.53 | 6.93 | 8.29 |
| MoMark Skia Raster | 4.07 | 4.52 | n/a | 1.58 | 1.92 | 2.35 | 2.55 |
| MoMark Skia GPU | 8.42 | 9.56 | n/a | 1.99 | 2.60 | 6.18 | 7.30 |
| MoMark WGPU | 8.47 | 11.02 | n/a | 2.22 | 2.74 | 5.96 | 8.15 |
| GpMark.mbt (GPUI) | 9.99 | 11.22 | n/a | 5.65 | 7.17 | n/a | n/a |
| Flutter Skia | 10.00 | 10.00 | 0 | 2.00 | 3.53 | 0.39 | 0.74 |
| Flutter Impeller | 9.97 | 10.00 | 0 | 2.04 | 3.62 | 0.42 | 0.69 |
| Electron | 9.95 | 11.30 | 0 | 1.82 | 2.40 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoUI Skia Raster CPU stress 81.0 ms（max 100.4 ms）；MoMark Skia Raster stress 202.4 ms（max 203.8 ms）；MoMark Skia GPU small 111.9 ms（max 134.1 ms）；MoMark Skia GPU medium 101.9 ms（max 102.5 ms）；MoMark Skia GPU large 115.6 ms（max 123.4 ms）；MoMark Skia GPU stress 227.0 ms（max 229.5 ms）；MoMark WGPU stress 191.7 ms（max 194.5 ms）；GpMark.mbt (GPUI) small 110.7 ms（max 116.0 ms）；GpMark.mbt (GPUI) medium 107.6 ms（max 109.6 ms）；GpMark.mbt (GPUI) large 111.9 ms（max 119.5 ms）；GpMark.mbt (GPUI) stress 129.9 ms（max 138.6 ms）。
- P1 输入尾延迟：MoMark Skia Raster stress P95 21.77 ms；MoMark Skia GPU stress P95 25.20 ms；MoMark WGPU stress P95 20.88 ms。
- 长帧（超预算）：MoMark Skia Raster: stress/input 30 次，max 24.65 ms；MoMark Skia GPU: large/input 1 次，max 16.80 ms, stress/input 30 次，max 28.10 ms, stress/scroll 1 次，max 17.03 ms；MoMark WGPU: large/scroll 2 次，max 25.88 ms, stress/input 30 次，max 23.13 ms, stress/scroll 1 次，max 17.27 ms；Flutter Skia: small/scroll 1 次，max 20.00 ms, medium/scroll 1 次，max 20.00 ms。
- 丢帧（优先处理）：Flutter Skia: small/scroll 1 帧, medium/scroll 1 帧。
- 解释：首帧异常优先检查窗口/渲染器初始化；输入尾延迟检查 action 到下一可见帧的调度与同步重建；长帧检查解析、布局、文本 shaping 和 GPU 提交；`n/a` 表示未埋点，不等于 0。
- 普通模式的长帧、帧间隔和输入延迟是各框架回调诊断，不能替代跨框架 compositor 排名；需要严格结论时运行 `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`。

## 采集口径

- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。
- `frame_work_ms` 统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏；对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `device_present_ms`：设备/上屏侧统一字段。MoUI raster 为 Skia CPU 光栅化+像素回读整体；MoUI GPU/wgpu 为提交后同步等待设备完成（headless host-surface 逐帧同步，真实应用的 vsync 流水线可重叠掉一部分，该值应视为上屏成本上界）；窗口模式（`window_mode=native-window`）下 MoUI 由真实 AppKit 窗口上屏，适配器侧不单独计时，显示 `n/a`；Flutter 为 `FrameTiming.rasterDuration`（光栅线程任务时间，含显示列表光栅化与 GPU 提交、不含设备完成等待）；GPUI 与 Electron 适配器侧无法观测，显示 `n/a`。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧；窗口模式（MoUI `native-window`）取帧时钟观察到的首个窗口帧完成，含 AppKit 窗口创建成本；严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代；打开场景没有前一帧，所以不计算 interval/drop。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。
