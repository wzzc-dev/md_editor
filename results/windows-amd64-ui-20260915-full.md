# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-15T12:58:58Z`
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
| moui-skia-raster | small | open | ui-frame | 11.594/12.400 | - | - | - | n/a | n/a | n/a | 69.61 ms | 0 | measured |
| moui-skia-raster | small | input | ui-frame | 2.066/2.380 | - | 30.228/31.881 | 30.124/31.759 | n/a | n/a | n/a | 72.65 ms | 30 | measured |
| moui-skia-raster | small | scroll | ui-frame | 2.315/2.821 | - | 30.887/32.645 | - | n/a | n/a | n/a | 69.64 ms | 366 | measured |
| moui-skia-raster | medium | open | ui-frame | 11.081/11.718 | - | - | - | n/a | n/a | n/a | 73.37 ms | 0 | measured |
| moui-skia-raster | medium | input | ui-frame | 2.177/2.691 | - | 30.954/32.731 | 30.848/32.625 | n/a | n/a | n/a | 73.20 ms | 30 | measured |
| moui-skia-raster | medium | scroll | ui-frame | 2.366/3.080 | - | 30.836/32.540 | - | n/a | n/a | n/a | 63.60 ms | 363 | measured |
| moui-skia-raster | large | open | ui-frame | 9.862/10.399 | - | - | - | n/a | n/a | n/a | 90.30 ms | 0 | measured |
| moui-skia-raster | large | input | ui-frame | 2.314/3.417 | - | 30.902/33.484 | 30.781/33.483 | n/a | n/a | n/a | 91.87 ms | 32 | measured |
| moui-skia-raster | large | scroll | ui-frame | 2.350/2.972 | - | 30.825/32.483 | - | n/a | n/a | n/a | 89.94 ms | 364 | measured |
| moui-skia-raster | stress | open | ui-frame | 9.771/10.311 | - | - | - | n/a | n/a | n/a | 419.64 ms | 0 | measured |
| moui-skia-raster | stress | input | ui-frame | 2.142/2.529 | - | 31.162/32.682 | 31.061/32.580 | n/a | n/a | n/a | 411.05 ms | 30 | measured |
| moui-skia-raster | stress | scroll | ui-frame | 2.351/2.987 | - | 30.671/32.385 | - | n/a | n/a | n/a | 407.58 ms | 361 | measured |
| moui-skia-gpu | small | open | ui-frame | 9.619/10.211 | - | - | - | n/a | n/a | n/a | 820.50 ms | 0 | measured |
| moui-skia-gpu | small | input | ui-frame | 2.116/2.459 | - | 30.624/32.510 | 30.514/32.390 | n/a | n/a | n/a | 824.39 ms | 30 | measured |
| moui-skia-gpu | small | scroll | ui-frame | 2.339/3.070 | - | 27.904/32.525 | - | n/a | n/a | n/a | 829.07 ms | 315 | measured |
| moui-skia-gpu | medium | open | ui-frame | 9.650/10.182 | - | - | - | n/a | n/a | n/a | 833.88 ms | 0 | measured |
| moui-skia-gpu | medium | input | ui-frame | 2.140/2.506 | - | 30.985/32.657 | 30.871/32.545 | n/a | n/a | n/a | 846.75 ms | 30 | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 2.336/2.968 | - | 28.066/32.434 | - | n/a | n/a | n/a | 833.13 ms | 317 | measured |
| moui-skia-gpu | large | open | ui-frame | 9.084/9.425 | - | - | - | n/a | n/a | n/a | 869.93 ms | 0 | measured |
| moui-skia-gpu | large | input | ui-frame | 2.151/2.622 | - | 30.481/32.612 | 30.370/32.488 | n/a | n/a | n/a | 868.16 ms | 30 | measured |
| moui-skia-gpu | large | scroll | ui-frame | 2.363/3.053 | - | 28.509/32.222 | - | n/a | n/a | n/a | 864.61 ms | 330 | measured |
| moui-skia-gpu | stress | open | ui-frame | 8.955/9.188 | - | - | - | n/a | n/a | n/a | 1177.53 ms | 0 | measured |
| moui-skia-gpu | stress | input | ui-frame | 2.164/2.861 | - | 45.852/48.461 | 45.733/48.328 | n/a | n/a | n/a | 1192.87 ms | 60 | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 2.342/2.959 | - | 28.790/32.444 | - | n/a | n/a | n/a | 1180.11 ms | 329 | measured |
| moui-wgpu | small | open | ui-frame | 41.104/42.142 | - | - | - | n/a | n/a | n/a | 1359.58 ms | 0 | measured |
| moui-wgpu | small | input | ui-frame | 5.263/6.247 | - | 30.647/33.780 | 30.538/33.664 | n/a | n/a | n/a | 1356.49 ms | 33 | measured |
| moui-wgpu | small | scroll | ui-frame | 2.686/3.388 | - | 30.805/32.897 | - | n/a | n/a | n/a | 1360.60 ms | 371 | measured |
| moui-wgpu | medium | open | ui-frame | 41.936/44.768 | - | - | - | n/a | n/a | n/a | 1368.31 ms | 0 | measured |
| moui-wgpu | medium | input | ui-frame | 5.166/6.274 | - | 30.531/33.585 | 30.427/33.470 | n/a | n/a | n/a | 1380.98 ms | 32 | measured |
| moui-wgpu | medium | scroll | ui-frame | 2.751/3.617 | - | 30.916/32.604 | - | n/a | n/a | n/a | 1390.39 ms | 365 | measured |
| moui-wgpu | large | open | ui-frame | 40.703/41.327 | - | - | - | n/a | n/a | n/a | 1399.76 ms | 0 | measured |
| moui-wgpu | large | input | ui-frame | 4.962/5.659 | - | 30.828/33.354 | 30.713/33.230 | n/a | n/a | n/a | 1407.25 ms | 32 | measured |
| moui-wgpu | large | scroll | ui-frame | 2.661/3.415 | - | 30.742/32.230 | - | n/a | n/a | n/a | 1402.60 ms | 364 | measured |
| moui-wgpu | stress | open | ui-frame | 40.333/41.201 | - | - | - | n/a | n/a | n/a | 1735.87 ms | 0 | measured |
| moui-wgpu | stress | input | ui-frame | 5.055/6.041 | - | 41.077/48.092 | 40.972/47.986 | n/a | n/a | n/a | 1718.86 ms | 52 | measured |
| moui-wgpu | stress | scroll | ui-frame | 2.738/3.573 | - | 30.767/32.907 | - | n/a | n/a | n/a | 1725.60 ms | 369 | measured |
| moui-md-skia-raster | small | open | ui-frame | 14.995/15.035 | - | - | - | n/a | n/a | n/a | 74.45 ms | 0 | measured |
| moui-md-skia-raster | small | input | ui-frame | 3.971/4.451 | - | 30.939/32.534 | 30.847/32.533 | n/a | n/a | n/a | 73.24 ms | 31 | measured |
| moui-md-skia-raster | small | scroll | ui-frame | 4.785/5.964 | - | 30.954/34.191 | - | n/a | n/a | n/a | 72.55 ms | 405 | measured |
| moui-md-skia-raster | medium | open | ui-frame | 14.483/14.986 | - | - | - | n/a | n/a | n/a | 76.84 ms | 0 | measured |
| moui-md-skia-raster | medium | input | ui-frame | 4.040/4.916 | - | 30.754/33.338 | 30.662/33.245 | n/a | n/a | n/a | 77.02 ms | 32 | measured |
| moui-md-skia-raster | medium | scroll | ui-frame | 4.808/6.075 | - | 30.926/34.107 | - | n/a | n/a | n/a | 76.09 ms | 408 | measured |
| moui-md-skia-raster | large | open | ui-frame | 15.544/17.623 | - | - | - | n/a | n/a | n/a | 117.30 ms | 0 | measured |
| moui-md-skia-raster | large | input | ui-frame | 4.476/5.010 | - | 30.947/32.900 | 30.856/32.899 | n/a | n/a | n/a | 117.25 ms | 31 | measured |
| moui-md-skia-raster | large | scroll | ui-frame | 4.817/5.995 | - | 31.095/34.520 | - | n/a | n/a | n/a | 116.37 ms | 411 | measured |
| moui-md-skia-raster | stress | open | ui-frame | 14.805/14.995 | - | - | - | n/a | n/a | n/a | 526.46 ms | 0 | measured |
| moui-md-skia-raster | stress | input | ui-frame | 7.996/9.030 | - | 59.437/65.076 | 59.335/64.966 | n/a | n/a | n/a | 527.15 ms | 86 | measured |
| moui-md-skia-raster | stress | scroll | ui-frame | 4.847/6.150 | - | 31.102/34.612 | - | n/a | n/a | n/a | 533.90 ms | 416 | measured |
| moui-md-skia-gpu | small | open | ui-frame | 14.195/15.114 | - | - | - | n/a | n/a | n/a | 1044.27 ms | 0 | measured |
| moui-md-skia-gpu | small | input | ui-frame | 3.975/4.590 | - | 60.928/67.928 | 60.838/67.927 | n/a | n/a | n/a | 1021.10 ms | 92 | measured |
| moui-md-skia-gpu | small | scroll | ui-frame | 4.983/6.479 | - | 46.633/50.193 | - | n/a | n/a | n/a | 1018.15 ms | 739 | measured |
| moui-md-skia-gpu | medium | open | ui-frame | 14.118/14.418 | - | - | - | n/a | n/a | n/a | 1021.40 ms | 0 | measured |
| moui-md-skia-gpu | medium | input | ui-frame | 3.929/4.484 | - | 61.869/68.305 | 61.776/68.303 | n/a | n/a | n/a | 1015.81 ms | 93 | measured |
| moui-md-skia-gpu | medium | scroll | ui-frame | 5.033/6.616 | - | 47.393/54.554 | - | n/a | n/a | n/a | 1030.58 ms | 765 | measured |
| moui-md-skia-gpu | large | open | ui-frame | 13.962/14.150 | - | - | - | n/a | n/a | n/a | 1065.00 ms | 0 | measured |
| moui-md-skia-gpu | large | input | ui-frame | 4.516/6.206 | - | 61.746/66.896 | 61.652/66.895 | n/a | n/a | n/a | 1063.16 ms | 92 | measured |
| moui-md-skia-gpu | large | scroll | ui-frame | 4.956/6.344 | - | 46.883/50.669 | - | n/a | n/a | n/a | 1065.37 ms | 746 | measured |
| moui-md-skia-gpu | stress | open | ui-frame | 14.314/15.320 | - | - | - | n/a | n/a | n/a | 1481.57 ms | 0 | measured |
| moui-md-skia-gpu | stress | input | ui-frame | 8.293/9.211 | - | 78.926/88.806 | 78.831/88.660 | n/a | n/a | n/a | 1483.57 ms | 124 | measured |
| moui-md-skia-gpu | stress | scroll | ui-frame | 4.934/6.142 | - | 46.690/50.190 | - | n/a | n/a | n/a | 1485.77 ms | 739 | measured |
| moui-md-wgpu | small | open | ui-frame | 54.407/54.909 | - | - | - | n/a | n/a | n/a | 1387.33 ms | 0 | measured |
| moui-md-wgpu | small | input | ui-frame | 7.816/9.127 | - | 32.035/39.449 | 31.939/39.448 | n/a | n/a | n/a | 1443.27 ms | 35 | measured |
| moui-md-wgpu | small | scroll | ui-frame | 5.922/7.667 | - | 31.342/36.574 | - | n/a | n/a | n/a | 1375.74 ms | 517 | measured |
| moui-md-wgpu | medium | open | ui-frame | 53.398/53.893 | - | - | - | n/a | n/a | n/a | 1384.68 ms | 0 | measured |
| moui-md-wgpu | medium | input | ui-frame | 7.387/8.447 | - | 32.536/41.494 | 32.435/41.365 | n/a | n/a | n/a | 1387.66 ms | 37 | measured |
| moui-md-wgpu | medium | scroll | ui-frame | 5.806/7.196 | - | 31.102/36.034 | - | n/a | n/a | n/a | 1384.93 ms | 516 | measured |
| moui-md-wgpu | large | open | ui-frame | 58.111/63.821 | - | - | - | n/a | n/a | n/a | 1421.78 ms | 0 | measured |
| moui-md-wgpu | large | input | ui-frame | 7.935/9.263 | - | 34.620/45.294 | 34.522/45.199 | n/a | n/a | n/a | 1420.28 ms | 41 | measured |
| moui-md-wgpu | large | scroll | ui-frame | 5.945/7.745 | - | 31.221/36.843 | - | n/a | n/a | n/a | 1425.84 ms | 529 | measured |
| moui-md-wgpu | stress | open | ui-frame | 55.121/57.026 | - | - | - | n/a | n/a | n/a | 1831.71 ms | 0 | measured |
| moui-md-wgpu | stress | input | ui-frame | 11.766/13.602 | - | 61.811/66.941 | 61.717/66.940 | n/a | n/a | n/a | 1841.29 ms | 92 | measured |
| moui-md-wgpu | stress | scroll | ui-frame | 6.027/7.867 | - | 31.159/37.030 | - | n/a | n/a | n/a | 1822.12 ms | 531 | measured |
| gpmark | small | open | ui-frame | 1.191/1.281 | - | - | - | n/a | n/a | n/a | 254.84 ms | n/a | measured |
| gpmark | small | input | ui-frame | 1.081/1.319 | 0.385/0.511 | 6.802/7.716 | 6.800/7.715 | n/a | n/a | n/a | 256.85 ms | n/a | measured |
| gpmark | small | scroll | ui-frame | 1.445/1.964 | 0.000/0.001 | 6.942/7.410 | - | n/a | n/a | n/a | 256.60 ms | n/a | measured |
| gpmark | medium | open | ui-frame | 2.001/3.009 | - | - | - | n/a | n/a | n/a | 263.60 ms | n/a | measured |
| gpmark | medium | input | ui-frame | 1.081/1.322 | 0.473/0.676 | 6.859/7.663 | 6.857/7.663 | n/a | n/a | n/a | 257.51 ms | n/a | measured |
| gpmark | medium | scroll | ui-frame | 1.497/2.001 | 0.000/0.001 | 6.935/7.457 | - | n/a | n/a | n/a | 260.55 ms | n/a | measured |
| gpmark | large | open | ui-frame | 1.423/1.929 | - | - | - | n/a | n/a | n/a | 309.85 ms | n/a | measured |
| gpmark | large | input | ui-frame | 1.124/1.318 | 1.591/1.917 | 6.840/7.554 | 6.838/7.553 | n/a | n/a | n/a | 299.61 ms | n/a | measured |
| gpmark | large | scroll | ui-frame | 1.451/1.934 | 0.000/0.001 | 6.931/7.373 | - | n/a | n/a | n/a | 302.42 ms | n/a | measured |
| gpmark | stress | open | ui-frame | 1.245/1.337 | - | - | - | n/a | n/a | n/a | 694.42 ms | n/a | measured |
| gpmark | stress | input | ui-frame | 1.111/1.381 | 15.268/17.386 | 15.656/18.859 | 15.655/18.859 | n/a | n/a | n/a | 692.27 ms | n/a | measured |
| gpmark | stress | scroll | ui-frame | 1.429/1.963 | 0.000/0.001 | 6.943/7.487 | - | n/a | n/a | n/a | 678.67 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 0.442/0.471 | - | - | - | 43.76 ms | n/a | n/a | 29.33 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 0.802/0.968 | - | 6.945/6.945 | 7.054/8.959 | 0.49 ms | n/a | n/a | 29.33 ms | 0 | measured |
| flutter-skia | small | scroll | ui-frame | 2.448/3.100 | - | 7.060/6.945 | - | 0.54 ms | n/a | n/a | 29.33 ms | 0 | measured |
| flutter-skia | medium | open | ui-frame | 0.491/0.559 | - | - | - | 44.16 ms | n/a | n/a | 29.00 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 0.833/0.939 | - | 6.945/6.945 | 7.118/8.435 | 0.51 ms | n/a | n/a | 30.67 ms | 0 | measured |
| flutter-skia | medium | scroll | ui-frame | 3.726/5.694 | - | 9.066/13.889 | - | 0.54 ms | n/a | n/a | 29.00 ms | 0 | measured |
| flutter-skia | large | open | ui-frame | 1.507/1.711 | - | - | - | 39.56 ms | n/a | n/a | 34.33 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 0.824/0.944 | - | 6.944/6.945 | 7.066/8.811 | 0.49 ms | n/a | n/a | 35.33 ms | 0 | measured |
| flutter-skia | large | scroll | ui-frame | 3.783/5.660 | - | 8.931/13.889 | - | 0.54 ms | n/a | n/a | 34.67 ms | 0 | measured |
| flutter-skia | stress | open | ui-frame | 0.482/0.603 | - | - | - | 42.72 ms | n/a | n/a | 88.33 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 0.799/0.927 | - | 6.944/6.945 | 7.042/7.798 | 0.50 ms | n/a | n/a | 90.67 ms | 0 | measured |
| flutter-skia | stress | scroll | ui-frame | 3.775/5.800 | - | 9.047/13.889 | - | 0.53 ms | n/a | n/a | 90.67 ms | 0 | measured |
| flutter-impeller | small | open | ui-frame | 0.439/0.509 | - | - | - | 20.23 ms | n/a | n/a | 29.33 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 0.994/1.954 | - | 6.713/6.945 | 6.811/8.520 | 1.43 ms | n/a | n/a | 30.33 ms | 0 | measured |
| flutter-impeller | small | scroll | ui-frame | 2.526/3.168 | - | 7.070/6.945 | - | 1.27 ms | n/a | n/a | 30.00 ms | 0 | measured |
| flutter-impeller | medium | open | ui-frame | 0.422/0.462 | - | - | - | 22.99 ms | n/a | n/a | 31.00 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 0.898/1.326 | - | 6.945/6.945 | 6.996/8.583 | 1.27 ms | n/a | n/a | 30.33 ms | 0 | measured |
| flutter-impeller | medium | scroll | ui-frame | 3.806/6.073 | - | 9.541/13.889 | - | 1.29 ms | n/a | n/a | 30.67 ms | 0 | measured |
| flutter-impeller | large | open | ui-frame | 1.469/1.515 | - | - | - | 22.13 ms | n/a | n/a | 36.33 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 0.943/1.271 | - | 6.945/6.945 | 7.094/9.190 | 1.30 ms | n/a | n/a | 36.33 ms | 0 | measured |
| flutter-impeller | large | scroll | ui-frame | 3.893/5.892 | - | 9.656/13.889 | - | 1.26 ms | n/a | n/a | 36.00 ms | 0 | measured |
| flutter-impeller | stress | open | ui-frame | 0.419/0.427 | - | - | - | 20.96 ms | n/a | n/a | 92.00 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 0.957/1.415 | - | 6.945/6.945 | 7.144/8.695 | 1.30 ms | n/a | n/a | 90.00 ms | 0 | measured |
| flutter-impeller | stress | scroll | ui-frame | 3.850/5.668 | - | 9.248/13.890 | - | 1.24 ms | n/a | n/a | 91.33 ms | 0 | measured |
| electron | small | open | ui-frame | 1283.667/1298.000 | - | - | - | n/a | n/a | n/a | 1283.67 ms | 0 | measured |
| electron | small | input | ui-frame | 2.993/4.600 | - | 8.197/13.900 | 6.650/13.400 | n/a | n/a | n/a | 1283.67 ms | 0 | measured |
| electron | small | scroll | ui-frame | 3.176/4.600 | - | 7.265/7.100 | - | n/a | n/a | n/a | 1279.67 ms | 3 | measured |
| electron | medium | open | ui-frame | 1271.000/1280.000 | - | - | - | n/a | n/a | n/a | 1271.00 ms | 0 | measured |
| electron | medium | input | ui-frame | 2.913/4.600 | - | 7.504/13.800 | 6.657/13.400 | n/a | n/a | n/a | 1262.33 ms | 0 | measured |
| electron | medium | scroll | ui-frame | 3.349/4.500 | - | 7.277/7.100 | - | n/a | n/a | n/a | 1265.33 ms | 3 | measured |
| electron | large | open | ui-frame | 1280.333/1299.000 | - | - | - | n/a | n/a | n/a | 1280.33 ms | 0 | measured |
| electron | large | input | ui-frame | 2.967/4.300 | - | 7.638/13.800 | 6.937/15.000 | n/a | n/a | n/a | 1277.67 ms | 0 | measured |
| electron | large | scroll | ui-frame | 3.303/4.600 | - | 7.335/8.338 | - | n/a | n/a | n/a | 1274.33 ms | 3 | measured |
| electron | stress | open | ui-frame | 1292.333/1304.000 | - | - | - | n/a | n/a | n/a | 1292.33 ms | 0 | measured |
| electron | stress | input | ui-frame | 2.940/4.400 | - | 8.424/13.900 | 7.120/16.600 | n/a | n/a | n/a | 1292.33 ms | 0 | measured |
| electron | stress | scroll | ui-frame | 3.356/4.500 | - | 7.315/7.100 | - | n/a | n/a | n/a | 1299.67 ms | 4 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 30.89/30.84/30.83 | 32.64/32.54/32.48 | 366/363/364 | 2.32/2.37/2.35 | 2.82/3.08/2.97 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 27.90/28.07/28.51 | 32.53/32.43/32.22 | 315/317/330 | 2.34/2.34/2.36 | 3.07/2.97/3.05 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 30.81/30.92/30.74 | 32.90/32.60/32.23 | 371/365/364 | 2.69/2.75/2.66 | 3.39/3.62/3.42 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 30.95/30.93/31.09 | 34.19/34.11/34.52 | 405/408/411 | 4.78/4.81/4.82 | 5.96/6.07/5.99 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 46.63/47.39/46.88 | 50.19/54.55/50.67 | 739/765/746 | 4.98/5.03/4.96 | 6.48/6.62/6.34 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 31.34/31.10/31.22 | 36.57/36.03/36.84 | 517/516/529 | 5.92/5.81/5.94 | 7.67/7.20/7.75 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 6.94/6.93/6.93 | 7.41/7.46/7.37 | n/a/n/a/n/a | 1.45/1.50/1.45 | 1.96/2.00/1.93 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.06/9.07/8.93 | 6.95/13.89/13.89 | 0/0/0 | 2.45/3.73/3.78 | 3.10/5.69/5.66 | 0.54/0.54/0.54 | 0.75/0.74/0.70 |
| Flutter Impeller | 7.07/9.54/9.66 | 6.95/13.89/13.89 | 0/0/0 | 2.53/3.81/3.89 | 3.17/6.07/5.89 | 1.27/1.29/1.26 | 1.66/1.82/1.72 |
| Electron | 7.27/7.28/7.33 | 7.10/7.10/8.34 | 3/3/3 | 3.18/3.35/3.30 | 4.60/4.50/4.60 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 30.67 | 32.38 | 361 | 2.35 | 2.99 | n/a | n/a |
| MoUI Skia GPU | 28.79 | 32.44 | 329 | 2.34 | 2.96 | n/a | n/a |
| MoUI WGPU | 30.77 | 32.91 | 369 | 2.74 | 3.57 | n/a | n/a |
| MoMark Skia Raster | 31.10 | 34.61 | 416 | 4.85 | 6.15 | n/a | n/a |
| MoMark Skia GPU | 46.69 | 50.19 | 739 | 4.93 | 6.14 | n/a | n/a |
| MoMark WGPU | 31.16 | 37.03 | 531 | 6.03 | 7.87 | n/a | n/a |
| GpMark.mbt (GPUI) | 6.94 | 7.49 | n/a | 1.43 | 1.96 | n/a | n/a |
| Flutter Skia | 9.05 | 13.89 | 0 | 3.77 | 5.80 | 0.53 | 0.69 |
| Flutter Impeller | 9.25 | 13.89 | 0 | 3.85 | 5.67 | 1.24 | 1.63 |
| Electron | 7.32 | 7.10 | 4 | 3.36 | 4.50 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 30.12/30.85/30.78 | 31.76/32.62/33.48 | 2.07/2.18/2.31 | 2.38/2.69/3.42 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 30.51/30.87/30.37 | 32.39/32.54/32.49 | 2.12/2.14/2.15 | 2.46/2.51/2.62 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 30.54/30.43/30.71 | 33.66/33.47/33.23 | 5.26/5.17/4.96 | 6.25/6.27/5.66 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 30.85/30.66/30.86 | 32.53/33.24/32.90 | 3.97/4.04/4.48 | 4.45/4.92/5.01 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 60.84/61.78/61.65 | 67.93/68.30/66.90 | 3.98/3.93/4.52 | 4.59/4.48/6.21 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 31.94/32.44/34.52 | 39.45/41.37/45.20 | 7.82/7.39/7.94 | 9.13/8.45/9.26 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 6.80/6.86/6.84 | 7.71/7.66/7.55 | 1.08/1.08/1.12 | 1.32/1.32/1.32 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.05/7.12/7.07 | 8.96/8.44/8.81 | 0.80/0.83/0.82 | 0.97/0.94/0.94 | 0.49/0.51/0.49 | 0.56/0.60/0.60 |
| Flutter Impeller | 6.81/7.00/7.09 | 8.52/8.58/9.19 | 0.99/0.90/0.94 | 1.95/1.33/1.27 | 1.43/1.27/1.30 | 2.02/1.69/1.79 |
| Electron | 6.65/6.66/6.94 | 13.40/13.40/15.00 | 2.99/2.91/2.97 | 4.60/4.60/4.30 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 31.06 | 32.58 | 2.14 | 2.53 | n/a | n/a |
| MoUI Skia GPU | 45.73 | 48.33 | 2.16 | 2.86 | n/a | n/a |
| MoUI WGPU | 40.97 | 47.99 | 5.05 | 6.04 | n/a | n/a |
| MoMark Skia Raster | 59.33 | 64.97 | 8.00 | 9.03 | n/a | n/a |
| MoMark Skia GPU | 78.83 | 88.66 | 8.29 | 9.21 | n/a | n/a |
| MoMark WGPU | 61.72 | 66.94 | 11.77 | 13.60 | n/a | n/a |
| GpMark.mbt (GPUI) | 15.65 | 18.86 | 1.11 | 1.38 | n/a | n/a |
| Flutter Skia | 7.04 | 7.80 | 0.80 | 0.93 | 0.50 | 0.64 |
| Flutter Impeller | 7.14 | 8.70 | 0.96 | 1.42 | 1.30 | 1.99 |
| Electron | 7.12 | 16.60 | 2.94 | 4.40 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 69.61/73.37/90.30 | 70.43/75.29/92.33 | 0.24/0.69/3.74 | 0.30/0.76/3.87 | 11.59/11.08/9.86 | 12.40/11.72/10.40 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 820.50/833.88/869.93 | 821.68/843.59/873.19 | 0.17/0.62/3.89 | 0.20/0.64/4.34 | 9.62/9.65/9.08 | 10.21/10.18/9.42 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 1359.58/1368.31/1399.76 | 1377.35/1376.44/1416.76 | 0.17/0.71/4.18 | 0.18/0.86/4.95 | 41.10/41.94/40.70 | 42.14/44.77/41.33 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 74.45/76.84/117.30 | 75.43/76.98/119.60 | 0.15/0.61/4.02 | 0.17/0.64/4.34 | 15.00/14.48/15.54 | 15.04/14.99/17.62 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 1044.27/1021.40/1065.00 | 1095.46/1029.78/1079.21 | 0.18/0.60/4.53 | 0.25/0.62/5.94 | 14.20/14.12/13.96 | 15.11/14.42/14.15 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 1387.33/1384.68/1421.78 | 1402.88/1391.96/1435.44 | 0.17/0.58/3.61 | 0.23/0.60/3.68 | 54.41/53.40/58.11 | 54.91/53.89/63.82 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 254.84/263.60/309.85 | 256.69/268.13/323.33 | 0.00/1.33/3.67 | 0.00/2.00/4.00 | 1.19/2.00/1.42 | 1.28/3.01/1.93 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 29.33/29.00/34.33 | 30.00/30.00/36.00 | 0.84/0.99/1.07 | 0.90/1.20/1.15 | 0.44/0.49/1.51 | 0.47/0.56/1.71 | 43.76/44.16/39.56 | 45.26/45.05/41.35 |
| Flutter Impeller | 29.33/31.00/36.33 | 30.00/32.00/37.00 | 0.80/0.86/1.23 | 0.94/0.95/1.27 | 0.44/0.42/1.47 | 0.51/0.46/1.51 | 20.23/22.99/22.13 | 23.77/23.73/23.98 |
| Electron | 1283.67/1271.00/1280.33 | 1298.00/1280.00/1299.00 | 3.64/3.73/4.10 | 4.20/4.23/4.59 | 1283.67/1271.00/1280.33 | 1298.00/1280.00/1299.00 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 419.64 | 425.64 | 40.31 | 43.75 | 9.77 | 10.31 | n/a | n/a |
| MoUI Skia GPU | 1177.53 | 1196.73 | 38.77 | 40.71 | 8.95 | 9.19 | n/a | n/a |
| MoUI WGPU | 1735.87 | 1791.85 | 42.04 | 49.30 | 40.33 | 41.20 | n/a | n/a |
| MoMark Skia Raster | 526.46 | 528.59 | 38.94 | 40.63 | 14.80 | 14.99 | n/a | n/a |
| MoMark Skia GPU | 1481.57 | 1501.84 | 38.43 | 39.32 | 14.31 | 15.32 | n/a | n/a |
| MoMark WGPU | 1831.71 | 1838.97 | 39.77 | 44.66 | 55.12 | 57.03 | n/a | n/a |
| GpMark.mbt (GPUI) | 694.42 | 726.93 | 36.67 | 37.00 | 1.25 | 1.34 | n/a | n/a |
| Flutter Skia | 88.33 | 92.00 | 3.44 | 3.48 | 0.48 | 0.60 | 42.72 | 44.36 |
| Flutter Impeller | 92.00 | 104.00 | 3.83 | 4.65 | 0.42 | 0.43 | 20.96 | 22.29 |
| Electron | 1292.33 | 1304.00 | 9.39 | 9.59 | 1292.33 | 1304.00 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 30.89/30.84/30.83 | 32.64/32.54/32.48 | 366/363/364 | 2.32/2.37/2.35 | 2.82/3.08/2.97 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 27.90/28.07/28.51 | 32.53/32.43/32.22 | 315/317/330 | 2.34/2.34/2.36 | 3.07/2.97/3.05 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 30.81/30.92/30.74 | 32.90/32.60/32.23 | 371/365/364 | 2.69/2.75/2.66 | 3.39/3.62/3.42 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 30.95/30.93/31.09 | 34.19/34.11/34.52 | 405/408/411 | 4.78/4.81/4.82 | 5.96/6.07/5.99 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 46.63/47.39/46.88 | 50.19/54.55/50.67 | 739/765/746 | 4.98/5.03/4.96 | 6.48/6.62/6.34 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 31.34/31.10/31.22 | 36.57/36.03/36.84 | 517/516/529 | 5.92/5.81/5.94 | 7.67/7.20/7.75 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 6.94/6.93/6.93 | 7.41/7.46/7.37 | n/a/n/a/n/a | 1.45/1.50/1.45 | 1.96/2.00/1.93 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.06/9.07/8.93 | 6.95/13.89/13.89 | 0/0/0 | 2.45/3.73/3.78 | 3.10/5.69/5.66 | 0.54/0.54/0.54 | 0.75/0.74/0.70 |
| Flutter Impeller | 7.07/9.54/9.66 | 6.95/13.89/13.89 | 0/0/0 | 2.53/3.81/3.89 | 3.17/6.07/5.89 | 1.27/1.29/1.26 | 1.66/1.82/1.72 |
| Electron | 7.27/7.28/7.33 | 7.10/7.10/8.34 | 3/3/3 | 3.18/3.35/3.30 | 4.60/4.50/4.60 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 30.67 | 32.38 | 361 | 2.35 | 2.99 | n/a | n/a |
| MoUI Skia GPU | 28.79 | 32.44 | 329 | 2.34 | 2.96 | n/a | n/a |
| MoUI WGPU | 30.77 | 32.91 | 369 | 2.74 | 3.57 | n/a | n/a |
| MoMark Skia Raster | 31.10 | 34.61 | 416 | 4.85 | 6.15 | n/a | n/a |
| MoMark Skia GPU | 46.69 | 50.19 | 739 | 4.93 | 6.14 | n/a | n/a |
| MoMark WGPU | 31.16 | 37.03 | 531 | 6.03 | 7.87 | n/a | n/a |
| GpMark.mbt (GPUI) | 6.94 | 7.49 | n/a | 1.43 | 1.96 | n/a | n/a |
| Flutter Skia | 9.05 | 13.89 | 0 | 3.77 | 5.80 | 0.53 | 0.69 |
| Flutter Impeller | 9.25 | 13.89 | 0 | 3.85 | 5.67 | 1.24 | 1.63 |
| Electron | 7.32 | 7.10 | 4 | 3.36 | 4.50 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoUI Skia Raster CPU stress 419.6 ms（max 425.6 ms）；MoUI Skia GPU small 820.5 ms（max 821.7 ms）；MoUI Skia GPU medium 833.9 ms（max 843.6 ms）；MoUI Skia GPU large 869.9 ms（max 873.2 ms）；MoUI Skia GPU stress 1177.5 ms（max 1196.7 ms）；MoUI WGPU small 1359.6 ms（max 1377.3 ms）；MoUI WGPU medium 1368.3 ms（max 1376.4 ms）；MoUI WGPU large 1399.8 ms（max 1416.8 ms）；MoUI WGPU stress 1735.9 ms（max 1791.8 ms）；MoMark Skia Raster large 117.3 ms（max 119.6 ms）；MoMark Skia Raster stress 526.5 ms（max 528.6 ms）；MoMark Skia GPU small 1044.3 ms（max 1095.5 ms）；MoMark Skia GPU medium 1021.4 ms（max 1029.8 ms）；MoMark Skia GPU large 1065.0 ms（max 1079.2 ms）；MoMark Skia GPU stress 1481.6 ms（max 1501.8 ms）；MoMark WGPU small 1387.3 ms（max 1402.9 ms）；MoMark WGPU medium 1384.7 ms（max 1392.0 ms）；MoMark WGPU large 1421.8 ms（max 1435.4 ms）；MoMark WGPU stress 1831.7 ms（max 1839.0 ms）；GpMark.mbt (GPUI) small 254.8 ms（max 256.7 ms）；GpMark.mbt (GPUI) medium 263.6 ms（max 268.1 ms）；GpMark.mbt (GPUI) large 309.8 ms（max 323.3 ms）；GpMark.mbt (GPUI) stress 694.4 ms（max 726.9 ms）；Flutter Impeller stress 92.0 ms（max 104.0 ms）；Electron small 1283.7 ms（max 1298.0 ms）；Electron medium 1271.0 ms（max 1280.0 ms）；Electron large 1280.3 ms（max 1299.0 ms）；Electron stress 1292.3 ms（max 1304.0 ms）。
- P1 输入尾延迟：MoUI Skia Raster CPU small P95 31.76 ms；MoUI Skia Raster CPU medium P95 32.62 ms；MoUI Skia Raster CPU large P95 33.48 ms；MoUI Skia Raster CPU stress P95 32.58 ms；MoUI Skia GPU small P95 32.39 ms；MoUI Skia GPU medium P95 32.54 ms；MoUI Skia GPU large P95 32.49 ms；MoUI Skia GPU stress P95 48.33 ms；MoUI WGPU small P95 33.66 ms；MoUI WGPU medium P95 33.47 ms；MoUI WGPU large P95 33.23 ms；MoUI WGPU stress P95 47.99 ms；MoMark Skia Raster small P95 32.53 ms；MoMark Skia Raster medium P95 33.24 ms；MoMark Skia Raster large P95 32.90 ms；MoMark Skia Raster stress P95 64.97 ms；MoMark Skia GPU small P95 67.93 ms；MoMark Skia GPU medium P95 68.30 ms；MoMark Skia GPU large P95 66.90 ms；MoMark Skia GPU stress P95 88.66 ms；MoMark WGPU small P95 39.45 ms；MoMark WGPU medium P95 41.37 ms；MoMark WGPU large P95 45.20 ms；MoMark WGPU stress P95 66.94 ms；GpMark.mbt (GPUI) stress P95 18.86 ms。
- 长帧（超预算）：MoUI Skia Raster CPU: small/input 30 次，max 32.01 ms, small/scroll 359 次，max 35.12 ms, medium/input 30 次，max 33.06 ms, medium/scroll 360 次，max 34.71 ms, large/input 30 次，max 34.81 ms, large/scroll 359 次，max 34.24 ms, stress/input 30 次，max 32.90 ms, stress/scroll 359 次，max 34.47 ms；MoUI Skia GPU: small/input 30 次，max 32.51 ms, small/scroll 302 次，max 36.17 ms, medium/input 30 次，max 33.08 ms, medium/scroll 317 次，max 33.30 ms, large/input 30 次，max 32.77 ms, large/scroll 324 次，max 33.79 ms, stress/input 30 次，max 48.76 ms, stress/scroll 326 次，max 34.74 ms；MoUI WGPU: small/input 30 次，max 34.55 ms, small/scroll 360 次，max 35.36 ms, medium/input 30 次，max 34.38 ms, medium/scroll 360 次，max 35.10 ms, large/input 30 次，max 33.51 ms, large/scroll 360 次，max 35.09 ms, stress/input 30 次，max 48.28 ms, stress/scroll 360 次，max 34.68 ms；MoMark Skia Raster: small/input 30 次，max 33.52 ms, small/scroll 360 次，max 40.82 ms, medium/input 30 次，max 33.42 ms, medium/scroll 360 次，max 39.67 ms, large/input 30 次，max 33.64 ms, large/scroll 360 次，max 45.78 ms, stress/input 30 次，max 74.81 ms, stress/scroll 360 次，max 43.79 ms；MoMark Skia GPU: small/input 30 次，max 69.84 ms, small/scroll 360 次，max 62.50 ms, medium/input 30 次，max 69.20 ms, medium/scroll 360 次，max 64.20 ms, large/input 30 次，max 67.31 ms, large/scroll 360 次，max 58.66 ms, stress/input 30 次，max 91.10 ms, stress/scroll 360 次，max 59.76 ms；MoMark WGPU: small/input 30 次，max 42.36 ms, small/scroll 360 次，max 49.59 ms, medium/input 30 次，max 47.47 ms, medium/scroll 360 次，max 42.84 ms, large/input 30 次，max 47.19 ms, large/scroll 360 次，max 40.70 ms, stress/input 30 次，max 67.91 ms, stress/scroll 360 次，max 41.28 ms；GpMark.mbt (GPUI): stress/input 12 次，max 20.90 ms；Electron: small/scroll 3 次，max 20.90 ms, medium/scroll 3 次，max 20.90 ms, large/scroll 3 次，max 20.90 ms, stress/scroll 4 次，max 20.90 ms。
- 丢帧（优先处理）：MoUI Skia Raster CPU: small/input 30 帧, small/scroll 366 帧, medium/input 30 帧, medium/scroll 363 帧, large/input 32 帧, large/scroll 364 帧, stress/input 30 帧, stress/scroll 361 帧；MoUI Skia GPU: small/input 30 帧, small/scroll 315 帧, medium/input 30 帧, medium/scroll 317 帧, large/input 30 帧, large/scroll 330 帧, stress/input 60 帧, stress/scroll 329 帧；MoUI WGPU: small/input 33 帧, small/scroll 371 帧, medium/input 32 帧, medium/scroll 365 帧, large/input 32 帧, large/scroll 364 帧, stress/input 52 帧, stress/scroll 369 帧；MoMark Skia Raster: small/input 31 帧, small/scroll 405 帧, medium/input 32 帧, medium/scroll 408 帧, large/input 31 帧, large/scroll 411 帧, stress/input 86 帧, stress/scroll 416 帧；MoMark Skia GPU: small/input 92 帧, small/scroll 739 帧, medium/input 93 帧, medium/scroll 765 帧, large/input 92 帧, large/scroll 746 帧, stress/input 124 帧, stress/scroll 739 帧；MoMark WGPU: small/input 35 帧, small/scroll 517 帧, medium/input 37 帧, medium/scroll 516 帧, large/input 41 帧, large/scroll 529 帧, stress/input 92 帧, stress/scroll 531 帧；Electron: small/scroll 3 帧, medium/scroll 3 帧, large/scroll 3 帧, stress/scroll 4 帧。
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
