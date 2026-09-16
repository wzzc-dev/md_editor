# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-16T04:57:44Z`
- 数据状态：`180 measured`，`60 skipped/error`；原始样本保留在 JSON。
- Host：`macOS-26.3-arm64-arm-64bit` / `arm64` / `16.0 GiB`；GPU：`Apple M4`
- OS：`25.3.0`；CPU：`arm`；toolchains：`python=3.12.11, moon=moon 0.1.20260824 (dae026a 2026-08-24), rustc=rustc 1.94.0 (4a4ef493e 2026-03-02), cargo=cargo 1.94.0 (85eff7c80 2026-01-15), node=v25.2.1, npm=11.6.2, flutter=┌─────────────────────────────────────────────────────────┐`
- 统一配置：`1280x800 @ 60 Hz`；font `system-ui 16px`；line-height `1.55`；overscan `3`；fixed row `66px`；GPU backend `Metal`
- Fixture：`small=5KB/100 blocks`，`medium=50KB/1,000 blocks`，`large=500KB/10,000 blocks`，`stress=5MB/100,000 blocks`。
- 本次执行集合：`small, medium, large, stress`；未执行集合在矩阵中显示 `n/a`，不参与比较。
- 汇总口径：mean/P95 合并原始样本；每格 repetition `3`、process warm-up `1`；drop 为各 repetition dropped_display_frames 之和。
- 公平性口径：所有 ui-frame 记录使用相同 fixture、viewport、动作数、warm-up 和重复次数。`工作`（frame_work）统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏：MoUI 为 build+layout+paint+draw，Flutter 为 UI 线程 buildDuration，GPUI 为 request_layout→prepaint→paint，Electron 为 JS 可见的 DOM 更新+layout。设备光栅化与上屏统一单列为 `设备侧`（device_present）：native-window 模式下 MoUI 在真实 AppKit 窗口上屏，适配器侧不单独计时设备光栅化，显示 `n/a`，Flutter 为光栅线程 rasterDuration（不含设备完成等待），GPUI 与 Electron 无法在适配器侧观测显示链路，显示 `n/a`。MoUI ui-frame 运行在真实 AppKit 窗口（`native-window`），其帧间隔/输入延迟是动作到原生帧观察的 wall-clock 采样（观察节奏约 12 ms），与 GPUI 的 `on_next_frame`、Flutter 的 vsyncStart、Electron 的 rAF 同属框架回调诊断；GPUI 的 action dispatch 另列为诊断字段。不同框架的显示时间戳由各自平台 API 提供，帧间隔覆盖完整链路，报告不做跨时钟的综合排名。`n/a` 表示没有采集，绝不等同于 0。下方各对比表把同平台跨框架可比列（帧间隔/可见延迟/首次可交互/丢帧数等）排在前面，框架内部诊断列（`工作`/`设备侧`）排在后面并标注 `†`。

- `moui-md-*` 行来自 `momark`（MoMark，原 `vendor/MoUI/examples/markdown_editor`）官方示例应用：fixture 通过应用自身的 `OpenRecentDocument` 服务路径打开，渲染经过示例自己的虚拟滚动与富文本缓存实现，不套用简化基准应用的 `fixed row 66px` 统一行高；viewport、fixture、动作数、warm-up 与重复次数与其他行完全一致。严格模式（`UI_BENCHMARK_SYSTEM_TRACE=1`）目前不为 `moui-md-*` 行采集系统 present，这些行会显示 error。

<details><summary>原始 ui-frame 汇总（可审计）</summary>

| 实现 | 测试集合 | 场景 | 范围 | 工作均值/P95 | 仅分发均值/P95 | 帧间隔均值/P95 | 输入到可见均值/P95 | 设备侧均值 | 离屏均值 | 回读均值 | 首次可交互 | 丢帧数 | 状态 |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| moui-skia-raster | small | open | ui-frame | 0.012/0.017 | - | - | - | n/a | n/a | n/a | 231.49 ms | 0 | measured |
| moui-skia-raster | small | input | ui-frame | 0.664/0.771 | - | 26.009/36.142 | 25.955/36.089 | n/a | n/a | n/a | 200.96 ms | 31 | measured |
| moui-skia-raster | small | scroll | ui-frame | 0.483/0.608 | - | 24.203/26.341 | - | n/a | n/a | n/a | 196.85 ms | 360 | measured |
| moui-skia-raster | medium | open | ui-frame | 0.014/0.023 | - | - | - | n/a | n/a | n/a | 202.49 ms | 0 | measured |
| moui-skia-raster | medium | input | ui-frame | 0.709/0.776 | - | 25.866/35.133 | 25.811/35.072 | n/a | n/a | n/a | 213.36 ms | 31 | measured |
| moui-skia-raster | medium | scroll | ui-frame | 0.482/0.601 | - | 24.258/26.544 | - | n/a | n/a | n/a | 207.69 ms | 362 | measured |
| moui-skia-raster | large | open | ui-frame | 0.020/0.034 | - | - | - | n/a | n/a | n/a | 204.91 ms | 0 | measured |
| moui-skia-raster | large | input | ui-frame | 0.691/0.778 | - | 26.559/36.161 | 26.501/36.104 | n/a | n/a | n/a | 216.10 ms | 31 | measured |
| moui-skia-raster | large | scroll | ui-frame | 0.483/0.612 | - | 24.367/26.317 | - | n/a | n/a | n/a | 211.13 ms | 360 | measured |
| moui-skia-raster | stress | open | ui-frame | 0.020/0.022 | - | - | - | n/a | n/a | n/a | 250.98 ms | 0 | measured |
| moui-skia-raster | stress | input | ui-frame | 0.657/0.775 | - | 25.704/28.550 | 25.651/28.544 | n/a | n/a | n/a | 248.21 ms | 29 | measured |
| moui-skia-raster | stress | scroll | ui-frame | 0.491/0.630 | - | 24.608/26.468 | - | n/a | n/a | n/a | 249.50 ms | 362 | measured |
| moui-md-skia-raster | small | open | ui-frame | 0.013/0.015 | - | - | - | n/a | n/a | n/a | 217.72 ms | 0 | measured |
| moui-md-skia-raster | small | input | ui-frame | 1.149/1.275 | - | 32.447/36.719 | 32.399/36.667 | n/a | n/a | n/a | 215.53 ms | 36 | measured |
| moui-md-skia-raster | small | scroll | ui-frame | 1.564/1.968 | - | 34.169/36.730 | - | n/a | n/a | n/a | 220.93 ms | 590 | measured |
| moui-md-skia-raster | medium | open | ui-frame | 0.019/0.031 | - | - | - | n/a | n/a | n/a | 222.94 ms | 0 | measured |
| moui-md-skia-raster | medium | input | ui-frame | 1.219/1.337 | - | 32.935/42.633 | 32.884/42.584 | n/a | n/a | n/a | 220.84 ms | 39 | measured |
| moui-md-skia-raster | medium | scroll | ui-frame | 1.563/1.944 | - | 33.694/36.812 | - | n/a | n/a | n/a | 227.02 ms | 544 | measured |
| moui-md-skia-raster | large | open | ui-frame | 0.012/0.017 | - | - | - | n/a | n/a | n/a | 191.07 ms | 0 | measured |
| moui-md-skia-raster | large | input | ui-frame | 1.450/1.589 | - | 32.003/40.457 | 31.955/40.418 | n/a | n/a | n/a | 233.68 ms | 33 | measured |
| moui-md-skia-raster | large | scroll | ui-frame | 1.555/1.926 | - | 33.292/35.761 | - | n/a | n/a | n/a | 244.46 ms | 517 | measured |
| moui-md-skia-raster | stress | open | ui-frame | 0.012/0.013 | - | - | - | n/a | n/a | n/a | 335.74 ms | 0 | measured |
| moui-md-skia-raster | stress | input | ui-frame | 3.978/4.310 | - | 34.868/36.294 | 34.817/36.253 | n/a | n/a | n/a | 305.60 ms | 58 | measured |
| moui-md-skia-raster | stress | scroll | ui-frame | 1.573/1.930 | - | 33.754/36.719 | - | n/a | n/a | n/a | 327.06 ms | 557 | measured |
| moui-md-skia-gpu | small | open | ui-frame | 0.014/0.016 | - | - | - | n/a | n/a | n/a | 201.14 ms | 0 | measured |
| moui-md-skia-gpu | small | input | ui-frame | 1.162/1.300 | - | 13.604/19.999 | 13.555/19.946 | n/a | n/a | n/a | 211.67 ms | 2 | measured |
| moui-md-skia-gpu | small | scroll | ui-frame | 2.028/2.696 | - | 13.199/14.387 | - | n/a | n/a | n/a | 209.87 ms | 3 | measured |
| moui-md-skia-gpu | medium | open | ui-frame | 0.013/0.014 | - | - | - | n/a | n/a | n/a | 187.85 ms | 0 | measured |
| moui-md-skia-gpu | medium | input | ui-frame | 1.193/1.376 | - | 13.595/19.985 | 13.544/19.928 | n/a | n/a | n/a | 207.97 ms | 2 | measured |
| moui-md-skia-gpu | medium | scroll | ui-frame | 2.041/2.657 | - | 13.390/14.640 | - | n/a | n/a | n/a | 200.51 ms | 7 | measured |
| moui-md-skia-gpu | large | open | ui-frame | 0.015/0.017 | - | - | - | n/a | n/a | n/a | 222.79 ms | 0 | measured |
| moui-md-skia-gpu | large | input | ui-frame | 1.420/1.518 | - | 13.443/14.515 | 13.379/14.425 | n/a | n/a | n/a | 223.30 ms | 0 | measured |
| moui-md-skia-gpu | large | scroll | ui-frame | 2.043/2.712 | - | 13.346/15.636 | - | n/a | n/a | n/a | 207.55 ms | 3 | measured |
| moui-md-skia-gpu | stress | open | ui-frame | 0.014/0.015 | - | - | - | n/a | n/a | n/a | 278.24 ms | 0 | measured |
| moui-md-skia-gpu | stress | input | ui-frame | 3.978/4.121 | - | 17.978/19.282 | 17.901/19.272 | n/a | n/a | n/a | 319.54 ms | 30 | measured |
| moui-md-skia-gpu | stress | scroll | ui-frame | 2.071/2.750 | - | 13.328/14.824 | - | n/a | n/a | n/a | 305.36 ms | 4 | measured |
| moui-md-wgpu | small | open | ui-frame | 0.000/0.000 | - | - | - | n/a | n/a | n/a | 30120.21 ms | 0 | measured |
| moui-md-wgpu | small | input | ui-frame | 0.000/0.000 | - | 14.894/15.788 | 14.458/15.096 | n/a | n/a | n/a | 30112.43 ms | 0 | measured |
| moui-md-wgpu | small | scroll | ui-frame | 0.000/0.000 | - | 17.720/19.477 | - | n/a | n/a | n/a | 30120.41 ms | 299 | measured |
| moui-md-wgpu | medium | open | ui-frame | 0.000/0.000 | - | - | - | n/a | n/a | n/a | 30123.50 ms | 0 | measured |
| moui-md-wgpu | medium | input | ui-frame | 0.000/0.000 | - | 14.744/16.156 | 14.346/15.194 | n/a | n/a | n/a | 30171.00 ms | 0 | measured |
| moui-md-wgpu | medium | scroll | ui-frame | 0.000/0.000 | - | 17.744/19.658 | - | n/a | n/a | n/a | 30112.39 ms | 293 | measured |
| moui-md-wgpu | large | open | ui-frame | 0.000/0.000 | - | - | - | n/a | n/a | n/a | 30129.31 ms | 0 | measured |
| moui-md-wgpu | large | input | ui-frame | 0.000/0.000 | - | 15.098/16.226 | 14.810/15.696 | n/a | n/a | n/a | 30139.01 ms | 0 | measured |
| moui-md-wgpu | large | scroll | ui-frame | 0.000/0.000 | - | 16.916/18.515 | - | n/a | n/a | n/a | 30130.58 ms | 207 | measured |
| moui-md-wgpu | stress | open | ui-frame | 0.000/0.000 | - | - | - | n/a | n/a | n/a | 30223.03 ms | 0 | measured |
| moui-md-wgpu | stress | input | ui-frame | 0.000/0.000 | - | 21.644/22.894 | 21.482/22.880 | n/a | n/a | n/a | 30203.00 ms | 30 | measured |
| moui-md-wgpu | stress | scroll | ui-frame | 0.000/0.000 | - | 16.981/18.589 | - | n/a | n/a | n/a | 30215.78 ms | 208 | measured |
| gpmark | small | open | ui-frame | 5.276/5.423 | - | - | - | n/a | n/a | n/a | 113.18 ms | n/a | measured |
| gpmark | small | input | ui-frame | 4.892/5.095 | 0.311/0.383 | 9.394/10.954 | 9.391/10.941 | n/a | n/a | n/a | 112.32 ms | n/a | measured |
| gpmark | small | scroll | ui-frame | 5.762/7.260 | 0.002/0.004 | 9.937/10.834 | - | n/a | n/a | n/a | 117.76 ms | n/a | measured |
| gpmark | medium | open | ui-frame | 5.282/5.297 | - | - | - | n/a | n/a | n/a | 114.10 ms | n/a | measured |
| gpmark | medium | input | ui-frame | 4.999/5.275 | 0.327/0.394 | 9.566/10.940 | 9.563/10.937 | n/a | n/a | n/a | 115.61 ms | n/a | measured |
| gpmark | medium | scroll | ui-frame | 5.960/7.531 | 0.003/0.005 | 9.953/10.939 | - | n/a | n/a | n/a | 115.67 ms | n/a | measured |
| gpmark | large | open | ui-frame | 5.321/5.369 | - | - | - | n/a | n/a | n/a | 120.21 ms | n/a | measured |
| gpmark | large | input | ui-frame | 5.016/5.304 | 0.558/0.714 | 9.703/10.836 | 9.700/10.834 | n/a | n/a | n/a | 123.38 ms | n/a | measured |
| gpmark | large | scroll | ui-frame | 5.846/7.285 | 0.002/0.004 | 9.999/10.178 | - | n/a | n/a | n/a | 128.10 ms | n/a | measured |
| gpmark | stress | open | ui-frame | 5.410/5.593 | - | - | - | n/a | n/a | n/a | 214.98 ms | n/a | measured |
| gpmark | stress | input | ui-frame | 5.082/5.515 | 3.019/3.880 | 9.273/10.709 | 9.272/10.708 | n/a | n/a | n/a | 222.19 ms | n/a | measured |
| gpmark | stress | scroll | ui-frame | 5.864/7.290 | 0.002/0.004 | 9.978/10.832 | - | n/a | n/a | n/a | 223.77 ms | n/a | measured |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 24.20/24.26/24.37 | 26.34/26.54/26.32 | 360/362/360 | 0.48/0.48/0.48 | 0.61/0.60/0.61 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 34.17/33.69/33.29 | 36.73/36.81/35.76 | 590/544/517 | 1.56/1.56/1.55 | 1.97/1.94/1.93 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 13.20/13.39/13.35 | 14.39/14.64/15.64 | 3/7/3 | 2.03/2.04/2.04 | 2.70/2.66/2.71 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 17.72/17.74/16.92 | 19.48/19.66/18.52 | 299/293/207 | 0.00/0.00/0.00 | 0.00/0.00/0.00 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 9.94/9.95/10.00 | 10.83/10.94/10.18 | n/a/n/a/n/a | 5.76/5.96/5.85 | 7.26/7.53/7.29 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Impeller | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Electron | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 24.61 | 26.47 | 362 | 0.49 | 0.63 | n/a | n/a |
| MoUI Skia GPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI WGPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoMark Skia Raster | 33.75 | 36.72 | 557 | 1.57 | 1.93 | n/a | n/a |
| MoMark Skia GPU | 13.33 | 14.82 | 4 | 2.07 | 2.75 | n/a | n/a |
| MoMark WGPU | 16.98 | 18.59 | 208 | 0.00 | 0.00 | n/a | n/a |
| GpMark.mbt (GPUI) | 9.98 | 10.83 | n/a | 5.86 | 7.29 | n/a | n/a |
| Flutter Skia | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Impeller | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Electron | n/a | n/a | n/a | n/a | n/a | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 25.95/25.81/26.50 | 36.09/35.07/36.10 | 0.66/0.71/0.69 | 0.77/0.78/0.78 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 32.40/32.88/31.96 | 36.67/42.58/40.42 | 1.15/1.22/1.45 | 1.27/1.34/1.59 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 13.56/13.54/13.38 | 19.95/19.93/14.43 | 1.16/1.19/1.42 | 1.30/1.38/1.52 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 14.46/14.35/14.81 | 15.10/15.19/15.70 | 0.00/0.00/0.00 | 0.00/0.00/0.00 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 9.39/9.56/9.70 | 10.94/10.94/10.83 | 4.89/5.00/5.02 | 5.10/5.27/5.30 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Impeller | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Electron | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 25.65 | 28.54 | 0.66 | 0.78 | n/a | n/a |
| MoUI Skia GPU | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI WGPU | n/a | n/a | n/a | n/a | n/a | n/a |
| MoMark Skia Raster | 34.82 | 36.25 | 3.98 | 4.31 | n/a | n/a |
| MoMark Skia GPU | 17.90 | 19.27 | 3.98 | 4.12 | n/a | n/a |
| MoMark WGPU | 21.48 | 22.88 | 0.00 | 0.00 | n/a | n/a |
| GpMark.mbt (GPUI) | 9.27 | 10.71 | 5.08 | 5.52 | n/a | n/a |
| Flutter Skia | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Impeller | n/a | n/a | n/a | n/a | n/a | n/a |
| Electron | n/a | n/a | n/a | n/a | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 231.49/202.49/204.91 | 289.59/209.73/207.71 | 0.08/0.32/2.49 | 0.09/0.44/2.51 | 0.01/0.01/0.02 | 0.02/0.02/0.03 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 217.72/222.94/191.07 | 227.16/225.39/227.53 | 0.08/0.28/2.50 | 0.10/0.29/2.56 | 0.01/0.02/0.01 | 0.02/0.03/0.02 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 201.14/187.85/222.79 | 218.30/205.33/228.59 | 0.08/0.25/2.52 | 0.10/0.29/2.57 | 0.01/0.01/0.01 | 0.02/0.01/0.02 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 30120.21/30123.50/30129.31 | 30129.17/30151.27/30134.75 | 0.16/0.48/3.10 | 0.21/0.59/3.37 | 0.00/0.00/0.00 | 0.00/0.00/0.00 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 113.18/114.10/120.21 | 116.66/116.08/122.12 | 0.00/0.00/2.00 | 0.00/0.00/2.00 | 5.28/5.28/5.32 | 5.42/5.30/5.37 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Impeller | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Electron | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 250.98 | 255.09 | 24.69 | 27.42 | 0.02 | 0.02 | n/a | n/a |
| MoUI Skia GPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI WGPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoMark Skia Raster | 335.74 | 344.93 | 24.84 | 27.05 | 0.01 | 0.01 | n/a | n/a |
| MoMark Skia GPU | 278.24 | 309.73 | 23.34 | 25.53 | 0.01 | 0.02 | n/a | n/a |
| MoMark WGPU | 30223.03 | 30224.88 | 26.12 | 32.04 | 0.00 | 0.00 | n/a | n/a |
| GpMark.mbt (GPUI) | 214.98 | 219.84 | 22.67 | 25.00 | 5.41 | 5.59 | n/a | n/a |
| Flutter Skia | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Impeller | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Electron | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 24.20/24.26/24.37 | 26.34/26.54/26.32 | 360/362/360 | 0.48/0.48/0.48 | 0.61/0.60/0.61 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia Raster | 34.17/33.69/33.29 | 36.73/36.81/35.76 | 590/544/517 | 1.56/1.56/1.55 | 1.97/1.94/1.93 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark Skia GPU | 13.20/13.39/13.35 | 14.39/14.64/15.64 | 3/7/3 | 2.03/2.04/2.04 | 2.70/2.66/2.71 | n/a/n/a/n/a | n/a/n/a/n/a |
| MoMark WGPU | 17.72/17.74/16.92 | 19.48/19.66/18.52 | 299/293/207 | 0.00/0.00/0.00 | 0.00/0.00/0.00 | n/a/n/a/n/a | n/a/n/a/n/a |
| GpMark.mbt (GPUI) | 9.94/9.95/10.00 | 10.83/10.94/10.18 | n/a/n/a/n/a | 5.76/5.96/5.85 | 7.26/7.53/7.29 | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Impeller | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Electron | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

## stress 5MB

| 实现 | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 工作均值（ms） † | 工作 P95（ms） † | 设备侧均值（ms） † | 设备侧 P95（ms） † |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 24.61 | 26.47 | 362 | 0.49 | 0.63 | n/a | n/a |
| MoUI Skia GPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI WGPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoMark Skia Raster | 33.75 | 36.72 | 557 | 1.57 | 1.93 | n/a | n/a |
| MoMark Skia GPU | 13.33 | 14.82 | 4 | 2.07 | 2.75 | n/a | n/a |
| MoMark WGPU | 16.98 | 18.59 | 208 | 0.00 | 0.00 | n/a | n/a |
| GpMark.mbt (GPUI) | 9.98 | 10.83 | n/a | 5.86 | 7.29 | n/a | n/a |
| Flutter Skia | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Impeller | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Electron | n/a | n/a | n/a | n/a | n/a | n/a | n/a |

> 列口径：无 `†` 的列为同平台跨框架可比（同 fixture/viewport/动作数/重复，覆盖到显示链路或 wall-clock）；带 `†` 的 `工作`/`设备侧` 为框架内部诊断（各框架统计相位与可观测面不同），仅用于同框架随 fixture 的缩放与回归比较，不应跨框架相除。

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：MoUI Skia Raster CPU small 231.5 ms（max 289.6 ms）；MoUI Skia Raster CPU medium 202.5 ms（max 209.7 ms）；MoUI Skia Raster CPU large 204.9 ms（max 207.7 ms）；MoUI Skia Raster CPU stress 251.0 ms（max 255.1 ms）；MoMark Skia Raster small 217.7 ms（max 227.2 ms）；MoMark Skia Raster medium 222.9 ms（max 225.4 ms）；MoMark Skia Raster large 191.1 ms（max 227.5 ms）；MoMark Skia Raster stress 335.7 ms（max 344.9 ms）；MoMark Skia GPU small 201.1 ms（max 218.3 ms）；MoMark Skia GPU medium 187.9 ms（max 205.3 ms）；MoMark Skia GPU large 222.8 ms（max 228.6 ms）；MoMark Skia GPU stress 278.2 ms（max 309.7 ms）；MoMark WGPU small 30120.2 ms（max 30129.2 ms）；MoMark WGPU medium 30123.5 ms（max 30151.3 ms）；MoMark WGPU large 30129.3 ms（max 30134.7 ms）；MoMark WGPU stress 30223.0 ms（max 30224.9 ms）；GpMark.mbt (GPUI) small 113.2 ms（max 116.7 ms）；GpMark.mbt (GPUI) medium 114.1 ms（max 116.1 ms）；GpMark.mbt (GPUI) large 120.2 ms（max 122.1 ms）；GpMark.mbt (GPUI) stress 215.0 ms（max 219.8 ms）。
- P1 输入尾延迟：MoUI Skia Raster CPU small P95 36.09 ms；MoUI Skia Raster CPU medium P95 35.07 ms；MoUI Skia Raster CPU large P95 36.10 ms；MoUI Skia Raster CPU stress P95 28.54 ms；MoMark Skia Raster small P95 36.67 ms；MoMark Skia Raster medium P95 42.58 ms；MoMark Skia Raster large P95 40.42 ms；MoMark Skia Raster stress P95 36.25 ms；MoMark Skia GPU small P95 19.95 ms；MoMark Skia GPU medium P95 19.93 ms；MoMark Skia GPU stress P95 19.27 ms；MoMark WGPU stress P95 22.88 ms。
- 长帧（超预算）：MoUI Skia Raster CPU: small/input 26 次，max 36.34 ms, small/scroll 358 次，max 36.27 ms, medium/input 28 次，max 36.41 ms, medium/scroll 358 次，max 38.66 ms, large/input 29 次，max 38.36 ms, large/scroll 357 次，max 36.39 ms, stress/input 29 次，max 30.02 ms, stress/scroll 358 次，max 37.56 ms；MoMark Skia Raster: small/input 30 次，max 42.83 ms, small/scroll 360 次，max 57.49 ms, medium/input 30 次，max 44.47 ms, medium/scroll 360 次，max 48.61 ms, large/input 30 次，max 49.43 ms, large/scroll 360 次，max 48.41 ms, stress/input 30 次，max 36.62 ms, stress/scroll 360 次，max 47.27 ms；MoMark Skia GPU: small/input 2 次，max 20.00 ms, small/scroll 3 次，max 19.99 ms, medium/input 2 次，max 20.02 ms, medium/scroll 7 次，max 20.01 ms, large/scroll 3 次，max 20.01 ms, stress/input 29 次，max 20.47 ms, stress/scroll 4 次，max 20.01 ms；MoMark WGPU: small/scroll 296 次，max 20.19 ms, medium/scroll 284 次，max 20.36 ms, large/scroll 197 次，max 19.05 ms, stress/input 30 次，max 23.69 ms, stress/scroll 197 次，max 21.26 ms。
- 丢帧（优先处理）：MoUI Skia Raster CPU: small/input 31 帧, small/scroll 360 帧, medium/input 31 帧, medium/scroll 362 帧, large/input 31 帧, large/scroll 360 帧, stress/input 29 帧, stress/scroll 362 帧；MoMark Skia Raster: small/input 36 帧, small/scroll 590 帧, medium/input 39 帧, medium/scroll 544 帧, large/input 33 帧, large/scroll 517 帧, stress/input 58 帧, stress/scroll 557 帧；MoMark Skia GPU: small/input 2 帧, small/scroll 3 帧, medium/input 2 帧, medium/scroll 7 帧, large/scroll 3 帧, stress/input 30 帧, stress/scroll 4 帧；MoMark WGPU: small/scroll 299 帧, medium/scroll 293 帧, large/scroll 207 帧, stress/input 30 帧, stress/scroll 208 帧。
- 解释：首帧异常优先检查窗口/渲染器初始化；输入尾延迟检查 action 到下一可见帧的调度与同步重建；长帧检查解析、布局、文本 shaping 和 GPU 提交；`n/a` 表示未埋点，不等于 0。
- 普通模式的长帧、帧间隔和输入延迟是各框架回调诊断，不能替代跨框架 compositor 排名；需要严格结论时运行 `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`。

## 采集口径

- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。
- `frame_work_ms` 统一为框架 CPU 侧帧生产工作，不含设备光栅化与上屏；对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `device_present_ms`：设备/上屏侧统一字段。MoUI raster 为 Skia CPU 光栅化+像素回读整体；MoUI GPU/wgpu 为提交后同步等待设备完成（headless host-surface 逐帧同步，真实应用的 vsync 流水线可重叠掉一部分，该值应视为上屏成本上界）；窗口模式（`window_mode=native-window`）下 MoUI 由真实 AppKit 窗口上屏，适配器侧不单独计时，显示 `n/a`；Flutter 为 `FrameTiming.rasterDuration`（光栅线程任务时间，含显示列表光栅化与 GPU 提交、不含设备完成等待）；GPUI 与 Electron 适配器侧无法观测，显示 `n/a`。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧，统一口径为「进程起点 → 首帧可交互」（全包含）：MoUI 在 main 入口打点（含渲染器构建，headless 无平台窗口成本）；Flutter 优先取 runner 在进程起点打点的 epoch（env 缺失时退回 Dart 最早时刻，Flutter 引擎与原生窗口创建计入）；Electron 取 main.js 首个 JS 时刻（Chromium 主进程初始化、窗口创建与页面加载计入）；GPUI 从 MoonBit main 入口打点（AppKit 初始化、Metal 渲染器与首帧计入）。打开场景没有前一帧，所以不计算 interval/drop。严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代。
- 跨框架比较注意：MoUI/MoMark 系列与 Flutter/Electron/GPUI 现默认同为原生窗口（native-window）模式，时钟同为进程起点 → 首帧可交互；旧 headless host-surface 模式可用 `UI_BENCHMARK_HEADLESS=1` 复现（无真实窗口/合成器成本，帧间隔为未同步的帧生产耗时，与窗口模式的 vsync 间隔语义不同）。GPUI 另可用 `GPUI_OPEN_TRACE=1` 输出启动分相（应用初始化 / 窗口创建 / 首帧）。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。
