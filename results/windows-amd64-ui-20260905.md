# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-05T16:08:47Z`
- 数据状态：`360 measured`，`0 skipped/error`；原始样本保留在 JSON。
- Host：`Windows-11-10.0.26200-SP0` / `AMD64` / `15.89 GiB`；GPU：`OrayIddDriver Device`
- OS：`11`；CPU：`AMD64 Family 25 Model 33 Stepping 2, AuthenticAMD`；toolchains：`python=3.12.10, moon=moon 0.1.20260824 (dae026a 2026-08-24), rustc=rustc 1.92.0 (ded5c06cf 2025-12-08), cargo=cargo 1.92.0 (344c4567c 2025-10-21), node=v22.20.0`
- 统一配置：`1280x800 @ 60 Hz`；font `system-ui 16px`；line-height `1.55`；overscan `3`；fixed row `66px`；GPU backend `Direct3D`
- Fixture：`small=5KB/100 blocks`，`medium=50KB/1,000 blocks`，`large=500KB/10,000 blocks`，`stress=5MB/100,000 blocks`。
- 本次执行集合：`small, medium, large, stress`；未执行集合在矩阵中显示 `n/a`，不参与比较。
- 汇总口径：mean/P95 合并原始样本；每格 repetition `3`、process warm-up `1`；drop 为各 repetition dropped_display_frames 之和。
- 公平性口径：所有 ui-frame 记录使用相同 fixture、viewport、动作数、warm-up 和重复次数。`工作`（frame_work）统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏：MoUI 为 build+layout+paint+draw，Flutter 为 UI 线程 buildDuration，GPUI 为 request_layout→prepaint→paint，Electron 为 JS 可见的 DOM 更新+layout。设备光栅化与上屏统一单列为 `设备侧`（device_present）：MoUI 为同步光栅化/present 完成（无头 harness 逐帧同步，无流水线重叠），Flutter 为光栅线程 rasterDuration（不含设备完成等待），GPUI 与 Electron 无法在适配器侧观测显示链路，显示 `n/a`。MoUI ui-frame 是 headless host-surface；GPUI 的 action dispatch 另列为诊断字段。不同框架的显示时间戳由各自平台 API 提供，帧间隔覆盖完整链路，报告不做跨时钟的综合排名。`n/a` 表示没有采集，绝不等同于 0。下方各对比表把同平台跨框架可比列（帧间隔/可见延迟/首次可交互/丢帧数等）排在前面，框架内部诊断列（`工作`/`设备侧`）排在后面并标注 `†`。

- `moui-md-*` 行来自 `momark`（MoMark，原 `vendor/MoUI/examples/markdown_editor`）官方示例应用：fixture 通过应用自身的 `OpenRecentDocument` 服务路径打开，渲染经过示例自己的虚拟滚动与富文本缓存实现，不套用简化基准应用的 `fixed row 66px` 统一行高；viewport、fixture、动作数、warm-up 与重复次数与其他行完全一致。严格模式（`UI_BENCHMARK_SYSTEM_TRACE=1`）目前不为 `moui-md-*` 行采集系统 present，这些行会显示 error。

<details><summary>原始 ui-frame 汇总（可审计）</summary>

| 实现 | 测试集合 | 场景 | 范围 | 工作均值/P95 | 仅分发均值/P95 | 帧间隔均值/P95 | 输入到可见均值/P95 | 设备侧均值 | 离屏均值 | 回读均值 | 首次可交互 | 丢帧数 | 状态 |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| moui-skia-raster | small | open | ui-frame | 31.712/32.427 | - | - | - | 7.86 ms | 0.00 ms | 7.86 ms | 44.79 ms | n/a | measured |
| moui-skia-raster | small | input | ui-frame | 1.862/2.228 | - | 4.740/7.236 | 4.739/7.236 | 2.36 ms | 0.00 ms | 2.36 ms | 46.15 ms | n/a | measured |
| moui-skia-raster | small | scroll | ui-frame | 3.469/5.883 | - | 6.553/9.796 | - | 1.97 ms | 0.00 ms | 1.97 ms | 44.52 ms | n/a | measured |
| moui-skia-raster | medium | open | ui-frame | 31.509/33.536 | - | - | - | 7.41 ms | 0.00 ms | 7.41 ms | 47.15 ms | n/a | measured |
| moui-skia-raster | medium | input | ui-frame | 1.866/2.409 | - | 4.683/5.605 | 4.682/5.602 | 2.19 ms | 0.00 ms | 2.19 ms | 49.75 ms | n/a | measured |
| moui-skia-raster | medium | scroll | ui-frame | 3.403/5.667 | - | 6.529/9.537 | - | 2.03 ms | 0.00 ms | 2.03 ms | 47.86 ms | n/a | measured |
| moui-skia-raster | large | open | ui-frame | 31.328/31.552 | - | - | - | 7.76 ms | 0.00 ms | 7.76 ms | 76.11 ms | n/a | measured |
| moui-skia-raster | large | input | ui-frame | 1.881/3.053 | - | 5.542/7.637 | 5.541/7.636 | 2.20 ms | 0.00 ms | 2.20 ms | 81.64 ms | n/a | measured |
| moui-skia-raster | large | scroll | ui-frame | 3.373/5.770 | - | 6.434/9.872 | - | 1.98 ms | 0.00 ms | 1.98 ms | 76.94 ms | n/a | measured |
| moui-skia-raster | stress | open | ui-frame | 31.983/32.212 | - | - | - | 8.29 ms | 0.00 ms | 8.29 ms | 359.61 ms | n/a | measured |
| moui-skia-raster | stress | input | ui-frame | 2.062/2.628 | - | 15.111/16.801 | 15.110/16.800 | 2.46 ms | 0.00 ms | 2.46 ms | 360.88 ms | n/a | measured |
| moui-skia-raster | stress | scroll | ui-frame | 3.336/5.461 | - | 6.379/9.496 | - | 1.97 ms | 0.00 ms | 1.97 ms | 355.98 ms | n/a | measured |
| moui-skia-gpu | small | open | ui-frame | 29.210/29.814 | - | - | - | 64.07 ms | 0.00 ms | 64.07 ms | 97.58 ms | n/a | measured |
| moui-skia-gpu | small | input | ui-frame | 1.997/2.479 | - | 13.442/15.356 | 13.441/15.356 | 10.84 ms | 0.00 ms | 10.84 ms | 102.77 ms | n/a | measured |
| moui-skia-gpu | small | scroll | ui-frame | 3.429/5.775 | - | 7.205/10.414 | - | 2.69 ms | 0.00 ms | 2.69 ms | 94.99 ms | n/a | measured |
| moui-skia-gpu | medium | open | ui-frame | 31.744/33.372 | - | - | - | 65.69 ms | 0.00 ms | 65.69 ms | 105.08 ms | n/a | measured |
| moui-skia-gpu | medium | input | ui-frame | 2.073/2.670 | - | 13.306/15.331 | 13.305/15.329 | 10.60 ms | 0.00 ms | 10.60 ms | 107.44 ms | n/a | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 3.444/5.790 | - | 7.310/10.687 | - | 2.78 ms | 0.00 ms | 2.78 ms | 106.02 ms | n/a | measured |
| moui-skia-gpu | large | open | ui-frame | 29.771/30.174 | - | - | - | 61.02 ms | 0.00 ms | 61.02 ms | 126.71 ms | n/a | measured |
| moui-skia-gpu | large | input | ui-frame | 2.066/2.670 | - | 14.554/16.077 | 14.552/16.075 | 10.69 ms | 0.00 ms | 10.69 ms | 131.75 ms | n/a | measured |
| moui-skia-gpu | large | scroll | ui-frame | 3.462/5.798 | - | 6.802/10.066 | - | 2.19 ms | 0.00 ms | 2.19 ms | 133.70 ms | n/a | measured |
| moui-skia-gpu | stress | open | ui-frame | 29.920/30.796 | - | - | - | 61.51 ms | 0.00 ms | 61.51 ms | 424.73 ms | n/a | measured |
| moui-skia-gpu | stress | input | ui-frame | 2.151/2.855 | - | 24.216/27.099 | 24.214/27.096 | 10.58 ms | 0.00 ms | 10.58 ms | 425.98 ms | n/a | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 3.491/6.016 | - | 7.198/10.730 | - | 2.58 ms | 0.00 ms | 2.58 ms | 410.13 ms | n/a | measured |
| moui-wgpu | small | open | ui-frame | 139.618/149.761 | - | - | - | 41.08 ms | n/a | 0.00 ms | 185.10 ms | n/a | measured |
| moui-wgpu | small | input | ui-frame | 5.224/6.260 | - | 12.452/16.341 | 12.450/16.340 | 6.59 ms | n/a | 0.00 ms | 193.91 ms | n/a | measured |
| moui-wgpu | small | scroll | ui-frame | 4.044/6.642 | - | 9.268/12.892 | - | 4.00 ms | n/a | 0.00 ms | 176.86 ms | n/a | measured |
| moui-wgpu | medium | open | ui-frame | 133.449/138.082 | - | - | - | 41.55 ms | n/a | 0.00 ms | 183.34 ms | n/a | measured |
| moui-wgpu | medium | input | ui-frame | 5.215/6.722 | - | 11.922/14.400 | 11.921/14.400 | 6.06 ms | n/a | 0.00 ms | 188.58 ms | n/a | measured |
| moui-wgpu | medium | scroll | ui-frame | 3.927/6.258 | - | 9.076/12.480 | - | 3.95 ms | n/a | 0.00 ms | 178.77 ms | n/a | measured |
| moui-wgpu | large | open | ui-frame | 131.857/133.818 | - | - | - | 40.02 ms | n/a | 0.00 ms | 206.89 ms | n/a | measured |
| moui-wgpu | large | input | ui-frame | 5.075/6.572 | - | 12.394/14.629 | 12.393/14.628 | 5.79 ms | n/a | 0.00 ms | 220.79 ms | n/a | measured |
| moui-wgpu | large | scroll | ui-frame | 3.880/6.298 | - | 8.912/12.221 | - | 3.82 ms | n/a | 0.00 ms | 206.61 ms | n/a | measured |
| moui-wgpu | stress | open | ui-frame | 130.567/131.263 | - | - | - | 39.44 ms | n/a | 0.00 ms | 489.15 ms | n/a | measured |
| moui-wgpu | stress | input | ui-frame | 4.986/6.197 | - | 21.584/25.460 | 21.583/25.459 | 5.95 ms | n/a | 0.00 ms | 496.91 ms | n/a | measured |
| moui-wgpu | stress | scroll | ui-frame | 3.835/6.215 | - | 8.829/12.034 | - | 3.82 ms | n/a | 0.00 ms | 494.03 ms | n/a | measured |
| moui-md-skia-raster | small | open | ui-frame | 41.250/41.765 | - | - | - | 13.24 ms | 0.00 ms | 13.24 ms | 61.03 ms | n/a | measured |
| moui-md-skia-raster | small | input | ui-frame | 5.060/5.666 | - | 11.696/12.750 | 11.627/12.357 | 5.75 ms | 0.00 ms | 5.75 ms | 63.39 ms | n/a | measured |
| moui-md-skia-raster | small | scroll | ui-frame | 3.416/4.443 | - | 10.048/12.197 | - | 6.10 ms | 0.00 ms | 6.10 ms | 61.72 ms | n/a | measured |
| moui-md-skia-raster | medium | open | ui-frame | 43.917/45.319 | - | - | - | 11.97 ms | 0.00 ms | 11.97 ms | 67.24 ms | n/a | measured |
| moui-md-skia-raster | medium | input | ui-frame | 5.392/6.028 | - | 13.924/15.450 | 13.855/15.448 | 5.91 ms | 0.00 ms | 5.91 ms | 71.57 ms | n/a | measured |
| moui-md-skia-raster | medium | scroll | ui-frame | 3.366/4.415 | - | 10.082/12.143 | - | 6.10 ms | 0.00 ms | 6.10 ms | 65.57 ms | n/a | measured |
| moui-md-skia-raster | large | open | ui-frame | 46.932/50.560 | - | - | - | 12.56 ms | 0.00 ms | 12.56 ms | 124.94 ms | n/a | measured |
| moui-md-skia-raster | large | input | ui-frame | 6.622/7.621 | - | 37.472/40.409 | 37.402/39.723 | 6.22 ms | 0.00 ms | 6.22 ms | 130.92 ms | n/a | measured |
| moui-md-skia-raster | large | scroll | ui-frame | 3.519/4.717 | - | 11.686/14.036 | - | 6.26 ms | 0.00 ms | 6.26 ms | 127.35 ms | n/a | measured |
| moui-md-skia-raster | stress | open | ui-frame | 78.499/82.351 | - | - | - | 12.87 ms | 0.00 ms | 12.87 ms | 720.13 ms | n/a | measured |
| moui-md-skia-raster | stress | input | ui-frame | 20.961/28.033 | - | 343.388/386.569 | 343.305/386.561 | 7.13 ms | 0.00 ms | 7.13 ms | 731.12 ms | n/a | measured |
| moui-md-skia-raster | stress | scroll | ui-frame | 3.811/5.320 | - | 28.599/34.331 | - | 6.49 ms | 0.00 ms | 6.49 ms | 729.96 ms | n/a | measured |
| moui-md-skia-gpu | small | open | ui-frame | 40.390/40.821 | - | - | - | 211.52 ms | 0.00 ms | 211.52 ms | 257.81 ms | n/a | measured |
| moui-md-skia-gpu | small | input | ui-frame | 5.491/6.328 | - | 38.728/41.570 | 38.646/41.569 | 32.20 ms | 0.00 ms | 32.20 ms | 273.93 ms | n/a | measured |
| moui-md-skia-gpu | small | scroll | ui-frame | 3.784/5.316 | - | 29.046/32.354 | - | 24.65 ms | 0.00 ms | 24.65 ms | 256.67 ms | n/a | measured |
| moui-md-skia-gpu | medium | open | ui-frame | 44.319/49.013 | - | - | - | 216.68 ms | 0.00 ms | 216.68 ms | 272.41 ms | n/a | measured |
| moui-md-skia-gpu | medium | input | ui-frame | 5.648/6.626 | - | 40.981/43.276 | 40.895/43.275 | 32.33 ms | 0.00 ms | 32.33 ms | 272.95 ms | n/a | measured |
| moui-md-skia-gpu | medium | scroll | ui-frame | 3.745/5.161 | - | 29.016/32.150 | - | 24.54 ms | 0.00 ms | 24.54 ms | 261.74 ms | n/a | measured |
| moui-md-skia-gpu | large | open | ui-frame | 44.591/45.943 | - | - | - | 210.69 ms | 0.00 ms | 210.69 ms | 320.45 ms | n/a | measured |
| moui-md-skia-gpu | large | input | ui-frame | 6.791/8.264 | - | 65.002/73.157 | 64.901/73.156 | 33.05 ms | 0.00 ms | 33.05 ms | 326.68 ms | n/a | measured |
| moui-md-skia-gpu | large | scroll | ui-frame | 3.781/5.343 | - | 30.572/34.711 | - | 24.63 ms | 0.00 ms | 24.63 ms | 319.98 ms | n/a | measured |
| moui-md-skia-gpu | stress | open | ui-frame | 76.703/80.929 | - | - | - | 205.13 ms | 0.00 ms | 205.13 ms | 905.20 ms | n/a | measured |
| moui-md-skia-gpu | stress | input | ui-frame | 20.905/25.328 | - | 385.161/420.344 | 385.076/420.337 | 34.30 ms | 0.00 ms | 34.30 ms | 923.23 ms | n/a | measured |
| moui-md-skia-gpu | stress | scroll | ui-frame | 4.201/5.805 | - | 49.153/54.083 | - | 25.58 ms | 0.00 ms | 25.58 ms | 930.48 ms | n/a | measured |
| moui-md-wgpu | small | open | ui-frame | 156.528/159.809 | - | - | - | 44.59 ms | n/a | 0.00 ms | 206.86 ms | n/a | measured |
| moui-md-wgpu | small | input | ui-frame | 23.459/26.056 | - | 31.416/33.836 | 31.337/33.834 | 6.92 ms | n/a | 0.00 ms | 211.62 ms | n/a | measured |
| moui-md-wgpu | small | scroll | ui-frame | 4.403/5.875 | - | 11.509/14.547 | - | 6.60 ms | n/a | 0.00 ms | 203.19 ms | n/a | measured |
| moui-md-wgpu | medium | open | ui-frame | 156.446/159.174 | - | - | - | 43.71 ms | n/a | 0.00 ms | 211.45 ms | n/a | measured |
| moui-md-wgpu | medium | input | ui-frame | 23.558/26.472 | - | 33.217/36.024 | 33.139/36.023 | 6.78 ms | n/a | 0.00 ms | 215.96 ms | n/a | measured |
| moui-md-wgpu | medium | scroll | ui-frame | 4.350/5.637 | - | 11.447/13.966 | - | 6.49 ms | n/a | 0.00 ms | 216.59 ms | n/a | measured |
| moui-md-wgpu | large | open | ui-frame | 159.113/163.035 | - | - | - | 42.78 ms | n/a | 0.00 ms | 266.08 ms | n/a | measured |
| moui-md-wgpu | large | input | ui-frame | 24.252/28.176 | - | 56.091/60.995 | 56.014/60.994 | 6.81 ms | n/a | 0.00 ms | 279.71 ms | n/a | measured |
| moui-md-wgpu | large | scroll | ui-frame | 4.206/5.527 | - | 12.308/14.784 | - | 6.41 ms | n/a | 0.00 ms | 267.35 ms | n/a | measured |
| moui-md-wgpu | stress | open | ui-frame | 199.207/211.541 | - | - | - | 43.44 ms | n/a | 0.00 ms | 861.55 ms | n/a | measured |
| moui-md-wgpu | stress | input | ui-frame | 43.245/53.881 | - | 384.442/420.180 | 384.364/420.178 | 8.62 ms | n/a | 0.00 ms | 867.32 ms | n/a | measured |
| moui-md-wgpu | stress | scroll | ui-frame | 5.082/7.017 | - | 31.840/38.164 | - | 7.48 ms | n/a | 0.00 ms | 859.12 ms | n/a | measured |
| gpmark | small | open | ui-frame | 2.053/3.138 | - | - | - | n/a | n/a | n/a | 250.78 ms | n/a | measured |
| gpmark | small | input | ui-frame | 1.516/1.789 | 0.547/0.750 | 6.874/7.549 | 6.872/7.548 | n/a | n/a | n/a | 246.99 ms | n/a | measured |
| gpmark | small | scroll | ui-frame | 1.835/2.593 | 0.001/0.001 | 6.922/7.389 | - | n/a | n/a | n/a | 246.12 ms | n/a | measured |
| gpmark | medium | open | ui-frame | 1.637/1.778 | - | - | - | n/a | n/a | n/a | 242.89 ms | n/a | measured |
| gpmark | medium | input | ui-frame | 1.523/1.795 | 0.684/0.772 | 6.866/7.708 | 6.865/7.707 | n/a | n/a | n/a | 250.76 ms | n/a | measured |
| gpmark | medium | scroll | ui-frame | 1.921/2.768 | 0.000/0.001 | 6.933/7.392 | - | n/a | n/a | n/a | 246.91 ms | n/a | measured |
| gpmark | large | open | ui-frame | 1.814/1.946 | - | - | - | n/a | n/a | n/a | 245.80 ms | n/a | measured |
| gpmark | large | input | ui-frame | 1.437/1.788 | 2.488/2.778 | 6.726/7.907 | 6.724/7.900 | n/a | n/a | n/a | 251.13 ms | n/a | measured |
| gpmark | large | scroll | ui-frame | 1.851/2.672 | 0.000/0.001 | 6.933/7.381 | - | n/a | n/a | n/a | 244.87 ms | n/a | measured |
| gpmark | stress | open | ui-frame | 1.585/1.837 | - | - | - | n/a | n/a | n/a | 242.73 ms | n/a | measured |
| gpmark | stress | input | ui-frame | 1.758/2.399 | 25.325/34.641 | 25.536/40.809 | 25.535/40.808 | n/a | n/a | n/a | 248.70 ms | n/a | measured |
| gpmark | stress | scroll | ui-frame | 1.917/2.746 | 0.000/0.001 | 6.936/7.415 | - | n/a | n/a | n/a | 244.68 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 0.435/0.511 | - | - | - | 41.20 ms | n/a | n/a | 27.87 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 0.853/1.050 | - | 6.945/6.945 | 7.110/9.450 | 0.53 ms | n/a | n/a | 29.02 ms | 0 | measured |
| flutter-skia | small | scroll | ui-frame | 2.469/3.279 | - | 7.153/8.289 | - | 0.52 ms | n/a | n/a | 28.61 ms | 0 | measured |
| flutter-skia | medium | open | ui-frame | 0.431/0.500 | - | - | - | 42.24 ms | n/a | n/a | 29.63 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 0.782/0.904 | - | 6.944/6.945 | 7.117/8.664 | 0.51 ms | n/a | n/a | 30.34 ms | 0 | measured |
| flutter-skia | medium | scroll | ui-frame | 3.800/6.025 | - | 9.641/13.889 | - | 0.58 ms | n/a | n/a | 28.89 ms | 1 | measured |
| flutter-skia | large | open | ui-frame | 1.593/1.859 | - | - | - | 42.42 ms | n/a | n/a | 33.83 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 0.884/1.056 | - | 6.945/6.945 | 6.997/8.855 | 0.55 ms | n/a | n/a | 34.93 ms | 0 | measured |
| flutter-skia | large | scroll | ui-frame | 3.751/5.782 | - | 9.370/13.889 | - | 0.56 ms | n/a | n/a | 34.73 ms | 1 | measured |
| flutter-skia | stress | open | ui-frame | 0.466/0.483 | - | - | - | 39.38 ms | n/a | n/a | 88.25 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 0.867/0.955 | - | 6.944/6.945 | 7.016/8.110 | 0.53 ms | n/a | n/a | 85.49 ms | 0 | measured |
| flutter-skia | stress | scroll | ui-frame | 3.767/5.811 | - | 9.394/13.889 | - | 0.58 ms | n/a | n/a | 88.77 ms | 1 | measured |
| flutter-impeller | small | open | ui-frame | 0.468/0.502 | - | - | - | 21.84 ms | n/a | n/a | 29.69 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 0.870/1.063 | - | 6.945/6.945 | 7.050/8.336 | 1.33 ms | n/a | n/a | 29.87 ms | 0 | measured |
| flutter-impeller | small | scroll | ui-frame | 2.577/3.336 | - | 7.157/6.945 | - | 1.34 ms | n/a | n/a | 29.45 ms | 0 | measured |
| flutter-impeller | medium | open | ui-frame | 0.480/0.544 | - | - | - | 20.24 ms | n/a | n/a | 28.79 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 0.863/1.101 | - | 6.945/6.945 | 7.087/8.151 | 1.32 ms | n/a | n/a | 29.93 ms | 0 | measured |
| flutter-impeller | medium | scroll | ui-frame | 3.887/5.897 | - | 9.491/13.889 | - | 1.32 ms | n/a | n/a | 32.34 ms | 0 | measured |
| flutter-impeller | large | open | ui-frame | 1.407/1.533 | - | - | - | 21.50 ms | n/a | n/a | 35.36 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 1.020/1.588 | - | 6.945/6.945 | 7.106/9.094 | 1.52 ms | n/a | n/a | 35.04 ms | 0 | measured |
| flutter-impeller | large | scroll | ui-frame | 3.879/5.985 | - | 9.722/13.889 | - | 1.33 ms | n/a | n/a | 36.39 ms | 0 | measured |
| flutter-impeller | stress | open | ui-frame | 0.565/0.798 | - | - | - | 19.51 ms | n/a | n/a | 93.46 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 0.838/1.007 | - | 7.073/6.945 | 7.172/9.883 | 1.29 ms | n/a | n/a | 88.04 ms | 0 | measured |
| flutter-impeller | stress | scroll | ui-frame | 3.904/5.874 | - | 9.628/13.889 | - | 1.35 ms | n/a | n/a | 90.27 ms | 0 | measured |
| electron | small | open | ui-frame | 29.433/53.900 | - | - | - | n/a | n/a | n/a | 29.43 ms | 0 | measured |
| electron | small | input | ui-frame | 3.093/4.500 | - | 8.098/13.900 | 7.200/14.100 | n/a | n/a | n/a | 29.60 ms | 0 | measured |
| electron | small | scroll | ui-frame | 3.261/4.500 | - | 7.103/7.100 | - | n/a | n/a | n/a | 44.47 ms | 0 | measured |
| electron | medium | open | ui-frame | 18.967/20.100 | - | - | - | n/a | n/a | n/a | 18.97 ms | 0 | measured |
| electron | medium | input | ui-frame | 3.060/4.600 | - | 7.967/13.900 | 6.847/13.100 | n/a | n/a | n/a | 18.77 ms | 0 | measured |
| electron | medium | scroll | ui-frame | 3.473/4.700 | - | 6.991/7.000 | - | n/a | n/a | n/a | 18.00 ms | 0 | measured |
| electron | large | open | ui-frame | 21.800/22.800 | - | - | - | n/a | n/a | n/a | 21.80 ms | 0 | measured |
| electron | large | input | ui-frame | 2.983/4.600 | - | 8.201/13.900 | 7.120/14.400 | n/a | n/a | n/a | 22.17 ms | 0 | measured |
| electron | large | scroll | ui-frame | 3.583/5.000 | - | 7.011/7.000 | - | n/a | n/a | n/a | 21.43 ms | 1 | measured |
| electron | stress | open | ui-frame | 35.933/37.200 | - | - | - | n/a | n/a | n/a | 35.93 ms | 0 | measured |
| electron | stress | input | ui-frame | 2.990/4.300 | - | 8.657/20.700 | 7.323/17.500 | n/a | n/a | n/a | 35.93 ms | 2 | measured |
| electron | stress | scroll | ui-frame | 3.599/4.900 | - | 7.029/7.000 | - | n/a | n/a | n/a | 35.80 ms | 1 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.55/6.53/6.43 | 9.80/9.54/9.87 | n/a/n/a/n/a | 3.47/3.40/3.37 | 5.88/5.67/5.77 | 1.97/2.03/1.98 | 2.50/2.62/2.47 |
| MoUI Skia GPU | 7.20/7.31/6.80 | 10.41/10.69/10.07 | n/a/n/a/n/a | 3.43/3.44/3.46 | 5.78/5.79/5.80 | 2.69/2.78/2.19 | 3.11/3.21/2.79 |
| MoUI WGPU | 9.27/9.08/8.91 | 12.89/12.48/12.22 | n/a/n/a/n/a | 4.04/3.93/3.88 | 6.64/6.26/6.30 | 4.00/3.95/3.82 | 5.30/5.37/4.84 |
| MoMark Skia Raster | 10.05/10.08/11.69 | 12.20/12.14/14.04 | n/a/n/a/n/a | 3.42/3.37/3.52 | 4.44/4.42/4.72 | 6.10/6.10/6.26 | 7.42/7.37/7.61 |
| MoMark Skia GPU | 29.05/29.02/30.57 | 32.35/32.15/34.71 | n/a/n/a/n/a | 3.78/3.74/3.78 | 5.32/5.16/5.34 | 24.65/24.54/24.63 | 26.88/26.83/27.62 |
| MoMark WGPU | 11.51/11.45/12.31 | 14.55/13.97/14.78 | n/a/n/a/n/a | 4.40/4.35/4.21 | 5.88/5.64/5.53 | 6.60/6.49/6.41 | 8.60/8.21/7.89 |
| GpMark.mbt (GPUI) | 6.92/6.93/6.93 | 7.39/7.39/7.38 | n/a/n/a/n/a | 1.83/1.92/1.85 | 2.59/2.77/2.67 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.15/9.64/9.37 | 8.29/13.89/13.89 | 0/1/1 | 2.47/3.80/3.75 | 3.28/6.03/5.78 | 0.52/0.58/0.56 | 0.70/0.77/0.74 |
| Flutter Impeller | 7.16/9.49/9.72 | 6.95/13.89/13.89 | 0/0/0 | 2.58/3.89/3.88 | 3.34/5.90/5.99 | 1.34/1.32/1.33 | 1.78/1.78/1.80 |
| Electron | 7.10/6.99/7.01 | 7.10/7.00/7.00 | 0/0/1 | 3.26/3.47/3.58 | 4.50/4.70/5.00 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.38 | 9.50 | n/a | 3.34 | 5.46 | 1.97 | 2.47 |
| MoUI Skia GPU | 7.20 | 10.73 | n/a | 3.49 | 6.02 | 2.58 | 3.33 |
| MoUI WGPU | 8.83 | 12.03 | n/a | 3.83 | 6.21 | 3.82 | 4.96 |
| MoMark Skia Raster | 28.60 | 34.33 | n/a | 3.81 | 5.32 | 6.49 | 8.15 |
| MoMark Skia GPU | 49.15 | 54.08 | n/a | 4.20 | 5.81 | 25.58 | 27.45 |
| MoMark WGPU | 31.84 | 38.16 | n/a | 5.08 | 7.02 | 7.48 | 9.87 |
| GpMark.mbt (GPUI) | 6.94 | 7.41 | n/a | 1.92 | 2.75 | n/a | n/a |
| Flutter Skia | 9.39 | 13.89 | 1 | 3.77 | 5.81 | 0.58 | 0.76 |
| Flutter Impeller | 9.63 | 13.89 | 0 | 3.90 | 5.87 | 1.35 | 1.80 |
| Electron | 7.03 | 7.00 | 1 | 3.60 | 4.90 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 4.74/4.68/5.54 | 7.24/5.60/7.64 | 1.86/1.87/1.88 | 2.23/2.41/3.05 | 2.36/2.19/2.20 | 5.04/2.59/2.90 |
| MoUI Skia GPU | 13.44/13.30/14.55 | 15.36/15.33/16.08 | 2.00/2.07/2.07 | 2.48/2.67/2.67 | 10.84/10.60/10.69 | 12.38/12.51/12.28 |
| MoUI WGPU | 12.45/11.92/12.39 | 16.34/14.40/14.63 | 5.22/5.21/5.08 | 6.26/6.72/6.57 | 6.59/6.06/5.79 | 9.52/7.25/7.74 |
| MoMark Skia Raster | 11.63/13.85/37.40 | 12.36/15.45/39.72 | 5.06/5.39/6.62 | 5.67/6.03/7.62 | 5.75/5.91/6.22 | 6.48/6.78/6.80 |
| MoMark Skia GPU | 38.65/40.89/64.90 | 41.57/43.27/73.16 | 5.49/5.65/6.79 | 6.33/6.63/8.26 | 32.20/32.33/33.05 | 35.34/34.33/38.54 |
| MoMark WGPU | 31.34/33.14/56.01 | 33.83/36.02/60.99 | 23.46/23.56/24.25 | 26.06/26.47/28.18 | 6.92/6.78/6.81 | 8.09/8.32/7.78 |
| GpMark.mbt (GPUI) | 6.87/6.87/6.72 | 7.55/7.71/7.90 | 1.52/1.52/1.44 | 1.79/1.79/1.79 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.11/7.12/7.00 | 9.45/8.66/8.86 | 0.85/0.78/0.88 | 1.05/0.90/1.06 | 0.53/0.51/0.55 | 0.65/0.63/0.68 |
| Flutter Impeller | 7.05/7.09/7.11 | 8.34/8.15/9.09 | 0.87/0.86/1.02 | 1.06/1.10/1.59 | 1.33/1.32/1.52 | 1.72/1.70/2.12 |
| Electron | 7.20/6.85/7.12 | 14.10/13.10/14.40 | 3.09/3.06/2.98 | 4.50/4.60/4.60 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 15.11 | 16.80 | 2.06 | 2.63 | 2.46 | 3.01 |
| MoUI Skia GPU | 24.21 | 27.10 | 2.15 | 2.86 | 10.58 | 12.14 |
| MoUI WGPU | 21.58 | 25.46 | 4.99 | 6.20 | 5.95 | 7.58 |
| MoMark Skia Raster | 343.30 | 386.56 | 20.96 | 28.03 | 7.13 | 8.47 |
| MoMark Skia GPU | 385.08 | 420.34 | 20.91 | 25.33 | 34.30 | 36.38 |
| MoMark WGPU | 384.36 | 420.18 | 43.24 | 53.88 | 8.62 | 10.68 |
| GpMark.mbt (GPUI) | 25.53 | 40.81 | 1.76 | 2.40 | n/a | n/a |
| Flutter Skia | 7.02 | 8.11 | 0.87 | 0.95 | 0.53 | 0.63 |
| Flutter Impeller | 7.17 | 9.88 | 0.84 | 1.01 | 1.29 | 1.85 |
| Electron | 7.32 | 17.50 | 2.99 | 4.30 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 44.79/47.15/76.11 | 45.68/49.19/78.52 | 0.20/0.68/3.99 | 0.20/0.70/4.49 | 31.71/31.51/31.33 | 32.43/33.54/31.55 | 7.86/7.41/7.76 | 8.40/7.70/7.96 |
| MoUI Skia GPU | 97.58/105.08/126.71 | 98.95/112.84/127.87 | 0.19/0.65/4.00 | 0.22/0.70/4.43 | 29.21/31.74/29.77 | 29.81/33.37/30.17 | 64.07/65.69/61.02 | 65.13/70.79/62.73 |
| MoUI WGPU | 185.10/183.34/206.89 | 198.35/185.48/207.78 | 0.20/0.87/4.42 | 0.21/1.02/4.48 | 139.62/133.45/131.86 | 149.76/138.08/133.82 | 41.08/41.55/40.02 | 44.47/44.48/42.46 |
| MoMark Skia Raster | 61.03/67.24/124.94 | 61.81/69.44/131.81 | 0.20/0.63/3.79 | 0.22/0.67/3.97 | 41.25/43.92/46.93 | 41.76/45.32/50.56 | 13.24/11.97/12.56 | 14.30/12.31/13.16 |
| MoMark Skia GPU | 257.81/272.41/320.45 | 258.16/281.22/322.11 | 0.16/0.58/3.97 | 0.17/0.60/4.04 | 40.39/44.32/44.59 | 40.82/49.01/45.94 | 211.52/216.68/210.69 | 212.48/223.37/212.12 |
| MoMark WGPU | 206.86/211.45/266.08 | 209.99/214.94/268.04 | 0.19/0.69/3.72 | 0.26/0.96/3.84 | 156.53/156.45/159.11 | 159.81/159.17/163.04 | 44.59/43.71/42.78 | 45.59/45.26/43.80 |
| GpMark.mbt (GPUI) | 250.78/242.89/245.80 | 256.29/245.62/252.13 | 0.00/1.00/5.00 | 0.00/2.00/5.00 | 2.05/1.64/1.81 | 3.14/1.78/1.95 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 27.87/29.63/33.83 | 29.07/33.40/34.48 | 0.80/0.81/1.12 | 0.84/0.81/1.23 | 0.44/0.43/1.59 | 0.51/0.50/1.86 | 41.20/42.24/42.42 | 44.87/43.97/43.96 |
| Flutter Impeller | 29.69/28.79/35.36 | 31.00/29.20/36.23 | 0.75/0.81/1.12 | 0.75/0.89/1.20 | 0.47/0.48/1.41 | 0.50/0.54/1.53 | 21.84/20.24/21.50 | 24.02/21.65/22.63 |
| Electron | 29.43/18.97/21.80 | 53.90/20.10/22.80 | 3.69/3.77/4.52 | 3.84/4.34/4.87 | 29.43/18.97/21.80 | 53.90/20.10/22.80 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 359.61 | 360.28 | 38.80 | 40.49 | 31.98 | 32.21 | 8.29 | 8.71 |
| MoUI Skia GPU | 424.73 | 435.09 | 38.85 | 39.89 | 29.92 | 30.80 | 61.51 | 62.99 |
| MoUI WGPU | 489.15 | 492.00 | 37.35 | 38.11 | 130.57 | 131.26 | 39.44 | 39.51 |
| MoMark Skia Raster | 720.13 | 724.41 | 37.80 | 37.85 | 78.50 | 82.35 | 12.87 | 13.36 |
| MoMark Skia GPU | 905.20 | 918.16 | 37.61 | 38.03 | 76.70 | 80.93 | 205.13 | 209.30 |
| MoMark WGPU | 861.55 | 868.41 | 37.23 | 38.10 | 199.21 | 211.54 | 43.44 | 45.21 |
| GpMark.mbt (GPUI) | 242.73 | 245.74 | 38.00 | 39.00 | 1.58 | 1.84 | n/a | n/a |
| Flutter Skia | 88.25 | 88.90 | 3.95 | 4.83 | 0.47 | 0.48 | 39.38 | 41.04 |
| Flutter Impeller | 93.46 | 106.88 | 3.59 | 3.91 | 0.57 | 0.80 | 19.51 | 20.32 |
| Electron | 35.93 | 37.20 | 9.43 | 9.92 | 35.93 | 37.20 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.55/6.53/6.43 | 9.80/9.54/9.87 | n/a/n/a/n/a | 3.47/3.40/3.37 | 5.88/5.67/5.77 | 1.97/2.03/1.98 | 2.50/2.62/2.47 |
| MoUI Skia GPU | 7.20/7.31/6.80 | 10.41/10.69/10.07 | n/a/n/a/n/a | 3.43/3.44/3.46 | 5.78/5.79/5.80 | 2.69/2.78/2.19 | 3.11/3.21/2.79 |
| MoUI WGPU | 9.27/9.08/8.91 | 12.89/12.48/12.22 | n/a/n/a/n/a | 4.04/3.93/3.88 | 6.64/6.26/6.30 | 4.00/3.95/3.82 | 5.30/5.37/4.84 |
| MoMark Skia Raster | 10.05/10.08/11.69 | 12.20/12.14/14.04 | n/a/n/a/n/a | 3.42/3.37/3.52 | 4.44/4.42/4.72 | 6.10/6.10/6.26 | 7.42/7.37/7.61 |
| MoMark Skia GPU | 29.05/29.02/30.57 | 32.35/32.15/34.71 | n/a/n/a/n/a | 3.78/3.74/3.78 | 5.32/5.16/5.34 | 24.65/24.54/24.63 | 26.88/26.83/27.62 |
| MoMark WGPU | 11.51/11.45/12.31 | 14.55/13.97/14.78 | n/a/n/a/n/a | 4.40/4.35/4.21 | 5.88/5.64/5.53 | 6.60/6.49/6.41 | 8.60/8.21/7.89 |
| GpMark.mbt (GPUI) | 6.92/6.93/6.93 | 7.39/7.39/7.38 | n/a/n/a/n/a | 1.83/1.92/1.85 | 2.59/2.77/2.67 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.15/9.64/9.37 | 8.29/13.89/13.89 | 0/1/1 | 2.47/3.80/3.75 | 3.28/6.03/5.78 | 0.52/0.58/0.56 | 0.70/0.77/0.74 |
| Flutter Impeller | 7.16/9.49/9.72 | 6.95/13.89/13.89 | 0/0/0 | 2.58/3.89/3.88 | 3.34/5.90/5.99 | 1.34/1.32/1.33 | 1.78/1.78/1.80 |
| Electron | 7.10/6.99/7.01 | 7.10/7.00/7.00 | 0/0/1 | 3.26/3.47/3.58 | 4.50/4.70/5.00 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.38 | 9.50 | n/a | 3.34 | 5.46 | 1.97 | 2.47 |
| MoUI Skia GPU | 7.20 | 10.73 | n/a | 3.49 | 6.02 | 2.58 | 3.33 |
| MoUI WGPU | 8.83 | 12.03 | n/a | 3.83 | 6.21 | 3.82 | 4.96 |
| MoMark Skia Raster | 28.60 | 34.33 | n/a | 3.81 | 5.32 | 6.49 | 8.15 |
| MoMark Skia GPU | 49.15 | 54.08 | n/a | 4.20 | 5.81 | 25.58 | 27.45 |
| MoMark WGPU | 31.84 | 38.16 | n/a | 5.08 | 7.02 | 7.48 | 9.87 |
| GpMark.mbt (GPUI) | 6.94 | 7.41 | n/a | 1.92 | 2.75 | n/a | n/a |
| Flutter Skia | 9.39 | 13.89 | 1 | 3.77 | 5.81 | 0.58 | 0.76 |
| Flutter Impeller | 9.63 | 13.89 | 0 | 3.90 | 5.87 | 1.35 | 1.80 |
| Electron | 7.03 | 7.00 | 1 | 3.60 | 4.90 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoUI Skia Raster CPU stress 359.6 ms（max 360.3 ms）；MoUI Skia GPU medium 105.1 ms（max 112.8 ms）；MoUI Skia GPU large 126.7 ms（max 127.9 ms）；MoUI Skia GPU stress 424.7 ms（max 435.1 ms）；MoUI WGPU small 185.1 ms（max 198.4 ms）；MoUI WGPU medium 183.3 ms（max 185.5 ms）；MoUI WGPU large 206.9 ms（max 207.8 ms）；MoUI WGPU stress 489.2 ms（max 492.0 ms）；MoMark Skia Raster large 124.9 ms（max 131.8 ms）；MoMark Skia Raster stress 720.1 ms（max 724.4 ms）；MoMark Skia GPU small 257.8 ms（max 258.2 ms）；MoMark Skia GPU medium 272.4 ms（max 281.2 ms）；MoMark Skia GPU large 320.5 ms（max 322.1 ms）；MoMark Skia GPU stress 905.2 ms（max 918.2 ms）；MoMark WGPU small 206.9 ms（max 210.0 ms）；MoMark WGPU medium 211.4 ms（max 214.9 ms）；MoMark WGPU large 266.1 ms（max 268.0 ms）；MoMark WGPU stress 861.5 ms（max 868.4 ms）；GpMark.mbt (GPUI) small 250.8 ms（max 256.3 ms）；GpMark.mbt (GPUI) medium 242.9 ms（max 245.6 ms）；GpMark.mbt (GPUI) large 245.8 ms（max 252.1 ms）；GpMark.mbt (GPUI) stress 242.7 ms（max 245.7 ms）；Flutter Impeller stress 93.5 ms（max 106.9 ms）。
- P1 输入尾延迟：MoUI Skia Raster CPU stress P95 16.80 ms；MoUI Skia GPU stress P95 27.10 ms；MoUI WGPU stress P95 25.46 ms；MoMark Skia Raster large P95 39.72 ms；MoMark Skia Raster stress P95 386.56 ms；MoMark Skia GPU small P95 41.57 ms；MoMark Skia GPU medium P95 43.27 ms；MoMark Skia GPU large P95 73.16 ms；MoMark Skia GPU stress P95 420.34 ms；MoMark WGPU small P95 33.83 ms；MoMark WGPU medium P95 36.02 ms；MoMark WGPU large P95 60.99 ms；MoMark WGPU stress P95 420.18 ms；GpMark.mbt (GPUI) stress P95 40.81 ms；Electron stress P95 17.50 ms。
- 长帧（超预算）：MoUI Skia Raster CPU: stress/input 2 次，max 17.06 ms；MoUI Skia GPU: small/input 1 次，max 16.94 ms, medium/input 1 次，max 17.32 ms, large/input 1 次，max 22.64 ms, stress/input 30 次，max 27.48 ms；MoUI WGPU: small/input 1 次，max 18.16 ms, large/input 1 次，max 19.17 ms, stress/input 30 次，max 30.22 ms；MoMark Skia Raster: large/input 30 次，max 40.66 ms, large/scroll 2 次，max 17.70 ms, stress/input 30 次，max 395.47 ms, stress/scroll 360 次，max 41.53 ms；MoMark Skia GPU: small/input 30 次，max 42.68 ms, small/scroll 360 次，max 36.81 ms, medium/input 30 次，max 48.30 ms, medium/scroll 360 次，max 37.96 ms, large/input 30 次，max 74.37 ms, large/scroll 360 次，max 39.38 ms, stress/input 30 次，max 428.52 ms, stress/scroll 360 次，max 63.90 ms；MoMark WGPU: small/input 30 次，max 33.90 ms, small/scroll 6 次，max 19.13 ms, medium/input 30 次，max 39.01 ms, medium/scroll 1 次，max 20.40 ms, large/input 30 次，max 62.11 ms, large/scroll 2 次，max 18.76 ms, stress/input 30 次，max 434.07 ms, stress/scroll 360 次，max 47.68 ms；GpMark.mbt (GPUI): stress/input 27 次，max 41.22 ms；Flutter Skia: medium/scroll 1 次，max 26.32 ms, large/scroll 1 次，max 27.78 ms, stress/scroll 1 次，max 27.78 ms；Electron: large/scroll 1 次，max 20.90 ms, stress/input 2 次，max 20.90 ms, stress/scroll 1 次，max 20.80 ms。
- 丢帧（优先处理）：Flutter Skia: medium/scroll 1 帧, large/scroll 1 帧, stress/scroll 1 帧；Electron: large/scroll 1 帧, stress/input 2 帧, stress/scroll 1 帧。
- 解释：首帧异常优先检查窗口/渲染器初始化；输入尾延迟检查 action 到下一可见帧的调度与同步重建；长帧检查解析、布局、文本 shaping 和 GPU 提交；`n/a` 表示未埋点，不等于 0。
- 普通模式的长帧、帧间隔和输入延迟是各框架回调诊断，不能替代跨框架 compositor 排名；需要严格结论时运行 `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`。

## 采集口径

- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。
- `frame_work_ms` 统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏；对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `device_present_ms`：设备/上屏侧统一字段。MoUI raster 为 Skia CPU 光栅化+像素回读整体；MoUI GPU/wgpu 为提交后同步等待设备完成（headless host-surface 逐帧同步，真实应用的 vsync 流水线可重叠掉一部分，该值应视为上屏成本上界）；Flutter 为 `FrameTiming.rasterDuration`（光栅线程任务时间，含显示列表光栅化与 GPU 提交、不含设备完成等待）；GPUI 与 Electron 适配器侧无法观测，显示 `n/a`。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧；严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代；打开场景没有前一帧，所以不计算 interval/drop。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。
