# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-14T18:50:12Z`
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
| moui-skia-raster | small | open | ui-frame | 11.883/15.002 | - | - | - | n/a | n/a | n/a | 64.25 ms | 0 | measured |
| moui-skia-raster | small | input | ui-frame | 2.362/2.731 | - | 30.682/32.083 | 30.568/31.976 | n/a | n/a | n/a | 63.35 ms | 31 | measured |
| moui-skia-raster | small | scroll | ui-frame | 2.540/3.450 | - | 30.617/32.504 | - | n/a | n/a | n/a | 62.93 ms | 365 | measured |
| moui-skia-raster | medium | open | ui-frame | 10.352/10.791 | - | - | - | n/a | n/a | n/a | 67.89 ms | 0 | measured |
| moui-skia-raster | medium | input | ui-frame | 2.327/2.577 | - | 30.783/32.084 | 30.675/31.967 | n/a | n/a | n/a | 68.25 ms | 31 | measured |
| moui-skia-raster | medium | scroll | ui-frame | 2.561/3.368 | - | 30.667/32.507 | - | n/a | n/a | n/a | 62.24 ms | 364 | measured |
| moui-skia-raster | large | open | ui-frame | 9.107/9.717 | - | - | - | n/a | n/a | n/a | 85.97 ms | 0 | measured |
| moui-skia-raster | large | input | ui-frame | 2.458/3.256 | - | 30.729/32.190 | 30.612/32.190 | n/a | n/a | n/a | 87.48 ms | 30 | measured |
| moui-skia-raster | large | scroll | ui-frame | 2.535/3.251 | - | 30.615/32.529 | - | n/a | n/a | n/a | 92.88 ms | 366 | measured |
| moui-skia-raster | stress | open | ui-frame | 9.777/10.179 | - | - | - | n/a | n/a | n/a | 438.71 ms | 0 | measured |
| moui-skia-raster | stress | input | ui-frame | 2.342/2.861 | - | 31.100/32.399 | 30.995/32.274 | n/a | n/a | n/a | 416.75 ms | 31 | measured |
| moui-skia-raster | stress | scroll | ui-frame | 2.554/3.499 | - | 30.627/32.413 | - | n/a | n/a | n/a | 417.18 ms | 366 | measured |
| moui-skia-gpu | small | open | ui-frame | 8.660/8.808 | - | - | - | n/a | n/a | n/a | 817.67 ms | 0 | measured |
| moui-skia-gpu | small | input | ui-frame | 2.495/3.440 | - | 30.312/33.740 | 30.190/33.627 | n/a | n/a | n/a | 822.17 ms | 32 | measured |
| moui-skia-gpu | small | scroll | ui-frame | 2.723/3.851 | - | 30.058/32.616 | - | n/a | n/a | n/a | 847.08 ms | 359 | measured |
| moui-skia-gpu | medium | open | ui-frame | 9.461/9.833 | - | - | - | n/a | n/a | n/a | 877.25 ms | 0 | measured |
| moui-skia-gpu | medium | input | ui-frame | 2.564/3.658 | - | 30.641/33.560 | 30.522/33.446 | n/a | n/a | n/a | 869.54 ms | 32 | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 2.614/3.645 | - | 29.218/32.680 | - | n/a | n/a | n/a | 833.71 ms | 348 | measured |
| moui-skia-gpu | large | open | ui-frame | 8.856/8.985 | - | - | - | n/a | n/a | n/a | 838.73 ms | 0 | measured |
| moui-skia-gpu | large | input | ui-frame | 2.550/3.746 | - | 30.545/31.746 | 30.434/31.609 | n/a | n/a | n/a | 850.81 ms | 30 | measured |
| moui-skia-gpu | large | scroll | ui-frame | 2.622/3.328 | - | 29.715/32.596 | - | n/a | n/a | n/a | 855.10 ms | 349 | measured |
| moui-skia-gpu | stress | open | ui-frame | 9.208/9.677 | - | - | - | n/a | n/a | n/a | 1163.18 ms | 0 | measured |
| moui-skia-gpu | stress | input | ui-frame | 2.295/2.639 | - | 46.636/48.709 | 46.525/48.599 | n/a | n/a | n/a | 1172.35 ms | 60 | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 2.633/3.225 | - | 30.050/32.442 | - | n/a | n/a | n/a | 1178.73 ms | 356 | measured |
| moui-wgpu | small | open | ui-frame | 40.854/42.046 | - | - | - | n/a | n/a | n/a | 1210.21 ms | 0 | measured |
| moui-wgpu | small | input | ui-frame | 5.689/6.738 | - | 30.859/33.480 | 30.752/33.369 | n/a | n/a | n/a | 1222.34 ms | 32 | measured |
| moui-wgpu | small | scroll | ui-frame | 2.974/3.965 | - | 30.756/32.581 | - | n/a | n/a | n/a | 1208.09 ms | 368 | measured |
| moui-wgpu | medium | open | ui-frame | 40.672/41.579 | - | - | - | n/a | n/a | n/a | 1214.58 ms | 0 | measured |
| moui-wgpu | medium | input | ui-frame | 5.361/6.430 | - | 30.838/33.259 | 30.731/33.150 | n/a | n/a | n/a | 1220.87 ms | 31 | measured |
| moui-wgpu | medium | scroll | ui-frame | 3.004/4.025 | - | 30.774/33.236 | - | n/a | n/a | n/a | 1215.73 ms | 374 | measured |
| moui-wgpu | large | open | ui-frame | 41.731/44.201 | - | - | - | n/a | n/a | n/a | 1256.14 ms | 0 | measured |
| moui-wgpu | large | input | ui-frame | 5.493/6.952 | - | 30.861/33.548 | 30.753/33.445 | n/a | n/a | n/a | 1240.47 ms | 33 | measured |
| moui-wgpu | large | scroll | ui-frame | 2.851/3.613 | - | 30.755/32.639 | - | n/a | n/a | n/a | 1245.23 ms | 370 | measured |
| moui-wgpu | stress | open | ui-frame | 40.378/42.016 | - | - | - | n/a | n/a | n/a | 1570.31 ms | 0 | measured |
| moui-wgpu | stress | input | ui-frame | 5.537/6.819 | - | 40.014/46.624 | 39.910/46.520 | n/a | n/a | n/a | 1571.85 ms | 48 | measured |
| moui-wgpu | stress | scroll | ui-frame | 3.016/3.764 | - | 30.793/33.061 | - | n/a | n/a | n/a | 1604.29 ms | 374 | measured |
| moui-md-skia-raster | small | open | ui-frame | 14.913/15.594 | - | - | - | n/a | n/a | n/a | 71.69 ms | 0 | measured |
| moui-md-skia-raster | small | input | ui-frame | 4.486/6.466 | - | 31.121/33.435 | 31.029/33.435 | n/a | n/a | n/a | 69.82 ms | 32 | measured |
| moui-md-skia-raster | small | scroll | ui-frame | 5.238/6.729 | - | 31.040/34.944 | - | n/a | n/a | n/a | 70.21 ms | 426 | measured |
| moui-md-skia-raster | medium | open | ui-frame | 14.397/14.544 | - | - | - | n/a | n/a | n/a | 72.20 ms | 0 | measured |
| moui-md-skia-raster | medium | input | ui-frame | 4.152/4.570 | - | 30.769/32.751 | 30.677/32.625 | n/a | n/a | n/a | 74.41 ms | 30 | measured |
| moui-md-skia-raster | medium | scroll | ui-frame | 5.248/6.636 | - | 30.996/35.331 | - | n/a | n/a | n/a | 73.15 ms | 438 | measured |
| moui-md-skia-raster | large | open | ui-frame | 14.466/15.061 | - | - | - | n/a | n/a | n/a | 111.50 ms | 0 | measured |
| moui-md-skia-raster | large | input | ui-frame | 4.974/6.399 | - | 31.472/34.526 | 31.378/34.427 | n/a | n/a | n/a | 110.23 ms | 33 | measured |
| moui-md-skia-raster | large | scroll | ui-frame | 5.286/6.710 | - | 30.970/34.628 | - | n/a | n/a | n/a | 111.12 ms | 413 | measured |
| moui-md-skia-raster | stress | open | ui-frame | 15.842/19.284 | - | - | - | n/a | n/a | n/a | 534.65 ms | 0 | measured |
| moui-md-skia-raster | stress | input | ui-frame | 9.069/11.385 | - | 61.655/65.331 | 61.557/65.234 | n/a | n/a | n/a | 531.00 ms | 91 | measured |
| moui-md-skia-raster | stress | scroll | ui-frame | 5.254/6.757 | - | 30.990/34.828 | - | n/a | n/a | n/a | 530.36 ms | 427 | measured |
| moui-md-skia-gpu | small | open | ui-frame | 15.373/16.194 | - | - | - | n/a | n/a | n/a | 1010.01 ms | 0 | measured |
| moui-md-skia-gpu | small | input | ui-frame | 4.424/5.972 | - | 61.355/69.747 | 61.259/69.746 | n/a | n/a | n/a | 1005.21 ms | 92 | measured |
| moui-md-skia-gpu | small | scroll | ui-frame | 5.333/6.972 | - | 46.554/50.710 | - | n/a | n/a | n/a | 1000.55 ms | 746 | measured |
| moui-md-skia-gpu | medium | open | ui-frame | 13.712/14.097 | - | - | - | n/a | n/a | n/a | 1008.41 ms | 0 | measured |
| moui-md-skia-gpu | medium | input | ui-frame | 4.543/6.205 | - | 61.636/66.983 | 61.535/66.982 | n/a | n/a | n/a | 1004.62 ms | 92 | measured |
| moui-md-skia-gpu | medium | scroll | ui-frame | 5.292/6.734 | - | 46.518/50.421 | - | n/a | n/a | n/a | 1030.46 ms | 744 | measured |
| moui-md-skia-gpu | large | open | ui-frame | 15.445/18.390 | - | - | - | n/a | n/a | n/a | 1051.44 ms | 0 | measured |
| moui-md-skia-gpu | large | input | ui-frame | 4.765/5.291 | - | 62.027/69.711 | 61.931/69.710 | n/a | n/a | n/a | 1043.92 ms | 94 | measured |
| moui-md-skia-gpu | large | scroll | ui-frame | 5.314/6.947 | - | 46.333/50.334 | - | n/a | n/a | n/a | 1051.68 ms | 744 | measured |
| moui-md-skia-gpu | stress | open | ui-frame | 13.788/14.267 | - | - | - | n/a | n/a | n/a | 1471.05 ms | 0 | measured |
| moui-md-skia-gpu | stress | input | ui-frame | 8.860/9.839 | - | 77.600/79.814 | 77.504/79.697 | n/a | n/a | n/a | 1469.94 ms | 121 | measured |
| moui-md-skia-gpu | stress | scroll | ui-frame | 5.285/6.857 | - | 46.443/50.606 | - | n/a | n/a | n/a | 1495.03 ms | 749 | measured |
| moui-md-wgpu | small | open | ui-frame | 56.624/58.396 | - | - | - | n/a | n/a | n/a | 1243.20 ms | 0 | measured |
| moui-md-wgpu | small | input | ui-frame | 7.794/12.134 | - | 32.781/40.462 | 32.679/40.366 | n/a | n/a | n/a | 1251.90 ms | 38 | measured |
| moui-md-wgpu | small | scroll | ui-frame | 6.349/8.039 | - | 31.484/38.765 | - | n/a | n/a | n/a | 1258.01 ms | 548 | measured |
| moui-md-wgpu | medium | open | ui-frame | 54.720/55.430 | - | - | - | n/a | n/a | n/a | 1246.39 ms | 0 | measured |
| moui-md-wgpu | medium | input | ui-frame | 7.883/11.093 | - | 31.921/39.562 | 31.813/39.462 | n/a | n/a | n/a | 1250.99 ms | 35 | measured |
| moui-md-wgpu | medium | scroll | ui-frame | 6.198/7.755 | - | 31.296/37.679 | - | n/a | n/a | n/a | 1241.13 ms | 539 | measured |
| moui-md-wgpu | large | open | ui-frame | 56.008/59.046 | - | - | - | n/a | n/a | n/a | 1285.54 ms | 0 | measured |
| moui-md-wgpu | large | input | ui-frame | 8.107/9.465 | - | 36.104/48.774 | 36.007/48.679 | n/a | n/a | n/a | 1286.58 ms | 43 | measured |
| moui-md-wgpu | large | scroll | ui-frame | 6.378/8.079 | - | 31.505/38.869 | - | n/a | n/a | n/a | 1296.93 ms | 540 | measured |
| moui-md-wgpu | stress | open | ui-frame | 55.450/59.695 | - | - | - | n/a | n/a | n/a | 1712.14 ms | 0 | measured |
| moui-md-wgpu | stress | input | ui-frame | 11.878/13.666 | - | 61.765/66.897 | 61.675/66.797 | n/a | n/a | n/a | 1719.76 ms | 92 | measured |
| moui-md-wgpu | stress | scroll | ui-frame | 6.456/8.199 | - | 31.947/40.109 | - | n/a | n/a | n/a | 1710.18 ms | 550 | measured |
| gpmark | small | open | ui-frame | 1.148/1.198 | - | - | - | n/a | n/a | n/a | 253.85 ms | n/a | measured |
| gpmark | small | input | ui-frame | 1.284/1.392 | 0.444/0.537 | 30.550/32.628 | 30.548/32.624 | n/a | n/a | n/a | 258.15 ms | n/a | measured |
| gpmark | small | scroll | ui-frame | 1.719/2.291 | 0.001/0.001 | 30.822/31.784 | - | n/a | n/a | n/a | 253.55 ms | n/a | measured |
| gpmark | medium | open | ui-frame | 1.409/1.738 | - | - | - | n/a | n/a | n/a | 258.40 ms | n/a | measured |
| gpmark | medium | input | ui-frame | 1.260/1.580 | 0.554/0.782 | 30.708/32.485 | 30.706/32.484 | n/a | n/a | n/a | 255.72 ms | n/a | measured |
| gpmark | medium | scroll | ui-frame | 1.735/2.239 | 0.001/0.001 | 30.837/31.709 | - | n/a | n/a | n/a | 260.26 ms | n/a | measured |
| gpmark | large | open | ui-frame | 1.295/1.404 | - | - | - | n/a | n/a | n/a | 298.35 ms | n/a | measured |
| gpmark | large | input | ui-frame | 1.331/1.571 | 1.755/1.932 | 30.721/32.551 | 30.719/32.542 | n/a | n/a | n/a | 296.07 ms | n/a | measured |
| gpmark | large | scroll | ui-frame | 1.760/2.268 | 0.001/0.001 | 30.806/31.809 | - | n/a | n/a | n/a | 295.26 ms | n/a | measured |
| gpmark | stress | open | ui-frame | 1.293/1.380 | - | - | - | n/a | n/a | n/a | 696.61 ms | n/a | measured |
| gpmark | stress | input | ui-frame | 1.270/1.508 | 14.607/15.655 | 29.940/31.602 | 29.938/31.601 | n/a | n/a | n/a | 684.64 ms | n/a | measured |
| gpmark | stress | scroll | ui-frame | 1.780/2.376 | 0.001/0.001 | 30.767/31.733 | - | n/a | n/a | n/a | 692.51 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 0.423/0.492 | - | - | - | 69.50 ms | n/a | n/a | 29.00 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 0.851/1.085 | - | 6.945/6.945 | 7.110/8.346 | 0.51 ms | n/a | n/a | 29.33 ms | 0 | measured |
| flutter-skia | small | scroll | ui-frame | 2.419/3.093 | - | 7.002/6.945 | - | 0.48 ms | n/a | n/a | 30.00 ms | 0 | measured |
| flutter-skia | medium | open | ui-frame | 0.408/0.464 | - | - | - | 71.98 ms | n/a | n/a | 30.33 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 0.816/1.048 | - | 6.945/6.945 | 6.964/7.883 | 0.49 ms | n/a | n/a | 31.33 ms | 0 | measured |
| flutter-skia | medium | scroll | ui-frame | 3.702/5.420 | - | 8.932/13.889 | - | 0.51 ms | n/a | n/a | 30.00 ms | 3 | measured |
| flutter-skia | large | open | ui-frame | 1.501/1.531 | - | - | - | 80.57 ms | n/a | n/a | 35.00 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 0.750/0.858 | - | 6.945/6.945 | 7.026/7.895 | 0.46 ms | n/a | n/a | 35.33 ms | 0 | measured |
| flutter-skia | large | scroll | ui-frame | 3.601/5.505 | - | 8.681/13.889 | - | 0.51 ms | n/a | n/a | 35.67 ms | 3 | measured |
| flutter-skia | stress | open | ui-frame | 0.418/0.419 | - | - | - | 81.63 ms | n/a | n/a | 87.33 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 0.833/1.026 | - | 6.945/6.945 | 6.955/7.919 | 0.48 ms | n/a | n/a | 86.33 ms | 0 | measured |
| flutter-skia | stress | scroll | ui-frame | 3.780/5.515 | - | 9.202/13.890 | - | 0.53 ms | n/a | n/a | 91.33 ms | 0 | measured |
| flutter-impeller | small | open | ui-frame | 0.480/0.521 | - | - | - | 57.55 ms | n/a | n/a | 29.33 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 0.980/1.373 | - | 6.945/6.945 | 7.091/8.742 | 1.41 ms | n/a | n/a | 29.00 ms | 0 | measured |
| flutter-impeller | small | scroll | ui-frame | 2.532/3.178 | - | 7.002/6.945 | - | 1.15 ms | n/a | n/a | 30.00 ms | 0 | measured |
| flutter-impeller | medium | open | ui-frame | 0.444/0.498 | - | - | - | 54.27 ms | n/a | n/a | 30.67 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 0.819/0.986 | - | 6.945/6.945 | 7.028/8.309 | 1.28 ms | n/a | n/a | 30.33 ms | 0 | measured |
| flutter-impeller | medium | scroll | ui-frame | 3.927/5.838 | - | 9.510/13.890 | - | 1.23 ms | n/a | n/a | 30.67 ms | 4 | measured |
| flutter-impeller | large | open | ui-frame | 1.615/1.713 | - | - | - | 54.82 ms | n/a | n/a | 36.00 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 0.865/1.103 | - | 6.945/6.945 | 7.102/8.700 | 1.31 ms | n/a | n/a | 36.00 ms | 0 | measured |
| flutter-impeller | large | scroll | ui-frame | 3.846/5.796 | - | 9.317/13.890 | - | 1.21 ms | n/a | n/a | 35.67 ms | 2 | measured |
| flutter-impeller | stress | open | ui-frame | 0.475/0.505 | - | - | - | 60.18 ms | n/a | n/a | 88.00 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 0.851/0.992 | - | 6.945/6.945 | 6.992/8.739 | 1.31 ms | n/a | n/a | 89.33 ms | 0 | measured |
| flutter-impeller | stress | scroll | ui-frame | 3.821/5.933 | - | 9.144/13.890 | - | 1.23 ms | n/a | n/a | 85.33 ms | 0 | measured |
| electron | small | open | ui-frame | 1265.333/1275.000 | - | - | - | n/a | n/a | n/a | 1265.33 ms | 0 | measured |
| electron | small | input | ui-frame | 2.847/4.400 | - | 8.361/15.300 | 7.300/11.300 | n/a | n/a | n/a | 1256.67 ms | 1 | measured |
| electron | small | scroll | ui-frame | 3.106/4.700 | - | 7.602/7.800 | - | n/a | n/a | n/a | 1260.00 ms | 0 | measured |
| electron | medium | open | ui-frame | 1250.667/1260.000 | - | - | - | n/a | n/a | n/a | 1250.67 ms | 0 | measured |
| electron | medium | input | ui-frame | 3.030/4.800 | - | 8.781/15.300 | 7.677/15.500 | n/a | n/a | n/a | 1259.33 ms | 1 | measured |
| electron | medium | scroll | ui-frame | 3.325/4.700 | - | 7.664/7.700 | - | n/a | n/a | n/a | 1258.00 ms | 0 | measured |
| electron | large | open | ui-frame | 1262.333/1269.000 | - | - | - | n/a | n/a | n/a | 1262.33 ms | 0 | measured |
| electron | large | input | ui-frame | 2.927/3.900 | - | 8.102/15.200 | 7.260/11.400 | n/a | n/a | n/a | 1263.67 ms | 1 | measured |
| electron | large | scroll | ui-frame | 3.251/4.700 | - | 7.667/7.700 | - | n/a | n/a | n/a | 1270.00 ms | 1 | measured |
| electron | stress | open | ui-frame | 1299.667/1312.000 | - | - | - | n/a | n/a | n/a | 1299.67 ms | 0 | measured |
| electron | stress | input | ui-frame | 3.040/4.500 | - | 8.771/16.372 | 7.387/12.300 | n/a | n/a | n/a | 1293.00 ms | 0 | measured |
| electron | stress | scroll | ui-frame | 3.364/4.800 | - | 7.701/7.800 | - | n/a | n/a | n/a | 1297.00 ms | 0 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 30.62/30.67/30.61 | 32.50/32.51/32.53 | 365/364/366 | 2.54/2.56/2.54 | 3.45/3.37/3.25 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 30.06/29.22/29.72 | 32.62/32.68/32.60 | 359/348/349 | 2.72/2.61/2.62 | 3.85/3.64/3.33 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 30.76/30.77/30.75 | 32.58/33.24/32.64 | 368/374/370 | 2.97/3.00/2.85 | 3.97/4.03/3.61 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 31.04/31.00/30.97 | 34.94/35.33/34.63 | 426/438/413 | 5.24/5.25/5.29 | 6.73/6.64/6.71 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 46.55/46.52/46.33 | 50.71/50.42/50.33 | 746/744/744 | 5.33/5.29/5.31 | 6.97/6.73/6.95 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 31.48/31.30/31.51 | 38.76/37.68/38.87 | 548/539/540 | 6.35/6.20/6.38 | 8.04/7.75/8.08 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 30.82/30.84/30.81 | 31.78/31.71/31.81 | n/a/n/a/n/a | 1.72/1.74/1.76 | 2.29/2.24/2.27 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.00/8.93/8.68 | 6.95/13.89/13.89 | 0/3/3 | 2.42/3.70/3.60 | 3.09/5.42/5.50 | 0.48/0.51/0.51 | 0.62/0.63/0.65 |
| Flutter Impeller | 7.00/9.51/9.32 | 6.95/13.89/13.89 | 0/4/2 | 2.53/3.93/3.85 | 3.18/5.84/5.80 | 1.15/1.23/1.21 | 1.46/1.58/1.50 |
| Electron | 7.60/7.66/7.67 | 7.80/7.70/7.70 | 0/0/1 | 3.11/3.32/3.25 | 4.70/4.70/4.70 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 30.63 | 32.41 | 366 | 2.55 | 3.50 | n/a | n/a |
| MoUI Skia GPU | 30.05 | 32.44 | 356 | 2.63 | 3.23 | n/a | n/a |
| MoUI WGPU | 30.79 | 33.06 | 374 | 3.02 | 3.76 | n/a | n/a |
| MoMark Skia Raster | 30.99 | 34.83 | 427 | 5.25 | 6.76 | n/a | n/a |
| MoMark Skia GPU | 46.44 | 50.61 | 749 | 5.28 | 6.86 | n/a | n/a |
| MoMark WGPU | 31.95 | 40.11 | 550 | 6.46 | 8.20 | n/a | n/a |
| GpMark.mbt (GPUI) | 30.77 | 31.73 | n/a | 1.78 | 2.38 | n/a | n/a |
| Flutter Skia | 9.20 | 13.89 | 0 | 3.78 | 5.51 | 0.53 | 0.63 |
| Flutter Impeller | 9.14 | 13.89 | 0 | 3.82 | 5.93 | 1.23 | 1.59 |
| Electron | 7.70 | 7.80 | 0 | 3.36 | 4.80 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 30.57/30.68/30.61 | 31.98/31.97/32.19 | 2.36/2.33/2.46 | 2.73/2.58/3.26 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 30.19/30.52/30.43 | 33.63/33.45/31.61 | 2.50/2.56/2.55 | 3.44/3.66/3.75 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 30.75/30.73/30.75 | 33.37/33.15/33.45 | 5.69/5.36/5.49 | 6.74/6.43/6.95 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 31.03/30.68/31.38 | 33.43/32.63/34.43 | 4.49/4.15/4.97 | 6.47/4.57/6.40 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 61.26/61.54/61.93 | 69.75/66.98/69.71 | 4.42/4.54/4.76 | 5.97/6.21/5.29 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 32.68/31.81/36.01 | 40.37/39.46/48.68 | 7.79/7.88/8.11 | 12.13/11.09/9.47 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 30.55/30.71/30.72 | 32.62/32.48/32.54 | 1.28/1.26/1.33 | 1.39/1.58/1.57 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.11/6.96/7.03 | 8.35/7.88/7.89 | 0.85/0.82/0.75 | 1.08/1.05/0.86 | 0.51/0.49/0.46 | 0.62/0.60/0.55 |
| Flutter Impeller | 7.09/7.03/7.10 | 8.74/8.31/8.70 | 0.98/0.82/0.86 | 1.37/0.99/1.10 | 1.41/1.28/1.31 | 1.94/1.60/1.81 |
| Electron | 7.30/7.68/7.26 | 11.30/15.50/11.40 | 2.85/3.03/2.93 | 4.40/4.80/3.90 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 31.00 | 32.27 | 2.34 | 2.86 | n/a | n/a |
| MoUI Skia GPU | 46.52 | 48.60 | 2.30 | 2.64 | n/a | n/a |
| MoUI WGPU | 39.91 | 46.52 | 5.54 | 6.82 | n/a | n/a |
| MoMark Skia Raster | 61.56 | 65.23 | 9.07 | 11.39 | n/a | n/a |
| MoMark Skia GPU | 77.50 | 79.70 | 8.86 | 9.84 | n/a | n/a |
| MoMark WGPU | 61.68 | 66.80 | 11.88 | 13.67 | n/a | n/a |
| GpMark.mbt (GPUI) | 29.94 | 31.60 | 1.27 | 1.51 | n/a | n/a |
| Flutter Skia | 6.96 | 7.92 | 0.83 | 1.03 | 0.48 | 0.55 |
| Flutter Impeller | 6.99 | 8.74 | 0.85 | 0.99 | 1.31 | 1.71 |
| Electron | 7.39 | 12.30 | 3.04 | 4.50 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 64.25/67.89/85.97 | 68.11/69.19/89.66 | 0.25/0.62/4.34 | 0.33/0.65/5.56 | 11.88/10.35/9.11 | 15.00/10.79/9.72 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 817.67/877.25/838.73 | 828.16/881.98/856.67 | 0.19/0.74/4.35 | 0.21/0.80/4.74 | 8.66/9.46/8.86 | 8.81/9.83/8.98 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 1210.21/1214.58/1256.14 | 1232.53/1234.01/1266.82 | 0.19/0.66/3.91 | 0.24/0.66/4.05 | 40.85/40.67/41.73 | 42.05/41.58/44.20 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 71.69/72.20/111.50 | 73.35/73.40/114.60 | 0.16/0.68/3.71 | 0.18/0.77/3.85 | 14.91/14.40/14.47 | 15.59/14.54/15.06 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 1010.01/1008.41/1051.44 | 1042.11/1016.81/1081.11 | 0.14/0.61/3.70 | 0.16/0.64/3.72 | 15.37/13.71/15.44 | 16.19/14.10/18.39 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 1243.20/1246.39/1285.54 | 1263.86/1254.47/1296.73 | 0.16/0.66/3.83 | 0.18/0.74/3.86 | 56.62/54.72/56.01 | 58.40/55.43/59.05 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 253.85/258.40/298.35 | 256.03/261.18/300.17 | 0.67/0.33/4.00 | 2.00/1.00/5.00 | 1.15/1.41/1.30 | 1.20/1.74/1.40 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 29.00/30.33/35.00 | 30.00/31.00/38.00 | 0.78/0.79/1.04 | 0.81/0.90/1.19 | 0.42/0.41/1.50 | 0.49/0.46/1.53 | 69.50/71.98/80.57 | 76.58/79.86/90.08 |
| Flutter Impeller | 29.33/30.67/36.00 | 30.00/32.00/38.00 | 0.78/0.85/1.15 | 0.89/0.95/1.23 | 0.48/0.44/1.62 | 0.52/0.50/1.71 | 57.55/54.27/54.82 | 64.56/64.95/56.27 |
| Electron | 1265.33/1250.67/1262.33 | 1275.00/1260.00/1269.00 | 3.23/3.54/3.89 | 3.69/3.91/4.33 | 1265.33/1250.67/1262.33 | 1275.00/1260.00/1269.00 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 438.71 | 478.77 | 43.23 | 48.68 | 9.78 | 10.18 | n/a | n/a |
| MoUI Skia GPU | 1163.18 | 1176.32 | 40.98 | 45.34 | 9.21 | 9.68 | n/a | n/a |
| MoUI WGPU | 1570.31 | 1574.93 | 37.92 | 39.07 | 40.38 | 42.02 | n/a | n/a |
| MoMark Skia Raster | 534.65 | 539.56 | 38.98 | 41.54 | 15.84 | 19.28 | n/a | n/a |
| MoMark Skia GPU | 1471.05 | 1490.95 | 38.91 | 40.39 | 13.79 | 14.27 | n/a | n/a |
| MoMark WGPU | 1712.14 | 1727.43 | 38.64 | 39.35 | 55.45 | 59.69 | n/a | n/a |
| GpMark.mbt (GPUI) | 696.61 | 699.96 | 38.33 | 39.00 | 1.29 | 1.38 | n/a | n/a |
| Flutter Skia | 87.33 | 88.00 | 3.24 | 3.45 | 0.42 | 0.42 | 81.63 | 90.34 |
| Flutter Impeller | 88.00 | 91.00 | 3.28 | 3.41 | 0.47 | 0.51 | 60.18 | 73.44 |
| Electron | 1299.67 | 1312.00 | 9.25 | 9.79 | 1299.67 | 1312.00 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 30.62/30.67/30.61 | 32.50/32.51/32.53 | 365/364/366 | 2.54/2.56/2.54 | 3.45/3.37/3.25 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 30.06/29.22/29.72 | 32.62/32.68/32.60 | 359/348/349 | 2.72/2.61/2.62 | 3.85/3.64/3.33 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 30.76/30.77/30.75 | 32.58/33.24/32.64 | 368/374/370 | 2.97/3.00/2.85 | 3.97/4.03/3.61 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 31.04/31.00/30.97 | 34.94/35.33/34.63 | 426/438/413 | 5.24/5.25/5.29 | 6.73/6.64/6.71 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 46.55/46.52/46.33 | 50.71/50.42/50.33 | 746/744/744 | 5.33/5.29/5.31 | 6.97/6.73/6.95 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 31.48/31.30/31.51 | 38.76/37.68/38.87 | 548/539/540 | 6.35/6.20/6.38 | 8.04/7.75/8.08 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 30.82/30.84/30.81 | 31.78/31.71/31.81 | n/a/n/a/n/a | 1.72/1.74/1.76 | 2.29/2.24/2.27 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.00/8.93/8.68 | 6.95/13.89/13.89 | 0/3/3 | 2.42/3.70/3.60 | 3.09/5.42/5.50 | 0.48/0.51/0.51 | 0.62/0.63/0.65 |
| Flutter Impeller | 7.00/9.51/9.32 | 6.95/13.89/13.89 | 0/4/2 | 2.53/3.93/3.85 | 3.18/5.84/5.80 | 1.15/1.23/1.21 | 1.46/1.58/1.50 |
| Electron | 7.60/7.66/7.67 | 7.80/7.70/7.70 | 0/0/1 | 3.11/3.32/3.25 | 4.70/4.70/4.70 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 30.63 | 32.41 | 366 | 2.55 | 3.50 | n/a | n/a |
| MoUI Skia GPU | 30.05 | 32.44 | 356 | 2.63 | 3.23 | n/a | n/a |
| MoUI WGPU | 30.79 | 33.06 | 374 | 3.02 | 3.76 | n/a | n/a |
| MoMark Skia Raster | 30.99 | 34.83 | 427 | 5.25 | 6.76 | n/a | n/a |
| MoMark Skia GPU | 46.44 | 50.61 | 749 | 5.28 | 6.86 | n/a | n/a |
| MoMark WGPU | 31.95 | 40.11 | 550 | 6.46 | 8.20 | n/a | n/a |
| GpMark.mbt (GPUI) | 30.77 | 31.73 | n/a | 1.78 | 2.38 | n/a | n/a |
| Flutter Skia | 9.20 | 13.89 | 0 | 3.78 | 5.51 | 0.53 | 0.63 |
| Flutter Impeller | 9.14 | 13.89 | 0 | 3.82 | 5.93 | 1.23 | 1.59 |
| Electron | 7.70 | 7.80 | 0 | 3.36 | 4.80 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoUI Skia Raster CPU stress 438.7 ms（max 478.8 ms）；MoUI Skia GPU small 817.7 ms（max 828.2 ms）；MoUI Skia GPU medium 877.3 ms（max 882.0 ms）；MoUI Skia GPU large 838.7 ms（max 856.7 ms）；MoUI Skia GPU stress 1163.2 ms（max 1176.3 ms）；MoUI WGPU small 1210.2 ms（max 1232.5 ms）；MoUI WGPU medium 1214.6 ms（max 1234.0 ms）；MoUI WGPU large 1256.1 ms（max 1266.8 ms）；MoUI WGPU stress 1570.3 ms（max 1574.9 ms）；MoMark Skia Raster large 111.5 ms（max 114.6 ms）；MoMark Skia Raster stress 534.6 ms（max 539.6 ms）；MoMark Skia GPU small 1010.0 ms（max 1042.1 ms）；MoMark Skia GPU medium 1008.4 ms（max 1016.8 ms）；MoMark Skia GPU large 1051.4 ms（max 1081.1 ms）；MoMark Skia GPU stress 1471.1 ms（max 1490.9 ms）；MoMark WGPU small 1243.2 ms（max 1263.9 ms）；MoMark WGPU medium 1246.4 ms（max 1254.5 ms）；MoMark WGPU large 1285.5 ms（max 1296.7 ms）；MoMark WGPU stress 1712.1 ms（max 1727.4 ms）；GpMark.mbt (GPUI) small 253.9 ms（max 256.0 ms）；GpMark.mbt (GPUI) medium 258.4 ms（max 261.2 ms）；GpMark.mbt (GPUI) large 298.4 ms（max 300.2 ms）；GpMark.mbt (GPUI) stress 696.6 ms（max 700.0 ms）；Electron small 1265.3 ms（max 1275.0 ms）；Electron medium 1250.7 ms（max 1260.0 ms）；Electron large 1262.3 ms（max 1269.0 ms）；Electron stress 1299.7 ms（max 1312.0 ms）。
- P1 输入尾延迟：MoUI Skia Raster CPU small P95 31.98 ms；MoUI Skia Raster CPU medium P95 31.97 ms；MoUI Skia Raster CPU large P95 32.19 ms；MoUI Skia Raster CPU stress P95 32.27 ms；MoUI Skia GPU small P95 33.63 ms；MoUI Skia GPU medium P95 33.45 ms；MoUI Skia GPU large P95 31.61 ms；MoUI Skia GPU stress P95 48.60 ms；MoUI WGPU small P95 33.37 ms；MoUI WGPU medium P95 33.15 ms；MoUI WGPU large P95 33.45 ms；MoUI WGPU stress P95 46.52 ms；MoMark Skia Raster small P95 33.43 ms；MoMark Skia Raster medium P95 32.63 ms；MoMark Skia Raster large P95 34.43 ms；MoMark Skia Raster stress P95 65.23 ms；MoMark Skia GPU small P95 69.75 ms；MoMark Skia GPU medium P95 66.98 ms；MoMark Skia GPU large P95 69.71 ms；MoMark Skia GPU stress P95 79.70 ms；MoMark WGPU small P95 40.37 ms；MoMark WGPU medium P95 39.46 ms；MoMark WGPU large P95 48.68 ms；MoMark WGPU stress P95 66.80 ms；GpMark.mbt (GPUI) small P95 32.62 ms；GpMark.mbt (GPUI) medium P95 32.48 ms；GpMark.mbt (GPUI) large P95 32.54 ms；GpMark.mbt (GPUI) stress P95 31.60 ms。
- 长帧（超预算）：MoUI Skia Raster CPU: small/input 30 次，max 33.42 ms, small/scroll 360 次，max 33.97 ms, medium/input 30 次，max 33.93 ms, medium/scroll 360 次，max 33.96 ms, large/input 30 次，max 32.99 ms, large/scroll 360 次，max 36.98 ms, stress/input 30 次，max 33.55 ms, stress/scroll 360 次，max 35.24 ms；MoUI Skia GPU: small/input 30 次，max 33.85 ms, small/scroll 356 次，max 34.02 ms, medium/input 30 次，max 37.71 ms, medium/scroll 337 次，max 34.09 ms, large/input 30 次，max 31.78 ms, large/scroll 340 次，max 34.14 ms, stress/input 30 次，max 49.28 ms, stress/scroll 351 次，max 34.19 ms；MoUI WGPU: small/input 30 次，max 37.73 ms, small/scroll 360 次，max 34.76 ms, medium/input 30 次，max 37.32 ms, medium/scroll 360 次，max 37.08 ms, large/input 30 次，max 34.49 ms, large/scroll 360 次，max 35.62 ms, stress/input 30 次，max 46.83 ms, stress/scroll 360 次，max 35.57 ms；MoMark Skia Raster: small/input 30 次，max 34.08 ms, small/scroll 360 次，max 39.20 ms, medium/input 30 次，max 32.79 ms, medium/scroll 360 次，max 42.31 ms, large/input 30 次，max 43.70 ms, large/scroll 360 次，max 41.45 ms, stress/input 30 次，max 68.53 ms, stress/scroll 360 次，max 41.83 ms；MoMark Skia GPU: small/input 30 次，max 70.01 ms, small/scroll 360 次，max 60.71 ms, medium/input 30 次，max 69.59 ms, medium/scroll 360 次，max 58.41 ms, large/input 30 次，max 71.30 ms, large/scroll 360 次，max 59.53 ms, stress/input 30 次，max 92.75 ms, stress/scroll 360 次，max 59.92 ms；MoMark WGPU: small/input 30 次，max 43.39 ms, small/scroll 360 次，max 44.97 ms, medium/input 30 次，max 42.22 ms, medium/scroll 360 次，max 42.71 ms, large/input 30 次，max 51.15 ms, large/scroll 360 次，max 47.82 ms, stress/input 30 次，max 67.61 ms, stress/scroll 360 次，max 49.24 ms；GpMark.mbt (GPUI): small/input 30 次，max 32.67 ms, small/scroll 360 次，max 32.81 ms, medium/input 30 次，max 32.71 ms, medium/scroll 360 次，max 32.85 ms, large/input 30 次，max 32.79 ms, large/scroll 360 次，max 32.68 ms, stress/input 30 次，max 32.12 ms, stress/scroll 360 次，max 32.78 ms；Flutter Skia: medium/scroll 1 次，max 62.50 ms, large/scroll 1 次，max 62.50 ms；Flutter Impeller: medium/scroll 2 次，max 48.61 ms, large/scroll 1 次，max 41.67 ms；Electron: small/input 1 次，max 18.27 ms, medium/input 1 次，max 21.47 ms, large/input 1 次，max 16.77 ms, large/scroll 1 次，max 17.64 ms。
- 丢帧（优先处理）：MoUI Skia Raster CPU: small/input 31 帧, small/scroll 365 帧, medium/input 31 帧, medium/scroll 364 帧, large/input 30 帧, large/scroll 366 帧, stress/input 31 帧, stress/scroll 366 帧；MoUI Skia GPU: small/input 32 帧, small/scroll 359 帧, medium/input 32 帧, medium/scroll 348 帧, large/input 30 帧, large/scroll 349 帧, stress/input 60 帧, stress/scroll 356 帧；MoUI WGPU: small/input 32 帧, small/scroll 368 帧, medium/input 31 帧, medium/scroll 374 帧, large/input 33 帧, large/scroll 370 帧, stress/input 48 帧, stress/scroll 374 帧；MoMark Skia Raster: small/input 32 帧, small/scroll 426 帧, medium/input 30 帧, medium/scroll 438 帧, large/input 33 帧, large/scroll 413 帧, stress/input 91 帧, stress/scroll 427 帧；MoMark Skia GPU: small/input 92 帧, small/scroll 746 帧, medium/input 92 帧, medium/scroll 744 帧, large/input 94 帧, large/scroll 744 帧, stress/input 121 帧, stress/scroll 749 帧；MoMark WGPU: small/input 38 帧, small/scroll 548 帧, medium/input 35 帧, medium/scroll 539 帧, large/input 43 帧, large/scroll 540 帧, stress/input 92 帧, stress/scroll 550 帧；Flutter Skia: medium/scroll 3 帧, large/scroll 3 帧；Flutter Impeller: medium/scroll 4 帧, large/scroll 2 帧；Electron: small/input 1 帧, medium/input 1 帧, large/input 1 帧, large/scroll 1 帧。
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
