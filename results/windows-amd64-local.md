# Markdown editor benchmark report

- Schema：`md-editor-benchmark/v2`；生成时间：`2026-09-01T12:40:04Z`
- 数据状态：`243 measured`，`12 skipped/error`；原始样本保留在 JSON。
- Host：`Windows-11-10.0.26200-SP0` / `AMD64` / `15.89 GiB`；GPU：`AMD Radeon RX 7800 XT`
- OS：`11`；CPU：`AMD64 Family 25 Model 33 Stepping 2, AuthenticAMD`；toolchains：`python=3.12.10, moon=moon 0.1.20260824 (dae026a 2026-08-24), rustc=rustc 1.92.0 (ded5c06cf 2025-12-08), cargo=cargo 1.92.0 (344c4567c 2025-10-21), node=v22.20.0`
- 统一配置：`1280x800 @ 60 Hz`；font `system-ui 16px`；line-height `1.55`；overscan `3`；fixed row `66px`；GPU backend `Direct3D`
- Fixture：`small=5KB/100 blocks`，`medium=50KB/1,000 blocks`，`large=500KB/10,000 blocks`，`stress=5MB/100,000 blocks`。
- 本次执行集合：`small, medium, large, stress`；未执行集合在矩阵中显示 `n/a`，不参与比较。
- 汇总口径：mean/P95 合并原始样本；每格 repetition `3`、process warm-up `1`；drop 为各 repetition dropped_display_frames 之和。
- 公平性口径：所有 ui-frame 记录使用相同 fixture、viewport、动作数、warm-up 和重复次数；数值来自框架真实渲染/提交回调。MoUI ui-frame 是 headless host-surface；GPUI 的 frame work 覆盖 request_layout→prepaint→paint，action dispatch 另列为诊断字段。不同框架的显示时间戳由各自平台 API 提供，因此报告不做跨时钟的综合排名。`n/a` 表示没有采集，绝不等同于 0。

<details><summary>原始 ui-frame 汇总（可审计）</summary>

| 实现 | 测试集合 | 场景 | 范围 | 工作均值/P95 | 仅分发均值/P95 | 帧间隔均值/P95 | 输入到可见均值/P95 | 离屏均值 | 回读均值 | 首次可交互 | 丢帧数 | 状态 |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| moui-skia-raster | small | open | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-skia-raster | small | input | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-skia-raster | small | scroll | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-skia-raster | medium | open | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-skia-raster | medium | input | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-skia-raster | medium | scroll | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-skia-raster | large | open | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-skia-raster | large | input | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-skia-raster | large | scroll | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-skia-raster | stress | open | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-skia-raster | stress | input | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-skia-raster | stress | scroll | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-skia-gpu | small | open | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-skia-gpu | small | input | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-skia-gpu | small | scroll | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-skia-gpu | medium | open | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-skia-gpu | medium | input | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-skia-gpu | medium | scroll | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-skia-gpu | large | open | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-skia-gpu | large | input | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-skia-gpu | large | scroll | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-skia-gpu | stress | open | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-skia-gpu | stress | input | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-skia-gpu | stress | scroll | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-wgpu | small | open | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-wgpu | small | input | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-wgpu | small | scroll | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-wgpu | medium | open | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-wgpu | medium | input | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-wgpu | medium | scroll | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-wgpu | large | open | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-wgpu | large | input | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-wgpu | large | scroll | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-wgpu | stress | open | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-wgpu | stress | input | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| moui-wgpu | stress | scroll | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| gpui | small | open | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| gpui | small | input | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| gpui | small | scroll | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| gpui | medium | open | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| gpui | medium | input | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| gpui | medium | scroll | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| gpui | large | open | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| gpui | large | input | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| gpui | large | scroll | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| gpui | stress | open | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| gpui | stress | input | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| gpui | stress | scroll | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| flutter-skia | small | open | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| flutter-skia | small | input | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| flutter-skia | small | scroll | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| flutter-skia | medium | open | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| flutter-skia | medium | input | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| flutter-skia | medium | scroll | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| flutter-skia | large | open | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| flutter-skia | large | input | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| flutter-skia | large | scroll | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| flutter-skia | stress | open | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| flutter-skia | stress | input | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| flutter-skia | stress | scroll | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| flutter-impeller | small | open | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| flutter-impeller | small | input | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| flutter-impeller | small | scroll | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| flutter-impeller | medium | open | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| flutter-impeller | medium | input | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| flutter-impeller | medium | scroll | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| flutter-impeller | large | open | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| flutter-impeller | large | input | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| flutter-impeller | large | scroll | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| flutter-impeller | stress | open | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| flutter-impeller | stress | input | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| flutter-impeller | stress | scroll | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| electron | small | open | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| electron | small | input | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| electron | small | scroll | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| electron | medium | open | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| electron | medium | input | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| electron | medium | scroll | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| electron | large | open | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| electron | large | input | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| electron | large | scroll | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| electron | stress | open | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| electron | stress | input | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |
| electron | stress | scroll | ui-frame | - | - | - | - | n/a | n/a | n/a | n/a | n/a |

</details>

# 帧性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| GPUI | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Impeller | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Electron | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 |
| --- | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | n/a | n/a | n/a | n/a | n/a |
| MoUI Skia GPU | n/a | n/a | n/a | n/a | n/a |
| MoUI WGPU | n/a | n/a | n/a | n/a | n/a |
| GPUI | n/a | n/a | n/a | n/a | n/a |
| Flutter Skia | n/a | n/a | n/a | n/a | n/a |
| Flutter Impeller | n/a | n/a | n/a | n/a | n/a |
| Electron | n/a | n/a | n/a | n/a | n/a |

# 输入延迟

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） |
| --- | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| GPUI | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Impeller | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Electron | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |

## stress 5MB

| 实现 | 可见延迟均值（ms） | 可见延迟 P95（ms） | 工作均值（ms） | 工作 P95（ms） |
| --- | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | n/a | n/a | n/a | n/a |
| MoUI Skia GPU | n/a | n/a | n/a | n/a |
| MoUI WGPU | n/a | n/a | n/a | n/a |
| GPUI | n/a | n/a | n/a | n/a |
| Flutter Skia | n/a | n/a | n/a | n/a |
| Flutter Impeller | n/a | n/a | n/a | n/a |
| Electron | n/a | n/a | n/a | n/a |

# 打开性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| GPUI | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Impeller | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Electron | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |

## stress 5MB

| 实现 | 首次可交互均值（ms） | 首次可交互 P95（ms） | 工作均值（ms） | 工作 P95（ms） | 文档加载均值（ms） | 文档加载 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI Skia GPU | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI WGPU | n/a | n/a | n/a | n/a | n/a | n/a |
| GPUI | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Skia | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Impeller | n/a | n/a | n/a | n/a | n/a | n/a |
| Electron | n/a | n/a | n/a | n/a | n/a | n/a |

# 滚动性能

## small / medium / large

值顺序：small（5KB / 100 blocks）/ medium（50KB / 1,000 blocks）/ large（500KB / 10,000 blocks）

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 离屏均值（ms） | 离屏 P95（ms） | 回读均值（ms） | 回读 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI Skia GPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| MoUI WGPU | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| GPUI | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Skia | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Flutter Impeller | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |
| Electron | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a | n/a/n/a/n/a |

## stress 5MB

| 实现 | 工作均值（ms） | 工作 P95（ms） | 帧间隔均值（ms） | 帧间隔 P95（ms） | 丢帧数 | 离屏均值（ms） | 离屏 P95（ms） | 回读均值（ms） | 回读 P95（ms） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI Skia GPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| MoUI WGPU | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| GPUI | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Skia | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Flutter Impeller | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| Electron | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |

# 异常项与优化优先级

- 参考帧预算：`16.667 ms`（含 ±0.1 ms 量化容差）；长帧/输入尾延迟阈值为一帧预算；计时来源：框架回调诊断（非 compositor 时钟）。
- P1 首帧：未发现 >100 ms 的首帧。
- P1 输入尾延迟：未发现超过一帧预算的输入 P95。
- 长帧（超预算）：未发现超过一帧预算的间隔。
- 丢帧（优先处理）：未发现可测丢帧。
- 解释：首帧异常优先检查窗口/渲染器初始化；输入尾延迟检查 action 到下一可见帧的调度与同步重建；长帧检查解析、布局、文本 shaping 和 GPU 提交；`n/a` 表示未埋点，不等于 0。
- 普通模式的长帧、帧间隔和输入延迟是各框架回调诊断，不能替代跨框架 compositor 排名；需要严格结论时运行 `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`。

## 采集口径

- Metric definitions：严格模式的 `动作到显示` 为统一的系统 action marker 到目标 surface 下一次 compositor present；`system_present_interval_samples_ms` 为同一目标 surface 的相邻显示时间戳间隔。`frame_work_ms` 仍是适配器内部 phase 诊断，不能与系统 present 时间相加。
- `frame_work_ms` 对 GPUI 来自 request_layout→prepaint→paint 的真实元素包络；action dispatch 作为独立的 `dispatch_work_samples_ms` 诊断字段保留，不与绘制时间混合。
- `input_to_visible_ms`：普通模式是输入动作到框架可见帧；严格模式使用同一 xctrace 中的 `md_editor_action` os_signpost 与目标 surface 的下一次 compositor present，写入 `system_action_to_present_samples_ms`。适配器提供的 wall-clock action 时间戳只用于裁剪 trace 窗口，不参与延迟计算。`system_dropped_display_frames` 使用同一 trace 的 VSync 周期按四舍五入后的刷新槽位 `max(round(interval / frame_budget_ms) - 1, 0)` 计算，以容忍系统时间戳量化抖动。
- `first_interactive_ms` 是首个可交互帧；严格模式改为进程启动到首个目标 compositor present，不使用进程总耗时替代；打开场景没有前一帧，所以不计算 interval/drop。
- `offscreen_ms` / `readback_ms` 只展示被实际计时的阶段；严格系统 trace 不会把 renderer 的提交时间或 readback 时间当作 compositor present。未埋点阶段显示 `n/a`，实测无 CPU 工作才显示数值 `0`。
