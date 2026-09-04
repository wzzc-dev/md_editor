# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-04T05:33:22Z`
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
| moui-skia-raster | small | open | ui-frame | 42.902/44.286 | - | - | - | 4.75 ms | 0.00 ms | 4.75 ms | 48.72 ms | n/a | measured |
| moui-skia-raster | small | input | ui-frame | 0.479/0.502 | - | 3.638/3.793 | 3.637/3.793 | 3.04 ms | 0.00 ms | 3.04 ms | 48.36 ms | n/a | measured |
| moui-skia-raster | small | scroll | ui-frame | 1.563/3.518 | - | 5.304/8.206 | - | 3.20 ms | 0.00 ms | 3.20 ms | 47.78 ms | n/a | measured |
| moui-skia-raster | medium | open | ui-frame | 41.873/42.150 | - | - | - | 4.61 ms | 0.00 ms | 4.61 ms | 47.74 ms | n/a | measured |
| moui-skia-raster | medium | input | ui-frame | 0.481/0.503 | - | 3.695/3.823 | 3.694/3.823 | 3.08 ms | 0.00 ms | 3.08 ms | 48.56 ms | n/a | measured |
| moui-skia-raster | medium | scroll | ui-frame | 1.561/3.502 | - | 5.308/8.017 | - | 3.20 ms | 0.00 ms | 3.20 ms | 48.27 ms | n/a | measured |
| moui-skia-raster | large | open | ui-frame | 43.659/45.530 | - | - | - | 4.89 ms | 0.00 ms | 4.89 ms | 51.42 ms | n/a | measured |
| moui-skia-raster | large | input | ui-frame | 0.481/0.498 | - | 3.801/3.955 | 3.800/3.954 | 3.06 ms | 0.00 ms | 3.06 ms | 49.82 ms | n/a | measured |
| moui-skia-raster | large | scroll | ui-frame | 1.557/3.481 | - | 5.311/8.079 | - | 3.21 ms | 0.00 ms | 3.21 ms | 49.71 ms | n/a | measured |
| moui-skia-raster | stress | open | ui-frame | 42.340/42.817 | - | - | - | 4.46 ms | 0.00 ms | 4.46 ms | 65.39 ms | n/a | measured |
| moui-skia-raster | stress | input | ui-frame | 0.523/0.574 | - | 5.761/6.696 | 5.761/6.696 | 3.16 ms | 0.00 ms | 3.16 ms | 67.01 ms | n/a | measured |
| moui-skia-raster | stress | scroll | ui-frame | 1.572/3.519 | - | 5.333/8.078 | - | 3.21 ms | 0.00 ms | 3.21 ms | 65.98 ms | n/a | measured |
| moui-skia-gpu | small | open | ui-frame | 39.395/39.928 | - | - | - | 11.80 ms | n/a | 0.00 ms | 52.29 ms | n/a | measured |
| moui-skia-gpu | small | input | ui-frame | 0.488/0.543 | - | 8.277/8.811 | 8.276/8.811 | 7.62 ms | n/a | 0.00 ms | 53.61 ms | n/a | measured |
| moui-skia-gpu | small | scroll | ui-frame | 1.594/3.492 | - | 8.362/9.292 | - | 6.19 ms | n/a | 0.00 ms | 51.74 ms | n/a | measured |
| moui-skia-gpu | medium | open | ui-frame | 40.018/40.126 | - | - | - | 10.37 ms | n/a | 0.00 ms | 51.64 ms | n/a | measured |
| moui-skia-gpu | medium | input | ui-frame | 0.487/0.533 | - | 8.311/8.883 | 8.310/8.883 | 7.65 ms | n/a | 0.00 ms | 53.47 ms | n/a | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 1.582/3.470 | - | 8.365/9.265 | - | 6.21 ms | n/a | 0.00 ms | 53.60 ms | n/a | measured |
| moui-skia-gpu | large | open | ui-frame | 40.027/40.200 | - | - | - | 10.37 ms | n/a | 0.00 ms | 53.28 ms | n/a | measured |
| moui-skia-gpu | large | input | ui-frame | 0.479/0.512 | - | 8.314/9.000 | 8.313/8.999 | 7.51 ms | n/a | 0.00 ms | 53.66 ms | n/a | measured |
| moui-skia-gpu | large | scroll | ui-frame | 1.589/3.486 | - | 8.372/9.336 | - | 6.20 ms | n/a | 0.00 ms | 53.46 ms | n/a | measured |
| moui-skia-gpu | stress | open | ui-frame | 40.864/41.228 | - | - | - | 10.52 ms | n/a | 0.00 ms | 70.38 ms | n/a | measured |
| moui-skia-gpu | stress | input | ui-frame | 0.523/0.585 | - | 8.373/9.345 | 8.371/9.343 | 5.74 ms | n/a | 0.00 ms | 71.06 ms | n/a | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 1.589/3.455 | - | 8.367/9.316 | - | 6.20 ms | n/a | 0.00 ms | 69.15 ms | n/a | measured |
| moui-wgpu | small | open | ui-frame | 37.430/37.775 | - | - | - | 9.32 ms | n/a | 0.00 ms | 47.88 ms | n/a | measured |
| moui-wgpu | small | input | ui-frame | 0.518/0.611 | - | 8.227/8.958 | 8.227/8.958 | 7.55 ms | n/a | 0.00 ms | 49.09 ms | n/a | measured |
| moui-wgpu | small | scroll | ui-frame | 2.229/3.424 | - | 8.328/9.204 | - | 5.35 ms | n/a | 0.00 ms | 47.68 ms | n/a | measured |
| moui-wgpu | medium | open | ui-frame | 38.203/39.546 | - | - | - | 9.35 ms | n/a | 0.00 ms | 48.85 ms | n/a | measured |
| moui-wgpu | medium | input | ui-frame | 0.514/0.588 | - | 8.235/9.368 | 8.234/9.368 | 7.55 ms | n/a | 0.00 ms | 49.75 ms | n/a | measured |
| moui-wgpu | medium | scroll | ui-frame | 2.228/3.462 | - | 8.329/9.164 | - | 5.34 ms | n/a | 0.00 ms | 48.28 ms | n/a | measured |
| moui-wgpu | large | open | ui-frame | 36.806/37.257 | - | - | - | 9.48 ms | n/a | 0.00 ms | 49.19 ms | n/a | measured |
| moui-wgpu | large | input | ui-frame | 0.521/0.602 | - | 8.192/9.824 | 8.191/9.823 | 7.34 ms | n/a | 0.00 ms | 49.50 ms | n/a | measured |
| moui-wgpu | large | scroll | ui-frame | 2.224/3.402 | - | 8.331/9.124 | - | 5.35 ms | n/a | 0.00 ms | 49.23 ms | n/a | measured |
| moui-wgpu | stress | open | ui-frame | 38.024/39.148 | - | - | - | 9.34 ms | n/a | 0.00 ms | 66.36 ms | n/a | measured |
| moui-wgpu | stress | input | ui-frame | 0.513/0.561 | - | 8.235/8.998 | 8.234/8.998 | 5.56 ms | n/a | 0.00 ms | 67.01 ms | n/a | measured |
| moui-wgpu | stress | scroll | ui-frame | 2.110/3.464 | - | 8.330/9.201 | - | 5.50 ms | n/a | 0.00 ms | 66.06 ms | n/a | measured |
| moui-md-skia-raster | small | open | ui-frame | 43.932/44.632 | - | - | - | 12.31 ms | 0.00 ms | 12.31 ms | 59.08 ms | n/a | measured |
| moui-md-skia-raster | small | input | ui-frame | 2.809/2.964 | - | 7.356/7.885 | 7.301/7.699 | 3.73 ms | 0.00 ms | 3.73 ms | 60.12 ms | n/a | measured |
| moui-md-skia-raster | small | scroll | ui-frame | 0.924/1.082 | - | 3.180/3.618 | - | 2.14 ms | 0.00 ms | 2.14 ms | 58.90 ms | n/a | measured |
| moui-md-skia-raster | medium | open | ui-frame | 47.404/47.567 | - | - | - | 11.86 ms | 0.00 ms | 11.86 ms | 74.43 ms | n/a | measured |
| moui-md-skia-raster | medium | input | ui-frame | 3.312/3.554 | - | 13.480/16.714 | 13.108/13.877 | 3.79 ms | 0.00 ms | 3.79 ms | 77.92 ms | n/a | measured |
| moui-md-skia-raster | medium | scroll | ui-frame | 1.195/1.240 | - | 3.658/3.939 | - | 2.16 ms | 0.00 ms | 2.16 ms | 75.09 ms | n/a | measured |
| moui-md-skia-raster | large | open | ui-frame | 80.377/81.462 | - | - | - | 11.85 ms | 0.00 ms | 11.85 ms | 230.87 ms | n/a | measured |
| moui-md-skia-raster | large | input | ui-frame | 8.290/8.547 | - | 74.647/105.849 | 71.085/72.875 | 4.01 ms | 0.00 ms | 4.01 ms | 246.45 ms | n/a | measured |
| moui-md-skia-raster | large | scroll | ui-frame | 3.841/5.165 | - | 8.085/8.955 | - | 2.19 ms | 0.00 ms | 2.19 ms | 231.63 ms | n/a | measured |
| moui-md-skia-raster | stress | open | ui-frame | 412.919/413.584 | - | - | - | 11.76 ms | 0.00 ms | 11.76 ms | 1834.79 ms | n/a | measured |
| moui-md-skia-raster | stress | input | ui-frame | 57.423/58.653 | - | 715.942/1034.913 | 679.058/687.620 | 4.21 ms | 0.00 ms | 4.21 ms | 1979.93 ms | n/a | measured |
| moui-md-skia-raster | stress | scroll | ui-frame | 31.750/46.537 | - | 56.053/68.367 | - | 2.79 ms | 0.00 ms | 2.79 ms | 1847.19 ms | n/a | measured |
| moui-md-skia-gpu | small | open | ui-frame | 43.716/45.081 | - | - | - | 25.98 ms | n/a | 0.00 ms | 72.64 ms | n/a | measured |
| moui-md-skia-gpu | small | input | ui-frame | 2.942/3.111 | - | 9.602/12.789 | 9.544/12.788 | 5.80 ms | n/a | 0.00 ms | 71.60 ms | n/a | measured |
| moui-md-skia-gpu | small | scroll | ui-frame | 1.286/2.070 | - | 8.519/9.274 | - | 6.97 ms | n/a | 0.00 ms | 80.63 ms | n/a | measured |
| moui-md-skia-gpu | medium | open | ui-frame | 54.504/56.552 | - | - | - | 38.34 ms | n/a | 0.00 ms | 109.52 ms | n/a | measured |
| moui-md-skia-gpu | medium | input | ui-frame | 4.371/5.263 | - | 18.465/26.589 | 18.042/25.357 | 6.53 ms | n/a | 0.00 ms | 111.45 ms | n/a | measured |
| moui-md-skia-gpu | medium | scroll | ui-frame | 1.627/1.904 | - | 8.398/9.228 | - | 6.33 ms | n/a | 0.00 ms | 93.47 ms | n/a | measured |
| moui-md-skia-gpu | large | open | ui-frame | 85.432/93.759 | - | - | - | 29.59 ms | n/a | 0.00 ms | 320.10 ms | n/a | measured |
| moui-md-skia-gpu | large | input | ui-frame | 8.610/9.545 | - | 77.599/109.613 | 73.924/83.669 | 4.68 ms | n/a | 0.00 ms | 268.90 ms | n/a | measured |
| moui-md-skia-gpu | large | scroll | ui-frame | 4.112/5.497 | - | 9.593/11.770 | - | 3.30 ms | n/a | 0.00 ms | 253.17 ms | n/a | measured |
| moui-md-skia-gpu | stress | open | ui-frame | 415.192/417.009 | - | - | - | 23.50 ms | n/a | 0.00 ms | 1845.60 ms | n/a | measured |
| moui-md-skia-gpu | stress | input | ui-frame | 61.433/95.719 | - | 764.580/1116.434 | 719.600/936.809 | 4.69 ms | n/a | 0.00 ms | 2042.93 ms | n/a | measured |
| moui-md-skia-gpu | stress | scroll | ui-frame | 33.253/48.603 | - | 59.978/71.169 | - | 3.23 ms | n/a | 0.00 ms | 1868.54 ms | n/a | measured |
| moui-md-wgpu | small | open | ui-frame | 41.139/42.484 | - | - | - | 12.85 ms | n/a | 0.00 ms | 56.94 ms | n/a | measured |
| moui-md-wgpu | small | input | ui-frame | 1.428/1.567 | - | 8.070/9.182 | 8.004/9.181 | 5.68 ms | n/a | 0.00 ms | 56.87 ms | n/a | measured |
| moui-md-wgpu | small | scroll | ui-frame | 1.248/1.498 | - | 8.304/9.046 | - | 6.88 ms | n/a | 0.00 ms | 53.32 ms | n/a | measured |
| moui-md-wgpu | medium | open | ui-frame | 42.413/44.881 | - | - | - | 13.05 ms | n/a | 0.00 ms | 71.29 ms | n/a | measured |
| moui-md-wgpu | medium | input | ui-frame | 1.788/1.863 | - | 10.340/13.798 | 9.917/10.658 | 1.77 ms | n/a | 0.00 ms | 71.47 ms | n/a | measured |
| moui-md-wgpu | medium | scroll | ui-frame | 1.538/1.648 | - | 8.334/9.173 | - | 6.42 ms | n/a | 0.00 ms | 68.67 ms | n/a | measured |
| moui-md-wgpu | large | open | ui-frame | 73.608/74.081 | - | - | - | 12.49 ms | n/a | 0.00 ms | 224.68 ms | n/a | measured |
| moui-md-wgpu | large | input | ui-frame | 6.548/6.789 | - | 72.065/104.807 | 68.352/69.249 | 1.99 ms | n/a | 0.00 ms | 241.99 ms | n/a | measured |
| moui-md-wgpu | large | scroll | ui-frame | 4.263/5.626 | - | 9.688/9.865 | - | 2.97 ms | n/a | 0.00 ms | 225.77 ms | n/a | measured |
| moui-md-wgpu | stress | open | ui-frame | 408.402/411.759 | - | - | - | 12.23 ms | n/a | 0.00 ms | 1831.81 ms | n/a | measured |
| moui-md-wgpu | stress | input | ui-frame | 55.585/56.968 | - | 714.737/1035.800 | 677.705/687.408 | 2.12 ms | n/a | 0.00 ms | 1970.59 ms | n/a | measured |
| moui-md-wgpu | stress | scroll | ui-frame | 32.101/46.809 | - | 55.955/68.096 | - | 2.22 ms | n/a | 0.00 ms | 1829.58 ms | n/a | measured |
| gpui | small | open | ui-frame | 16.839/17.124 | - | - | - | n/a | n/a | n/a | 111.85 ms | n/a | measured |
| gpui | small | input | ui-frame | 15.854/16.724 | 0.775/0.840 | 20.123/30.245 | 20.121/30.245 | n/a | n/a | n/a | 113.35 ms | n/a | measured |
| gpui | small | scroll | ui-frame | 17.552/20.149 | 0.001/0.002 | 20.672/23.897 | - | n/a | n/a | n/a | 115.94 ms | n/a | measured |
| gpui | medium | open | ui-frame | 16.838/16.900 | - | - | - | n/a | n/a | n/a | 116.05 ms | n/a | measured |
| gpui | medium | input | ui-frame | 15.903/16.689 | 1.601/1.701 | 20.940/25.602 | 20.938/25.601 | n/a | n/a | n/a | 113.15 ms | n/a | measured |
| gpui | medium | scroll | ui-frame | 17.519/20.170 | 0.001/0.002 | 21.028/24.148 | - | n/a | n/a | n/a | 113.91 ms | n/a | measured |
| gpui | large | open | ui-frame | 16.489/16.594 | - | - | - | n/a | n/a | n/a | 118.26 ms | n/a | measured |
| gpui | large | input | ui-frame | 15.902/16.898 | 10.119/10.833 | 28.296/37.128 | 28.295/37.127 | n/a | n/a | n/a | 122.16 ms | n/a | measured |
| gpui | large | scroll | ui-frame | 17.570/20.186 | 0.001/0.002 | 25.047/27.966 | - | n/a | n/a | n/a | 119.67 ms | n/a | measured |
| gpui | stress | open | ui-frame | 16.527/16.831 | - | - | - | n/a | n/a | n/a | 122.18 ms | n/a | measured |
| gpui | stress | input | ui-frame | 15.756/16.157 | 104.855/108.447 | 113.397/127.099 | 113.395/127.098 | n/a | n/a | n/a | 121.06 ms | n/a | measured |
| gpui | stress | scroll | ui-frame | 17.744/20.152 | 0.002/0.003 | 64.616/67.913 | - | n/a | n/a | n/a | 123.11 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 0.208/0.220 | - | - | - | 9.73 ms | n/a | n/a | 28.54 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 0.391/0.534 | - | 16.667/16.668 | 16.732/21.917 | 0.40 ms | n/a | n/a | 28.79 ms | 2 | measured |
| flutter-skia | small | scroll | ui-frame | 3.471/4.832 | - | 16.667/16.669 | - | 0.82 ms | n/a | n/a | 28.24 ms | 59 | measured |
| flutter-skia | medium | open | ui-frame | 0.194/0.205 | - | - | - | 9.46 ms | n/a | n/a | 29.28 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 0.459/0.640 | - | 16.667/16.669 | 16.762/19.605 | 0.45 ms | n/a | n/a | 28.50 ms | 5 | measured |
| flutter-skia | medium | scroll | ui-frame | 3.457/6.408 | - | 16.620/16.671 | - | 0.45 ms | n/a | n/a | 28.29 ms | 107 | measured |
| flutter-skia | large | open | ui-frame | 0.200/0.219 | - | - | - | 9.52 ms | n/a | n/a | 31.57 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 0.387/0.498 | - | 16.667/16.667 | 16.715/21.925 | 0.40 ms | n/a | n/a | 32.22 ms | 0 | measured |
| flutter-skia | large | scroll | ui-frame | 3.423/6.304 | - | 16.620/16.671 | - | 0.44 ms | n/a | n/a | 30.49 ms | 107 | measured |
| flutter-skia | stress | open | ui-frame | 0.202/0.207 | - | - | - | 9.56 ms | n/a | n/a | 57.77 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 0.354/0.525 | - | 16.667/16.667 | 16.713/22.586 | 0.36 ms | n/a | n/a | 59.15 ms | 1 | measured |
| flutter-skia | stress | scroll | ui-frame | 3.532/6.298 | - | 16.620/16.671 | - | 0.45 ms | n/a | n/a | 57.23 ms | 99 | measured |
| flutter-impeller | small | open | ui-frame | 0.228/0.257 | - | - | - | 8.09 ms | n/a | n/a | 28.54 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 0.398/0.555 | - | 16.667/16.668 | 16.740/20.676 | 0.41 ms | n/a | n/a | 28.32 ms | 3 | measured |
| flutter-impeller | small | scroll | ui-frame | 3.470/4.802 | - | 16.667/16.669 | - | 0.81 ms | n/a | n/a | 28.19 ms | 64 | measured |
| flutter-impeller | medium | open | ui-frame | 0.208/0.212 | - | - | - | 7.78 ms | n/a | n/a | 28.31 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 0.411/0.556 | - | 16.667/16.667 | 16.728/21.460 | 0.42 ms | n/a | n/a | 28.43 ms | 0 | measured |
| flutter-impeller | medium | scroll | ui-frame | 3.490/6.334 | - | 16.667/16.671 | - | 0.49 ms | n/a | n/a | 30.44 ms | 103 | measured |
| flutter-impeller | large | open | ui-frame | 0.197/0.209 | - | - | - | 7.70 ms | n/a | n/a | 30.41 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 0.399/0.506 | - | 16.667/16.668 | 16.725/18.829 | 0.41 ms | n/a | n/a | 30.69 ms | 2 | measured |
| flutter-impeller | large | scroll | ui-frame | 3.433/6.449 | - | 16.620/16.671 | - | 0.49 ms | n/a | n/a | 30.61 ms | 100 | measured |
| flutter-impeller | stress | open | ui-frame | 0.228/0.258 | - | - | - | 7.93 ms | n/a | n/a | 60.59 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 0.374/0.529 | - | 16.667/16.667 | 16.725/23.850 | 0.38 ms | n/a | n/a | 59.98 ms | 0 | measured |
| flutter-impeller | stress | scroll | ui-frame | 3.545/6.587 | - | 16.667/16.671 | - | 0.50 ms | n/a | n/a | 58.24 ms | 104 | measured |
| electron | small | open | ui-frame | 9.567/13.000 | - | - | - | n/a | n/a | n/a | 9.57 ms | 0 | measured |
| electron | small | input | ui-frame | 1.507/2.400 | - | 14.980/16.700 | 14.793/16.800 | n/a | n/a | n/a | 9.77 ms | 14 | measured |
| electron | small | scroll | ui-frame | 2.139/3.500 | - | 16.666/17.100 | - | n/a | n/a | n/a | 12.53 ms | 214 | measured |
| electron | medium | open | ui-frame | 9.700/13.100 | - | - | - | n/a | n/a | n/a | 9.70 ms | 0 | measured |
| electron | medium | input | ui-frame | 1.543/2.800 | - | 14.990/17.100 | 14.663/17.100 | n/a | n/a | n/a | 11.87 ms | 15 | measured |
| electron | medium | scroll | ui-frame | 2.186/3.500 | - | 16.662/17.100 | - | n/a | n/a | n/a | 10.37 ms | 220 | measured |
| electron | large | open | ui-frame | 8.967/9.000 | - | - | - | n/a | n/a | n/a | 8.97 ms | 0 | measured |
| electron | large | input | ui-frame | 1.493/2.400 | - | 15.000/17.300 | 14.760/17.300 | n/a | n/a | n/a | 11.10 ms | 16 | measured |
| electron | large | scroll | ui-frame | 2.211/3.700 | - | 16.663/17.200 | - | n/a | n/a | n/a | 9.77 ms | 210 | measured |
| electron | stress | open | ui-frame | 16.367/16.600 | - | - | - | n/a | n/a | n/a | 16.37 ms | 0 | measured |
| electron | stress | input | ui-frame | 1.313/1.600 | - | 14.990/16.800 | 14.103/16.800 | n/a | n/a | n/a | 16.27 ms | 15 | measured |
| electron | stress | scroll | ui-frame | 2.538/4.200 | - | 16.663/17.800 | - | n/a | n/a | n/a | 16.30 ms | 209 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.56/1.56/1.56 | 3.52/3.50/3.48 | 3.20/3.20/3.21 | 3.72/3.71/3.72 | 5.30/5.31/5.31 | 8.21/8.02/8.08 | n/a/n/a/n/a |
| MoUI Skia GPU | 1.59/1.58/1.59 | 3.49/3.47/3.49 | 6.19/6.21/6.20 | 7.76/7.75/7.74 | 8.36/8.37/8.37 | 9.29/9.27/9.34 | n/a/n/a/n/a |
| MoUI WGPU | 2.23/2.23/2.22 | 3.42/3.46/3.40 | 5.35/5.34/5.35 | 7.95/7.96/7.98 | 8.33/8.33/8.33 | 9.20/9.16/9.12 | n/a/n/a/n/a |
| MoUI 示例编辑器 Skia Raster | 0.92/1.19/3.84 | 1.08/1.24/5.16 | 2.14/2.16/2.19 | 2.43/2.44/2.48 | 3.18/3.66/8.09 | 3.62/3.94/8.95 | n/a/n/a/n/a |
| MoUI 示例编辑器 Skia GPU | 1.29/1.63/4.11 | 2.07/1.90/5.50 | 6.97/6.33/3.30 | 7.77/7.41/5.17 | 8.52/8.40/9.59 | 9.27/9.23/11.77 | n/a/n/a/n/a |
| MoUI 示例编辑器 WGPU | 1.25/1.54/4.26 | 1.50/1.65/5.63 | 6.88/6.42/2.97 | 7.35/7.22/4.65 | 8.30/8.33/9.69 | 9.05/9.17/9.87 | n/a/n/a/n/a |
| GPUI (md_mbt) | 17.55/17.52/17.57 | 20.15/20.17/20.19 | n/a/n/a/n/a | n/a/n/a/n/a | 20.67/21.03/25.05 | 23.90/24.15/27.97 | n/a/n/a/n/a |
| Flutter Skia | 3.47/3.46/3.42 | 4.83/6.41/6.30 | 0.82/0.45/0.44 | 1.19/0.67/0.60 | 16.67/16.62/16.62 | 16.67/16.67/16.67 | 59/107/107 |
| Flutter Impeller | 3.47/3.49/3.43 | 4.80/6.33/6.45 | 0.81/0.49/0.49 | 1.24/0.72/0.70 | 16.67/16.67/16.62 | 16.67/16.67/16.67 | 64/103/100 |
| Electron | 2.14/2.19/2.21 | 3.50/3.50/3.70 | n/a/n/a/n/a | n/a/n/a/n/a | 16.67/16.66/16.66 | 17.10/17.10/17.20 | 214/220/210 |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.57 | 3.52 | 3.21 | 3.70 | 5.33 | 8.08 | n/a |
| MoUI Skia GPU | 1.59 | 3.45 | 6.20 | 7.76 | 8.37 | 9.32 | n/a |
| MoUI WGPU | 2.11 | 3.46 | 5.50 | 8.01 | 8.33 | 9.20 | n/a |
| MoUI 示例编辑器 Skia Raster | 31.75 | 46.54 | 2.79 | 3.23 | 56.05 | 68.37 | n/a |
| MoUI 示例编辑器 Skia GPU | 33.25 | 48.60 | 3.23 | 5.13 | 59.98 | 71.17 | n/a |
| MoUI 示例编辑器 WGPU | 32.10 | 46.81 | 2.22 | 2.47 | 55.96 | 68.10 | n/a |
| GPUI (md_mbt) | 17.74 | 20.15 | n/a | n/a | 64.62 | 67.91 | n/a |
| Flutter Skia | 3.53 | 6.30 | 0.45 | 0.71 | 16.62 | 16.67 | 99 |
| Flutter Impeller | 3.55 | 6.59 | 0.50 | 0.73 | 16.67 | 16.67 | 104 |
| Electron | 2.54 | 4.20 | n/a | n/a | 16.66 | 17.80 | 209 |

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 3.64/3.69/3.80 | 3.79/3.82/3.95 | 0.48/0.48/0.48 | 0.50/0.50/0.50 | 3.04/3.08/3.06 | 3.21/3.21/3.20 |
| MoUI Skia GPU | 8.28/8.31/8.31 | 8.81/8.88/9.00 | 0.49/0.49/0.48 | 0.54/0.53/0.51 | 7.62/7.65/7.51 | 8.20/8.19/8.21 |
| MoUI WGPU | 8.23/8.23/8.19 | 8.96/9.37/9.82 | 0.52/0.51/0.52 | 0.61/0.59/0.60 | 7.55/7.55/7.34 | 8.27/8.75/8.98 |
| MoUI 示例编辑器 Skia Raster | 7.30/13.11/71.09 | 7.70/13.88/72.88 | 2.81/3.31/8.29 | 2.96/3.55/8.55 | 3.73/3.79/4.01 | 3.92/4.02/4.17 |
| MoUI 示例编辑器 Skia GPU | 9.54/18.04/73.92 | 12.79/25.36/83.67 | 2.94/4.37/8.61 | 3.11/5.26/9.55 | 5.80/6.53/4.68 | 8.67/9.90/8.87 |
| MoUI 示例编辑器 WGPU | 8.00/9.92/68.35 | 9.18/10.66/69.25 | 1.43/1.79/6.55 | 1.57/1.86/6.79 | 5.68/1.77/1.99 | 6.77/2.39/2.49 |
| GPUI (md_mbt) | 20.12/20.94/28.29 | 30.24/25.60/37.13 | 15.85/15.90/15.90 | 16.72/16.69/16.90 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 16.73/16.76/16.72 | 21.92/19.61/21.93 | 0.39/0.46/0.39 | 0.53/0.64/0.50 | 0.40/0.45/0.40 | 0.63/0.63/0.69 |
| Flutter Impeller | 16.74/16.73/16.72 | 20.68/21.46/18.83 | 0.40/0.41/0.40 | 0.56/0.56/0.51 | 0.41/0.42/0.41 | 0.67/0.68/0.66 |
| Electron | 14.79/14.66/14.76 | 16.80/17.10/17.30 | 1.51/1.54/1.49 | 2.40/2.80/2.40 | n/a/n/a/n/a | n/a/n/a/n/a |

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 5.76 | 6.70 | 0.52 | 0.57 | 3.16 | 3.38 |
| MoUI Skia GPU | 8.37 | 9.34 | 0.52 | 0.58 | 5.74 | 6.93 |
| MoUI WGPU | 8.23 | 9.00 | 0.51 | 0.56 | 5.56 | 6.46 |
| MoUI 示例编辑器 Skia Raster | 679.06 | 687.62 | 57.42 | 58.65 | 4.21 | 4.45 |
| MoUI 示例编辑器 Skia GPU | 719.60 | 936.81 | 61.43 | 95.72 | 4.69 | 7.88 |
| MoUI 示例编辑器 WGPU | 677.70 | 687.41 | 55.58 | 56.97 | 2.12 | 2.62 |
| GPUI (md_mbt) | 113.40 | 127.10 | 15.76 | 16.16 | n/a | n/a |
| Flutter Skia | 16.71 | 22.59 | 0.35 | 0.53 | 0.36 | 0.57 |
| Flutter Impeller | 16.73 | 23.85 | 0.37 | 0.53 | 0.38 | 0.57 |
| Electron | 14.10 | 16.80 | 1.31 | 1.60 | n/a | n/a |

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 48.72/47.74/51.42 | 50.16/48.06/53.23 | 42.90/41.87/43.66 | 44.29/42.15/45.53 | 4.75/4.61/4.89 | 4.80/4.65/5.01 | 0.05/0.27/2.32 | 0.05/0.27/2.33 |
| MoUI Skia GPU | 52.29/51.64/53.28 | 55.07/51.82/53.56 | 39.39/40.02/40.03 | 39.93/40.13/40.20 | 11.80/10.37/10.37 | 14.31/10.51/10.48 | 0.05/0.25/1.96 | 0.06/0.26/2.28 |
| MoUI WGPU | 47.88/48.85/49.19 | 48.13/50.24/49.89 | 37.43/38.20/36.81 | 37.77/39.55/37.26 | 9.32/9.35/9.48 | 9.39/9.42/9.70 | 0.05/0.26/2.28 | 0.05/0.26/2.32 |
| MoUI 示例编辑器 Skia Raster | 59.08/74.43/230.87 | 59.67/74.49/232.13 | 43.93/47.40/80.38 | 44.63/47.57/81.46 | 12.31/11.86/11.85 | 12.42/11.97/11.91 | 0.05/0.23/2.27 | 0.05/0.27/2.29 |
| MoUI 示例编辑器 Skia GPU | 72.64/109.52/320.10 | 76.76/117.97/454.93 | 43.72/54.50/85.43 | 45.08/56.55/93.76 | 25.98/38.34/29.59 | 28.74/44.73/33.48 | 0.05/0.25/2.38 | 0.06/0.29/2.48 |
| MoUI 示例编辑器 WGPU | 56.94/71.29/224.68 | 57.93/75.74/225.38 | 41.14/42.41/73.61 | 42.48/44.88/74.08 | 12.85/13.05/12.49 | 13.76/14.15/12.53 | 0.05/0.26/1.69 | 0.07/0.27/2.30 |
| GPUI (md_mbt) | 111.85/116.05/118.26 | 115.03/119.40/119.18 | 16.84/16.84/16.49 | 17.12/16.90/16.59 | n/a/n/a/n/a | n/a/n/a/n/a | 0.33/0.33/2.33 | 1.00/1.00/3.00 |
| Flutter Skia | 28.54/29.28/31.57 | 28.65/31.30/33.50 | 0.21/0.19/0.20 | 0.22/0.20/0.22 | 9.73/9.46/9.52 | 9.84/9.53/9.67 | 0.06/0.07/0.29 | 0.06/0.07/0.32 |
| Flutter Impeller | 28.54/28.31/30.41 | 28.84/28.44/30.53 | 0.23/0.21/0.20 | 0.26/0.21/0.21 | 8.09/7.78/7.70 | 8.33/7.86/7.73 | 0.06/0.08/0.28 | 0.07/0.09/0.29 |
| Electron | 9.57/9.70/8.97 | 13.00/13.10/9.00 | 9.57/9.70/8.97 | 13.00/13.10/9.00 | n/a/n/a/n/a | n/a/n/a/n/a | 2.78/2.64/2.74 | 2.95/2.66/2.77 |

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 65.39 | 65.83 | 42.34 | 42.82 | 4.46 | 4.46 | 20.47 | 23.22 |
| MoUI Skia GPU | 70.38 | 70.59 | 40.86 | 41.23 | 10.52 | 10.73 | 24.09 | 24.32 |
| MoUI WGPU | 66.36 | 67.69 | 38.02 | 39.15 | 9.34 | 9.58 | 20.31 | 23.19 |
| MoUI 示例编辑器 Skia Raster | 1834.79 | 1838.53 | 412.92 | 413.58 | 11.76 | 11.77 | 23.91 | 24.67 |
| MoUI 示例编辑器 Skia GPU | 1845.60 | 1856.82 | 415.19 | 417.01 | 23.50 | 24.15 | 15.30 | 15.78 |
| MoUI 示例编辑器 WGPU | 1831.81 | 1837.42 | 408.40 | 411.76 | 12.23 | 12.41 | 20.95 | 23.78 |
| GPUI (md_mbt) | 122.18 | 128.66 | 16.53 | 16.83 | n/a | n/a | 21.33 | 23.00 |
| Flutter Skia | 57.77 | 60.41 | 0.20 | 0.21 | 9.56 | 9.79 | 2.42 | 2.44 |
| Flutter Impeller | 60.59 | 61.06 | 0.23 | 0.26 | 7.93 | 8.16 | 2.40 | 2.43 |
| Electron | 16.37 | 16.60 | 16.37 | 16.60 | n/a | n/a | 4.26 | 4.37 |

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.56/1.56/1.56 | 3.52/3.50/3.48 | 3.20/3.20/3.21 | 3.72/3.71/3.72 | 5.30/5.31/5.31 | 8.21/8.02/8.08 | n/a/n/a/n/a |
| MoUI Skia GPU | 1.59/1.58/1.59 | 3.49/3.47/3.49 | 6.19/6.21/6.20 | 7.76/7.75/7.74 | 8.36/8.37/8.37 | 9.29/9.27/9.34 | n/a/n/a/n/a |
| MoUI WGPU | 2.23/2.23/2.22 | 3.42/3.46/3.40 | 5.35/5.34/5.35 | 7.95/7.96/7.98 | 8.33/8.33/8.33 | 9.20/9.16/9.12 | n/a/n/a/n/a |
| MoUI 示例编辑器 Skia Raster | 0.92/1.19/3.84 | 1.08/1.24/5.16 | 2.14/2.16/2.19 | 2.43/2.44/2.48 | 3.18/3.66/8.09 | 3.62/3.94/8.95 | n/a/n/a/n/a |
| MoUI 示例编辑器 Skia GPU | 1.29/1.63/4.11 | 2.07/1.90/5.50 | 6.97/6.33/3.30 | 7.77/7.41/5.17 | 8.52/8.40/9.59 | 9.27/9.23/11.77 | n/a/n/a/n/a |
| MoUI 示例编辑器 WGPU | 1.25/1.54/4.26 | 1.50/1.65/5.63 | 6.88/6.42/2.97 | 7.35/7.22/4.65 | 8.30/8.33/9.69 | 9.05/9.17/9.87 | n/a/n/a/n/a |
| GPUI (md_mbt) | 17.55/17.52/17.57 | 20.15/20.17/20.19 | n/a/n/a/n/a | n/a/n/a/n/a | 20.67/21.03/25.05 | 23.90/24.15/27.97 | n/a/n/a/n/a |
| Flutter Skia | 3.47/3.46/3.42 | 4.83/6.41/6.30 | 0.82/0.45/0.44 | 1.19/0.67/0.60 | 16.67/16.62/16.62 | 16.67/16.67/16.67 | 59/107/107 |
| Flutter Impeller | 3.47/3.49/3.43 | 4.80/6.33/6.45 | 0.81/0.49/0.49 | 1.24/0.72/0.70 | 16.67/16.67/16.62 | 16.67/16.67/16.67 | 64/103/100 |
| Electron | 2.14/2.19/2.21 | 3.50/3.50/3.70 | n/a/n/a/n/a | n/a/n/a/n/a | 16.67/16.66/16.66 | 17.10/17.10/17.20 | 214/220/210 |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.57 | 3.52 | 3.21 | 3.70 | 5.33 | 8.08 | n/a |
| MoUI Skia GPU | 1.59 | 3.45 | 6.20 | 7.76 | 8.37 | 9.32 | n/a |
| MoUI WGPU | 2.11 | 3.46 | 5.50 | 8.01 | 8.33 | 9.20 | n/a |
| MoUI 示例编辑器 Skia Raster | 31.75 | 46.54 | 2.79 | 3.23 | 56.05 | 68.37 | n/a |
| MoUI 示例编辑器 Skia GPU | 33.25 | 48.60 | 3.23 | 5.13 | 59.98 | 71.17 | n/a |
| MoUI 示例编辑器 WGPU | 32.10 | 46.81 | 2.22 | 2.47 | 55.96 | 68.10 | n/a |
| GPUI (md_mbt) | 17.74 | 20.15 | n/a | n/a | 64.62 | 67.91 | n/a |
| Flutter Skia | 3.53 | 6.30 | 0.45 | 0.71 | 16.62 | 16.67 | 99 |
| Flutter Impeller | 3.55 | 6.59 | 0.50 | 0.73 | 16.67 | 16.67 | 104 |
| Electron | 2.54 | 4.20 | n/a | n/a | 16.66 | 17.80 | 209 |

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoUI 示例编辑器 Skia Raster large 230.9 ms（max 232.1 ms）；MoUI 示例编辑器 Skia Raster stress 1834.8 ms（max 1838.5 ms）；MoUI 示例编辑器 Skia GPU medium 109.5 ms（max 118.0 ms）；MoUI 示例编辑器 Skia GPU large 320.1 ms（max 454.9 ms）；MoUI 示例编辑器 Skia GPU stress 1845.6 ms（max 1856.8 ms）；MoUI 示例编辑器 WGPU large 224.7 ms（max 225.4 ms）；MoUI 示例编辑器 WGPU stress 1831.8 ms（max 1837.4 ms）；GPUI (md_mbt) small 111.8 ms（max 115.0 ms）；GPUI (md_mbt) medium 116.1 ms（max 119.4 ms）；GPUI (md_mbt) large 118.3 ms（max 119.2 ms）；GPUI (md_mbt) stress 122.2 ms（max 128.7 ms）。
- P1 输入尾延迟：MoUI 示例编辑器 Skia Raster large P95 72.88 ms；MoUI 示例编辑器 Skia Raster stress P95 687.62 ms；MoUI 示例编辑器 Skia GPU medium P95 25.36 ms；MoUI 示例编辑器 Skia GPU large P95 83.67 ms；MoUI 示例编辑器 Skia GPU stress P95 936.81 ms；MoUI 示例编辑器 WGPU large P95 69.25 ms；MoUI 示例编辑器 WGPU stress P95 687.41 ms；GPUI (md_mbt) small P95 30.24 ms；GPUI (md_mbt) medium P95 25.60 ms；GPUI (md_mbt) large P95 37.13 ms；GPUI (md_mbt) stress P95 127.10 ms；Flutter Skia small P95 21.92 ms；Flutter Skia medium P95 19.61 ms；Flutter Skia large P95 21.93 ms；Flutter Skia stress P95 22.59 ms；Flutter Impeller small P95 20.68 ms；Flutter Impeller medium P95 21.46 ms；Flutter Impeller large P95 18.83 ms；Flutter Impeller stress P95 23.85 ms；Electron small P95 16.80 ms；Electron medium P95 17.10 ms；Electron large P95 17.30 ms；Electron stress P95 16.80 ms。
- 长帧（超预算）：MoUI 示例编辑器 Skia Raster: medium/input 1 次，max 16.92 ms, large/input 30 次，max 105.89 ms, large/scroll 3 次，max 41.32 ms, stress/input 30 次，max 1037.43 ms, stress/scroll 360 次，max 399.42 ms；MoUI 示例编辑器 Skia GPU: small/input 1 次，max 24.65 ms, small/scroll 2 次，max 36.47 ms, medium/input 17 次，max 28.27 ms, large/input 30 次，max 118.45 ms, large/scroll 8 次，max 65.73 ms, stress/input 30 次，max 1264.43 ms, stress/scroll 360 次，max 1014.97 ms；MoUI 示例编辑器 WGPU: large/input 30 次，max 104.90 ms, large/scroll 3 次，max 43.27 ms, stress/input 30 次，max 1039.79 ms, stress/scroll 360 次，max 394.86 ms；GPUI (md_mbt): small/input 30 次，max 31.07 ms, small/scroll 360 次，max 29.20 ms, medium/input 30 次，max 25.90 ms, medium/scroll 360 次，max 31.49 ms, large/input 30 次，max 38.10 ms, large/scroll 360 次，max 34.86 ms, stress/input 30 次，max 128.68 ms, stress/scroll 360 次，max 71.25 ms；Flutter Skia: large/scroll 1 次，max 33.33 ms；Electron: small/input 1 次，max 17.60 ms, small/scroll 50 次，max 17.70 ms, medium/input 2 次，max 17.10 ms, medium/scroll 37 次，max 18.60 ms, large/input 3 次，max 17.70 ms, large/scroll 49 次，max 18.60 ms, stress/input 2 次，max 16.80 ms, stress/scroll 60 次，max 18.70 ms。
- 丢帧（优先处理）：Flutter Skia: small/input 2 帧, small/scroll 59 帧, medium/input 5 帧, medium/scroll 107 帧, large/scroll 107 帧, stress/input 1 帧, stress/scroll 99 帧；Flutter Impeller: small/input 3 帧, small/scroll 64 帧, medium/scroll 103 帧, large/input 2 帧, large/scroll 100 帧, stress/scroll 104 帧；Electron: small/input 14 帧, small/scroll 214 帧, medium/input 15 帧, medium/scroll 220 帧, large/input 16 帧, large/scroll 210 帧, stress/input 15 帧, stress/scroll 209 帧。
- 解释：首帧异常优先检查窗口/渲染器初始化；输入尾延迟检查 action 到下一可见帧的调度与同步重建；长帧检查解析、布局、文本 shaping 和 GPU 提交；`n/a` 表示未埋点，不等于 0。
- 普通模式的长帧、帧间隔和输入延迟是各框架回调诊断，不能替代跨框架 compositor 排名；需要严格结论时运行 `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`。

## 采集口径

- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。
- `frame_work_ms` 统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏；对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `device_present_ms`：设备/上屏侧统一字段。MoUI raster 为 Skia CPU 光栅化+像素回读整体；MoUI GPU/wgpu 为提交后同步等待设备完成（headless host-surface 逐帧同步，真实应用的 vsync 流水线可重叠掉一部分，该值应视为上屏成本上界）；Flutter 为 `FrameTiming.rasterDuration`（光栅线程任务时间，含显示列表光栅化与 GPU 提交、不含设备完成等待）；GPUI 与 Electron 适配器侧无法观测，显示 `n/a`。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧；严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代；打开场景没有前一帧，所以不计算 interval/drop。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。

## 输入路径修复说明（2026-09-04，本表数据即修复后结果）

本节为本轮报告的手写附注；`bench/report.py` 整体重生成 `results/macos-arm64-ui.md` 后需重新补充。

**根因**：示例编辑器每次按键时，6 个输入守卫（自动链接粘贴/空格补全/回车补全、HTML 块粘贴、成对定界符、表格粘贴）在检查输入字符之前先查询“光标是否位于代码块内”，该查询触发全文 Markdown 重新解析（外加一次引用定义解析），即每按一键执行约 4 次 O(全文) 解析。

**修复**（均在 `vendor/MoUI`，纯行为保持改动）：
1. 编辑器 blocks 解析按源文本记忆化（`moui_richtext/rich_text_cache.mbt`，容量 2）；
2. 6 处输入守卫调整为先做廉价的输入字符检查、再查结构（守卫均为纯函数，结果不变）；
3. setext 标题判定改为先查下一行是否为 `===`/`---` 下划线行；
4. `parse_markdown`（`moui_richtext/markdown_model.mbt`）按文本记忆化（容量 1024）；
5. session 增量合成（stitched）结果发布进 blocks 缓存，下一键直接命中；
6. `markdown_editor_text_length`/`markdown_editor_substring` 记忆化并增加前缀快速路径；
7. 纯 ASCII 文本的 grapheme 边界 O(n) 快路径（`moui/core/unicode/grapheme_cluster.mbt`，与完整算法可证明逐位一致，附差分测试）。

**修复前后对比**（修复前基线归档于 `results/macos-arm64-ui-preinputfix-20260904.{json,md}`；stress=5MB）：

| 场景 | skia-raster 前→后 | skia-gpu 前→后 | wgpu 前→后 |
| --- | ---: | ---: | ---: |
| input 输入到可见 (stress) | 17538.7 → 679.9 ms | 17220.7 → 690.3 ms | 17123.7 → 677.3 ms |
| input 输入到可见 (large) | 1763.7 → 71.2 ms | 1693.1 → 72.5 ms | 1687.7 → 68.3 ms |
| input 输入到可见 (medium) | 181.3 → 13.0 ms | 176.3 → 19.4 ms | 171.7 → 9.9 ms |
| input 输入到可见 (small) | 25.8 → 7.2 ms | 24.3 → 8.4 ms | 20.5 → 8.0 ms |
| scroll 工作均值 (stress) | 421.9 → 31.7 ms | 421.1 → 34.4 ms | 421.2 → 32.0 ms |
| scroll 工作均值 (large) | 42.9 → 3.9 ms | 41.8 → 3.9 ms | 42.2 → 4.3 ms |
| open 工作均值 (stress) | 780.0 → 413.6 ms | 749.2 → 412.1 ms | 741.0 → 411.8 ms |

全矩阵 120 个对比单元无任何回归（>15% 恶化为零）；矩阵整轮时长因输入场景提速从约 2 小时缩短到约 10 分钟。回归测试：moui 3670/3670、moui_richtext 201/201、示例 app 423/423、grapheme ASCII 快路径差分测试通过。

**已知剩余项（设计级，本轮未改）**：`estimated_content_height` 在根布局时仍全块遍历并为每块生成 JSON 测量高度键（约占剩余按键耗时大头，约 0.4s/键，5MB 文档）；不可变 String 编辑存在整文档拷贝。彻底消除需将测量高度改为按 block id 索引或在增量应用处拼接几何，属对 vendored UI 库的高风险架构改动。
