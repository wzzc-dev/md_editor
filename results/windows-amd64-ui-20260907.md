# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-07T12:54:52Z`
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
| moui-skia-raster | small | open | ui-frame | 33.230/34.117 | - | - | - | 8.42 ms | 0.00 ms | 8.42 ms | 46.59 ms | n/a | measured |
| moui-skia-raster | small | input | ui-frame | 1.884/2.616 | - | 4.601/5.873 | 4.600/5.872 | 2.20 ms | 0.00 ms | 2.20 ms | 46.93 ms | n/a | measured |
| moui-skia-raster | small | scroll | ui-frame | 3.368/5.753 | - | 6.344/9.568 | - | 1.91 ms | 0.00 ms | 1.91 ms | 44.18 ms | n/a | measured |
| moui-skia-raster | medium | open | ui-frame | 31.763/32.241 | - | - | - | 7.00 ms | 0.00 ms | 7.00 ms | 45.94 ms | n/a | measured |
| moui-skia-raster | medium | input | ui-frame | 1.776/1.967 | - | 4.403/4.825 | 4.402/4.825 | 2.05 ms | 0.00 ms | 2.05 ms | 50.06 ms | n/a | measured |
| moui-skia-raster | medium | scroll | ui-frame | 3.297/5.454 | - | 6.253/9.159 | - | 1.90 ms | 0.00 ms | 1.90 ms | 48.70 ms | n/a | measured |
| moui-skia-raster | large | open | ui-frame | 31.602/32.454 | - | - | - | 7.85 ms | 0.00 ms | 7.85 ms | 73.47 ms | n/a | measured |
| moui-skia-raster | large | input | ui-frame | 1.815/2.199 | - | 5.404/6.955 | 5.403/6.954 | 2.23 ms | 0.00 ms | 2.23 ms | 74.76 ms | n/a | measured |
| moui-skia-raster | large | scroll | ui-frame | 3.341/5.612 | - | 6.370/9.424 | - | 1.97 ms | 0.00 ms | 1.97 ms | 73.52 ms | n/a | measured |
| moui-skia-raster | stress | open | ui-frame | 30.578/30.899 | - | - | - | 7.20 ms | 0.00 ms | 7.20 ms | 353.77 ms | n/a | measured |
| moui-skia-raster | stress | input | ui-frame | 1.898/2.317 | - | 14.388/17.442 | 14.387/17.441 | 2.35 ms | 0.00 ms | 2.35 ms | 349.57 ms | n/a | measured |
| moui-skia-raster | stress | scroll | ui-frame | 3.319/5.682 | - | 6.287/9.545 | - | 1.92 ms | 0.00 ms | 1.92 ms | 353.27 ms | n/a | measured |
| moui-skia-gpu | small | open | ui-frame | 29.054/29.533 | - | - | - | 58.43 ms | 0.00 ms | 58.43 ms | 91.91 ms | n/a | measured |
| moui-skia-gpu | small | input | ui-frame | 1.893/2.269 | - | 12.453/14.018 | 12.452/14.016 | 9.96 ms | 0.00 ms | 9.96 ms | 98.08 ms | n/a | measured |
| moui-skia-gpu | small | scroll | ui-frame | 3.332/5.725 | - | 6.523/9.986 | - | 2.11 ms | 0.00 ms | 2.11 ms | 93.38 ms | n/a | measured |
| moui-skia-gpu | medium | open | ui-frame | 28.417/29.488 | - | - | - | 62.15 ms | 0.00 ms | 62.15 ms | 97.70 ms | n/a | measured |
| moui-skia-gpu | medium | input | ui-frame | 1.899/2.353 | - | 12.412/13.018 | 12.410/13.015 | 9.85 ms | 0.00 ms | 9.85 ms | 101.50 ms | n/a | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 3.380/5.754 | - | 6.581/9.828 | - | 2.11 ms | 0.00 ms | 2.11 ms | 96.17 ms | n/a | measured |
| moui-skia-gpu | large | open | ui-frame | 30.034/31.934 | - | - | - | 58.70 ms | 0.00 ms | 58.70 ms | 123.59 ms | n/a | measured |
| moui-skia-gpu | large | input | ui-frame | 2.047/2.824 | - | 14.172/15.747 | 14.170/15.742 | 10.43 ms | 0.00 ms | 10.43 ms | 129.25 ms | n/a | measured |
| moui-skia-gpu | large | scroll | ui-frame | 3.358/5.584 | - | 6.582/9.732 | - | 2.11 ms | 0.00 ms | 2.11 ms | 124.09 ms | n/a | measured |
| moui-skia-gpu | stress | open | ui-frame | 29.443/29.775 | - | - | - | 61.38 ms | 0.00 ms | 61.38 ms | 399.30 ms | n/a | measured |
| moui-skia-gpu | stress | input | ui-frame | 1.947/2.224 | - | 22.215/24.371 | 22.214/24.370 | 10.20 ms | 0.00 ms | 10.20 ms | 404.88 ms | n/a | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 3.344/5.651 | - | 6.563/9.748 | - | 2.13 ms | 0.00 ms | 2.13 ms | 397.41 ms | n/a | measured |
| moui-wgpu | small | open | ui-frame | 126.463/127.301 | - | - | - | 37.58 ms | n/a | 0.00 ms | 168.57 ms | n/a | measured |
| moui-wgpu | small | input | ui-frame | 4.904/6.137 | - | 10.739/12.263 | 10.738/12.263 | 5.28 ms | n/a | 0.00 ms | 170.22 ms | n/a | measured |
| moui-wgpu | small | scroll | ui-frame | 3.782/6.126 | - | 8.594/11.700 | - | 3.66 ms | n/a | 0.00 ms | 169.86 ms | n/a | measured |
| moui-wgpu | medium | open | ui-frame | 125.743/129.456 | - | - | - | 39.24 ms | n/a | 0.00 ms | 172.29 ms | n/a | measured |
| moui-wgpu | medium | input | ui-frame | 4.894/6.166 | - | 10.928/12.189 | 10.927/12.186 | 5.44 ms | n/a | 0.00 ms | 178.59 ms | n/a | measured |
| moui-wgpu | medium | scroll | ui-frame | 3.795/6.201 | - | 8.638/11.989 | - | 3.68 ms | n/a | 0.00 ms | 175.48 ms | n/a | measured |
| moui-wgpu | large | open | ui-frame | 127.077/130.175 | - | - | - | 41.36 ms | n/a | 0.00 ms | 202.23 ms | n/a | measured |
| moui-wgpu | large | input | ui-frame | 4.946/6.025 | - | 11.782/13.758 | 11.781/13.757 | 5.51 ms | n/a | 0.00 ms | 207.75 ms | n/a | measured |
| moui-wgpu | large | scroll | ui-frame | 3.817/6.142 | - | 8.667/12.226 | - | 3.70 ms | n/a | 0.00 ms | 205.02 ms | n/a | measured |
| moui-wgpu | stress | open | ui-frame | 128.051/129.915 | - | - | - | 38.54 ms | n/a | 0.00 ms | 474.69 ms | n/a | measured |
| moui-wgpu | stress | input | ui-frame | 4.950/6.109 | - | 21.143/23.474 | 21.142/23.472 | 5.59 ms | n/a | 0.00 ms | 484.34 ms | n/a | measured |
| moui-wgpu | stress | scroll | ui-frame | 3.939/6.401 | - | 9.066/12.620 | - | 3.92 ms | n/a | 0.00 ms | 494.46 ms | n/a | measured |
| moui-md-skia-raster | small | open | ui-frame | 43.626/46.309 | - | - | - | 12.94 ms | 0.00 ms | 12.94 ms | 63.26 ms | n/a | measured |
| moui-md-skia-raster | small | input | ui-frame | 5.434/6.270 | - | 12.342/14.287 | 12.268/13.645 | 5.91 ms | 0.00 ms | 5.91 ms | 66.84 ms | n/a | measured |
| moui-md-skia-raster | small | scroll | ui-frame | 3.428/4.528 | - | 10.132/12.513 | - | 6.16 ms | 0.00 ms | 6.16 ms | 61.45 ms | n/a | measured |
| moui-md-skia-raster | medium | open | ui-frame | 41.312/43.637 | - | - | - | 13.42 ms | 0.00 ms | 13.42 ms | 66.34 ms | n/a | measured |
| moui-md-skia-raster | medium | input | ui-frame | 5.814/7.970 | - | 14.956/19.216 | 14.885/19.215 | 6.30 ms | 0.00 ms | 6.30 ms | 71.39 ms | n/a | measured |
| moui-md-skia-raster | medium | scroll | ui-frame | 3.650/4.954 | - | 10.888/13.721 | - | 6.55 ms | 0.00 ms | 6.55 ms | 79.97 ms | n/a | measured |
| moui-md-skia-raster | large | open | ui-frame | 45.420/48.665 | - | - | - | 13.43 ms | 0.00 ms | 13.43 ms | 125.05 ms | n/a | measured |
| moui-md-skia-raster | large | input | ui-frame | 7.413/10.996 | - | 43.150/53.913 | 43.073/53.913 | 6.88 ms | 0.00 ms | 6.88 ms | 138.99 ms | n/a | measured |
| moui-md-skia-raster | large | scroll | ui-frame | 3.408/4.388 | - | 11.357/13.586 | - | 6.10 ms | 0.00 ms | 6.10 ms | 120.08 ms | n/a | measured |
| moui-md-skia-raster | stress | open | ui-frame | 75.589/76.267 | - | - | - | 13.13 ms | 0.00 ms | 13.13 ms | 710.02 ms | n/a | measured |
| moui-md-skia-raster | stress | input | ui-frame | 17.228/19.029 | - | 307.687/327.465 | 307.615/327.463 | 6.27 ms | 0.00 ms | 6.27 ms | 730.42 ms | n/a | measured |
| moui-md-skia-raster | stress | scroll | ui-frame | 3.591/4.649 | - | 27.145/30.462 | - | 6.19 ms | 0.00 ms | 6.19 ms | 711.23 ms | n/a | measured |
| moui-md-skia-gpu | small | open | ui-frame | 39.672/40.352 | - | - | - | 212.02 ms | 0.00 ms | 212.02 ms | 257.96 ms | n/a | measured |
| moui-md-skia-gpu | small | input | ui-frame | 5.303/6.288 | - | 38.248/45.031 | 38.170/45.026 | 31.90 ms | 0.00 ms | 31.90 ms | 258.50 ms | n/a | measured |
| moui-md-skia-gpu | small | scroll | ui-frame | 3.471/4.495 | - | 28.024/30.875 | - | 23.99 ms | 0.00 ms | 23.99 ms | 250.68 ms | n/a | measured |
| moui-md-skia-gpu | medium | open | ui-frame | 39.951/41.352 | - | - | - | 214.28 ms | 0.00 ms | 214.28 ms | 265.55 ms | n/a | measured |
| moui-md-skia-gpu | medium | input | ui-frame | 5.231/6.139 | - | 39.865/41.728 | 39.793/41.727 | 31.80 ms | 0.00 ms | 31.80 ms | 268.77 ms | n/a | measured |
| moui-md-skia-gpu | medium | scroll | ui-frame | 3.467/4.440 | - | 28.201/30.677 | - | 24.06 ms | 0.00 ms | 24.06 ms | 256.48 ms | n/a | measured |
| moui-md-skia-gpu | large | open | ui-frame | 41.456/42.564 | - | - | - | 210.78 ms | 0.00 ms | 210.78 ms | 313.24 ms | n/a | measured |
| moui-md-skia-gpu | large | input | ui-frame | 6.422/7.550 | - | 62.661/65.750 | 62.575/65.749 | 31.96 ms | 0.00 ms | 31.96 ms | 318.82 ms | n/a | measured |
| moui-md-skia-gpu | large | scroll | ui-frame | 3.380/4.213 | - | 29.745/31.765 | - | 24.38 ms | 0.00 ms | 24.38 ms | 312.14 ms | n/a | measured |
| moui-md-skia-gpu | stress | open | ui-frame | 76.008/81.804 | - | - | - | 220.31 ms | 0.00 ms | 220.31 ms | 920.44 ms | n/a | measured |
| moui-md-skia-gpu | stress | input | ui-frame | 17.480/20.570 | - | 333.174/347.504 | 333.083/347.503 | 32.31 ms | 0.00 ms | 32.31 ms | 925.87 ms | n/a | measured |
| moui-md-skia-gpu | stress | scroll | ui-frame | 3.540/4.326 | - | 44.369/46.585 | - | 23.74 ms | 0.00 ms | 23.74 ms | 926.57 ms | n/a | measured |
| moui-md-wgpu | small | open | ui-frame | 152.233/153.159 | - | - | - | 42.91 ms | n/a | 0.00 ms | 200.64 ms | n/a | measured |
| moui-md-wgpu | small | input | ui-frame | 23.556/26.125 | - | 31.190/35.242 | 31.107/35.241 | 6.66 ms | n/a | 0.00 ms | 210.61 ms | n/a | measured |
| moui-md-wgpu | small | scroll | ui-frame | 4.234/5.466 | - | 11.020/13.476 | - | 6.31 ms | n/a | 0.00 ms | 209.63 ms | n/a | measured |
| moui-md-wgpu | medium | open | ui-frame | 160.127/171.275 | - | - | - | 44.71 ms | n/a | 0.00 ms | 215.21 ms | n/a | measured |
| moui-md-wgpu | medium | input | ui-frame | 24.281/29.216 | - | 33.967/38.457 | 33.891/38.455 | 6.77 ms | n/a | 0.00 ms | 225.13 ms | n/a | measured |
| moui-md-wgpu | medium | scroll | ui-frame | 4.380/5.600 | - | 11.619/13.982 | - | 6.61 ms | n/a | 0.00 ms | 211.82 ms | n/a | measured |
| moui-md-wgpu | large | open | ui-frame | 159.140/165.559 | - | - | - | 43.67 ms | n/a | 0.00 ms | 266.42 ms | n/a | measured |
| moui-md-wgpu | large | input | ui-frame | 25.679/30.896 | - | 59.107/66.240 | 59.029/66.238 | 7.20 ms | n/a | 0.00 ms | 289.10 ms | n/a | measured |
| moui-md-wgpu | large | scroll | ui-frame | 4.314/5.530 | - | 12.528/14.887 | - | 6.51 ms | n/a | 0.00 ms | 271.54 ms | n/a | measured |
| moui-md-wgpu | stress | open | ui-frame | 189.837/192.796 | - | - | - | 45.41 ms | n/a | 0.00 ms | 852.89 ms | n/a | measured |
| moui-md-wgpu | stress | input | ui-frame | 35.052/39.542 | - | 321.448/334.964 | 321.370/334.963 | 6.87 ms | n/a | 0.00 ms | 861.85 ms | n/a | measured |
| moui-md-wgpu | stress | scroll | ui-frame | 4.478/6.005 | - | 28.869/35.077 | - | 6.79 ms | n/a | 0.00 ms | 864.25 ms | n/a | measured |
| gpmark | small | open | ui-frame | 1.668/1.924 | - | - | - | n/a | n/a | n/a | 244.78 ms | n/a | measured |
| gpmark | small | input | ui-frame | 1.462/1.716 | 0.528/0.661 | 6.866/7.732 | 6.864/7.732 | n/a | n/a | n/a | 242.46 ms | n/a | measured |
| gpmark | small | scroll | ui-frame | 1.747/2.525 | 0.000/0.001 | 6.935/7.609 | - | n/a | n/a | n/a | 246.22 ms | n/a | measured |
| gpmark | medium | open | ui-frame | 1.936/2.548 | - | - | - | n/a | n/a | n/a | 249.01 ms | n/a | measured |
| gpmark | medium | input | ui-frame | 1.737/3.104 | 0.773/1.102 | 6.916/8.219 | 6.915/8.218 | n/a | n/a | n/a | 244.36 ms | n/a | measured |
| gpmark | medium | scroll | ui-frame | 1.788/2.572 | 0.000/0.001 | 6.935/7.648 | - | n/a | n/a | n/a | 246.57 ms | n/a | measured |
| gpmark | large | open | ui-frame | 1.657/1.875 | - | - | - | n/a | n/a | n/a | 243.30 ms | n/a | measured |
| gpmark | large | input | ui-frame | 1.485/1.930 | 2.471/2.918 | 6.776/7.740 | 6.775/7.739 | n/a | n/a | n/a | 244.49 ms | n/a | measured |
| gpmark | large | scroll | ui-frame | 1.799/2.615 | 0.000/0.001 | 6.938/7.711 | - | n/a | n/a | n/a | 252.90 ms | n/a | measured |
| gpmark | stress | open | ui-frame | 1.434/1.449 | - | - | - | n/a | n/a | n/a | 244.50 ms | n/a | measured |
| gpmark | stress | input | ui-frame | 1.518/1.836 | 23.934/25.179 | 23.976/27.369 | 23.975/27.362 | n/a | n/a | n/a | 246.30 ms | n/a | measured |
| gpmark | stress | scroll | ui-frame | 1.830/2.575 | 0.000/0.000 | 6.938/7.648 | - | n/a | n/a | n/a | 245.34 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 0.474/0.507 | - | - | - | 43.43 ms | n/a | n/a | 29.40 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 0.867/1.081 | - | 6.945/6.945 | 6.868/8.293 | 0.55 ms | n/a | n/a | 28.66 ms | 0 | measured |
| flutter-skia | small | scroll | ui-frame | 2.430/3.094 | - | 7.060/6.945 | - | 0.50 ms | n/a | n/a | 28.99 ms | 0 | measured |
| flutter-skia | medium | open | ui-frame | 0.490/0.514 | - | - | - | 42.62 ms | n/a | n/a | 29.84 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 0.854/1.238 | - | 6.945/6.945 | 6.994/9.276 | 0.56 ms | n/a | n/a | 28.30 ms | 0 | measured |
| flutter-skia | medium | scroll | ui-frame | 3.650/5.598 | - | 9.337/13.889 | - | 0.52 ms | n/a | n/a | 30.10 ms | 0 | measured |
| flutter-skia | large | open | ui-frame | 1.604/1.681 | - | - | - | 41.21 ms | n/a | n/a | 35.34 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 0.826/1.057 | - | 6.945/6.945 | 7.131/8.631 | 0.56 ms | n/a | n/a | 35.52 ms | 0 | measured |
| flutter-skia | large | scroll | ui-frame | 3.591/5.547 | - | 9.009/13.889 | - | 0.52 ms | n/a | n/a | 33.95 ms | 0 | measured |
| flutter-skia | stress | open | ui-frame | 0.418/0.435 | - | - | - | 41.58 ms | n/a | n/a | 83.84 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 0.835/1.077 | - | 6.842/6.945 | 6.837/8.176 | 0.51 ms | n/a | n/a | 87.37 ms | 0 | measured |
| flutter-skia | stress | scroll | ui-frame | 3.722/5.679 | - | 9.231/13.889 | - | 0.52 ms | n/a | n/a | 87.39 ms | 0 | measured |
| flutter-impeller | small | open | ui-frame | 0.565/0.766 | - | - | - | 22.86 ms | n/a | n/a | 30.86 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 0.840/1.150 | - | 6.945/6.945 | 7.009/8.727 | 1.36 ms | n/a | n/a | 29.67 ms | 0 | measured |
| flutter-impeller | small | scroll | ui-frame | 2.554/3.270 | - | 7.108/6.945 | - | 1.18 ms | n/a | n/a | 30.04 ms | 0 | measured |
| flutter-impeller | medium | open | ui-frame | 0.497/0.637 | - | - | - | 21.37 ms | n/a | n/a | 29.93 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 0.869/1.108 | - | 6.945/6.945 | 7.089/8.022 | 1.35 ms | n/a | n/a | 29.91 ms | 0 | measured |
| flutter-impeller | medium | scroll | ui-frame | 3.776/5.671 | - | 9.433/13.889 | - | 1.23 ms | n/a | n/a | 29.58 ms | 0 | measured |
| flutter-impeller | large | open | ui-frame | 1.620/1.851 | - | - | - | 19.99 ms | n/a | n/a | 36.77 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 0.833/1.006 | - | 6.945/6.945 | 7.031/8.278 | 1.31 ms | n/a | n/a | 34.76 ms | 0 | measured |
| flutter-impeller | large | scroll | ui-frame | 4.023/6.422 | - | 9.799/13.889 | - | 1.30 ms | n/a | n/a | 36.01 ms | 0 | measured |
| flutter-impeller | stress | open | ui-frame | 0.438/0.481 | - | - | - | 21.75 ms | n/a | n/a | 87.87 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 0.879/1.057 | - | 6.713/6.945 | 6.794/8.336 | 1.38 ms | n/a | n/a | 85.63 ms | 0 | measured |
| flutter-impeller | stress | scroll | ui-frame | 3.860/6.048 | - | 9.697/13.889 | - | 1.29 ms | n/a | n/a | 86.41 ms | 0 | measured |
| electron | small | open | ui-frame | 29.200/53.600 | - | - | - | n/a | n/a | n/a | 29.20 ms | 0 | measured |
| electron | small | input | ui-frame | 2.927/4.700 | - | 7.642/13.900 | 6.897/13.700 | n/a | n/a | n/a | 51.27 ms | 0 | measured |
| electron | small | scroll | ui-frame | 3.163/4.400 | - | 7.045/7.000 | - | n/a | n/a | n/a | 16.50 ms | 0 | measured |
| electron | medium | open | ui-frame | 17.533/18.000 | - | - | - | n/a | n/a | n/a | 17.53 ms | 0 | measured |
| electron | medium | input | ui-frame | 2.847/4.500 | - | 7.731/13.900 | 6.670/14.100 | n/a | n/a | n/a | 17.73 ms | 0 | measured |
| electron | medium | scroll | ui-frame | 3.404/4.600 | - | 7.099/7.100 | - | n/a | n/a | n/a | 16.77 ms | 0 | measured |
| electron | large | open | ui-frame | 20.700/21.300 | - | - | - | n/a | n/a | n/a | 20.70 ms | 0 | measured |
| electron | large | input | ui-frame | 2.903/4.500 | - | 7.645/13.800 | 6.883/15.200 | n/a | n/a | n/a | 20.47 ms | 0 | measured |
| electron | large | scroll | ui-frame | 3.349/4.700 | - | 7.037/7.000 | - | n/a | n/a | n/a | 19.77 ms | 0 | measured |
| electron | stress | open | ui-frame | 34.300/36.000 | - | - | - | n/a | n/a | n/a | 34.30 ms | 0 | measured |
| electron | stress | input | ui-frame | 2.903/3.800 | - | 7.967/13.900 | 7.060/16.500 | n/a | n/a | n/a | 34.20 ms | 1 | measured |
| electron | stress | scroll | ui-frame | 3.446/4.700 | - | 7.095/7.100 | - | n/a | n/a | n/a | 35.57 ms | 1 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.34/6.25/6.37 | 9.57/9.16/9.42 | n/a/n/a/n/a | 3.37/3.30/3.34 | 5.75/5.45/5.61 | 1.91/1.90/1.97 | 2.37/2.30/2.55 |
| MoUI Skia GPU | 6.52/6.58/6.58 | 9.99/9.83/9.73 | n/a/n/a/n/a | 3.33/3.38/3.36 | 5.73/5.75/5.58 | 2.11/2.11/2.11 | 2.56/2.60/2.44 |
| MoUI WGPU | 8.59/8.64/8.67 | 11.70/11.99/12.23 | n/a/n/a/n/a | 3.78/3.79/3.82 | 6.13/6.20/6.14 | 3.66/3.68/3.70 | 4.53/4.79/4.89 |
| MoMark Skia Raster | 10.13/10.89/11.36 | 12.51/13.72/13.59 | n/a/n/a/n/a | 3.43/3.65/3.41 | 4.53/4.95/4.39 | 6.16/6.55/6.10 | 7.45/8.27/7.38 |
| MoMark Skia GPU | 28.02/28.20/29.75 | 30.87/30.68/31.77 | n/a/n/a/n/a | 3.47/3.47/3.38 | 4.49/4.44/4.21 | 23.99/24.06/24.38 | 26.59/26.55/25.88 |
| MoMark WGPU | 11.02/11.62/12.53 | 13.48/13.98/14.89 | n/a/n/a/n/a | 4.23/4.38/4.31 | 5.47/5.60/5.53 | 6.31/6.61/6.51 | 7.71/8.16/7.97 |
| GpMark.mbt (GPUI) | 6.94/6.94/6.94 | 7.61/7.65/7.71 | n/a/n/a/n/a | 1.75/1.79/1.80 | 2.52/2.57/2.61 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.06/9.34/9.01 | 6.95/13.89/13.89 | 0/0/0 | 2.43/3.65/3.59 | 3.09/5.60/5.55 | 0.50/0.52/0.52 | 0.63/0.69/0.69 |
| Flutter Impeller | 7.11/9.43/9.80 | 6.95/13.89/13.89 | 0/0/0 | 2.55/3.78/4.02 | 3.27/5.67/6.42 | 1.18/1.23/1.30 | 1.52/1.54/1.81 |
| Electron | 7.04/7.10/7.04 | 7.00/7.10/7.00 | 0/0/0 | 3.16/3.40/3.35 | 4.40/4.60/4.70 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.29 | 9.54 | n/a | 3.32 | 5.68 | 1.92 | 2.38 |
| MoUI Skia GPU | 6.56 | 9.75 | n/a | 3.34 | 5.65 | 2.13 | 2.55 |
| MoUI WGPU | 9.07 | 12.62 | n/a | 3.94 | 6.40 | 3.92 | 5.16 |
| MoMark Skia Raster | 27.14 | 30.46 | n/a | 3.59 | 4.65 | 6.19 | 7.53 |
| MoMark Skia GPU | 44.37 | 46.59 | n/a | 3.54 | 4.33 | 23.74 | 25.42 |
| MoMark WGPU | 28.87 | 35.08 | n/a | 4.48 | 6.00 | 6.79 | 9.09 |
| GpMark.mbt (GPUI) | 6.94 | 7.65 | n/a | 1.83 | 2.58 | n/a | n/a |
| Flutter Skia | 9.23 | 13.89 | 0 | 3.72 | 5.68 | 0.52 | 0.64 |
| Flutter Impeller | 9.70 | 13.89 | 0 | 3.86 | 6.05 | 1.29 | 1.76 |
| Electron | 7.09 | 7.10 | 1 | 3.45 | 4.70 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 4.60/4.40/5.40 | 5.87/4.82/6.95 | 1.88/1.78/1.81 | 2.62/1.97/2.20 | 2.20/2.05/2.23 | 2.78/2.31/2.62 |
| MoUI Skia GPU | 12.45/12.41/14.17 | 14.02/13.01/15.74 | 1.89/1.90/2.05 | 2.27/2.35/2.82 | 9.96/9.85/10.43 | 11.04/10.48/11.75 |
| MoUI WGPU | 10.74/10.93/11.78 | 12.26/12.19/13.76 | 4.90/4.89/4.95 | 6.14/6.17/6.02 | 5.28/5.44/5.51 | 6.32/6.50/6.97 |
| MoMark Skia Raster | 12.27/14.88/43.07 | 13.64/19.22/53.91 | 5.43/5.81/7.41 | 6.27/7.97/11.00 | 5.91/6.30/6.88 | 6.49/7.32/8.46 |
| MoMark Skia GPU | 38.17/39.79/62.58 | 45.03/41.73/65.75 | 5.30/5.23/6.42 | 6.29/6.14/7.55 | 31.90/31.80/31.96 | 35.47/33.34/33.40 |
| MoMark WGPU | 31.11/33.89/59.03 | 35.24/38.46/66.24 | 23.56/24.28/25.68 | 26.13/29.22/30.90 | 6.66/6.77/7.20 | 8.39/7.73/8.85 |
| GpMark.mbt (GPUI) | 6.86/6.91/6.77 | 7.73/8.22/7.74 | 1.46/1.74/1.48 | 1.72/3.10/1.93 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 6.87/6.99/7.13 | 8.29/9.28/8.63 | 0.87/0.85/0.83 | 1.08/1.24/1.06 | 0.55/0.56/0.56 | 0.79/0.83/0.82 |
| Flutter Impeller | 7.01/7.09/7.03 | 8.73/8.02/8.28 | 0.84/0.87/0.83 | 1.15/1.11/1.01 | 1.36/1.35/1.31 | 1.83/1.75/1.81 |
| Electron | 6.90/6.67/6.88 | 13.70/14.10/15.20 | 2.93/2.85/2.90 | 4.70/4.50/4.50 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 14.39 | 17.44 | 1.90 | 2.32 | 2.35 | 2.92 |
| MoUI Skia GPU | 22.21 | 24.37 | 1.95 | 2.22 | 10.20 | 10.81 |
| MoUI WGPU | 21.14 | 23.47 | 4.95 | 6.11 | 5.59 | 6.67 |
| MoMark Skia Raster | 307.62 | 327.46 | 17.23 | 19.03 | 6.27 | 7.15 |
| MoMark Skia GPU | 333.08 | 347.50 | 17.48 | 20.57 | 32.31 | 33.52 |
| MoMark WGPU | 321.37 | 334.96 | 35.05 | 39.54 | 6.87 | 8.36 |
| GpMark.mbt (GPUI) | 23.98 | 27.36 | 1.52 | 1.84 | n/a | n/a |
| Flutter Skia | 6.84 | 8.18 | 0.83 | 1.08 | 0.51 | 0.66 |
| Flutter Impeller | 6.79 | 8.34 | 0.88 | 1.06 | 1.38 | 1.95 |
| Electron | 7.06 | 16.50 | 2.90 | 3.80 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 46.59/45.94/73.47 | 47.61/46.09/74.67 | 0.22/0.67/3.71 | 0.23/0.73/3.76 | 33.23/31.76/31.60 | 34.12/32.24/32.45 | 8.42/7.00/7.85 | 8.73/7.14/8.82 |
| MoUI Skia GPU | 91.91/97.70/123.59 | 92.62/99.91/127.38 | 0.19/0.72/3.94 | 0.20/0.73/4.69 | 29.05/28.42/30.03 | 29.53/29.49/31.93 | 58.43/62.15/58.70 | 58.96/64.86/59.57 |
| MoUI WGPU | 168.57/172.29/202.23 | 170.21/179.81/202.90 | 0.22/0.61/3.92 | 0.32/0.67/4.19 | 126.46/125.74/127.08 | 127.30/129.46/130.18 | 37.58/39.24/41.36 | 38.36/42.49/44.22 |
| MoMark Skia Raster | 63.26/66.34/125.05 | 67.28/68.43/130.42 | 0.16/0.70/4.00 | 0.18/0.76/5.11 | 43.63/41.31/45.42 | 46.31/43.64/48.67 | 12.94/13.42/13.43 | 14.19/13.88/14.93 |
| MoMark Skia GPU | 257.96/265.55/313.24 | 259.01/269.07/319.06 | 0.17/0.67/3.93 | 0.19/0.78/4.07 | 39.67/39.95/41.46 | 40.35/41.35/42.56 | 212.02/214.28/210.78 | 213.13/216.24/213.28 |
| MoMark WGPU | 200.64/215.21/266.42 | 202.36/228.13/274.95 | 0.17/0.55/3.69 | 0.18/0.62/3.92 | 152.23/160.13/159.14 | 153.16/171.27/165.56 | 42.91/44.71/43.67 | 43.90/46.29/46.56 |
| GpMark.mbt (GPUI) | 244.78/249.01/243.30 | 246.90/252.63/244.36 | 0.67/0.33/4.33 | 1.00/1.00/5.00 | 1.67/1.94/1.66 | 1.92/2.55/1.88 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 29.40/29.84/35.34 | 29.93/32.28/37.01 | 0.76/0.89/1.07 | 0.81/0.94/1.27 | 0.47/0.49/1.60 | 0.51/0.51/1.68 | 43.43/42.62/41.21 | 46.78/47.01/42.60 |
| Flutter Impeller | 30.86/29.93/36.77 | 31.94/30.48/41.68 | 0.86/0.75/1.11 | 0.98/0.77/1.13 | 0.57/0.50/1.62 | 0.77/0.64/1.85 | 22.86/21.37/19.99 | 25.64/24.79/22.13 |
| Electron | 29.20/17.53/20.70 | 53.60/18.00/21.30 | 3.92/3.92/4.27 | 4.23/4.19/4.49 | 29.20/17.53/20.70 | 53.60/18.00/21.30 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 353.77 | 359.12 | 37.28 | 37.91 | 30.58 | 30.90 | 7.20 | 7.67 |
| MoUI Skia GPU | 399.30 | 410.04 | 38.75 | 40.17 | 29.44 | 29.78 | 61.38 | 63.17 |
| MoUI WGPU | 474.69 | 478.78 | 38.04 | 40.48 | 128.05 | 129.92 | 38.54 | 39.75 |
| MoMark Skia Raster | 710.02 | 719.98 | 39.09 | 43.30 | 75.59 | 76.27 | 13.13 | 14.41 |
| MoMark Skia GPU | 920.44 | 959.70 | 36.82 | 38.35 | 76.01 | 81.80 | 220.31 | 228.04 |
| MoMark WGPU | 852.89 | 856.89 | 38.80 | 39.49 | 189.84 | 192.80 | 45.41 | 46.60 |
| GpMark.mbt (GPUI) | 244.50 | 246.20 | 37.33 | 39.00 | 1.43 | 1.45 | n/a | n/a |
| Flutter Skia | 83.84 | 85.23 | 3.19 | 3.37 | 0.42 | 0.43 | 41.58 | 43.33 |
| Flutter Impeller | 87.87 | 88.92 | 3.18 | 3.35 | 0.44 | 0.48 | 21.75 | 24.08 |
| Electron | 34.30 | 36.00 | 9.12 | 9.50 | 34.30 | 36.00 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.34/6.25/6.37 | 9.57/9.16/9.42 | n/a/n/a/n/a | 3.37/3.30/3.34 | 5.75/5.45/5.61 | 1.91/1.90/1.97 | 2.37/2.30/2.55 |
| MoUI Skia GPU | 6.52/6.58/6.58 | 9.99/9.83/9.73 | n/a/n/a/n/a | 3.33/3.38/3.36 | 5.73/5.75/5.58 | 2.11/2.11/2.11 | 2.56/2.60/2.44 |
| MoUI WGPU | 8.59/8.64/8.67 | 11.70/11.99/12.23 | n/a/n/a/n/a | 3.78/3.79/3.82 | 6.13/6.20/6.14 | 3.66/3.68/3.70 | 4.53/4.79/4.89 |
| MoMark Skia Raster | 10.13/10.89/11.36 | 12.51/13.72/13.59 | n/a/n/a/n/a | 3.43/3.65/3.41 | 4.53/4.95/4.39 | 6.16/6.55/6.10 | 7.45/8.27/7.38 |
| MoMark Skia GPU | 28.02/28.20/29.75 | 30.87/30.68/31.77 | n/a/n/a/n/a | 3.47/3.47/3.38 | 4.49/4.44/4.21 | 23.99/24.06/24.38 | 26.59/26.55/25.88 |
| MoMark WGPU | 11.02/11.62/12.53 | 13.48/13.98/14.89 | n/a/n/a/n/a | 4.23/4.38/4.31 | 5.47/5.60/5.53 | 6.31/6.61/6.51 | 7.71/8.16/7.97 |
| GpMark.mbt (GPUI) | 6.94/6.94/6.94 | 7.61/7.65/7.71 | n/a/n/a/n/a | 1.75/1.79/1.80 | 2.52/2.57/2.61 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.06/9.34/9.01 | 6.95/13.89/13.89 | 0/0/0 | 2.43/3.65/3.59 | 3.09/5.60/5.55 | 0.50/0.52/0.52 | 0.63/0.69/0.69 |
| Flutter Impeller | 7.11/9.43/9.80 | 6.95/13.89/13.89 | 0/0/0 | 2.55/3.78/4.02 | 3.27/5.67/6.42 | 1.18/1.23/1.30 | 1.52/1.54/1.81 |
| Electron | 7.04/7.10/7.04 | 7.00/7.10/7.00 | 0/0/0 | 3.16/3.40/3.35 | 4.40/4.60/4.70 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.29 | 9.54 | n/a | 3.32 | 5.68 | 1.92 | 2.38 |
| MoUI Skia GPU | 6.56 | 9.75 | n/a | 3.34 | 5.65 | 2.13 | 2.55 |
| MoUI WGPU | 9.07 | 12.62 | n/a | 3.94 | 6.40 | 3.92 | 5.16 |
| MoMark Skia Raster | 27.14 | 30.46 | n/a | 3.59 | 4.65 | 6.19 | 7.53 |
| MoMark Skia GPU | 44.37 | 46.59 | n/a | 3.54 | 4.33 | 23.74 | 25.42 |
| MoMark WGPU | 28.87 | 35.08 | n/a | 4.48 | 6.00 | 6.79 | 9.09 |
| GpMark.mbt (GPUI) | 6.94 | 7.65 | n/a | 1.83 | 2.58 | n/a | n/a |
| Flutter Skia | 9.23 | 13.89 | 0 | 3.72 | 5.68 | 0.52 | 0.64 |
| Flutter Impeller | 9.70 | 13.89 | 0 | 3.86 | 6.05 | 1.29 | 1.76 |
| Electron | 7.09 | 7.10 | 1 | 3.45 | 4.70 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoUI Skia Raster CPU stress 353.8 ms（max 359.1 ms）；MoUI Skia GPU large 123.6 ms（max 127.4 ms）；MoUI Skia GPU stress 399.3 ms（max 410.0 ms）；MoUI WGPU small 168.6 ms（max 170.2 ms）；MoUI WGPU medium 172.3 ms（max 179.8 ms）；MoUI WGPU large 202.2 ms（max 202.9 ms）；MoUI WGPU stress 474.7 ms（max 478.8 ms）；MoMark Skia Raster large 125.0 ms（max 130.4 ms）；MoMark Skia Raster stress 710.0 ms（max 720.0 ms）；MoMark Skia GPU small 258.0 ms（max 259.0 ms）；MoMark Skia GPU medium 265.5 ms（max 269.1 ms）；MoMark Skia GPU large 313.2 ms（max 319.1 ms）；MoMark Skia GPU stress 920.4 ms（max 959.7 ms）；MoMark WGPU small 200.6 ms（max 202.4 ms）；MoMark WGPU medium 215.2 ms（max 228.1 ms）；MoMark WGPU large 266.4 ms（max 274.9 ms）；MoMark WGPU stress 852.9 ms（max 856.9 ms）；GpMark.mbt (GPUI) small 244.8 ms（max 246.9 ms）；GpMark.mbt (GPUI) medium 249.0 ms（max 252.6 ms）；GpMark.mbt (GPUI) large 243.3 ms（max 244.4 ms）；GpMark.mbt (GPUI) stress 244.5 ms（max 246.2 ms）。
- P1 输入尾延迟：MoUI Skia Raster CPU stress P95 17.44 ms；MoUI Skia GPU stress P95 24.37 ms；MoUI WGPU stress P95 23.47 ms；MoMark Skia Raster medium P95 19.22 ms；MoMark Skia Raster large P95 53.91 ms；MoMark Skia Raster stress P95 327.46 ms；MoMark Skia GPU small P95 45.03 ms；MoMark Skia GPU medium P95 41.73 ms；MoMark Skia GPU large P95 65.75 ms；MoMark Skia GPU stress P95 347.50 ms；MoMark WGPU small P95 35.24 ms；MoMark WGPU medium P95 38.46 ms；MoMark WGPU large P95 66.24 ms；MoMark WGPU stress P95 334.96 ms；GpMark.mbt (GPUI) stress P95 27.36 ms。
- 长帧（超预算）：MoUI Skia Raster CPU: stress/input 3 次，max 17.94 ms；MoUI Skia GPU: medium/scroll 1 次，max 17.35 ms, stress/input 30 次，max 25.40 ms；MoUI WGPU: stress/input 30 次，max 24.09 ms；MoMark Skia Raster: medium/input 5 次，max 19.88 ms, large/input 30 次，max 62.95 ms, large/scroll 1 次，max 19.82 ms, stress/input 30 次，max 335.88 ms, stress/scroll 360 次，max 36.33 ms；MoMark Skia GPU: small/input 30 次，max 46.22 ms, small/scroll 360 次，max 38.53 ms, medium/input 30 次，max 41.73 ms, medium/scroll 360 次，max 42.84 ms, large/input 30 次，max 67.03 ms, large/scroll 360 次，max 39.51 ms, stress/input 30 次，max 385.54 ms, stress/scroll 360 次，max 59.80 ms；MoMark WGPU: small/input 30 次，max 37.11 ms, medium/input 30 次，max 41.14 ms, medium/scroll 1 次，max 17.60 ms, large/input 30 次，max 74.30 ms, large/scroll 3 次，max 17.82 ms, stress/input 30 次，max 335.30 ms, stress/scroll 360 次，max 57.39 ms；GpMark.mbt (GPUI): stress/input 27 次，max 28.33 ms；Electron: stress/input 1 次，max 20.80 ms, stress/scroll 1 次，max 20.80 ms。
- 丢帧（优先处理）：Electron: stress/input 1 帧, stress/scroll 1 帧。
- 解释：首帧异常优先检查窗口/渲染器初始化；输入尾延迟检查 action 到下一可见帧的调度与同步重建；长帧检查解析、布局、文本 shaping 和 GPU 提交；`n/a` 表示未埋点，不等于 0。
- 普通模式的长帧、帧间隔和输入延迟是各框架回调诊断，不能替代跨框架 compositor 排名；需要严格结论时运行 `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`。

## 采集口径

- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。
- `frame_work_ms` 统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏；对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `device_present_ms`：设备/上屏侧统一字段。MoUI raster 为 Skia CPU 光栅化+像素回读整体；MoUI GPU/wgpu 为提交后同步等待设备完成（headless host-surface 逐帧同步，真实应用的 vsync 流水线可重叠掉一部分，该值应视为上屏成本上界）；Flutter 为 `FrameTiming.rasterDuration`（光栅线程任务时间，含显示列表光栅化与 GPU 提交、不含设备完成等待）；GPUI 与 Electron 适配器侧无法观测，显示 `n/a`。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧；严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代；打开场景没有前一帧，所以不计算 interval/drop。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。
