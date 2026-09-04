# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-04T02:37:19Z`
- 数据状态：`360 measured`，`0 skipped/error`；原始样本保留在 JSON。
- Host：`macOS-26.3-arm64-arm-64bit` / `arm64` / `16.0 GiB`；GPU：`Apple M4`
- OS：`25.3.0`；CPU：`arm`；toolchains：`python=3.12.11, moon=moon 0.1.20260824 (dae026a 2026-08-24), rustc=rustc 1.94.0 (4a4ef493e 2026-03-02), cargo=cargo 1.94.0 (85eff7c80 2026-01-15), node=v25.2.1, npm=11.6.2, flutter=Flutter 3.47.1 • channel stable • https://github.com/flutter/flutter.git`
- 统一配置：`1280x800 @ 60 Hz`；font `system-ui 16px`；line-height `1.55`；overscan `3`；fixed row `66px`；GPU backend `Metal`
- Fixture：`small=5KB/100 blocks`，`medium=50KB/1,000 blocks`，`large=500KB/10,000 blocks`，`stress=5MB/100,000 blocks`。
- 本次执行集合：`small, medium, large, stress`；未执行集合在矩阵中显示 `n/a`，不参与比较。
- 汇总口径：mean/P95 合并原始样本；每格 repetition `3`、process warm-up `1`；drop 为各 repetition dropped_display_frames 之和。
- 公平性口径：所有 ui-frame 记录使用相同 fixture、viewport、动作数、warm-up 和重复次数；数值来自框架真实渲染/提交回调。MoUI ui-frame 是 headless host-surface；GPUI 的 frame work 覆盖 request_layout→prepaint→paint，action dispatch 另列为诊断字段。不同框架的显示时间戳由各自平台 API 提供，因此报告不做跨时钟的综合排名。`n/a` 表示没有采集，绝不等同于 0。

- `moui-md-*` 行来自 `vendor/MoUI/examples/markdown_editor` 官方示例应用：fixture 通过应用自身的 `OpenRecentDocument` 服务路径打开，渲染经过示例自己的虚拟滚动与富文本缓存实现，不套用简化基准应用的 `fixed row 66px` 统一行高；viewport、fixture、动作数、warm-up 与重复次数与其他行完全一致。严格模式（`UI_BENCHMARK_SYSTEM_TRACE=1`）目前不为 `moui-md-*` 行采集系统 present，这些行会显示 error。

<details><summary>原始 ui-frame 汇总（可审计）</summary>

| 实现 | 测试集合 | 场景 | 范围 | 工作均值/P95 | 仅分发均值/P95 | 帧间隔均值/P95 | 输入到可见均值/P95 | 离屏均值 | 回读均值 | 首次可交互 | 丢帧数 | 状态 |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| moui-skia-raster | small | open | ui-frame | 47.891/49.062 | - | - | - | 0.00 ms | 5.20 ms | 54.60 ms | n/a | measured |
| moui-skia-raster | small | input | ui-frame | 0.557/0.608 | - | 4.345/4.518 | 4.345/4.517 | 0.00 ms | 3.45 ms | 58.24 ms | n/a | measured |
| moui-skia-raster | small | scroll | ui-frame | 1.656/3.674 | - | 5.781/8.588 | - | 0.00 ms | 3.52 ms | 54.62 ms | n/a | measured |
| moui-skia-raster | medium | open | ui-frame | 49.808/51.293 | - | - | - | 0.00 ms | 6.27 ms | 57.79 ms | n/a | measured |
| moui-skia-raster | medium | input | ui-frame | 0.576/0.690 | - | 4.379/4.904 | 4.378/4.904 | 0.00 ms | 3.45 ms | 58.36 ms | n/a | measured |
| moui-skia-raster | medium | scroll | ui-frame | 1.692/3.714 | - | 5.824/8.858 | - | 0.00 ms | 3.52 ms | 55.83 ms | n/a | measured |
| moui-skia-raster | large | open | ui-frame | 47.571/49.284 | - | - | - | 0.00 ms | 5.14 ms | 56.05 ms | n/a | measured |
| moui-skia-raster | large | input | ui-frame | 0.563/0.632 | - | 4.490/4.839 | 4.490/4.839 | 0.00 ms | 3.41 ms | 60.12 ms | n/a | measured |
| moui-skia-raster | large | scroll | ui-frame | 1.712/3.723 | - | 6.002/8.937 | - | 0.00 ms | 3.65 ms | 60.85 ms | n/a | measured |
| moui-skia-raster | stress | open | ui-frame | 49.244/50.320 | - | - | - | 0.00 ms | 4.97 ms | 74.23 ms | n/a | measured |
| moui-skia-raster | stress | input | ui-frame | 0.638/0.723 | - | 7.032/8.578 | 7.031/8.578 | 0.00 ms | 3.49 ms | 75.68 ms | n/a | measured |
| moui-skia-raster | stress | scroll | ui-frame | 1.689/3.785 | - | 5.787/8.807 | - | 0.00 ms | 3.48 ms | 74.62 ms | n/a | measured |
| moui-skia-gpu | small | open | ui-frame | 63.852/65.568 | - | - | - | n/a | 0.00 ms | 65.39 ms | n/a | measured |
| moui-skia-gpu | small | input | ui-frame | 8.173/8.962 | - | 8.542/9.343 | 8.541/9.342 | n/a | 0.00 ms | 60.53 ms | n/a | measured |
| moui-skia-gpu | small | scroll | ui-frame | 7.805/8.669 | - | 8.472/9.414 | - | n/a | 0.00 ms | 63.77 ms | n/a | measured |
| moui-skia-gpu | medium | open | ui-frame | 69.137/74.231 | - | - | - | n/a | 0.00 ms | 70.83 ms | n/a | measured |
| moui-skia-gpu | medium | input | ui-frame | 8.536/10.730 | - | 8.934/11.187 | 8.933/11.186 | n/a | 0.00 ms | 63.74 ms | n/a | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 7.953/8.771 | - | 8.628/9.453 | - | n/a | 0.00 ms | 63.75 ms | n/a | measured |
| moui-skia-gpu | large | open | ui-frame | 63.567/65.546 | - | - | - | n/a | 0.00 ms | 66.91 ms | n/a | measured |
| moui-skia-gpu | large | input | ui-frame | 8.638/13.079 | - | 9.235/13.607 | 9.234/13.607 | n/a | 0.00 ms | 100.16 ms | n/a | measured |
| moui-skia-gpu | large | scroll | ui-frame | 7.779/8.652 | - | 8.427/9.284 | - | n/a | 0.00 ms | 67.17 ms | n/a | measured |
| moui-skia-gpu | stress | open | ui-frame | 63.752/65.205 | - | - | - | n/a | 0.00 ms | 83.84 ms | n/a | measured |
| moui-skia-gpu | stress | input | ui-frame | 6.905/9.899 | - | 9.864/12.916 | 9.863/12.915 | n/a | 0.00 ms | 82.55 ms | n/a | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 7.786/8.663 | - | 8.429/9.356 | - | n/a | 0.00 ms | 82.63 ms | n/a | measured |
| moui-wgpu | small | open | ui-frame | 58.629/58.877 | - | - | - | n/a | 0.00 ms | 60.14 ms | n/a | measured |
| moui-wgpu | small | input | ui-frame | 7.850/8.951 | - | 8.215/9.326 | 8.215/9.326 | n/a | 0.00 ms | 61.97 ms | n/a | measured |
| moui-wgpu | small | scroll | ui-frame | 7.571/8.791 | - | 8.328/9.260 | - | n/a | 0.00 ms | 60.96 ms | n/a | measured |
| moui-wgpu | medium | open | ui-frame | 59.036/60.433 | - | - | - | n/a | 0.00 ms | 60.69 ms | n/a | measured |
| moui-wgpu | medium | input | ui-frame | 7.818/8.973 | - | 8.220/9.386 | 8.219/9.386 | n/a | 0.00 ms | 62.20 ms | n/a | measured |
| moui-wgpu | medium | scroll | ui-frame | 7.578/8.748 | - | 8.329/9.253 | - | n/a | 0.00 ms | 61.87 ms | n/a | measured |
| moui-wgpu | large | open | ui-frame | 57.203/57.528 | - | - | - | n/a | 0.00 ms | 60.57 ms | n/a | measured |
| moui-wgpu | large | input | ui-frame | 7.545/8.751 | - | 8.138/9.343 | 8.138/9.342 | n/a | 0.00 ms | 62.90 ms | n/a | measured |
| moui-wgpu | large | scroll | ui-frame | 7.575/8.848 | - | 8.326/9.262 | - | n/a | 0.00 ms | 64.40 ms | n/a | measured |
| moui-wgpu | stress | open | ui-frame | 59.770/61.940 | - | - | - | n/a | 0.00 ms | 80.64 ms | n/a | measured |
| moui-wgpu | stress | input | ui-frame | 5.139/6.377 | - | 8.267/9.347 | 8.266/9.347 | n/a | 0.00 ms | 81.90 ms | n/a | measured |
| moui-wgpu | stress | scroll | ui-frame | 7.586/8.816 | - | 8.332/9.247 | - | n/a | 0.00 ms | 78.75 ms | n/a | measured |
| moui-md-skia-raster | small | open | ui-frame | 51.804/52.758 | - | - | - | 0.00 ms | 14.19 ms | 71.50 ms | n/a | measured |
| moui-md-skia-raster | small | input | ui-frame | 4.014/4.370 | - | 26.179/27.149 | 26.099/27.148 | 0.00 ms | 4.60 ms | 73.25 ms | n/a | measured |
| moui-md-skia-raster | small | scroll | ui-frame | 1.351/1.588 | - | 4.038/4.701 | - | 0.00 ms | 2.51 ms | 72.42 ms | n/a | measured |
| moui-md-skia-raster | medium | open | ui-frame | 58.922/59.964 | - | - | - | 0.00 ms | 13.94 ms | 110.06 ms | n/a | measured |
| moui-md-skia-raster | medium | input | ui-frame | 7.746/8.065 | - | 184.720/196.767 | 184.105/196.766 | 0.00 ms | 4.60 ms | 118.70 ms | n/a | measured |
| moui-md-skia-raster | medium | scroll | ui-frame | 5.121/5.781 | - | 7.928/9.144 | - | 0.00 ms | 2.45 ms | 108.30 ms | n/a | measured |
| moui-md-skia-raster | large | open | ui-frame | 120.166/122.537 | - | - | - | 0.00 ms | 13.66 ms | 480.86 ms | n/a | measured |
| moui-md-skia-raster | large | input | ui-frame | 42.714/43.469 | - | 1736.650/1798.469 | 1730.885/1759.512 | 0.00 ms | 4.52 ms | 569.62 ms | n/a | measured |
| moui-md-skia-raster | large | scroll | ui-frame | 42.611/46.998 | - | 47.500/52.037 | - | 0.00 ms | 2.58 ms | 485.23 ms | n/a | measured |
| moui-md-skia-raster | stress | open | ui-frame | 764.452/764.870 | - | - | - | 0.00 ms | 13.07 ms | 4272.50 ms | n/a | measured |
| moui-md-skia-raster | stress | input | ui-frame | 407.622/423.297 | - | 17760.621/18358.064 | 17702.564/18169.837 | 0.00 ms | 4.90 ms | 5183.29 ms | n/a | measured |
| moui-md-skia-raster | stress | scroll | ui-frame | 429.716/471.847 | - | 456.240/496.841 | - | 0.00 ms | 2.85 ms | 4294.31 ms | n/a | measured |
| moui-md-skia-gpu | small | open | ui-frame | 121.508/182.068 | - | - | - | n/a | 0.00 ms | 127.43 ms | n/a | measured |
| moui-md-skia-gpu | small | input | ui-frame | 11.872/21.210 | - | 29.171/38.246 | 29.083/38.245 | n/a | 0.00 ms | 94.73 ms | n/a | measured |
| moui-md-skia-gpu | small | scroll | ui-frame | 8.453/10.774 | - | 8.720/11.100 | - | n/a | 0.00 ms | 89.96 ms | n/a | measured |
| moui-md-skia-gpu | medium | open | ui-frame | 86.622/91.372 | - | - | - | n/a | 0.00 ms | 123.65 ms | n/a | measured |
| moui-md-skia-gpu | medium | input | ui-frame | 17.105/21.694 | - | 195.497/203.463 | 194.860/203.462 | n/a | 0.00 ms | 140.31 ms | n/a | measured |
| moui-md-skia-gpu | medium | scroll | ui-frame | 9.203/13.512 | - | 9.608/14.184 | - | n/a | 0.00 ms | 139.52 ms | n/a | measured |
| moui-md-skia-gpu | large | open | ui-frame | 163.858/167.965 | - | - | - | n/a | 0.00 ms | 514.36 ms | n/a | measured |
| moui-md-skia-gpu | large | input | ui-frame | 49.892/54.683 | - | 1806.032/2093.148 | 1798.862/2030.887 | n/a | 0.00 ms | 622.17 ms | n/a | measured |
| moui-md-skia-gpu | large | scroll | ui-frame | 45.285/53.215 | - | 47.595/55.495 | - | n/a | 0.00 ms | 497.28 ms | n/a | measured |
| moui-md-skia-gpu | stress | open | ui-frame | 811.707/829.261 | - | - | - | n/a | 0.00 ms | 4355.37 ms | n/a | measured |
| moui-md-skia-gpu | stress | input | ui-frame | 412.498/473.736 | - | 17864.203/19215.380 | 17803.934/19215.378 | n/a | 0.00 ms | 5176.70 ms | n/a | measured |
| moui-md-skia-gpu | stress | scroll | ui-frame | 448.392/542.055 | - | 472.314/586.431 | - | n/a | 0.00 ms | 4360.22 ms | n/a | measured |
| moui-md-wgpu | small | open | ui-frame | 93.794/126.223 | - | - | - | n/a | 0.00 ms | 101.07 ms | n/a | measured |
| moui-md-wgpu | small | input | ui-frame | 4.193/4.820 | - | 22.906/24.987 | 22.806/24.145 | n/a | 0.00 ms | 68.83 ms | n/a | measured |
| moui-md-wgpu | small | scroll | ui-frame | 8.511/10.465 | - | 8.849/11.330 | - | n/a | 0.00 ms | 65.27 ms | n/a | measured |
| moui-md-wgpu | medium | open | ui-frame | 64.003/65.111 | - | - | - | n/a | 0.00 ms | 101.02 ms | n/a | measured |
| moui-md-wgpu | medium | input | ui-frame | 8.096/9.283 | - | 189.452/219.407 | 188.750/219.406 | n/a | 0.00 ms | 113.52 ms | n/a | measured |
| moui-md-wgpu | medium | scroll | ui-frame | 8.417/9.574 | - | 8.837/10.419 | - | n/a | 0.00 ms | 110.78 ms | n/a | measured |
| moui-md-wgpu | large | open | ui-frame | 127.962/129.708 | - | - | - | n/a | 0.00 ms | 477.60 ms | n/a | measured |
| moui-md-wgpu | large | input | ui-frame | 43.889/44.691 | - | 1713.920/1759.073 | 1708.086/1738.022 | n/a | 0.00 ms | 556.04 ms | n/a | measured |
| moui-md-wgpu | large | scroll | ui-frame | 45.290/49.784 | - | 47.846/52.394 | - | n/a | 0.00 ms | 465.83 ms | n/a | measured |
| moui-md-wgpu | stress | open | ui-frame | 803.430/836.640 | - | - | - | n/a | 0.00 ms | 4432.95 ms | n/a | measured |
| moui-md-wgpu | stress | input | ui-frame | 406.411/416.738 | - | 17712.973/18664.114 | 17654.579/18664.112 | n/a | 0.00 ms | 7062.23 ms | n/a | measured |
| moui-md-wgpu | stress | scroll | ui-frame | 429.830/467.507 | - | 452.672/489.921 | - | n/a | 0.00 ms | 4340.51 ms | n/a | measured |
| gpui | small | open | ui-frame | 17.081/17.449 | - | - | - | n/a | n/a | 124.32 ms | n/a | measured |
| gpui | small | input | ui-frame | 16.121/16.693 | 0.792/0.857 | 20.108/25.697 | 20.107/25.695 | n/a | n/a | 120.39 ms | n/a | measured |
| gpui | small | scroll | ui-frame | 18.273/21.856 | 0.001/0.002 | 21.743/26.418 | - | n/a | n/a | 123.72 ms | n/a | measured |
| gpui | medium | open | ui-frame | 22.635/29.861 | - | - | - | n/a | n/a | 196.14 ms | n/a | measured |
| gpui | medium | input | ui-frame | 19.785/31.280 | 2.143/4.662 | 25.867/40.830 | 25.864/40.828 | n/a | n/a | 242.77 ms | n/a | measured |
| gpui | medium | scroll | ui-frame | 17.596/20.341 | 0.001/0.002 | 21.159/24.518 | - | n/a | n/a | 129.90 ms | n/a | measured |
| gpui | large | open | ui-frame | 17.354/17.513 | - | - | - | n/a | n/a | 129.67 ms | n/a | measured |
| gpui | large | input | ui-frame | 16.386/16.913 | 10.818/11.319 | 29.610/35.716 | 29.608/35.715 | n/a | n/a | 130.94 ms | n/a | measured |
| gpui | large | scroll | ui-frame | 19.002/21.829 | 0.001/0.003 | 27.867/30.471 | - | n/a | n/a | 133.74 ms | n/a | measured |
| gpui | stress | open | ui-frame | 16.787/16.911 | - | - | - | n/a | n/a | 120.10 ms | n/a | measured |
| gpui | stress | input | ui-frame | 15.664/16.015 | 105.749/109.999 | 113.688/128.019 | 113.687/128.017 | n/a | n/a | 128.39 ms | n/a | measured |
| gpui | stress | scroll | ui-frame | 17.746/20.197 | 0.002/0.003 | 64.500/67.994 | - | n/a | n/a | 456.91 ms | n/a | measured |
| flutter-skia | small | open | ui-frame | 10.754/10.871 | - | - | - | n/a | n/a | 53.74 ms | 0 | measured |
| flutter-skia | small | input | ui-frame | 1.029/1.312 | - | 16.667/16.668 | 16.695/20.475 | n/a | n/a | 54.30 ms | 7 | measured |
| flutter-skia | small | scroll | ui-frame | 4.254/5.983 | - | 16.667/16.669 | - | n/a | n/a | 53.09 ms | 87 | measured |
| flutter-skia | medium | open | ui-frame | 11.576/13.009 | - | - | - | n/a | n/a | 57.85 ms | 0 | measured |
| flutter-skia | medium | input | ui-frame | 1.087/1.431 | - | 16.667/16.668 | 16.695/22.279 | n/a | n/a | 58.05 ms | 8 | measured |
| flutter-skia | medium | scroll | ui-frame | 3.873/6.844 | - | 16.667/16.671 | - | n/a | n/a | 54.88 ms | 105 | measured |
| flutter-skia | large | open | ui-frame | 10.841/11.317 | - | - | - | n/a | n/a | 57.83 ms | 0 | measured |
| flutter-skia | large | input | ui-frame | 1.060/1.333 | - | 16.667/16.668 | 16.699/25.347 | n/a | n/a | 58.69 ms | 8 | measured |
| flutter-skia | large | scroll | ui-frame | 3.874/6.878 | - | 16.713/16.671 | - | n/a | n/a | 59.50 ms | 111 | measured |
| flutter-skia | stress | open | ui-frame | 10.583/10.784 | - | - | - | n/a | n/a | 86.55 ms | 0 | measured |
| flutter-skia | stress | input | ui-frame | 1.034/1.306 | - | 16.667/16.668 | 16.703/19.420 | n/a | n/a | 87.15 ms | 7 | measured |
| flutter-skia | stress | scroll | ui-frame | 3.892/6.873 | - | 16.574/16.671 | - | n/a | n/a | 85.85 ms | 108 | measured |
| flutter-impeller | small | open | ui-frame | 8.646/8.799 | - | - | - | n/a | n/a | 56.54 ms | 0 | measured |
| flutter-impeller | small | input | ui-frame | 1.037/1.332 | - | 16.667/16.668 | 16.703/20.684 | n/a | n/a | 55.63 ms | 8 | measured |
| flutter-impeller | small | scroll | ui-frame | 4.329/5.979 | - | 16.667/16.669 | - | n/a | n/a | 54.40 ms | 79 | measured |
| flutter-impeller | medium | open | ui-frame | 8.748/9.052 | - | - | - | n/a | n/a | 53.95 ms | 0 | measured |
| flutter-impeller | medium | input | ui-frame | 1.077/1.274 | - | 17.222/16.668 | 17.254/25.163 | n/a | n/a | 55.23 ms | 9 | measured |
| flutter-impeller | medium | scroll | ui-frame | 3.891/6.808 | - | 16.574/16.671 | - | n/a | n/a | 54.31 ms | 107 | measured |
| flutter-impeller | large | open | ui-frame | 8.724/8.801 | - | - | - | n/a | n/a | 56.94 ms | 0 | measured |
| flutter-impeller | large | input | ui-frame | 1.111/1.614 | - | 16.667/16.668 | 16.705/26.875 | n/a | n/a | 56.46 ms | 8 | measured |
| flutter-impeller | large | scroll | ui-frame | 3.937/6.857 | - | 16.667/16.671 | - | n/a | n/a | 58.97 ms | 116 | measured |
| flutter-impeller | stress | open | ui-frame | 8.685/8.732 | - | - | - | n/a | n/a | 85.94 ms | 0 | measured |
| flutter-impeller | stress | input | ui-frame | 1.048/1.355 | - | 16.667/16.668 | 16.690/17.100 | n/a | n/a | 88.61 ms | 8 | measured |
| flutter-impeller | stress | scroll | ui-frame | 3.907/6.985 | - | 16.574/16.671 | - | n/a | n/a | 91.25 ms | 103 | measured |
| electron | small | open | ui-frame | 14.467/16.700 | - | - | - | n/a | n/a | 14.47 ms | 0 | measured |
| electron | small | input | ui-frame | 1.510/2.900 | - | 15.000/16.700 | 14.553/16.800 | n/a | n/a | 9.63 ms | 16 | measured |
| electron | small | scroll | ui-frame | 2.505/4.100 | - | 16.666/17.200 | - | n/a | n/a | 12.67 ms | 215 | measured |
| electron | medium | open | ui-frame | 12.133/14.600 | - | - | - | n/a | n/a | 12.13 ms | 0 | measured |
| electron | medium | input | ui-frame | 1.547/3.000 | - | 15.000/16.800 | 14.487/16.800 | n/a | n/a | 10.37 ms | 15 | measured |
| electron | medium | scroll | ui-frame | 2.419/4.000 | - | 16.620/16.800 | - | n/a | n/a | 9.80 ms | 222 | measured |
| electron | large | open | ui-frame | 11.633/12.700 | - | - | - | n/a | n/a | 11.63 ms | 0 | measured |
| electron | large | input | ui-frame | 1.667/2.700 | - | 14.998/17.300 | 14.233/17.200 | n/a | n/a | 11.60 ms | 17 | measured |
| electron | large | scroll | ui-frame | 2.584/4.100 | - | 16.575/17.200 | - | n/a | n/a | 12.60 ms | 218 | measured |
| electron | stress | open | ui-frame | 17.633/17.800 | - | - | - | n/a | n/a | 17.63 ms | 0 | measured |
| electron | stress | input | ui-frame | 1.490/1.900 | - | 15.003/16.800 | 14.360/16.800 | n/a | n/a | 17.43 ms | 15 | measured |
| electron | stress | scroll | ui-frame | 2.468/4.100 | - | 16.572/17.200 | - | n/a | n/a | 17.53 ms | 212 | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.66/1.69/1.71 | 3.67/3.71/3.72 | 5.78/5.82/6.00 | 8.59/8.86/8.94 | n/a/n/a/n/a |
| MoUI Skia GPU | 7.81/7.95/7.78 | 8.67/8.77/8.65 | 8.47/8.63/8.43 | 9.41/9.45/9.28 | n/a/n/a/n/a |
| MoUI WGPU | 7.57/7.58/7.57 | 8.79/8.75/8.85 | 8.33/8.33/8.33 | 9.26/9.25/9.26 | n/a/n/a/n/a |
| MoUI 示例编辑器 Skia Raster | 1.35/5.12/42.61 | 1.59/5.78/47.00 | 4.04/7.93/47.50 | 4.70/9.14/52.04 | n/a/n/a/n/a |
| MoUI 示例编辑器 Skia GPU | 8.45/9.20/45.28 | 10.77/13.51/53.21 | 8.72/9.61/47.60 | 11.10/14.18/55.49 | n/a/n/a/n/a |
| MoUI 示例编辑器 WGPU | 8.51/8.42/45.29 | 10.46/9.57/49.78 | 8.85/8.84/47.85 | 11.33/10.42/52.39 | n/a/n/a/n/a |
| GPUI (md_mbt) | 18.27/17.60/19.00 | 21.86/20.34/21.83 | 21.74/21.16/27.87 | 26.42/24.52/30.47 | n/a/n/a/n/a |
| Flutter Skia | 4.25/3.87/3.87 | 5.98/6.84/6.88 | 16.67/16.67/16.71 | 16.67/16.67/16.67 | 87/105/111 |
| Flutter Impeller | 4.33/3.89/3.94 | 5.98/6.81/6.86 | 16.67/16.57/16.67 | 16.67/16.67/16.67 | 79/107/116 |
| Electron | 2.51/2.42/2.58 | 4.10/4.00/4.10 | 16.67/16.62/16.57 | 17.20/16.80/17.20 | 215/222/218 |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.69 | 3.79 | 5.79 | 8.81 | n/a |
| MoUI Skia GPU | 7.79 | 8.66 | 8.43 | 9.36 | n/a |
| MoUI WGPU | 7.59 | 8.82 | 8.33 | 9.25 | n/a |
| MoUI 示例编辑器 Skia Raster | 429.72 | 471.85 | 456.24 | 496.84 | n/a |
| MoUI 示例编辑器 Skia GPU | 448.39 | 542.06 | 472.31 | 586.43 | n/a |
| MoUI 示例编辑器 WGPU | 429.83 | 467.51 | 452.67 | 489.92 | n/a |
| GPUI (md_mbt) | 17.75 | 20.20 | 64.50 | 67.99 | n/a |
| Flutter Skia | 3.89 | 6.87 | 16.57 | 16.67 | 108 |
| Flutter Impeller | 3.91 | 6.99 | 16.57 | 16.67 | 103 |
| Electron | 2.47 | 4.10 | 16.57 | 17.20 | 212 |

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） |
| --- | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 4.34/4.38/4.49 | 4.52/4.90/4.84 | 0.56/0.58/0.56 | 0.61/0.69/0.63 |
| MoUI Skia GPU | 8.54/8.93/9.23 | 9.34/11.19/13.61 | 8.17/8.54/8.64 | 8.96/10.73/13.08 |
| MoUI WGPU | 8.21/8.22/8.14 | 9.33/9.39/9.34 | 7.85/7.82/7.54 | 8.95/8.97/8.75 |
| MoUI 示例编辑器 Skia Raster | 26.10/184.10/1730.89 | 27.15/196.77/1759.51 | 4.01/7.75/42.71 | 4.37/8.07/43.47 |
| MoUI 示例编辑器 Skia GPU | 29.08/194.86/1798.86 | 38.25/203.46/2030.89 | 11.87/17.10/49.89 | 21.21/21.69/54.68 |
| MoUI 示例编辑器 WGPU | 22.81/188.75/1708.09 | 24.15/219.41/1738.02 | 4.19/8.10/43.89 | 4.82/9.28/44.69 |
| GPUI (md_mbt) | 20.11/25.86/29.61 | 25.70/40.83/35.71 | 16.12/19.79/16.39 | 16.69/31.28/16.91 |
| Flutter Skia | 16.70/16.70/16.70 | 20.48/22.28/25.35 | 1.03/1.09/1.06 | 1.31/1.43/1.33 |
| Flutter Impeller | 16.70/17.25/16.70 | 20.68/25.16/26.88 | 1.04/1.08/1.11 | 1.33/1.27/1.61 |
| Electron | 14.55/14.49/14.23 | 16.80/16.80/17.20 | 1.51/1.55/1.67 | 2.90/3.00/2.70 |

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） |
| --- | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 7.03 | 8.58 | 0.64 | 0.72 |
| MoUI Skia GPU | 9.86 | 12.92 | 6.91 | 9.90 |
| MoUI WGPU | 8.27 | 9.35 | 5.14 | 6.38 |
| MoUI 示例编辑器 Skia Raster | 17702.56 | 18169.84 | 407.62 | 423.30 |
| MoUI 示例编辑器 Skia GPU | 17803.93 | 19215.38 | 412.50 | 473.74 |
| MoUI 示例编辑器 WGPU | 17654.58 | 18664.11 | 406.41 | 416.74 |
| GPUI (md_mbt) | 113.69 | 128.02 | 15.66 | 16.02 |
| Flutter Skia | 16.70 | 19.42 | 1.03 | 1.31 |
| Flutter Impeller | 16.69 | 17.10 | 1.05 | 1.35 |
| Electron | 14.36 | 16.80 | 1.49 | 1.90 |

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 54.60/57.79/56.05 | 55.62/60.61/57.71 | 47.89/49.81/47.57 | 49.06/51.29/49.28 | 0.07/0.27/2.51 | 0.09/0.31/2.63 |
| MoUI Skia GPU | 65.39/70.83/66.91 | 67.18/75.89/68.89 | 63.85/69.14/63.57 | 65.57/74.23/65.55 | 0.07/0.33/2.50 | 0.07/0.35/2.50 |
| MoUI WGPU | 60.14/60.69/60.57 | 60.35/62.14/60.98 | 58.63/59.04/57.20 | 58.88/60.43/57.53 | 0.06/0.33/2.45 | 0.07/0.33/2.48 |
| MoUI 示例编辑器 Skia Raster | 71.50/110.06/480.86 | 72.26/111.08/485.32 | 51.80/58.92/120.17 | 52.76/59.96/122.54 | 0.07/0.27/2.10 | 0.08/0.30/2.45 |
| MoUI 示例编辑器 Skia GPU | 127.43/123.65/514.36 | 187.62/127.97/517.55 | 121.51/86.62/163.86 | 182.07/91.37/167.96 | 0.07/0.32/2.43 | 0.08/0.33/2.49 |
| MoUI 示例编辑器 WGPU | 101.07/101.02/477.60 | 131.92/102.52/481.85 | 93.79/64.00/127.96 | 126.22/65.11/129.71 | 0.09/0.27/2.50 | 0.10/0.28/2.67 |
| GPUI (md_mbt) | 124.32/196.14/129.67 | 128.92/275.73/135.29 | 17.08/22.63/17.35 | 17.45/29.86/17.51 | 0.00/0.67/3.00 | 0.00/1.00/3.00 |
| Flutter Skia | 53.74/57.85/57.83 | 55.30/61.63/58.81 | 10.75/11.58/10.84 | 10.87/13.01/11.32 | 0.09/0.12/0.38 | 0.09/0.13/0.44 |
| Flutter Impeller | 56.54/53.95/56.94 | 58.89/55.58/58.99 | 8.65/8.75/8.72 | 8.80/9.05/8.80 | 0.08/0.11/0.35 | 0.09/0.12/0.36 |
| Electron | 14.47/12.13/11.63 | 16.70/14.60/12.70 | 14.47/12.13/11.63 | 16.70/14.60/12.70 | 2.73/2.70/3.06 | 2.75/2.80/3.25 |

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 74.23 | 75.31 | 49.24 | 50.32 | 24.45 | 27.62 |
| MoUI Skia GPU | 83.84 | 85.13 | 63.75 | 65.20 | 25.49 | 26.73 |
| MoUI WGPU | 80.64 | 84.27 | 59.77 | 61.94 | 17.89 | 19.14 |
| MoUI 示例编辑器 Skia Raster | 4272.50 | 4289.47 | 764.45 | 764.87 | 22.80 | 26.16 |
| MoUI 示例编辑器 Skia GPU | 4355.37 | 4401.44 | 811.71 | 829.26 | 19.14 | 22.10 |
| MoUI 示例编辑器 WGPU | 4432.95 | 4538.26 | 803.43 | 836.64 | 22.37 | 26.69 |
| GPUI (md_mbt) | 120.10 | 124.86 | 16.79 | 16.91 | 24.33 | 26.00 |
| Flutter Skia | 86.55 | 87.82 | 10.58 | 10.78 | 2.74 | 2.77 |
| Flutter Impeller | 85.94 | 89.47 | 8.69 | 8.73 | 2.82 | 2.85 |
| Electron | 17.63 | 17.80 | 17.63 | 17.80 | 4.63 | 4.86 |

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 离屏均值（ms） | 离屏 P95（ms） | 回读均值（ms） | 回读 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.66/1.69/1.71 | 3.67/3.71/3.72 | 5.78/5.82/6.00 | 8.59/8.86/8.94 | n/a/n/a/n/a | 0.00/0.00/0.00 | 0.00/0.00/0.00 | 3.52/3.52/3.65 | 4.18/4.18/4.41 |
| MoUI Skia GPU | 7.81/7.95/7.78 | 8.67/8.77/8.65 | 8.47/8.63/8.43 | 9.41/9.45/9.28 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | 0.00/0.00/0.00 | 0.00/0.00/0.00 |
| MoUI WGPU | 7.57/7.58/7.57 | 8.79/8.75/8.85 | 8.33/8.33/8.33 | 9.26/9.25/9.26 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | 0.00/0.00/0.00 | 0.00/0.00/0.00 |
| MoUI 示例编辑器 Skia Raster | 1.35/5.12/42.61 | 1.59/5.78/47.00 | 4.04/7.93/47.50 | 4.70/9.14/52.04 | n/a/n/a/n/a | 0.00/0.00/0.00 | 0.00/0.00/0.00 | 2.51/2.45/2.58 | 2.97/3.01/3.11 |
| MoUI 示例编辑器 Skia GPU | 8.45/9.20/45.28 | 10.77/13.51/53.21 | 8.72/9.61/47.60 | 11.10/14.18/55.49 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | 0.00/0.00/0.00 | 0.00/0.00/0.00 |
| MoUI 示例编辑器 WGPU | 8.51/8.42/45.29 | 10.46/9.57/49.78 | 8.85/8.84/47.85 | 11.33/10.42/52.39 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | 0.00/0.00/0.00 | 0.00/0.00/0.00 |
| GPUI (md_mbt) | 18.27/17.60/19.00 | 21.86/20.34/21.83 | 21.74/21.16/27.87 | 26.42/24.52/30.47 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | 4.25/3.87/3.87 | 5.98/6.84/6.88 | 16.67/16.67/16.71 | 16.67/16.67/16.67 | 87/105/111 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Impeller | 4.33/3.89/3.94 | 5.98/6.81/6.86 | 16.67/16.57/16.67 | 16.67/16.67/16.67 | 79/107/116 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Electron | 2.51/2.42/2.58 | 4.10/4.00/4.10 | 16.67/16.62/16.57 | 17.20/16.80/17.20 | 215/222/218 | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 离屏均值（ms） | 离屏 P95（ms） | 回读均值（ms） | 回读 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 1.69 | 3.79 | 5.79 | 8.81 | n/a | 0.00 | 0.00 | 3.48 | 4.12 |
| MoUI Skia GPU | 7.79 | 8.66 | 8.43 | 9.36 | n/a | n/a | n/a | 0.00 | 0.00 |
| MoUI WGPU | 7.59 | 8.82 | 8.33 | 9.25 | n/a | n/a | n/a | 0.00 | 0.00 |
| MoUI 示例编辑器 Skia Raster | 429.72 | 471.85 | 456.24 | 496.84 | n/a | 0.00 | 0.00 | 2.85 | 3.42 |
| MoUI 示例编辑器 Skia GPU | 448.39 | 542.06 | 472.31 | 586.43 | n/a | n/a | n/a | 0.00 | 0.00 |
| MoUI 示例编辑器 WGPU | 429.83 | 467.51 | 452.67 | 489.92 | n/a | n/a | n/a | 0.00 | 0.00 |
| GPUI (md_mbt) | 17.75 | 20.20 | 64.50 | 67.99 | n/a | n/a | n/a | n/a | n/a |
| Flutter Skia | 3.89 | 6.87 | 16.57 | 16.67 | 108 | n/a | n/a | n/a | n/a |
| Flutter Impeller | 3.91 | 6.99 | 16.57 | 16.67 | 103 | n/a | n/a | n/a | n/a |
| Electron | 2.47 | 4.10 | 16.57 | 17.20 | 212 | n/a | n/a | n/a | n/a |

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoUI 示例编辑器 Skia Raster medium 110.1 ms（max 111.1 ms）；MoUI 示例编辑器 Skia Raster large 480.9 ms（max 485.3 ms）；MoUI 示例编辑器 Skia Raster stress 4272.5 ms（max 4289.5 ms）；MoUI 示例编辑器 Skia GPU small 127.4 ms（max 187.6 ms）；MoUI 示例编辑器 Skia GPU medium 123.7 ms（max 128.0 ms）；MoUI 示例编辑器 Skia GPU large 514.4 ms（max 517.5 ms）；MoUI 示例编辑器 Skia GPU stress 4355.4 ms（max 4401.4 ms）；MoUI 示例编辑器 WGPU small 101.1 ms（max 131.9 ms）；MoUI 示例编辑器 WGPU medium 101.0 ms（max 102.5 ms）；MoUI 示例编辑器 WGPU large 477.6 ms（max 481.9 ms）；MoUI 示例编辑器 WGPU stress 4432.9 ms（max 4538.3 ms）；GPUI (md_mbt) small 124.3 ms（max 128.9 ms）；GPUI (md_mbt) medium 196.1 ms（max 275.7 ms）；GPUI (md_mbt) large 129.7 ms（max 135.3 ms）；GPUI (md_mbt) stress 120.1 ms（max 124.9 ms）。
- P1 输入尾延迟：MoUI 示例编辑器 Skia Raster small P95 27.15 ms；MoUI 示例编辑器 Skia Raster medium P95 196.77 ms；MoUI 示例编辑器 Skia Raster large P95 1759.51 ms；MoUI 示例编辑器 Skia Raster stress P95 18169.84 ms；MoUI 示例编辑器 Skia GPU small P95 38.25 ms；MoUI 示例编辑器 Skia GPU medium P95 203.46 ms；MoUI 示例编辑器 Skia GPU large P95 2030.89 ms；MoUI 示例编辑器 Skia GPU stress P95 19215.38 ms；MoUI 示例编辑器 WGPU small P95 24.15 ms；MoUI 示例编辑器 WGPU medium P95 219.41 ms；MoUI 示例编辑器 WGPU large P95 1738.02 ms；MoUI 示例编辑器 WGPU stress P95 18664.11 ms；GPUI (md_mbt) small P95 25.70 ms；GPUI (md_mbt) medium P95 40.83 ms；GPUI (md_mbt) large P95 35.71 ms；GPUI (md_mbt) stress P95 128.02 ms；Flutter Skia small P95 20.48 ms；Flutter Skia medium P95 22.28 ms；Flutter Skia large P95 25.35 ms；Flutter Skia stress P95 19.42 ms；Flutter Impeller small P95 20.68 ms；Flutter Impeller medium P95 25.16 ms；Flutter Impeller large P95 26.88 ms；Flutter Impeller stress P95 17.10 ms；Electron small P95 16.80 ms；Electron medium P95 16.80 ms；Electron large P95 17.20 ms；Electron stress P95 16.80 ms。
- 长帧（超预算）：MoUI Skia GPU: medium/scroll 3 次，max 32.94 ms, stress/input 1 次，max 18.76 ms；MoUI 示例编辑器 Skia Raster: small/input 30 次，max 27.55 ms, medium/input 30 次，max 205.68 ms, large/input 30 次，max 1803.14 ms, large/scroll 360 次，max 77.22 ms, stress/input 30 次，max 18935.08 ms, stress/scroll 360 次，max 794.47 ms；MoUI 示例编辑器 Skia GPU: small/input 30 次，max 39.07 ms, small/scroll 1 次，max 17.25 ms, medium/input 30 次，max 332.43 ms, medium/scroll 8 次，max 25.26 ms, large/input 30 次，max 2152.03 ms, large/scroll 360 次，max 76.47 ms, stress/input 30 次，max 23097.88 ms, stress/scroll 360 次，max 939.92 ms；MoUI 示例编辑器 WGPU: small/input 30 次，max 25.02 ms, small/scroll 6 次，max 45.49 ms, medium/input 30 次，max 240.89 ms, medium/scroll 4 次，max 23.85 ms, large/input 30 次，max 1785.78 ms, large/scroll 360 次，max 128.39 ms, stress/input 30 次，max 18874.14 ms, stress/scroll 360 次，max 748.10 ms；GPUI (md_mbt): small/input 30 次，max 27.09 ms, small/scroll 360 次，max 33.01 ms, medium/input 30 次，max 52.09 ms, medium/scroll 360 次，max 32.25 ms, large/input 30 次，max 37.62 ms, large/scroll 360 次，max 405.35 ms, stress/input 30 次，max 128.22 ms, stress/scroll 360 次，max 71.72 ms；Flutter Skia: large/scroll 1 次，max 33.33 ms；Flutter Impeller: medium/input 1 次，max 33.33 ms；Electron: small/input 1 次，max 16.80 ms, small/scroll 39 次，max 17.70 ms, medium/input 3 次，max 16.80 ms, medium/scroll 31 次，max 17.60 ms, large/input 5 次，max 17.60 ms, large/scroll 49 次，max 17.70 ms, stress/input 3 次，max 17.30 ms, stress/scroll 54 次，max 17.70 ms。
- 丢帧（优先处理）：Flutter Skia: small/input 7 帧, small/scroll 87 帧, medium/input 8 帧, medium/scroll 105 帧, large/input 8 帧, large/scroll 111 帧, stress/input 7 帧, stress/scroll 108 帧；Flutter Impeller: small/input 8 帧, small/scroll 79 帧, medium/input 9 帧, medium/scroll 107 帧, large/input 8 帧, large/scroll 116 帧, stress/input 8 帧, stress/scroll 103 帧；Electron: small/input 16 帧, small/scroll 215 帧, medium/input 15 帧, medium/scroll 222 帧, large/input 17 帧, large/scroll 218 帧, stress/input 15 帧, stress/scroll 212 帧。
- 解释：首帧异常优先检查窗口/渲染器初始化；输入尾延迟检查 action 到下一可见帧的调度与同步重建；长帧检查解析、布局、文本 shaping 和 GPU 提交；`n/a` 表示未埋点，不等于 0。
- 普通模式的长帧、帧间隔和输入延迟是各框架回调诊断，不能替代跨框架 compositor 排名；需要严格结论时运行 `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`。

## 采集口径

- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。
- `frame_work_ms` 对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧；严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代；打开场景没有前一帧，所以不计算 interval/drop。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。
