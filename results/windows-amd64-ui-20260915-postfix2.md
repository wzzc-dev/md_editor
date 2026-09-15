# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-15T16:44:07Z`
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
| moui-skia-raster | small | open | ui-frame | 9.941/9.972 | - | - | - | n/a | n/a | n/a | 61.34 ms | 0 | measured |
| moui-skia-raster | small | input | ui-frame | 2.173/2.668 | - | 7.242/9.115 | 7.129/8.997 | n/a | n/a | n/a | 61.33 ms | 0 | measured |
| moui-skia-raster | small | scroll | ui-frame | 2.431/3.352 | - | 7.178/8.586 | - | n/a | n/a | n/a | 61.97 ms | 0 | measured |
| moui-skia-raster | medium | open | ui-frame | 9.924/10.722 | - | - | - | n/a | n/a | n/a | 63.57 ms | 0 | measured |
| moui-skia-raster | medium | input | ui-frame | 2.393/3.103 | - | 7.335/8.291 | 7.230/8.174 | n/a | n/a | n/a | 63.39 ms | 0 | measured |
| moui-skia-raster | medium | scroll | ui-frame | 2.432/3.438 | - | 7.227/8.739 | - | n/a | n/a | n/a | 64.90 ms | 0 | measured |
| moui-skia-raster | large | open | ui-frame | 10.813/10.933 | - | - | - | n/a | n/a | n/a | 103.10 ms | 0 | measured |
| moui-skia-raster | large | input | ui-frame | 2.344/3.235 | - | 7.346/8.745 | 7.212/8.554 | n/a | n/a | n/a | 100.26 ms | 0 | measured |
| moui-skia-raster | large | scroll | ui-frame | 2.426/3.387 | - | 7.049/8.537 | - | n/a | n/a | n/a | 101.23 ms | 0 | measured |
| moui-skia-raster | stress | open | ui-frame | 12.191/13.893 | - | - | - | n/a | n/a | n/a | 448.72 ms | 0 | measured |
| moui-skia-raster | stress | input | ui-frame | 2.310/3.312 | - | 7.329/8.533 | 7.213/8.360 | n/a | n/a | n/a | 427.43 ms | 0 | measured |
| moui-skia-raster | stress | scroll | ui-frame | 2.331/3.091 | - | 6.960/8.339 | - | n/a | n/a | n/a | 425.58 ms | 0 | measured |
| moui-skia-gpu | small | open | ui-frame | 10.362/11.351 | - | - | - | n/a | n/a | n/a | 371.52 ms | 0 | measured |
| moui-skia-gpu | small | input | ui-frame | 1.950/2.240 | - | 6.654/8.993 | 6.541/8.899 | n/a | n/a | n/a | 362.33 ms | 0 | measured |
| moui-skia-gpu | small | scroll | ui-frame | 2.160/2.681 | - | 6.927/7.244 | - | n/a | n/a | n/a | 365.40 ms | 0 | measured |
| moui-skia-gpu | medium | open | ui-frame | 9.659/10.126 | - | - | - | n/a | n/a | n/a | 363.65 ms | 0 | measured |
| moui-skia-gpu | medium | input | ui-frame | 1.951/2.240 | - | 6.377/7.327 | 6.276/7.224 | n/a | n/a | n/a | 360.19 ms | 0 | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 2.178/2.742 | - | 6.955/7.271 | - | n/a | n/a | n/a | 365.64 ms | 0 | measured |
| moui-skia-gpu | large | open | ui-frame | 9.683/9.891 | - | - | - | n/a | n/a | n/a | 432.69 ms | 0 | measured |
| moui-skia-gpu | large | input | ui-frame | 1.960/2.244 | - | 6.432/7.403 | 6.316/7.300 | n/a | n/a | n/a | 405.95 ms | 0 | measured |
| moui-skia-gpu | large | scroll | ui-frame | 2.184/2.733 | - | 6.968/7.241 | - | n/a | n/a | n/a | 398.47 ms | 0 | measured |
| moui-skia-gpu | stress | open | ui-frame | 10.041/10.362 | - | - | - | n/a | n/a | n/a | 722.80 ms | 0 | measured |
| moui-skia-gpu | stress | input | ui-frame | 1.976/2.368 | - | 6.353/7.164 | 6.237/7.051 | n/a | n/a | n/a | 717.36 ms | 0 | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 2.202/2.785 | - | 7.002/7.413 | - | n/a | n/a | n/a | 717.47 ms | 0 | measured |
| moui-wgpu | small | open | ui-frame | 43.067/46.028 | - | - | - | n/a | n/a | n/a | 1271.93 ms | 0 | measured |
| moui-wgpu | small | input | ui-frame | 5.038/6.655 | - | 11.165/13.264 | 11.062/13.164 | n/a | n/a | n/a | 1243.60 ms | 0 | measured |
| moui-wgpu | small | scroll | ui-frame | 2.508/3.220 | - | 7.240/8.747 | - | n/a | n/a | n/a | 1258.77 ms | 0 | measured |
| moui-wgpu | medium | open | ui-frame | 40.103/41.011 | - | - | - | n/a | n/a | n/a | 1247.63 ms | 0 | measured |
| moui-wgpu | medium | input | ui-frame | 5.047/6.580 | - | 11.136/15.010 | 11.025/15.009 | n/a | n/a | n/a | 1258.44 ms | 0 | measured |
| moui-wgpu | medium | scroll | ui-frame | 2.486/3.183 | - | 7.210/8.623 | - | n/a | n/a | n/a | 1257.16 ms | 0 | measured |
| moui-wgpu | large | open | ui-frame | 42.609/44.992 | - | - | - | n/a | n/a | n/a | 1332.63 ms | 0 | measured |
| moui-wgpu | large | input | ui-frame | 5.165/6.203 | - | 11.501/14.388 | 11.386/14.266 | n/a | n/a | n/a | 1304.06 ms | 0 | measured |
| moui-wgpu | large | scroll | ui-frame | 2.485/3.306 | - | 7.169/8.580 | - | n/a | n/a | n/a | 1283.28 ms | 0 | measured |
| moui-wgpu | stress | open | ui-frame | 40.315/41.500 | - | - | - | n/a | n/a | n/a | 1612.60 ms | 0 | measured |
| moui-wgpu | stress | input | ui-frame | 5.018/6.063 | - | 11.168/13.056 | 11.058/12.945 | n/a | n/a | n/a | 1611.52 ms | 0 | measured |
| moui-wgpu | stress | scroll | ui-frame | 2.514/3.277 | - | 7.259/8.580 | - | n/a | n/a | n/a | 1594.52 ms | 0 | measured |
| moui-md-skia-raster | small | open | ui-frame | 14.971/15.259 | - | - | - | n/a | n/a | n/a | 79.17 ms | 0 | measured |
| moui-md-skia-raster | small | input | ui-frame | 3.908/5.312 | - | 15.796/18.095 | 15.698/17.976 | n/a | n/a | n/a | 81.38 ms | 6 | measured |
| moui-md-skia-raster | small | scroll | ui-frame | 4.804/6.150 | - | 15.388/17.835 | - | n/a | n/a | n/a | 78.03 ms | 66 | measured |
| moui-md-skia-raster | medium | open | ui-frame | 14.586/15.322 | - | - | - | n/a | n/a | n/a | 80.06 ms | 0 | measured |
| moui-md-skia-raster | medium | input | ui-frame | 3.934/4.774 | - | 15.580/17.500 | 15.487/17.389 | n/a | n/a | n/a | 83.94 ms | 6 | measured |
| moui-md-skia-raster | medium | scroll | ui-frame | 4.847/6.283 | - | 15.665/18.785 | - | n/a | n/a | n/a | 81.67 ms | 83 | measured |
| moui-md-skia-raster | large | open | ui-frame | 15.719/17.041 | - | - | - | n/a | n/a | n/a | 119.85 ms | 0 | measured |
| moui-md-skia-raster | large | input | ui-frame | 4.512/6.495 | - | 17.955/21.357 | 17.853/21.207 | n/a | n/a | n/a | 126.95 ms | 24 | measured |
| moui-md-skia-raster | large | scroll | ui-frame | 4.764/6.130 | - | 15.193/17.479 | - | n/a | n/a | n/a | 118.10 ms | 58 | measured |
| moui-md-skia-raster | stress | open | ui-frame | 14.945/16.350 | - | - | - | n/a | n/a | n/a | 546.08 ms | 0 | measured |
| moui-md-skia-raster | stress | input | ui-frame | 8.310/10.418 | - | 38.743/40.918 | 38.646/40.821 | n/a | n/a | n/a | 555.65 ms | 60 | measured |
| moui-md-skia-raster | stress | scroll | ui-frame | 4.794/6.210 | - | 15.311/17.853 | - | n/a | n/a | n/a | 540.10 ms | 67 | measured |
| moui-md-skia-gpu | small | open | ui-frame | 15.324/17.177 | - | - | - | n/a | n/a | n/a | 375.91 ms | 0 | measured |
| moui-md-skia-gpu | small | input | ui-frame | 3.861/4.556 | - | 9.100/15.871 | 9.011/15.870 | n/a | n/a | n/a | 378.83 ms | 1 | measured |
| moui-md-skia-gpu | small | scroll | ui-frame | 4.667/5.964 | - | 7.293/9.153 | - | n/a | n/a | n/a | 373.12 ms | 0 | measured |
| moui-md-skia-gpu | medium | open | ui-frame | 15.548/15.668 | - | - | - | n/a | n/a | n/a | 375.92 ms | 0 | measured |
| moui-md-skia-gpu | medium | input | ui-frame | 4.131/5.829 | - | 9.332/15.394 | 9.242/15.393 | n/a | n/a | n/a | 377.77 ms | 1 | measured |
| moui-md-skia-gpu | medium | scroll | ui-frame | 4.674/6.042 | - | 7.283/8.976 | - | n/a | n/a | n/a | 381.22 ms | 0 | measured |
| moui-md-skia-gpu | large | open | ui-frame | 15.238/15.612 | - | - | - | n/a | n/a | n/a | 440.41 ms | 0 | measured |
| moui-md-skia-gpu | large | input | ui-frame | 4.521/5.643 | - | 11.513/18.737 | 11.423/18.736 | n/a | n/a | n/a | 417.79 ms | 3 | measured |
| moui-md-skia-gpu | large | scroll | ui-frame | 4.757/6.199 | - | 7.470/9.580 | - | n/a | n/a | n/a | 414.45 ms | 0 | measured |
| moui-md-skia-gpu | stress | open | ui-frame | 16.518/17.717 | - | - | - | n/a | n/a | n/a | 853.33 ms | 0 | measured |
| moui-md-skia-gpu | stress | input | ui-frame | 8.369/10.699 | - | 31.921/35.824 | 31.833/35.736 | n/a | n/a | n/a | 840.98 ms | 34 | measured |
| moui-md-skia-gpu | stress | scroll | ui-frame | 4.771/6.245 | - | 7.537/9.574 | - | n/a | n/a | n/a | 853.48 ms | 0 | measured |
| moui-md-wgpu | small | open | ui-frame | 54.997/55.590 | - | - | - | n/a | n/a | n/a | 1268.43 ms | 0 | measured |
| moui-md-wgpu | small | input | ui-frame | 7.186/8.157 | - | 17.860/19.208 | 17.774/19.208 | n/a | n/a | n/a | 1280.86 ms | 26 | measured |
| moui-md-wgpu | small | scroll | ui-frame | 5.862/7.755 | - | 16.339/20.529 | - | n/a | n/a | n/a | 1280.98 ms | 176 | measured |
| moui-md-wgpu | medium | open | ui-frame | 55.504/57.645 | - | - | - | n/a | n/a | n/a | 1297.50 ms | 0 | measured |
| moui-md-wgpu | medium | input | ui-frame | 7.029/8.043 | - | 17.776/19.266 | 17.681/19.147 | n/a | n/a | n/a | 1264.24 ms | 25 | measured |
| moui-md-wgpu | medium | scroll | ui-frame | 5.947/7.695 | - | 16.662/21.059 | - | n/a | n/a | n/a | 1280.98 ms | 190 | measured |
| moui-md-wgpu | large | open | ui-frame | 53.741/54.454 | - | - | - | n/a | n/a | n/a | 1324.78 ms | 0 | measured |
| moui-md-wgpu | large | input | ui-frame | 7.636/9.248 | - | 19.947/23.116 | 19.851/23.024 | n/a | n/a | n/a | 1325.18 ms | 30 | measured |
| moui-md-wgpu | large | scroll | ui-frame | 5.716/7.260 | - | 15.963/19.577 | - | n/a | n/a | n/a | 1313.53 ms | 164 | measured |
| moui-md-wgpu | stress | open | ui-frame | 55.563/57.425 | - | - | - | n/a | n/a | n/a | 1716.47 ms | 0 | measured |
| moui-md-wgpu | stress | input | ui-frame | 11.788/14.049 | - | 41.686/45.266 | 41.582/45.119 | n/a | n/a | n/a | 1750.36 ms | 60 | measured |
| moui-md-wgpu | stress | scroll | ui-frame | 5.961/7.846 | - | 16.695/20.792 | - | n/a | n/a | n/a | 1732.05 ms | 190 | measured |
| gpmark | small | open | ui-frame | 1.544/1.867 | - | - | - | n/a | n/a | n/a | 263.64 ms | n/a | measured |
| gpmark | small | input | ui-frame | 1.129/1.373 | 0.377/0.484 | 6.856/8.205 | 6.854/8.204 | n/a | n/a | n/a | 262.95 ms | n/a | measured |
| gpmark | small | scroll | ui-frame | 1.606/2.070 | 0.000/0.001 | 6.938/7.447 | - | n/a | n/a | n/a | 265.49 ms | n/a | measured |
| gpmark | medium | open | ui-frame | 1.287/1.478 | - | - | - | n/a | n/a | n/a | 270.65 ms | n/a | measured |
| gpmark | medium | input | ui-frame | 1.174/1.374 | 0.435/0.519 | 6.894/7.839 | 6.892/7.839 | n/a | n/a | n/a | 271.11 ms | n/a | measured |
| gpmark | medium | scroll | ui-frame | 1.573/2.073 | 0.000/0.001 | 6.939/7.446 | - | n/a | n/a | n/a | 271.57 ms | n/a | measured |
| gpmark | large | open | ui-frame | 1.385/1.550 | - | - | - | n/a | n/a | n/a | 315.47 ms | n/a | measured |
| gpmark | large | input | ui-frame | 1.197/1.422 | 0.797/0.929 | 6.863/7.742 | 6.861/7.742 | n/a | n/a | n/a | 308.11 ms | n/a | measured |
| gpmark | large | scroll | ui-frame | 1.597/2.076 | 0.000/0.001 | 6.928/7.372 | - | n/a | n/a | n/a | 309.72 ms | n/a | measured |
| gpmark | stress | open | ui-frame | 1.499/1.585 | - | - | - | n/a | n/a | n/a | 699.11 ms | n/a | measured |
| gpmark | stress | input | ui-frame | 1.231/1.681 | 5.126/7.249 | 6.513/9.069 | 6.512/9.064 | n/a | n/a | n/a | 706.52 ms | n/a | measured |
| gpmark | stress | scroll | ui-frame | 1.596/2.101 | 0.000/0.001 | 6.936/7.403 | - | n/a | n/a | n/a | 721.58 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 0.471/0.520 | - | - | - | 43.75 ms | n/a | n/a | 176.33 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 0.842/0.961 | - | 6.945/6.945 | 7.012/7.797 | 0.53 ms | n/a | n/a | 174.67 ms | 0 | measured |
| flutter-skia | small | scroll | ui-frame | 2.522/3.058 | - | 7.017/6.945 | - | 0.50 ms | n/a | n/a | 178.67 ms | 0 | measured |
| flutter-skia | medium | open | ui-frame | 0.449/0.494 | - | - | - | 45.15 ms | n/a | n/a | 180.33 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 0.896/1.176 | - | 6.944/6.945 | 6.990/7.984 | 0.53 ms | n/a | n/a | 177.33 ms | 0 | measured |
| flutter-skia | medium | scroll | ui-frame | 3.778/5.924 | - | 9.761/13.889 | - | 0.58 ms | n/a | n/a | 181.67 ms | 1 | measured |
| flutter-skia | large | open | ui-frame | 1.623/1.832 | - | - | - | 39.95 ms | n/a | n/a | 184.33 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 0.941/1.098 | - | 6.944/6.945 | 6.937/7.842 | 0.55 ms | n/a | n/a | 190.00 ms | 0 | measured |
| flutter-skia | large | scroll | ui-frame | 3.742/5.725 | - | 9.684/13.889 | - | 0.55 ms | n/a | n/a | 185.33 ms | 0 | measured |
| flutter-skia | stress | open | ui-frame | 0.522/0.658 | - | - | - | 44.21 ms | n/a | n/a | 243.00 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 0.863/0.989 | - | 6.870/6.945 | 6.899/7.784 | 0.52 ms | n/a | n/a | 239.00 ms | 0 | measured |
| flutter-skia | stress | scroll | ui-frame | 3.670/6.023 | - | 9.645/13.889 | - | 0.54 ms | n/a | n/a | 239.67 ms | 0 | measured |
| flutter-impeller | small | open | ui-frame | 0.496/0.510 | - | - | - | 19.65 ms | n/a | n/a | 1340.00 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 0.897/1.044 | - | 6.944/6.945 | 6.986/8.518 | 1.36 ms | n/a | n/a | 1344.67 ms | 0 | measured |
| flutter-impeller | small | scroll | ui-frame | 2.584/3.107 | - | 6.983/6.945 | - | 1.11 ms | n/a | n/a | 1365.00 ms | 0 | measured |
| flutter-impeller | medium | open | ui-frame | 0.401/0.418 | - | - | - | 22.49 ms | n/a | n/a | 1332.67 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 0.947/1.324 | - | 6.944/6.945 | 7.005/8.045 | 1.30 ms | n/a | n/a | 1345.00 ms | 0 | measured |
| flutter-impeller | medium | scroll | ui-frame | 4.009/6.011 | - | 9.722/13.889 | - | 1.29 ms | n/a | n/a | 1337.67 ms | 0 | measured |
| flutter-impeller | large | open | ui-frame | 1.559/1.797 | - | - | - | 23.44 ms | n/a | n/a | 1355.33 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 0.955/1.386 | - | 6.945/6.945 | 7.001/7.741 | 1.32 ms | n/a | n/a | 1346.00 ms | 0 | measured |
| flutter-impeller | large | scroll | ui-frame | 3.900/5.986 | - | 9.934/13.889 | - | 1.31 ms | n/a | n/a | 1369.00 ms | 1 | measured |
| flutter-impeller | stress | open | ui-frame | 0.537/0.679 | - | - | - | 20.24 ms | n/a | n/a | 1450.00 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 0.964/1.326 | - | 6.944/6.945 | 6.905/7.782 | 1.30 ms | n/a | n/a | 1402.00 ms | 0 | measured |
| flutter-impeller | stress | scroll | ui-frame | 4.116/6.409 | - | 10.040/13.889 | - | 1.30 ms | n/a | n/a | 1406.67 ms | 0 | measured |
| electron | small | open | ui-frame | 1285.667/1304.000 | - | - | - | n/a | n/a | n/a | 1285.67 ms | 0 | measured |
| electron | small | input | ui-frame | 3.070/4.800 | - | 7.967/13.900 | 6.853/13.300 | n/a | n/a | n/a | 1278.00 ms | 0 | measured |
| electron | small | scroll | ui-frame | 3.325/4.500 | - | 7.338/7.100 | - | n/a | n/a | n/a | 1279.67 ms | 4 | measured |
| electron | medium | open | ui-frame | 1283.000/1285.000 | - | - | - | n/a | n/a | n/a | 1283.00 ms | 0 | measured |
| electron | medium | input | ui-frame | 3.137/4.800 | - | 7.727/13.800 | 6.987/13.200 | n/a | n/a | n/a | 1274.00 ms | 0 | measured |
| electron | medium | scroll | ui-frame | 3.509/4.700 | - | 7.323/7.100 | - | n/a | n/a | n/a | 1280.67 ms | 3 | measured |
| electron | large | open | ui-frame | 1277.000/1283.000 | - | - | - | n/a | n/a | n/a | 1277.00 ms | 0 | measured |
| electron | large | input | ui-frame | 3.390/4.400 | - | 8.016/13.940 | 7.070/14.000 | n/a | n/a | n/a | 1285.67 ms | 0 | measured |
| electron | large | scroll | ui-frame | 3.534/4.800 | - | 7.296/7.100 | - | n/a | n/a | n/a | 1277.33 ms | 3 | measured |
| electron | stress | open | ui-frame | 1316.667/1323.000 | - | - | - | n/a | n/a | n/a | 1316.67 ms | 0 | measured |
| electron | stress | input | ui-frame | 3.080/4.700 | - | 8.427/13.900 | 7.110/14.800 | n/a | n/a | n/a | 1311.00 ms | 0 | measured |
| electron | stress | scroll | ui-frame | 3.512/4.600 | - | 7.400/8.438 | - | n/a | n/a | n/a | 1303.67 ms | 6 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 7.18/7.23/7.05 | 8.59/8.74/8.54 | 0/0/0 | 2.43/2.43/2.43 | 3.35/3.44/3.39 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 6.93/6.95/6.97 | 7.24/7.27/7.24 | 0/0/0 | 2.16/2.18/2.18 | 2.68/2.74/2.73 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 7.24/7.21/7.17 | 8.75/8.62/8.58 | 0/0/0 | 2.51/2.49/2.49 | 3.22/3.18/3.31 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 15.39/15.67/15.19 | 17.84/18.78/17.48 | 66/83/58 | 4.80/4.85/4.76 | 6.15/6.28/6.13 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 7.29/7.28/7.47 | 9.15/8.98/9.58 | 0/0/0 | 4.67/4.67/4.76 | 5.96/6.04/6.20 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 16.34/16.66/15.96 | 20.53/21.06/19.58 | 176/190/164 | 5.86/5.95/5.72 | 7.75/7.69/7.26 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 6.94/6.94/6.93 | 7.45/7.45/7.37 | n/a/n/a/n/a | 1.61/1.57/1.60 | 2.07/2.07/2.08 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.02/9.76/9.68 | 6.95/13.89/13.89 | 0/1/0 | 2.52/3.78/3.74 | 3.06/5.92/5.72 | 0.50/0.58/0.55 | 0.71/0.78/0.73 |
| Flutter Impeller | 6.98/9.72/9.93 | 6.95/13.89/13.89 | 0/0/1 | 2.58/4.01/3.90 | 3.11/6.01/5.99 | 1.11/1.29/1.31 | 1.33/1.68/1.72 |
| Electron | 7.34/7.32/7.30 | 7.10/7.10/7.10 | 4/3/3 | 3.32/3.51/3.53 | 4.50/4.70/4.80 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.96 | 8.34 | 0 | 2.33 | 3.09 | n/a | n/a |
| MoUI Skia GPU | 7.00 | 7.41 | 0 | 2.20 | 2.78 | n/a | n/a |
| MoUI WGPU | 7.26 | 8.58 | 0 | 2.51 | 3.28 | n/a | n/a |
| MoMark Skia Raster | 15.31 | 17.85 | 67 | 4.79 | 6.21 | n/a | n/a |
| MoMark Skia GPU | 7.54 | 9.57 | 0 | 4.77 | 6.24 | n/a | n/a |
| MoMark WGPU | 16.70 | 20.79 | 190 | 5.96 | 7.85 | n/a | n/a |
| GpMark.mbt (GPUI) | 6.94 | 7.40 | n/a | 1.60 | 2.10 | n/a | n/a |
| Flutter Skia | 9.65 | 13.89 | 0 | 3.67 | 6.02 | 0.54 | 0.71 |
| Flutter Impeller | 10.04 | 13.89 | 0 | 4.12 | 6.41 | 1.30 | 1.73 |
| Electron | 7.40 | 8.44 | 6 | 3.51 | 4.60 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 7.13/7.23/7.21 | 9.00/8.17/8.55 | 2.17/2.39/2.34 | 2.67/3.10/3.23 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 6.54/6.28/6.32 | 8.90/7.22/7.30 | 1.95/1.95/1.96 | 2.24/2.24/2.24 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 11.06/11.02/11.39 | 13.16/15.01/14.27 | 5.04/5.05/5.16 | 6.66/6.58/6.20 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 15.70/15.49/17.85 | 17.98/17.39/21.21 | 3.91/3.93/4.51 | 5.31/4.77/6.49 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 9.01/9.24/11.42 | 15.87/15.39/18.74 | 3.86/4.13/4.52 | 4.56/5.83/5.64 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 17.77/17.68/19.85 | 19.21/19.15/23.02 | 7.19/7.03/7.64 | 8.16/8.04/9.25 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 6.85/6.89/6.86 | 8.20/7.84/7.74 | 1.13/1.17/1.20 | 1.37/1.37/1.42 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.01/6.99/6.94 | 7.80/7.98/7.84 | 0.84/0.90/0.94 | 0.96/1.18/1.10 | 0.53/0.53/0.55 | 0.59/0.62/0.62 |
| Flutter Impeller | 6.99/7.00/7.00 | 8.52/8.04/7.74 | 0.90/0.95/0.96 | 1.04/1.32/1.39 | 1.36/1.30/1.32 | 1.75/1.74/1.71 |
| Electron | 6.85/6.99/7.07 | 13.30/13.20/14.00 | 3.07/3.14/3.39 | 4.80/4.80/4.40 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 7.21 | 8.36 | 2.31 | 3.31 | n/a | n/a |
| MoUI Skia GPU | 6.24 | 7.05 | 1.98 | 2.37 | n/a | n/a |
| MoUI WGPU | 11.06 | 12.95 | 5.02 | 6.06 | n/a | n/a |
| MoMark Skia Raster | 38.65 | 40.82 | 8.31 | 10.42 | n/a | n/a |
| MoMark Skia GPU | 31.83 | 35.74 | 8.37 | 10.70 | n/a | n/a |
| MoMark WGPU | 41.58 | 45.12 | 11.79 | 14.05 | n/a | n/a |
| GpMark.mbt (GPUI) | 6.51 | 9.06 | 1.23 | 1.68 | n/a | n/a |
| Flutter Skia | 6.90 | 7.78 | 0.86 | 0.99 | 0.52 | 0.61 |
| Flutter Impeller | 6.91 | 7.78 | 0.96 | 1.33 | 1.30 | 1.66 |
| Electron | 7.11 | 14.80 | 3.08 | 4.70 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 61.34/63.57/103.10 | 62.40/66.96/103.53 | 0.19/0.72/4.53 | 0.21/0.86/5.28 | 9.94/9.92/10.81 | 9.97/10.72/10.93 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 371.52/363.65/432.69 | 378.21/368.24/485.94 | 0.19/0.70/3.87 | 0.21/0.86/4.06 | 10.36/9.66/9.68 | 11.35/10.13/9.89 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 1271.93/1247.63/1332.63 | 1274.72/1257.31/1367.77 | 0.18/0.68/3.76 | 0.20/0.82/4.11 | 43.07/40.10/42.61 | 46.03/41.01/44.99 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 79.17/80.06/119.85 | 81.74/80.49/122.47 | 0.17/0.66/3.73 | 0.19/0.83/3.94 | 14.97/14.59/15.72 | 15.26/15.32/17.04 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 375.91/375.92/440.41 | 383.15/384.22/493.99 | 0.14/0.61/4.50 | 0.15/0.64/5.38 | 15.32/15.55/15.24 | 17.18/15.67/15.61 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 1268.43/1297.50/1324.78 | 1284.49/1311.83/1334.94 | 0.16/0.58/4.20 | 0.19/0.59/4.95 | 55.00/55.50/53.74 | 55.59/57.64/54.45 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 263.64/270.65/315.47 | 265.75/275.54/321.74 | 0.33/1.00/5.33 | 1.00/2.00/6.00 | 1.54/1.29/1.39 | 1.87/1.48/1.55 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 176.33/180.33/184.33 | 177.00/186.00/187.00 | 0.85/0.96/1.00 | 1.03/1.04/1.02 | 0.47/0.45/1.62 | 0.52/0.49/1.83 | 43.75/45.15/39.95 | 44.19/46.22/40.95 |
| Flutter Impeller | 1340.00/1332.67/1355.33 | 1352.00/1340.00/1363.00 | 0.81/0.85/1.12 | 0.92/0.96/1.23 | 0.50/0.40/1.56 | 0.51/0.42/1.80 | 19.65/22.49/23.44 | 20.21/23.39/24.01 |
| Electron | 1285.67/1283.00/1277.00 | 1304.00/1285.00/1283.00 | 2.96/4.02/5.04 | 3.09/4.57/5.84 | 1285.67/1283.00/1277.00 | 1304.00/1285.00/1283.00 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 448.72 | 486.70 | 40.23 | 43.99 | 12.19 | 13.89 | n/a | n/a |
| MoUI Skia GPU | 722.80 | 733.37 | 39.30 | 41.47 | 10.04 | 10.36 | n/a | n/a |
| MoUI WGPU | 1612.60 | 1624.90 | 37.23 | 37.53 | 40.31 | 41.50 | n/a | n/a |
| MoMark Skia Raster | 546.08 | 563.89 | 39.15 | 40.27 | 14.95 | 16.35 | n/a | n/a |
| MoMark Skia GPU | 853.33 | 876.07 | 38.41 | 39.16 | 16.52 | 17.72 | n/a | n/a |
| MoMark WGPU | 1716.47 | 1746.30 | 38.75 | 40.76 | 55.56 | 57.43 | n/a | n/a |
| GpMark.mbt (GPUI) | 699.11 | 703.01 | 40.33 | 41.00 | 1.50 | 1.58 | n/a | n/a |
| Flutter Skia | 243.00 | 250.00 | 3.13 | 3.22 | 0.52 | 0.66 | 44.21 | 45.26 |
| Flutter Impeller | 1450.00 | 1523.00 | 3.43 | 3.54 | 0.54 | 0.68 | 20.24 | 21.98 |
| Electron | 1316.67 | 1323.00 | 9.81 | 10.36 | 1316.67 | 1323.00 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 7.18/7.23/7.05 | 8.59/8.74/8.54 | 0/0/0 | 2.43/2.43/2.43 | 3.35/3.44/3.39 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 6.93/6.95/6.97 | 7.24/7.27/7.24 | 0/0/0 | 2.16/2.18/2.18 | 2.68/2.74/2.73 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 7.24/7.21/7.17 | 8.75/8.62/8.58 | 0/0/0 | 2.51/2.49/2.49 | 3.22/3.18/3.31 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 15.39/15.67/15.19 | 17.84/18.78/17.48 | 66/83/58 | 4.80/4.85/4.76 | 6.15/6.28/6.13 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 7.29/7.28/7.47 | 9.15/8.98/9.58 | 0/0/0 | 4.67/4.67/4.76 | 5.96/6.04/6.20 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 16.34/16.66/15.96 | 20.53/21.06/19.58 | 176/190/164 | 5.86/5.95/5.72 | 7.75/7.69/7.26 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 6.94/6.94/6.93 | 7.45/7.45/7.37 | n/a/n/a/n/a | 1.61/1.57/1.60 | 2.07/2.07/2.08 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.02/9.76/9.68 | 6.95/13.89/13.89 | 0/1/0 | 2.52/3.78/3.74 | 3.06/5.92/5.72 | 0.50/0.58/0.55 | 0.71/0.78/0.73 |
| Flutter Impeller | 6.98/9.72/9.93 | 6.95/13.89/13.89 | 0/0/1 | 2.58/4.01/3.90 | 3.11/6.01/5.99 | 1.11/1.29/1.31 | 1.33/1.68/1.72 |
| Electron | 7.34/7.32/7.30 | 7.10/7.10/7.10 | 4/3/3 | 3.32/3.51/3.53 | 4.50/4.70/4.80 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.96 | 8.34 | 0 | 2.33 | 3.09 | n/a | n/a |
| MoUI Skia GPU | 7.00 | 7.41 | 0 | 2.20 | 2.78 | n/a | n/a |
| MoUI WGPU | 7.26 | 8.58 | 0 | 2.51 | 3.28 | n/a | n/a |
| MoMark Skia Raster | 15.31 | 17.85 | 67 | 4.79 | 6.21 | n/a | n/a |
| MoMark Skia GPU | 7.54 | 9.57 | 0 | 4.77 | 6.24 | n/a | n/a |
| MoMark WGPU | 16.70 | 20.79 | 190 | 5.96 | 7.85 | n/a | n/a |
| GpMark.mbt (GPUI) | 6.94 | 7.40 | n/a | 1.60 | 2.10 | n/a | n/a |
| Flutter Skia | 9.65 | 13.89 | 0 | 3.67 | 6.02 | 0.54 | 0.71 |
| Flutter Impeller | 10.04 | 13.89 | 0 | 4.12 | 6.41 | 1.30 | 1.73 |
| Electron | 7.40 | 8.44 | 6 | 3.51 | 4.60 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoUI Skia Raster CPU large 103.1 ms（max 103.5 ms）；MoUI Skia Raster CPU stress 448.7 ms（max 486.7 ms）；MoUI Skia GPU small 371.5 ms（max 378.2 ms）；MoUI Skia GPU medium 363.6 ms（max 368.2 ms）；MoUI Skia GPU large 432.7 ms（max 485.9 ms）；MoUI Skia GPU stress 722.8 ms（max 733.4 ms）；MoUI WGPU small 1271.9 ms（max 1274.7 ms）；MoUI WGPU medium 1247.6 ms（max 1257.3 ms）；MoUI WGPU large 1332.6 ms（max 1367.8 ms）；MoUI WGPU stress 1612.6 ms（max 1624.9 ms）；MoMark Skia Raster large 119.8 ms（max 122.5 ms）；MoMark Skia Raster stress 546.1 ms（max 563.9 ms）；MoMark Skia GPU small 375.9 ms（max 383.2 ms）；MoMark Skia GPU medium 375.9 ms（max 384.2 ms）；MoMark Skia GPU large 440.4 ms（max 494.0 ms）；MoMark Skia GPU stress 853.3 ms（max 876.1 ms）；MoMark WGPU small 1268.4 ms（max 1284.5 ms）；MoMark WGPU medium 1297.5 ms（max 1311.8 ms）；MoMark WGPU large 1324.8 ms（max 1334.9 ms）；MoMark WGPU stress 1716.5 ms（max 1746.3 ms）；GpMark.mbt (GPUI) small 263.6 ms（max 265.7 ms）；GpMark.mbt (GPUI) medium 270.7 ms（max 275.5 ms）；GpMark.mbt (GPUI) large 315.5 ms（max 321.7 ms）；GpMark.mbt (GPUI) stress 699.1 ms（max 703.0 ms）；Flutter Skia small 176.3 ms（max 177.0 ms）；Flutter Skia medium 180.3 ms（max 186.0 ms）；Flutter Skia large 184.3 ms（max 187.0 ms）；Flutter Skia stress 243.0 ms（max 250.0 ms）；Flutter Impeller small 1340.0 ms（max 1352.0 ms）；Flutter Impeller medium 1332.7 ms（max 1340.0 ms）；Flutter Impeller large 1355.3 ms（max 1363.0 ms）；Flutter Impeller stress 1450.0 ms（max 1523.0 ms）；Electron small 1285.7 ms（max 1304.0 ms）；Electron medium 1283.0 ms（max 1285.0 ms）；Electron large 1277.0 ms（max 1283.0 ms）；Electron stress 1316.7 ms（max 1323.0 ms）。
- P1 输入尾延迟：MoMark Skia Raster small P95 17.98 ms；MoMark Skia Raster medium P95 17.39 ms；MoMark Skia Raster large P95 21.21 ms；MoMark Skia Raster stress P95 40.82 ms；MoMark Skia GPU large P95 18.74 ms；MoMark Skia GPU stress P95 35.74 ms；MoMark WGPU small P95 19.21 ms；MoMark WGPU medium P95 19.15 ms；MoMark WGPU large P95 23.02 ms；MoMark WGPU stress P95 45.12 ms。
- 长帧（超预算）：MoMark Skia Raster: small/input 6 次，max 20.07 ms, small/scroll 65 次，max 20.81 ms, medium/input 5 次，max 18.04 ms, medium/scroll 73 次，max 22.22 ms, large/input 24 次，max 21.94 ms, large/scroll 49 次，max 19.90 ms, stress/input 30 次，max 41.83 ms, stress/scroll 58 次，max 21.07 ms；MoMark Skia GPU: small/input 1 次，max 18.35 ms, medium/input 1 次，max 18.42 ms, large/input 3 次，max 22.26 ms, stress/input 30 次，max 44.10 ms；MoMark WGPU: small/input 25 次，max 20.02 ms, small/scroll 172 次，max 26.16 ms, medium/input 24 次，max 20.91 ms, medium/scroll 186 次，max 24.67 ms, large/input 30 次，max 23.40 ms, large/scroll 157 次，max 34.70 ms, stress/input 30 次，max 46.22 ms, stress/scroll 188 次，max 28.02 ms；Flutter Skia: medium/scroll 1 次，max 27.78 ms；Flutter Impeller: large/scroll 1 次，max 17.27 ms；Electron: small/scroll 4 次，max 20.90 ms, medium/scroll 3 次，max 20.90 ms, large/scroll 3 次，max 20.90 ms, stress/scroll 6 次，max 20.90 ms。
- 丢帧（优先处理）：MoMark Skia Raster: small/input 6 帧, small/scroll 66 帧, medium/input 6 帧, medium/scroll 83 帧, large/input 24 帧, large/scroll 58 帧, stress/input 60 帧, stress/scroll 67 帧；MoMark Skia GPU: small/input 1 帧, medium/input 1 帧, large/input 3 帧, stress/input 34 帧；MoMark WGPU: small/input 26 帧, small/scroll 176 帧, medium/input 25 帧, medium/scroll 190 帧, large/input 30 帧, large/scroll 164 帧, stress/input 60 帧, stress/scroll 190 帧；Flutter Skia: medium/scroll 1 帧；Flutter Impeller: large/scroll 1 帧；Electron: small/scroll 4 帧, medium/scroll 3 帧, large/scroll 3 帧, stress/scroll 6 帧。
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
