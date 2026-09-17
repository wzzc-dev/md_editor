# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-17T02:01:00Z`
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
| moui-skia-raster | small | open | ui-frame | 10.198/11.293 | - | - | - | n/a | n/a | n/a | 67.55 ms | 0 | measured |
| moui-skia-raster | small | input | ui-frame | 1.888/2.225 | - | 6.348/7.457 | 6.248/7.364 | n/a | n/a | n/a | 65.69 ms | 0 | measured |
| moui-skia-raster | small | scroll | ui-frame | 2.064/2.686 | - | 6.225/7.542 | - | n/a | n/a | n/a | 65.35 ms | 0 | measured |
| moui-skia-raster | medium | open | ui-frame | 9.592/9.981 | - | - | - | n/a | n/a | n/a | 67.09 ms | 0 | measured |
| moui-skia-raster | medium | input | ui-frame | 1.817/2.082 | - | 6.320/7.413 | 6.223/7.330 | n/a | n/a | n/a | 66.02 ms | 0 | measured |
| moui-skia-raster | medium | scroll | ui-frame | 2.044/2.682 | - | 6.215/7.336 | - | n/a | n/a | n/a | 68.06 ms | 0 | measured |
| moui-skia-raster | large | open | ui-frame | 10.683/12.704 | - | - | - | n/a | n/a | n/a | 81.30 ms | 0 | measured |
| moui-skia-raster | large | input | ui-frame | 1.993/2.604 | - | 6.785/8.896 | 6.676/8.896 | n/a | n/a | n/a | 79.89 ms | 0 | measured |
| moui-skia-raster | large | scroll | ui-frame | 2.061/2.673 | - | 6.235/7.407 | - | n/a | n/a | n/a | 80.37 ms | 0 | measured |
| moui-skia-raster | stress | open | ui-frame | 9.624/10.132 | - | - | - | n/a | n/a | n/a | 199.63 ms | 0 | measured |
| moui-skia-raster | stress | input | ui-frame | 1.905/2.291 | - | 6.549/8.186 | 6.447/7.986 | n/a | n/a | n/a | 201.44 ms | 0 | measured |
| moui-skia-raster | stress | scroll | ui-frame | 2.062/2.664 | - | 6.257/7.409 | - | n/a | n/a | n/a | 198.87 ms | 0 | measured |
| moui-skia-gpu | small | open | ui-frame | 9.404/9.785 | - | - | - | n/a | n/a | n/a | 311.88 ms | 0 | measured |
| moui-skia-gpu | small | input | ui-frame | 1.962/2.312 | - | 14.865/30.415 | 14.760/30.302 | n/a | n/a | n/a | 313.65 ms | 14 | measured |
| moui-skia-gpu | small | scroll | ui-frame | 2.156/2.795 | - | 16.398/30.358 | - | n/a | n/a | n/a | 308.35 ms | 191 | measured |
| moui-skia-gpu | medium | open | ui-frame | 8.634/8.898 | - | - | - | n/a | n/a | n/a | 324.87 ms | 0 | measured |
| moui-skia-gpu | medium | input | ui-frame | 1.932/2.299 | - | 14.568/31.375 | 14.465/31.258 | n/a | n/a | n/a | 306.24 ms | 13 | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 2.103/2.708 | - | 16.515/30.391 | - | n/a | n/a | n/a | 304.75 ms | 193 | measured |
| moui-skia-gpu | large | open | ui-frame | 9.383/10.474 | - | - | - | n/a | n/a | n/a | 329.70 ms | 0 | measured |
| moui-skia-gpu | large | input | ui-frame | 1.968/2.355 | - | 13.673/25.955 | 13.565/25.858 | n/a | n/a | n/a | 317.51 ms | 12 | measured |
| moui-skia-gpu | large | scroll | ui-frame | 2.175/2.836 | - | 16.412/30.328 | - | n/a | n/a | n/a | 318.37 ms | 191 | measured |
| moui-skia-gpu | stress | open | ui-frame | 8.335/8.432 | - | - | - | n/a | n/a | n/a | 312.71 ms | 0 | measured |
| moui-skia-gpu | stress | input | ui-frame | 1.922/2.301 | - | 13.691/27.154 | 13.588/27.028 | n/a | n/a | n/a | 314.43 ms | 13 | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 2.297/3.171 | - | 16.121/30.171 | - | n/a | n/a | n/a | 317.42 ms | 184 | measured |
| moui-wgpu | small | open | ui-frame | 44.455/45.056 | - | - | - | n/a | n/a | n/a | 1149.83 ms | 0 | measured |
| moui-wgpu | small | input | ui-frame | 5.650/7.119 | - | 14.467/21.004 | 14.358/20.909 | n/a | n/a | n/a | 1184.26 ms | 10 | measured |
| moui-wgpu | small | scroll | ui-frame | 2.385/2.991 | - | 15.338/24.528 | - | n/a | n/a | n/a | 1165.94 ms | 179 | measured |
| moui-wgpu | medium | open | ui-frame | 48.481/54.399 | - | - | - | n/a | n/a | n/a | 1166.82 ms | 0 | measured |
| moui-wgpu | medium | input | ui-frame | 5.304/6.665 | - | 14.553/22.490 | 14.446/22.394 | n/a | n/a | n/a | 1155.56 ms | 12 | measured |
| moui-wgpu | medium | scroll | ui-frame | 2.360/2.970 | - | 15.262/24.221 | - | n/a | n/a | n/a | 1154.25 ms | 178 | measured |
| moui-wgpu | large | open | ui-frame | 45.898/48.019 | - | - | - | n/a | n/a | n/a | 1173.15 ms | 0 | measured |
| moui-wgpu | large | input | ui-frame | 5.587/6.907 | - | 14.204/21.974 | 14.090/21.863 | n/a | n/a | n/a | 1179.13 ms | 9 | measured |
| moui-wgpu | large | scroll | ui-frame | 2.382/3.057 | - | 15.265/24.552 | - | n/a | n/a | n/a | 1204.19 ms | 176 | measured |
| moui-wgpu | stress | open | ui-frame | 47.302/50.640 | - | - | - | n/a | n/a | n/a | 1296.06 ms | 0 | measured |
| moui-wgpu | stress | input | ui-frame | 5.606/7.345 | - | 14.611/22.877 | 14.502/22.782 | n/a | n/a | n/a | 1302.58 ms | 10 | measured |
| moui-wgpu | stress | scroll | ui-frame | 2.424/3.049 | - | 15.388/24.544 | - | n/a | n/a | n/a | 1310.45 ms | 179 | measured |
| moui-md-skia-raster | small | open | ui-frame | 10.959/11.837 | - | - | - | n/a | n/a | n/a | 67.54 ms | 0 | measured |
| moui-md-skia-raster | small | input | ui-frame | 3.537/4.940 | - | 14.370/15.885 | 14.279/15.797 | n/a | n/a | n/a | 67.63 ms | 1 | measured |
| moui-md-skia-raster | small | scroll | ui-frame | 4.560/5.944 | - | 14.701/16.716 | - | n/a | n/a | n/a | 66.99 ms | 22 | measured |
| moui-md-skia-raster | medium | open | ui-frame | 11.530/12.199 | - | - | - | n/a | n/a | n/a | 71.09 ms | 0 | measured |
| moui-md-skia-raster | medium | input | ui-frame | 3.589/4.047 | - | 14.855/16.456 | 14.767/16.365 | n/a | n/a | n/a | 72.89 ms | 1 | measured |
| moui-md-skia-raster | medium | scroll | ui-frame | 4.590/5.932 | - | 14.770/16.908 | - | n/a | n/a | n/a | 70.66 ms | 22 | measured |
| moui-md-skia-raster | large | open | ui-frame | 10.801/11.395 | - | - | - | n/a | n/a | n/a | 111.91 ms | 0 | measured |
| moui-md-skia-raster | large | input | ui-frame | 3.605/4.233 | - | 15.801/18.602 | 15.715/18.510 | n/a | n/a | n/a | 110.29 ms | 5 | measured |
| moui-md-skia-raster | large | scroll | ui-frame | 4.601/5.994 | - | 14.793/17.187 | - | n/a | n/a | n/a | 112.65 ms | 36 | measured |
| moui-md-skia-raster | stress | open | ui-frame | 10.937/11.362 | - | - | - | n/a | n/a | n/a | 526.89 ms | 0 | measured |
| moui-md-skia-raster | stress | input | ui-frame | 6.576/7.424 | - | 30.304/32.494 | 30.215/32.407 | n/a | n/a | n/a | 536.42 ms | 30 | measured |
| moui-md-skia-raster | stress | scroll | ui-frame | 4.679/6.117 | - | 15.183/17.853 | - | n/a | n/a | n/a | 534.37 ms | 52 | measured |
| moui-md-skia-gpu | small | open | ui-frame | 11.151/11.230 | - | - | - | n/a | n/a | n/a | 322.37 ms | 0 | measured |
| moui-md-skia-gpu | small | input | ui-frame | 3.504/3.943 | - | 14.045/25.235 | 13.961/25.141 | n/a | n/a | n/a | 322.09 ms | 11 | measured |
| moui-md-skia-gpu | small | scroll | ui-frame | 4.593/6.079 | - | 15.324/23.502 | - | n/a | n/a | n/a | 319.73 ms | 178 | measured |
| moui-md-skia-gpu | medium | open | ui-frame | 10.522/11.173 | - | - | - | n/a | n/a | n/a | 316.89 ms | 0 | measured |
| moui-md-skia-gpu | medium | input | ui-frame | 3.334/3.827 | - | 14.321/24.361 | 14.235/24.280 | n/a | n/a | n/a | 324.11 ms | 12 | measured |
| moui-md-skia-gpu | medium | scroll | ui-frame | 4.514/5.733 | - | 15.300/23.873 | - | n/a | n/a | n/a | 321.49 ms | 179 | measured |
| moui-md-skia-gpu | large | open | ui-frame | 10.732/11.095 | - | - | - | n/a | n/a | n/a | 318.09 ms | 0 | measured |
| moui-md-skia-gpu | large | input | ui-frame | 3.830/4.467 | - | 14.064/23.054 | 13.977/22.953 | n/a | n/a | n/a | 322.91 ms | 12 | measured |
| moui-md-skia-gpu | large | scroll | ui-frame | 4.473/5.783 | - | 15.292/24.554 | - | n/a | n/a | n/a | 320.36 ms | 178 | measured |
| moui-md-skia-gpu | stress | open | ui-frame | 12.051/12.613 | - | - | - | n/a | n/a | n/a | 609.44 ms | 0 | measured |
| moui-md-skia-gpu | stress | input | ui-frame | 6.507/7.713 | - | 23.066/25.254 | 22.982/25.171 | n/a | n/a | n/a | 596.08 ms | 30 | measured |
| moui-md-skia-gpu | stress | scroll | ui-frame | 4.628/5.968 | - | 15.333/24.675 | - | n/a | n/a | n/a | 596.00 ms | 178 | measured |
| moui-md-wgpu | small | open | ui-frame | 63.006/63.947 | - | - | - | n/a | n/a | n/a | 1190.04 ms | 0 | measured |
| moui-md-wgpu | small | input | ui-frame | 7.637/11.316 | - | 18.318/21.793 | 18.228/21.683 | n/a | n/a | n/a | 1197.70 ms | 24 | measured |
| moui-md-wgpu | small | scroll | ui-frame | 5.340/6.746 | - | 17.069/32.819 | - | n/a | n/a | n/a | 1176.84 ms | 176 | measured |
| moui-md-wgpu | medium | open | ui-frame | 60.760/62.255 | - | - | - | n/a | n/a | n/a | 1201.84 ms | 0 | measured |
| moui-md-wgpu | medium | input | ui-frame | 7.351/8.310 | - | 17.946/21.181 | 17.864/21.095 | n/a | n/a | n/a | 1192.67 ms | 23 | measured |
| moui-md-wgpu | medium | scroll | ui-frame | 5.435/6.891 | - | 17.289/31.275 | - | n/a | n/a | n/a | 1174.42 ms | 169 | measured |
| moui-md-wgpu | large | open | ui-frame | 61.861/62.958 | - | - | - | n/a | n/a | n/a | 1237.53 ms | 0 | measured |
| moui-md-wgpu | large | input | ui-frame | 7.628/8.719 | - | 19.362/23.492 | 19.275/23.404 | n/a | n/a | n/a | 1227.23 ms | 29 | measured |
| moui-md-wgpu | large | scroll | ui-frame | 5.449/6.910 | - | 17.903/32.644 | - | n/a | n/a | n/a | 1243.31 ms | 190 | measured |
| moui-md-wgpu | stress | open | ui-frame | 62.239/64.296 | - | - | - | n/a | n/a | n/a | 1676.07 ms | 0 | measured |
| moui-md-wgpu | stress | input | ui-frame | 10.206/11.586 | - | 34.360/38.270 | 34.280/38.160 | n/a | n/a | n/a | 1661.82 ms | 50 | measured |
| moui-md-wgpu | stress | scroll | ui-frame | 5.538/7.072 | - | 17.327/30.508 | - | n/a | n/a | n/a | 1692.49 ms | 173 | measured |
| gpmark | small | open | ui-frame | 1.091/1.130 | - | - | - | n/a | n/a | n/a | 250.55 ms | n/a | measured |
| gpmark | small | input | ui-frame | 1.137/1.376 | 0.379/0.452 | 30.509/31.353 | 30.508/31.353 | n/a | n/a | n/a | 252.06 ms | n/a | measured |
| gpmark | small | scroll | ui-frame | 1.815/2.648 | 0.001/0.001 | 30.781/31.913 | - | n/a | n/a | n/a | 280.39 ms | n/a | measured |
| gpmark | medium | open | ui-frame | 1.421/1.791 | - | - | - | n/a | n/a | n/a | 276.22 ms | n/a | measured |
| gpmark | medium | input | ui-frame | 1.312/1.731 | 0.480/0.665 | 30.757/31.888 | 30.755/31.884 | n/a | n/a | n/a | 275.59 ms | n/a | measured |
| gpmark | medium | scroll | ui-frame | 1.833/2.583 | 0.001/0.001 | 30.840/32.307 | - | n/a | n/a | n/a | 266.08 ms | n/a | measured |
| gpmark | large | open | ui-frame | 1.333/1.536 | - | - | - | n/a | n/a | n/a | 310.21 ms | n/a | measured |
| gpmark | large | input | ui-frame | 1.321/1.657 | 0.882/1.061 | 30.672/31.634 | 30.670/31.633 | n/a | n/a | n/a | 314.34 ms | n/a | measured |
| gpmark | large | scroll | ui-frame | 1.838/2.660 | 0.001/0.001 | 30.795/32.162 | - | n/a | n/a | n/a | 310.99 ms | n/a | measured |
| gpmark | stress | open | ui-frame | 1.274/1.392 | - | - | - | n/a | n/a | n/a | 717.89 ms | n/a | measured |
| gpmark | stress | input | ui-frame | 1.211/1.372 | 4.999/6.217 | 30.794/32.390 | 30.792/32.381 | n/a | n/a | n/a | 750.36 ms | n/a | measured |
| gpmark | stress | scroll | ui-frame | 1.630/2.295 | 0.001/0.001 | 30.688/31.804 | - | n/a | n/a | n/a | 677.79 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 0.434/0.452 | - | - | - | 72.02 ms | n/a | n/a | 176.67 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 0.828/1.198 | - | 6.945/6.945 | 7.015/8.363 | 0.51 ms | n/a | n/a | 169.67 ms | 0 | measured |
| flutter-skia | small | scroll | ui-frame | 2.385/2.910 | - | 7.041/6.945 | - | 0.46 ms | n/a | n/a | 171.00 ms | 0 | measured |
| flutter-skia | medium | open | ui-frame | 0.499/0.547 | - | - | - | 76.80 ms | n/a | n/a | 169.67 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 0.790/0.936 | - | 6.945/6.945 | 7.075/8.473 | 0.47 ms | n/a | n/a | 171.33 ms | 0 | measured |
| flutter-skia | medium | scroll | ui-frame | 3.557/5.414 | - | 8.584/13.889 | - | 0.49 ms | n/a | n/a | 171.33 ms | 0 | measured |
| flutter-skia | large | open | ui-frame | 1.443/1.535 | - | - | - | 78.76 ms | n/a | n/a | 176.33 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 0.817/1.201 | - | 6.945/6.945 | 7.030/8.776 | 0.46 ms | n/a | n/a | 175.00 ms | 0 | measured |
| flutter-skia | large | scroll | ui-frame | 3.613/5.308 | - | 8.411/13.890 | - | 0.50 ms | n/a | n/a | 179.33 ms | 0 | measured |
| flutter-skia | stress | open | ui-frame | 0.439/0.479 | - | - | - | 74.38 ms | n/a | n/a | 228.67 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 0.782/0.927 | - | 6.945/6.945 | 7.009/7.757 | 0.48 ms | n/a | n/a | 230.33 ms | 0 | measured |
| flutter-skia | stress | scroll | ui-frame | 3.507/5.436 | - | 8.661/13.890 | - | 0.50 ms | n/a | n/a | 235.33 ms | 0 | measured |
| flutter-impeller | small | open | ui-frame | 0.463/0.589 | - | - | - | 66.57 ms | n/a | n/a | 1322.67 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 0.855/1.081 | - | 6.945/6.945 | 7.104/8.480 | 1.33 ms | n/a | n/a | 1312.33 ms | 0 | measured |
| flutter-impeller | small | scroll | ui-frame | 2.405/2.937 | - | 6.945/6.945 | - | 1.12 ms | n/a | n/a | 1297.00 ms | 0 | measured |
| flutter-impeller | medium | open | ui-frame | 0.407/0.477 | - | - | - | 63.10 ms | n/a | n/a | 1314.33 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 0.828/1.217 | - | 6.945/6.945 | 7.044/8.783 | 1.40 ms | n/a | n/a | 1323.33 ms | 0 | measured |
| flutter-impeller | medium | scroll | ui-frame | 3.657/5.569 | - | 8.874/13.889 | - | 1.19 ms | n/a | n/a | 1299.00 ms | 0 | measured |
| flutter-impeller | large | open | ui-frame | 1.394/1.437 | - | - | - | 51.20 ms | n/a | n/a | 1304.67 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 0.933/1.356 | - | 6.945/6.945 | 7.105/7.938 | 1.35 ms | n/a | n/a | 1316.67 ms | 0 | measured |
| flutter-impeller | large | scroll | ui-frame | 3.664/5.512 | - | 8.951/13.890 | - | 1.17 ms | n/a | n/a | 1357.00 ms | 0 | measured |
| flutter-impeller | stress | open | ui-frame | 0.479/0.491 | - | - | - | 58.35 ms | n/a | n/a | 1376.00 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 0.813/0.967 | - | 6.945/6.945 | 6.971/8.052 | 1.21 ms | n/a | n/a | 1358.33 ms | 0 | measured |
| flutter-impeller | stress | scroll | ui-frame | 3.887/5.868 | - | 9.568/13.890 | - | 1.22 ms | n/a | n/a | 1385.67 ms | 2 | measured |
| electron | small | open | ui-frame | 1275.333/1307.000 | - | - | - | n/a | n/a | n/a | 1275.33 ms | 0 | measured |
| electron | small | input | ui-frame | 2.783/4.200 | - | 8.324/15.100 | 7.233/12.500 | n/a | n/a | n/a | 1259.33 ms | 1 | measured |
| electron | small | scroll | ui-frame | 2.988/4.600 | - | 7.646/7.700 | - | n/a | n/a | n/a | 1253.00 ms | 0 | measured |
| electron | medium | open | ui-frame | 1235.000/1246.000 | - | - | - | n/a | n/a | n/a | 1235.00 ms | 0 | measured |
| electron | medium | input | ui-frame | 2.800/4.500 | - | 8.246/14.800 | 7.193/11.400 | n/a | n/a | n/a | 1245.67 ms | 0 | measured |
| electron | medium | scroll | ui-frame | 3.354/4.700 | - | 7.639/7.700 | - | n/a | n/a | n/a | 1256.00 ms | 1 | measured |
| electron | large | open | ui-frame | 1256.333/1273.000 | - | - | - | n/a | n/a | n/a | 1256.33 ms | 0 | measured |
| electron | large | input | ui-frame | 2.787/3.800 | - | 7.944/14.800 | 7.270/10.700 | n/a | n/a | n/a | 1257.33 ms | 0 | measured |
| electron | large | scroll | ui-frame | 3.170/4.700 | - | 7.671/7.800 | - | n/a | n/a | n/a | 1248.00 ms | 0 | measured |
| electron | stress | open | ui-frame | 1272.667/1278.000 | - | - | - | n/a | n/a | n/a | 1272.67 ms | 0 | measured |
| electron | stress | input | ui-frame | 2.890/4.400 | - | 8.331/15.200 | 7.373/16.200 | n/a | n/a | n/a | 1278.00 ms | 0 | measured |
| electron | stress | scroll | ui-frame | 3.376/4.600 | - | 7.704/7.800 | - | n/a | n/a | n/a | 1292.33 ms | 0 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.23/6.22/6.23 | 7.54/7.34/7.41 | 0/0/0 | 2.06/2.04/2.06 | 2.69/2.68/2.67 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 16.40/16.51/16.41 | 30.36/30.39/30.33 | 191/193/191 | 2.16/2.10/2.18 | 2.79/2.71/2.84 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 15.34/15.26/15.26 | 24.53/24.22/24.55 | 179/178/176 | 2.39/2.36/2.38 | 2.99/2.97/3.06 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 14.70/14.77/14.79 | 16.72/16.91/17.19 | 22/22/36 | 4.56/4.59/4.60 | 5.94/5.93/5.99 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 15.32/15.30/15.29 | 23.50/23.87/24.55 | 178/179/178 | 4.59/4.51/4.47 | 6.08/5.73/5.78 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 17.07/17.29/17.90 | 32.82/31.27/32.64 | 176/169/190 | 5.34/5.44/5.45 | 6.75/6.89/6.91 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 30.78/30.84/30.79 | 31.91/32.31/32.16 | n/a/n/a/n/a | 1.82/1.83/1.84 | 2.65/2.58/2.66 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.04/8.58/8.41 | 6.95/13.89/13.89 | 0/0/0 | 2.39/3.56/3.61 | 2.91/5.41/5.31 | 0.46/0.49/0.50 | 0.60/0.64/0.63 |
| Flutter Impeller | 6.94/8.87/8.95 | 6.95/13.89/13.89 | 0/0/0 | 2.40/3.66/3.66 | 2.94/5.57/5.51 | 1.12/1.19/1.17 | 1.41/1.60/1.45 |
| Electron | 7.65/7.64/7.67 | 7.70/7.70/7.80 | 0/1/0 | 2.99/3.35/3.17 | 4.60/4.70/4.70 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.26 | 7.41 | 0 | 2.06 | 2.66 | n/a | n/a |
| MoUI Skia GPU | 16.12 | 30.17 | 184 | 2.30 | 3.17 | n/a | n/a |
| MoUI WGPU | 15.39 | 24.54 | 179 | 2.42 | 3.05 | n/a | n/a |
| MoMark Skia Raster | 15.18 | 17.85 | 52 | 4.68 | 6.12 | n/a | n/a |
| MoMark Skia GPU | 15.33 | 24.67 | 178 | 4.63 | 5.97 | n/a | n/a |
| MoMark WGPU | 17.33 | 30.51 | 173 | 5.54 | 7.07 | n/a | n/a |
| GpMark.mbt (GPUI) | 30.69 | 31.80 | n/a | 1.63 | 2.30 | n/a | n/a |
| Flutter Skia | 8.66 | 13.89 | 0 | 3.51 | 5.44 | 0.50 | 0.62 |
| Flutter Impeller | 9.57 | 13.89 | 2 | 3.89 | 5.87 | 1.22 | 1.66 |
| Electron | 7.70 | 7.80 | 0 | 3.38 | 4.60 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.25/6.22/6.68 | 7.36/7.33/8.90 | 1.89/1.82/1.99 | 2.22/2.08/2.60 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 14.76/14.46/13.57 | 30.30/31.26/25.86 | 1.96/1.93/1.97 | 2.31/2.30/2.35 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 14.36/14.45/14.09 | 20.91/22.39/21.86 | 5.65/5.30/5.59 | 7.12/6.66/6.91 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 14.28/14.77/15.71 | 15.80/16.37/18.51 | 3.54/3.59/3.60 | 4.94/4.05/4.23 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 13.96/14.24/13.98 | 25.14/24.28/22.95 | 3.50/3.33/3.83 | 3.94/3.83/4.47 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 18.23/17.86/19.27 | 21.68/21.10/23.40 | 7.64/7.35/7.63 | 11.32/8.31/8.72 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 30.51/30.75/30.67 | 31.35/31.88/31.63 | 1.14/1.31/1.32 | 1.38/1.73/1.66 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.01/7.08/7.03 | 8.36/8.47/8.78 | 0.83/0.79/0.82 | 1.20/0.94/1.20 | 0.51/0.47/0.46 | 0.69/0.59/0.59 |
| Flutter Impeller | 7.10/7.04/7.10 | 8.48/8.78/7.94 | 0.86/0.83/0.93 | 1.08/1.22/1.36 | 1.33/1.40/1.35 | 1.84/2.10/1.91 |
| Electron | 7.23/7.19/7.27 | 12.50/11.40/10.70 | 2.78/2.80/2.79 | 4.20/4.50/3.80 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.45 | 7.99 | 1.90 | 2.29 | n/a | n/a |
| MoUI Skia GPU | 13.59 | 27.03 | 1.92 | 2.30 | n/a | n/a |
| MoUI WGPU | 14.50 | 22.78 | 5.61 | 7.34 | n/a | n/a |
| MoMark Skia Raster | 30.21 | 32.41 | 6.58 | 7.42 | n/a | n/a |
| MoMark Skia GPU | 22.98 | 25.17 | 6.51 | 7.71 | n/a | n/a |
| MoMark WGPU | 34.28 | 38.16 | 10.21 | 11.59 | n/a | n/a |
| GpMark.mbt (GPUI) | 30.79 | 32.38 | 1.21 | 1.37 | n/a | n/a |
| Flutter Skia | 7.01 | 7.76 | 0.78 | 0.93 | 0.48 | 0.67 |
| Flutter Impeller | 6.97 | 8.05 | 0.81 | 0.97 | 1.21 | 1.64 |
| Electron | 7.37 | 16.20 | 2.89 | 4.40 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 67.55/67.09/81.30 | 68.95/68.54/83.48 | 0.18/0.60/3.39 | 0.21/0.63/3.55 | 10.20/9.59/10.68 | 11.29/9.98/12.70 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 311.88/324.87/329.70 | 316.00/338.89/366.05 | 0.17/0.60/3.90 | 0.19/0.61/4.15 | 9.40/8.63/9.38 | 9.79/8.90/10.47 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 1149.83/1166.82/1173.15 | 1156.53/1175.40/1186.26 | 0.17/0.74/3.65 | 0.19/0.82/4.24 | 44.45/48.48/45.90 | 45.06/54.40/48.02 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 67.54/71.09/111.91 | 67.74/72.11/112.46 | 0.13/0.55/3.31 | 0.13/0.58/3.40 | 10.96/11.53/10.80 | 11.84/12.20/11.39 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 322.37/316.89/318.09 | 327.29/320.54/321.66 | 0.12/0.61/3.54 | 0.12/0.68/3.72 | 11.15/10.52/10.73 | 11.23/11.17/11.10 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 1190.04/1201.84/1237.53 | 1207.45/1215.94/1253.71 | 0.15/0.54/3.92 | 0.18/0.56/4.44 | 63.01/60.76/61.86 | 63.95/62.26/62.96 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 250.55/276.22/310.21 | 252.12/280.98/314.53 | 0.00/1.00/4.67 | 0.00/1.00/6.00 | 1.09/1.42/1.33 | 1.13/1.79/1.54 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 176.67/169.67/176.33 | 179.00/173.00/182.00 | 0.81/0.89/1.06 | 0.90/0.93/1.24 | 0.43/0.50/1.44 | 0.45/0.55/1.53 | 72.02/76.80/78.76 | 82.74/88.50/82.02 |
| Flutter Impeller | 1322.67/1314.33/1304.67 | 1364.00/1338.00/1315.00 | 0.89/0.85/1.12 | 1.10/0.90/1.30 | 0.46/0.41/1.39 | 0.59/0.48/1.44 | 66.57/63.10/51.20 | 71.91/66.28/53.99 |
| Electron | 1275.33/1235.00/1256.33 | 1307.00/1246.00/1273.00 | 3.17/3.82/4.00 | 3.51/4.21/4.53 | 1275.33/1235.00/1256.33 | 1307.00/1246.00/1273.00 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 199.63 | 201.64 | 35.34 | 36.85 | 9.62 | 10.13 | n/a | n/a |
| MoUI Skia GPU | 312.71 | 313.38 | 36.50 | 37.26 | 8.34 | 8.43 | n/a | n/a |
| MoUI WGPU | 1296.06 | 1306.98 | 35.74 | 36.03 | 47.30 | 50.64 | n/a | n/a |
| MoMark Skia Raster | 526.89 | 530.62 | 35.41 | 36.90 | 10.94 | 11.36 | n/a | n/a |
| MoMark Skia GPU | 609.44 | 620.35 | 36.76 | 37.76 | 12.05 | 12.61 | n/a | n/a |
| MoMark WGPU | 1676.07 | 1701.97 | 35.43 | 36.02 | 62.24 | 64.30 | n/a | n/a |
| GpMark.mbt (GPUI) | 717.89 | 722.08 | 46.00 | 53.00 | 1.27 | 1.39 | n/a | n/a |
| Flutter Skia | 228.67 | 232.00 | 3.14 | 3.21 | 0.44 | 0.48 | 74.38 | 88.90 |
| Flutter Impeller | 1376.00 | 1392.00 | 3.85 | 4.47 | 0.48 | 0.49 | 58.35 | 73.20 |
| Electron | 1272.67 | 1278.00 | 9.67 | 10.87 | 1272.67 | 1278.00 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.23/6.22/6.23 | 7.54/7.34/7.41 | 0/0/0 | 2.06/2.04/2.06 | 2.69/2.68/2.67 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | 16.40/16.51/16.41 | 30.36/30.39/30.33 | 191/193/191 | 2.16/2.10/2.18 | 2.79/2.71/2.84 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | 15.34/15.26/15.26 | 24.53/24.22/24.55 | 179/178/176 | 2.39/2.36/2.38 | 2.99/2.97/3.06 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 14.70/14.77/14.79 | 16.72/16.91/17.19 | 22/22/36 | 4.56/4.59/4.60 | 5.94/5.93/5.99 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 15.32/15.30/15.29 | 23.50/23.87/24.55 | 178/179/178 | 4.59/4.51/4.47 | 6.08/5.73/5.78 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 17.07/17.29/17.90 | 32.82/31.27/32.64 | 176/169/190 | 5.34/5.44/5.45 | 6.75/6.89/6.91 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 30.78/30.84/30.79 | 31.91/32.31/32.16 | n/a/n/a/n/a | 1.82/1.83/1.84 | 2.65/2.58/2.66 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 7.04/8.58/8.41 | 6.95/13.89/13.89 | 0/0/0 | 2.39/3.56/3.61 | 2.91/5.41/5.31 | 0.46/0.49/0.50 | 0.60/0.64/0.63 |
| Flutter Impeller | 6.94/8.87/8.95 | 6.95/13.89/13.89 | 0/0/0 | 2.40/3.66/3.66 | 2.94/5.57/5.51 | 1.12/1.19/1.17 | 1.41/1.60/1.45 |
| Electron | 7.65/7.64/7.67 | 7.70/7.70/7.80 | 0/1/0 | 2.99/3.35/3.17 | 4.60/4.70/4.70 | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 6.26 | 7.41 | 0 | 2.06 | 2.66 | n/a | n/a |
| MoUI Skia GPU | 16.12 | 30.17 | 184 | 2.30 | 3.17 | n/a | n/a |
| MoUI WGPU | 15.39 | 24.54 | 179 | 2.42 | 3.05 | n/a | n/a |
| MoMark Skia Raster | 15.18 | 17.85 | 52 | 4.68 | 6.12 | n/a | n/a |
| MoMark Skia GPU | 15.33 | 24.67 | 178 | 4.63 | 5.97 | n/a | n/a |
| MoMark WGPU | 17.33 | 30.51 | 173 | 5.54 | 7.07 | n/a | n/a |
| GpMark.mbt (GPUI) | 30.69 | 31.80 | n/a | 1.63 | 2.30 | n/a | n/a |
| Flutter Skia | 8.66 | 13.89 | 0 | 3.51 | 5.44 | 0.50 | 0.62 |
| Flutter Impeller | 9.57 | 13.89 | 2 | 3.89 | 5.87 | 1.22 | 1.66 |
| Electron | 7.70 | 7.80 | 0 | 3.38 | 4.60 | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoUI Skia Raster CPU stress 199.6 ms（max 201.6 ms）；MoUI Skia GPU small 311.9 ms（max 316.0 ms）；MoUI Skia GPU medium 324.9 ms（max 338.9 ms）；MoUI Skia GPU large 329.7 ms（max 366.1 ms）；MoUI Skia GPU stress 312.7 ms（max 313.4 ms）；MoUI WGPU small 1149.8 ms（max 1156.5 ms）；MoUI WGPU medium 1166.8 ms（max 1175.4 ms）；MoUI WGPU large 1173.1 ms（max 1186.3 ms）；MoUI WGPU stress 1296.1 ms（max 1307.0 ms）；MoMark Skia Raster large 111.9 ms（max 112.5 ms）；MoMark Skia Raster stress 526.9 ms（max 530.6 ms）；MoMark Skia GPU small 322.4 ms（max 327.3 ms）；MoMark Skia GPU medium 316.9 ms（max 320.5 ms）；MoMark Skia GPU large 318.1 ms（max 321.7 ms）；MoMark Skia GPU stress 609.4 ms（max 620.3 ms）；MoMark WGPU small 1190.0 ms（max 1207.4 ms）；MoMark WGPU medium 1201.8 ms（max 1215.9 ms）；MoMark WGPU large 1237.5 ms（max 1253.7 ms）；MoMark WGPU stress 1676.1 ms（max 1702.0 ms）；GpMark.mbt (GPUI) small 250.5 ms（max 252.1 ms）；GpMark.mbt (GPUI) medium 276.2 ms（max 281.0 ms）；GpMark.mbt (GPUI) large 310.2 ms（max 314.5 ms）；GpMark.mbt (GPUI) stress 717.9 ms（max 722.1 ms）；Flutter Skia small 176.7 ms（max 179.0 ms）；Flutter Skia medium 169.7 ms（max 173.0 ms）；Flutter Skia large 176.3 ms（max 182.0 ms）；Flutter Skia stress 228.7 ms（max 232.0 ms）；Flutter Impeller small 1322.7 ms（max 1364.0 ms）；Flutter Impeller medium 1314.3 ms（max 1338.0 ms）；Flutter Impeller large 1304.7 ms（max 1315.0 ms）；Flutter Impeller stress 1376.0 ms（max 1392.0 ms）；Electron small 1275.3 ms（max 1307.0 ms）；Electron medium 1235.0 ms（max 1246.0 ms）；Electron large 1256.3 ms（max 1273.0 ms）；Electron stress 1272.7 ms（max 1278.0 ms）。
- P1 输入尾延迟：MoUI Skia GPU small P95 30.30 ms；MoUI Skia GPU medium P95 31.26 ms；MoUI Skia GPU large P95 25.86 ms；MoUI Skia GPU stress P95 27.03 ms；MoUI WGPU small P95 20.91 ms；MoUI WGPU medium P95 22.39 ms；MoUI WGPU large P95 21.86 ms；MoUI WGPU stress P95 22.78 ms；MoMark Skia Raster large P95 18.51 ms；MoMark Skia Raster stress P95 32.41 ms；MoMark Skia GPU small P95 25.14 ms；MoMark Skia GPU medium P95 24.28 ms；MoMark Skia GPU large P95 22.95 ms；MoMark Skia GPU stress P95 25.17 ms；MoMark WGPU small P95 21.68 ms；MoMark WGPU medium P95 21.10 ms；MoMark WGPU large P95 23.40 ms；MoMark WGPU stress P95 38.16 ms；GpMark.mbt (GPUI) small P95 31.35 ms；GpMark.mbt (GPUI) medium P95 31.88 ms；GpMark.mbt (GPUI) large P95 31.63 ms；GpMark.mbt (GPUI) stress P95 32.38 ms。
- 长帧（超预算）：MoUI Skia GPU: small/input 14 次，max 30.78 ms, small/scroll 191 次，max 32.46 ms, medium/input 13 次，max 31.41 ms, medium/scroll 193 次，max 32.63 ms, large/input 12 次，max 30.30 ms, large/scroll 191 次，max 32.49 ms, stress/input 13 次，max 30.41 ms, stress/scroll 182 次，max 32.33 ms；MoUI WGPU: small/input 10 次，max 23.68 ms, small/scroll 179 次，max 31.33 ms, medium/input 11 次，max 33.80 ms, medium/scroll 178 次，max 25.43 ms, large/input 9 次，max 22.31 ms, large/scroll 176 次，max 27.28 ms, stress/input 10 次，max 31.78 ms, stress/scroll 179 次，max 30.79 ms；MoMark Skia Raster: small/input 1 次，max 18.64 ms, small/scroll 17 次，max 19.13 ms, medium/scroll 21 次，max 23.42 ms, large/input 5 次，max 18.61 ms, large/scroll 33 次，max 20.59 ms, stress/input 30 次，max 32.77 ms, stress/scroll 47 次，max 27.94 ms；MoMark Skia GPU: small/input 11 次，max 28.62 ms, small/scroll 178 次，max 31.50 ms, medium/input 12 次，max 30.51 ms, medium/scroll 179 次，max 30.49 ms, large/input 12 次，max 23.17 ms, large/scroll 178 次，max 31.40 ms, stress/input 30 次，max 25.38 ms, stress/scroll 178 次，max 26.42 ms；MoMark WGPU: small/input 24 次，max 26.44 ms, small/scroll 156 次，max 36.11 ms, medium/input 23 次，max 25.07 ms, medium/scroll 155 次，max 35.13 ms, large/input 29 次，max 24.07 ms, large/scroll 176 次，max 35.80 ms, stress/input 30 次，max 38.71 ms, stress/scroll 162 次，max 35.70 ms；GpMark.mbt (GPUI): small/input 30 次，max 32.40 ms, small/scroll 360 次，max 32.64 ms, medium/input 30 次，max 32.01 ms, medium/scroll 360 次，max 32.78 ms, large/input 30 次，max 31.68 ms, large/scroll 360 次，max 33.02 ms, stress/input 30 次，max 32.59 ms, stress/scroll 360 次，max 32.90 ms；Flutter Impeller: stress/scroll 1 次，max 41.67 ms；Electron: small/input 1 次，max 17.27 ms。
- 丢帧（优先处理）：MoUI Skia GPU: small/input 14 帧, small/scroll 191 帧, medium/input 13 帧, medium/scroll 193 帧, large/input 12 帧, large/scroll 191 帧, stress/input 13 帧, stress/scroll 184 帧；MoUI WGPU: small/input 10 帧, small/scroll 179 帧, medium/input 12 帧, medium/scroll 178 帧, large/input 9 帧, large/scroll 176 帧, stress/input 10 帧, stress/scroll 179 帧；MoMark Skia Raster: small/input 1 帧, small/scroll 22 帧, medium/input 1 帧, medium/scroll 22 帧, large/input 5 帧, large/scroll 36 帧, stress/input 30 帧, stress/scroll 52 帧；MoMark Skia GPU: small/input 11 帧, small/scroll 178 帧, medium/input 12 帧, medium/scroll 179 帧, large/input 12 帧, large/scroll 178 帧, stress/input 30 帧, stress/scroll 178 帧；MoMark WGPU: small/input 24 帧, small/scroll 176 帧, medium/input 23 帧, medium/scroll 169 帧, large/input 29 帧, large/scroll 190 帧, stress/input 50 帧, stress/scroll 173 帧；Flutter Impeller: stress/scroll 2 帧；Electron: small/input 1 帧, medium/scroll 1 帧。
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
