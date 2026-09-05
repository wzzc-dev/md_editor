# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-05T14:17:08Z`
- 数据状态：`324 measured`，`36 skipped/error`；原始样本保留在 JSON。
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
| moui-skia-raster | small | open | ui-frame | 30.784/32.691 | - | - | - | 7.95 ms | 0.00 ms | 7.95 ms | 43.39 ms | n/a | measured |
| moui-skia-raster | small | input | ui-frame | 1.850/2.178 | - | 4.631/5.342 | 4.630/5.340 | 2.24 ms | 0.00 ms | 2.24 ms | 46.66 ms | n/a | measured |
| moui-skia-raster | small | scroll | ui-frame | 3.444/5.991 | - | 6.531/10.212 | - | 1.96 ms | 0.00 ms | 1.96 ms | 44.49 ms | n/a | measured |
| moui-skia-raster | medium | open | ui-frame | 33.432/37.778 | - | - | - | 7.99 ms | 0.00 ms | 7.99 ms | 50.53 ms | n/a | measured |
| moui-skia-raster | medium | input | ui-frame | 1.867/2.531 | - | 4.699/5.906 | 4.698/5.905 | 2.20 ms | 0.00 ms | 2.20 ms | 48.90 ms | n/a | measured |
| moui-skia-raster | medium | scroll | ui-frame | 3.440/5.707 | - | 6.556/9.638 | - | 2.01 ms | 0.00 ms | 2.01 ms | 48.47 ms | n/a | measured |
| moui-skia-raster | large | open | ui-frame | 33.144/34.533 | - | - | - | 7.97 ms | 0.00 ms | 7.97 ms | 79.14 ms | n/a | measured |
| moui-skia-raster | large | input | ui-frame | 1.875/2.212 | - | 5.447/5.966 | 5.446/5.963 | 2.19 ms | 0.00 ms | 2.19 ms | 78.40 ms | n/a | measured |
| moui-skia-raster | large | scroll | ui-frame | 3.421/5.878 | - | 6.492/9.826 | - | 1.98 ms | 0.00 ms | 1.98 ms | 78.10 ms | n/a | measured |
| moui-skia-raster | stress | open | ui-frame | 32.105/33.293 | - | - | - | 8.00 ms | 0.00 ms | 8.00 ms | 369.46 ms | n/a | measured |
| moui-skia-raster | stress | input | ui-frame | 1.998/2.380 | - | 14.903/16.612 | 14.902/16.611 | 2.43 ms | 0.00 ms | 2.43 ms | 358.05 ms | n/a | measured |
| moui-skia-raster | stress | scroll | ui-frame | 3.416/5.795 | - | 6.476/9.775 | - | 1.97 ms | 0.00 ms | 1.97 ms | 359.49 ms | n/a | measured |
| moui-skia-gpu | small | open | ui-frame | 31.201/34.956 | - | - | - | 64.29 ms | 0.00 ms | 64.29 ms | 99.82 ms | n/a | measured |
| moui-skia-gpu | small | input | ui-frame | 2.004/2.457 | - | 12.644/13.733 | 12.642/13.731 | 10.02 ms | 0.00 ms | 10.02 ms | 99.52 ms | n/a | measured |
| moui-skia-gpu | small | scroll | ui-frame | 3.406/5.769 | - | 6.714/10.140 | - | 2.19 ms | 0.00 ms | 2.19 ms | 94.15 ms | n/a | measured |
| moui-skia-gpu | medium | open | ui-frame | 29.544/30.814 | - | - | - | 60.30 ms | 0.00 ms | 60.30 ms | 97.39 ms | n/a | measured |
| moui-skia-gpu | medium | input | ui-frame | 2.019/2.590 | - | 12.791/15.067 | 12.790/15.065 | 10.12 ms | 0.00 ms | 10.12 ms | 104.66 ms | n/a | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 3.459/5.600 | - | 6.859/10.140 | - | 2.25 ms | 0.00 ms | 2.25 ms | 97.13 ms | n/a | measured |
| moui-skia-gpu | large | open | ui-frame | 29.938/30.348 | - | - | - | 61.84 ms | 0.00 ms | 61.84 ms | 130.09 ms | n/a | measured |
| moui-skia-gpu | large | input | ui-frame | 1.917/2.207 | - | 13.345/14.181 | 13.343/14.178 | 9.83 ms | 0.00 ms | 9.83 ms | 132.62 ms | n/a | measured |
| moui-skia-gpu | large | scroll | ui-frame | 3.479/6.068 | - | 6.753/10.304 | - | 2.15 ms | 0.00 ms | 2.15 ms | 130.05 ms | n/a | measured |
| moui-skia-gpu | stress | open | ui-frame | 30.433/31.273 | - | - | - | 62.53 ms | 0.00 ms | 62.53 ms | 424.53 ms | n/a | measured |
| moui-skia-gpu | stress | input | ui-frame | 2.043/3.043 | - | 23.061/25.687 | 23.060/25.687 | 10.32 ms | 0.00 ms | 10.32 ms | 421.34 ms | n/a | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 3.436/5.832 | - | 6.876/10.392 | - | 2.31 ms | 0.00 ms | 2.31 ms | 409.36 ms | n/a | measured |
| moui-wgpu | small | open | ui-frame | 136.220/145.456 | - | - | - | 38.89 ms | n/a | 0.00 ms | 179.25 ms | n/a | measured |
| moui-wgpu | small | input | ui-frame | 5.019/6.159 | - | 11.073/12.755 | 11.072/12.754 | 5.49 ms | n/a | 0.00 ms | 181.74 ms | n/a | measured |
| moui-wgpu | small | scroll | ui-frame | 3.872/6.343 | - | 8.844/12.294 | - | 3.80 ms | n/a | 0.00 ms | 176.77 ms | n/a | measured |
| moui-wgpu | medium | open | ui-frame | 138.415/153.405 | - | - | - | 40.53 ms | n/a | 0.00 ms | 186.39 ms | n/a | measured |
| moui-wgpu | medium | input | ui-frame | 5.191/7.146 | - | 11.509/13.673 | 11.508/13.672 | 5.66 ms | n/a | 0.00 ms | 179.30 ms | n/a | measured |
| moui-wgpu | medium | scroll | ui-frame | 3.854/6.389 | - | 8.825/12.393 | - | 3.81 ms | n/a | 0.00 ms | 192.41 ms | n/a | measured |
| moui-wgpu | large | open | ui-frame | 129.612/133.020 | - | - | - | 39.82 ms | n/a | 0.00 ms | 204.87 ms | n/a | measured |
| moui-wgpu | large | input | ui-frame | 4.940/5.701 | - | 12.080/13.529 | 12.080/13.528 | 5.68 ms | n/a | 0.00 ms | 209.63 ms | n/a | measured |
| moui-wgpu | large | scroll | ui-frame | 3.876/6.207 | - | 8.909/12.250 | - | 3.86 ms | n/a | 0.00 ms | 211.44 ms | n/a | measured |
| moui-wgpu | stress | open | ui-frame | 133.079/133.408 | - | - | - | 39.39 ms | n/a | 0.00 ms | 497.33 ms | n/a | measured |
| moui-wgpu | stress | input | ui-frame | 5.050/5.957 | - | 21.623/23.884 | 21.621/23.884 | 5.67 ms | n/a | 0.00 ms | 497.38 ms | n/a | measured |
| moui-wgpu | stress | scroll | ui-frame | 3.875/6.356 | - | 8.915/12.492 | - | 3.88 ms | n/a | 0.00 ms | 499.44 ms | n/a | measured |
| moui-md-skia-raster | small | open | ui-frame | 43.271/44.864 | - | - | - | 13.34 ms | 0.00 ms | 13.34 ms | 63.22 ms | n/a | measured |
| moui-md-skia-raster | small | input | ui-frame | 5.349/6.984 | - | 12.308/14.347 | 12.239/14.345 | 6.00 ms | 0.00 ms | 6.00 ms | 66.41 ms | n/a | measured |
| moui-md-skia-raster | small | scroll | ui-frame | 3.487/4.570 | - | 10.266/12.484 | - | 6.23 ms | 0.00 ms | 6.23 ms | 62.30 ms | n/a | measured |
| moui-md-skia-raster | medium | open | ui-frame | 46.169/49.673 | - | - | - | 13.95 ms | 0.00 ms | 13.95 ms | 72.86 ms | n/a | measured |
| moui-md-skia-raster | medium | input | ui-frame | 5.576/6.772 | - | 14.226/16.844 | 14.154/16.843 | 6.00 ms | 0.00 ms | 6.00 ms | 71.10 ms | n/a | measured |
| moui-md-skia-raster | medium | scroll | ui-frame | 3.470/4.678 | - | 10.253/12.494 | - | 6.14 ms | 0.00 ms | 6.14 ms | 67.89 ms | n/a | measured |
| moui-md-skia-raster | large | open | ui-frame | 44.543/45.785 | - | - | - | 13.15 ms | 0.00 ms | 13.15 ms | 124.40 ms | n/a | measured |
| moui-md-skia-raster | large | input | ui-frame | 6.741/8.385 | - | 37.991/41.734 | 37.919/41.734 | 6.21 ms | 0.00 ms | 6.21 ms | 131.76 ms | n/a | measured |
| moui-md-skia-raster | large | scroll | ui-frame | 3.533/4.682 | - | 11.738/14.023 | - | 6.32 ms | 0.00 ms | 6.32 ms | 124.41 ms | n/a | measured |
| moui-md-skia-raster | stress | open | ui-frame | 81.672/88.170 | - | - | - | 12.26 ms | 0.00 ms | 12.26 ms | 722.01 ms | n/a | measured |
| moui-md-skia-raster | stress | input | ui-frame | 17.867/19.532 | - | 315.298/334.110 | 315.222/334.109 | 6.56 ms | 0.00 ms | 6.56 ms | 739.73 ms | n/a | measured |
| moui-md-skia-raster | stress | scroll | ui-frame | 3.599/4.708 | - | 27.403/30.441 | - | 6.29 ms | 0.00 ms | 6.29 ms | 740.77 ms | n/a | measured |
| moui-md-skia-gpu | small | open | ui-frame | 40.557/41.203 | - | - | - | 208.52 ms | 0.00 ms | 208.52 ms | 254.93 ms | n/a | measured |
| moui-md-skia-gpu | small | input | ui-frame | 5.526/6.436 | - | 39.046/45.586 | 38.960/45.580 | 32.43 ms | 0.00 ms | 32.43 ms | 265.87 ms | n/a | measured |
| moui-md-skia-gpu | small | scroll | ui-frame | 3.646/4.791 | - | 28.647/31.164 | - | 24.37 ms | 0.00 ms | 24.37 ms | 255.38 ms | n/a | measured |
| moui-md-skia-gpu | medium | open | ui-frame | 43.988/48.477 | - | - | - | 213.32 ms | 0.00 ms | 213.32 ms | 268.67 ms | n/a | measured |
| moui-md-skia-gpu | medium | input | ui-frame | 5.575/6.519 | - | 40.948/43.489 | 40.872/43.463 | 32.49 ms | 0.00 ms | 32.49 ms | 274.89 ms | n/a | measured |
| moui-md-skia-gpu | medium | scroll | ui-frame | 3.545/4.553 | - | 28.279/30.609 | - | 24.04 ms | 0.00 ms | 24.04 ms | 263.93 ms | n/a | measured |
| moui-md-skia-gpu | large | open | ui-frame | 46.907/48.370 | - | - | - | 211.46 ms | 0.00 ms | 211.46 ms | 323.47 ms | n/a | measured |
| moui-md-skia-gpu | large | input | ui-frame | 6.844/7.879 | - | 65.030/68.967 | 64.948/68.966 | 32.22 ms | 0.00 ms | 32.22 ms | 330.56 ms | n/a | measured |
| moui-md-skia-gpu | large | scroll | ui-frame | 3.522/4.458 | - | 29.464/31.416 | - | 23.89 ms | 0.00 ms | 23.89 ms | 324.04 ms | n/a | measured |
| moui-md-skia-gpu | stress | open | ui-frame | 77.268/78.715 | - | - | - | 207.33 ms | 0.00 ms | 207.33 ms | 926.92 ms | n/a | measured |
| moui-md-skia-gpu | stress | input | ui-frame | 18.032/22.015 | - | 339.732/365.521 | 339.643/365.519 | 32.60 ms | 0.00 ms | 32.60 ms | 946.11 ms | n/a | measured |
| moui-md-skia-gpu | stress | scroll | ui-frame | 3.653/4.639 | - | 45.600/48.479 | - | 24.33 ms | 0.00 ms | 24.33 ms | 914.10 ms | n/a | measured |
| moui-md-wgpu | small | open | ui-frame | 160.991/162.667 | - | - | - | 43.22 ms | n/a | 0.00 ms | 209.87 ms | n/a | measured |
| moui-md-wgpu | small | input | ui-frame | 24.005/27.440 | - | 31.996/36.213 | 31.921/36.210 | 6.93 ms | n/a | 0.00 ms | 217.44 ms | n/a | measured |
| moui-md-wgpu | small | scroll | ui-frame | 4.405/5.598 | - | 11.484/13.927 | - | 6.57 ms | n/a | 0.00 ms | 210.52 ms | n/a | measured |
| moui-md-wgpu | medium | open | ui-frame | 158.458/159.288 | - | - | - | 45.27 ms | n/a | 0.00 ms | 214.63 ms | n/a | measured |
| moui-md-wgpu | medium | input | ui-frame | 23.145/25.457 | - | 32.898/35.264 | 32.827/35.263 | 6.85 ms | n/a | 0.00 ms | 223.17 ms | n/a | measured |
| moui-md-wgpu | medium | scroll | ui-frame | 4.445/5.816 | - | 11.699/14.382 | - | 6.61 ms | n/a | 0.00 ms | 214.66 ms | n/a | measured |
| moui-md-wgpu | large | open | ui-frame | 165.276/167.850 | - | - | - | 42.47 ms | n/a | 0.00 ms | 271.14 ms | n/a | measured |
| moui-md-wgpu | large | input | ui-frame | 25.889/29.924 | - | 58.226/65.692 | 58.125/65.691 | 7.15 ms | n/a | 0.00 ms | 281.09 ms | n/a | measured |
| moui-md-wgpu | large | scroll | ui-frame | 4.458/5.947 | - | 13.028/16.036 | - | 6.76 ms | n/a | 0.00 ms | 277.34 ms | n/a | measured |
| moui-md-wgpu | stress | open | ui-frame | 200.344/203.109 | - | - | - | 44.93 ms | n/a | 0.00 ms | 883.42 ms | n/a | measured |
| moui-md-wgpu | stress | input | ui-frame | 36.148/38.833 | - | 331.497/345.467 | 331.393/345.465 | 7.41 ms | n/a | 0.00 ms | 900.22 ms | n/a | measured |
| moui-md-wgpu | stress | scroll | ui-frame | 4.509/5.825 | - | 29.217/32.688 | - | 6.95 ms | n/a | 0.00 ms | 882.45 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 0.472/0.553 | - | - | - | 41.58 ms | n/a | n/a | 27.84 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 0.836/0.944 | - | 6.809/6.945 | 6.955/8.655 | 0.53 ms | n/a | n/a | 30.00 ms | 0 | measured |
| flutter-skia | small | scroll | ui-frame | 2.574/3.415 | - | 7.209/9.057 | - | 0.51 ms | n/a | n/a | 29.08 ms | 0 | measured |
| flutter-skia | medium | open | ui-frame | 0.458/0.515 | - | - | - | 43.76 ms | n/a | n/a | 28.63 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 0.831/1.292 | - | 6.872/6.945 | 6.991/9.179 | 0.51 ms | n/a | n/a | 28.73 ms | 0 | measured |
| flutter-skia | medium | scroll | ui-frame | 3.926/5.884 | - | 9.562/13.889 | - | 0.58 ms | n/a | n/a | 30.12 ms | 0 | measured |
| flutter-skia | large | open | ui-frame | 1.595/1.660 | - | - | - | 40.62 ms | n/a | n/a | 33.64 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 0.863/1.021 | - | 7.022/9.263 | 6.947/8.643 | 0.51 ms | n/a | n/a | 34.52 ms | 0 | measured |
| flutter-skia | large | scroll | ui-frame | 3.736/5.762 | - | 9.465/13.889 | - | 0.56 ms | n/a | n/a | 34.07 ms | 0 | measured |
| flutter-skia | stress | open | ui-frame | 0.434/0.494 | - | - | - | 42.45 ms | n/a | n/a | 88.71 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 0.904/1.165 | - | 6.547/6.945 | 6.550/7.709 | 0.55 ms | n/a | n/a | 90.05 ms | 0 | measured |
| flutter-skia | stress | scroll | ui-frame | 3.961/6.262 | - | 9.633/13.889 | - | 0.57 ms | n/a | n/a | 87.56 ms | 0 | measured |
| flutter-impeller | small | open | ui-frame | 0.447/0.509 | - | - | - | 21.09 ms | n/a | n/a | 29.46 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 0.922/1.226 | - | 6.944/6.945 | 6.984/8.258 | 1.32 ms | n/a | n/a | 32.74 ms | 0 | measured |
| flutter-impeller | small | scroll | ui-frame | 2.599/3.538 | - | 7.022/6.945 | - | 1.16 ms | n/a | n/a | 29.21 ms | 0 | measured |
| flutter-impeller | medium | open | ui-frame | 0.487/0.506 | - | - | - | 20.44 ms | n/a | n/a | 30.35 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 0.926/1.341 | - | 7.047/10.022 | 7.095/9.168 | 1.33 ms | n/a | n/a | 30.82 ms | 0 | measured |
| flutter-impeller | medium | scroll | ui-frame | 3.970/6.362 | - | 9.626/13.889 | - | 1.32 ms | n/a | n/a | 30.51 ms | 0 | measured |
| flutter-impeller | large | open | ui-frame | 1.634/1.754 | - | - | - | 19.32 ms | n/a | n/a | 36.08 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 0.898/1.301 | - | 6.944/6.945 | 6.939/8.304 | 1.30 ms | n/a | n/a | 36.20 ms | 0 | measured |
| flutter-impeller | large | scroll | ui-frame | 3.995/5.934 | - | 10.070/13.889 | - | 1.36 ms | n/a | n/a | 35.20 ms | 0 | measured |
| flutter-impeller | stress | open | ui-frame | 0.588/0.785 | - | - | - | 20.89 ms | n/a | n/a | 91.77 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 1.016/1.155 | - | 6.944/6.945 | 6.983/8.124 | 1.32 ms | n/a | n/a | 89.11 ms | 0 | measured |
| flutter-impeller | stress | scroll | ui-frame | 4.064/6.289 | - | 9.664/13.889 | - | 1.34 ms | n/a | n/a | 91.01 ms | 0 | measured |
| electron | small | open | ui-frame | 30.367/54.900 | - | - | - | n/a | n/a | n/a | 30.37 ms | 0 | measured |
| electron | small | input | ui-frame | 3.090/4.300 | - | 8.194/13.900 | 6.997/14.000 | n/a | n/a | n/a | 29.77 ms | 1 | measured |
| electron | small | scroll | ui-frame | 3.326/4.600 | - | 7.037/7.000 | - | n/a | n/a | n/a | 30.20 ms | 0 | measured |
| electron | medium | open | ui-frame | 17.667/18.000 | - | - | - | n/a | n/a | n/a | 17.67 ms | 0 | measured |
| electron | medium | input | ui-frame | 3.040/4.600 | - | 8.098/13.900 | 7.017/14.100 | n/a | n/a | n/a | 18.73 ms | 0 | measured |
| electron | medium | scroll | ui-frame | 3.489/4.600 | - | 6.999/7.000 | - | n/a | n/a | n/a | 18.53 ms | 0 | measured |
| electron | large | open | ui-frame | 22.167/23.600 | - | - | - | n/a | n/a | n/a | 22.17 ms | 0 | measured |
| electron | large | input | ui-frame | 3.030/4.700 | - | 8.197/13.800 | 7.073/14.500 | n/a | n/a | n/a | 20.43 ms | 0 | measured |
| electron | large | scroll | ui-frame | 3.511/5.000 | - | 7.011/7.000 | - | n/a | n/a | n/a | 22.23 ms | 0 | measured |
| electron | stress | open | ui-frame | 36.767/39.800 | - | - | - | n/a | n/a | n/a | 36.77 ms | 0 | measured |
| electron | stress | input | ui-frame | 3.043/4.600 | - | 7.221/13.900 | 6.870/16.700 | n/a | n/a | n/a | 35.43 ms | 0 | measured |
| electron | stress | scroll | ui-frame | 3.569/4.800 | - | 7.072/7.000 | - | n/a | n/a | n/a | 36.37 ms | 0 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.53/6.56/6.49 | 10.21/9.64/9.83 | n/a/n/a/n/a | 3.44/3.44/3.42 | 5.99/5.71/5.88 | 1.96/2.01/1.98 | 2.39/2.51/2.46 |
| MoUI Skia GPU | 6.71/6.86/6.75 | 10.14/10.14/10.30 | n/a/n/a/n/a | 3.41/3.46/3.48 | 5.77/5.60/6.07 | 2.19/2.25/2.15 | 2.71/2.87/2.54 |
| MoUI WGPU | 8.84/8.82/8.91 | 12.29/12.39/12.25 | n/a/n/a/n/a | 3.87/3.85/3.88 | 6.34/6.39/6.21 | 3.80/3.81/3.86 | 4.87/4.84/5.03 |
| MoMark Skia Raster | 10.27/10.25/11.74 | 12.48/12.49/14.02 | n/a/n/a/n/a | 3.49/3.47/3.53 | 4.57/4.68/4.68 | 6.23/6.14/6.32 | 7.56/7.46/7.62 |
| MoMark Skia GPU | 28.65/28.28/29.46 | 31.16/30.61/31.42 | n/a/n/a/n/a | 3.65/3.55/3.52 | 4.79/4.55/4.46 | 24.37/24.04/23.89 | 26.40/25.71/25.15 |
| MoMark WGPU | 11.48/11.70/13.03 | 13.93/14.38/16.04 | n/a/n/a/n/a | 4.41/4.44/4.46 | 5.60/5.82/5.95 | 6.57/6.61/6.76 | 8.09/8.16/8.60 |
| GpMark.mbt (GPUI) | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.21/9.56/9.46 | 9.06/13.89/13.89 | 0/0/0 | 2.57/3.93/3.74 | 3.42/5.88/5.76 | 0.51/0.58/0.56 | 0.67/0.78/0.80 |
| Flutter Impeller | 7.02/9.63/10.07 | 6.95/13.89/13.89 | 0/0/0 | 2.60/3.97/4.00 | 3.54/6.36/5.93 | 1.16/1.32/1.36 | 1.35/1.68/1.78 |
| Electron | 7.04/7.00/7.01 | 7.00/7.00/7.00 | 0/0/0 | 3.33/3.49/3.51 | 4.60/4.60/5.00 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.48 | 9.78 | n/a | 3.42 | 5.80 | 1.97 | 2.48 |
| MoUI Skia GPU | 6.88 | 10.39 | n/a | 3.44 | 5.83 | 2.31 | 3.93 |
| MoUI WGPU | 8.92 | 12.49 | n/a | 3.87 | 6.36 | 3.88 | 5.10 |
| MoMark Skia Raster | 27.40 | 30.44 | n/a | 3.60 | 4.71 | 6.29 | 7.65 |
| MoMark Skia GPU | 45.60 | 48.48 | n/a | 3.65 | 4.64 | 24.33 | 25.87 |
| MoMark WGPU | 29.22 | 32.69 | n/a | 4.51 | 5.82 | 6.95 | 8.71 |
| GpMark.mbt (GPUI) | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Skia | 9.63 | 13.89 | 0 | 3.96 | 6.26 | 0.57 | 0.77 |
| Flutter Impeller | 9.66 | 13.89 | 0 | 4.06 | 6.29 | 1.34 | 1.74 |
| Electron | 7.07 | 7.00 | 0 | 3.57 | 4.80 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 4.63/4.70/5.45 | 5.34/5.91/5.96 | 1.85/1.87/1.88 | 2.18/2.53/2.21 | 2.24/2.20/2.19 | 2.82/2.51/2.64 |
| MoUI Skia GPU | 12.64/12.79/13.34 | 13.73/15.07/14.18 | 2.00/2.02/1.92 | 2.46/2.59/2.21 | 10.02/10.12/9.83 | 11.37/12.04/10.33 |
| MoUI WGPU | 11.07/11.51/12.08 | 12.75/13.67/13.53 | 5.02/5.19/4.94 | 6.16/7.15/5.70 | 5.49/5.66/5.68 | 6.93/6.93/6.96 |
| MoMark Skia Raster | 12.24/14.15/37.92 | 14.35/16.84/41.73 | 5.35/5.58/6.74 | 6.98/6.77/8.39 | 6.00/6.00/6.21 | 7.25/7.59/7.34 |
| MoMark Skia GPU | 38.96/40.87/64.95 | 45.58/43.46/68.97 | 5.53/5.58/6.84 | 6.44/6.52/7.88 | 32.43/32.49/32.22 | 37.11/34.74/33.69 |
| MoMark WGPU | 31.92/32.83/58.13 | 36.21/35.26/65.69 | 24.00/23.15/25.89 | 27.44/25.46/29.92 | 6.93/6.85/7.15 | 8.39/7.92/8.49 |
| GpMark.mbt (GPUI) | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 6.95/6.99/6.95 | 8.65/9.18/8.64 | 0.84/0.83/0.86 | 0.94/1.29/1.02 | 0.53/0.51/0.51 | 0.67/0.75/0.65 |
| Flutter Impeller | 6.98/7.10/6.94 | 8.26/9.17/8.30 | 0.92/0.93/0.90 | 1.23/1.34/1.30 | 1.32/1.33/1.30 | 1.59/1.72/1.74 |
| Electron | 7.00/7.02/7.07 | 14.00/14.10/14.50 | 3.09/3.04/3.03 | 4.30/4.60/4.70 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 14.90 | 16.61 | 2.00 | 2.38 | 2.43 | 3.01 |
| MoUI Skia GPU | 23.06 | 25.69 | 2.04 | 3.04 | 10.32 | 12.68 |
| MoUI WGPU | 21.62 | 23.88 | 5.05 | 5.96 | 5.67 | 6.59 |
| MoMark Skia Raster | 315.22 | 334.11 | 17.87 | 19.53 | 6.56 | 7.58 |
| MoMark Skia GPU | 339.64 | 365.52 | 18.03 | 22.01 | 32.60 | 34.57 |
| MoMark WGPU | 331.39 | 345.46 | 36.15 | 38.83 | 7.41 | 8.81 |
| GpMark.mbt (GPUI) | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Skia | 6.55 | 7.71 | 0.90 | 1.17 | 0.55 | 0.71 |
| Flutter Impeller | 6.98 | 8.12 | 1.02 | 1.16 | 1.32 | 1.73 |
| Electron | 6.87 | 16.70 | 3.04 | 4.60 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 43.39/50.53/79.14 | 45.69/58.90/82.77 | 0.17/0.69/3.58 | 0.17/0.74/3.65 | 30.78/33.43/33.14 | 32.69/37.78/34.53 | 7.95/7.99/7.97 | 8.18/9.45/8.42 |
| MoUI Skia GPU | 99.82/97.39/130.09 | 103.37/101.25/134.46 | 0.27/0.65/3.62 | 0.31/0.72/3.71 | 31.20/29.54/29.94 | 34.96/30.81/30.35 | 64.29/60.30/61.84 | 67.27/63.28/63.48 |
| MoUI WGPU | 179.25/186.39/204.87 | 186.54/203.54/208.34 | 0.17/0.68/3.91 | 0.18/0.73/4.10 | 136.22/138.42/129.61 | 145.46/153.41/133.02 | 38.89/40.53/39.82 | 40.56/42.79/40.58 |
| MoMark Skia Raster | 63.22/72.86/124.40 | 65.45/78.58/129.58 | 0.17/0.80/3.97 | 0.19/0.99/4.15 | 43.27/46.17/44.54 | 44.86/49.67/45.79 | 13.34/13.95/13.15 | 13.50/14.20/15.45 |
| MoMark Skia GPU | 254.93/268.67/323.47 | 257.94/279.04/327.28 | 0.18/0.60/3.75 | 0.19/0.65/3.90 | 40.56/43.99/46.91 | 41.20/48.48/48.37 | 208.52/213.32/211.46 | 210.98/218.66/213.89 |
| MoMark WGPU | 209.87/214.63/271.14 | 212.39/216.47/272.76 | 0.18/0.58/3.71 | 0.20/0.60/4.01 | 160.99/158.46/165.28 | 162.67/159.29/167.85 | 43.22/45.27/42.47 | 47.33/47.12/45.62 |
| GpMark.mbt (GPUI) | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 27.84/28.63/33.64 | 28.25/29.28/33.81 | 0.74/0.94/1.02 | 0.76/0.96/1.12 | 0.47/0.46/1.59 | 0.55/0.52/1.66 | 41.58/43.76/40.62 | 45.31/46.02/41.21 |
| Flutter Impeller | 29.46/30.35/36.08 | 30.02/30.84/36.73 | 0.79/0.81/1.19 | 0.87/0.87/1.28 | 0.45/0.49/1.63 | 0.51/0.51/1.75 | 21.09/20.44/19.32 | 21.92/23.75/20.11 |
| Electron | 30.37/17.67/22.17 | 54.90/18.00/23.60 | 4.68/3.91/4.03 | 5.55/4.35/4.36 | 30.37/17.67/22.17 | 54.90/18.00/23.60 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 369.46 | 371.23 | 37.34 | 38.50 | 32.11 | 33.29 | 8.00 | 8.28 |
| MoUI Skia GPU | 424.53 | 439.25 | 38.14 | 40.17 | 30.43 | 31.27 | 62.53 | 65.02 |
| MoUI WGPU | 497.33 | 507.69 | 39.16 | 39.79 | 133.08 | 133.41 | 39.39 | 39.70 |
| MoMark Skia Raster | 722.01 | 727.54 | 38.35 | 38.90 | 81.67 | 88.17 | 12.26 | 12.87 |
| MoMark Skia GPU | 926.92 | 939.43 | 37.28 | 38.02 | 77.27 | 78.71 | 207.33 | 208.35 |
| MoMark WGPU | 883.42 | 888.83 | 38.69 | 41.01 | 200.34 | 203.11 | 44.93 | 47.28 |
| GpMark.mbt (GPUI) | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Skia | 88.71 | 91.09 | 3.92 | 4.64 | 0.43 | 0.49 | 42.45 | 44.91 |
| Flutter Impeller | 91.77 | 96.67 | 3.59 | 3.71 | 0.59 | 0.79 | 20.89 | 24.00 |
| Electron | 36.77 | 39.80 | 9.83 | 10.80 | 36.77 | 39.80 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.53/6.56/6.49 | 10.21/9.64/9.83 | n/a/n/a/n/a | 3.44/3.44/3.42 | 5.99/5.71/5.88 | 1.96/2.01/1.98 | 2.39/2.51/2.46 |
| MoUI Skia GPU | 6.71/6.86/6.75 | 10.14/10.14/10.30 | n/a/n/a/n/a | 3.41/3.46/3.48 | 5.77/5.60/6.07 | 2.19/2.25/2.15 | 2.71/2.87/2.54 |
| MoUI WGPU | 8.84/8.82/8.91 | 12.29/12.39/12.25 | n/a/n/a/n/a | 3.87/3.85/3.88 | 6.34/6.39/6.21 | 3.80/3.81/3.86 | 4.87/4.84/5.03 |
| MoMark Skia Raster | 10.27/10.25/11.74 | 12.48/12.49/14.02 | n/a/n/a/n/a | 3.49/3.47/3.53 | 4.57/4.68/4.68 | 6.23/6.14/6.32 | 7.56/7.46/7.62 |
| MoMark Skia GPU | 28.65/28.28/29.46 | 31.16/30.61/31.42 | n/a/n/a/n/a | 3.65/3.55/3.52 | 4.79/4.55/4.46 | 24.37/24.04/23.89 | 26.40/25.71/25.15 |
| MoMark WGPU | 11.48/11.70/13.03 | 13.93/14.38/16.04 | n/a/n/a/n/a | 4.41/4.44/4.46 | 5.60/5.82/5.95 | 6.57/6.61/6.76 | 8.09/8.16/8.60 |
| GpMark.mbt (GPUI) | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.21/9.56/9.46 | 9.06/13.89/13.89 | 0/0/0 | 2.57/3.93/3.74 | 3.42/5.88/5.76 | 0.51/0.58/0.56 | 0.67/0.78/0.80 |
| Flutter Impeller | 7.02/9.63/10.07 | 6.95/13.89/13.89 | 0/0/0 | 2.60/3.97/4.00 | 3.54/6.36/5.93 | 1.16/1.32/1.36 | 1.35/1.68/1.78 |
| Electron | 7.04/7.00/7.01 | 7.00/7.00/7.00 | 0/0/0 | 3.33/3.49/3.51 | 4.60/4.60/5.00 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.48 | 9.78 | n/a | 3.42 | 5.80 | 1.97 | 2.48 |
| MoUI Skia GPU | 6.88 | 10.39 | n/a | 3.44 | 5.83 | 2.31 | 3.93 |
| MoUI WGPU | 8.92 | 12.49 | n/a | 3.87 | 6.36 | 3.88 | 5.10 |
| MoMark Skia Raster | 27.40 | 30.44 | n/a | 3.60 | 4.71 | 6.29 | 7.65 |
| MoMark Skia GPU | 45.60 | 48.48 | n/a | 3.65 | 4.64 | 24.33 | 25.87 |
| MoMark WGPU | 29.22 | 32.69 | n/a | 4.51 | 5.82 | 6.95 | 8.71 |
| GpMark.mbt (GPUI) | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Skia | 9.63 | 13.89 | 0 | 3.96 | 6.26 | 0.57 | 0.77 |
| Flutter Impeller | 9.66 | 13.89 | 0 | 4.06 | 6.29 | 1.34 | 1.74 |
| Electron | 7.07 | 7.00 | 0 | 3.57 | 4.80 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoUI Skia Raster CPU stress 369.5 ms（max 371.2 ms）；MoUI Skia GPU small 99.8 ms（max 103.4 ms）；MoUI Skia GPU medium 97.4 ms（max 101.2 ms）；MoUI Skia GPU large 130.1 ms（max 134.5 ms）；MoUI Skia GPU stress 424.5 ms（max 439.2 ms）；MoUI WGPU small 179.2 ms（max 186.5 ms）；MoUI WGPU medium 186.4 ms（max 203.5 ms）；MoUI WGPU large 204.9 ms（max 208.3 ms）；MoUI WGPU stress 497.3 ms（max 507.7 ms）；MoMark Skia Raster large 124.4 ms（max 129.6 ms）；MoMark Skia Raster stress 722.0 ms（max 727.5 ms）；MoMark Skia GPU small 254.9 ms（max 257.9 ms）；MoMark Skia GPU medium 268.7 ms（max 279.0 ms）；MoMark Skia GPU large 323.5 ms（max 327.3 ms）；MoMark Skia GPU stress 926.9 ms（max 939.4 ms）；MoMark WGPU small 209.9 ms（max 212.4 ms）；MoMark WGPU medium 214.6 ms（max 216.5 ms）；MoMark WGPU large 271.1 ms（max 272.8 ms）；MoMark WGPU stress 883.4 ms（max 888.8 ms）。
- P1 输入尾延迟：MoUI Skia GPU stress P95 25.69 ms；MoUI WGPU stress P95 23.88 ms；MoMark Skia Raster medium P95 16.84 ms；MoMark Skia Raster large P95 41.73 ms；MoMark Skia Raster stress P95 334.11 ms；MoMark Skia GPU small P95 45.58 ms；MoMark Skia GPU medium P95 43.46 ms；MoMark Skia GPU large P95 68.97 ms；MoMark Skia GPU stress P95 365.52 ms；MoMark WGPU small P95 36.21 ms；MoMark WGPU medium P95 35.26 ms；MoMark WGPU large P95 65.69 ms；MoMark WGPU stress P95 345.46 ms。
- 长帧（超预算）：MoUI Skia Raster CPU: stress/input 1 次，max 16.92 ms；MoUI Skia GPU: stress/input 30 次，max 27.60 ms；MoUI WGPU: stress/input 30 次，max 26.24 ms；MoMark Skia Raster: medium/input 2 次，max 19.20 ms, large/input 30 次，max 41.85 ms, large/scroll 1 次，max 18.13 ms, stress/input 30 次，max 337.13 ms, stress/scroll 360 次，max 35.05 ms；MoMark Skia GPU: small/input 30 次，max 47.35 ms, small/scroll 360 次，max 33.30 ms, medium/input 30 次，max 44.01 ms, medium/scroll 360 次，max 35.89 ms, large/input 30 次，max 74.85 ms, large/scroll 360 次，max 33.06 ms, stress/input 30 次，max 366.60 ms, stress/scroll 360 次，max 69.46 ms；MoMark WGPU: small/input 30 次，max 36.30 ms, small/scroll 1 次，max 17.84 ms, medium/input 30 次，max 36.55 ms, large/input 30 次，max 66.16 ms, large/scroll 8 次，max 18.53 ms, stress/input 30 次，max 348.42 ms, stress/scroll 360 次，max 42.28 ms；Electron: small/input 1 次，max 19.47 ms。
- 丢帧（优先处理）：Electron: small/input 1 帧。
- 解释：首帧异常优先检查窗口/渲染器初始化；输入尾延迟检查 action 到下一可见帧的调度与同步重建；长帧检查解析、布局、文本 shaping 和 GPU 提交；`n/a` 表示未埋点，不等于 0。
- 普通模式的长帧、帧间隔和输入延迟是各框架回调诊断，不能替代跨框架 compositor 排名；需要严格结论时运行 `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`。

## 采集口径

- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。
- `frame_work_ms` 统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏；对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `device_present_ms`：设备/上屏侧统一字段。MoUI raster 为 Skia CPU 光栅化+像素回读整体；MoUI GPU/wgpu 为提交后同步等待设备完成（headless host-surface 逐帧同步，真实应用的 vsync 流水线可重叠掉一部分，该值应视为上屏成本上界）；Flutter 为 `FrameTiming.rasterDuration`（光栅线程任务时间，含显示列表光栅化与 GPU 提交、不含设备完成等待）；GPUI 与 Electron 适配器侧无法观测，显示 `n/a`。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧；严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代；打开场景没有前一帧，所以不计算 interval/drop。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。
