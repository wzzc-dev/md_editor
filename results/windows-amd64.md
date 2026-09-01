# Windows amd64 测试报告

- 日期：`2026-09-01`
- 机器：Windows 11 专业版 25H2（`10.0.26200`）/ `AMD64`
- CPU：`AMD Ryzen 5 5600 6-Core Processor`；内存：`15.89 GiB`
- GPU：`AMD Radeon RX 7800 XT`（系统同时枚举 Oray / GameViewer / MuMu 虚拟显示器，采集时以 `GPU_MODEL` 显式指定真实 GPU）
- 显示：物理 `4096x2304 @ 144 Hz`，系统缩放 200%（有效 DPR 2.0）
- 结论：**官方 `ui-frame` 矩阵全量出数：7 个适配器 × 4 fixture × 3 场景 × 3 重复 = 252 条全部 `measured`、0 条 error**；headless 诊断 243 条 `measured`（另 12 条为 headless 协议不适用的 `moui-wgpu` 组合，与 macOS 口径一致）。MoUI 三适配器（`moui-skia-raster` / `moui-skia-gpu` / `moui-wgpu`）已移植出 Windows 变体 `moui/windows_benchmark` 并跑通（见“为在 Windows 上出数所做的修改”第 11-14 条）。

对应的数据文件（原始样本全部保留在 JSON）：

- UI 矩阵：[`windows-amd64-ui.json`](windows-amd64-ui.json) / [`windows-amd64-ui.md`](windows-amd64-ui.md)
- Headless 诊断：[`windows-amd64-local.json`](windows-amd64-local.json) / [`windows-amd64-local.md`](windows-amd64-local.md)

## 验收对照（docs/windows.md）

| 条件 | 本次结果 |
| --- | --- |
| `machine=AMD64` | 通过 |
| 内存约 16 GiB | 通过（15.89 GiB） |
| 真实 GPU | 通过（RX 7800 XT，Direct3D 路由） |
| `1280x800` viewport | 通过（全部 252 条记录 viewport 恰为 1280×800 逻辑像素） |
| `ui-frame` scope | 通过 |
| 无 skipped/error | 通过（252 条全 `measured`，0 error；MoUI headless 口径的 12 条 `moui-wgpu` 为协议不适用，非 error） |

## 工具链

| 工具 | 版本 |
| --- | --- |
| Python | 3.12.10（`C:\Program Files\Python312`；Windows Store 的 `python3` stub 用 PATH 前部的 `python3.exe` 副本屏蔽，否则子进程 `exit 9009`） |
| MoonBit | `moon 0.1.20260824 (dae026a)` |
| Rust | `rustc 1.92.0` / `cargo 1.92.0`，`x86_64-pc-windows-msvc` |
| Node / npm | v22.20.0 / 10.9.3 |
| Flutter | 3.47.2 stable，Dart 3.13.2（scoop） |
| 构建 | VS Community 2022 17.14.x，MSVC 14.44，Windows SDK 10.0.26100 |

## 功能测试结果

| 套件 | 结果 | 说明 |
| --- | --- | --- |
| Python 协议测试 `python -m unittest discover -s bench` | 25/26 通过 | 唯一失败是 macOS 锁屏严格 trace 预检，Windows 上不适用 |
| Fixture 字节契约 | 通过 | 5120 / 51200 / 512000 / 5242880 字节，LF |
| `moon test moui/app --target native` | 7/7 通过 | |
| Electron `npm test`（main/preload/renderer/benchmark 语法检查） | 通过 | |
| `flutter analyze` / `flutter test` | 通过 | analyze 无 issue，widget test 5/5 |
| `flutter build windows --profile` | 通过 | 含本报告下方的 Windows runner 修正 |
| GPUI `gpui/build.py`（vendor `gpui-moonbit` @ `9656fcf`） | 通过 | 产出 `gpui/dist/gpui-markdown-editor.exe` |
| MoUI `moui/windows_benchmark` 构建 | 通过 | 新增的 Windows 移植包；`scripts/build_moui_windows.sh` 两段式 MSVC 编译产出 `windows_benchmark.exe`（Skia-raster / Skia-gpu D3D12 / WGPU 三路径均出 ui-frame） |

## 为在 Windows 上出数所做的修改

以下改动均已落盘（git 工作区），是本轮验收得以完成的原因；上一轮报告中记录的阻塞点全部由此解除：

1. **GPUI vendor pin**：`gpui/vendor/gpui-moonbit` 工作树恢复到 superproject gitlink 记录的 `9656fcf`（含 `framework_dispatch_with_patch`；此前工作树被误停在 `10e1d06`），`gpui/app` 由此可编译，无需改任何 pin。
2. **`gpui/app/benchmark.mbt`**：原逻辑假设“FFI 返回即失败”（macOS 上 `cx.quit()` 直接终结进程不返回）。Windows 上事件循环正常退出并返回 0，被误判为失败后 `abort`。改为 `status == 0` 时 `exit(0)`（报告已由 Rust 侧 flush）。
3. **`gpui/ui_benchmark.py`**：Windows 构建是 GUI 子系统 PE，CRT `execv()` 不会把 harness 的管道句柄标记为可继承，JSON 报告静默丢失。改为 `subprocess.run()`（CreateProcess 正确传递句柄）。
4. **`flutter/windows/runner/main.cpp`（DPI）**：runner 以 `Win32Window::Size(1280, 800)` 创建窗口，在缩放下这是物理像素，Flutter 逻辑视口只有 1024×640，被协议门禁拒绝（旧报告的 exit 70）。改为创建后按 `GetDpiForWindow` + `AdjustWindowRectExForDpi` 调整窗口，使**客户区恰为 1280×800 逻辑像素**，任意缩放下都满足门禁。
5. **`flutter/windows/runner/main.cpp`（日志捕获）**：`AttachConsole(ATTACH_PARENT_PROCESS)` 在 stdio 已重定向时会把引擎日志抢回父控制台，包装器因此读不到渲染后端标记。改为仅在 stderr 未被重定向时才 attach。
6. **`flutter/ui_benchmark.py`（Skia 验证）**：Windows 引擎不打印 “Using the Skia rendering backend”；启用 Impeller 时才打印 “Using the Impeller rendering backend (…)”。Skia 运行改用反向验证（日志中不得出现 Impeller 标记），记录 `renderer_verification_source=windows-skia-negative-impeller-marker`；Impeller 仍为正向日志验证。
7. **`electron/main.js`（精确视口）**：`useContentSize: true` 在 Windows DPI 舍入下 CSS 视口落在 1282×802，被 `validate_ui_payload` 拒绝。基准模式先加载 `about:blank`，测得偏差后用线性求解 `setContentSize` 收敛到精确 1280×800（resize 事件不保证触发，故配 250ms 兜底定时器）。
8. **`electron/renderer.js`（滚动自检容差）**：DPR 2.0 下 Chromium 把 `scrollTop` 舍入到设备像素（实测 5919.2 vs 目标 5920），0.5px 容差误报 “scroll target was not applied”。容差改为 `max(1, 2/devicePixelRatio)` CSS px；仅放宽自检，不影响测量数据。
9. **`electron/ui_benchmark.py`（管道）**：libuv 拒绝 Python 为 `subprocess.PIPE` 使用的伪继承 std 句柄（报告静默消失）。改为真实 `os.pipe()` 捕获、读到第一条 `ui-frame` JSON 即停（Chromium 长活子进程持有写端，等 EOF 会死锁），随后最多等 30 秒收进程。
10. **环境**：`~/bin/python3.exe`（官方 python.exe 的副本，经注册表 App Paths 定位 stdlib）放在 PATH 前部，替代 Windows Store stub；否则 harness `Popen("python3")` 一律 `exit 9009`，8 个协议测试因此假失败。
11. **新增 `moui/windows_benchmark` 包**：`moui/benchmark` 的 moon.pkg 无条件导入 `@macos_backend`/CoreText 并把 Obj-C Metal stub 编进链接（cl 会忽略 `.m` 后在链接期报缺 obj），且本 moon 版本不支持按 OS 条件导入。按仓库既有约定（`macos_skia`/`windows_skia` 一包一平台 exe）新建 Windows 可执行包：复用同一 headless 分块/协议代码；Skia 路径经 `create_with_present_target_and_route(surface_route=direct3d)` 用 D3D12 Ganesh 光栅、CPU 像素帧呈现（该路线无公开 host-GPU surface API，如实报 readback 而非伪装 drawable）；WGPU 路径以新增 `benchmark_surface.c` 创建**每监视器 DPI 感知的隐藏 Win32 popup 窗口**，经 `surface_descriptor_windows_hwnd_new` 绑定 wgpu 的 D3D12 swapchain（与 macOS 离屏 CAMetalLayer 对应，presentation=host-gpu-surface，readback=0）；文本引擎换 DirectWrite（cosmic 兜底）。`UI_BENCHMARK_SYSTEM_PRESENT=1` 显式 abort（xctrace 是 macOS 专属，拒绝静默降级）。
12. **`moui/ui_benchmark.py`**：exe 候选表按 OS 选择（`benchmark` / `windows_benchmark`）；Windows Skia 启动要求 `icudtl.dat` 在 exe 目录旁（`SkLoadICU` 不认 `SK_ICU_DATA` 环境变量），包装器从 `vendor/MoUI/moui_skia/.skia-cache` 幂等拷贝；wgpu 运行时注入 `MBT_WGPU_NATIVE_ROOT` 指向 `.cache/wgpu-native-msvc`（`scripts/fetch_wgpu_native.ps1` 从官方 release 物化，见第 13 条）；Git-Bash 下 `os.execve` 对子进程段错误（与第 3 条同类的句柄传递问题），Windows 分支改 `subprocess.run`。
13. **`moui/moon.mod.json` + 两段式 MSVC 编译（`scripts/build_moui_windows.sh`）**：`Milky2018/wgpu_mbt@0.14.8` 使用原版包，包源码零修改。两个 Windows 问题都不动包源码解决：(a) 其 win32 静态构件是 GNU ABI（libgcc unwind / mingw 导入符号），MSVC 链接器不可消费 → 走它官方支持面内的动态链接模式 `MBT_WGPU_LINK_MODE=dynamic`（wgpu shim 本就支持 LoadLibrary 动态加载），MSVC 版 `wgpu_native.dll`（v29.0.1.1，与包 pin 一致）放 `native/windows/`；(b) 其 C stub 不带 `/std` flag，MSVC 的 C11 原子门报 C1189，而 `moui_skia` 的 C++ stub 经包级 flag 钉死 `/std:c++20`，两个 `/std` 在同一 cl 命令行互斥（D8016）→ 按**编译轮次**切分 flag 集：pass 1（无 `CL`）编 `windows_skia`（闭包不含 wgpu_mbt），编完全部 C++ stub；pass 2（`CL=/std:c11 /experimental:c11atomics`）编 `windows_benchmark`，增量只剩 wgpu_mbt 的 `.c` stub 与基准包本身，C11 旗标只命中纯 C 编译。两种失败模式都是响的：pass 1 不新鲜时单跑裸构建立报 C1189；若未来有 C++ 对象落入 pass 2 立报 D8016，不存在静默混 flag 出包。模块文件维持仓库原版 `moui/moon.mod`（零改动，本就 pin `Milky2018/wgpu_mbt@0.14.8`）；vendoring 已彻底移除：注册表缓存恢复后先做了逐字节核对（注册表包与回退后的 vendored 副本源码全树一致，含 `build.js`），随后切回版本号依赖（moon 从全局注册表缓存离线解包 0.14.8），`vendor/wgpu_mbt/` 目录删除，运行时 dll 迁至 `.cache/wgpu-native-msvc`（gitignored），由 `scripts/fetch_wgpu_native.ps1` 从 gfx-rs/wgpu-native `v29.0.1.1` 官方 release 物化。注意 moon 会按对象记录 `CL` 环境：pass 2 之后一切会编译 windows_benchmark 闭包的 moon 调用（含矩阵惰性的 `moon run`）必须携带同一 `CL=/std:c11 /experimental:c11atomics` + `MBT_WGPU_LINK_MODE=dynamic` + `MBT_WGPU_NATIVE_ROOT` 环境，裸调用会失效 wgpu 的 C 对象并响亮报 C1189，重跑 helper 即修复。
14. **`scripts/run_ui_benchmark.sh` / `scripts/run_benchmark.sh` / `scripts/build_moui_windows.sh`**：MoUI benchmark 包名按 `uname` 分支（Darwin→`moui/benchmark`，MINGW/MSYS→`moui/windows_benchmark`），macOS 侧行为不变；Windows 分支的构建入口改为调用 `scripts/build_moui_windows.sh`（两段式，见第 13 条）；headless 矩阵的两条 `moon run` 适配器字符串内嵌同一 `CL`/`MBT_WGPU_*` 环境（moon 按对象跟踪 CL，裸 `moon run` 会重建 wgpu C 对象并报 C1189），macOS 侧前缀为空。

另：`scripts/generate_fixtures.py` 的 LF 写盘修正本轮开始前已存在，fixture 字节契约直接通过。

## 性能结果摘要（Windows 机内口径）

完整表格见 [`windows-amd64-ui.md`](windows-amd64-ui.md)（帧性能 / 输入延迟 / 打开性能 / 滚动性能 / 异常项）。要点：

- **滚动工作时长（小/中/大/压力，ms 均值）**：GPUI 3.19/3.21/3.19/3.18 最稳（P95 3.6-3.7）；Electron 3.42/3.61/3.65/3.67；Flutter Skia 3.17/4.43/4.34/4.39；Flutter Impeller 3.85/5.18/5.19/5.25（Windows 走 OpenGL 通道的 Impeller 明显慢于 Skia）；**MoUI Skia raster/gpu 约 4.9ms 恒定**（P95 约 8.6，四个 fixture 无差别，虚拟滚动生效），**MoUI WGPU 约 11.0ms**（P95 约 15）。
- **输入**：工作时长 Flutter Skia 最低（1.4ms 级），MoUI Skia 约 2.1ms、MoUI WGPU 约 13.4ms；可见延迟均值 6.5-7.3ms，受 144Hz 帧网格支配（144Hz 帧间隔约 6.9ms）。Electron 输入 P95 偏高（large/stress 16.8/18.8ms）。**MoUI 口径提示**：ui-frame 用同步渲染完成时钟而非合成器时间戳（`display_timestamp_source=synchronous-render-completion-no-compositor-timestamp`），其 10-19ms 的 visible 值与实窗适配器不同网格，见异常项。
- **打开（首次可交互）**：small 下 MoUI raster 52ms ≈ Flutter 31ms～Electron 55ms 一档；5MB 压力下 Electron（~73ms）最快，Flutter Skia ~88ms，**MoUI 399-533ms 是压力打开的垫底者**（见异常项 P2）。**GPUI 约 500ms 是本轮最突出的异常**（macOS 同口径约 120ms），四个 fixture 一致，指向 Windows 侧窗口/渲染器初始化路径，见异常项。
- **丢帧**：Electron 合计 10 帧（长帧集中在 20.8/20.9ms——恰好两个 144Hz 帧间隔），Flutter Skia 1 帧，其余实窗适配器为 0；MoUI 三适配器 `dropped_display_frames=null`（headless 时钟无法推断显示丢帧，协议如实置 null）。
- **headless 纯工作量（MoUI）**：分块渲染 0.033/0.357/3.39/35.6ms（小→压力，raster 与 gpu 一致——该 scope 不含渲染）；框架富文本准备路径 `markdown_document` 在 small 为 ~21ms（协议限制只在 small 采样，O(blocks×chars) 超线性）。

## 与 macOS arm64 报告对比时的口径差异

两份报告（`macos-arm64-ui.md` vs `windows-amd64-ui.md`）用同一协议与同一 fixture，但存在以下不可消除的口径差异，跨平台比较只能作参考：

1. **刷新率**：本机显示 144Hz（实测帧间隔中位 6.94ms），macOS 采集机 60Hz（16.67ms）。帧间隔、丢帧数、“可见延迟”的量化网格都由各机刷新率支配，**不可跨平台直接排名**；工作时长（frame_work、input work、document load、first_interactive 减去初始化）可以比。
2. **缩放**：本机 200%（DPR 2.0，物理 2560×1600），与 macOS Retina（2.0）恰好同级，渲染负载可比。
3. **MoUI 三适配器为 headless host-surface 口径**：`window_mode=headless-host-surface` + 同步渲染完成时钟（macOS 报告同口径），其 visible/interval 不与实窗适配器的合成器时钟同网格；跨机比 `frame_work_ms`/`first_interactive_ms` 有效。同代码两机对比：scroll work raster 4.9ms vs 2.0ms、wgpu 11.0ms vs 7.7ms（差值与 CPU/GPU 档位相称）；small 打开 52ms vs 52ms 几乎一致，但 **stress 打开 399-533ms vs 68-73ms 是显著机差**（见异常项）。
4. **严格系统 trace**：`UI_BENCHMARK_SYSTEM_TRACE` 基于 xctrace，仅 macOS；本报告两平台均为“框架回调诊断”普通模式，非 compositor 时钟。
5. **GPU**：Apple M4 vs RX 7800 XT + Ryzen 5 5600，绝对值本就不同机。

## 异常项与优先级（Windows 侧）

- **P1 — GPUI 首帧 ~500ms**：small/medium/large/stress 一致（493-511ms），文档加载本身 ≤5ms，macOS 同代码 ~120ms。优先排查 vendored gpui-sys 在 Windows 上的窗口/DComp/字体初始化路径。
- **P1 — Electron 输入尾延迟**：large/stress P95 16.8/18.8ms，长帧集中在 20.8-20.9ms（两个 144Hz 帧槽），丢帧合计 10 帧；macOS Electron 同场景 0 丢帧。检查 rAF 驱动的 scroll 循环在 144Hz 下的对齐（480px 步进 + 固定行虚拟列表的可见区重算）。
- **P2 — MoUI 压力打开 399-533ms**（macOS 同代码 68-73ms）：small/medium 与 macOS 齐平（52ms），问题集中在 100k 块首帧的 build+paint 在 6 核 5600 上的扩展性；后续可查 paint 阶段的字体整形缓存预热。
- **P2 — MoUI Skia-gpu 输入 visible（17-19ms）高于 raster（10ms）**：Windows 的 direct3d 路线无 host-GPU present API，每帧付 D3D12 GPU 等待 + readback（约 6ms，协议如实计入 `readback_ms`）；这是移植口径决定，非回归。WGPU 适配器无 readback（readback=0）且 input work 13.4ms 反映命令提交成本。
- **P2 — Flutter Skia medium/scroll 1 次 27.8ms 长帧**：单点，暂不阻塞。
- 完整清单见 `windows-amd64-ui.md` 的“异常项与优化优先级”。

## 限制与后续步骤

1. **MoUI Windows 基准入口已移植完成**（原 36 格 `n/a` 解除）：`moui/windows_benchmark` + 原版 wgpu_mbt 两段式编译 + 接线脚本（见修改清单 11-14）。遗留：旧报告记录的 `windows_accessibility_host.cpp` `std::max` 宏冲突未影响本基准（未启用 backend entry）；`moui/windows_skia`/`windows_wgpu` 应用级入口与基准共用同一原版依赖，wgpu 应用现需在 exe 旁可解析 `wgpu_native.dll`（或设置 `MBT_WGPU_NATIVE_ROOT`）。
2. `gpui/vendor/gpui-moonbit` 已复位到 gitlink 记录的 `9656fcf`（`git submodule update` 即可保持），上一轮工作树被移到 `10e1d06` 是出数失败的原因之一。
3. 严格模式在 Windows 的等价物（ETW / Windows.Graphics.Capture present 时间戳）尚未实现；如需跨平台 compositor 级排名，这是一个独立的工具链工程。
4. 本报告未提交 git；`results/windows-amd64-*.json|md`、上节全部源码改动（Flutter runner 两处、Electron 三处、GPUI 两处、MoUI 移植三处）与新目录 `moui/windows_benchmark/`、`scripts/build_moui_windows.sh`、`scripts/fetch_wgpu_native.ps1` 建议一并处置。wgpu_mbt 已无任何本地副本：依赖走注册表版本、运行时 dll 在 gitignored 的 `.cache/`，无需入库。

## 复现方式（本机）

```sh
# Git Bash；需要 ~/bin/python3.exe（真实解释器副本）与 scoop flutter 在 PATH
scripts/build_moui_windows.sh   # MoUI Windows 基准 exe（两段式：pass1 干净环境编 windows_skia；pass2 CL=/std:c11 编 windows_benchmark）
GPU_MODEL="AMD Radeon RX 7800 XT" MOUI_GPU_ROUTE=direct3d python3 bench/run_benchmark.py \
  --adapter moui-skia-raster='python3 moui/ui_benchmark.py skia-raster {fixture} {scenario}' \
  --adapter moui-skia-gpu='python3 moui/ui_benchmark.py skia-gpu {fixture} {scenario}' \
  --adapter moui-wgpu='python3 moui/ui_benchmark.py wgpu {fixture} {scenario}' \
  --adapter gpui='python3 gpui/ui_benchmark.py {fixture} {scenario}' \
  --adapter flutter-skia='python3 flutter/ui_benchmark.py skia {fixture} {scenario}' \
  --adapter flutter-impeller='python3 flutter/ui_benchmark.py impeller {fixture} {scenario}' \
  --adapter electron='python3 electron/ui_benchmark.py {fixture} {scenario}' \
  --repetitions 3 --warmups 1 --timeout 300 \
  --out results/windows-amd64-ui.json
python3 bench/report.py results/windows-amd64-ui.json > results/windows-amd64-ui.md
```

本报告的 252 格由两条子集捕获按 `scripts/merge_captures.py` 合并而成（base=四实窗适配器，extra=`moui-windows-ui.json` 的三个 MoUI 适配器；provenance 记录在 JSON 的 `merged_captures` 字段），单独一次全量 `run_benchmark.py` 亦可直出。

headless 用同样的 `run_benchmark.py`，适配器换成 `MOUI_SKIA_RENDERER=skia-raster|skia-gpu moon run moui/windows_benchmark --target native --release -- {fixture} {scenario}`、`gpui/benchmark.py`、`dart.exe run flutter/tool/benchmark.dart`（前缀 `FLUTTER_RENDERER=skia|impeller`）与 `npm.cmd run --prefix electron benchmark`。实测全矩阵耗时约 9 分钟（UI，四实窗）+ 约 2 分钟（MoUI UI）+ 约 7 分钟（headless）。

## 与首轮（2026-09-01 上午）报告的差异

首轮结论是“官方 ui-frame 矩阵无法出数”（DPI 视口门禁、MoUI/GPUI 构建、管道丢失）；第二轮出了四实窗 144 格、MoUI 记为 `n/a`。本轮完成 MoUI 移植，矩阵补满 252 格，无遗留 `n/a`。首轮记录的其余环境坑（Store `python3` stub、`npm.cmd`/`dart` 可执行解析、`_build/.moon-lock` 残留、GPU 探针误报虚拟显卡）历轮复现并全部按记录的绕法执行。
