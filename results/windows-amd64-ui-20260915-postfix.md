# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-15T15:08:14Z`
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
| moui-skia-raster | small | open | ui-frame | 11.658/12.269 | - | - | - | n/a | n/a | n/a | 73.97 ms | 0 | measured |
| moui-skia-raster | small | input | ui-frame | 2.062/2.813 | - | 7.048/8.401 | 6.932/8.291 | n/a | n/a | n/a | 74.18 ms | 0 | measured |
| moui-skia-raster | small | scroll | ui-frame | 2.239/3.084 | - | 6.791/8.376 | - | n/a | n/a | n/a | 72.04 ms | 0 | measured |
| moui-skia-raster | medium | open | ui-frame | 11.260/11.621 | - | - | - | n/a | n/a | n/a | 76.03 ms | 0 | measured |
| moui-skia-raster | medium | input | ui-frame | 1.963/2.487 | - | 6.803/8.117 | 6.693/8.012 | n/a | n/a | n/a | 75.25 ms | 0 | measured |
| moui-skia-raster | medium | scroll | ui-frame | 2.183/2.917 | - | 6.607/7.917 | - | n/a | n/a | n/a | 80.55 ms | 0 | measured |
| moui-skia-raster | large | open | ui-frame | 12.192/12.446 | - | - | - | n/a | n/a | n/a | 111.89 ms | 0 | measured |
| moui-skia-raster | large | input | ui-frame | 2.081/2.568 | - | 8.088/9.489 | 7.975/9.293 | n/a | n/a | n/a | 111.34 ms | 0 | measured |
| moui-skia-raster | large | scroll | ui-frame | 2.244/3.155 | - | 6.683/8.324 | - | n/a | n/a | n/a | 109.81 ms | 0 | measured |
| moui-skia-raster | stress | open | ui-frame | 11.954/12.553 | - | - | - | n/a | n/a | n/a | 461.09 ms | 0 | measured |
| moui-skia-raster | stress | input | ui-frame | 2.203/2.775 | - | 18.285/20.078 | 18.175/19.977 | n/a | n/a | n/a | 445.94 ms | 29 | measured |
| moui-skia-raster | stress | scroll | ui-frame | 2.284/3.036 | - | 6.929/8.395 | - | n/a | n/a | n/a | 439.45 ms | 0 | measured |
| moui-skia-gpu | small | open | ui-frame | 9.569/9.968 | - | - | - | n/a | n/a | n/a | 373.36 ms | 0 | measured |
| moui-skia-gpu | small | input | ui-frame | 2.024/2.255 | - | 6.640/9.353 | 6.524/9.235 | n/a | n/a | n/a | 376.61 ms | 0 | measured |
| moui-skia-gpu | small | scroll | ui-frame | 2.270/2.810 | - | 6.905/7.313 | - | n/a | n/a | n/a | 364.81 ms | 0 | measured |
| moui-skia-gpu | medium | open | ui-frame | 9.501/9.659 | - | - | - | n/a | n/a | n/a | 376.30 ms | 0 | measured |
| moui-skia-gpu | medium | input | ui-frame | 2.064/3.120 | - | 6.061/7.500 | 5.952/7.373 | n/a | n/a | n/a | 371.59 ms | 0 | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 2.288/2.871 | - | 6.926/7.314 | - | n/a | n/a | n/a | 378.66 ms | 0 | measured |
| moui-skia-gpu | large | open | ui-frame | 10.942/11.870 | - | - | - | n/a | n/a | n/a | 411.56 ms | 0 | measured |
| moui-skia-gpu | large | input | ui-frame | 2.005/2.361 | - | 6.153/6.959 | 6.048/6.841 | n/a | n/a | n/a | 392.35 ms | 0 | measured |
| moui-skia-gpu | large | scroll | ui-frame | 2.275/2.774 | - | 6.906/7.380 | - | n/a | n/a | n/a | 404.12 ms | 0 | measured |
| moui-skia-gpu | stress | open | ui-frame | 9.952/10.323 | - | - | - | n/a | n/a | n/a | 721.20 ms | 0 | measured |
| moui-skia-gpu | stress | input | ui-frame | 2.155/2.632 | - | 16.123/18.691 | 16.017/18.595 | n/a | n/a | n/a | 732.13 ms | 9 | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 2.277/2.955 | - | 6.978/7.670 | - | n/a | n/a | n/a | 712.80 ms | 2 | measured |
| moui-wgpu | small | open | ui-frame | 43.222/49.466 | - | - | - | n/a | n/a | n/a | 1279.16 ms | 0 | measured |
| moui-wgpu | small | input | ui-frame | 4.950/6.053 | - | 11.008/12.883 | 10.905/12.882 | n/a | n/a | n/a | 1249.49 ms | 0 | measured |
| moui-wgpu | small | scroll | ui-frame | 2.528/3.238 | - | 7.216/8.764 | - | n/a | n/a | n/a | 1247.53 ms | 0 | measured |
| moui-wgpu | medium | open | ui-frame | 41.907/43.226 | - | - | - | n/a | n/a | n/a | 1262.69 ms | 0 | measured |
| moui-wgpu | medium | input | ui-frame | 5.375/6.174 | - | 11.683/14.000 | 11.563/13.853 | n/a | n/a | n/a | 1271.55 ms | 0 | measured |
| moui-wgpu | medium | scroll | ui-frame | 2.601/3.487 | - | 7.448/8.950 | - | n/a | n/a | n/a | 1289.45 ms | 0 | measured |
| moui-wgpu | large | open | ui-frame | 41.592/43.095 | - | - | - | n/a | n/a | n/a | 1288.38 ms | 0 | measured |
| moui-wgpu | large | input | ui-frame | 5.230/6.592 | - | 12.551/16.266 | 12.424/16.053 | n/a | n/a | n/a | 1355.54 ms | 0 | measured |
| moui-wgpu | large | scroll | ui-frame | 2.543/3.222 | - | 7.362/8.959 | - | n/a | n/a | n/a | 1309.34 ms | 0 | measured |
| moui-wgpu | stress | open | ui-frame | 41.827/44.951 | - | - | - | n/a | n/a | n/a | 1619.77 ms | 0 | measured |
| moui-wgpu | stress | input | ui-frame | 5.090/5.934 | - | 21.181/24.187 | 21.063/24.081 | n/a | n/a | n/a | 1644.97 ms | 30 | measured |
| moui-wgpu | stress | scroll | ui-frame | 2.557/3.240 | - | 7.286/8.808 | - | n/a | n/a | n/a | 1607.84 ms | 0 | measured |
| moui-md-skia-raster | small | open | ui-frame | 14.739/15.481 | - | - | - | n/a | n/a | n/a | 80.96 ms | 0 | measured |
| moui-md-skia-raster | small | input | ui-frame | 3.984/4.683 | - | 15.897/17.266 | 15.799/17.173 | n/a | n/a | n/a | 76.02 ms | 7 | measured |
| moui-md-skia-raster | small | scroll | ui-frame | 4.939/6.405 | - | 15.637/18.245 | - | n/a | n/a | n/a | 76.85 ms | 93 | measured |
| moui-md-skia-raster | medium | open | ui-frame | 15.698/15.920 | - | - | - | n/a | n/a | n/a | 81.51 ms | 0 | measured |
| moui-md-skia-raster | medium | input | ui-frame | 3.950/5.145 | - | 16.302/18.408 | 16.207/18.290 | n/a | n/a | n/a | 86.76 ms | 8 | measured |
| moui-md-skia-raster | medium | scroll | ui-frame | 4.917/6.501 | - | 15.687/18.362 | - | n/a | n/a | n/a | 81.36 ms | 87 | measured |
| moui-md-skia-raster | large | open | ui-frame | 15.291/16.274 | - | - | - | n/a | n/a | n/a | 120.36 ms | 0 | measured |
| moui-md-skia-raster | large | input | ui-frame | 4.630/5.543 | - | 18.083/19.753 | 17.982/19.602 | n/a | n/a | n/a | 117.43 ms | 27 | measured |
| moui-md-skia-raster | large | scroll | ui-frame | 4.914/6.449 | - | 15.535/18.029 | - | n/a | n/a | n/a | 122.31 ms | 82 | measured |
| moui-md-skia-raster | stress | open | ui-frame | 15.308/16.031 | - | - | - | n/a | n/a | n/a | 537.02 ms | 0 | measured |
| moui-md-skia-raster | stress | input | ui-frame | 8.242/9.790 | - | 38.918/41.130 | 38.823/41.035 | n/a | n/a | n/a | 553.35 ms | 60 | measured |
| moui-md-skia-raster | stress | scroll | ui-frame | 4.899/6.334 | - | 15.630/18.001 | - | n/a | n/a | n/a | 550.34 ms | 91 | measured |
| moui-md-skia-gpu | small | open | ui-frame | 14.539/15.059 | - | - | - | n/a | n/a | n/a | 380.83 ms | 0 | measured |
| moui-md-skia-gpu | small | input | ui-frame | 3.886/4.920 | - | 9.143/14.913 | 9.047/14.911 | n/a | n/a | n/a | 372.36 ms | 1 | measured |
| moui-md-skia-gpu | small | scroll | ui-frame | 4.837/6.413 | - | 7.511/9.474 | - | n/a | n/a | n/a | 386.89 ms | 0 | measured |
| moui-md-skia-gpu | medium | open | ui-frame | 15.040/15.765 | - | - | - | n/a | n/a | n/a | 383.41 ms | 0 | measured |
| moui-md-skia-gpu | medium | input | ui-frame | 3.900/4.240 | - | 9.173/16.205 | 9.086/16.204 | n/a | n/a | n/a | 377.43 ms | 1 | measured |
| moui-md-skia-gpu | medium | scroll | ui-frame | 4.799/6.288 | - | 7.475/9.555 | - | n/a | n/a | n/a | 387.71 ms | 0 | measured |
| moui-md-skia-gpu | large | open | ui-frame | 14.982/15.924 | - | - | - | n/a | n/a | n/a | 427.45 ms | 0 | measured |
| moui-md-skia-gpu | large | input | ui-frame | 4.479/4.986 | - | 11.576/18.138 | 11.483/18.136 | n/a | n/a | n/a | 418.98 ms | 3 | measured |
| moui-md-skia-gpu | large | scroll | ui-frame | 4.780/6.214 | - | 7.450/9.430 | - | n/a | n/a | n/a | 424.66 ms | 0 | measured |
| moui-md-skia-gpu | stress | open | ui-frame | 14.860/14.899 | - | - | - | n/a | n/a | n/a | 852.57 ms | 0 | measured |
| moui-md-skia-gpu | stress | input | ui-frame | 8.189/9.190 | - | 31.855/35.870 | 31.767/35.783 | n/a | n/a | n/a | 840.74 ms | 35 | measured |
| moui-md-skia-gpu | stress | scroll | ui-frame | 4.804/6.155 | - | 7.589/9.653 | - | n/a | n/a | n/a | 854.41 ms | 0 | measured |
| moui-md-wgpu | small | open | ui-frame | 54.984/56.679 | - | - | - | n/a | n/a | n/a | 1301.26 ms | 0 | measured |
| moui-md-wgpu | small | input | ui-frame | 7.274/8.374 | - | 18.108/21.284 | 18.003/21.134 | n/a | n/a | n/a | 1305.94 ms | 25 | measured |
| moui-md-wgpu | small | scroll | ui-frame | 5.919/7.607 | - | 16.557/20.835 | - | n/a | n/a | n/a | 1310.82 ms | 185 | measured |
| moui-md-wgpu | medium | open | ui-frame | 55.113/57.067 | - | - | - | n/a | n/a | n/a | 1311.28 ms | 0 | measured |
| moui-md-wgpu | medium | input | ui-frame | 7.351/8.563 | - | 18.410/20.416 | 18.313/20.326 | n/a | n/a | n/a | 1290.52 ms | 27 | measured |
| moui-md-wgpu | medium | scroll | ui-frame | 5.883/7.686 | - | 16.346/20.746 | - | n/a | n/a | n/a | 1315.21 ms | 175 | measured |
| moui-md-wgpu | large | open | ui-frame | 53.264/53.922 | - | - | - | n/a | n/a | n/a | 1330.77 ms | 0 | measured |
| moui-md-wgpu | large | input | ui-frame | 7.990/9.392 | - | 20.296/23.357 | 20.194/23.260 | n/a | n/a | n/a | 1347.00 ms | 30 | measured |
| moui-md-wgpu | large | scroll | ui-frame | 5.863/7.719 | - | 16.357/20.870 | - | n/a | n/a | n/a | 1332.88 ms | 169 | measured |
| moui-md-wgpu | stress | open | ui-frame | 55.141/57.064 | - | - | - | n/a | n/a | n/a | 1772.85 ms | 0 | measured |
| moui-md-wgpu | stress | input | ui-frame | 12.845/20.084 | - | 44.965/55.508 | 44.864/55.396 | n/a | n/a | n/a | 1770.48 ms | 64 | measured |
| moui-md-wgpu | stress | scroll | ui-frame | 5.966/7.857 | - | 16.768/22.017 | - | n/a | n/a | n/a | 1744.23 ms | 184 | measured |
| gpmark | small | open | ui-frame | 1.170/1.219 | - | - | - | n/a | n/a | n/a | 265.37 ms | n/a | measured |
| gpmark | small | input | ui-frame | 1.270/1.655 | 0.427/0.537 | 6.883/7.620 | 6.881/7.620 | n/a | n/a | n/a | 271.82 ms | n/a | measured |
| gpmark | small | scroll | ui-frame | 1.675/2.127 | 0.000/0.001 | 6.938/7.530 | - | n/a | n/a | n/a | 276.64 ms | n/a | measured |
| gpmark | medium | open | ui-frame | 1.269/1.412 | - | - | - | n/a | n/a | n/a | 275.79 ms | n/a | measured |
| gpmark | medium | input | ui-frame | 1.226/1.611 | 0.572/0.840 | 6.926/8.412 | 6.925/8.411 | n/a | n/a | n/a | 271.47 ms | n/a | measured |
| gpmark | medium | scroll | ui-frame | 1.681/2.142 | 0.000/0.001 | 6.940/7.543 | - | n/a | n/a | n/a | 275.82 ms | n/a | measured |
| gpmark | large | open | ui-frame | 1.472/1.538 | - | - | - | n/a | n/a | n/a | 313.72 ms | n/a | measured |
| gpmark | large | input | ui-frame | 1.236/1.515 | 1.765/2.235 | 6.813/8.077 | 6.811/8.071 | n/a | n/a | n/a | 314.57 ms | n/a | measured |
| gpmark | large | scroll | ui-frame | 1.685/2.160 | 0.000/0.001 | 6.940/7.480 | - | n/a | n/a | n/a | 315.18 ms | n/a | measured |
| gpmark | stress | open | ui-frame | 1.323/1.548 | - | - | - | n/a | n/a | n/a | 706.57 ms | n/a | measured |
| gpmark | stress | input | ui-frame | 1.180/1.579 | 15.968/17.832 | 16.240/20.057 | 16.239/20.057 | n/a | n/a | n/a | 712.73 ms | n/a | measured |
| gpmark | stress | scroll | ui-frame | 1.666/2.105 | 0.000/0.001 | 6.938/7.448 | - | n/a | n/a | n/a | 712.68 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 0.532/0.551 | - | - | - | 42.59 ms | n/a | n/a | 30.67 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 0.902/1.114 | - | 6.945/6.945 | 7.065/8.747 | 0.56 ms | n/a | n/a | 30.00 ms | 0 | measured |
| flutter-skia | small | scroll | ui-frame | 2.753/3.747 | - | 7.285/9.250 | - | 0.51 ms | n/a | n/a | 31.00 ms | 0 | measured |
| flutter-skia | medium | open | ui-frame | 0.504/0.563 | - | - | - | 43.22 ms | n/a | n/a | 30.33 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 0.928/1.126 | - | 6.944/6.945 | 7.033/8.324 | 0.58 ms | n/a | n/a | 30.00 ms | 0 | measured |
| flutter-skia | medium | scroll | ui-frame | 3.980/6.034 | - | 9.542/13.889 | - | 0.57 ms | n/a | n/a | 30.67 ms | 1 | measured |
| flutter-skia | large | open | ui-frame | 1.576/1.686 | - | - | - | 43.42 ms | n/a | n/a | 36.00 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 0.908/1.153 | - | 6.945/6.945 | 7.071/8.377 | 0.57 ms | n/a | n/a | 36.67 ms | 0 | measured |
| flutter-skia | large | scroll | ui-frame | 4.037/6.244 | - | 9.496/13.889 | - | 0.56 ms | n/a | n/a | 37.00 ms | 0 | measured |
| flutter-skia | stress | open | ui-frame | 0.521/0.568 | - | - | - | 40.92 ms | n/a | n/a | 93.00 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 0.907/1.266 | - | 6.765/6.945 | 6.874/8.236 | 0.56 ms | n/a | n/a | 92.67 ms | 0 | measured |
| flutter-skia | stress | scroll | ui-frame | 4.131/6.490 | - | 9.738/13.889 | - | 0.56 ms | n/a | n/a | 96.33 ms | 0 | measured |
| flutter-impeller | small | open | ui-frame | 0.501/0.513 | - | - | - | 20.77 ms | n/a | n/a | 31.67 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 0.971/1.326 | - | 6.945/6.945 | 6.937/8.578 | 1.41 ms | n/a | n/a | 32.33 ms | 0 | measured |
| flutter-impeller | small | scroll | ui-frame | 2.724/3.600 | - | 7.002/6.945 | - | 1.16 ms | n/a | n/a | 32.00 ms | 0 | measured |
| flutter-impeller | medium | open | ui-frame | 0.456/0.480 | - | - | - | 22.77 ms | n/a | n/a | 31.33 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 0.978/1.349 | - | 6.945/6.945 | 6.943/8.096 | 1.41 ms | n/a | n/a | 31.00 ms | 0 | measured |
| flutter-impeller | medium | scroll | ui-frame | 4.052/6.230 | - | 10.002/13.889 | - | 1.26 ms | n/a | n/a | 31.00 ms | 0 | measured |
| flutter-impeller | large | open | ui-frame | 1.644/1.740 | - | - | - | 19.07 ms | n/a | n/a | 37.33 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 0.948/1.080 | - | 6.808/6.945 | 7.019/9.214 | 1.52 ms | n/a | n/a | 38.00 ms | 0 | measured |
| flutter-impeller | large | scroll | ui-frame | 4.230/5.886 | - | 9.828/13.889 | - | 1.27 ms | n/a | n/a | 38.33 ms | 0 | measured |
| flutter-impeller | stress | open | ui-frame | 0.448/0.509 | - | - | - | 20.28 ms | n/a | n/a | 90.00 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 0.961/1.749 | - | 6.809/6.945 | 6.984/9.966 | 1.42 ms | n/a | n/a | 91.33 ms | 0 | measured |
| flutter-impeller | stress | scroll | ui-frame | 4.048/6.017 | - | 9.684/13.889 | - | 1.24 ms | n/a | n/a | 91.67 ms | 0 | measured |
| electron | small | open | ui-frame | 1306.667/1316.000 | - | - | - | n/a | n/a | n/a | 1306.67 ms | 0 | measured |
| electron | small | input | ui-frame | 3.007/4.300 | - | 8.424/19.472 | 6.997/13.900 | n/a | n/a | n/a | 1281.00 ms | 2 | measured |
| electron | small | scroll | ui-frame | 3.244/4.600 | - | 7.180/7.100 | - | n/a | n/a | n/a | 1281.33 ms | 0 | measured |
| electron | medium | open | ui-frame | 1285.000/1290.000 | - | - | - | n/a | n/a | n/a | 1285.00 ms | 0 | measured |
| electron | medium | input | ui-frame | 3.047/4.700 | - | 7.872/13.800 | 6.950/13.800 | n/a | n/a | n/a | 1292.33 ms | 0 | measured |
| electron | medium | scroll | ui-frame | 3.397/4.600 | - | 7.041/7.000 | - | n/a | n/a | n/a | 1292.67 ms | 0 | measured |
| electron | large | open | ui-frame | 1290.333/1296.000 | - | - | - | n/a | n/a | n/a | 1290.33 ms | 0 | measured |
| electron | large | input | ui-frame | 3.197/4.700 | - | 7.914/13.800 | 7.050/14.600 | n/a | n/a | n/a | 1301.33 ms | 0 | measured |
| electron | large | scroll | ui-frame | 3.421/4.800 | - | 7.076/7.100 | - | n/a | n/a | n/a | 1287.33 ms | 1 | measured |
| electron | stress | open | ui-frame | 1315.333/1329.000 | - | - | - | n/a | n/a | n/a | 1315.33 ms | 0 | measured |
| electron | stress | input | ui-frame | 3.050/5.400 | - | 7.687/13.900 | 7.150/15.600 | n/a | n/a | n/a | 1328.33 ms | 0 | measured |
| electron | stress | scroll | ui-frame | 3.383/4.600 | - | 7.238/7.100 | - | n/a | n/a | n/a | 1315.33 ms | 1 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.79/6.61/6.68 | 8.38/7.92/8.32 | 0/0/0 | 2.24/2.18/2.24 | 3.08/2.92/3.15 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 6.91/6.93/6.91 | 7.31/7.31/7.38 | 0/0/0 | 2.27/2.29/2.27 | 2.81/2.87/2.77 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 7.22/7.45/7.36 | 8.76/8.95/8.96 | 0/0/0 | 2.53/2.60/2.54 | 3.24/3.49/3.22 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 15.64/15.69/15.53 | 18.25/18.36/18.03 | 93/87/82 | 4.94/4.92/4.91 | 6.41/6.50/6.45 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 7.51/7.48/7.45 | 9.47/9.56/9.43 | 0/0/0 | 4.84/4.80/4.78 | 6.41/6.29/6.21 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 16.56/16.35/16.36 | 20.83/20.75/20.87 | 185/175/169 | 5.92/5.88/5.86 | 7.61/7.69/7.72 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 6.94/6.94/6.94 | 7.53/7.54/7.48 | n/a/n/a/n/a | 1.68/1.68/1.69 | 2.13/2.14/2.16 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.29/9.54/9.50 | 9.25/13.89/13.89 | 0/1/0 | 2.75/3.98/4.04 | 3.75/6.03/6.24 | 0.51/0.57/0.56 | 0.62/0.68/0.69 |
| Flutter Impeller | 7.00/10.00/9.83 | 6.95/13.89/13.89 | 0/0/0 | 2.72/4.05/4.23 | 3.60/6.23/5.89 | 1.16/1.26/1.27 | 1.35/1.52/1.54 |
| Electron | 7.18/7.04/7.08 | 7.10/7.00/7.10 | 0/0/1 | 3.24/3.40/3.42 | 4.60/4.60/4.80 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.93 | 8.40 | 0 | 2.28 | 3.04 | n/a | n/a |
| MoUI Skia GPU | 6.98 | 7.67 | 2 | 2.28 | 2.95 | n/a | n/a |
| MoUI WGPU | 7.29 | 8.81 | 0 | 2.56 | 3.24 | n/a | n/a |
| MoMark Skia Raster | 15.63 | 18.00 | 91 | 4.90 | 6.33 | n/a | n/a |
| MoMark Skia GPU | 7.59 | 9.65 | 0 | 4.80 | 6.16 | n/a | n/a |
| MoMark WGPU | 16.77 | 22.02 | 184 | 5.97 | 7.86 | n/a | n/a |
| GpMark.mbt (GPUI) | 6.94 | 7.45 | n/a | 1.67 | 2.11 | n/a | n/a |
| Flutter Skia | 9.74 | 13.89 | 0 | 4.13 | 6.49 | 0.56 | 0.70 |
| Flutter Impeller | 9.68 | 13.89 | 0 | 4.05 | 6.02 | 1.24 | 1.45 |
| Electron | 7.24 | 7.10 | 1 | 3.38 | 4.60 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.93/6.69/7.97 | 8.29/8.01/9.29 | 2.06/1.96/2.08 | 2.81/2.49/2.57 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 6.52/5.95/6.05 | 9.24/7.37/6.84 | 2.02/2.06/2.01 | 2.25/3.12/2.36 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 10.90/11.56/12.42 | 12.88/13.85/16.05 | 4.95/5.38/5.23 | 6.05/6.17/6.59 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 15.80/16.21/17.98 | 17.17/18.29/19.60 | 3.98/3.95/4.63 | 4.68/5.15/5.54 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 9.05/9.09/11.48 | 14.91/16.20/18.14 | 3.89/3.90/4.48 | 4.92/4.24/4.99 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 18.00/18.31/20.19 | 21.13/20.33/23.26 | 7.27/7.35/7.99 | 8.37/8.56/9.39 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 6.88/6.92/6.81 | 7.62/8.41/8.07 | 1.27/1.23/1.24 | 1.66/1.61/1.52 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.06/7.03/7.07 | 8.75/8.32/8.38 | 0.90/0.93/0.91 | 1.11/1.13/1.15 | 0.56/0.58/0.57 | 0.70/0.79/0.79 |
| Flutter Impeller | 6.94/6.94/7.02 | 8.58/8.10/9.21 | 0.97/0.98/0.95 | 1.33/1.35/1.08 | 1.41/1.41/1.52 | 1.94/1.70/1.92 |
| Electron | 7.00/6.95/7.05 | 13.90/13.80/14.60 | 3.01/3.05/3.20 | 4.30/4.70/4.70 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 18.17 | 19.98 | 2.20 | 2.78 | n/a | n/a |
| MoUI Skia GPU | 16.02 | 18.60 | 2.15 | 2.63 | n/a | n/a |
| MoUI WGPU | 21.06 | 24.08 | 5.09 | 5.93 | n/a | n/a |
| MoMark Skia Raster | 38.82 | 41.04 | 8.24 | 9.79 | n/a | n/a |
| MoMark Skia GPU | 31.77 | 35.78 | 8.19 | 9.19 | n/a | n/a |
| MoMark WGPU | 44.86 | 55.40 | 12.85 | 20.08 | n/a | n/a |
| GpMark.mbt (GPUI) | 16.24 | 20.06 | 1.18 | 1.58 | n/a | n/a |
| Flutter Skia | 6.87 | 8.24 | 0.91 | 1.27 | 0.56 | 0.72 |
| Flutter Impeller | 6.98 | 9.97 | 0.96 | 1.75 | 1.42 | 2.24 |
| Electron | 7.15 | 15.60 | 3.05 | 5.40 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 73.97/76.03/111.89 | 76.45/77.35/117.08 | 0.25/0.78/3.98 | 0.32/0.87/4.88 | 11.66/11.26/12.19 | 12.27/11.62/12.45 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 373.36/376.30/411.56 | 377.21/378.50/413.38 | 0.22/0.66/3.89 | 0.33/0.74/4.12 | 9.57/9.50/10.94 | 9.97/9.66/11.87 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 1279.16/1262.69/1288.38 | 1295.10/1272.42/1292.29 | 0.17/0.61/4.00 | 0.19/0.62/5.10 | 43.22/41.91/41.59 | 49.47/43.23/43.09 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 80.96/81.51/120.36 | 87.28/86.07/124.22 | 0.15/0.60/3.57 | 0.17/0.64/3.60 | 14.74/15.70/15.29 | 15.48/15.92/16.27 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 380.83/383.41/427.45 | 388.04/388.47/436.97 | 0.17/0.64/3.99 | 0.18/0.73/4.67 | 14.54/15.04/14.98 | 15.06/15.77/15.92 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 1301.26/1311.28/1330.77 | 1310.60/1343.67/1337.94 | 0.16/0.63/3.77 | 0.19/0.77/4.05 | 54.98/55.11/53.26 | 56.68/57.07/53.92 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 265.37/275.79/313.72 | 275.10/282.45/323.80 | 0.00/1.00/3.67 | 0.00/2.00/5.00 | 1.17/1.27/1.47 | 1.22/1.41/1.54 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 30.67/30.33/36.00 | 32.00/31.00/37.00 | 0.86/0.93/1.11 | 0.89/1.10/1.21 | 0.53/0.50/1.58 | 0.55/0.56/1.69 | 42.59/43.22/43.42 | 45.23/46.12/44.14 |
| Flutter Impeller | 31.67/31.33/37.33 | 33.00/32.00/40.00 | 0.91/0.89/1.15 | 0.92/0.94/1.22 | 0.50/0.46/1.64 | 0.51/0.48/1.74 | 20.77/22.77/19.07 | 24.03/23.57/21.41 |
| Electron | 1306.67/1285.00/1290.33 | 1316.00/1290.00/1296.00 | 3.47/3.83/4.00 | 3.70/4.15/4.64 | 1306.67/1285.00/1290.33 | 1316.00/1290.00/1296.00 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 461.09 | 486.34 | 38.52 | 40.41 | 11.95 | 12.55 | n/a | n/a |
| MoUI Skia GPU | 721.20 | 732.59 | 38.00 | 40.59 | 9.95 | 10.32 | n/a | n/a |
| MoUI WGPU | 1619.77 | 1633.85 | 38.02 | 39.67 | 41.83 | 44.95 | n/a | n/a |
| MoMark Skia Raster | 537.02 | 552.17 | 37.80 | 38.14 | 15.31 | 16.03 | n/a | n/a |
| MoMark Skia GPU | 852.57 | 855.86 | 37.22 | 37.61 | 14.86 | 14.90 | n/a | n/a |
| MoMark WGPU | 1772.85 | 1793.16 | 36.41 | 36.52 | 55.14 | 57.06 | n/a | n/a |
| GpMark.mbt (GPUI) | 706.57 | 719.11 | 38.33 | 40.00 | 1.32 | 1.55 | n/a | n/a |
| Flutter Skia | 93.00 | 97.00 | 3.57 | 3.71 | 0.52 | 0.57 | 40.92 | 45.57 |
| Flutter Impeller | 90.00 | 92.00 | 3.41 | 3.73 | 0.45 | 0.51 | 20.28 | 24.91 |
| Electron | 1315.33 | 1329.00 | 9.36 | 9.40 | 1315.33 | 1329.00 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.79/6.61/6.68 | 8.38/7.92/8.32 | 0/0/0 | 2.24/2.18/2.24 | 3.08/2.92/3.15 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 6.91/6.93/6.91 | 7.31/7.31/7.38 | 0/0/0 | 2.27/2.29/2.27 | 2.81/2.87/2.77 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 7.22/7.45/7.36 | 8.76/8.95/8.96 | 0/0/0 | 2.53/2.60/2.54 | 3.24/3.49/3.22 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 15.64/15.69/15.53 | 18.25/18.36/18.03 | 93/87/82 | 4.94/4.92/4.91 | 6.41/6.50/6.45 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 7.51/7.48/7.45 | 9.47/9.56/9.43 | 0/0/0 | 4.84/4.80/4.78 | 6.41/6.29/6.21 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 16.56/16.35/16.36 | 20.83/20.75/20.87 | 185/175/169 | 5.92/5.88/5.86 | 7.61/7.69/7.72 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 6.94/6.94/6.94 | 7.53/7.54/7.48 | n/a/n/a/n/a | 1.68/1.68/1.69 | 2.13/2.14/2.16 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.29/9.54/9.50 | 9.25/13.89/13.89 | 0/1/0 | 2.75/3.98/4.04 | 3.75/6.03/6.24 | 0.51/0.57/0.56 | 0.62/0.68/0.69 |
| Flutter Impeller | 7.00/10.00/9.83 | 6.95/13.89/13.89 | 0/0/0 | 2.72/4.05/4.23 | 3.60/6.23/5.89 | 1.16/1.26/1.27 | 1.35/1.52/1.54 |
| Electron | 7.18/7.04/7.08 | 7.10/7.00/7.10 | 0/0/1 | 3.24/3.40/3.42 | 4.60/4.60/4.80 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.93 | 8.40 | 0 | 2.28 | 3.04 | n/a | n/a |
| MoUI Skia GPU | 6.98 | 7.67 | 2 | 2.28 | 2.95 | n/a | n/a |
| MoUI WGPU | 7.29 | 8.81 | 0 | 2.56 | 3.24 | n/a | n/a |
| MoMark Skia Raster | 15.63 | 18.00 | 91 | 4.90 | 6.33 | n/a | n/a |
| MoMark Skia GPU | 7.59 | 9.65 | 0 | 4.80 | 6.16 | n/a | n/a |
| MoMark WGPU | 16.77 | 22.02 | 184 | 5.97 | 7.86 | n/a | n/a |
| GpMark.mbt (GPUI) | 6.94 | 7.45 | n/a | 1.67 | 2.11 | n/a | n/a |
| Flutter Skia | 9.74 | 13.89 | 0 | 4.13 | 6.49 | 0.56 | 0.70 |
| Flutter Impeller | 9.68 | 13.89 | 0 | 4.05 | 6.02 | 1.24 | 1.45 |
| Electron | 7.24 | 7.10 | 1 | 3.38 | 4.60 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoUI Skia Raster CPU large 111.9 ms（max 117.1 ms）；MoUI Skia Raster CPU stress 461.1 ms（max 486.3 ms）；MoUI Skia GPU small 373.4 ms（max 377.2 ms）；MoUI Skia GPU medium 376.3 ms（max 378.5 ms）；MoUI Skia GPU large 411.6 ms（max 413.4 ms）；MoUI Skia GPU stress 721.2 ms（max 732.6 ms）；MoUI WGPU small 1279.2 ms（max 1295.1 ms）；MoUI WGPU medium 1262.7 ms（max 1272.4 ms）；MoUI WGPU large 1288.4 ms（max 1292.3 ms）；MoUI WGPU stress 1619.8 ms（max 1633.8 ms）；MoMark Skia Raster large 120.4 ms（max 124.2 ms）；MoMark Skia Raster stress 537.0 ms（max 552.2 ms）；MoMark Skia GPU small 380.8 ms（max 388.0 ms）；MoMark Skia GPU medium 383.4 ms（max 388.5 ms）；MoMark Skia GPU large 427.5 ms（max 437.0 ms）；MoMark Skia GPU stress 852.6 ms（max 855.9 ms）；MoMark WGPU small 1301.3 ms（max 1310.6 ms）；MoMark WGPU medium 1311.3 ms（max 1343.7 ms）；MoMark WGPU large 1330.8 ms（max 1337.9 ms）；MoMark WGPU stress 1772.8 ms（max 1793.2 ms）；GpMark.mbt (GPUI) small 265.4 ms（max 275.1 ms）；GpMark.mbt (GPUI) medium 275.8 ms（max 282.4 ms）；GpMark.mbt (GPUI) large 313.7 ms（max 323.8 ms）；GpMark.mbt (GPUI) stress 706.6 ms（max 719.1 ms）；Electron small 1306.7 ms（max 1316.0 ms）；Electron medium 1285.0 ms（max 1290.0 ms）；Electron large 1290.3 ms（max 1296.0 ms）；Electron stress 1315.3 ms（max 1329.0 ms）。
- P1 输入尾延迟：MoUI Skia Raster CPU stress P95 19.98 ms；MoUI Skia GPU stress P95 18.60 ms；MoUI WGPU stress P95 24.08 ms；MoMark Skia Raster small P95 17.17 ms；MoMark Skia Raster medium P95 18.29 ms；MoMark Skia Raster large P95 19.60 ms；MoMark Skia Raster stress P95 41.04 ms；MoMark Skia GPU large P95 18.14 ms；MoMark Skia GPU stress P95 35.78 ms；MoMark WGPU small P95 21.13 ms；MoMark WGPU medium P95 20.33 ms；MoMark WGPU large P95 23.26 ms；MoMark WGPU stress P95 55.40 ms；GpMark.mbt (GPUI) stress P95 20.06 ms。
- 长帧（超预算）：MoUI Skia Raster CPU: stress/input 29 次，max 21.64 ms；MoUI Skia GPU: stress/input 9 次，max 19.06 ms, stress/scroll 2 次，max 17.40 ms；MoUI WGPU: stress/input 30 次，max 24.28 ms；MoMark Skia Raster: small/input 6 次，max 17.61 ms, small/scroll 82 次，max 23.17 ms, medium/input 8 次，max 23.71 ms, medium/scroll 78 次，max 23.15 ms, large/input 27 次，max 21.62 ms, large/scroll 75 次，max 21.62 ms, stress/input 30 次，max 41.26 ms, stress/scroll 81 次，max 21.95 ms；MoMark Skia GPU: small/input 1 次，max 17.06 ms, medium/input 1 次，max 17.43 ms, large/input 3 次，max 20.36 ms, stress/input 30 次，max 35.98 ms；MoMark WGPU: small/input 25 次，max 21.82 ms, small/scroll 181 次，max 26.46 ms, medium/input 27 次，max 20.51 ms, medium/scroll 173 次，max 27.10 ms, large/input 30 次，max 27.11 ms, large/scroll 164 次，max 27.69 ms, stress/input 30 次，max 65.60 ms, stress/scroll 179 次，max 31.78 ms；GpMark.mbt (GPUI): stress/input 23 次，max 21.00 ms；Flutter Skia: medium/scroll 1 次，max 27.78 ms；Electron: small/input 2 次，max 19.47 ms, large/scroll 1 次，max 20.90 ms, stress/scroll 1 次，max 20.80 ms。
- 丢帧（优先处理）：MoUI Skia Raster CPU: stress/input 29 帧；MoUI Skia GPU: stress/input 9 帧, stress/scroll 2 帧；MoUI WGPU: stress/input 30 帧；MoMark Skia Raster: small/input 7 帧, small/scroll 93 帧, medium/input 8 帧, medium/scroll 87 帧, large/input 27 帧, large/scroll 82 帧, stress/input 60 帧, stress/scroll 91 帧；MoMark Skia GPU: small/input 1 帧, medium/input 1 帧, large/input 3 帧, stress/input 35 帧；MoMark WGPU: small/input 25 帧, small/scroll 185 帧, medium/input 27 帧, medium/scroll 175 帧, large/input 30 帧, large/scroll 169 帧, stress/input 64 帧, stress/scroll 184 帧；Flutter Skia: medium/scroll 1 帧；Electron: small/input 2 帧, large/scroll 1 帧, stress/scroll 1 帧。
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
