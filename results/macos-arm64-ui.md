# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-05T06:15:00Z`
- 数据状态：`360 measured`，`0 skipped/error`；原始样本保留在 JSON。
- 会话说明：`MoUI 示例编辑器`（`moui-md-*`）与 `GPUI (md_mbt)` 为本次重测（含示例编辑器 shell 解析、打开路径与滚动几何优化）；其余 adapter 沿用 `2026-09-04T17:14Z` 会话数据（记录级来源见 JSON 的 `merged_sessions`）。
- Host：`macOS-26.3-arm64-arm-64bit` / `arm64` / `16.0 GiB`；GPU：`Apple M4`
- OS：`25.3.0`；CPU：`arm`；toolchains：`python=3.12.11, moon=moon 0.1.20260824 (dae026a 2026-08-24), rustc=rustc 1.94.0 (4a4ef493e 2026-03-02), cargo=cargo 1.94.0 (85eff7c80 2026-01-15), node=v25.2.1, npm=11.6.2, flutter=Flutter 3.47.1 • channel stable • https://github.com/flutter/flutter.git`
- 统一配置：`1280x800 @ 60 Hz`；font `system-ui 16px`；line-height `1.55`；overscan `3`；fixed row `66px`；GPU backend `Metal`
- Fixture：`small=5KB/100 blocks`，`medium=50KB/1,000 blocks`，`large=500KB/10,000 blocks`，`stress=5MB/100,000 blocks`。
- 本次执行集合：`small, medium, large, stress`；未执行集合在矩阵中显示 `n/a`，不参与比较。
- 汇总口径：mean/P95 合并原始样本；每格 repetition `3`、process warm-up `1`；drop 为各 repetition dropped_display_frames 之和。
- 公平性口径：所有 ui-frame 记录使用相同 fixture、viewport、动作数、warm-up 和重复次数。`工作`（frame_work）统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏：MoUI 为 build+layout+paint+draw，Flutter 为 UI 线程 buildDuration，GPUI 为 request_layout→prepaint→paint，Electron 为 JS 可见的 DOM 更新+layout。设备光栅化与上屏统一单列为 `设备侧`（device_present）：MoUI 为同步光栅化/present 完成（无头 harness 逐帧同步，无流水线重叠），Flutter 为光栅线程 rasterDuration（不含设备完成等待），GPUI 与 Electron 无法在适配器侧观测显示链路，显示 `n/a`。MoUI ui-frame 是 headless host-surface；GPUI 的 action dispatch 另列为诊断字段。不同框架的显示时间戳由各自平台 API 提供，帧间隔覆盖完整链路，报告不做跨时钟的综合排名。`n/a` 表示没有采集，绝不等同于 0。

- `moui-md-*` 行来自 `vendor/MoUI/examples/markdown_editor` 官方示例应用：fixture 通过应用自身的 `OpenRecentDocument` 服务路径打开，渲染经过示例自己的虚拟滚动与富文本缓存实现，不套用简化基准应用的 `fixed row 66px` 统一行高；viewport、fixture、动作数、warm-up 与重复次数与其他行完全一致。严格模式（`UI_BENCHMARK_SYSTEM_TRACE=1`）目前不为 `moui-md-*` 行采集系统 present，这些行会显示 error。

<details><summary>原始 ui-frame 汇总（可审计）</summary>

| 实现 | 测试集合 | 场景 | 范围 | 工作均值/P95 | 仅分发均值/P95 | 帧间隔均值/P95 | 输入到可见均值/P95 | 设备侧均值 | 离屏均值 | 回读均值 | 首次可交互 | 丢帧数 | 状态 |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| moui-skia-raster | small | open | ui-frame | 71.804/91.423 | - | - | - | 7.78 ms | 0.00 ms | 7.78 ms | 80.85 ms | n/a | measured |
| moui-skia-raster | small | input | ui-frame | 0.705/1.557 | - | 5.101/8.066 | 5.100/8.064 | 4.18 ms | 0.00 ms | 4.18 ms | 63.18 ms | n/a | measured |
| moui-skia-raster | small | scroll | ui-frame | 2.574/6.576 | - | 9.234/16.617 | - | 5.63 ms | 0.00 ms | 5.63 ms | 98.95 ms | n/a | measured |
| moui-skia-raster | medium | open | ui-frame | 76.377/79.791 | - | - | - | 6.88 ms | 0.00 ms | 6.88 ms | 85.63 ms | n/a | measured |
| moui-skia-raster | medium | input | ui-frame | 1.321/2.424 | - | 9.373/16.322 | 9.372/16.321 | 7.57 ms | 0.00 ms | 7.57 ms | 188.11 ms | n/a | measured |
| moui-skia-raster | medium | scroll | ui-frame | 2.044/4.478 | - | 7.183/13.044 | - | 4.35 ms | 0.00 ms | 4.35 ms | 77.88 ms | n/a | measured |
| moui-skia-raster | large | open | ui-frame | 61.844/83.025 | - | - | - | 5.54 ms | 0.00 ms | 5.54 ms | 70.47 ms | n/a | measured |
| moui-skia-raster | large | input | ui-frame | 0.699/1.359 | - | 5.416/10.578 | 5.415/10.577 | 4.15 ms | 0.00 ms | 4.15 ms | 76.09 ms | n/a | measured |
| moui-skia-raster | large | scroll | ui-frame | 1.717/3.763 | - | 5.992/9.216 | - | 3.63 ms | 0.00 ms | 3.63 ms | 59.88 ms | n/a | measured |
| moui-skia-raster | stress | open | ui-frame | 47.266/47.713 | - | - | - | 5.13 ms | 0.00 ms | 5.13 ms | 71.87 ms | n/a | measured |
| moui-skia-raster | stress | input | ui-frame | 0.669/0.978 | - | 7.215/9.459 | 7.214/9.458 | 3.69 ms | 0.00 ms | 3.69 ms | 76.94 ms | n/a | measured |
| moui-skia-raster | stress | scroll | ui-frame | 2.004/4.337 | - | 7.249/10.628 | - | 4.44 ms | 0.00 ms | 4.44 ms | 80.16 ms | n/a | measured |
| moui-skia-gpu | small | open | ui-frame | 51.513/53.068 | - | - | - | 14.65 ms | n/a | 0.00 ms | 67.38 ms | n/a | measured |
| moui-skia-gpu | small | input | ui-frame | 0.687/1.091 | - | 8.376/9.372 | 8.375/9.372 | 7.45 ms | n/a | 0.00 ms | 64.25 ms | n/a | measured |
| moui-skia-gpu | small | scroll | ui-frame | 1.817/3.859 | - | 8.559/9.468 | - | 6.02 ms | n/a | 0.00 ms | 67.12 ms | n/a | measured |
| moui-skia-gpu | medium | open | ui-frame | 49.060/49.880 | - | - | - | 13.38 ms | n/a | 0.00 ms | 64.05 ms | n/a | measured |
| moui-skia-gpu | medium | input | ui-frame | 0.625/0.779 | - | 8.322/9.324 | 8.320/9.322 | 7.46 ms | n/a | 0.00 ms | 61.52 ms | n/a | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 1.680/3.686 | - | 8.428/9.253 | - | 6.11 ms | n/a | 0.00 ms | 63.11 ms | n/a | measured |
| moui-skia-gpu | large | open | ui-frame | 46.768/48.986 | - | - | - | 13.37 ms | n/a | 0.00 ms | 63.16 ms | n/a | measured |
| moui-skia-gpu | large | input | ui-frame | 0.591/0.706 | - | 8.571/9.467 | 8.571/9.466 | 7.59 ms | n/a | 0.00 ms | 75.13 ms | n/a | measured |
| moui-skia-gpu | large | scroll | ui-frame | 1.792/3.807 | - | 8.583/9.464 | - | 6.07 ms | n/a | 0.00 ms | 90.75 ms | n/a | measured |
| moui-skia-gpu | stress | open | ui-frame | 46.400/47.685 | - | - | - | 12.14 ms | n/a | 0.00 ms | 78.33 ms | n/a | measured |
| moui-skia-gpu | stress | input | ui-frame | 0.650/0.723 | - | 8.396/9.329 | 8.395/9.328 | 5.18 ms | n/a | 0.00 ms | 79.09 ms | n/a | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 1.967/4.173 | - | 8.796/10.797 | - | 6.07 ms | n/a | 0.00 ms | 88.56 ms | n/a | measured |
| moui-wgpu | small | open | ui-frame | 51.966/58.125 | - | - | - | 10.77 ms | n/a | 0.00 ms | 64.07 ms | n/a | measured |
| moui-wgpu | small | input | ui-frame | 0.624/0.788 | - | 8.231/9.273 | 8.231/9.273 | 7.37 ms | n/a | 0.00 ms | 63.60 ms | n/a | measured |
| moui-wgpu | small | scroll | ui-frame | 1.953/3.543 | - | 8.328/9.322 | - | 5.65 ms | n/a | 0.00 ms | 60.23 ms | n/a | measured |
| moui-wgpu | medium | open | ui-frame | 53.016/54.170 | - | - | - | 12.17 ms | n/a | 0.00 ms | 67.14 ms | n/a | measured |
| moui-wgpu | medium | input | ui-frame | 0.641/0.768 | - | 8.210/9.219 | 8.209/9.218 | 7.30 ms | n/a | 0.00 ms | 64.18 ms | n/a | measured |
| moui-wgpu | medium | scroll | ui-frame | 1.937/3.389 | - | 8.328/9.261 | - | 5.67 ms | n/a | 0.00 ms | 63.16 ms | n/a | measured |
| moui-wgpu | large | open | ui-frame | 47.411/48.141 | - | - | - | 10.46 ms | n/a | 0.00 ms | 60.94 ms | n/a | measured |
| moui-wgpu | large | input | ui-frame | 0.607/0.735 | - | 8.146/9.328 | 8.145/9.327 | 7.12 ms | n/a | 0.00 ms | 62.33 ms | n/a | measured |
| moui-wgpu | large | scroll | ui-frame | 2.024/3.967 | - | 8.346/9.486 | - | 5.55 ms | n/a | 0.00 ms | 83.24 ms | n/a | measured |
| moui-wgpu | stress | open | ui-frame | 51.704/52.383 | - | - | - | 11.61 ms | n/a | 0.00 ms | 84.02 ms | n/a | measured |
| moui-wgpu | stress | input | ui-frame | 0.773/1.322 | - | 8.336/9.428 | 8.335/9.428 | 4.30 ms | n/a | 0.00 ms | 84.52 ms | n/a | measured |
| moui-wgpu | stress | scroll | ui-frame | 1.905/3.545 | - | 8.339/9.379 | - | 5.70 ms | n/a | 0.00 ms | 86.90 ms | n/a | measured |
| moui-md-skia-raster | small | open | ui-frame | 55.985/64.488 | - | - | - | 13.48 ms | 0.00 ms | 13.48 ms | 71.47 ms | n/a | measured |
| moui-md-skia-raster | small | input | ui-frame | 5.373/17.588 | - | 9.820/31.584 | 9.776/30.752 | 3.80 ms | 0.00 ms | 3.80 ms | 68.78 ms | n/a | measured |
| moui-md-skia-raster | small | scroll | ui-frame | 1.055/1.383 | - | 3.697/4.450 | - | 2.44 ms | 0.00 ms | 2.44 ms | 70.25 ms | n/a | measured |
| moui-md-skia-raster | medium | open | ui-frame | 54.923/55.517 | - | - | - | 13.54 ms | 0.00 ms | 13.54 ms | 71.99 ms | n/a | measured |
| moui-md-skia-raster | medium | input | ui-frame | 3.794/4.103 | - | 8.460/8.996 | 8.431/8.995 | 2.86 ms | 0.00 ms | 2.86 ms | 71.45 ms | n/a | measured |
| moui-md-skia-raster | medium | scroll | ui-frame | 1.081/1.502 | - | 3.809/5.103 | - | 2.50 ms | 0.00 ms | 2.50 ms | 70.19 ms | n/a | measured |
| moui-md-skia-raster | large | open | ui-frame | 55.846/57.262 | - | - | - | 13.11 ms | 0.00 ms | 13.11 ms | 86.50 ms | n/a | measured |
| moui-md-skia-raster | large | input | ui-frame | 4.808/5.200 | - | 22.989/24.180 | 22.963/24.180 | 2.89 ms | 0.00 ms | 2.89 ms | 88.96 ms | n/a | measured |
| moui-md-skia-raster | large | scroll | ui-frame | 1.038/1.280 | - | 3.876/4.747 | - | 2.43 ms | 0.00 ms | 2.43 ms | 94.07 ms | n/a | measured |
| moui-md-skia-raster | stress | open | ui-frame | 63.828/64.729 | - | - | - | 12.79 ms | 0.00 ms | 12.79 ms | 243.04 ms | n/a | measured |
| moui-md-skia-raster | stress | input | ui-frame | 12.836/14.045 | - | 181.858/197.546 | 181.830/197.545 | 3.08 ms | 0.00 ms | 3.08 ms | 248.57 ms | n/a | measured |
| moui-md-skia-raster | stress | scroll | ui-frame | 1.098/1.367 | - | 6.301/7.536 | - | 2.49 ms | 0.00 ms | 2.49 ms | 242.59 ms | n/a | measured |
| moui-md-skia-gpu | small | open | ui-frame | 60.622/65.984 | - | - | - | 60.59 ms | n/a | 0.00 ms | 123.10 ms | n/a | measured |
| moui-md-skia-gpu | small | input | ui-frame | 3.655/3.917 | - | 9.947/10.621 | 9.921/10.620 | 5.85 ms | n/a | 0.00 ms | 121.15 ms | n/a | measured |
| moui-md-skia-gpu | small | scroll | ui-frame | 1.219/1.707 | - | 8.678/9.955 | - | 7.20 ms | n/a | 0.00 ms | 126.70 ms | n/a | measured |
| moui-md-skia-gpu | medium | open | ui-frame | 48.875/50.242 | - | - | - | 29.01 ms | n/a | 0.00 ms | 80.96 ms | n/a | measured |
| moui-md-skia-gpu | medium | input | ui-frame | 3.879/4.522 | - | 9.883/10.667 | 9.857/10.665 | 4.25 ms | n/a | 0.00 ms | 130.27 ms | n/a | measured |
| moui-md-skia-gpu | medium | scroll | ui-frame | 1.196/1.657 | - | 8.606/9.715 | - | 7.14 ms | n/a | 0.00 ms | 120.17 ms | n/a | measured |
| moui-md-skia-gpu | large | open | ui-frame | 53.171/53.772 | - | - | - | 62.34 ms | n/a | 0.00 ms | 133.74 ms | n/a | measured |
| moui-md-skia-gpu | large | input | ui-frame | 5.350/6.518 | - | 29.680/37.099 | 29.651/37.098 | 8.27 ms | n/a | 0.00 ms | 133.72 ms | n/a | measured |
| moui-md-skia-gpu | large | scroll | ui-frame | 1.168/1.556 | - | 8.690/9.989 | - | 6.99 ms | n/a | 0.00 ms | 137.02 ms | n/a | measured |
| moui-md-skia-gpu | stress | open | ui-frame | 61.509/63.577 | - | - | - | 64.60 ms | n/a | 0.00 ms | 290.95 ms | n/a | measured |
| moui-md-skia-gpu | stress | input | ui-frame | 13.074/14.593 | - | 184.416/200.675 | 184.388/200.674 | 6.45 ms | n/a | 0.00 ms | 286.18 ms | n/a | measured |
| moui-md-skia-gpu | stress | scroll | ui-frame | 1.240/1.612 | - | 10.245/10.879 | - | 6.50 ms | n/a | 0.00 ms | 293.36 ms | n/a | measured |
| moui-md-wgpu | small | open | ui-frame | 45.877/53.558 | - | - | - | 16.72 ms | n/a | 0.00 ms | 64.52 ms | n/a | measured |
| moui-md-wgpu | small | input | ui-frame | 1.648/2.132 | - | 8.094/9.669 | 8.061/9.544 | 5.92 ms | n/a | 0.00 ms | 64.27 ms | n/a | measured |
| moui-md-wgpu | small | scroll | ui-frame | 1.466/1.943 | - | 22.036/32.814 | - | 20.25 ms | n/a | 0.00 ms | 69.68 ms | n/a | measured |
| moui-md-wgpu | medium | open | ui-frame | 52.874/55.709 | - | - | - | 17.69 ms | n/a | 0.00 ms | 74.16 ms | n/a | measured |
| moui-md-wgpu | medium | input | ui-frame | 1.736/2.120 | - | 18.828/46.221 | 18.791/46.220 | 15.13 ms | n/a | 0.00 ms | 69.06 ms | n/a | measured |
| moui-md-wgpu | medium | scroll | ui-frame | 1.419/1.710 | - | 8.453/9.423 | - | 6.78 ms | n/a | 0.00 ms | 56.48 ms | n/a | measured |
| moui-md-wgpu | large | open | ui-frame | 42.571/42.955 | - | - | - | 13.49 ms | n/a | 0.00 ms | 72.74 ms | n/a | measured |
| moui-md-wgpu | large | input | ui-frame | 2.189/2.424 | - | 18.509/19.564 | 18.485/19.564 | 2.05 ms | n/a | 0.00 ms | 71.66 ms | n/a | measured |
| moui-md-wgpu | large | scroll | ui-frame | 1.325/1.648 | - | 8.304/9.375 | - | 6.60 ms | n/a | 0.00 ms | 70.25 ms | n/a | measured |
| moui-md-wgpu | stress | open | ui-frame | 48.279/50.011 | - | - | - | 12.68 ms | n/a | 0.00 ms | 214.20 ms | n/a | measured |
| moui-md-wgpu | stress | input | ui-frame | 9.546/10.074 | - | 160.909/168.033 | 160.881/168.032 | 2.10 ms | n/a | 0.00 ms | 222.73 ms | n/a | measured |
| moui-md-wgpu | stress | scroll | ui-frame | 1.365/1.657 | - | 8.333/9.053 | - | 4.43 ms | n/a | 0.00 ms | 220.10 ms | n/a | measured |
| gpui | small | open | ui-frame | 6.671/6.847 | - | - | - | n/a | n/a | n/a | 114.22 ms | n/a | measured |
| gpui | small | input | ui-frame | 6.406/6.806 | 0.343/0.373 | 9.859/12.742 | 9.858/12.741 | n/a | n/a | n/a | 109.75 ms | n/a | measured |
| gpui | small | scroll | ui-frame | 7.440/9.418 | 0.001/0.003 | 10.034/11.291 | - | n/a | n/a | n/a | 112.28 ms | n/a | measured |
| gpui | medium | open | ui-frame | 6.761/6.824 | - | - | - | n/a | n/a | n/a | 107.19 ms | n/a | measured |
| gpui | medium | input | ui-frame | 6.426/6.812 | 0.378/0.418 | 9.544/12.750 | 9.542/12.748 | n/a | n/a | n/a | 115.52 ms | n/a | measured |
| gpui | medium | scroll | ui-frame | 7.446/9.363 | 0.002/0.003 | 10.073/11.266 | - | n/a | n/a | n/a | 110.66 ms | n/a | measured |
| gpui | large | open | ui-frame | 6.562/6.612 | - | - | - | n/a | n/a | n/a | 113.55 ms | n/a | measured |
| gpui | large | input | ui-frame | 6.414/6.782 | 0.719/0.824 | 9.921/14.694 | 9.919/14.692 | n/a | n/a | n/a | 116.37 ms | n/a | measured |
| gpui | large | scroll | ui-frame | 7.417/9.326 | 0.001/0.003 | 10.042/11.201 | - | n/a | n/a | n/a | 117.42 ms | n/a | measured |
| gpui | stress | open | ui-frame | 6.883/7.027 | - | - | - | n/a | n/a | n/a | 136.55 ms | n/a | measured |
| gpui | stress | input | ui-frame | 6.574/6.820 | 4.490/5.080 | 12.620/16.245 | 12.618/16.243 | n/a | n/a | n/a | 142.19 ms | n/a | measured |
| gpui | stress | scroll | ui-frame | 7.429/9.461 | 0.001/0.003 | 10.038/11.241 | - | n/a | n/a | n/a | 126.58 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 0.386/0.511 | - | - | - | 13.38 ms | n/a | n/a | 65.99 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 0.542/0.661 | - | 10.000/10.004 | 10.057/16.733 | 0.53 ms | n/a | n/a | 66.14 ms | 0 | measured |
| flutter-skia | small | scroll | ui-frame | 1.997/3.573 | - | 10.000/10.004 | - | 0.48 ms | n/a | n/a | 64.75 ms | 0 | measured |
| flutter-skia | medium | open | ui-frame | 0.324/0.364 | - | - | - | 8.88 ms | n/a | n/a | 60.52 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 0.519/0.685 | - | 9.667/10.006 | 10.019/17.901 | 0.59 ms | n/a | n/a | 63.31 ms | 0 | measured |
| flutter-skia | medium | scroll | ui-frame | 2.267/3.986 | - | 10.028/10.001 | - | 0.44 ms | n/a | n/a | 62.20 ms | 1 | measured |
| flutter-skia | large | open | ui-frame | 0.290/0.318 | - | - | - | 8.61 ms | n/a | n/a | 63.00 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 0.519/0.624 | - | 9.000/10.003 | 10.631/15.100 | 0.65 ms | n/a | n/a | 64.47 ms | 0 | measured |
| flutter-skia | large | scroll | ui-frame | 2.274/4.032 | - | 9.972/10.001 | - | 0.44 ms | n/a | n/a | 63.74 ms | 0 | measured |
| flutter-skia | stress | open | ui-frame | 0.339/0.419 | - | - | - | 8.76 ms | n/a | n/a | 93.42 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 0.518/0.633 | - | 10.000/10.004 | 9.978/11.890 | 0.54 ms | n/a | n/a | 91.68 ms | 0 | measured |
| flutter-skia | stress | scroll | ui-frame | 2.263/4.001 | - | 10.000/10.001 | - | 0.45 ms | n/a | n/a | 92.31 ms | 1 | measured |
| flutter-impeller | small | open | ui-frame | 0.369/0.411 | - | - | - | 6.59 ms | n/a | n/a | 61.31 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 0.538/0.653 | - | 9.667/10.004 | 10.352/15.990 | 0.60 ms | n/a | n/a | 60.96 ms | 0 | measured |
| flutter-impeller | small | scroll | ui-frame | 1.980/3.570 | - | 10.000/10.004 | - | 0.49 ms | n/a | n/a | 61.70 ms | 0 | measured |
| flutter-impeller | medium | open | ui-frame | 0.343/0.399 | - | - | - | 6.66 ms | n/a | n/a | 60.53 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 0.548/0.722 | - | 9.000/10.006 | 10.501/16.522 | 0.70 ms | n/a | n/a | 62.17 ms | 0 | measured |
| flutter-impeller | medium | scroll | ui-frame | 2.058/3.682 | - | 10.195/10.001 | - | 0.42 ms | n/a | n/a | 61.38 ms | 6 | measured |
| flutter-impeller | large | open | ui-frame | 0.336/0.352 | - | - | - | 6.78 ms | n/a | n/a | 61.44 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 0.548/0.684 | - | 9.000/10.003 | 10.700/15.404 | 0.68 ms | n/a | n/a | 63.72 ms | 0 | measured |
| flutter-impeller | large | scroll | ui-frame | 2.279/3.965 | - | 10.028/10.001 | - | 0.44 ms | n/a | n/a | 60.06 ms | 2 | measured |
| flutter-impeller | stress | open | ui-frame | 0.283/0.297 | - | - | - | 7.33 ms | n/a | n/a | 87.20 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 0.506/0.648 | - | 10.000/10.002 | 10.364/15.943 | 0.56 ms | n/a | n/a | 88.77 ms | 1 | measured |
| flutter-impeller | stress | scroll | ui-frame | 2.122/3.741 | - | 10.056/10.001 | - | 0.44 ms | n/a | n/a | 87.79 ms | 1 | measured |
| electron | small | open | ui-frame | 11.700/14.100 | - | - | - | n/a | n/a | n/a | 11.70 ms | 0 | measured |
| electron | small | input | ui-frame | 1.543/2.800 | - | 9.304/10.700 | 8.460/10.700 | n/a | n/a | n/a | 13.77 ms | 0 | measured |
| electron | small | scroll | ui-frame | 1.741/2.400 | - | 9.984/10.900 | - | n/a | n/a | n/a | 11.90 ms | 0 | measured |
| electron | medium | open | ui-frame | 11.933/14.000 | - | - | - | n/a | n/a | n/a | 11.93 ms | 0 | measured |
| electron | medium | input | ui-frame | 1.560/3.100 | - | 9.334/10.900 | 8.560/10.100 | n/a | n/a | n/a | 8.10 ms | 0 | measured |
| electron | medium | scroll | ui-frame | 1.809/2.500 | - | 9.905/10.900 | - | n/a | n/a | n/a | 12.40 ms | 0 | measured |
| electron | large | open | ui-frame | 11.400/15.400 | - | - | - | n/a | n/a | n/a | 11.40 ms | 0 | measured |
| electron | large | input | ui-frame | 1.430/2.500 | - | 9.664/10.800 | 8.853/10.300 | n/a | n/a | n/a | 9.43 ms | 1 | measured |
| electron | large | scroll | ui-frame | 1.834/2.400 | - | 9.980/10.300 | - | n/a | n/a | n/a | 13.93 ms | 0 | measured |
| electron | stress | open | ui-frame | 17.000/17.200 | - | - | - | n/a | n/a | n/a | 17.00 ms | 0 | measured |
| electron | stress | input | ui-frame | 1.380/1.900 | - | 9.775/10.100 | 8.657/10.100 | n/a | n/a | n/a | 19.37 ms | 0 | measured |
| electron | stress | scroll | ui-frame | 1.853/2.500 | - | 9.973/10.600 | - | n/a | n/a | n/a | 24.70 ms | 0 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.57/2.04/1.72 | 6.58/4.48/3.76 | 5.63/4.35/3.63 | 9.72/7.62/4.60 | 9.23/7.18/5.99 | 16.62/13.04/9.22 | n/a/n/a/n/a |
| MoUI Skia GPU | 1.82/1.68/1.79 | 3.86/3.69/3.81 | 6.02/6.11/6.07 | 7.89/7.77/7.86 | 8.56/8.43/8.58 | 9.47/9.25/9.46 | n/a/n/a/n/a |
| MoUI WGPU | 1.95/1.94/2.02 | 3.54/3.39/3.97 | 5.65/5.67/5.55 | 8.12/8.02/8.22 | 8.33/8.33/8.35 | 9.32/9.26/9.49 | n/a/n/a/n/a |
| MoUI 示例编辑器 Skia Raster | 1.06/1.08/1.04 | 1.38/1.50/1.28 | 2.44/2.50/2.43 | 2.98/3.45/3.02 | 3.70/3.81/3.88 | 4.45/5.10/4.75 | n/a/n/a/n/a |
| MoUI 示例编辑器 Skia GPU | 1.22/1.20/1.17 | 1.71/1.66/1.56 | 7.20/7.14/6.99 | 8.38/8.24/8.19 | 8.68/8.61/8.69 | 9.95/9.72/9.99 | n/a/n/a/n/a |
| MoUI 示例编辑器 WGPU | 1.47/1.42/1.33 | 1.94/1.71/1.65 | 20.25/6.78/6.60 | 30.90/7.66/7.50 | 22.04/8.45/8.30 | 32.81/9.42/9.38 | n/a/n/a/n/a |
| GPUI (md_mbt) | 7.44/7.45/7.42 | 9.42/9.36/9.33 | n/a/n/a/n/a | n/a/n/a/n/a | 10.03/10.07/10.04 | 11.29/11.27/11.20 | n/a/n/a/n/a |
| Flutter Skia | 2.00/2.27/2.27 | 3.57/3.99/4.03 | 0.48/0.44/0.44 | 1.04/0.68/0.66 | 10.00/10.03/9.97 | 10.00/10.00/10.00 | 0/1/0 |
| Flutter Impeller | 1.98/2.06/2.28 | 3.57/3.68/3.96 | 0.49/0.42/0.44 | 0.96/0.73/0.66 | 10.00/10.19/10.03 | 10.00/10.00/10.00 | 0/6/2 |
| Electron | 1.74/1.81/1.83 | 2.40/2.50/2.40 | n/a/n/a/n/a | n/a/n/a/n/a | 9.98/9.91/9.98 | 10.90/10.90/10.30 | 0/0/0 |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.00 | 4.34 | 4.44 | 5.48 | 7.25 | 10.63 | n/a |
| MoUI Skia GPU | 1.97 | 4.17 | 6.07 | 7.81 | 8.80 | 10.80 | n/a |
| MoUI WGPU | 1.90 | 3.54 | 5.70 | 7.94 | 8.34 | 9.38 | n/a |
| MoUI 示例编辑器 Skia Raster | 1.10 | 1.37 | 2.49 | 3.06 | 6.30 | 7.54 | n/a |
| MoUI 示例编辑器 Skia GPU | 1.24 | 1.61 | 6.50 | 7.35 | 10.24 | 10.88 | n/a |
| MoUI 示例编辑器 WGPU | 1.36 | 1.66 | 4.43 | 4.97 | 8.33 | 9.05 | n/a |
| GPUI (md_mbt) | 7.43 | 9.46 | n/a | n/a | 10.04 | 11.24 | n/a |
| Flutter Skia | 2.26 | 4.00 | 0.45 | 0.74 | 10.00 | 10.00 | 1 |
| Flutter Impeller | 2.12 | 3.74 | 0.44 | 0.72 | 10.06 | 10.00 | 1 |
| Electron | 1.85 | 2.50 | n/a | n/a | 9.97 | 10.60 | 0 |

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 5.10/9.37/5.41 | 8.06/16.32/10.58 | 0.70/1.32/0.70 | 1.56/2.42/1.36 | 4.18/7.57/4.15 | 6.05/13.52/8.66 |
| MoUI Skia GPU | 8.37/8.32/8.57 | 9.37/9.32/9.47 | 0.69/0.62/0.59 | 1.09/0.78/0.71 | 7.45/7.46/7.59 | 8.51/8.47/8.42 |
| MoUI WGPU | 8.23/8.21/8.15 | 9.27/9.22/9.33 | 0.62/0.64/0.61 | 0.79/0.77/0.74 | 7.37/7.30/7.12 | 8.48/8.41/8.34 |
| MoUI 示例编辑器 Skia Raster | 9.78/8.43/22.96 | 30.75/8.99/24.18 | 5.37/3.79/4.81 | 17.59/4.10/5.20 | 3.80/2.86/2.89 | 11.95/3.20/3.29 |
| MoUI 示例编辑器 Skia GPU | 9.92/9.86/29.65 | 10.62/10.66/37.10 | 3.66/3.88/5.35 | 3.92/4.52/6.52 | 5.85/4.25/8.27 | 6.51/5.06/10.18 |
| MoUI 示例编辑器 WGPU | 8.06/18.79/18.49 | 9.54/46.22/19.56 | 1.65/1.74/2.19 | 2.13/2.12/2.42 | 5.92/15.13/2.05 | 7.21/42.14/2.61 |
| GPUI (md_mbt) | 9.86/9.54/9.92 | 12.74/12.75/14.69 | 6.41/6.43/6.41 | 6.81/6.81/6.78 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 10.06/10.02/10.63 | 16.73/17.90/15.10 | 0.54/0.52/0.52 | 0.66/0.69/0.62 | 0.53/0.59/0.65 | 0.99/1.08/1.36 |
| Flutter Impeller | 10.35/10.50/10.70 | 15.99/16.52/15.40 | 0.54/0.55/0.55 | 0.65/0.72/0.68 | 0.60/0.70/0.68 | 1.18/1.53/1.57 |
| Electron | 8.46/8.56/8.85 | 10.70/10.10/10.30 | 1.54/1.56/1.43 | 2.80/3.10/2.50 | n/a/n/a/n/a | n/a/n/a/n/a |

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 7.21 | 9.46 | 0.67 | 0.98 | 3.69 | 4.66 |
| MoUI Skia GPU | 8.40 | 9.33 | 0.65 | 0.72 | 5.18 | 6.26 |
| MoUI WGPU | 8.33 | 9.43 | 0.77 | 1.32 | 4.30 | 6.22 |
| MoUI 示例编辑器 Skia Raster | 181.83 | 197.54 | 12.84 | 14.04 | 3.08 | 3.46 |
| MoUI 示例编辑器 Skia GPU | 184.39 | 200.67 | 13.07 | 14.59 | 6.45 | 9.73 |
| MoUI 示例编辑器 WGPU | 160.88 | 168.03 | 9.55 | 10.07 | 2.10 | 2.60 |
| GPUI (md_mbt) | 12.62 | 16.24 | 6.57 | 6.82 | n/a | n/a |
| Flutter Skia | 9.98 | 11.89 | 0.52 | 0.63 | 0.54 | 1.14 |
| Flutter Impeller | 10.36 | 15.94 | 0.51 | 0.65 | 0.56 | 1.10 |
| Electron | 8.66 | 10.10 | 1.38 | 1.90 | n/a | n/a |

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 80.85/85.63/70.47 | 103.90/88.27/92.09 | 71.80/76.38/61.84 | 91.42/79.79/83.02 | 7.78/6.88/5.54 | 11.08/7.09/6.13 | 0.07/0.47/2.55 | 0.08/0.56/2.76 |
| MoUI Skia GPU | 67.38/64.05/63.16 | 70.18/65.65/68.11 | 51.51/49.06/46.77 | 53.07/49.88/48.99 | 14.65/13.38/13.37 | 15.89/14.24/16.01 | 0.10/0.30/2.49 | 0.12/0.31/2.53 |
| MoUI WGPU | 64.07/67.14/60.94 | 70.23/68.08/61.94 | 51.97/53.02/47.41 | 58.13/54.17/48.14 | 10.77/12.17/10.46 | 10.84/12.58/10.68 | 0.07/0.29/2.13 | 0.08/0.31/2.58 |
| MoUI 示例编辑器 Skia Raster | 71.47/71.99/86.50 | 81.05/73.00/88.56 | 55.98/54.92/55.85 | 64.49/55.52/57.26 | 13.48/13.54/13.11 | 14.62/13.74/13.19 | 0.09/0.32/2.29 | 0.15/0.35/2.66 |
| MoUI 示例编辑器 Skia GPU | 123.10/80.96/133.74 | 137.98/83.68/139.70 | 60.62/48.88/53.17 | 65.98/50.24/53.77 | 60.59/29.01/62.34 | 70.15/30.28/67.28 | 0.09/0.20/2.45 | 0.11/0.20/2.72 |
| MoUI 示例编辑器 WGPU | 64.52/74.16/72.74 | 72.86/78.11/74.49 | 45.88/52.87/42.57 | 53.56/55.71/42.96 | 16.72/17.69/13.49 | 17.45/18.87/13.59 | 0.10/0.33/2.17 | 0.14/0.38/2.58 |
| GPUI (md_mbt) | 114.22/107.19/113.55 | 120.46/108.95/116.64 | 6.67/6.76/6.56 | 6.85/6.82/6.61 | n/a/n/a/n/a | n/a/n/a/n/a | 0.33/0.00/2.33 | 1.00/0.00/3.00 |
| Flutter Skia | 65.99/60.52/63.00 | 67.79/61.95/66.34 | 0.39/0.32/0.29 | 0.51/0.36/0.32 | 13.38/8.88/8.61 | 18.58/9.18/8.78 | 0.14/0.14/0.38 | 0.17/0.16/0.41 |
| Flutter Impeller | 61.31/60.53/61.44 | 64.47/63.78/63.46 | 0.37/0.34/0.34 | 0.41/0.40/0.35 | 6.59/6.66/6.78 | 6.65/6.86/6.98 | 0.11/0.13/0.43 | 0.11/0.17/0.54 |
| Electron | 11.70/11.93/11.40 | 14.10/14.00/15.40 | 11.70/11.93/11.40 | 14.10/14.00/15.40 | n/a/n/a/n/a | n/a/n/a/n/a | 2.35/2.34/2.69 | 2.88/2.82/4.58 |

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 71.87 | 72.37 | 47.27 | 47.71 | 5.13 | 5.39 | 24.31 | 26.59 |
| MoUI Skia GPU | 78.33 | 80.43 | 46.40 | 47.68 | 12.14 | 12.68 | 26.58 | 27.24 |
| MoUI WGPU | 84.02 | 85.75 | 51.70 | 52.38 | 11.61 | 11.69 | 22.15 | 24.91 |
| MoUI 示例编辑器 Skia Raster | 243.04 | 243.61 | 63.83 | 64.73 | 12.79 | 13.05 | 26.75 | 28.59 |
| MoUI 示例编辑器 Skia GPU | 290.95 | 301.48 | 61.51 | 63.58 | 64.60 | 69.55 | 24.26 | 26.30 |
| MoUI 示例编辑器 WGPU | 214.20 | 217.78 | 48.28 | 50.01 | 12.68 | 12.90 | 24.58 | 25.47 |
| GPUI (md_mbt) | 136.55 | 139.41 | 6.88 | 7.03 | n/a | n/a | 25.67 | 26.00 |
| Flutter Skia | 93.42 | 94.37 | 0.34 | 0.42 | 8.76 | 8.96 | 3.08 | 3.37 |
| Flutter Impeller | 87.20 | 90.31 | 0.28 | 0.30 | 7.33 | 8.77 | 3.06 | 3.27 |
| Electron | 17.00 | 17.20 | 17.00 | 17.20 | n/a | n/a | 5.07 | 5.38 |

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.57/2.04/1.72 | 6.58/4.48/3.76 | 5.63/4.35/3.63 | 9.72/7.62/4.60 | 9.23/7.18/5.99 | 16.62/13.04/9.22 | n/a/n/a/n/a |
| MoUI Skia GPU | 1.82/1.68/1.79 | 3.86/3.69/3.81 | 6.02/6.11/6.07 | 7.89/7.77/7.86 | 8.56/8.43/8.58 | 9.47/9.25/9.46 | n/a/n/a/n/a |
| MoUI WGPU | 1.95/1.94/2.02 | 3.54/3.39/3.97 | 5.65/5.67/5.55 | 8.12/8.02/8.22 | 8.33/8.33/8.35 | 9.32/9.26/9.49 | n/a/n/a/n/a |
| MoUI 示例编辑器 Skia Raster | 1.06/1.08/1.04 | 1.38/1.50/1.28 | 2.44/2.50/2.43 | 2.98/3.45/3.02 | 3.70/3.81/3.88 | 4.45/5.10/4.75 | n/a/n/a/n/a |
| MoUI 示例编辑器 Skia GPU | 1.22/1.20/1.17 | 1.71/1.66/1.56 | 7.20/7.14/6.99 | 8.38/8.24/8.19 | 8.68/8.61/8.69 | 9.95/9.72/9.99 | n/a/n/a/n/a |
| MoUI 示例编辑器 WGPU | 1.47/1.42/1.33 | 1.94/1.71/1.65 | 20.25/6.78/6.60 | 30.90/7.66/7.50 | 22.04/8.45/8.30 | 32.81/9.42/9.38 | n/a/n/a/n/a |
| GPUI (md_mbt) | 7.44/7.45/7.42 | 9.42/9.36/9.33 | n/a/n/a/n/a | n/a/n/a/n/a | 10.03/10.07/10.04 | 11.29/11.27/11.20 | n/a/n/a/n/a |
| Flutter Skia | 2.00/2.27/2.27 | 3.57/3.99/4.03 | 0.48/0.44/0.44 | 1.04/0.68/0.66 | 10.00/10.03/9.97 | 10.00/10.00/10.00 | 0/1/0 |
| Flutter Impeller | 1.98/2.06/2.28 | 3.57/3.68/3.96 | 0.49/0.42/0.44 | 0.96/0.73/0.66 | 10.00/10.19/10.03 | 10.00/10.00/10.00 | 0/6/2 |
| Electron | 1.74/1.81/1.83 | 2.40/2.50/2.40 | n/a/n/a/n/a | n/a/n/a/n/a | 9.98/9.91/9.98 | 10.90/10.90/10.30 | 0/0/0 |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 设备侧均值（ms） | 设备侧 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 2.00 | 4.34 | 4.44 | 5.48 | 7.25 | 10.63 | n/a |
| MoUI Skia GPU | 1.97 | 4.17 | 6.07 | 7.81 | 8.80 | 10.80 | n/a |
| MoUI WGPU | 1.90 | 3.54 | 5.70 | 7.94 | 8.34 | 9.38 | n/a |
| MoUI 示例编辑器 Skia Raster | 1.10 | 1.37 | 2.49 | 3.06 | 6.30 | 7.54 | n/a |
| MoUI 示例编辑器 Skia GPU | 1.24 | 1.61 | 6.50 | 7.35 | 10.24 | 10.88 | n/a |
| MoUI 示例编辑器 WGPU | 1.36 | 1.66 | 4.43 | 4.97 | 8.33 | 9.05 | n/a |
| GPUI (md_mbt) | 7.43 | 9.46 | n/a | n/a | 10.04 | 11.24 | n/a |
| Flutter Skia | 2.26 | 4.00 | 0.45 | 0.74 | 10.00 | 10.00 | 1 |
| Flutter Impeller | 2.12 | 3.74 | 0.44 | 0.72 | 10.06 | 10.00 | 1 |
| Electron | 1.85 | 2.50 | n/a | n/a | 9.97 | 10.60 | 0 |

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoUI Skia Raster CPU small 80.9 ms（max 103.9 ms）；MoUI 示例编辑器 Skia Raster stress 243.0 ms（max 243.6 ms）；MoUI 示例编辑器 Skia GPU small 123.1 ms（max 138.0 ms）；MoUI 示例编辑器 Skia GPU large 133.7 ms（max 139.7 ms）；MoUI 示例编辑器 Skia GPU stress 291.0 ms（max 301.5 ms）；MoUI 示例编辑器 WGPU stress 214.2 ms（max 217.8 ms）；GPUI (md_mbt) small 114.2 ms（max 120.5 ms）；GPUI (md_mbt) medium 107.2 ms（max 109.0 ms）；GPUI (md_mbt) large 113.6 ms（max 116.6 ms）；GPUI (md_mbt) stress 136.6 ms（max 139.4 ms）。
- P1 输入尾延迟：MoUI 示例编辑器 Skia Raster small P95 30.75 ms；MoUI 示例编辑器 Skia Raster large P95 24.18 ms；MoUI 示例编辑器 Skia Raster stress P95 197.54 ms；MoUI 示例编辑器 Skia GPU large P95 37.10 ms；MoUI 示例编辑器 Skia GPU stress P95 200.67 ms；MoUI 示例编辑器 WGPU medium P95 46.22 ms；MoUI 示例编辑器 WGPU large P95 19.56 ms；MoUI 示例编辑器 WGPU stress P95 168.03 ms；Flutter Skia medium P95 17.90 ms。
- 长帧（超预算）：MoUI Skia Raster CPU: small/scroll 18 次，max 24.37 ms, medium/input 1 次，max 17.03 ms, medium/scroll 3 次，max 29.57 ms, stress/scroll 7 次，max 69.91 ms；MoUI Skia GPU: small/scroll 1 次，max 22.72 ms, large/scroll 1 次，max 31.45 ms, stress/scroll 1 次，max 18.00 ms；MoUI 示例编辑器 Skia Raster: small/input 4 次，max 31.96 ms, large/input 30 次，max 24.37 ms, stress/input 30 次，max 214.54 ms；MoUI 示例编辑器 Skia GPU: large/input 30 次，max 40.22 ms, stress/input 30 次，max 210.02 ms, stress/scroll 8 次，max 30.71 ms；MoUI 示例编辑器 WGPU: small/scroll 266 次，max 132.40 ms, medium/input 14 次，max 64.88 ms, medium/scroll 3 次，max 25.47 ms, large/input 30 次，max 20.32 ms, stress/input 30 次，max 168.03 ms；GPUI (md_mbt): small/input 1 次，max 17.96 ms, small/scroll 1 次，max 16.92 ms, medium/input 1 次，max 17.54 ms, medium/scroll 3 次，max 19.61 ms, large/scroll 2 次，max 19.05 ms, stress/input 1 次，max 19.02 ms, stress/scroll 2 次，max 19.28 ms；Flutter Skia: medium/scroll 1 次，max 20.00 ms, stress/scroll 1 次，max 20.00 ms；Flutter Impeller: medium/scroll 6 次，max 30.00 ms, large/scroll 2 次，max 20.00 ms, stress/input 1 次，max 20.00 ms, stress/scroll 1 次，max 30.00 ms；Electron: large/input 1 次，max 20.10 ms。
- 丢帧（优先处理）：Flutter Skia: medium/scroll 1 帧, stress/scroll 1 帧；Flutter Impeller: medium/scroll 6 帧, large/scroll 2 帧, stress/input 1 帧, stress/scroll 1 帧；Electron: large/input 1 帧。
- 解释：首帧异常优先检查窗口/渲染器初始化；输入尾延迟检查 action 到下一可见帧的调度与同步重建；长帧检查解析、布局、文本 shaping 和 GPU 提交；`n/a` 表示未埋点，不等于 0。
- 普通模式的长帧、帧间隔和输入延迟是各框架回调诊断，不能替代跨框架 compositor 排名；需要严格结论时运行 `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`。

## 采集口径

- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。
- `frame_work_ms` 统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏；对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `device_present_ms`：设备/上屏侧统一字段。MoUI raster 为 Skia CPU 光栅化+像素回读整体；MoUI GPU/wgpu 为提交后同步等待设备完成（headless host-surface 逐帧同步，真实应用的 vsync 流水线可重叠掉一部分，该值应视为上屏成本上界）；Flutter 为 `FrameTiming.rasterDuration`（光栅线程任务时间，含显示列表光栅化与 GPU 提交、不含设备完成等待）；GPUI 与 Electron 适配器侧无法观测，显示 `n/a`。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧；严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代；打开场景没有前一帧，所以不计算 interval/drop。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。
