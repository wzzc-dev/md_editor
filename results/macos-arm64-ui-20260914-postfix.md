# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-14T16:04:59Z`
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
| moui-skia-raster | small | open | ui-frame | 0.018/0.031 | - | - | - | n/a | n/a | n/a | 287.25 ms | 0 | measured |
| moui-skia-raster | small | input | ui-frame | 0.766/0.923 | - | 28.506/38.970 | 28.442/38.959 | n/a | n/a | n/a | 259.76 ms | 32 | measured |
| moui-skia-raster | small | scroll | ui-frame | 0.547/0.662 | - | 26.017/28.707 | - | n/a | n/a | n/a | 209.69 ms | 362 | measured |
| moui-skia-raster | medium | open | ui-frame | 0.013/0.018 | - | - | - | n/a | n/a | n/a | 255.62 ms | 0 | measured |
| moui-skia-raster | medium | input | ui-frame | 0.764/0.890 | - | 27.767/30.008 | 27.706/29.956 | n/a | n/a | n/a | 261.15 ms | 31 | measured |
| moui-skia-raster | medium | scroll | ui-frame | 0.546/0.670 | - | 26.060/28.590 | - | n/a | n/a | n/a | 284.68 ms | 362 | measured |
| moui-skia-raster | large | open | ui-frame | 0.013/0.017 | - | - | - | n/a | n/a | n/a | 259.56 ms | 0 | measured |
| moui-skia-raster | large | input | ui-frame | 0.778/0.876 | - | 29.083/39.412 | 29.023/39.406 | n/a | n/a | n/a | 262.87 ms | 33 | measured |
| moui-skia-raster | large | scroll | ui-frame | 0.556/0.665 | - | 26.325/28.308 | - | n/a | n/a | n/a | 232.87 ms | 363 | measured |
| moui-skia-raster | stress | open | ui-frame | 0.013/0.015 | - | - | - | n/a | n/a | n/a | 325.29 ms | 0 | measured |
| moui-skia-raster | stress | input | ui-frame | 0.812/1.021 | - | 28.457/37.266 | 28.396/37.165 | n/a | n/a | n/a | 324.26 ms | 33 | measured |
| moui-skia-raster | stress | scroll | ui-frame | 0.562/0.668 | - | 26.573/29.486 | - | n/a | n/a | n/a | 339.74 ms | 362 | measured |
| moui-skia-gpu | small | open | ui-frame | 0.018/0.019 | - | - | - | n/a | n/a | n/a | 283.64 ms | 0 | measured |
| moui-skia-gpu | small | input | ui-frame | 0.786/0.947 | - | 14.581/19.272 | 14.520/19.266 | n/a | n/a | n/a | 303.31 ms | 5 | measured |
| moui-skia-gpu | small | scroll | ui-frame | 0.632/1.224 | - | 13.234/14.728 | - | n/a | n/a | n/a | 293.03 ms | 11 | measured |
| moui-skia-gpu | medium | open | ui-frame | 0.012/0.013 | - | - | - | n/a | n/a | n/a | 294.42 ms | 0 | measured |
| moui-skia-gpu | medium | input | ui-frame | 0.750/0.878 | - | 14.272/20.372 | 14.207/20.366 | n/a | n/a | n/a | 290.63 ms | 5 | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 0.605/0.994 | - | 13.177/14.732 | - | n/a | n/a | n/a | 322.50 ms | 12 | measured |
| moui-skia-gpu | large | open | ui-frame | 0.028/0.039 | - | - | - | n/a | n/a | n/a | 293.41 ms | 0 | measured |
| moui-skia-gpu | large | input | ui-frame | 0.761/0.924 | - | 14.174/19.365 | 14.114/19.357 | n/a | n/a | n/a | 308.02 ms | 3 | measured |
| moui-skia-gpu | large | scroll | ui-frame | 0.589/1.020 | - | 13.196/14.802 | - | n/a | n/a | n/a | 283.21 ms | 10 | measured |
| moui-skia-gpu | stress | open | ui-frame | 0.012/0.013 | - | - | - | n/a | n/a | n/a | 330.37 ms | 0 | measured |
| moui-skia-gpu | stress | input | ui-frame | 0.790/0.994 | - | 16.301/18.879 | 16.170/18.761 | n/a | n/a | n/a | 321.25 ms | 7 | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 0.614/1.153 | - | 13.126/14.852 | - | n/a | n/a | n/a | 337.68 ms | 7 | measured |
| moui-wgpu | small | open | ui-frame | 0.016/0.026 | - | - | - | n/a | n/a | n/a | 314.00 ms | 0 | measured |
| moui-wgpu | small | input | ui-frame | 0.772/1.067 | - | 13.845/20.024 | 13.769/20.019 | n/a | n/a | n/a | 304.34 ms | 4 | measured |
| moui-wgpu | small | scroll | ui-frame | 0.625/0.854 | - | 13.162/14.937 | - | n/a | n/a | n/a | 298.01 ms | 8 | measured |
| moui-wgpu | medium | open | ui-frame | 0.011/0.012 | - | - | - | n/a | n/a | n/a | 301.76 ms | 0 | measured |
| moui-wgpu | medium | input | ui-frame | 0.754/0.912 | - | 14.236/19.965 | 14.161/19.871 | n/a | n/a | n/a | 290.85 ms | 5 | measured |
| moui-wgpu | medium | scroll | ui-frame | 0.612/0.845 | - | 13.234/14.822 | - | n/a | n/a | n/a | 309.05 ms | 8 | measured |
| moui-wgpu | large | open | ui-frame | 0.012/0.013 | - | - | - | n/a | n/a | n/a | 315.45 ms | 0 | measured |
| moui-wgpu | large | input | ui-frame | 0.729/0.899 | - | 14.308/20.940 | 14.227/20.933 | n/a | n/a | n/a | 322.49 ms | 5 | measured |
| moui-wgpu | large | scroll | ui-frame | 0.603/0.781 | - | 13.176/14.753 | - | n/a | n/a | n/a | 329.71 ms | 5 | measured |
| moui-wgpu | stress | open | ui-frame | 0.018/0.021 | - | - | - | n/a | n/a | n/a | 346.28 ms | 0 | measured |
| moui-wgpu | stress | input | ui-frame | 0.773/0.975 | - | 16.914/22.396 | 16.821/22.198 | n/a | n/a | n/a | 350.81 ms | 13 | measured |
| moui-wgpu | stress | scroll | ui-frame | 0.623/0.840 | - | 13.233/14.779 | - | n/a | n/a | n/a | 352.07 ms | 6 | measured |
| moui-md-skia-raster | small | open | ui-frame | 0.028/0.057 | - | - | - | n/a | n/a | n/a | 267.63 ms | 0 | measured |
| moui-md-skia-raster | small | input | ui-frame | 2.282/2.522 | - | 36.978/47.653 | 36.920/47.647 | n/a | n/a | n/a | 325.81 ms | 57 | measured |
| moui-md-skia-raster | small | scroll | ui-frame | 1.737/2.114 | - | 35.993/39.120 | - | n/a | n/a | n/a | 266.36 ms | 716 | measured |
| moui-md-skia-raster | medium | open | ui-frame | 0.021/0.038 | - | - | - | n/a | n/a | n/a | 305.06 ms | 0 | measured |
| moui-md-skia-raster | medium | input | ui-frame | 2.275/2.504 | - | 38.488/48.708 | 38.432/48.664 | n/a | n/a | n/a | 271.09 ms | 59 | measured |
| moui-md-skia-raster | medium | scroll | ui-frame | 1.729/2.103 | - | 35.895/38.800 | - | n/a | n/a | n/a | 332.88 ms | 710 | measured |
| moui-md-skia-raster | large | open | ui-frame | 0.019/0.021 | - | - | - | n/a | n/a | n/a | 351.28 ms | 0 | measured |
| moui-md-skia-raster | large | input | ui-frame | 2.658/3.171 | - | 38.626/49.664 | 38.571/49.604 | n/a | n/a | n/a | 308.50 ms | 60 | measured |
| moui-md-skia-raster | large | scroll | ui-frame | 1.747/2.145 | - | 35.556/38.506 | - | n/a | n/a | n/a | 308.72 ms | 698 | measured |
| moui-md-skia-raster | stress | open | ui-frame | 0.014/0.019 | - | - | - | n/a | n/a | n/a | 441.64 ms | 0 | measured |
| moui-md-skia-raster | stress | input | ui-frame | 5.094/5.297 | - | 38.130/48.322 | 38.077/48.313 | n/a | n/a | n/a | 459.27 ms | 58 | measured |
| moui-md-skia-raster | stress | scroll | ui-frame | 1.733/2.118 | - | 36.088/39.127 | - | n/a | n/a | n/a | 435.99 ms | 709 | measured |
| moui-md-skia-gpu | small | open | ui-frame | 0.016/0.024 | - | - | - | n/a | n/a | n/a | 342.01 ms | 0 | measured |
| moui-md-skia-gpu | small | input | ui-frame | 2.192/2.346 | - | 19.076/20.172 | 19.019/20.168 | n/a | n/a | n/a | 313.05 ms | 26 | measured |
| moui-md-skia-gpu | small | scroll | ui-frame | 1.774/2.196 | - | 14.676/17.535 | - | n/a | n/a | n/a | 346.81 ms | 50 | measured |
| moui-md-skia-gpu | medium | open | ui-frame | 0.022/0.031 | - | - | - | n/a | n/a | n/a | 351.57 ms | 0 | measured |
| moui-md-skia-gpu | medium | input | ui-frame | 2.235/2.431 | - | 18.245/22.641 | 18.184/22.635 | n/a | n/a | n/a | 292.31 ms | 23 | measured |
| moui-md-skia-gpu | medium | scroll | ui-frame | 1.747/2.145 | - | 14.765/17.677 | - | n/a | n/a | n/a | 340.45 ms | 47 | measured |
| moui-md-skia-gpu | large | open | ui-frame | 0.016/0.021 | - | - | - | n/a | n/a | n/a | 355.76 ms | 0 | measured |
| moui-md-skia-gpu | large | input | ui-frame | 2.519/2.675 | - | 18.679/21.310 | 18.619/21.242 | n/a | n/a | n/a | 348.90 ms | 25 | measured |
| moui-md-skia-gpu | large | scroll | ui-frame | 1.793/2.215 | - | 15.103/17.642 | - | n/a | n/a | n/a | 293.73 ms | 54 | measured |
| moui-md-skia-gpu | stress | open | ui-frame | 0.019/0.020 | - | - | - | n/a | n/a | n/a | 456.46 ms | 0 | measured |
| moui-md-skia-gpu | stress | input | ui-frame | 5.061/5.364 | - | 20.939/22.545 | 20.858/22.399 | n/a | n/a | n/a | 459.14 ms | 30 | measured |
| moui-md-skia-gpu | stress | scroll | ui-frame | 1.772/2.171 | - | 15.095/17.641 | - | n/a | n/a | n/a | 417.46 ms | 59 | measured |
| moui-md-wgpu | small | open | ui-frame | 0.012/0.014 | - | - | - | n/a | n/a | n/a | 312.18 ms | 0 | measured |
| moui-md-wgpu | small | input | ui-frame | 1.911/2.384 | - | 22.353/37.575 | 22.255/37.468 | n/a | n/a | n/a | 305.53 ms | 33 | measured |
| moui-md-wgpu | small | scroll | ui-frame | 2.361/2.989 | - | 24.810/34.630 | - | n/a | n/a | n/a | 326.49 ms | 387 | measured |
| moui-md-wgpu | medium | open | ui-frame | 0.025/0.045 | - | - | - | n/a | n/a | n/a | 307.54 ms | 0 | measured |
| moui-md-wgpu | medium | input | ui-frame | 1.869/2.243 | - | 22.771/41.157 | 22.685/41.069 | n/a | n/a | n/a | 302.44 ms | 30 | measured |
| moui-md-wgpu | medium | scroll | ui-frame | 2.320/2.907 | - | 24.304/34.869 | - | n/a | n/a | n/a | 309.34 ms | 398 | measured |
| moui-md-wgpu | large | open | ui-frame | 0.017/0.025 | - | - | - | n/a | n/a | n/a | 322.85 ms | 0 | measured |
| moui-md-wgpu | large | input | ui-frame | 2.173/2.532 | - | 22.509/35.451 | 22.425/35.342 | n/a | n/a | n/a | 301.47 ms | 30 | measured |
| moui-md-wgpu | large | scroll | ui-frame | 2.354/2.995 | - | 24.146/34.434 | - | n/a | n/a | n/a | 302.46 ms | 394 | measured |
| moui-md-wgpu | stress | open | ui-frame | 0.011/0.012 | - | - | - | n/a | n/a | n/a | 361.50 ms | 0 | measured |
| moui-md-wgpu | stress | input | ui-frame | 4.863/6.044 | - | 24.647/27.381 | 24.539/27.374 | n/a | n/a | n/a | 416.84 ms | 30 | measured |
| moui-md-wgpu | stress | scroll | ui-frame | 2.428/3.064 | - | 24.440/35.121 | - | n/a | n/a | n/a | 397.00 ms | 403 | measured |
| gpmark | small | open | ui-frame | 6.053/6.206 | - | - | - | n/a | n/a | n/a | 169.91 ms | n/a | measured |
| gpmark | small | input | ui-frame | 5.592/6.044 | 0.359/0.427 | 9.820/11.449 | 9.815/11.447 | n/a | n/a | n/a | 166.03 ms | n/a | measured |
| gpmark | small | scroll | ui-frame | 6.522/7.985 | 0.003/0.005 | 9.970/11.504 | - | n/a | n/a | n/a | 163.10 ms | n/a | measured |
| gpmark | medium | open | ui-frame | 5.971/6.011 | - | - | - | n/a | n/a | n/a | 162.92 ms | n/a | measured |
| gpmark | medium | input | ui-frame | 5.599/5.965 | 0.385/0.456 | 9.941/15.183 | 9.937/15.179 | n/a | n/a | n/a | 169.92 ms | n/a | measured |
| gpmark | medium | scroll | ui-frame | 6.533/7.980 | 0.003/0.005 | 9.977/11.754 | - | n/a | n/a | n/a | 166.05 ms | n/a | measured |
| gpmark | large | open | ui-frame | 5.713/5.757 | - | - | - | n/a | n/a | n/a | 177.89 ms | n/a | measured |
| gpmark | large | input | ui-frame | 5.594/5.928 | 0.703/0.849 | 9.642/11.169 | 9.637/11.166 | n/a | n/a | n/a | 171.66 ms | n/a | measured |
| gpmark | large | scroll | ui-frame | 6.588/8.067 | 0.003/0.006 | 10.027/11.112 | - | n/a | n/a | n/a | 180.55 ms | n/a | measured |
| gpmark | stress | open | ui-frame | 6.498/7.441 | - | - | - | n/a | n/a | n/a | 266.81 ms | n/a | measured |
| gpmark | stress | input | ui-frame | 5.720/6.049 | 3.964/4.841 | 11.484/15.905 | 11.481/15.903 | n/a | n/a | n/a | 263.43 ms | n/a | measured |
| gpmark | stress | scroll | ui-frame | 6.624/8.121 | 0.003/0.005 | 10.002/11.390 | - | n/a | n/a | n/a | 262.43 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 0.397/0.456 | - | - | - | 9.69 ms | n/a | n/a | 203.00 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 0.601/0.923 | - | 11.667/30.002 | 9.871/10.150 | 0.70 ms | n/a | n/a | 203.33 ms | 3 | measured |
| flutter-skia | small | scroll | ui-frame | 1.346/1.794 | - | 10.083/10.002 | - | 0.43 ms | n/a | n/a | 202.33 ms | 2 | measured |
| flutter-skia | medium | open | ui-frame | 0.456/0.510 | - | - | - | 9.70 ms | n/a | n/a | 200.00 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 0.592/0.857 | - | 11.667/30.002 | 10.064/10.715 | 0.71 ms | n/a | n/a | 204.33 ms | 3 | measured |
| flutter-skia | medium | scroll | ui-frame | 1.766/2.445 | - | 10.139/10.002 | - | 0.42 ms | n/a | n/a | 203.00 ms | 4 | measured |
| flutter-skia | large | open | ui-frame | 0.647/0.789 | - | - | - | 11.79 ms | n/a | n/a | 217.00 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 0.616/0.853 | - | 11.334/30.002 | 9.968/10.219 | 0.66 ms | n/a | n/a | 207.33 ms | 2 | measured |
| flutter-skia | large | scroll | ui-frame | 1.740/2.430 | - | 10.111/10.002 | - | 0.41 ms | n/a | n/a | 204.00 ms | 3 | measured |
| flutter-skia | stress | open | ui-frame | 0.374/0.439 | - | - | - | 9.75 ms | n/a | n/a | 236.00 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 0.568/0.764 | - | 12.334/30.003 | 9.847/10.295 | 0.68 ms | n/a | n/a | 252.00 ms | 4 | measured |
| flutter-skia | stress | scroll | ui-frame | 1.744/2.434 | - | 10.167/10.002 | - | 0.41 ms | n/a | n/a | 242.67 ms | 4 | measured |
| flutter-impeller | small | open | ui-frame | 0.512/0.557 | - | - | - | 7.12 ms | n/a | n/a | 206.00 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 0.621/0.891 | - | 12.667/40.004 | 10.189/10.484 | 0.66 ms | n/a | n/a | 221.33 ms | 5 | measured |
| flutter-impeller | small | scroll | ui-frame | 1.331/1.734 | - | 10.167/10.003 | - | 0.42 ms | n/a | n/a | 217.67 ms | 4 | measured |
| flutter-impeller | medium | open | ui-frame | 0.472/0.509 | - | - | - | 7.17 ms | n/a | n/a | 221.33 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 0.617/0.863 | - | 11.334/20.003 | 10.092/12.217 | 0.61 ms | n/a | n/a | 212.00 ms | 3 | measured |
| flutter-impeller | medium | scroll | ui-frame | 1.846/2.589 | - | 10.111/10.002 | - | 0.42 ms | n/a | n/a | 210.33 ms | 3 | measured |
| flutter-impeller | large | open | ui-frame | 0.349/0.369 | - | - | - | 7.49 ms | n/a | n/a | 214.00 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 0.621/0.886 | - | 10.667/10.005 | 10.001/10.400 | 0.65 ms | n/a | n/a | 214.67 ms | 1 | measured |
| flutter-impeller | large | scroll | ui-frame | 1.841/2.524 | - | 10.111/10.002 | - | 0.41 ms | n/a | n/a | 211.00 ms | 3 | measured |
| flutter-impeller | stress | open | ui-frame | 0.403/0.469 | - | - | - | 7.56 ms | n/a | n/a | 247.67 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 0.609/0.931 | - | 12.667/30.004 | 10.096/16.447 | 0.63 ms | n/a | n/a | 251.00 ms | 5 | measured |
| flutter-impeller | stress | scroll | ui-frame | 1.821/2.484 | - | 10.195/10.002 | - | 0.41 ms | n/a | n/a | 252.33 ms | 5 | measured |
| electron | small | open | ui-frame | 411.000/436.000 | - | - | - | n/a | n/a | n/a | 411.00 ms | 0 | measured |
| electron | small | input | ui-frame | 2.503/4.000 | - | 9.747/11.400 | 8.877/11.100 | n/a | n/a | n/a | 400.33 ms | 1 | measured |
| electron | small | scroll | ui-frame | 1.996/2.700 | - | 10.000/11.400 | - | n/a | n/a | n/a | 414.67 ms | 0 | measured |
| electron | medium | open | ui-frame | 403.333/424.000 | - | - | - | n/a | n/a | n/a | 403.33 ms | 0 | measured |
| electron | medium | input | ui-frame | 2.610/3.500 | - | 10.040/11.900 | 8.880/11.400 | n/a | n/a | n/a | 388.00 ms | 1 | measured |
| electron | medium | scroll | ui-frame | 2.125/3.000 | - | 9.915/11.500 | - | n/a | n/a | n/a | 388.33 ms | 0 | measured |
| electron | large | open | ui-frame | 407.667/417.000 | - | - | - | n/a | n/a | n/a | 407.67 ms | 0 | measured |
| electron | large | input | ui-frame | 2.787/4.900 | - | 10.273/13.336 | 8.897/10.500 | n/a | n/a | n/a | 399.00 ms | 0 | measured |
| electron | large | scroll | ui-frame | 2.101/2.900 | - | 9.932/11.400 | - | n/a | n/a | n/a | 399.33 ms | 0 | measured |
| electron | stress | open | ui-frame | 411.333/416.000 | - | - | - | n/a | n/a | n/a | 411.33 ms | 0 | measured |
| electron | stress | input | ui-frame | 2.447/3.800 | - | 9.614/10.700 | 8.763/10.600 | n/a | n/a | n/a | 408.67 ms | 1 | measured |
| electron | stress | scroll | ui-frame | 2.132/3.000 | - | 10.019/11.400 | - | n/a | n/a | n/a | 407.67 ms | 1 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 26.02/26.06/26.33 | 28.71/28.59/28.31 | 362/362/363 | 0.55/0.55/0.56 | 0.66/0.67/0.66 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 13.23/13.18/13.20 | 14.73/14.73/14.80 | 11/12/10 | 0.63/0.60/0.59 | 1.22/0.99/1.02 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 13.16/13.23/13.18 | 14.94/14.82/14.75 | 8/8/5 | 0.63/0.61/0.60 | 0.85/0.85/0.78 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 35.99/35.90/35.56 | 39.12/38.80/38.51 | 716/710/698 | 1.74/1.73/1.75 | 2.11/2.10/2.15 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 14.68/14.77/15.10 | 17.54/17.68/17.64 | 50/47/54 | 1.77/1.75/1.79 | 2.20/2.15/2.21 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 24.81/24.30/24.15 | 34.63/34.87/34.43 | 387/398/394 | 2.36/2.32/2.35 | 2.99/2.91/2.99 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 9.97/9.98/10.03 | 11.50/11.75/11.11 | n/a/n/a/n/a | 6.52/6.53/6.59 | 7.99/7.98/8.07 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 10.08/10.14/10.11 | 10.00/10.00/10.00 | 2/4/3 | 1.35/1.77/1.74 | 1.79/2.44/2.43 | 0.43/0.42/0.41 | 0.58/0.59/0.55 |
| Flutter Impeller | 10.17/10.11/10.11 | 10.00/10.00/10.00 | 4/3/3 | 1.33/1.85/1.84 | 1.73/2.59/2.52 | 0.42/0.42/0.41 | 0.58/0.63/0.57 |
| Electron | 10.00/9.92/9.93 | 11.40/11.50/11.40 | 0/0/0 | 2.00/2.12/2.10 | 2.70/3.00/2.90 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 26.57 | 29.49 | 362 | 0.56 | 0.67 | n/a | n/a |
| MoUI Skia GPU | 13.13 | 14.85 | 7 | 0.61 | 1.15 | n/a | n/a |
| MoUI WGPU | 13.23 | 14.78 | 6 | 0.62 | 0.84 | n/a | n/a |
| MoMark Skia Raster | 36.09 | 39.13 | 709 | 1.73 | 2.12 | n/a | n/a |
| MoMark Skia GPU | 15.09 | 17.64 | 59 | 1.77 | 2.17 | n/a | n/a |
| MoMark WGPU | 24.44 | 35.12 | 403 | 2.43 | 3.06 | n/a | n/a |
| GpMark.mbt (GPUI) | 10.00 | 11.39 | n/a | 6.62 | 8.12 | n/a | n/a |
| Flutter Skia | 10.17 | 10.00 | 4 | 1.74 | 2.43 | 0.41 | 0.54 |
| Flutter Impeller | 10.19 | 10.00 | 5 | 1.82 | 2.48 | 0.41 | 0.63 |
| Electron | 10.02 | 11.40 | 1 | 2.13 | 3.00 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 28.44/27.71/29.02 | 38.96/29.96/39.41 | 0.77/0.76/0.78 | 0.92/0.89/0.88 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 14.52/14.21/14.11 | 19.27/20.37/19.36 | 0.79/0.75/0.76 | 0.95/0.88/0.92 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 13.77/14.16/14.23 | 20.02/19.87/20.93 | 0.77/0.75/0.73 | 1.07/0.91/0.90 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 36.92/38.43/38.57 | 47.65/48.66/49.60 | 2.28/2.28/2.66 | 2.52/2.50/3.17 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 19.02/18.18/18.62 | 20.17/22.63/21.24 | 2.19/2.24/2.52 | 2.35/2.43/2.68 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 22.26/22.68/22.42 | 37.47/41.07/35.34 | 1.91/1.87/2.17 | 2.38/2.24/2.53 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 9.81/9.94/9.64 | 11.45/15.18/11.17 | 5.59/5.60/5.59 | 6.04/5.96/5.93 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 9.87/10.06/9.97 | 10.15/10.71/10.22 | 0.60/0.59/0.62 | 0.92/0.86/0.85 | 0.70/0.71/0.66 | 1.41/1.56/1.30 |
| Flutter Impeller | 10.19/10.09/10.00 | 10.48/12.22/10.40 | 0.62/0.62/0.62 | 0.89/0.86/0.89 | 0.66/0.61/0.65 | 1.57/1.38/1.42 |
| Electron | 8.88/8.88/8.90 | 11.10/11.40/10.50 | 2.50/2.61/2.79 | 4.00/3.50/4.90 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 28.40 | 37.17 | 0.81 | 1.02 | n/a | n/a |
| MoUI Skia GPU | 16.17 | 18.76 | 0.79 | 0.99 | n/a | n/a |
| MoUI WGPU | 16.82 | 22.20 | 0.77 | 0.98 | n/a | n/a |
| MoMark Skia Raster | 38.08 | 48.31 | 5.09 | 5.30 | n/a | n/a |
| MoMark Skia GPU | 20.86 | 22.40 | 5.06 | 5.36 | n/a | n/a |
| MoMark WGPU | 24.54 | 27.37 | 4.86 | 6.04 | n/a | n/a |
| GpMark.mbt (GPUI) | 11.48 | 15.90 | 5.72 | 6.05 | n/a | n/a |
| Flutter Skia | 9.85 | 10.29 | 0.57 | 0.76 | 0.68 | 1.40 |
| Flutter Impeller | 10.10 | 16.45 | 0.61 | 0.93 | 0.63 | 1.22 |
| Electron | 8.76 | 10.60 | 2.45 | 3.80 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 287.25/255.62/259.56 | 291.48/283.49/285.35 | 0.12/0.40/3.00 | 0.13/0.51/3.24 | 0.02/0.01/0.01 | 0.03/0.02/0.02 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 283.64/294.42/293.41 | 299.11/308.64/297.39 | 0.09/0.36/2.75 | 0.09/0.45/3.22 | 0.02/0.01/0.03 | 0.02/0.01/0.04 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 314.00/301.76/315.45 | 324.35/305.36/328.16 | 0.12/0.51/3.07 | 0.16/0.55/3.41 | 0.02/0.01/0.01 | 0.03/0.01/0.01 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 267.63/305.06/351.28 | 317.47/312.68/367.92 | 0.12/0.35/2.88 | 0.14/0.41/3.04 | 0.03/0.02/0.02 | 0.06/0.04/0.02 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 342.01/351.57/355.76 | 348.29/361.31/359.79 | 0.16/0.33/2.84 | 0.24/0.36/2.89 | 0.02/0.02/0.02 | 0.02/0.03/0.02 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 312.18/307.54/322.85 | 328.34/310.37/345.79 | 0.09/0.30/2.48 | 0.12/0.31/2.83 | 0.01/0.03/0.02 | 0.01/0.04/0.03 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 169.91/162.92/177.89 | 174.67/178.84/185.49 | 0.00/0.67/2.67 | 0.00/1.00/3.00 | 6.05/5.97/5.71 | 6.21/6.01/5.76 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 203.00/200.00/217.00 | 206.00/205.00/234.00 | 0.11/0.12/0.46 | 0.11/0.13/0.54 | 0.40/0.46/0.65 | 0.46/0.51/0.79 | 9.69/9.70/11.79 | 10.11/9.90/13.55 |
| Flutter Impeller | 206.00/221.33/214.00 | 207.00/228.00/223.00 | 0.13/0.16/0.42 | 0.16/0.17/0.47 | 0.51/0.47/0.35 | 0.56/0.51/0.37 | 7.12/7.17/7.49 | 7.15/7.24/7.97 |
| Electron | 411.00/403.33/407.67 | 436.00/424.00/417.00 | 5.63/8.06/8.49 | 9.60/10.30/11.09 | 411.00/403.33/407.67 | 436.00/424.00/417.00 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 325.29 | 331.25 | 27.56 | 28.90 | 0.01 | 0.01 | n/a | n/a |
| MoUI Skia GPU | 330.37 | 337.11 | 26.02 | 28.97 | 0.01 | 0.01 | n/a | n/a |
| MoUI WGPU | 346.28 | 355.33 | 27.65 | 28.36 | 0.02 | 0.02 | n/a | n/a |
| MoMark Skia Raster | 441.64 | 463.03 | 27.59 | 29.46 | 0.01 | 0.02 | n/a | n/a |
| MoMark Skia GPU | 456.46 | 460.67 | 28.11 | 30.19 | 0.02 | 0.02 | n/a | n/a |
| MoMark WGPU | 361.50 | 443.58 | 26.52 | 26.88 | 0.01 | 0.01 | n/a | n/a |
| GpMark.mbt (GPUI) | 266.81 | 271.66 | 25.67 | 30.00 | 6.50 | 7.44 | n/a | n/a |
| Flutter Skia | 236.00 | 246.00 | 3.39 | 3.71 | 0.37 | 0.44 | 9.75 | 9.84 |
| Flutter Impeller | 247.67 | 262.00 | 4.41 | 4.54 | 0.40 | 0.47 | 7.56 | 7.85 |
| Electron | 411.33 | 416.00 | 11.17 | 13.30 | 411.33 | 416.00 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 26.02/26.06/26.33 | 28.71/28.59/28.31 | 362/362/363 | 0.55/0.55/0.56 | 0.66/0.67/0.66 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 13.23/13.18/13.20 | 14.73/14.73/14.80 | 11/12/10 | 0.63/0.60/0.59 | 1.22/0.99/1.02 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 13.16/13.23/13.18 | 14.94/14.82/14.75 | 8/8/5 | 0.63/0.61/0.60 | 0.85/0.85/0.78 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 35.99/35.90/35.56 | 39.12/38.80/38.51 | 716/710/698 | 1.74/1.73/1.75 | 2.11/2.10/2.15 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 14.68/14.77/15.10 | 17.54/17.68/17.64 | 50/47/54 | 1.77/1.75/1.79 | 2.20/2.15/2.21 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 24.81/24.30/24.15 | 34.63/34.87/34.43 | 387/398/394 | 2.36/2.32/2.35 | 2.99/2.91/2.99 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 9.97/9.98/10.03 | 11.50/11.75/11.11 | n/a/n/a/n/a | 6.52/6.53/6.59 | 7.99/7.98/8.07 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 10.08/10.14/10.11 | 10.00/10.00/10.00 | 2/4/3 | 1.35/1.77/1.74 | 1.79/2.44/2.43 | 0.43/0.42/0.41 | 0.58/0.59/0.55 |
| Flutter Impeller | 10.17/10.11/10.11 | 10.00/10.00/10.00 | 4/3/3 | 1.33/1.85/1.84 | 1.73/2.59/2.52 | 0.42/0.42/0.41 | 0.58/0.63/0.57 |
| Electron | 10.00/9.92/9.93 | 11.40/11.50/11.40 | 0/0/0 | 2.00/2.12/2.10 | 2.70/3.00/2.90 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 26.57 | 29.49 | 362 | 0.56 | 0.67 | n/a | n/a |
| MoUI Skia GPU | 13.13 | 14.85 | 7 | 0.61 | 1.15 | n/a | n/a |
| MoUI WGPU | 13.23 | 14.78 | 6 | 0.62 | 0.84 | n/a | n/a |
| MoMark Skia Raster | 36.09 | 39.13 | 709 | 1.73 | 2.12 | n/a | n/a |
| MoMark Skia GPU | 15.09 | 17.64 | 59 | 1.77 | 2.17 | n/a | n/a |
| MoMark WGPU | 24.44 | 35.12 | 403 | 2.43 | 3.06 | n/a | n/a |
| GpMark.mbt (GPUI) | 10.00 | 11.39 | n/a | 6.62 | 8.12 | n/a | n/a |
| Flutter Skia | 10.17 | 10.00 | 4 | 1.74 | 2.43 | 0.41 | 0.54 |
| Flutter Impeller | 10.19 | 10.00 | 5 | 1.82 | 2.48 | 0.41 | 0.63 |
| Electron | 10.02 | 11.40 | 1 | 2.13 | 3.00 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoUI Skia Raster CPU small 287.2 ms（max 291.5 ms）；MoUI Skia Raster CPU medium 255.6 ms（max 283.5 ms）；MoUI Skia Raster CPU large 259.6 ms（max 285.3 ms）；MoUI Skia Raster CPU stress 325.3 ms（max 331.2 ms）；MoUI Skia GPU small 283.6 ms（max 299.1 ms）；MoUI Skia GPU medium 294.4 ms（max 308.6 ms）；MoUI Skia GPU large 293.4 ms（max 297.4 ms）；MoUI Skia GPU stress 330.4 ms（max 337.1 ms）；MoUI WGPU small 314.0 ms（max 324.3 ms）；MoUI WGPU medium 301.8 ms（max 305.4 ms）；MoUI WGPU large 315.4 ms（max 328.2 ms）；MoUI WGPU stress 346.3 ms（max 355.3 ms）；MoMark Skia Raster small 267.6 ms（max 317.5 ms）；MoMark Skia Raster medium 305.1 ms（max 312.7 ms）；MoMark Skia Raster large 351.3 ms（max 367.9 ms）；MoMark Skia Raster stress 441.6 ms（max 463.0 ms）；MoMark Skia GPU small 342.0 ms（max 348.3 ms）；MoMark Skia GPU medium 351.6 ms（max 361.3 ms）；MoMark Skia GPU large 355.8 ms（max 359.8 ms）；MoMark Skia GPU stress 456.5 ms（max 460.7 ms）；MoMark WGPU small 312.2 ms（max 328.3 ms）；MoMark WGPU medium 307.5 ms（max 310.4 ms）；MoMark WGPU large 322.9 ms（max 345.8 ms）；MoMark WGPU stress 361.5 ms（max 443.6 ms）；GpMark.mbt (GPUI) small 169.9 ms（max 174.7 ms）；GpMark.mbt (GPUI) medium 162.9 ms（max 178.8 ms）；GpMark.mbt (GPUI) large 177.9 ms（max 185.5 ms）；GpMark.mbt (GPUI) stress 266.8 ms（max 271.7 ms）；Flutter Skia small 203.0 ms（max 206.0 ms）；Flutter Skia medium 200.0 ms（max 205.0 ms）；Flutter Skia large 217.0 ms（max 234.0 ms）；Flutter Skia stress 236.0 ms（max 246.0 ms）；Flutter Impeller small 206.0 ms（max 207.0 ms）；Flutter Impeller medium 221.3 ms（max 228.0 ms）；Flutter Impeller large 214.0 ms（max 223.0 ms）；Flutter Impeller stress 247.7 ms（max 262.0 ms）；Electron small 411.0 ms（max 436.0 ms）；Electron medium 403.3 ms（max 424.0 ms）；Electron large 407.7 ms（max 417.0 ms）；Electron stress 411.3 ms（max 416.0 ms）。
- P1 输入尾延迟：MoUI Skia Raster CPU small P95 38.96 ms；MoUI Skia Raster CPU medium P95 29.96 ms；MoUI Skia Raster CPU large P95 39.41 ms；MoUI Skia Raster CPU stress P95 37.17 ms；MoUI Skia GPU small P95 19.27 ms；MoUI Skia GPU medium P95 20.37 ms；MoUI Skia GPU large P95 19.36 ms；MoUI Skia GPU stress P95 18.76 ms；MoUI WGPU small P95 20.02 ms；MoUI WGPU medium P95 19.87 ms；MoUI WGPU large P95 20.93 ms；MoUI WGPU stress P95 22.20 ms；MoMark Skia Raster small P95 47.65 ms；MoMark Skia Raster medium P95 48.66 ms；MoMark Skia Raster large P95 49.60 ms；MoMark Skia Raster stress P95 48.31 ms；MoMark Skia GPU small P95 20.17 ms；MoMark Skia GPU medium P95 22.63 ms；MoMark Skia GPU large P95 21.24 ms；MoMark Skia GPU stress P95 22.40 ms；MoMark WGPU small P95 37.47 ms；MoMark WGPU medium P95 41.07 ms；MoMark WGPU large P95 35.34 ms；MoMark WGPU stress P95 27.37 ms。
- 长帧（超预算）：MoUI Skia Raster CPU: small/input 30 次，max 41.91 ms, small/scroll 358 次，max 39.96 ms, medium/input 30 次，max 41.37 ms, medium/scroll 359 次，max 41.88 ms, large/input 30 次，max 42.99 ms, large/scroll 359 次，max 43.16 ms, stress/input 30 次，max 53.41 ms, stress/scroll 360 次，max 39.46 ms；MoUI Skia GPU: small/input 5 次，max 20.01 ms, small/scroll 11 次，max 20.67 ms, medium/input 5 次，max 20.44 ms, medium/scroll 12 次，max 20.02 ms, large/input 3 次，max 19.75 ms, large/scroll 10 次，max 20.63 ms, stress/input 6 次，max 22.68 ms, stress/scroll 7 次，max 19.99 ms；MoUI WGPU: small/input 4 次，max 21.99 ms, small/scroll 8 次，max 20.04 ms, medium/input 5 次，max 20.18 ms, medium/scroll 8 次，max 20.02 ms, large/input 5 次，max 21.21 ms, large/scroll 5 次，max 19.98 ms, stress/input 12 次，max 23.84 ms, stress/scroll 6 次，max 20.03 ms；MoMark Skia Raster: small/input 30 次，max 49.17 ms, small/scroll 360 次，max 56.31 ms, medium/input 30 次，max 59.01 ms, medium/scroll 360 次，max 51.65 ms, large/input 30 次，max 49.69 ms, large/scroll 360 次，max 50.29 ms, stress/input 30 次，max 49.96 ms, stress/scroll 360 次，max 47.96 ms；MoMark Skia GPU: small/input 26 次，max 22.84 ms, small/scroll 44 次，max 19.66 ms, medium/input 23 次，max 26.82 ms, medium/scroll 42 次，max 20.32 ms, large/input 25 次，max 22.40 ms, large/scroll 37 次，max 23.92 ms, stress/input 30 次，max 23.22 ms, stress/scroll 42 次，max 20.36 ms；MoMark WGPU: small/input 30 次，max 40.40 ms, small/scroll 355 次，max 49.66 ms, medium/input 28 次，max 47.62 ms, medium/scroll 354 次，max 55.04 ms, large/input 28 次，max 44.73 ms, large/scroll 352 次，max 162.02 ms, stress/input 30 次，max 27.71 ms, stress/scroll 356 次，max 53.97 ms；GpMark.mbt (GPUI): medium/input 1 次，max 21.20 ms, large/scroll 2 次，max 27.52 ms, stress/input 1 次，max 18.96 ms, stress/scroll 2 次，max 18.21 ms；Flutter Skia: small/input 2 次，max 40.01 ms, small/scroll 1 次，max 40.00 ms, medium/input 2 次，max 40.00 ms, medium/scroll 2 次，max 40.00 ms, large/input 2 次，max 30.00 ms, large/scroll 2 次，max 40.00 ms, stress/input 3 次，max 40.00 ms, stress/scroll 3 次，max 40.00 ms；Flutter Impeller: small/input 2 次，max 60.00 ms, small/scroll 3 次，max 40.00 ms, medium/input 2 次，max 40.00 ms, medium/scroll 2 次，max 40.00 ms, large/input 1 次，max 30.00 ms, large/scroll 2 次，max 40.00 ms, stress/input 4 次，max 40.00 ms, stress/scroll 3 次，max 40.01 ms；Electron: medium/input 1 次，max 16.77 ms, stress/scroll 1 次，max 20.00 ms。
- 丢帧（优先处理）：MoUI Skia Raster CPU: small/input 32 帧, small/scroll 362 帧, medium/input 31 帧, medium/scroll 362 帧, large/input 33 帧, large/scroll 363 帧, stress/input 33 帧, stress/scroll 362 帧；MoUI Skia GPU: small/input 5 帧, small/scroll 11 帧, medium/input 5 帧, medium/scroll 12 帧, large/input 3 帧, large/scroll 10 帧, stress/input 7 帧, stress/scroll 7 帧；MoUI WGPU: small/input 4 帧, small/scroll 8 帧, medium/input 5 帧, medium/scroll 8 帧, large/input 5 帧, large/scroll 5 帧, stress/input 13 帧, stress/scroll 6 帧；MoMark Skia Raster: small/input 57 帧, small/scroll 716 帧, medium/input 59 帧, medium/scroll 710 帧, large/input 60 帧, large/scroll 698 帧, stress/input 58 帧, stress/scroll 709 帧；MoMark Skia GPU: small/input 26 帧, small/scroll 50 帧, medium/input 23 帧, medium/scroll 47 帧, large/input 25 帧, large/scroll 54 帧, stress/input 30 帧, stress/scroll 59 帧；MoMark WGPU: small/input 33 帧, small/scroll 387 帧, medium/input 30 帧, medium/scroll 398 帧, large/input 30 帧, large/scroll 394 帧, stress/input 30 帧, stress/scroll 403 帧；Flutter Skia: small/input 3 帧, small/scroll 2 帧, medium/input 3 帧, medium/scroll 4 帧, large/input 2 帧, large/scroll 3 帧, stress/input 4 帧, stress/scroll 4 帧；Flutter Impeller: small/input 5 帧, small/scroll 4 帧, medium/input 3 帧, medium/scroll 3 帧, large/input 1 帧, large/scroll 3 帧, stress/input 5 帧, stress/scroll 5 帧；Electron: small/input 1 帧, medium/input 1 帧, stress/input 1 帧, stress/scroll 1 帧。
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
