# Markdown 编辑器跨框架基准仓库 — 完整测试报告

| 项目 | 值 |
| --- | --- |
| 报告生成时间 | 2026-09-11（UTC 13:14–13:41） |
| 被测提交 | `06aa3723a50dc51ffeae3b16aa46805e23107e61`（`chore(deps): update momark and MoUI submodules`） |
| 主机 | Apple M4 / 10 核 / 16 GiB / arm64 |
| 操作系统 | macOS 26.3（build `25D125`） |
| 测试范围 | 单元与集成测试、静态检查、无头基准冒烟、UI 基准冒烟、完整 10 适配器 UI 性能基准 |
| 结论 | **558 / 558 用例通过、0 失败；基准 417 格全部 `measured`、0 `error`。** 发现 6 项工程问题（无功能性阻塞），详见第 7 节。 |

---

## 1. 结论摘要

本次执行覆盖了仓库 `.github/workflows/ci.yml` 定义的全部关卡，并在此基础上补齐了 CI 未覆盖的两个测试包（`momark/app`、`gpmark/adapter`），以及三级基准测试。

| 层级 | 内容 | 结果 |
| --- | --- | --- |
| L1 单元/集成测试 | 12 项套件、558 个用例 | ✅ 全部通过 |
| L2 静态检查 | MoonBit `check` ×3、`flutter analyze`、`node --check` ×4、`cargo check` | ✅ 0 error |
| L3 基准冒烟 | 无头 27 格 + UI 30 格 | ✅ 0 error |
| L4 完整 UI 基准 | 10 适配器 × 4 fixture × 3 场景 × 3 重复 = 360 格 | ✅ 360/360 `measured` |

**关键结论：**

1. 所有被测实现（MoUI ×3、MoMark ×3、GpMark.mbt、Flutter ×2、Electron）在 1280×800 视口下、从小文件到 5 MB / 100,000 块的 Stress fixture 均可正常打开、输入与滚动，**无崩溃、无超时、无协议校验失败**。
2. 循环内（input / scroll）性能稳定：绝大多数适配器帧间隔贴近 60 Hz 刷新周期；在会报告丢帧的适配器中，三种 fixture 合计仅 **1 帧**丢帧，其余适配器不埋点丢帧（`n/a`）。
3. 主要性能风险集中在 **open 首帧** 与 **Stress 档的输入尾延迟**，且集中在 MoMark 示例应用与 GpMark.mbt 两条路径，详见 6.4 / 6.5。
4. 发现一项 **CI 覆盖缺口**：558 个测试用例中有 465 个（**83.3%**）未被 CI 门禁保护，详见 7.2。

---

## 2. 测试环境

```
== OS ==        macOS 26.3 (25D125), arm64
== CPU ==       Apple M4, 10 cores
== MEM ==       16 GiB
== python ==    3.12.11
== node ==      v25.2.1 / npm 11.6.2
== rust ==      rustc 1.94.0 (4a4ef493e 2026-03-02)
                cargo 1.94.0 (85eff7c80 2026-01-15)
== moon ==      moon    0.1.20260824 (dae026a 2026-08-24)
                moonc   v0.10.10+f8a486b6f (2026-08-21)
                moonrun 0.1.20260824 (dae026a 2026-08-24)
== flutter ==   Flutter 3.47.1 • channel stable • revision 6655482ec0
                Engine 11d79658c444477b06513d32b52c8c4ccb7276b0
                Tools • Dart 3.13.1
```

工具链版本与仓库中既有的受审捕获（`results/macos-arm64-ui.json`，2026-09-06）完全一致，因此本次数字与历史捕获可直接对照。

原始记录见 `results/test-report-20260911/00-environment.log`。

### 2.1 基准统一口径

- 视口 `1280×800 @ 60 Hz`，帧预算 `16.667 ms`
- 字体 `system-ui 16px`，行高 `1.55`，overscan `3`，固定行高 `66px`
- 每格 repetition = 3，process warm-up = 1；另有 1 次 action 级 warm-up
- fixture：`small 5KB/100 blocks`、`medium 50KB/1,000 blocks`、`large 500KB/10,000 blocks`、`stress 5MB/100,000 blocks`
- `comparison_mode = framework-callback-diagnostic`（**非** compositor 时钟）

聚合口径与 `bench/report.py` 完全一致：**mean / P95 由各 repetition 的原始样本池化后计算**（不是对每格百分位再取平均），丢帧为各 repetition 之和。本报告第 6 节所有数字均由 `bench/report.py` 的同一组函数导出。

---

## 3. 测试矩阵与执行结果

| # | 套件 | 执行命令 | 用例 | 结果 | 退出码 |
| --- | --- | --- | ---: | --- | ---: |
| 1 | Python 基准协议 | `python3 -m unittest discover -s bench -v` | 32 | ✅ 32/32（2.06 s） | 0 |
| 2 | MoUI app 检查 | `moon check moui/app --target native` | — | ✅ 2 warnings / 0 errors | 0 |
| 3 | MoUI app 测试 | `moon test moui/app --target native` | 7 | ✅ 7/7 | 0 |
| 4 | MoMark app 检查 | `moon check momark/app --target native` | — | ✅ 5 warnings / 0 errors | 0 |
| 5 | MoMark app 测试 | `moon test momark/app --target native` | 434 | ✅ 434/434 | 0 |
| 6 | GpMark 检查 | `cd gpmark && moon check core adapter --target native` | — | ✅ 27 warnings / 0 errors | 0 |
| 7 | GpMark core 测试 | `cd gpmark && moon test core --target native` | 49 | ✅ 49/49 | 0 |
| 8 | GpMark adapter 测试 | `cd gpmark && moon test adapter --target native` | 31 | ✅ 31/31 ※ | 0 |
| 9 | Rust GPUI 绑定 | `cargo check --manifest-path gpmark/third_party/gpui-moonbit/gpui-sys/Cargo.toml` | — | ✅ Finished in 4.20 s | 0 |
| 10 | Flutter 静态分析 | `cd flutter && flutter analyze` | — | ✅ No issues found (3.7 s) | 0 |
| 11 | Flutter 测试 | `cd flutter && flutter test` | 5 | ✅ 5/5 | 0 |
| 12 | Electron 检查 | `npm test --prefix electron` | — | ✅ 4 个文件语法检查通过 | 0 |

### 3.1 用例总数

| 类别 | 用例数 | 通过 | 失败 |
| --- | ---: | ---: | ---: |
| Python（基准协议） | 32 | 32 | 0 |
| MoonBit（moui + momark + gpmark） | 521 | 521 | 0 |
| Dart（Flutter widget） | 5 | 5 | 0 |
| **合计** | **558** | **558** | **0** |

> Rust `cargo check`、`flutter analyze`、`node --check` 属静态检查，不计入用例数。

---

## 4. 逐套件结果

### 4.1 Python 基准协议测试（32 用例）

覆盖 `bench/run_benchmark.py` 与 `bench/report.py` 的协议契约，全部通过：

- **适配器协议**：多 scope 输出、适配器自报名称权威性、环境变量透传、error 状态不被重标为 measured。
- **ui-frame 校验**：payload 形状、非有限样本拒绝、非 input 场景拒绝 input 延迟、startup proxy 可选。
- **严格模式**：system trace 采样、目标 surface 过滤、丢帧计数容忍时间戳抖动、surface 无法关联时拒绝；严格报告**不回退**到框架回调间隔。
- **报告层**：error 行保持表形、原始样本池化计算百分位。
- **trace 临时区**：scratch 在异常/适配器缺失时仍被清理、按 age 清理仅回收本会话产物、`--prune-scratch-only` 不会误删。
- **显示锁**：macOS 控制台锁屏时在启动前拒绝严格用例。
- **fixture 契约**：字节/块数与 `MANIFEST.tsv` 一致。

原始日志：`results/test-report-20260911/01-python-protocol-tests.log`

> **副作用提示**：`test_runner_schema_with_no_commands` 会写入 `results/test.json`，导致工作区变脏。本次已在测试后 `git checkout` 还原。建议改进见 7.5。

### 4.2 MoUI 应用（7 用例）

`moon check` 2 条告警、0 错误；`moon test` 7/7 通过。

原始日志：`02-moui-app-check.log`、`02-moui-app-test.log`

### 4.3 MoMark 应用（434 用例）

仓库中最大的测试集（49 个 `*_wbtest.mbt` 文件），覆盖编辑器运行时、命令树、输入规则、快照解析/格式化、查找、折叠、大纲、文件侧栏、剪贴板、表格键盘等。`moon check` 5 条告警、0 错误；`moon test` 434/434 通过。

原始日志：`03-momark-app-check.log`、`03-momark-app-test.log`

> ⚠️ 这 434 个用例**未被 CI 执行**，见 7.2。

### 4.4 GpMark.mbt（core 49 + adapter 31）

- `moon check core adapter`：27 条告警、0 错误。
- `moon test core`：49/49 通过（`unit`、`edit`、`history`、`mdparse`、`rules`）。
- `moon test adapter`：31/31 通过 ※

※ **重要说明**：在默认的 `workspace-write` 文件沙箱下，`gpmark/adapter` 会**误报 1 个失败**：

```
[mdmbt/adapter] test file_wbtest.mbt:20 ("open_path 读取替换文档；save_current_file 回写；tilde 展开")
  failed: file_wbtest.mbt:24:3-24:18@mdmbt/adapter FAILED: `false` is not true
Total tests: 31, passed: 30, failed: 1.
```

根因已定位并验证。该用例第 22–24 行在 `$HOME` 下创建临时文件：

```moonbit
let path = home_dir() + "/mdmbt_open_wbtest.md"
let ok = write_text(path, "# 打开的文件\n\n正文内容。\n")
assert_true(ok)
```

而 `write_text`（`gpmark/adapter/app.mbt:393`）把写失败静默吞成 `false`：

```moonbit
fn write_text(p : String, s : String) -> Bool {
  @fs.write_string_to_file(p, s) catch { _ => return false }
  true
}
```

沙箱下对 `$HOME` 的写入被拒绝（`Operation not permitted`），于是断言失败。放开文件权限后重跑同一命令，**31/31 全部通过** —— 因此这是**环境产物，不是产品缺陷**。

两份日志均保留：`04-gpmark-adapter-test-sandboxed.log`（沙箱下失败）、`04-gpmark-adapter-test.log`（完整权限下通过）。

### 4.5 Rust GPUI 绑定

```
Compiling gpui-sys v0.1.0 (.../gpui-moonbit/gpui-sys)
Finished `dev` profile [unoptimized + debuginfo] target(s) in 4.20s
```

链接阶段存在已知告警（见 7.6）：`libgpui_sys.a` 中大量目标文件按 macOS 26.2 构建，而 MoonBit 侧按 26.0 链接；在 26.3 主机上可正常链接运行。

### 4.6 Flutter（analyze + 5 用例）

```
flutter analyze  →  No issues found! (ran in 3.7s)
flutter test     →  +5: All tests passed!
```

5 个 widget 用例：可编辑 span 与源文本逐字一致、渲染格式化编辑器、编辑使文档标记为 dirty、切换块复用 controller、长文档滚动时延迟构建后续块。

> ⚠️ 在默认沙箱下 Flutter **完全无法构建/测试**，需放宽文件权限，见 7.4。执行时通过 `CI=true FLUTTER_SUPPRESS_ANALYTICS=true` 关闭遥测写入。

原始日志：`08-build-flutter.log`（含沙箱下失败证据）

### 4.7 Electron

`npm test` 执行 4 个文件的语法检查，全部通过：

```
node --check main.js && node --check preload.js && node --check renderer.js && node --check benchmark.js
```

`npm ci --prefix electron` 成功（15 packages / 4 s / 0 vulnerabilities），Electron 运行时与 Vditor 3.11.3 资源就绪。

原始日志：`07-electron-test.log`

---

## 5. 静态检查与告警汇总

| 套件 | warnings | errors | 主要类别 |
| --- | ---: | ---: | --- |
| `moon check moui/app` | 2 | 0 | `unused_field` ×1、`unused_value` ×1 |
| `moon check momark/app` | 5 | 0 | `unused_value` ×4、`unused_field` ×1 |
| `moon check core adapter`（gpmark） | 27 | 0 | `deprecated` ×25、`unused_value` ×1、`reserved_keyword` ×1 |
| `flutter analyze` | 0 | 0 | — |
| `cargo check` | 链接期告警 | 0 | 见 7.6 |

**值得处理的几条：**

- `vendor/MoUI/moui/core/text_editing.mbt:91` — 字段 `length` 从未被读取（`unused_field`）。
- `vendor/MoUI/moui_richtext/rich_text_document_view.mbt:444` — 函数 `rich_text_document_view_insert_breaks` 未被使用（`unused_value`）。
- gpmark 中 `extend : Bool` 字段名触发 `reserved_keyword` 告警（MoonBit 保留该词供未来使用），建议改名。
- 25 条 `deprecated` 集中在测试文件与 `adapter/hit.mbt`：`.is_none()` → `x is None`、`k.to_float()` → `Float::from_int`、`line.substring(...)` → `str[:]`。

以上均为**非阻塞**告警，不影响构建与测试结果。

---

## 6. 基准测试结果

### 6.1 无头诊断冒烟（CI 对齐）

等价于 CI 的 `Small benchmark smoke test`：`--fixture small --repetitions 1 --warmups 0`，6 个 headless 适配器。

| 指标 | 值 |
| --- | --- |
| measured | **27** |
| skipped | 12 |
| error | **0** |

12 条 `skipped` 全部来自 `bench/run_benchmark.py` 的内置默认适配器（`moui-wgpu`、`moui-md-skia-raster`、`moui-md-skia-gpu`、`moui-md-wgpu`，各 3 场景）。它们不在无头命令的适配器清单内、可执行文件不可用，按协议如实记为 `skipped` 而非 `error` —— 这正是 `docs/limitations.md` 约定的行为。

产出：`results/test-report-20260911/headless-smoke.json` / `.md`

> 无头 `headless-render` / `richtext-full` / `wysiwyg-full` 是解析器与分块基线，**不可**与 `ui-frame` 行比较。

### 6.2 UI 基准冒烟

命令：`UI_BENCHMARK_REPETITIONS=1 UI_BENCHMARK_WARMUPS=0 ./scripts/run_ui_benchmark.sh --fixture small --fail-on-error`

| 指标 | 值 |
| --- | --- |
| measured | **30 / 30** |
| skipped / error | **0 / 0** |

10 个桌面适配器 × 3 场景 × `small`，`--fail-on-error` 未触发。

产出：`results/test-report-20260911/ui-smoke.json` / `.md`

### 6.3 完整 UI 基准（360 格）

命令：`./scripts/run_ui_benchmark.sh`（默认 3 repetition + 1 process warm-up，全部 4 个 fixture）

| 指标 | 值 |
| --- | --- |
| 记录总数 | **360** |
| measured | **360** |
| skipped / error | **0 / 0** |
| 墙钟耗时 | **5 min 17 s** |
| 生成时间 | `2026-09-11T13:41:02Z` |

矩阵构成：10 适配器 × 4 fixture × 3 场景 = 120 格，每格 3 次重复 = 360 条记录。

| 维度 | 分布 |
| --- | --- |
| `measurement_scope` | `ui-frame` × 360 |
| `window_mode` | `headless-host-surface` × 216，`native-window` × 144 |
| 重复 / 预热 | `(3, 1)` × 360 |

10 个适配器：`moui-skia-raster`、`moui-skia-gpu`、`moui-wgpu`、`moui-md-skia-raster`、`moui-md-skia-gpu`、`moui-md-wgpu`、`gpmark`、`flutter-skia`、`flutter-impeller`、`electron`。

产出：`results/test-report-20260911/ui-full.json` / `.md`

### 6.4 关键性能数据

以下三张表均由 `bench/report.py` 的池化口径导出，顺序为 small / medium / large / stress。

**表 A：滚动帧间隔（`frame_interval_ms`）**

| 实现 | 均值（ms） | P95（ms） | 丢帧（合计） |
| --- | --- | --- | ---: |
| MoUI Skia Raster CPU | 1.20 / 1.29 / 1.19 / 1.24 | 1.30 / 1.53 / 1.30 / 1.36 | n/a |
| MoUI Skia GPU | 8.34 / 8.33 / 8.35 / 8.33 | 9.20 / 9.16 / 9.24 / 9.10 | n/a |
| MoUI WGPU | 8.33 / 8.34 / 8.34 / 8.38 | 9.53 / 9.54 / 9.70 / 9.65 | n/a |
| MoMark Skia Raster | 3.77 / 3.81 / 3.78 / 3.78 | 4.14 / 4.13 / 4.17 / 4.13 | n/a |
| MoMark Skia GPU | 9.03 / 8.66 / 8.65 / 8.70 | 11.39 / 10.18 / 9.92 / 10.15 | n/a |
| MoMark WGPU | 10.12 / 10.36 / 8.37 / 8.35 | **26.34 / 25.66** / 9.47 / 9.27 | n/a |
| GpMark.mbt (GPUI) | 9.94 / 9.97 / 9.98 / 9.95 | 10.48 / 10.82 / 10.48 / 10.49 | n/a |
| Flutter Skia | 9.97 / 10.00 / 10.00 / 10.00 | 10.00 / 10.00 / 10.00 / 10.00 | 0 / 0 / 0 / 0 |
| Flutter Impeller | 10.00 / 10.00 / 10.00 / 9.97 | 10.00 / 10.00 / 10.00 / 10.00 | **1** / 0 / 0 / 0 |
| Electron | 9.92 / 9.96 / 9.94 / 9.95 | 10.90 / 10.60 / 10.80 / 10.90 | 0 / 0 / 0 / 0 |

> MoUI 与 GpMark 适配器不埋点 `dropped_display_frames`，故为 `n/a`（表示**未采集**，不是 0）。

**表 B：打开首帧（`first_interactive_ms` 均值）**

| 实现 | small | medium | large | stress |
| --- | ---: | ---: | ---: | ---: |
| MoUI Skia Raster CPU | 57.52 | 48.99 | 50.20 | 66.17 |
| MoUI Skia GPU | 53.33 | 52.23 | 53.70 | 70.80 |
| MoUI WGPU | 50.13 | 50.41 | 51.61 | 68.61 |
| MoMark Skia Raster | 69.40 | 68.34 | 79.70 | **189.17** |
| MoMark Skia GPU | 87.90 | 96.73 | 106.87 | **226.25** |
| MoMark WGPU | 70.77 | 71.94 | 73.04 | **180.30** |
| GpMark.mbt (GPUI) | **123.04** | **113.31** | **118.59** | **143.15** |
| Flutter Skia | 29.72 | 25.17 | 30.93 | 66.43 |
| Flutter Impeller | 28.19 | 30.92 | 33.93 | 62.40 |
| Electron | 82.57 | 79.30 | 79.97 | 89.03 |

**表 C：输入到可见延迟（`input_to_visible_ms`）**

| 实现 | 均值（ms） | P95（ms） |
| --- | --- | --- |
| MoUI Skia Raster CPU | 1.29 / 1.29 / 1.43 / 3.47 | 1.42 / 1.42 / 1.63 / 4.24 |
| MoUI Skia GPU | 8.36 / 8.24 / 8.36 / 8.34 | 9.13 / 8.90 / 9.15 / 8.93 |
| MoUI WGPU | 8.22 / 8.20 / 8.19 / 8.24 | 10.02 / 10.02 / 9.97 / 9.28 |
| MoMark Skia Raster | 5.28 / 5.63 / 8.42 / 19.88 | 5.49 / 6.54 / 7.92 / **20.61** |
| MoMark Skia GPU | 8.51 / 8.70 / 10.51 / 22.25 | 9.49 / 9.57 / **17.39** / **25.71** |
| MoMark WGPU | 8.18 / 8.39 / 8.18 / 19.35 | 10.25 / 10.05 / 9.92 / **20.33** |
| GpMark.mbt (GPUI) | 9.18 / 9.23 / 9.56 / 10.64 | 11.02 / 11.05 / 11.00 / 12.90 |
| Flutter Skia | 10.03 / 10.05 / 10.04 / 10.03 | 10.34 / 10.49 / 10.41 / 10.44 |
| Flutter Impeller | 10.03 / 10.05 / 10.03 / 10.04 | 10.50 / 10.69 / 10.49 / 10.35 |
| Electron | 8.76 / 8.92 / 8.93 / 8.66 | 10.80 / 10.90 / 10.60 / 11.10 |

### 6.5 报告自动识别的异常项（摘录自 `ui-full.md`）

- **P1 首帧（> 100 ms）**：MoMark Skia GPU stress 226.2 ms（max 230.0）；MoMark Skia Raster stress 189.2 ms（max 193.8）；MoMark WGPU stress 180.3 ms（max 183.8）；MoMark Skia GPU large 106.9 ms（max 108.3）；GpMark.mbt small 123.0（max 140.7）、medium 113.3（max 115.3）、large 118.6（max 124.2）、stress 143.2（max 145.3）。
- **P1 输入尾延迟（P95 超一帧预算）**：MoMark Skia GPU stress 25.71 ms、MoMark Skia Raster stress 20.61 ms、MoMark WGPU stress 20.33 ms、MoMark Skia GPU large 17.39 ms。
- **长帧（超 16.667 ms 预算）**：MoMark WGPU small/scroll 32 次（max 29.58 ms）、medium/scroll 35 次（max 49.62 ms）；MoMark Skia Raster 与 Skia GPU 在 stress/input 各 30 次；MoUI WGPU stress/scroll 1 次（max 18.30 ms）；Flutter Skia large/input 1 次；Flutter Impeller small/scroll 1 次；Electron stress/input 1 次。
- **丢帧**：Flutter Impeller small/scroll 1 帧；Flutter Skia large/input 1 帧；Electron stress/input 1 帧 —— 合计 3 帧。

### 6.6 与上一次受审捕获的对照

将本次 `ui-full.json` 与 `results/macos-arm64-ui.json`（2026-09-06）在 120 个共同单元格上按同一池化口径对比，循环内指标整体改善：

| 单元格 | 上次 | 本次 | 变化 |
| --- | ---: | ---: | ---: |
| moui-md-wgpu small scroll | 22.89 ms | 10.12 ms | **−56%** |
| moui-md-wgpu stress scroll | 22.97 ms | 8.35 ms | **−64%** |
| moui-md-wgpu small input | 18.80 ms | 8.18 ms | **−56%** |
| moui-skia-raster small scroll | 2.18 ms | 1.20 ms | −45% |
| moui-skia-raster small input | 2.25 ms | 1.29 ms | −43% |
| moui-md-skia-raster stress input | 28.38 ms | 19.88 ms | −30% |
| moui-md-skia-gpu stress input | 29.69 ms | 22.25 ms | −25% |
| gpmark small input | 12.71 ms | 9.18 ms | −28% |
| gpmark stress input | 16.19 ms | 10.64 ms | −34% |
| flutter-skia / flutter-impeller / electron（8 格） | — | — | −3% ~ +4%（噪声级） |
| moui-md-skia-gpu small scroll | 8.38 ms | 9.03 ms | +8% |

> ⚠️ 两次捕获之间 `momark` 与 `MoUI` 子模块均有提交（soft-break 渲染、段落切分、空行输入、调度修复等），因此这是**版本间对照，不是纯 A/B 回归实验**，改善同时包含代码变更与测量噪声。`moui-md-wgpu` 的大幅改善与子模块的调度修复提交一致。

---

## 7. 缺陷、风险与改进建议

按严重度排序。**未发现功能性阻塞缺陷**；以下均为工程/流程问题。

### 7.1 沙箱环境下 `gpmark/adapter` 误报失败（中）

- **现象**：`workspace-write` 沙箱下 `moon test adapter` 报 30/31。
- **根因**：用例在 `$HOME` 下创建临时文件，沙箱拒绝写入；`write_text` 把异常吞成 `false`，断言只看到 `false`，真实原因丢失。
- **验证**：完整文件权限下重跑 31/31。
- **建议**：
  1. 让 `write_text` 返回 `Result[Unit, String]`，或在测试中显式区分「写入被拒」与「内容不符」；
  2. 测试临时文件改用 `TMPDIR` / `TEMP` 解析而非硬编码 `$HOME`（当前注释说明为兼容 Windows runner 才放 home 下，可用 `@fs` 的临时目录能力替代）。

### 7.2 CI 覆盖缺口：465 个用例无门禁（中高）

`.github/workflows/ci.yml` 的 MoonBit 步骤只执行：

```sh
moon check moui/app --target native
moon test  moui/app --target native
cd gpmark && moon check core adapter --target native && moon test core --target native
```

对照本次执行结果：

| 测试包 | 用例数 | CI 是否执行 |
| --- | ---: | --- |
| `moui/app` | 7 | ✅ 是 |
| `gpmark/core` | 49 | ✅ 是 |
| `momark/app` | 434 | ❌ 否（`ci.yml` 中未出现 `momark`） |
| `gpmark/adapter` | 31 | ❌ 否（只 `check`，不 `test`） |

即 **465 / 558 = 83.3% 的用例不受 CI 保护**，其中 `momark/app` 是仓库最大的单包测试集，且正是 `moui-md-*` 基准行所使用的官方示例应用。

- **建议**：在 CI 中追加 `moon test momark/app --target native` 与 `cd gpmark && moon test adapter --target native`（后者需先解决 7.1 的临时文件问题，否则在 CI 沙箱中同样会误报）。

### 7.3 `run_ui_benchmark.sh` 在 macOS 上总是重跑 `npm ci`（低）

`scripts/run_ui_benchmark.sh:75` 的跳过判断使用了 Windows 专用文件名：

```sh
if [ -f "$ROOT/electron/node_modules/electron/dist/electron.exe" ] && ...
```

macOS 下 `electron/dist/` 的内容是 `Electron.app`、`LICENSE`、`LICENSES.chromium.html`、`version`，**不存在 `electron.exe`**，因此该分支恒为假，包装脚本每次都会执行 `npm ci` —— 包括 CI（CI 已在更早步骤执行过一次）。

- **影响**：每次基准运行多一次网络安装；离线或 registry 不可达时会让整条基准链直接失败，而这正是脚本注释想避免的场景。
- **建议**：改按平台判断（macOS 用 `electron/dist/Electron.app`），或只检查 `electron/node_modules/electron/path.txt` 与 `electron/node_modules/vditor/dist/index.min.js` 一类的跨平台标志文件。

### 7.4 Flutter 工具链要求工作区外的文件写入（中）

在默认 `workspace-write` 沙箱下，Flutter 全链路失败：

1. `flutter pub get` / `analyze` / `test`：
   `Cannot delete file, path = '/Users/zc/.dart-tool/dart-flutter-telemetry.log' (Operation not permitted)`
   → 可通过 `CI=true FLUTTER_SUPPRESS_ANALYTICS=true` 规避。
2. `flutter build macos --profile`：Xcode Swift Package Manager 需要写
   `~/Library/Caches/org.swift.swiftpm/manifests/...`
   → **无环境变量可规避**，必须放宽文件权限。

- **影响**：任何在受限文件沙箱中运行的自动化（CI 沙箱、agent 沙箱、容器只读 home）都会在 Flutter 构建阶段中断。
- **建议**：在 `docs/build-and-run.md` 记录该前置条件；若需在沙箱内构建，可为项目关闭 Swift Package Manager 集成或显式设置 SPM 缓存目录。
- **备注**：仓库内 `.tools/flutter` 提供了工作区内的 SDK 副本，可解决 SDK 自身 cache 的写入问题，但解决不了 `~/Library/Caches` 与 `~/.dart-tool`。

### 7.5 测试套件污染工作区（低）

`bench/test_benchmark.py::test_runner_schema_with_no_commands` 会实际执行 runner 并写入 `results/test.json`，使 `git status` 变脏（本次差异：+2 / −11 行）。

- **建议**：把该用例的 `--out` 指向 `tempfile.TemporaryDirectory()`。

### 7.6 链接期告警（低，已知）

1. MoonBit 运行时静态库：
   `warning: input verification failed ... libruntime.a(runtime-backtrace.o / runtime-env.o / runtime-runtime.o)`
   —— 仅在需要重新链接时出现，不影响产物运行。
2. GpUI：`libgpui_sys.a` 中大量对象按 macOS 26.2 构建，而 MoonBit 侧按 26.0 链接。应用在 macOS 26.3 上链接运行正常，但**不声称兼容更早的 macOS**（`docs/limitations.md` 已记录）。

### 7.7 基准层面的风险与观察（信息性）

1. **MoMark WGPU 的滚动抖动**：small / medium 档帧间隔 P95 达 26.34 / 25.66 ms，长帧 32 / 35 次，与同应用 Skia 路径（P95 ≈ 10 ms）差距明显，值得单独排查。
2. **MoMark 与 GpMark 的首帧成本**：MoMark 在 stress 档达 180–226 ms；GpMark 四档均 > 110 ms，相对 Flutter / Electron 的 25–89 ms 偏高。
3. **跨框架可比性边界**：本次为 `framework-callback-diagnostic` 模式，框架回调时钟**不等价**于 compositor present。需要严格结论时必须运行
   `UI_BENCHMARK_SYSTEM_TRACE=1 ./scripts/run_ui_benchmark.sh`（要求 macOS 控制台处于解锁状态）。本报告中的跨框架数字**不构成**端到端显示延迟的排序证明。
4. `n/a` 一律表示**未埋点**，绝不等同于 0。带 `†` 的框架内部诊断列不可跨框架相除。
5. 未执行 Windows amd64 捕获（需真实 Windows 主机，见 `docs/windows.md`）；本报告结论仅适用于 macOS arm64。

---

## 8. 复现步骤

```sh
cd /Volumes/Data/Code/moon/md_editor

# --- L1 单元与集成测试 ---
python3 -m unittest discover -s bench -v
moon check moui/app --target native && moon test moui/app --target native
moon check momark/app --target native && moon test momark/app --target native
( cd gpmark && moon check core adapter --target native \
             && moon test core --target native \
             && moon test adapter --target native )
cargo check --manifest-path gpmark/third_party/gpui-moonbit/gpui-sys/Cargo.toml
( cd flutter && flutter pub get && flutter analyze && flutter test )
npm test --prefix electron

# --- L3 无头冒烟（CI 对齐）---
python3 bench/run_benchmark.py --fixture small --repetitions 1 --warmups 0 \
  --adapter moui-skia-raster='MOUI_SKIA_RENDERER=skia-raster moon run moui/benchmark --target native --release -- {fixture} {scenario}' \
  --adapter moui-skia-gpu='MOUI_SKIA_RENDERER=skia-gpu moon run moui/benchmark --target native --release -- {fixture} {scenario}' \
  --adapter gpmark='python3 bench/adapters/gpmark/benchmark.py {fixture} {scenario}' \
  --adapter flutter-skia='FLUTTER_RENDERER=skia dart run flutter/tool/benchmark.dart {fixture} {scenario}' \
  --adapter flutter-impeller='FLUTTER_RENDERER=impeller dart run flutter/tool/benchmark.dart {fixture} {scenario}' \
  --adapter electron='npm run --prefix electron benchmark -- {fixture} {scenario}' \
  --out results/headless-smoke.json --fail-on-error
python3 bench/report.py results/headless-smoke.json > results/headless-smoke.md

# --- L3 UI 冒烟 ---
UI_BENCHMARK_REPETITIONS=1 UI_BENCHMARK_WARMUPS=0 \
  ./scripts/run_ui_benchmark.sh --fixture small --fail-on-error

# --- L4 完整 UI 基准（360 格，约 5 分钟）---
./scripts/run_ui_benchmark.sh
```

**前置条件**

- 必须从**仓库根目录**执行 `moon` 命令，否则 `vendor/MoUI` 不会覆盖已发布版本（见 `docs/build-and-run.md`）。
- 复现本次 Flutter 结果需让 Flutter 能写入工作区外路径（7.4），并设置 `CI=true FLUTTER_SUPPRESS_ANALYTICS=true`；`flutter` 需在 `PATH` 上。
- 基准运行前保持机器空闲、关闭节能；视口固定 1280×800。

---

## 附录 A：证据文件清单

全部位于 `results/test-report-20260911/`。

| 文件 | 内容 |
| --- | --- |
| `00-environment.log` | 主机、OS、全部工具链版本 |
| `01-python-protocol-tests.log` | Python 协议测试全量 verbose 输出（32 用例） |
| `02-moui-app-check.log` | `moon check moui/app` |
| `02-moui-app-test.log` | `moon test moui/app`（7/7） |
| `03-momark-app-check.log` | `moon check momark/app` |
| `03-momark-app-test.log` | `moon test momark/app`（434/434） |
| `04-gpmark-check.log` | `moon check core adapter`（27 warnings） |
| `04-gpmark-core-test.log` | `moon test core`（49/49） |
| `04-gpmark-adapter-test-sandboxed.log` | 沙箱下 `moon test adapter`（30/31，环境产物） |
| `04-gpmark-adapter-test.log` | 完整权限下 `moon test adapter`（31/31） |
| `07-electron-test.log` | `npm test --prefix electron` |
| `08-build-moui.log` | `moon build moui/benchmark --release` |
| `08-build-gpmark.log` | `bench/adapters/gpmark/build.sh` |
| `08-build-flutter.log` | 沙箱下 Flutter 构建失败输出（7.4 证据） |
| `headless-smoke.json` / `.md` | 无头冒烟原始数据与报告（27 measured / 12 skipped） |
| `ui-smoke.json` / `.md` | UI 冒烟原始数据与报告（30/30） |
| `ui-full.json` / `.md` | **完整 UI 基准原始数据与报告（360/360）** |

## 附录 B：与 CI 的对应关系

| CI 步骤 | 本次是否执行 | 备注 |
| --- | --- | --- |
| `moon update` | 未单独执行 | 依赖已解析，构建成功 |
| `python3 scripts/generate_fixtures.py` | ✅（由基准脚本调用） | fixture 字节/块数与 MANIFEST 一致 |
| `python3 -m unittest discover -s bench -v` | ✅ | 32/32 |
| `moon check/test moui/app` | ✅ | 7/7 |
| `moon check core adapter` + `moon test core` | ✅ | 49/49 |
| `cargo check gpui-sys` | ✅ | OK |
| `flutter analyze` + `flutter test` | ✅ | 0 issues / 5 passed |
| `npm ci` + `npm test --prefix electron` | ✅（`npm ci` 由包装脚本执行） | OK |
| UI 冒烟 `--fixture small --fail-on-error` | ✅ | 30/30 |
| 无头冒烟 | ✅ | 27 measured |
| **额外补充** | ✅ | `momark/app` 434、`gpmark/adapter` 31、完整 UI 基准 360 格 |
