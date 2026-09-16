# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-16T12:34:50Z`
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
| moui-skia-raster | small | open | ui-frame | 11.022/12.119 | - | - | - | n/a | n/a | n/a | 61.88 ms | 0 | measured |
| moui-skia-raster | small | input | ui-frame | 1.868/2.344 | - | 6.399/7.501 | 6.293/7.397 | n/a | n/a | n/a | 61.72 ms | 0 | measured |
| moui-skia-raster | small | scroll | ui-frame | 2.058/2.714 | - | 6.213/7.331 | - | n/a | n/a | n/a | 60.43 ms | 0 | measured |
| moui-skia-raster | medium | open | ui-frame | 10.344/11.540 | - | - | - | n/a | n/a | n/a | 63.64 ms | 0 | measured |
| moui-skia-raster | medium | input | ui-frame | 1.933/2.447 | - | 6.359/7.650 | 6.255/7.551 | n/a | n/a | n/a | 63.93 ms | 0 | measured |
| moui-skia-raster | medium | scroll | ui-frame | 2.057/2.714 | - | 6.204/7.421 | - | n/a | n/a | n/a | 63.78 ms | 0 | measured |
| moui-skia-raster | large | open | ui-frame | 9.930/10.845 | - | - | - | n/a | n/a | n/a | 95.44 ms | 0 | measured |
| moui-skia-raster | large | input | ui-frame | 1.868/2.278 | - | 6.207/7.302 | 6.104/7.201 | n/a | n/a | n/a | 96.93 ms | 0 | measured |
| moui-skia-raster | large | scroll | ui-frame | 2.042/2.660 | - | 6.226/7.442 | - | n/a | n/a | n/a | 100.65 ms | 0 | measured |
| moui-skia-raster | stress | open | ui-frame | 10.968/12.056 | - | - | - | n/a | n/a | n/a | 419.90 ms | 0 | measured |
| moui-skia-raster | stress | input | ui-frame | 1.930/2.232 | - | 6.409/7.635 | 6.312/7.541 | n/a | n/a | n/a | 422.50 ms | 0 | measured |
| moui-skia-raster | stress | scroll | ui-frame | 2.075/2.806 | - | 6.303/7.700 | - | n/a | n/a | n/a | 411.14 ms | 0 | measured |
| moui-skia-gpu | small | open | ui-frame | 9.277/10.074 | - | - | - | n/a | n/a | n/a | 328.00 ms | 0 | measured |
| moui-skia-gpu | small | input | ui-frame | 1.781/2.172 | - | 6.505/7.411 | 6.402/7.323 | n/a | n/a | n/a | 323.24 ms | 0 | measured |
| moui-skia-gpu | small | scroll | ui-frame | 2.013/2.648 | - | 7.009/7.276 | - | n/a | n/a | n/a | 329.14 ms | 0 | measured |
| moui-skia-gpu | medium | open | ui-frame | 9.104/9.469 | - | - | - | n/a | n/a | n/a | 330.15 ms | 0 | measured |
| moui-skia-gpu | medium | input | ui-frame | 1.789/2.047 | - | 6.227/7.171 | 6.127/7.054 | n/a | n/a | n/a | 327.65 ms | 0 | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 2.005/2.567 | - | 6.972/7.191 | - | n/a | n/a | n/a | 326.75 ms | 0 | measured |
| moui-skia-gpu | large | open | ui-frame | 8.839/9.338 | - | - | - | n/a | n/a | n/a | 364.07 ms | 0 | measured |
| moui-skia-gpu | large | input | ui-frame | 1.822/2.046 | - | 6.641/9.136 | 6.540/9.040 | n/a | n/a | n/a | 359.37 ms | 0 | measured |
| moui-skia-gpu | large | scroll | ui-frame | 2.089/2.709 | - | 6.962/7.312 | - | n/a | n/a | n/a | 362.58 ms | 0 | measured |
| moui-skia-gpu | stress | open | ui-frame | 9.205/9.557 | - | - | - | n/a | n/a | n/a | 683.18 ms | 0 | measured |
| moui-skia-gpu | stress | input | ui-frame | 1.798/2.082 | - | 6.464/7.288 | 6.365/7.174 | n/a | n/a | n/a | 687.00 ms | 0 | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 1.989/2.582 | - | 6.969/7.198 | - | n/a | n/a | n/a | 685.26 ms | 0 | measured |
| moui-wgpu | small | open | ui-frame | 46.657/47.389 | - | - | - | n/a | n/a | n/a | 1153.77 ms | 0 | measured |
| moui-wgpu | small | input | ui-frame | 5.309/6.694 | - | 11.187/13.773 | 11.089/13.677 | n/a | n/a | n/a | 1157.91 ms | 0 | measured |
| moui-wgpu | small | scroll | ui-frame | 2.289/2.891 | - | 6.948/7.932 | - | n/a | n/a | n/a | 1161.17 ms | 0 | measured |
| moui-wgpu | medium | open | ui-frame | 46.378/47.686 | - | - | - | n/a | n/a | n/a | 1151.62 ms | 0 | measured |
| moui-wgpu | medium | input | ui-frame | 5.449/6.170 | - | 11.131/13.211 | 11.035/13.110 | n/a | n/a | n/a | 1147.45 ms | 1 | measured |
| moui-wgpu | medium | scroll | ui-frame | 2.313/2.961 | - | 6.941/8.125 | - | n/a | n/a | n/a | 1173.95 ms | 0 | measured |
| moui-wgpu | large | open | ui-frame | 48.787/54.827 | - | - | - | n/a | n/a | n/a | 1176.52 ms | 0 | measured |
| moui-wgpu | large | input | ui-frame | 5.269/6.130 | - | 10.916/12.352 | 10.822/12.256 | n/a | n/a | n/a | 1193.27 ms | 0 | measured |
| moui-wgpu | large | scroll | ui-frame | 2.402/3.344 | - | 7.108/8.663 | - | n/a | n/a | n/a | 1193.61 ms | 0 | measured |
| moui-wgpu | stress | open | ui-frame | 47.136/48.759 | - | - | - | n/a | n/a | n/a | 1488.45 ms | 0 | measured |
| moui-wgpu | stress | input | ui-frame | 5.204/6.141 | - | 10.825/12.798 | 10.723/12.693 | n/a | n/a | n/a | 1493.14 ms | 0 | measured |
| moui-wgpu | stress | scroll | ui-frame | 2.283/2.865 | - | 6.924/7.901 | - | n/a | n/a | n/a | 1497.73 ms | 0 | measured |
| moui-md-skia-raster | small | open | ui-frame | 11.478/11.854 | - | - | - | n/a | n/a | n/a | 60.26 ms | 0 | measured |
| moui-md-skia-raster | small | input | ui-frame | 3.320/4.119 | - | 14.117/15.256 | 14.030/15.164 | n/a | n/a | n/a | 60.34 ms | 1 | measured |
| moui-md-skia-raster | small | scroll | ui-frame | 4.559/5.837 | - | 14.594/16.506 | - | n/a | n/a | n/a | 60.63 ms | 15 | measured |
| moui-md-skia-raster | medium | open | ui-frame | 11.987/12.379 | - | - | - | n/a | n/a | n/a | 66.73 ms | 0 | measured |
| moui-md-skia-raster | medium | input | ui-frame | 3.314/3.824 | - | 14.379/17.382 | 14.293/17.284 | n/a | n/a | n/a | 64.76 ms | 2 | measured |
| moui-md-skia-raster | medium | scroll | ui-frame | 4.521/5.942 | - | 14.560/16.565 | - | n/a | n/a | n/a | 66.20 ms | 16 | measured |
| moui-md-skia-raster | large | open | ui-frame | 11.588/11.930 | - | - | - | n/a | n/a | n/a | 105.43 ms | 0 | measured |
| moui-md-skia-raster | large | input | ui-frame | 3.840/4.709 | - | 15.962/17.542 | 15.874/17.440 | n/a | n/a | n/a | 103.57 ms | 4 | measured |
| moui-md-skia-raster | large | scroll | ui-frame | 4.571/5.924 | - | 14.778/17.075 | - | n/a | n/a | n/a | 102.77 ms | 29 | measured |
| moui-md-skia-raster | stress | open | ui-frame | 11.407/11.854 | - | - | - | n/a | n/a | n/a | 506.41 ms | 0 | measured |
| moui-md-skia-raster | stress | input | ui-frame | 7.767/8.765 | - | 30.963/33.794 | 30.879/33.697 | n/a | n/a | n/a | 500.04 ms | 33 | measured |
| moui-md-skia-raster | stress | scroll | ui-frame | 4.575/6.145 | - | 14.785/16.909 | - | n/a | n/a | n/a | 495.39 ms | 28 | measured |
| moui-md-skia-gpu | small | open | ui-frame | 11.612/12.124 | - | - | - | n/a | n/a | n/a | 335.84 ms | 0 | measured |
| moui-md-skia-gpu | small | input | ui-frame | 3.356/4.073 | - | 8.129/14.497 | 8.043/14.495 | n/a | n/a | n/a | 329.90 ms | 0 | measured |
| moui-md-skia-gpu | small | scroll | ui-frame | 4.654/6.186 | - | 7.336/9.312 | - | n/a | n/a | n/a | 333.75 ms | 0 | measured |
| moui-md-skia-gpu | medium | open | ui-frame | 11.690/11.931 | - | - | - | n/a | n/a | n/a | 341.95 ms | 0 | measured |
| moui-md-skia-gpu | medium | input | ui-frame | 3.362/3.748 | - | 8.099/14.735 | 8.021/14.734 | n/a | n/a | n/a | 338.66 ms | 0 | measured |
| moui-md-skia-gpu | medium | scroll | ui-frame | 4.480/5.781 | - | 7.060/8.547 | - | n/a | n/a | n/a | 339.76 ms | 0 | measured |
| moui-md-skia-gpu | large | open | ui-frame | 11.235/11.615 | - | - | - | n/a | n/a | n/a | 375.82 ms | 0 | measured |
| moui-md-skia-gpu | large | input | ui-frame | 3.954/5.091 | - | 9.616/16.857 | 9.538/16.856 | n/a | n/a | n/a | 372.15 ms | 2 | measured |
| moui-md-skia-gpu | large | scroll | ui-frame | 4.454/5.837 | - | 7.080/8.732 | - | n/a | n/a | n/a | 373.05 ms | 0 | measured |
| moui-md-skia-gpu | stress | open | ui-frame | 11.332/11.623 | - | - | - | n/a | n/a | n/a | 780.64 ms | 0 | measured |
| moui-md-skia-gpu | stress | input | ui-frame | 7.861/9.083 | - | 24.943/28.596 | 24.856/28.514 | n/a | n/a | n/a | 775.62 ms | 30 | measured |
| moui-md-skia-gpu | stress | scroll | ui-frame | 4.497/5.815 | - | 7.140/8.799 | - | n/a | n/a | n/a | 775.67 ms | 0 | measured |
| moui-md-wgpu | small | open | ui-frame | 63.454/64.403 | - | - | - | n/a | n/a | n/a | 1181.92 ms | 0 | measured |
| moui-md-wgpu | small | input | ui-frame | 7.447/8.674 | - | 17.947/20.734 | 17.860/20.589 | n/a | n/a | n/a | 1164.34 ms | 23 | measured |
| moui-md-wgpu | small | scroll | ui-frame | 5.387/6.957 | - | 14.815/18.118 | - | n/a | n/a | n/a | 1172.61 ms | 82 | measured |
| moui-md-wgpu | medium | open | ui-frame | 61.484/62.220 | - | - | - | n/a | n/a | n/a | 1184.89 ms | 0 | measured |
| moui-md-wgpu | medium | input | ui-frame | 7.347/8.454 | - | 17.690/18.607 | 17.602/18.607 | n/a | n/a | n/a | 1177.01 ms | 25 | measured |
| moui-md-wgpu | medium | scroll | ui-frame | 5.450/6.900 | - | 15.026/18.275 | - | n/a | n/a | n/a | 1192.95 ms | 102 | measured |
| moui-md-wgpu | large | open | ui-frame | 62.003/63.499 | - | - | - | n/a | n/a | n/a | 1234.64 ms | 0 | measured |
| moui-md-wgpu | large | input | ui-frame | 7.730/9.254 | - | 19.266/21.518 | 19.180/21.433 | n/a | n/a | n/a | 1224.67 ms | 29 | measured |
| moui-md-wgpu | large | scroll | ui-frame | 5.499/7.029 | - | 15.219/18.537 | - | n/a | n/a | n/a | 1212.49 ms | 124 | measured |
| moui-md-wgpu | stress | open | ui-frame | 62.014/62.537 | - | - | - | n/a | n/a | n/a | 1628.80 ms | 0 | measured |
| moui-md-wgpu | stress | input | ui-frame | 11.529/14.717 | - | 35.431/38.091 | 35.343/38.003 | n/a | n/a | n/a | 1605.44 ms | 56 | measured |
| moui-md-wgpu | stress | scroll | ui-frame | 5.628/7.202 | - | 15.534/18.546 | - | n/a | n/a | n/a | 1619.65 ms | 144 | measured |
| gpmark | small | open | ui-frame | 1.342/1.427 | - | - | - | n/a | n/a | n/a | 244.37 ms | n/a | measured |
| gpmark | small | input | ui-frame | 1.049/1.227 | 0.365/0.561 | 6.814/7.446 | 6.812/7.445 | n/a | n/a | n/a | 246.38 ms | n/a | measured |
| gpmark | small | scroll | ui-frame | 1.405/1.901 | 0.000/0.001 | 6.930/7.459 | - | n/a | n/a | n/a | 245.12 ms | n/a | measured |
| gpmark | medium | open | ui-frame | 1.269/1.386 | - | - | - | n/a | n/a | n/a | 253.97 ms | n/a | measured |
| gpmark | medium | input | ui-frame | 1.024/1.250 | 0.385/0.522 | 6.805/7.757 | 6.803/7.757 | n/a | n/a | n/a | 247.76 ms | n/a | measured |
| gpmark | medium | scroll | ui-frame | 1.415/1.913 | 0.000/0.001 | 6.940/7.467 | - | n/a | n/a | n/a | 254.66 ms | n/a | measured |
| gpmark | large | open | ui-frame | 1.172/1.210 | - | - | - | n/a | n/a | n/a | 288.91 ms | n/a | measured |
| gpmark | large | input | ui-frame | 1.115/1.378 | 0.768/0.968 | 6.761/7.553 | 6.759/7.553 | n/a | n/a | n/a | 285.30 ms | n/a | measured |
| gpmark | large | scroll | ui-frame | 1.415/1.896 | 0.000/0.001 | 6.930/7.472 | - | n/a | n/a | n/a | 289.85 ms | n/a | measured |
| gpmark | stress | open | ui-frame | 1.538/1.682 | - | - | - | n/a | n/a | n/a | 676.01 ms | n/a | measured |
| gpmark | stress | input | ui-frame | 1.186/1.607 | 4.306/5.337 | 6.587/8.029 | 6.585/8.023 | n/a | n/a | n/a | 668.92 ms | n/a | measured |
| gpmark | stress | scroll | ui-frame | 1.415/1.910 | 0.000/0.001 | 6.933/7.510 | - | n/a | n/a | n/a | 682.84 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 0.419/0.455 | - | - | - | 43.54 ms | n/a | n/a | 166.00 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 0.806/1.060 | - | 6.945/6.945 | 6.957/7.853 | 0.48 ms | n/a | n/a | 165.00 ms | 0 | measured |
| flutter-skia | small | scroll | ui-frame | 2.315/2.849 | - | 7.022/6.945 | - | 0.47 ms | n/a | n/a | 166.67 ms | 0 | measured |
| flutter-skia | medium | open | ui-frame | 0.428/0.466 | - | - | - | 42.12 ms | n/a | n/a | 162.00 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 0.779/0.941 | - | 6.944/6.945 | 6.971/7.703 | 0.47 ms | n/a | n/a | 165.00 ms | 0 | measured |
| flutter-skia | medium | scroll | ui-frame | 3.624/5.271 | - | 8.700/13.889 | - | 0.53 ms | n/a | n/a | 166.67 ms | 0 | measured |
| flutter-skia | large | open | ui-frame | 1.450/1.673 | - | - | - | 41.06 ms | n/a | n/a | 175.67 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 0.760/0.919 | - | 6.944/6.945 | 6.964/7.780 | 0.46 ms | n/a | n/a | 169.67 ms | 0 | measured |
| flutter-skia | large | scroll | ui-frame | 3.584/5.485 | - | 9.037/13.889 | - | 0.52 ms | n/a | n/a | 177.67 ms | 0 | measured |
| flutter-skia | stress | open | ui-frame | 0.454/0.493 | - | - | - | 40.73 ms | n/a | n/a | 226.33 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 0.808/0.979 | - | 6.944/6.945 | 6.966/7.962 | 0.49 ms | n/a | n/a | 230.67 ms | 0 | measured |
| flutter-skia | stress | scroll | ui-frame | 3.848/5.862 | - | 9.510/13.889 | - | 0.59 ms | n/a | n/a | 236.67 ms | 3 | measured |
| flutter-impeller | small | open | ui-frame | 0.482/0.552 | - | - | - | 22.36 ms | n/a | n/a | 1368.67 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 0.938/1.351 | - | 6.944/6.945 | 7.021/7.744 | 1.30 ms | n/a | n/a | 1340.00 ms | 0 | measured |
| flutter-impeller | small | scroll | ui-frame | 2.908/4.514 | - | 7.695/13.889 | - | 1.30 ms | n/a | n/a | 1364.00 ms | 0 | measured |
| flutter-impeller | medium | open | ui-frame | 0.396/0.405 | - | - | - | 23.74 ms | n/a | n/a | 1328.00 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 0.804/1.201 | - | 6.944/6.945 | 6.995/8.288 | 1.22 ms | n/a | n/a | 1309.00 ms | 0 | measured |
| flutter-impeller | medium | scroll | ui-frame | 3.708/5.521 | - | 8.997/13.889 | - | 1.25 ms | n/a | n/a | 1318.33 ms | 0 | measured |
| flutter-impeller | large | open | ui-frame | 1.566/1.713 | - | - | - | 19.67 ms | n/a | n/a | 1331.33 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 0.838/0.987 | - | 6.945/6.945 | 7.034/8.226 | 1.21 ms | n/a | n/a | 1318.33 ms | 0 | measured |
| flutter-impeller | large | scroll | ui-frame | 3.647/5.414 | - | 8.996/13.889 | - | 1.25 ms | n/a | n/a | 1303.67 ms | 0 | measured |
| flutter-impeller | stress | open | ui-frame | 0.476/0.535 | - | - | - | 20.25 ms | n/a | n/a | 1353.33 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 0.787/0.968 | - | 6.945/6.945 | 6.964/8.089 | 1.17 ms | n/a | n/a | 1345.67 ms | 0 | measured |
| flutter-impeller | stress | scroll | ui-frame | 3.583/5.280 | - | 8.858/13.889 | - | 1.23 ms | n/a | n/a | 1356.67 ms | 0 | measured |
| electron | small | open | ui-frame | 1252.333/1261.000 | - | - | - | n/a | n/a | n/a | 1252.33 ms | 0 | measured |
| electron | small | input | ui-frame | 2.957/4.600 | - | 7.501/13.800 | 6.787/13.700 | n/a | n/a | n/a | 1244.00 ms | 0 | measured |
| electron | small | scroll | ui-frame | 3.186/4.500 | - | 7.026/7.000 | - | n/a | n/a | n/a | 1255.67 ms | 0 | measured |
| electron | medium | open | ui-frame | 1247.667/1261.000 | - | - | - | n/a | n/a | n/a | 1247.67 ms | 0 | measured |
| electron | medium | input | ui-frame | 2.943/4.200 | - | 7.264/13.800 | 6.800/13.300 | n/a | n/a | n/a | 1251.33 ms | 0 | measured |
| electron | medium | scroll | ui-frame | 3.504/4.800 | - | 7.072/7.000 | - | n/a | n/a | n/a | 1256.00 ms | 0 | measured |
| electron | large | open | ui-frame | 1251.333/1255.000 | - | - | - | n/a | n/a | n/a | 1251.33 ms | 0 | measured |
| electron | large | input | ui-frame | 3.040/4.500 | - | 7.737/13.900 | 6.737/11.900 | n/a | n/a | n/a | 1252.67 ms | 0 | measured |
| electron | large | scroll | ui-frame | 3.366/4.600 | - | 7.014/7.000 | - | n/a | n/a | n/a | 1257.00 ms | 0 | measured |
| electron | stress | open | ui-frame | 1282.333/1285.000 | - | - | - | n/a | n/a | n/a | 1282.33 ms | 0 | measured |
| electron | stress | input | ui-frame | 2.860/4.500 | - | 8.201/13.900 | 7.167/15.500 | n/a | n/a | n/a | 1285.67 ms | 0 | measured |
| electron | stress | scroll | ui-frame | 3.386/4.700 | - | 7.017/7.000 | - | n/a | n/a | n/a | 1281.67 ms | 1 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.21/6.20/6.23 | 7.33/7.42/7.44 | 0/0/0 | 2.06/2.06/2.04 | 2.71/2.71/2.66 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 7.01/6.97/6.96 | 7.28/7.19/7.31 | 0/0/0 | 2.01/2.00/2.09 | 2.65/2.57/2.71 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 6.95/6.94/7.11 | 7.93/8.13/8.66 | 0/0/0 | 2.29/2.31/2.40 | 2.89/2.96/3.34 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 14.59/14.56/14.78 | 16.51/16.57/17.07 | 15/16/29 | 4.56/4.52/4.57 | 5.84/5.94/5.92 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 7.34/7.06/7.08 | 9.31/8.55/8.73 | 0/0/0 | 4.65/4.48/4.45 | 6.19/5.78/5.84 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 14.81/15.03/15.22 | 18.12/18.28/18.54 | 82/102/124 | 5.39/5.45/5.50 | 6.96/6.90/7.03 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 6.93/6.94/6.93 | 7.46/7.47/7.47 | n/a/n/a/n/a | 1.40/1.41/1.42 | 1.90/1.91/1.90 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.02/8.70/9.04 | 6.95/13.89/13.89 | 0/0/0 | 2.32/3.62/3.58 | 2.85/5.27/5.49 | 0.47/0.53/0.52 | 0.58/0.68/0.69 |
| Flutter Impeller | 7.69/9.00/9.00 | 13.89/13.89/13.89 | 0/0/0 | 2.91/3.71/3.65 | 4.51/5.52/5.41 | 1.30/1.25/1.25 | 2.03/1.60/1.63 |
| Electron | 7.03/7.07/7.01 | 7.00/7.00/7.00 | 0/0/0 | 3.19/3.50/3.37 | 4.50/4.80/4.60 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.30 | 7.70 | 0 | 2.07 | 2.81 | n/a | n/a |
| MoUI Skia GPU | 6.97 | 7.20 | 0 | 1.99 | 2.58 | n/a | n/a |
| MoUI WGPU | 6.92 | 7.90 | 0 | 2.28 | 2.86 | n/a | n/a |
| MoMark Skia Raster | 14.78 | 16.91 | 28 | 4.58 | 6.14 | n/a | n/a |
| MoMark Skia GPU | 7.14 | 8.80 | 0 | 4.50 | 5.81 | n/a | n/a |
| MoMark WGPU | 15.53 | 18.55 | 144 | 5.63 | 7.20 | n/a | n/a |
| GpMark.mbt (GPUI) | 6.93 | 7.51 | n/a | 1.41 | 1.91 | n/a | n/a |
| Flutter Skia | 9.51 | 13.89 | 3 | 3.85 | 5.86 | 0.59 | 0.81 |
| Flutter Impeller | 8.86 | 13.89 | 0 | 3.58 | 5.28 | 1.23 | 1.57 |
| Electron | 7.02 | 7.00 | 1 | 3.39 | 4.70 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.29/6.26/6.10 | 7.40/7.55/7.20 | 1.87/1.93/1.87 | 2.34/2.45/2.28 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 6.40/6.13/6.54 | 7.32/7.05/9.04 | 1.78/1.79/1.82 | 2.17/2.05/2.05 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 11.09/11.03/10.82 | 13.68/13.11/12.26 | 5.31/5.45/5.27 | 6.69/6.17/6.13 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 14.03/14.29/15.87 | 15.16/17.28/17.44 | 3.32/3.31/3.84 | 4.12/3.82/4.71 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 8.04/8.02/9.54 | 14.50/14.73/16.86 | 3.36/3.36/3.95 | 4.07/3.75/5.09 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 17.86/17.60/19.18 | 20.59/18.61/21.43 | 7.45/7.35/7.73 | 8.67/8.45/9.25 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 6.81/6.80/6.76 | 7.45/7.76/7.55 | 1.05/1.02/1.12 | 1.23/1.25/1.38 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 6.96/6.97/6.96 | 7.85/7.70/7.78 | 0.81/0.78/0.76 | 1.06/0.94/0.92 | 0.48/0.47/0.46 | 0.64/0.58/0.55 |
| Flutter Impeller | 7.02/6.99/7.03 | 7.74/8.29/8.23 | 0.94/0.80/0.84 | 1.35/1.20/0.99 | 1.30/1.22/1.21 | 1.82/1.52/1.53 |
| Electron | 6.79/6.80/6.74 | 13.70/13.30/11.90 | 2.96/2.94/3.04 | 4.60/4.20/4.50 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.31 | 7.54 | 1.93 | 2.23 | n/a | n/a |
| MoUI Skia GPU | 6.37 | 7.17 | 1.80 | 2.08 | n/a | n/a |
| MoUI WGPU | 10.72 | 12.69 | 5.20 | 6.14 | n/a | n/a |
| MoMark Skia Raster | 30.88 | 33.70 | 7.77 | 8.76 | n/a | n/a |
| MoMark Skia GPU | 24.86 | 28.51 | 7.86 | 9.08 | n/a | n/a |
| MoMark WGPU | 35.34 | 38.00 | 11.53 | 14.72 | n/a | n/a |
| GpMark.mbt (GPUI) | 6.59 | 8.02 | 1.19 | 1.61 | n/a | n/a |
| Flutter Skia | 6.97 | 7.96 | 0.81 | 0.98 | 0.49 | 0.57 |
| Flutter Impeller | 6.96 | 8.09 | 0.79 | 0.97 | 1.17 | 1.76 |
| Electron | 7.17 | 15.50 | 2.86 | 4.50 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 61.88/63.64/95.44 | 62.90/67.03/96.34 | 0.15/0.59/3.50 | 0.15/0.62/3.53 | 11.02/10.34/9.93 | 12.12/11.54/10.84 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 328.00/330.15/364.07 | 332.73/333.41/375.69 | 0.20/0.72/3.56 | 0.23/0.93/3.62 | 9.28/9.10/8.84 | 10.07/9.47/9.34 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 1153.77/1151.62/1176.52 | 1172.20/1164.53/1177.82 | 0.19/0.64/3.67 | 0.22/0.76/3.94 | 46.66/46.38/48.79 | 47.39/47.69/54.83 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 60.26/66.73/105.43 | 61.51/69.39/107.72 | 0.13/0.57/3.97 | 0.13/0.60/4.43 | 11.48/11.99/11.59 | 11.85/12.38/11.93 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 335.84/341.95/375.82 | 338.93/343.99/379.21 | 0.12/0.57/3.62 | 0.13/0.57/3.67 | 11.61/11.69/11.23 | 12.12/11.93/11.62 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 1181.92/1184.89/1234.64 | 1190.60/1192.83/1245.33 | 0.14/0.57/3.67 | 0.17/0.58/3.81 | 63.45/61.48/62.00 | 64.40/62.22/63.50 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 244.37/253.97/288.91 | 247.96/256.96/291.91 | 0.33/0.00/4.00 | 1.00/0.00/5.00 | 1.34/1.27/1.17 | 1.43/1.39/1.21 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 166.00/162.00/175.67 | 172.00/162.00/190.00 | 0.75/0.88/1.03 | 0.88/1.09/1.05 | 0.42/0.43/1.45 | 0.46/0.47/1.67 | 43.54/42.12/41.06 | 45.08/43.02/43.18 |
| Flutter Impeller | 1368.67/1328.00/1331.33 | 1372.00/1343.00/1359.00 | 0.79/0.81/1.07 | 0.90/0.86/1.16 | 0.48/0.40/1.57 | 0.55/0.41/1.71 | 22.36/23.74/19.67 | 23.76/24.71/21.08 |
| Electron | 1252.33/1247.67/1251.33 | 1261.00/1261.00/1255.00 | 2.96/3.35/3.48 | 3.18/3.85/3.95 | 1252.33/1247.67/1251.33 | 1261.00/1261.00/1255.00 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 419.90 | 425.71 | 38.86 | 40.70 | 10.97 | 12.06 | n/a | n/a |
| MoUI Skia GPU | 683.18 | 687.01 | 37.43 | 39.33 | 9.20 | 9.56 | n/a | n/a |
| MoUI WGPU | 1488.45 | 1497.64 | 36.76 | 38.11 | 47.14 | 48.76 | n/a | n/a |
| MoMark Skia Raster | 506.41 | 520.68 | 37.67 | 38.88 | 11.41 | 11.85 | n/a | n/a |
| MoMark Skia GPU | 780.64 | 786.15 | 38.20 | 38.51 | 11.33 | 11.62 | n/a | n/a |
| MoMark WGPU | 1628.80 | 1630.50 | 36.73 | 37.35 | 62.01 | 62.54 | n/a | n/a |
| GpMark.mbt (GPUI) | 676.01 | 677.47 | 41.00 | 42.00 | 1.54 | 1.68 | n/a | n/a |
| Flutter Skia | 226.33 | 235.00 | 3.19 | 3.29 | 0.45 | 0.49 | 40.73 | 44.05 |
| Flutter Impeller | 1353.33 | 1373.00 | 3.39 | 3.63 | 0.48 | 0.54 | 20.25 | 20.64 |
| Electron | 1282.33 | 1285.00 | 8.75 | 9.01 | 1282.33 | 1285.00 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.21/6.20/6.23 | 7.33/7.42/7.44 | 0/0/0 | 2.06/2.06/2.04 | 2.71/2.71/2.66 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 7.01/6.97/6.96 | 7.28/7.19/7.31 | 0/0/0 | 2.01/2.00/2.09 | 2.65/2.57/2.71 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 6.95/6.94/7.11 | 7.93/8.13/8.66 | 0/0/0 | 2.29/2.31/2.40 | 2.89/2.96/3.34 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 14.59/14.56/14.78 | 16.51/16.57/17.07 | 15/16/29 | 4.56/4.52/4.57 | 5.84/5.94/5.92 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 7.34/7.06/7.08 | 9.31/8.55/8.73 | 0/0/0 | 4.65/4.48/4.45 | 6.19/5.78/5.84 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 14.81/15.03/15.22 | 18.12/18.28/18.54 | 82/102/124 | 5.39/5.45/5.50 | 6.96/6.90/7.03 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 6.93/6.94/6.93 | 7.46/7.47/7.47 | n/a/n/a/n/a | 1.40/1.41/1.42 | 1.90/1.91/1.90 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.02/8.70/9.04 | 6.95/13.89/13.89 | 0/0/0 | 2.32/3.62/3.58 | 2.85/5.27/5.49 | 0.47/0.53/0.52 | 0.58/0.68/0.69 |
| Flutter Impeller | 7.69/9.00/9.00 | 13.89/13.89/13.89 | 0/0/0 | 2.91/3.71/3.65 | 4.51/5.52/5.41 | 1.30/1.25/1.25 | 2.03/1.60/1.63 |
| Electron | 7.03/7.07/7.01 | 7.00/7.00/7.00 | 0/0/0 | 3.19/3.50/3.37 | 4.50/4.80/4.60 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.30 | 7.70 | 0 | 2.07 | 2.81 | n/a | n/a |
| MoUI Skia GPU | 6.97 | 7.20 | 0 | 1.99 | 2.58 | n/a | n/a |
| MoUI WGPU | 6.92 | 7.90 | 0 | 2.28 | 2.86 | n/a | n/a |
| MoMark Skia Raster | 14.78 | 16.91 | 28 | 4.58 | 6.14 | n/a | n/a |
| MoMark Skia GPU | 7.14 | 8.80 | 0 | 4.50 | 5.81 | n/a | n/a |
| MoMark WGPU | 15.53 | 18.55 | 144 | 5.63 | 7.20 | n/a | n/a |
| GpMark.mbt (GPUI) | 6.93 | 7.51 | n/a | 1.41 | 1.91 | n/a | n/a |
| Flutter Skia | 9.51 | 13.89 | 3 | 3.85 | 5.86 | 0.59 | 0.81 |
| Flutter Impeller | 8.86 | 13.89 | 0 | 3.58 | 5.28 | 1.23 | 1.57 |
| Electron | 7.02 | 7.00 | 1 | 3.39 | 4.70 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoUI Skia Raster CPU stress 419.9 ms（max 425.7 ms）；MoUI Skia GPU small 328.0 ms（max 332.7 ms）；MoUI Skia GPU medium 330.2 ms（max 333.4 ms）；MoUI Skia GPU large 364.1 ms（max 375.7 ms）；MoUI Skia GPU stress 683.2 ms（max 687.0 ms）；MoUI WGPU small 1153.8 ms（max 1172.2 ms）；MoUI WGPU medium 1151.6 ms（max 1164.5 ms）；MoUI WGPU large 1176.5 ms（max 1177.8 ms）；MoUI WGPU stress 1488.5 ms（max 1497.6 ms）；MoMark Skia Raster large 105.4 ms（max 107.7 ms）；MoMark Skia Raster stress 506.4 ms（max 520.7 ms）；MoMark Skia GPU small 335.8 ms（max 338.9 ms）；MoMark Skia GPU medium 342.0 ms（max 344.0 ms）；MoMark Skia GPU large 375.8 ms（max 379.2 ms）；MoMark Skia GPU stress 780.6 ms（max 786.1 ms）；MoMark WGPU small 1181.9 ms（max 1190.6 ms）；MoMark WGPU medium 1184.9 ms（max 1192.8 ms）；MoMark WGPU large 1234.6 ms（max 1245.3 ms）；MoMark WGPU stress 1628.8 ms（max 1630.5 ms）；GpMark.mbt (GPUI) small 244.4 ms（max 248.0 ms）；GpMark.mbt (GPUI) medium 254.0 ms（max 257.0 ms）；GpMark.mbt (GPUI) large 288.9 ms（max 291.9 ms）；GpMark.mbt (GPUI) stress 676.0 ms（max 677.5 ms）；Flutter Skia small 166.0 ms（max 172.0 ms）；Flutter Skia medium 162.0 ms（max 162.0 ms）；Flutter Skia large 175.7 ms（max 190.0 ms）；Flutter Skia stress 226.3 ms（max 235.0 ms）；Flutter Impeller small 1368.7 ms（max 1372.0 ms）；Flutter Impeller medium 1328.0 ms（max 1343.0 ms）；Flutter Impeller large 1331.3 ms（max 1359.0 ms）；Flutter Impeller stress 1353.3 ms（max 1373.0 ms）；Electron small 1252.3 ms（max 1261.0 ms）；Electron medium 1247.7 ms（max 1261.0 ms）；Electron large 1251.3 ms（max 1255.0 ms）；Electron stress 1282.3 ms（max 1285.0 ms）。
- P1 输入尾延迟：MoMark Skia Raster medium P95 17.28 ms；MoMark Skia Raster large P95 17.44 ms；MoMark Skia Raster stress P95 33.70 ms；MoMark Skia GPU large P95 16.86 ms；MoMark Skia GPU stress P95 28.51 ms；MoMark WGPU small P95 20.59 ms；MoMark WGPU medium P95 18.61 ms；MoMark WGPU large P95 21.43 ms；MoMark WGPU stress P95 38.00 ms。
- 长帧（超预算）：MoUI WGPU: medium/input 1 次，max 21.34 ms；MoMark Skia Raster: small/input 1 次，max 17.52 ms, small/scroll 14 次，max 21.23 ms, medium/input 2 次，max 19.42 ms, medium/scroll 14 次，max 21.85 ms, large/input 4 次，max 18.53 ms, large/scroll 27 次，max 28.00 ms, stress/input 30 次，max 44.99 ms, stress/scroll 24 次，max 22.06 ms；MoMark Skia GPU: large/input 2 次，max 17.58 ms, stress/input 30 次，max 29.24 ms；MoMark WGPU: small/input 23 次，max 21.60 ms, small/scroll 74 次，max 25.87 ms, medium/input 24 次，max 19.61 ms, medium/scroll 98 次，max 21.75 ms, large/input 29 次，max 22.42 ms, large/scroll 119 次，max 29.70 ms, stress/input 30 次，max 38.45 ms, stress/scroll 135 次，max 29.34 ms；Flutter Skia: stress/scroll 2 次，max 34.72 ms；Electron: stress/scroll 1 次，max 20.90 ms。
- 丢帧（优先处理）：MoUI WGPU: medium/input 1 帧；MoMark Skia Raster: small/input 1 帧, small/scroll 15 帧, medium/input 2 帧, medium/scroll 16 帧, large/input 4 帧, large/scroll 29 帧, stress/input 33 帧, stress/scroll 28 帧；MoMark Skia GPU: large/input 2 帧, stress/input 30 帧；MoMark WGPU: small/input 23 帧, small/scroll 82 帧, medium/input 25 帧, medium/scroll 102 帧, large/input 29 帧, large/scroll 124 帧, stress/input 56 帧, stress/scroll 144 帧；Flutter Skia: stress/scroll 3 帧；Electron: stress/scroll 1 帧。
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
