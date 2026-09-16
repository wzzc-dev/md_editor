# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-16T14:15:39Z`
- 数据状态：`360 measured`，`0 skipped/error`；原始样本保留在 JSON。
- Host：`Windows-11-10.0.26200-SP0` / `AMD64` / `15.89 GiB`；GPU：`OrayIddDriver Device`
- OS：`11`；CPU：`AMD64 Family 25 Model 33 Stepping 2, AuthenticAMD`；toolchains：`python=3.12.10, moon=moon 0.1.20260824 (dae026a 2026-08-24), rustc=rustc 1.92.0 (ded5c06cf 2025-12-08), cargo=cargo 1.92.0 (344c4567c 2025-10-21), node=v22.20.0`
- 统一配置：`1280x800 @ 60 Hz`；font `system-ui 16px`；line-height `1.55`；overscan `3`；fixed row `66px`；GPU backend `Direct3D`
- Fixture：`small=5KB/100 blocks`，`medium=50KB/1,000 blocks`，`large=500KB/10,000 blocks`，`stress=5MB/100,000 blocks`。
- 本次执行集合：`small, medium, large, stress`；未执行集合在矩阵中显示 `n/a`，不参与比较。
- 汇总口径：mean/P95 合并原始样本；每格 repetition `3`、process warm-up `1`；drop 为各 repetition dropped_display_frames 之和。
- 公平性口径：所有 ui-frame 记录使用相同 fixture、viewport、动作数、warm-up 和重复次数。`工作`（frame_work）统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏：MoUI 为 build+layout+paint+draw，Flutter 为 UI 线程 buildDuration，GPUI 为 request_layout→prepaint→paint，Electron 为 JS 可见的 DOM 更新+layout。设备光栅化与上屏统一单列为 `设备侧`（device_present）：native-window 模式下 MoUI 在真实 Win32 窗口上屏，适配器侧不单独计时设备光栅化，显示 `n/a`，Flutter 为光栅线程 rasterDuration（不含设备完成等待），GPUI 与 Electron 无法在适配器侧观测显示链路，显示 `n/a`。MoUI ui-frame 运行在真实 Win32 窗口（`native-window`），其帧间隔/输入延迟是动作到原生帧观察的 wall-clock 采样（观察节奏约 12 ms），与 GPUI 的 `on_next_frame`、Flutter 的 vsyncStart、Electron 的 rAF 同属框架回调诊断；GPUI 的 action dispatch 另列为诊断字段。不同框架的显示时间戳由各自平台 API 提供，帧间隔覆盖完整链路，报告不做跨时钟的综合排名。`n/a` 表示没有采集，绝不等同于 0。下方各对比表把同平台跨框架可比列（帧间隔/可见延迟/首次可交互/丢帧数等）排在前面，框架内部诊断列（`工作`/`设备侧`）排在后面并标注 `†`。

- `moui-md-*` 行来自 `momark`（MoMark，原 `vendor/MoUI/examples/markdown_editor`）官方示例应用：fixture 通过应用自身的 `OpenRecentDocument` 服务路径打开，渲染经过示例自己的虚拟滚动与富文本缓存实现，不套用简化基准应用的 `fixed row 66px` 统一行高；viewport、fixture、动作数、warm-up 与重复次数与其他行完全一致。严格模式（`UI_BENCHMARK_SYSTEM_TRACE=1`）目前不为 `moui-md-*` 行采集系统 present，这些行会显示 error。

<details><summary>原始 ui-frame 汇总（可审计）</summary>

| 实现 | 测试集合 | 场景 | 范围 | 工作均值/P95 | 仅分发均值/P95 | 帧间隔均值/P95 | 输入到可见均值/P95 | 设备侧均值 | 离屏均值 | 回读均值 | 首次可交互 | 丢帧数 | 状态 |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| moui-skia-raster | small | open | ui-frame | 9.883/10.667 | - | - | - | n/a | n/a | n/a | 55.75 ms | 0 | measured |
| moui-skia-raster | small | input | ui-frame | 2.219/3.175 | - | 7.074/8.824 | 6.966/8.727 | n/a | n/a | n/a | 56.14 ms | 0 | measured |
| moui-skia-raster | small | scroll | ui-frame | 2.279/3.090 | - | 6.991/8.641 | - | n/a | n/a | n/a | 56.66 ms | 0 | measured |
| moui-skia-raster | medium | open | ui-frame | 9.901/11.157 | - | - | - | n/a | n/a | n/a | 61.16 ms | 0 | measured |
| moui-skia-raster | medium | input | ui-frame | 2.104/3.092 | - | 7.382/8.894 | 7.260/8.702 | n/a | n/a | n/a | 62.64 ms | 0 | measured |
| moui-skia-raster | medium | scroll | ui-frame | 2.314/3.157 | - | 7.388/8.822 | - | n/a | n/a | n/a | 60.99 ms | 0 | measured |
| moui-skia-raster | large | open | ui-frame | 10.032/10.419 | - | - | - | n/a | n/a | n/a | 96.36 ms | 0 | measured |
| moui-skia-raster | large | input | ui-frame | 2.129/3.037 | - | 7.453/9.289 | 7.349/9.175 | n/a | n/a | n/a | 97.94 ms | 0 | measured |
| moui-skia-raster | large | scroll | ui-frame | 2.294/3.189 | - | 7.383/8.859 | - | n/a | n/a | n/a | 99.05 ms | 0 | measured |
| moui-skia-raster | stress | open | ui-frame | 9.961/10.799 | - | - | - | n/a | n/a | n/a | 455.13 ms | 0 | measured |
| moui-skia-raster | stress | input | ui-frame | 2.113/3.039 | - | 7.768/9.304 | 7.655/9.303 | n/a | n/a | n/a | 467.87 ms | 0 | measured |
| moui-skia-raster | stress | scroll | ui-frame | 2.353/3.265 | - | 7.492/9.089 | - | n/a | n/a | n/a | 462.16 ms | 1 | measured |
| moui-skia-gpu | small | open | ui-frame | 9.746/11.051 | - | - | - | n/a | n/a | n/a | 401.48 ms | 0 | measured |
| moui-skia-gpu | small | input | ui-frame | 1.929/2.440 | - | 6.584/7.272 | 6.456/7.125 | n/a | n/a | n/a | 414.20 ms | 0 | measured |
| moui-skia-gpu | small | scroll | ui-frame | 2.154/2.799 | - | 6.928/7.221 | - | n/a | n/a | n/a | 405.04 ms | 0 | measured |
| moui-skia-gpu | medium | open | ui-frame | 8.911/9.231 | - | - | - | n/a | n/a | n/a | 417.37 ms | 0 | measured |
| moui-skia-gpu | medium | input | ui-frame | 1.957/2.463 | - | 6.756/8.912 | 6.639/8.818 | n/a | n/a | n/a | 418.25 ms | 0 | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 2.193/2.710 | - | 6.927/7.346 | - | n/a | n/a | n/a | 396.81 ms | 0 | measured |
| moui-skia-gpu | large | open | ui-frame | 10.747/13.481 | - | - | - | n/a | n/a | n/a | 431.97 ms | 0 | measured |
| moui-skia-gpu | large | input | ui-frame | 1.859/2.075 | - | 6.151/7.281 | 6.036/7.129 | n/a | n/a | n/a | 407.62 ms | 0 | measured |
| moui-skia-gpu | large | scroll | ui-frame | 2.195/2.706 | - | 6.962/7.231 | - | n/a | n/a | n/a | 395.92 ms | 0 | measured |
| moui-skia-gpu | stress | open | ui-frame | 10.150/11.422 | - | - | - | n/a | n/a | n/a | 776.63 ms | 0 | measured |
| moui-skia-gpu | stress | input | ui-frame | 1.950/2.234 | - | 6.637/9.023 | 6.512/8.928 | n/a | n/a | n/a | 722.40 ms | 0 | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 2.183/2.683 | - | 6.898/7.203 | - | n/a | n/a | n/a | 776.25 ms | 0 | measured |
| moui-wgpu | small | open | ui-frame | 51.246/54.485 | - | - | - | n/a | n/a | n/a | 1271.74 ms | 0 | measured |
| moui-wgpu | small | input | ui-frame | 5.773/7.234 | - | 12.092/15.149 | 11.975/14.997 | n/a | n/a | n/a | 1261.55 ms | 0 | measured |
| moui-wgpu | small | scroll | ui-frame | 2.467/3.294 | - | 7.113/8.406 | - | n/a | n/a | n/a | 1239.19 ms | 0 | measured |
| moui-wgpu | medium | open | ui-frame | 53.500/55.976 | - | - | - | n/a | n/a | n/a | 1293.56 ms | 0 | measured |
| moui-wgpu | medium | input | ui-frame | 6.399/10.744 | - | 13.133/18.905 | 13.002/18.785 | n/a | n/a | n/a | 1285.48 ms | 5 | measured |
| moui-wgpu | medium | scroll | ui-frame | 2.451/3.170 | - | 7.126/8.456 | - | n/a | n/a | n/a | 1250.63 ms | 0 | measured |
| moui-wgpu | large | open | ui-frame | 47.891/49.674 | - | - | - | n/a | n/a | n/a | 1279.62 ms | 0 | measured |
| moui-wgpu | large | input | ui-frame | 5.756/8.505 | - | 11.952/16.320 | 11.843/16.218 | n/a | n/a | n/a | 1278.67 ms | 0 | measured |
| moui-wgpu | large | scroll | ui-frame | 2.512/3.288 | - | 7.158/8.629 | - | n/a | n/a | n/a | 1303.81 ms | 0 | measured |
| moui-wgpu | stress | open | ui-frame | 50.314/53.092 | - | - | - | n/a | n/a | n/a | 1644.53 ms | 0 | measured |
| moui-wgpu | stress | input | ui-frame | 5.407/6.514 | - | 11.311/13.317 | 11.195/13.119 | n/a | n/a | n/a | 1630.04 ms | 0 | measured |
| moui-wgpu | stress | scroll | ui-frame | 2.509/3.364 | - | 7.171/8.921 | - | n/a | n/a | n/a | 1608.30 ms | 0 | measured |
| moui-md-skia-raster | small | open | ui-frame | 12.187/12.465 | - | - | - | n/a | n/a | n/a | 66.15 ms | 0 | measured |
| moui-md-skia-raster | small | input | ui-frame | 3.661/4.379 | - | 15.135/17.767 | 15.040/17.767 | n/a | n/a | n/a | 68.17 ms | 3 | measured |
| moui-md-skia-raster | small | scroll | ui-frame | 4.837/6.418 | - | 15.459/18.541 | - | n/a | n/a | n/a | 68.18 ms | 71 | measured |
| moui-md-skia-raster | medium | open | ui-frame | 11.946/13.338 | - | - | - | n/a | n/a | n/a | 72.21 ms | 0 | measured |
| moui-md-skia-raster | medium | input | ui-frame | 3.639/4.534 | - | 15.301/16.477 | 15.208/16.386 | n/a | n/a | n/a | 70.76 ms | 1 | measured |
| moui-md-skia-raster | medium | scroll | ui-frame | 4.758/6.410 | - | 15.360/18.083 | - | n/a | n/a | n/a | 71.25 ms | 66 | measured |
| moui-md-skia-raster | large | open | ui-frame | 12.218/13.364 | - | - | - | n/a | n/a | n/a | 116.34 ms | 0 | measured |
| moui-md-skia-raster | large | input | ui-frame | 4.325/6.132 | - | 17.403/21.138 | 17.300/21.047 | n/a | n/a | n/a | 116.10 ms | 17 | measured |
| moui-md-skia-raster | large | scroll | ui-frame | 4.783/6.232 | - | 15.563/18.415 | - | n/a | n/a | n/a | 128.87 ms | 82 | measured |
| moui-md-skia-raster | stress | open | ui-frame | 11.674/11.961 | - | - | - | n/a | n/a | n/a | 583.39 ms | 0 | measured |
| moui-md-skia-raster | stress | input | ui-frame | 8.151/10.710 | - | 33.080/37.803 | 32.986/37.693 | n/a | n/a | n/a | 574.76 ms | 38 | measured |
| moui-md-skia-raster | stress | scroll | ui-frame | 4.745/6.134 | - | 15.553/18.600 | - | n/a | n/a | n/a | 570.49 ms | 72 | measured |
| moui-md-skia-gpu | small | open | ui-frame | 10.795/11.029 | - | - | - | n/a | n/a | n/a | 369.37 ms | 0 | measured |
| moui-md-skia-gpu | small | input | ui-frame | 3.697/5.688 | - | 8.673/14.441 | 8.586/14.439 | n/a | n/a | n/a | 372.11 ms | 1 | measured |
| moui-md-skia-gpu | small | scroll | ui-frame | 4.787/6.308 | - | 7.381/9.646 | - | n/a | n/a | n/a | 373.95 ms | 0 | measured |
| moui-md-skia-gpu | medium | open | ui-frame | 11.275/11.648 | - | - | - | n/a | n/a | n/a | 379.12 ms | 0 | measured |
| moui-md-skia-gpu | medium | input | ui-frame | 3.656/4.367 | - | 8.692/14.211 | 8.611/14.210 | n/a | n/a | n/a | 375.27 ms | 0 | measured |
| moui-md-skia-gpu | medium | scroll | ui-frame | 4.743/6.205 | - | 7.364/9.246 | - | n/a | n/a | n/a | 374.50 ms | 0 | measured |
| moui-md-skia-gpu | large | open | ui-frame | 11.270/11.528 | - | - | - | n/a | n/a | n/a | 430.37 ms | 0 | measured |
| moui-md-skia-gpu | large | input | ui-frame | 4.018/4.810 | - | 9.920/17.816 | 9.837/17.815 | n/a | n/a | n/a | 433.48 ms | 3 | measured |
| moui-md-skia-gpu | large | scroll | ui-frame | 4.728/6.213 | - | 7.284/9.531 | - | n/a | n/a | n/a | 428.76 ms | 0 | measured |
| moui-md-skia-gpu | stress | open | ui-frame | 11.858/12.627 | - | - | - | n/a | n/a | n/a | 939.83 ms | 0 | measured |
| moui-md-skia-gpu | stress | input | ui-frame | 8.062/9.448 | - | 25.484/27.914 | 25.399/27.810 | n/a | n/a | n/a | 887.80 ms | 30 | measured |
| moui-md-skia-gpu | stress | scroll | ui-frame | 4.690/6.123 | - | 7.316/9.219 | - | n/a | n/a | n/a | 880.65 ms | 0 | measured |
| moui-md-wgpu | small | open | ui-frame | 72.936/78.036 | - | - | - | n/a | n/a | n/a | 1308.57 ms | 0 | measured |
| moui-md-wgpu | small | input | ui-frame | 8.279/12.029 | - | 19.373/24.780 | 19.277/24.688 | n/a | n/a | n/a | 1272.34 ms | 29 | measured |
| moui-md-wgpu | small | scroll | ui-frame | 5.755/7.605 | - | 15.953/20.122 | - | n/a | n/a | n/a | 1279.20 ms | 166 | measured |
| moui-md-wgpu | medium | open | ui-frame | 63.904/65.538 | - | - | - | n/a | n/a | n/a | 1275.27 ms | 0 | measured |
| moui-md-wgpu | medium | input | ui-frame | 7.839/9.650 | - | 18.339/21.361 | 18.246/21.268 | n/a | n/a | n/a | 1279.93 ms | 29 | measured |
| moui-md-wgpu | medium | scroll | ui-frame | 5.753/7.293 | - | 16.019/20.214 | - | n/a | n/a | n/a | 1283.25 ms | 174 | measured |
| moui-md-wgpu | large | open | ui-frame | 68.070/74.756 | - | - | - | n/a | n/a | n/a | 1319.61 ms | 0 | measured |
| moui-md-wgpu | large | input | ui-frame | 8.279/10.820 | - | 19.977/22.365 | 19.883/22.277 | n/a | n/a | n/a | 1311.14 ms | 30 | measured |
| moui-md-wgpu | large | scroll | ui-frame | 5.780/7.710 | - | 16.131/19.970 | - | n/a | n/a | n/a | 1322.28 ms | 171 | measured |
| moui-md-wgpu | stress | open | ui-frame | 63.470/64.495 | - | - | - | n/a | n/a | n/a | 1797.15 ms | 0 | measured |
| moui-md-wgpu | stress | input | ui-frame | 13.050/19.230 | - | 39.076/46.597 | 38.973/46.428 | n/a | n/a | n/a | 1801.36 ms | 60 | measured |
| moui-md-wgpu | stress | scroll | ui-frame | 5.876/7.666 | - | 16.477/20.833 | - | n/a | n/a | n/a | 1773.37 ms | 183 | measured |
| gpmark | small | open | ui-frame | 1.215/1.277 | - | - | - | n/a | n/a | n/a | 296.25 ms | n/a | measured |
| gpmark | small | input | ui-frame | 1.121/1.273 | 0.384/0.430 | 6.819/7.505 | 6.818/7.505 | n/a | n/a | n/a | 304.76 ms | n/a | measured |
| gpmark | small | scroll | ui-frame | 1.599/2.037 | 0.000/0.001 | 6.935/7.580 | - | n/a | n/a | n/a | 302.99 ms | n/a | measured |
| gpmark | medium | open | ui-frame | 1.263/1.474 | - | - | - | n/a | n/a | n/a | 307.15 ms | n/a | measured |
| gpmark | medium | input | ui-frame | 1.202/1.674 | 0.442/0.587 | 6.882/7.814 | 6.880/7.811 | n/a | n/a | n/a | 308.00 ms | n/a | measured |
| gpmark | medium | scroll | ui-frame | 1.606/2.106 | 0.000/0.001 | 6.934/7.519 | - | n/a | n/a | n/a | 303.96 ms | n/a | measured |
| gpmark | large | open | ui-frame | 1.665/1.890 | - | - | - | n/a | n/a | n/a | 339.10 ms | n/a | measured |
| gpmark | large | input | ui-frame | 1.160/1.374 | 0.773/0.949 | 6.796/7.444 | 6.795/7.444 | n/a | n/a | n/a | 347.24 ms | n/a | measured |
| gpmark | large | scroll | ui-frame | 1.593/2.000 | 0.000/0.001 | 6.937/7.486 | - | n/a | n/a | n/a | 337.94 ms | n/a | measured |
| gpmark | stress | open | ui-frame | 1.680/2.036 | - | - | - | n/a | n/a | n/a | 755.56 ms | n/a | measured |
| gpmark | stress | input | ui-frame | 1.319/1.733 | 4.616/6.628 | 6.595/7.380 | 6.594/7.374 | n/a | n/a | n/a | 746.91 ms | n/a | measured |
| gpmark | stress | scroll | ui-frame | 1.589/1.998 | 0.000/0.001 | 6.933/7.498 | - | n/a | n/a | n/a | 774.17 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 0.564/0.590 | - | - | - | 43.54 ms | n/a | n/a | 193.00 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 0.836/1.077 | - | 6.945/6.945 | 7.130/8.918 | 0.51 ms | n/a | n/a | 191.67 ms | 0 | measured |
| flutter-skia | small | scroll | ui-frame | 2.492/3.067 | - | 7.022/6.945 | - | 0.51 ms | n/a | n/a | 200.67 ms | 0 | measured |
| flutter-skia | medium | open | ui-frame | 0.481/0.522 | - | - | - | 40.15 ms | n/a | n/a | 191.33 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 0.848/1.046 | - | 6.944/6.945 | 7.102/8.638 | 0.51 ms | n/a | n/a | 192.33 ms | 0 | measured |
| flutter-skia | medium | scroll | ui-frame | 3.871/5.853 | - | 9.896/13.889 | - | 0.55 ms | n/a | n/a | 192.33 ms | 0 | measured |
| flutter-skia | large | open | ui-frame | 1.514/1.793 | - | - | - | 43.47 ms | n/a | n/a | 197.33 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 0.908/1.165 | - | 6.944/6.945 | 7.089/8.157 | 0.51 ms | n/a | n/a | 207.67 ms | 0 | measured |
| flutter-skia | large | scroll | ui-frame | 4.109/6.820 | - | 10.205/13.889 | - | 0.58 ms | n/a | n/a | 203.00 ms | 0 | measured |
| flutter-skia | stress | open | ui-frame | 0.485/0.542 | - | - | - | 40.45 ms | n/a | n/a | 269.00 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 0.877/1.102 | - | 6.944/6.945 | 7.058/8.537 | 0.52 ms | n/a | n/a | 265.33 ms | 0 | measured |
| flutter-skia | stress | scroll | ui-frame | 3.889/5.956 | - | 9.722/13.889 | - | 0.56 ms | n/a | n/a | 261.00 ms | 2 | measured |
| flutter-impeller | small | open | ui-frame | 0.457/0.496 | - | - | - | 20.20 ms | n/a | n/a | 1372.33 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 0.890/1.078 | - | 6.945/6.945 | 7.085/8.767 | 1.32 ms | n/a | n/a | 1401.00 ms | 0 | measured |
| flutter-impeller | small | scroll | ui-frame | 2.630/3.499 | - | 7.041/6.945 | - | 1.30 ms | n/a | n/a | 1389.67 ms | 0 | measured |
| flutter-impeller | medium | open | ui-frame | 0.443/0.488 | - | - | - | 23.48 ms | n/a | n/a | 1381.67 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 0.860/0.987 | - | 6.945/6.945 | 7.089/9.058 | 1.32 ms | n/a | n/a | 1394.33 ms | 0 | measured |
| flutter-impeller | medium | scroll | ui-frame | 4.079/6.688 | - | 10.012/13.889 | - | 1.31 ms | n/a | n/a | 1410.33 ms | 0 | measured |
| flutter-impeller | large | open | ui-frame | 1.544/1.653 | - | - | - | 23.17 ms | n/a | n/a | 1371.33 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 0.897/1.139 | - | 6.944/6.945 | 7.080/9.172 | 1.30 ms | n/a | n/a | 1382.00 ms | 0 | measured |
| flutter-impeller | large | scroll | ui-frame | 3.972/6.022 | - | 9.799/13.889 | - | 1.30 ms | n/a | n/a | 1393.00 ms | 0 | measured |
| flutter-impeller | stress | open | ui-frame | 0.455/0.509 | - | - | - | 21.50 ms | n/a | n/a | 1437.00 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 0.874/1.066 | - | 6.945/6.945 | 7.085/8.038 | 1.31 ms | n/a | n/a | 1460.00 ms | 0 | measured |
| flutter-impeller | stress | scroll | ui-frame | 4.149/6.460 | - | 9.780/13.889 | - | 1.32 ms | n/a | n/a | 1443.33 ms | 0 | measured |
| electron | small | open | ui-frame | 1291.667/1306.000 | - | - | - | n/a | n/a | n/a | 1291.67 ms | 0 | measured |
| electron | small | input | ui-frame | 3.130/5.100 | - | 8.424/13.900 | 7.080/13.600 | n/a | n/a | n/a | 1290.33 ms | 1 | measured |
| electron | small | scroll | ui-frame | 3.286/4.500 | - | 7.010/7.000 | - | n/a | n/a | n/a | 1282.67 ms | 0 | measured |
| electron | medium | open | ui-frame | 1281.000/1285.000 | - | - | - | n/a | n/a | n/a | 1281.00 ms | 0 | measured |
| electron | medium | input | ui-frame | 3.047/5.000 | - | 7.543/13.900 | 6.770/14.700 | n/a | n/a | n/a | 1292.67 ms | 0 | measured |
| electron | medium | scroll | ui-frame | 3.453/4.700 | - | 7.010/7.000 | - | n/a | n/a | n/a | 1281.67 ms | 0 | measured |
| electron | large | open | ui-frame | 1273.667/1277.000 | - | - | - | n/a | n/a | n/a | 1273.67 ms | 0 | measured |
| electron | large | input | ui-frame | 3.053/4.500 | - | 7.789/13.900 | 7.010/14.100 | n/a | n/a | n/a | 1284.00 ms | 1 | measured |
| electron | large | scroll | ui-frame | 3.442/4.700 | - | 7.010/7.000 | - | n/a | n/a | n/a | 1287.00 ms | 0 | measured |
| electron | stress | open | ui-frame | 1328.667/1338.000 | - | - | - | n/a | n/a | n/a | 1328.67 ms | 0 | measured |
| electron | stress | input | ui-frame | 2.967/4.800 | - | 8.654/13.900 | 7.223/14.200 | n/a | n/a | n/a | 1300.33 ms | 1 | measured |
| electron | stress | scroll | ui-frame | 3.532/4.900 | - | 7.022/7.000 | - | n/a | n/a | n/a | 1312.67 ms | 0 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.99/7.39/7.38 | 8.64/8.82/8.86 | 0/0/0 | 2.28/2.31/2.29 | 3.09/3.16/3.19 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 6.93/6.93/6.96 | 7.22/7.35/7.23 | 0/0/0 | 2.15/2.19/2.19 | 2.80/2.71/2.71 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 7.11/7.13/7.16 | 8.41/8.46/8.63 | 0/0/0 | 2.47/2.45/2.51 | 3.29/3.17/3.29 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 15.46/15.36/15.56 | 18.54/18.08/18.42 | 71/66/82 | 4.84/4.76/4.78 | 6.42/6.41/6.23 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 7.38/7.36/7.28 | 9.65/9.25/9.53 | 0/0/0 | 4.79/4.74/4.73 | 6.31/6.21/6.21 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 15.95/16.02/16.13 | 20.12/20.21/19.97 | 166/174/171 | 5.75/5.75/5.78 | 7.61/7.29/7.71 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 6.94/6.93/6.94 | 7.58/7.52/7.49 | n/a/n/a/n/a | 1.60/1.61/1.59 | 2.04/2.11/2.00 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.02/9.90/10.20 | 6.95/13.89/13.89 | 0/0/0 | 2.49/3.87/4.11 | 3.07/5.85/6.82 | 0.51/0.55/0.58 | 0.69/0.77/0.84 |
| Flutter Impeller | 7.04/10.01/9.80 | 6.95/13.89/13.89 | 0/0/0 | 2.63/4.08/3.97 | 3.50/6.69/6.02 | 1.30/1.31/1.30 | 1.68/1.84/1.71 |
| Electron | 7.01/7.01/7.01 | 7.00/7.00/7.00 | 0/0/0 | 3.29/3.45/3.44 | 4.50/4.70/4.70 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 7.49 | 9.09 | 1 | 2.35 | 3.27 | n/a | n/a |
| MoUI Skia GPU | 6.90 | 7.20 | 0 | 2.18 | 2.68 | n/a | n/a |
| MoUI WGPU | 7.17 | 8.92 | 0 | 2.51 | 3.36 | n/a | n/a |
| MoMark Skia Raster | 15.55 | 18.60 | 72 | 4.75 | 6.13 | n/a | n/a |
| MoMark Skia GPU | 7.32 | 9.22 | 0 | 4.69 | 6.12 | n/a | n/a |
| MoMark WGPU | 16.48 | 20.83 | 183 | 5.88 | 7.67 | n/a | n/a |
| GpMark.mbt (GPUI) | 6.93 | 7.50 | n/a | 1.59 | 2.00 | n/a | n/a |
| Flutter Skia | 9.72 | 13.89 | 2 | 3.89 | 5.96 | 0.56 | 0.76 |
| Flutter Impeller | 9.78 | 13.89 | 0 | 4.15 | 6.46 | 1.32 | 1.79 |
| Electron | 7.02 | 7.00 | 0 | 3.53 | 4.90 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.97/7.26/7.35 | 8.73/8.70/9.17 | 2.22/2.10/2.13 | 3.18/3.09/3.04 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 6.46/6.64/6.04 | 7.13/8.82/7.13 | 1.93/1.96/1.86 | 2.44/2.46/2.07 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 11.97/13.00/11.84 | 15.00/18.79/16.22 | 5.77/6.40/5.76 | 7.23/10.74/8.50 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 15.04/15.21/17.30 | 17.77/16.39/21.05 | 3.66/3.64/4.32 | 4.38/4.53/6.13 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 8.59/8.61/9.84 | 14.44/14.21/17.81 | 3.70/3.66/4.02 | 5.69/4.37/4.81 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 19.28/18.25/19.88 | 24.69/21.27/22.28 | 8.28/7.84/8.28 | 12.03/9.65/10.82 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 6.82/6.88/6.79 | 7.50/7.81/7.44 | 1.12/1.20/1.16 | 1.27/1.67/1.37 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.13/7.10/7.09 | 8.92/8.64/8.16 | 0.84/0.85/0.91 | 1.08/1.05/1.17 | 0.51/0.51/0.51 | 0.59/0.58/0.67 |
| Flutter Impeller | 7.08/7.09/7.08 | 8.77/9.06/9.17 | 0.89/0.86/0.90 | 1.08/0.99/1.14 | 1.32/1.32/1.30 | 1.82/1.77/1.57 |
| Electron | 7.08/6.77/7.01 | 13.60/14.70/14.10 | 3.13/3.05/3.05 | 5.10/5.00/4.50 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 7.66 | 9.30 | 2.11 | 3.04 | n/a | n/a |
| MoUI Skia GPU | 6.51 | 8.93 | 1.95 | 2.23 | n/a | n/a |
| MoUI WGPU | 11.20 | 13.12 | 5.41 | 6.51 | n/a | n/a |
| MoMark Skia Raster | 32.99 | 37.69 | 8.15 | 10.71 | n/a | n/a |
| MoMark Skia GPU | 25.40 | 27.81 | 8.06 | 9.45 | n/a | n/a |
| MoMark WGPU | 38.97 | 46.43 | 13.05 | 19.23 | n/a | n/a |
| GpMark.mbt (GPUI) | 6.59 | 7.37 | 1.32 | 1.73 | n/a | n/a |
| Flutter Skia | 7.06 | 8.54 | 0.88 | 1.10 | 0.52 | 0.57 |
| Flutter Impeller | 7.09 | 8.04 | 0.87 | 1.07 | 1.31 | 1.90 |
| Electron | 7.22 | 14.20 | 2.97 | 4.80 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 55.75/61.16/96.36 | 57.34/64.06/99.68 | 0.22/0.73/4.99 | 0.27/0.80/5.36 | 9.88/9.90/10.03 | 10.67/11.16/10.42 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 401.48/417.37/431.97 | 409.22/433.93/464.79 | 0.20/0.72/3.66 | 0.27/0.93/3.72 | 9.75/8.91/10.75 | 11.05/9.23/13.48 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 1271.74/1293.56/1279.62 | 1308.35/1315.68/1280.61 | 0.17/0.71/3.70 | 0.18/0.84/3.86 | 51.25/53.50/47.89 | 54.49/55.98/49.67 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 66.15/72.21/116.34 | 67.62/76.88/120.98 | 0.17/0.72/4.14 | 0.20/0.84/5.07 | 12.19/11.95/12.22 | 12.47/13.34/13.36 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 369.37/379.12/430.37 | 374.91/388.61/436.39 | 0.14/0.69/3.91 | 0.15/0.92/4.08 | 10.79/11.28/11.27 | 11.03/11.65/11.53 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 1308.57/1275.27/1319.61 | 1326.73/1280.38/1327.23 | 0.13/0.56/4.24 | 0.14/0.57/5.01 | 72.94/63.90/68.07 | 78.04/65.54/74.76 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 296.25/307.15/339.10 | 298.72/310.67/341.33 | 0.67/0.67/4.33 | 1.00/1.00/5.00 | 1.22/1.26/1.67 | 1.28/1.47/1.89 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 193.00/191.33/197.33 | 195.00/193.00/199.00 | 0.82/0.90/1.14 | 1.04/1.01/1.23 | 0.56/0.48/1.51 | 0.59/0.52/1.79 | 43.54/40.15/43.47 | 45.22/41.91/44.84 |
| Flutter Impeller | 1372.33/1381.67/1371.33 | 1378.00/1391.00/1391.00 | 0.85/0.88/1.28 | 0.90/0.93/1.53 | 0.46/0.44/1.54 | 0.50/0.49/1.65 | 20.20/23.48/23.17 | 22.90/23.98/24.10 |
| Electron | 1291.67/1281.00/1273.67 | 1306.00/1285.00/1277.00 | 4.06/3.45/4.42 | 4.39/3.85/4.66 | 1291.67/1281.00/1273.67 | 1306.00/1285.00/1277.00 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 455.13 | 466.42 | 52.30 | 53.22 | 9.96 | 10.80 | n/a | n/a |
| MoUI Skia GPU | 776.63 | 778.07 | 42.15 | 45.91 | 10.15 | 11.42 | n/a | n/a |
| MoUI WGPU | 1644.53 | 1678.72 | 38.53 | 39.78 | 50.31 | 53.09 | n/a | n/a |
| MoMark Skia Raster | 583.39 | 601.25 | 43.03 | 46.48 | 11.67 | 11.96 | n/a | n/a |
| MoMark Skia GPU | 939.83 | 943.58 | 41.60 | 45.51 | 11.86 | 12.63 | n/a | n/a |
| MoMark WGPU | 1797.15 | 1809.94 | 38.51 | 39.63 | 63.47 | 64.50 | n/a | n/a |
| GpMark.mbt (GPUI) | 755.56 | 760.10 | 40.33 | 42.00 | 1.68 | 2.04 | n/a | n/a |
| Flutter Skia | 269.00 | 274.00 | 3.49 | 3.82 | 0.48 | 0.54 | 40.45 | 41.53 |
| Flutter Impeller | 1437.00 | 1451.00 | 3.37 | 3.55 | 0.45 | 0.51 | 21.50 | 22.30 |
| Electron | 1328.67 | 1338.00 | 10.51 | 11.28 | 1328.67 | 1338.00 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.99/7.39/7.38 | 8.64/8.82/8.86 | 0/0/0 | 2.28/2.31/2.29 | 3.09/3.16/3.19 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 6.93/6.93/6.96 | 7.22/7.35/7.23 | 0/0/0 | 2.15/2.19/2.19 | 2.80/2.71/2.71 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 7.11/7.13/7.16 | 8.41/8.46/8.63 | 0/0/0 | 2.47/2.45/2.51 | 3.29/3.17/3.29 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 15.46/15.36/15.56 | 18.54/18.08/18.42 | 71/66/82 | 4.84/4.76/4.78 | 6.42/6.41/6.23 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 7.38/7.36/7.28 | 9.65/9.25/9.53 | 0/0/0 | 4.79/4.74/4.73 | 6.31/6.21/6.21 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 15.95/16.02/16.13 | 20.12/20.21/19.97 | 166/174/171 | 5.75/5.75/5.78 | 7.61/7.29/7.71 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 6.94/6.93/6.94 | 7.58/7.52/7.49 | n/a/n/a/n/a | 1.60/1.61/1.59 | 2.04/2.11/2.00 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.02/9.90/10.20 | 6.95/13.89/13.89 | 0/0/0 | 2.49/3.87/4.11 | 3.07/5.85/6.82 | 0.51/0.55/0.58 | 0.69/0.77/0.84 |
| Flutter Impeller | 7.04/10.01/9.80 | 6.95/13.89/13.89 | 0/0/0 | 2.63/4.08/3.97 | 3.50/6.69/6.02 | 1.30/1.31/1.30 | 1.68/1.84/1.71 |
| Electron | 7.01/7.01/7.01 | 7.00/7.00/7.00 | 0/0/0 | 3.29/3.45/3.44 | 4.50/4.70/4.70 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 7.49 | 9.09 | 1 | 2.35 | 3.27 | n/a | n/a |
| MoUI Skia GPU | 6.90 | 7.20 | 0 | 2.18 | 2.68 | n/a | n/a |
| MoUI WGPU | 7.17 | 8.92 | 0 | 2.51 | 3.36 | n/a | n/a |
| MoMark Skia Raster | 15.55 | 18.60 | 72 | 4.75 | 6.13 | n/a | n/a |
| MoMark Skia GPU | 7.32 | 9.22 | 0 | 4.69 | 6.12 | n/a | n/a |
| MoMark WGPU | 16.48 | 20.83 | 183 | 5.88 | 7.67 | n/a | n/a |
| GpMark.mbt (GPUI) | 6.93 | 7.50 | n/a | 1.59 | 2.00 | n/a | n/a |
| Flutter Skia | 9.72 | 13.89 | 2 | 3.89 | 5.96 | 0.56 | 0.76 |
| Flutter Impeller | 9.78 | 13.89 | 0 | 4.15 | 6.46 | 1.32 | 1.79 |
| Electron | 7.02 | 7.00 | 0 | 3.53 | 4.90 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoUI Skia Raster CPU stress 455.1 ms（max 466.4 ms）；MoUI Skia GPU small 401.5 ms（max 409.2 ms）；MoUI Skia GPU medium 417.4 ms（max 433.9 ms）；MoUI Skia GPU large 432.0 ms（max 464.8 ms）；MoUI Skia GPU stress 776.6 ms（max 778.1 ms）；MoUI WGPU small 1271.7 ms（max 1308.3 ms）；MoUI WGPU medium 1293.6 ms（max 1315.7 ms）；MoUI WGPU large 1279.6 ms（max 1280.6 ms）；MoUI WGPU stress 1644.5 ms（max 1678.7 ms）；MoMark Skia Raster large 116.3 ms（max 121.0 ms）；MoMark Skia Raster stress 583.4 ms（max 601.2 ms）；MoMark Skia GPU small 369.4 ms（max 374.9 ms）；MoMark Skia GPU medium 379.1 ms（max 388.6 ms）；MoMark Skia GPU large 430.4 ms（max 436.4 ms）；MoMark Skia GPU stress 939.8 ms（max 943.6 ms）；MoMark WGPU small 1308.6 ms（max 1326.7 ms）；MoMark WGPU medium 1275.3 ms（max 1280.4 ms）；MoMark WGPU large 1319.6 ms（max 1327.2 ms）；MoMark WGPU stress 1797.2 ms（max 1809.9 ms）；GpMark.mbt (GPUI) small 296.3 ms（max 298.7 ms）；GpMark.mbt (GPUI) medium 307.2 ms（max 310.7 ms）；GpMark.mbt (GPUI) large 339.1 ms（max 341.3 ms）；GpMark.mbt (GPUI) stress 755.6 ms（max 760.1 ms）；Flutter Skia small 193.0 ms（max 195.0 ms）；Flutter Skia medium 191.3 ms（max 193.0 ms）；Flutter Skia large 197.3 ms（max 199.0 ms）；Flutter Skia stress 269.0 ms（max 274.0 ms）；Flutter Impeller small 1372.3 ms（max 1378.0 ms）；Flutter Impeller medium 1381.7 ms（max 1391.0 ms）；Flutter Impeller large 1371.3 ms（max 1391.0 ms）；Flutter Impeller stress 1437.0 ms（max 1451.0 ms）；Electron small 1291.7 ms（max 1306.0 ms）；Electron medium 1281.0 ms（max 1285.0 ms）；Electron large 1273.7 ms（max 1277.0 ms）；Electron stress 1328.7 ms（max 1338.0 ms）。
- P1 输入尾延迟：MoUI WGPU medium P95 18.79 ms；MoMark Skia Raster small P95 17.77 ms；MoMark Skia Raster large P95 21.05 ms；MoMark Skia Raster stress P95 37.69 ms；MoMark Skia GPU large P95 17.81 ms；MoMark Skia GPU stress P95 27.81 ms；MoMark WGPU small P95 24.69 ms；MoMark WGPU medium P95 21.27 ms；MoMark WGPU large P95 22.28 ms；MoMark WGPU stress P95 46.43 ms。
- 长帧（超预算）：MoUI Skia Raster CPU: stress/scroll 1 次，max 18.93 ms；MoUI WGPU: medium/input 5 次，max 21.50 ms；MoMark Skia Raster: small/input 3 次，max 19.21 ms, small/scroll 67 次，max 21.79 ms, medium/input 1 次，max 18.77 ms, medium/scroll 61 次，max 26.24 ms, large/input 15 次，max 22.25 ms, large/scroll 77 次，max 22.05 ms, stress/input 30 次，max 44.03 ms, stress/scroll 61 次，max 22.17 ms；MoMark Skia GPU: small/input 1 次，max 17.83 ms, large/input 3 次，max 18.29 ms, stress/input 30 次，max 27.97 ms；MoMark WGPU: small/input 28 次，max 27.08 ms, small/scroll 154 次，max 33.80 ms, medium/input 28 次，max 25.39 ms, medium/scroll 169 次，max 24.74 ms, large/input 30 次，max 23.97 ms, large/scroll 165 次，max 28.65 ms, stress/input 30 次，max 47.25 ms, stress/scroll 180 次，max 27.87 ms；Flutter Skia: stress/scroll 2 次，max 27.78 ms；Electron: small/input 1 次，max 19.37 ms, large/input 1 次，max 19.47 ms, stress/input 1 次，max 19.47 ms。
- 丢帧（优先处理）：MoUI Skia Raster CPU: stress/scroll 1 帧；MoUI WGPU: medium/input 5 帧；MoMark Skia Raster: small/input 3 帧, small/scroll 71 帧, medium/input 1 帧, medium/scroll 66 帧, large/input 17 帧, large/scroll 82 帧, stress/input 38 帧, stress/scroll 72 帧；MoMark Skia GPU: small/input 1 帧, large/input 3 帧, stress/input 30 帧；MoMark WGPU: small/input 29 帧, small/scroll 166 帧, medium/input 29 帧, medium/scroll 174 帧, large/input 30 帧, large/scroll 171 帧, stress/input 60 帧, stress/scroll 183 帧；Flutter Skia: stress/scroll 2 帧；Electron: small/input 1 帧, large/input 1 帧, stress/input 1 帧。
- 解释：首帧异常优先检查窗口/渲染器初始化；输入尾延迟检查 action 到下一可见帧的调度与同步重建；长帧检查解析、布局、文本 shaping 和 GPU 提交；`n/a` 表示未埋点，不等于 0。
- 普通模式的长帧、帧间隔和输入延迟是各框架回调诊断，不能替代跨框架 compositor 排名；需要严格结论时运行 `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`。

## 采集口径

- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。
- `frame_work_ms` 统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏；对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `device_present_ms`：设备/上屏侧统一字段。MoUI raster 为 Skia CPU 光栅化+像素回读整体；MoUI GPU/wgpu 为提交后同步等待设备完成（headless host-surface 逐帧同步，真实应用的 vsync 流水线可重叠掉一部分，该值应视为上屏成本上界）；窗口模式（`window_mode=native-window`）下 MoUI 由真实 Win32 窗口上屏，适配器侧不单独计时，显示 `n/a`；Flutter 为 `FrameTiming.rasterDuration`（光栅线程任务时间，含显示列表光栅化与 GPU 提交、不含设备完成等待）；GPUI 与 Electron 适配器侧无法观测，显示 `n/a`。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧，统一口径为「进程起点 → 首帧可交互」（全包含）：MoUI 在 main 入口打点（含渲染器构建，headless 无平台窗口成本）；Flutter 优先取 runner 在进程起点打点的 epoch（env 缺失时退回 Dart 最早时刻，Flutter 引擎与原生窗口创建计入）；Electron 取 main.js 首个 JS 时刻（Chromium 主进程初始化、窗口创建与页面加载计入）；GPUI 从 MoonBit main 入口打点（Win32 初始化、Direct3D 渲染器与首帧计入）。打开场景没有前一帧，所以不计算 interval/drop。严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代。
- 跨框架比较注意：MoUI/MoMark 系列与 Flutter/Electron/GPUI 现默认同为原生窗口（native-window）模式，时钟同为进程起点 → 首帧可交互；旧 headless host-surface 模式可用 `UI_BENCHMARK_HEADLESS=1` 复现（无真实窗口/合成器成本，帧间隔为未同步的帧生产耗时，与窗口模式的 vsync 间隔语义不同）。GPUI 另可用 `GPUI_OPEN_TRACE=1` 输出启动分相（应用初始化 / 窗口创建 / 首帧）。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。
