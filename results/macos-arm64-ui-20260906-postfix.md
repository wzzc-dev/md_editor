# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-05T18:55:00Z`
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
| moui-skia-raster | small | open | ui-frame | 52.837/53.150 | - | - | - | 4.90 ms | 0.00 ms | 4.90 ms | 59.03 ms | n/a | measured |
| moui-skia-raster | small | input | ui-frame | 0.543/0.590 | - | 1.688/1.937 | 1.688/1.937 | 0.98 ms | 0.00 ms | 0.98 ms | 59.81 ms | n/a | measured |
| moui-skia-raster | small | scroll | ui-frame | 1.544/3.249 | - | 2.853/5.160 | - | 0.76 ms | 0.00 ms | 0.76 ms | 58.62 ms | n/a | measured |
| moui-skia-raster | medium | open | ui-frame | 52.568/53.373 | - | - | - | 5.03 ms | 0.00 ms | 5.03 ms | 59.12 ms | n/a | measured |
| moui-skia-raster | medium | input | ui-frame | 0.533/0.616 | - | 1.617/1.905 | 1.616/1.905 | 0.92 ms | 0.00 ms | 0.92 ms | 59.34 ms | n/a | measured |
| moui-skia-raster | medium | scroll | ui-frame | 1.550/3.280 | - | 2.863/5.143 | - | 0.76 ms | 0.00 ms | 0.76 ms | 59.41 ms | n/a | measured |
| moui-skia-raster | large | open | ui-frame | 52.959/53.780 | - | - | - | 4.97 ms | 0.00 ms | 4.97 ms | 61.08 ms | n/a | measured |
| moui-skia-raster | large | input | ui-frame | 0.573/0.669 | - | 2.020/2.401 | 2.020/2.401 | 1.07 ms | 0.00 ms | 1.07 ms | 61.31 ms | n/a | measured |
| moui-skia-raster | large | scroll | ui-frame | 1.560/3.253 | - | 2.906/5.184 | - | 0.79 ms | 0.00 ms | 0.79 ms | 60.90 ms | n/a | measured |
| moui-skia-raster | stress | open | ui-frame | 53.288/53.710 | - | - | - | 4.72 ms | 0.00 ms | 4.72 ms | 78.31 ms | n/a | measured |
| moui-skia-raster | stress | input | ui-frame | 0.710/0.843 | - | 4.971/7.221 | 4.971/7.220 | 1.03 ms | 0.00 ms | 1.03 ms | 78.78 ms | n/a | measured |
| moui-skia-raster | stress | scroll | ui-frame | 1.608/3.316 | - | 3.003/5.283 | - | 0.82 ms | 0.00 ms | 0.82 ms | 77.84 ms | n/a | measured |
| moui-skia-gpu | small | open | ui-frame | 50.130/51.845 | - | - | - | 16.11 ms | n/a | 0.00 ms | 67.58 ms | n/a | measured |
| moui-skia-gpu | small | input | ui-frame | 0.685/0.796 | - | 8.350/9.264 | 8.349/9.264 | 7.42 ms | n/a | 0.00 ms | 67.24 ms | n/a | measured |
| moui-skia-gpu | small | scroll | ui-frame | 1.662/3.277 | - | 8.334/9.354 | - | 6.03 ms | n/a | 0.00 ms | 63.83 ms | n/a | measured |
| moui-skia-gpu | medium | open | ui-frame | 46.200/47.734 | - | - | - | 12.48 ms | n/a | 0.00 ms | 60.20 ms | n/a | measured |
| moui-skia-gpu | medium | input | ui-frame | 0.622/0.759 | - | 8.385/9.634 | 8.384/9.634 | 7.55 ms | n/a | 0.00 ms | 60.69 ms | n/a | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 1.830/3.340 | - | 8.335/9.405 | - | 5.77 ms | n/a | 0.00 ms | 69.85 ms | n/a | measured |
| moui-skia-gpu | large | open | ui-frame | 49.827/50.112 | - | - | - | 14.43 ms | n/a | 0.00 ms | 67.38 ms | n/a | measured |
| moui-skia-gpu | large | input | ui-frame | 0.703/0.910 | - | 8.330/9.300 | 8.329/9.300 | 7.11 ms | n/a | 0.00 ms | 69.21 ms | n/a | measured |
| moui-skia-gpu | large | scroll | ui-frame | 2.338/5.881 | - | 8.803/10.151 | - | 5.47 ms | n/a | 0.00 ms | 69.61 ms | n/a | measured |
| moui-skia-gpu | stress | open | ui-frame | 51.628/53.663 | - | - | - | 15.19 ms | n/a | 0.00 ms | 86.74 ms | n/a | measured |
| moui-skia-gpu | stress | input | ui-frame | 0.810/1.181 | - | 8.943/10.043 | 8.942/10.043 | 4.45 ms | n/a | 0.00 ms | 86.77 ms | n/a | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 1.788/3.773 | - | 8.332/9.267 | - | 5.84 ms | n/a | 0.00 ms | 85.61 ms | n/a | measured |
| moui-wgpu | small | open | ui-frame | 56.694/56.761 | - | - | - | 11.15 ms | n/a | 0.00 ms | 69.17 ms | n/a | measured |
| moui-wgpu | small | input | ui-frame | 0.680/0.854 | - | 8.153/9.474 | 8.152/9.471 | 7.20 ms | n/a | 0.00 ms | 73.91 ms | n/a | measured |
| moui-wgpu | small | scroll | ui-frame | 1.697/3.262 | - | 8.331/9.553 | - | 6.00 ms | n/a | 0.00 ms | 61.78 ms | n/a | measured |
| moui-wgpu | medium | open | ui-frame | 50.887/51.529 | - | - | - | 10.53 ms | n/a | 0.00 ms | 62.78 ms | n/a | measured |
| moui-wgpu | medium | input | ui-frame | 0.643/0.824 | - | 8.124/9.432 | 8.124/9.431 | 7.21 ms | n/a | 0.00 ms | 62.93 ms | n/a | measured |
| moui-wgpu | medium | scroll | ui-frame | 1.792/3.428 | - | 8.326/9.462 | - | 5.85 ms | n/a | 0.00 ms | 75.08 ms | n/a | measured |
| moui-wgpu | large | open | ui-frame | 61.161/63.944 | - | - | - | 11.15 ms | n/a | 0.00 ms | 75.66 ms | n/a | measured |
| moui-wgpu | large | input | ui-frame | 0.691/0.803 | - | 8.134/9.486 | 8.134/9.484 | 6.88 ms | n/a | 0.00 ms | 74.65 ms | n/a | measured |
| moui-wgpu | large | scroll | ui-frame | 1.876/3.345 | - | 8.417/9.524 | - | 5.83 ms | n/a | 0.00 ms | 88.50 ms | n/a | measured |
| moui-wgpu | stress | open | ui-frame | 63.948/68.115 | - | - | - | 11.36 ms | n/a | 0.00 ms | 95.77 ms | n/a | measured |
| moui-wgpu | stress | input | ui-frame | 0.741/0.865 | - | 8.226/9.536 | 8.225/9.535 | 3.45 ms | n/a | 0.00 ms | 93.26 ms | n/a | measured |
| moui-wgpu | stress | scroll | ui-frame | 1.918/3.524 | - | 8.543/9.646 | - | 5.87 ms | n/a | 0.00 ms | 84.02 ms | n/a | measured |
| moui-md-skia-raster | small | open | ui-frame | 54.063/54.236 | - | - | - | 13.56 ms | 0.00 ms | 13.56 ms | 69.45 ms | n/a | measured |
| moui-md-skia-raster | small | input | ui-frame | 3.706/4.813 | - | 7.203/8.594 | 7.174/8.593 | 3.12 ms | 0.00 ms | 3.12 ms | 71.29 ms | n/a | measured |
| moui-md-skia-raster | small | scroll | ui-frame | 1.019/1.266 | - | 3.740/4.510 | - | 2.53 ms | 0.00 ms | 2.53 ms | 71.13 ms | n/a | measured |
| moui-md-skia-raster | medium | open | ui-frame | 54.122/55.217 | - | - | - | 13.66 ms | 0.00 ms | 13.66 ms | 71.23 ms | n/a | measured |
| moui-md-skia-raster | medium | input | ui-frame | 3.626/4.040 | - | 7.218/7.850 | 7.186/7.850 | 2.98 ms | 0.00 ms | 2.98 ms | 72.48 ms | n/a | measured |
| moui-md-skia-raster | medium | scroll | ui-frame | 1.007/1.238 | - | 3.722/4.415 | - | 2.51 ms | 0.00 ms | 2.51 ms | 72.53 ms | n/a | measured |
| moui-md-skia-raster | large | open | ui-frame | 54.713/55.105 | - | - | - | 12.65 ms | 0.00 ms | 12.65 ms | 84.93 ms | n/a | measured |
| moui-md-skia-raster | large | input | ui-frame | 6.586/23.120 | - | 15.904/52.360 | 15.831/51.657 | 4.38 ms | 0.00 ms | 4.38 ms | 106.03 ms | n/a | measured |
| moui-md-skia-raster | large | scroll | ui-frame | 1.007/1.249 | - | 3.810/4.768 | - | 2.42 ms | 0.00 ms | 2.42 ms | 84.28 ms | n/a | measured |
| moui-md-skia-raster | stress | open | ui-frame | 51.205/52.767 | - | - | - | 11.53 ms | 0.00 ms | 11.53 ms | 219.90 ms | n/a | measured |
| moui-md-skia-raster | stress | input | ui-frame | 4.191/7.115 | - | 44.626/125.989 | 44.337/125.988 | 3.28 ms | 0.00 ms | 3.28 ms | 330.90 ms | n/a | measured |
| moui-md-skia-raster | stress | scroll | ui-frame | 1.107/1.363 | - | 7.130/8.255 | - | 2.68 ms | 0.00 ms | 2.68 ms | 243.24 ms | n/a | measured |
| moui-md-skia-gpu | small | open | ui-frame | 51.547/51.737 | - | - | - | 38.51 ms | n/a | 0.00 ms | 92.00 ms | n/a | measured |
| moui-md-skia-gpu | small | input | ui-frame | 3.745/4.064 | - | 9.119/10.134 | 9.095/10.134 | 4.97 ms | n/a | 0.00 ms | 95.31 ms | n/a | measured |
| moui-md-skia-gpu | small | scroll | ui-frame | 1.247/2.171 | - | 8.349/9.162 | - | 6.82 ms | n/a | 0.00 ms | 96.75 ms | n/a | measured |
| moui-md-skia-gpu | medium | open | ui-frame | 52.609/55.738 | - | - | - | 39.37 ms | n/a | 0.00 ms | 95.41 ms | n/a | measured |
| moui-md-skia-gpu | medium | input | ui-frame | 3.746/4.188 | - | 9.761/10.585 | 9.731/10.584 | 5.33 ms | n/a | 0.00 ms | 96.50 ms | n/a | measured |
| moui-md-skia-gpu | medium | scroll | ui-frame | 1.360/2.783 | - | 8.614/9.807 | - | 6.90 ms | n/a | 0.00 ms | 98.65 ms | n/a | measured |
| moui-md-skia-gpu | large | open | ui-frame | 51.511/51.798 | - | - | - | 37.23 ms | n/a | 0.00 ms | 106.36 ms | n/a | measured |
| moui-md-skia-gpu | large | input | ui-frame | 3.806/4.031 | - | 9.814/10.465 | 9.757/10.465 | 2.76 ms | n/a | 0.00 ms | 113.50 ms | n/a | measured |
| moui-md-skia-gpu | large | scroll | ui-frame | 1.134/1.591 | - | 8.387/9.547 | - | 6.74 ms | n/a | 0.00 ms | 107.20 ms | n/a | measured |
| moui-md-skia-gpu | stress | open | ui-frame | 49.012/49.767 | - | - | - | 23.14 ms | n/a | 0.00 ms | 227.15 ms | n/a | measured |
| moui-md-skia-gpu | stress | input | ui-frame | 4.623/5.333 | - | 47.031/62.693 | 46.725/62.692 | 4.24 ms | n/a | 0.00 ms | 331.93 ms | n/a | measured |
| moui-md-skia-gpu | stress | scroll | ui-frame | 1.121/1.411 | - | 9.439/10.413 | - | 4.69 ms | n/a | 0.00 ms | 261.90 ms | n/a | measured |
| moui-md-wgpu | small | open | ui-frame | 60.779/61.313 | - | - | - | 16.40 ms | n/a | 0.00 ms | 79.31 ms | n/a | measured |
| moui-md-wgpu | small | input | ui-frame | 1.731/1.934 | - | 13.592/32.986 | 13.558/32.985 | 11.42 ms | n/a | 0.00 ms | 78.67 ms | n/a | measured |
| moui-md-wgpu | small | scroll | ui-frame | 1.336/1.672 | - | 8.349/10.161 | - | 6.74 ms | n/a | 0.00 ms | 60.60 ms | n/a | measured |
| moui-md-wgpu | medium | open | ui-frame | 60.268/63.766 | - | - | - | 16.02 ms | n/a | 0.00 ms | 80.38 ms | n/a | measured |
| moui-md-wgpu | medium | input | ui-frame | 1.763/2.214 | - | 12.056/32.096 | 12.018/32.096 | 9.59 ms | n/a | 0.00 ms | 72.84 ms | n/a | measured |
| moui-md-wgpu | medium | scroll | ui-frame | 1.378/1.718 | - | 12.360/27.303 | - | 10.65 ms | n/a | 0.00 ms | 78.28 ms | n/a | measured |
| moui-md-wgpu | large | open | ui-frame | 45.259/46.445 | - | - | - | 15.25 ms | n/a | 0.00 ms | 77.52 ms | n/a | measured |
| moui-md-wgpu | large | input | ui-frame | 1.533/1.664 | - | 8.582/10.648 | 8.524/10.120 | 3.96 ms | n/a | 0.00 ms | 80.29 ms | n/a | measured |
| moui-md-wgpu | large | scroll | ui-frame | 1.682/1.812 | - | 12.131/27.198 | - | 9.83 ms | n/a | 0.00 ms | 80.31 ms | n/a | measured |
| moui-md-wgpu | stress | open | ui-frame | 56.118/56.561 | - | - | - | 15.23 ms | n/a | 0.00 ms | 235.11 ms | n/a | measured |
| moui-md-wgpu | stress | input | ui-frame | 1.726/1.991 | - | 41.087/45.481 | 40.776/45.480 | 2.95 ms | n/a | 0.00 ms | 245.26 ms | n/a | measured |
| moui-md-wgpu | stress | scroll | ui-frame | 1.401/1.741 | - | 10.093/27.082 | - | 5.46 ms | n/a | 0.00 ms | 224.32 ms | n/a | measured |
| gpmark | small | open | ui-frame | 5.750/5.995 | - | - | - | n/a | n/a | n/a | 139.90 ms | n/a | measured |
| gpmark | small | input | ui-frame | 5.469/5.751 | 0.363/0.444 | 10.397/19.129 | 10.392/19.127 | n/a | n/a | n/a | 137.05 ms | n/a | measured |
| gpmark | small | scroll | ui-frame | 6.491/7.908 | 0.003/0.006 | 10.052/11.961 | - | n/a | n/a | n/a | 158.41 ms | n/a | measured |
| gpmark | medium | open | ui-frame | 5.833/6.109 | - | - | - | n/a | n/a | n/a | 143.83 ms | n/a | measured |
| gpmark | medium | input | ui-frame | 5.556/5.993 | 0.394/0.538 | 11.627/27.244 | 11.624/27.243 | n/a | n/a | n/a | 140.36 ms | n/a | measured |
| gpmark | medium | scroll | ui-frame | 6.481/7.886 | 0.003/0.006 | 10.114/11.978 | - | n/a | n/a | n/a | 146.37 ms | n/a | measured |
| gpmark | large | open | ui-frame | 6.600/7.908 | - | - | - | n/a | n/a | n/a | 146.72 ms | n/a | measured |
| gpmark | large | input | ui-frame | 5.559/5.931 | 0.815/1.138 | 11.479/28.857 | 11.476/28.848 | n/a | n/a | n/a | 143.77 ms | n/a | measured |
| gpmark | large | scroll | ui-frame | 6.525/7.970 | 0.003/0.006 | 10.144/11.941 | - | n/a | n/a | n/a | 173.22 ms | n/a | measured |
| gpmark | stress | open | ui-frame | 6.165/6.452 | - | - | - | n/a | n/a | n/a | 169.18 ms | n/a | measured |
| gpmark | stress | input | ui-frame | 5.668/6.055 | 5.850/6.688 | 14.473/24.891 | 14.469/24.890 | n/a | n/a | n/a | 155.63 ms | n/a | measured |
| gpmark | stress | scroll | ui-frame | 6.481/7.913 | 0.003/0.006 | 10.103/11.964 | - | n/a | n/a | n/a | 162.29 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 0.369/0.549 | - | - | - | 10.22 ms | n/a | n/a | 74.42 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 0.590/0.844 | - | 10.667/20.003 | 10.701/18.654 | 0.84 ms | n/a | n/a | 76.51 ms | 4 | measured |
| flutter-skia | small | scroll | ui-frame | 1.289/2.058 | - | 10.000/10.002 | - | 0.45 ms | n/a | n/a | 80.25 ms | 2 | measured |
| flutter-skia | medium | open | ui-frame | 0.387/0.457 | - | - | - | 9.69 ms | n/a | n/a | 78.75 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 0.617/0.963 | - | 10.334/20.001 | 10.766/17.476 | 0.82 ms | n/a | n/a | 75.72 ms | 3 | measured |
| flutter-skia | medium | scroll | ui-frame | 1.753/2.469 | - | 10.056/10.003 | - | 0.45 ms | n/a | n/a | 85.52 ms | 5 | measured |
| flutter-skia | large | open | ui-frame | 0.375/0.540 | - | - | - | 10.09 ms | n/a | n/a | 80.61 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 0.585/0.856 | - | 10.334/19.998 | 10.712/15.920 | 0.83 ms | n/a | n/a | 78.91 ms | 3 | measured |
| flutter-skia | large | scroll | ui-frame | 1.804/2.895 | - | 10.000/10.002 | - | 0.42 ms | n/a | n/a | 77.23 ms | 0 | measured |
| flutter-skia | stress | open | ui-frame | 0.332/0.352 | - | - | - | 9.44 ms | n/a | n/a | 114.80 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 0.585/0.819 | - | 10.334/19.994 | 10.295/18.770 | 0.80 ms | n/a | n/a | 115.30 ms | 2 | measured |
| flutter-skia | stress | scroll | ui-frame | 1.706/2.481 | - | 10.028/10.002 | - | 0.41 ms | n/a | n/a | 113.78 ms | 1 | measured |
| flutter-impeller | small | open | ui-frame | 0.374/0.419 | - | - | - | 8.69 ms | n/a | n/a | 92.92 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 0.655/0.964 | - | 10.667/20.002 | 11.060/18.113 | 0.91 ms | n/a | n/a | 70.11 ms | 5 | measured |
| flutter-impeller | small | scroll | ui-frame | 1.346/2.172 | - | 10.000/10.002 | - | 0.45 ms | n/a | n/a | 76.45 ms | 1 | measured |
| flutter-impeller | medium | open | ui-frame | 0.428/0.538 | - | - | - | 8.19 ms | n/a | n/a | 77.28 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 0.682/0.927 | - | 10.667/19.999 | 11.399/19.686 | 0.84 ms | n/a | n/a | 71.60 ms | 4 | measured |
| flutter-impeller | medium | scroll | ui-frame | 1.827/2.566 | - | 10.250/10.003 | - | 0.63 ms | n/a | n/a | 79.62 ms | 7 | measured |
| flutter-impeller | large | open | ui-frame | 0.428/0.471 | - | - | - | 8.36 ms | n/a | n/a | 78.81 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 0.641/0.938 | - | 10.000/19.998 | 11.061/16.386 | 0.94 ms | n/a | n/a | 78.38 ms | 3 | measured |
| flutter-impeller | large | scroll | ui-frame | 1.845/2.701 | - | 10.000/10.002 | - | 0.47 ms | n/a | n/a | 81.22 ms | 0 | measured |
| flutter-impeller | stress | open | ui-frame | 0.493/0.574 | - | - | - | 7.90 ms | n/a | n/a | 116.59 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 0.680/0.947 | - | 11.334/20.002 | 10.059/12.628 | 0.87 ms | n/a | n/a | 110.07 ms | 5 | measured |
| flutter-impeller | stress | scroll | ui-frame | 1.834/2.640 | - | 10.000/10.003 | - | 0.46 ms | n/a | n/a | 109.43 ms | 3 | measured |
| electron | small | open | ui-frame | 14.067/17.600 | - | - | - | n/a | n/a | n/a | 14.07 ms | 0 | measured |
| electron | small | input | ui-frame | 2.157/3.300 | - | 9.778/13.236 | 8.740/10.600 | n/a | n/a | n/a | 16.37 ms | 0 | measured |
| electron | small | scroll | ui-frame | 1.910/2.600 | - | 9.902/11.400 | - | n/a | n/a | n/a | 14.60 ms | 0 | measured |
| electron | medium | open | ui-frame | 8.967/9.100 | - | - | - | n/a | n/a | n/a | 8.97 ms | 0 | measured |
| electron | medium | input | ui-frame | 2.263/3.500 | - | 10.051/13.236 | 8.860/11.800 | n/a | n/a | n/a | 14.20 ms | 0 | measured |
| electron | medium | scroll | ui-frame | 1.988/2.600 | - | 9.964/10.800 | - | n/a | n/a | n/a | 11.53 ms | 0 | measured |
| electron | large | open | ui-frame | 10.833/11.300 | - | - | - | n/a | n/a | n/a | 10.83 ms | 0 | measured |
| electron | large | input | ui-frame | 2.053/2.800 | - | 9.004/12.000 | 8.663/12.000 | n/a | n/a | n/a | 11.67 ms | 0 | measured |
| electron | large | scroll | ui-frame | 1.983/2.600 | - | 9.973/10.800 | - | n/a | n/a | n/a | 11.23 ms | 1 | measured |
| electron | stress | open | ui-frame | 19.700/20.500 | - | - | - | n/a | n/a | n/a | 19.70 ms | 0 | measured |
| electron | stress | input | ui-frame | 2.000/2.700 | - | 9.330/11.300 | 8.913/10.300 | n/a | n/a | n/a | 19.87 ms | 1 | measured |
| electron | stress | scroll | ui-frame | 1.978/2.700 | - | 9.982/10.800 | - | n/a | n/a | n/a | 19.37 ms | 2 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.85/2.86/2.91 | 5.16/5.14/5.18 | n/a/n/a/n/a | 1.54/1.55/1.56 | 3.25/3.28/3.25 | 0.76/0.76/0.79 | 1.02/1.01/1.11 |
| MoUI Skia GPU | 8.33/8.33/8.80 | 9.35/9.41/10.15 | n/a/n/a/n/a | 1.66/1.83/2.34 | 3.28/3.34/5.88 | 6.03/5.77/5.47 | 7.94/7.94/7.98 |
| MoUI WGPU | 8.33/8.33/8.42 | 9.55/9.46/9.52 | n/a/n/a/n/a | 1.70/1.79/1.88 | 3.26/3.43/3.35 | 6.00/5.85/5.83 | 8.19/8.22/8.27 |
| MoMark Skia Raster | 3.74/3.72/3.81 | 4.51/4.41/4.77 | n/a/n/a/n/a | 1.02/1.01/1.01 | 1.27/1.24/1.25 | 2.53/2.51/2.42 | 3.12/3.02/3.13 |
| MoMark Skia GPU | 8.35/8.61/8.39 | 9.16/9.81/9.55 | n/a/n/a/n/a | 1.25/1.36/1.13 | 2.17/2.78/1.59 | 6.82/6.90/6.74 | 7.75/8.38/8.08 |
| MoMark WGPU | 8.35/12.36/12.13 | 10.16/27.30/27.20 | n/a/n/a/n/a | 1.34/1.38/1.68 | 1.67/1.72/1.81 | 6.74/10.65/9.83 | 8.48/25.75/25.50 |
| GpMark.mbt (GPUI) | 10.05/10.11/10.14 | 11.96/11.98/11.94 | n/a/n/a/n/a | 6.49/6.48/6.53 | 7.91/7.89/7.97 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 10.00/10.06/10.00 | 10.00/10.00/10.00 | 2/5/0 | 1.29/1.75/1.80 | 2.06/2.47/2.90 | 0.45/0.45/0.42 | 0.64/0.67/0.62 |
| Flutter Impeller | 10.00/10.25/10.00 | 10.00/10.00/10.00 | 1/7/0 | 1.35/1.83/1.85 | 2.17/2.57/2.70 | 0.45/0.63/0.47 | 0.69/0.63/0.84 |
| Electron | 9.90/9.96/9.97 | 11.40/10.80/10.80 | 0/0/1 | 1.91/1.99/1.98 | 2.60/2.60/2.60 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 3.00 | 5.28 | n/a | 1.61 | 3.32 | 0.82 | 1.20 |
| MoUI Skia GPU | 8.33 | 9.27 | n/a | 1.79 | 3.77 | 5.84 | 7.92 |
| MoUI WGPU | 8.54 | 9.65 | n/a | 1.92 | 3.52 | 5.87 | 8.17 |
| MoMark Skia Raster | 7.13 | 8.26 | n/a | 1.11 | 1.36 | 2.68 | 3.23 |
| MoMark Skia GPU | 9.44 | 10.41 | n/a | 1.12 | 1.41 | 4.69 | 5.42 |
| MoMark WGPU | 10.09 | 27.08 | n/a | 1.40 | 1.74 | 5.46 | 21.76 |
| GpMark.mbt (GPUI) | 10.10 | 11.96 | n/a | 6.48 | 7.91 | n/a | n/a |
| Flutter Skia | 10.03 | 10.00 | 1 | 1.71 | 2.48 | 0.41 | 0.60 |
| Flutter Impeller | 10.00 | 10.00 | 3 | 1.83 | 2.64 | 0.46 | 0.77 |
| Electron | 9.98 | 10.80 | 2 | 1.98 | 2.70 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.69/1.62/2.02 | 1.94/1.91/2.40 | 0.54/0.53/0.57 | 0.59/0.62/0.67 | 0.98/0.92/1.07 | 1.26/1.27/1.32 |
| MoUI Skia GPU | 8.35/8.38/8.33 | 9.26/9.63/9.30 | 0.68/0.62/0.70 | 0.80/0.76/0.91 | 7.42/7.55/7.11 | 8.33/8.85/8.33 |
| MoUI WGPU | 8.15/8.12/8.13 | 9.47/9.43/9.48 | 0.68/0.64/0.69 | 0.85/0.82/0.80 | 7.20/7.21/6.88 | 8.55/8.47/8.30 |
| MoMark Skia Raster | 7.17/7.19/15.83 | 8.59/7.85/51.66 | 3.71/3.63/6.59 | 4.81/4.04/23.12 | 3.12/2.98/4.38 | 3.85/3.43/14.42 |
| MoMark Skia GPU | 9.09/9.73/9.76 | 10.13/10.58/10.46 | 3.75/3.75/3.81 | 4.06/4.19/4.03 | 4.97/5.33/2.76 | 5.84/6.08/3.43 |
| MoMark WGPU | 13.56/12.02/8.52 | 32.99/32.10/10.12 | 1.73/1.76/1.53 | 1.93/2.21/1.66 | 11.42/9.59/3.96 | 30.97/30.00/5.57 |
| GpMark.mbt (GPUI) | 10.39/11.62/11.48 | 19.13/27.24/28.85 | 5.47/5.56/5.56 | 5.75/5.99/5.93 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 10.70/10.77/10.71 | 18.65/17.48/15.92 | 0.59/0.62/0.59 | 0.84/0.96/0.86 | 0.84/0.82/0.83 | 1.81/1.65/1.70 |
| Flutter Impeller | 11.06/11.40/11.06 | 18.11/19.69/16.39 | 0.65/0.68/0.64 | 0.96/0.93/0.94 | 0.91/0.84/0.94 | 2.33/1.66/1.96 |
| Electron | 8.74/8.86/8.66 | 10.60/11.80/12.00 | 2.16/2.26/2.05 | 3.30/3.50/2.80 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 4.97 | 7.22 | 0.71 | 0.84 | 1.03 | 1.35 |
| MoUI Skia GPU | 8.94 | 10.04 | 0.81 | 1.18 | 4.45 | 5.36 |
| MoUI WGPU | 8.22 | 9.53 | 0.74 | 0.86 | 3.45 | 5.56 |
| MoMark Skia Raster | 44.34 | 125.99 | 4.19 | 7.11 | 3.28 | 9.29 |
| MoMark Skia GPU | 46.73 | 62.69 | 4.62 | 5.33 | 4.24 | 6.72 |
| MoMark WGPU | 40.78 | 45.48 | 1.73 | 1.99 | 2.95 | 3.89 |
| GpMark.mbt (GPUI) | 14.47 | 24.89 | 5.67 | 6.06 | n/a | n/a |
| Flutter Skia | 10.30 | 18.77 | 0.58 | 0.82 | 0.80 | 1.69 |
| Flutter Impeller | 10.06 | 12.63 | 0.68 | 0.95 | 0.87 | 2.23 |
| Electron | 8.91 | 10.30 | 2.00 | 2.70 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 59.03/59.12/61.08 | 59.46/60.31/61.99 | 0.08/0.39/2.33 | 0.11/0.43/2.74 | 52.84/52.57/52.96 | 53.15/53.37/53.78 | 4.90/5.03/4.97 | 5.02/5.31/5.12 |
| MoUI Skia GPU | 67.58/60.20/67.38 | 68.31/61.10/67.67 | 0.13/0.32/2.78 | 0.18/0.36/2.84 | 50.13/46.20/49.83 | 51.85/47.73/50.11 | 16.11/12.48/14.43 | 17.13/14.44/14.48 |
| MoUI WGPU | 69.17/62.78/75.66 | 69.45/63.14/78.10 | 0.08/0.31/2.64 | 0.09/0.35/2.71 | 56.69/50.89/61.16 | 56.76/51.53/63.94 | 11.15/10.53/11.15 | 11.32/11.73/11.46 |
| MoMark Skia Raster | 69.45/71.23/84.93 | 69.64/71.96/85.34 | 0.07/0.32/2.43 | 0.07/0.36/2.81 | 54.06/54.12/54.71 | 54.24/55.22/55.10 | 13.56/13.66/12.65 | 13.73/14.12/12.87 |
| MoMark Skia GPU | 92.00/95.41/106.36 | 92.52/103.67/109.56 | 0.10/0.26/2.39 | 0.14/0.30/2.76 | 51.55/52.61/51.51 | 51.74/55.74/51.80 | 38.51/39.37/37.23 | 38.90/44.23/39.75 |
| MoMark WGPU | 79.31/80.38/77.52 | 79.90/84.36/78.63 | 0.08/0.47/2.58 | 0.12/0.58/2.68 | 60.78/60.27/45.26 | 61.31/63.77/46.45 | 16.40/16.02/15.25 | 16.93/17.38/16.79 |
| GpMark.mbt (GPUI) | 139.90/143.83/146.72 | 157.41/162.28/157.69 | 0.00/0.33/2.33 | 0.00/1.00/3.00 | 5.75/5.83/6.60 | 6.00/6.11/7.91 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 74.42/78.75/80.61 | 79.11/88.41/84.04 | 0.14/0.13/0.42 | 0.18/0.16/0.50 | 0.37/0.39/0.38 | 0.55/0.46/0.54 | 10.22/9.69/10.09 | 11.46/10.73/10.40 |
| Flutter Impeller | 92.92/77.28/78.81 | 115.39/85.86/88.49 | 0.12/0.14/0.46 | 0.16/0.17/0.52 | 0.37/0.43/0.43 | 0.42/0.54/0.47 | 8.69/8.19/8.36 | 10.88/8.72/9.50 |
| Electron | 14.07/8.97/10.83 | 17.60/9.10/11.30 | 6.02/6.96/10.43 | 10.61/12.99/23.36 | 14.07/8.97/10.83 | 17.60/9.10/11.30 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 78.31 | 78.94 | 27.48 | 28.57 | 53.29 | 53.71 | 4.72 | 4.86 |
| MoUI Skia GPU | 86.74 | 87.59 | 26.91 | 28.25 | 51.63 | 53.66 | 15.19 | 16.14 |
| MoUI WGPU | 95.77 | 99.79 | 25.82 | 28.80 | 63.95 | 68.11 | 11.36 | 11.52 |
| MoMark Skia Raster | 219.90 | 221.92 | 21.71 | 26.08 | 51.21 | 52.77 | 11.53 | 12.22 |
| MoMark Skia GPU | 227.15 | 229.72 | 20.36 | 22.71 | 49.01 | 49.77 | 23.14 | 24.78 |
| MoMark WGPU | 235.11 | 235.63 | 25.83 | 27.44 | 56.12 | 56.56 | 15.23 | 15.39 |
| GpMark.mbt (GPUI) | 169.18 | 170.20 | 26.00 | 30.00 | 6.17 | 6.45 | n/a | n/a |
| Flutter Skia | 114.80 | 116.86 | 3.14 | 3.44 | 0.33 | 0.35 | 9.44 | 10.19 |
| Flutter Impeller | 116.59 | 129.29 | 3.20 | 3.91 | 0.49 | 0.57 | 7.90 | 8.25 |
| Electron | 19.70 | 20.50 | 11.42 | 14.84 | 19.70 | 20.50 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.85/2.86/2.91 | 5.16/5.14/5.18 | n/a/n/a/n/a | 1.54/1.55/1.56 | 3.25/3.28/3.25 | 0.76/0.76/0.79 | 1.02/1.01/1.11 |
| MoUI Skia GPU | 8.33/8.33/8.80 | 9.35/9.41/10.15 | n/a/n/a/n/a | 1.66/1.83/2.34 | 3.28/3.34/5.88 | 6.03/5.77/5.47 | 7.94/7.94/7.98 |
| MoUI WGPU | 8.33/8.33/8.42 | 9.55/9.46/9.52 | n/a/n/a/n/a | 1.70/1.79/1.88 | 3.26/3.43/3.35 | 6.00/5.85/5.83 | 8.19/8.22/8.27 |
| MoMark Skia Raster | 3.74/3.72/3.81 | 4.51/4.41/4.77 | n/a/n/a/n/a | 1.02/1.01/1.01 | 1.27/1.24/1.25 | 2.53/2.51/2.42 | 3.12/3.02/3.13 |
| MoMark Skia GPU | 8.35/8.61/8.39 | 9.16/9.81/9.55 | n/a/n/a/n/a | 1.25/1.36/1.13 | 2.17/2.78/1.59 | 6.82/6.90/6.74 | 7.75/8.38/8.08 |
| MoMark WGPU | 8.35/12.36/12.13 | 10.16/27.30/27.20 | n/a/n/a/n/a | 1.34/1.38/1.68 | 1.67/1.72/1.81 | 6.74/10.65/9.83 | 8.48/25.75/25.50 |
| GpMark.mbt (GPUI) | 10.05/10.11/10.14 | 11.96/11.98/11.94 | n/a/n/a/n/a | 6.49/6.48/6.53 | 7.91/7.89/7.97 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 10.00/10.06/10.00 | 10.00/10.00/10.00 | 2/5/0 | 1.29/1.75/1.80 | 2.06/2.47/2.90 | 0.45/0.45/0.42 | 0.64/0.67/0.62 |
| Flutter Impeller | 10.00/10.25/10.00 | 10.00/10.00/10.00 | 1/7/0 | 1.35/1.83/1.85 | 2.17/2.57/2.70 | 0.45/0.63/0.47 | 0.69/0.63/0.84 |
| Electron | 9.90/9.96/9.97 | 11.40/10.80/10.80 | 0/0/1 | 1.91/1.99/1.98 | 2.60/2.60/2.60 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 3.00 | 5.28 | n/a | 1.61 | 3.32 | 0.82 | 1.20 |
| MoUI Skia GPU | 8.33 | 9.27 | n/a | 1.79 | 3.77 | 5.84 | 7.92 |
| MoUI WGPU | 8.54 | 9.65 | n/a | 1.92 | 3.52 | 5.87 | 8.17 |
| MoMark Skia Raster | 7.13 | 8.26 | n/a | 1.11 | 1.36 | 2.68 | 3.23 |
| MoMark Skia GPU | 9.44 | 10.41 | n/a | 1.12 | 1.41 | 4.69 | 5.42 |
| MoMark WGPU | 10.09 | 27.08 | n/a | 1.40 | 1.74 | 5.46 | 21.76 |
| GpMark.mbt (GPUI) | 10.10 | 11.96 | n/a | 6.48 | 7.91 | n/a | n/a |
| Flutter Skia | 10.03 | 10.00 | 1 | 1.71 | 2.48 | 0.41 | 0.60 |
| Flutter Impeller | 10.00 | 10.00 | 3 | 1.83 | 2.64 | 0.46 | 0.77 |
| Electron | 9.98 | 10.80 | 2 | 1.98 | 2.70 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoMark Skia Raster stress 219.9 ms（max 221.9 ms）；MoMark Skia GPU medium 95.4 ms（max 103.7 ms）；MoMark Skia GPU large 106.4 ms（max 109.6 ms）；MoMark Skia GPU stress 227.1 ms（max 229.7 ms）；MoMark WGPU stress 235.1 ms（max 235.6 ms）；GpMark.mbt (GPUI) small 139.9 ms（max 157.4 ms）；GpMark.mbt (GPUI) medium 143.8 ms（max 162.3 ms）；GpMark.mbt (GPUI) large 146.7 ms（max 157.7 ms）；GpMark.mbt (GPUI) stress 169.2 ms（max 170.2 ms）；Flutter Skia stress 114.8 ms（max 116.9 ms）；Flutter Impeller small 92.9 ms（max 115.4 ms）；Flutter Impeller stress 116.6 ms（max 129.3 ms）。
- P1 输入尾延迟：MoMark Skia Raster large P95 51.66 ms；MoMark Skia Raster stress P95 125.99 ms；MoMark Skia GPU stress P95 62.69 ms；MoMark WGPU small P95 32.99 ms；MoMark WGPU medium P95 32.10 ms；MoMark WGPU stress P95 45.48 ms；GpMark.mbt (GPUI) small P95 19.13 ms；GpMark.mbt (GPUI) medium P95 27.24 ms；GpMark.mbt (GPUI) large P95 28.85 ms；GpMark.mbt (GPUI) stress P95 24.89 ms；Flutter Skia small P95 18.65 ms；Flutter Skia medium P95 17.48 ms；Flutter Skia stress P95 18.77 ms；Flutter Impeller small P95 18.11 ms；Flutter Impeller medium P95 19.69 ms。
- 长帧（超预算）：MoUI Skia GPU: large/scroll 9 次，max 24.57 ms；MoUI WGPU: large/scroll 2 次，max 26.24 ms, stress/scroll 3 次，max 32.76 ms；MoMark Skia Raster: large/input 5 次，max 52.82 ms, stress/input 30 次，max 145.15 ms；MoMark Skia GPU: medium/scroll 5 次，max 21.86 ms, stress/input 30 次，max 77.06 ms；MoMark WGPU: small/input 8 次，max 35.37 ms, small/scroll 1 次，max 26.21 ms, medium/input 5 次，max 34.18 ms, medium/scroll 85 次，max 31.77 ms, large/scroll 71 次，max 72.97 ms, stress/input 30 次，max 46.69 ms, stress/scroll 25 次，max 29.11 ms；GpMark.mbt (GPUI): small/input 2 次，max 21.83 ms, small/scroll 3 次，max 21.25 ms, medium/input 3 次，max 39.35 ms, medium/scroll 3 次，max 34.87 ms, large/input 3 次，max 33.03 ms, large/scroll 3 次，max 38.92 ms, stress/input 4 次，max 35.15 ms, stress/scroll 3 次，max 37.92 ms；Flutter Skia: small/input 4 次，max 20.00 ms, small/scroll 2 次，max 20.00 ms, medium/input 3 次，max 20.00 ms, medium/scroll 5 次，max 20.00 ms, large/input 3 次，max 20.00 ms, stress/input 2 次，max 20.00 ms, stress/scroll 1 次，max 20.01 ms；Flutter Impeller: small/input 5 次，max 20.00 ms, small/scroll 1 次，max 20.00 ms, medium/input 4 次，max 20.00 ms, medium/scroll 5 次，max 50.00 ms, large/input 3 次，max 20.00 ms, stress/input 5 次，max 20.00 ms, stress/scroll 3 次，max 20.00 ms；Electron: large/scroll 1 次，max 20.10 ms, stress/scroll 2 次，max 20.00 ms。
- 丢帧（优先处理）：Flutter Skia: small/input 4 帧, small/scroll 2 帧, medium/input 3 帧, medium/scroll 5 帧, large/input 3 帧, stress/input 2 帧, stress/scroll 1 帧；Flutter Impeller: small/input 5 帧, small/scroll 1 帧, medium/input 4 帧, medium/scroll 7 帧, large/input 3 帧, stress/input 5 帧, stress/scroll 3 帧；Electron: large/scroll 1 帧, stress/input 1 帧, stress/scroll 2 帧。
- 解释：首帧异常优先检查窗口/渲染器初始化；输入尾延迟检查 action 到下一可见帧的调度与同步重建；长帧检查解析、布局、文本 shaping 和 GPU 提交；`n/a` 表示未埋点，不等于 0。
- 普通模式的长帧、帧间隔和输入延迟是各框架回调诊断，不能替代跨框架 compositor 排名；需要严格结论时运行 `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`。

## 采集口径

- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。
- `frame_work_ms` 统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏；对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `device_present_ms`：设备/上屏侧统一字段。MoUI raster 为 Skia CPU 光栅化+像素回读整体；MoUI GPU/wgpu 为提交后同步等待设备完成（headless host-surface 逐帧同步，真实应用的 vsync 流水线可重叠掉一部分，该值应视为上屏成本上界）；Flutter 为 `FrameTiming.rasterDuration`（光栅线程任务时间，含显示列表光栅化与 GPU 提交、不含设备完成等待）；GPUI 与 Electron 适配器侧无法观测，显示 `n/a`。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧；严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代；打开场景没有前一帧，所以不计算 interval/drop。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。
