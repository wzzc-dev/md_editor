# MoUI 文本编辑栈"下沉公共件"改造计划（P1–P4）

## 已核实的现状（决定了计划形状）

- **引擎契约已对**：`core/text_layout.mbt` 的 `TextSystem.paragraph_layout → TextParagraphLayoutResult`（:67-72）；core fallback 已是单遍增量测宽折行且有"只 measure 一次"测试锚定（:285-401）；Skia 有原生实现，sun 自实现，web/wgpu 走 fallback。**core 无任何段落排版缓存**。
- **唯一双轨在 text_area**：paint/caret 走自带 O(n²) 贪心（`text_area_layout.mbt:42-95`，逐 char 重测前缀、`max_lines` 截断致超长文本不可达）；selection rect/hit-test/上下键已走 core paragraph。同一帧两套行模型（y 分别是 slot 28.0 与 font×1.25 累加），互相错位。
- **零视口**：无 scroll 状态、无 wheel 分支、全库无 caret-following；多行 text_area 零行为测试。
- **undo 三套栈**：widget 层 `TextHistoryEntryContext.text` 全文快照（core/view_protocol.mbt:188，进 mbti、每帧被 element_tree 整栈 copy）；richtext 500ms 合并窗只"跳过 push"不改栈顶（rich_text_editor_history.mbt）；examples app 另有命令级全文快照栈。
- **relocation 是活跃计划**（docs/plans/active/richtext-markdown-domain-relocation.md）：`editor_session.mbt`/`editor_model.mbt` 等归属未来的 moui_markdown。**本计划刻意不碰这批域文件**，避免双向返工；域簿记增量化（word/line 计数、height index、substring O(n)、wrap memo 委托 core 缓存）列为后续 P5，与 relocation 一起排期。

已定决策（用户未选，按推荐）：范围 P1–P4；行高统一后**保留控件 line_height 槽位网格**（断行真相归引擎、y 放置归控件，零视觉回归）；验收=受影响模块+全 workspace 单测 + MOUI_EDITOR_HOT_BENCH 微基准，**不重跑全矩阵**（保持叫停）。

## P1 core：ParagraphLayoutCache（纯新增，零行为变化）

新文件 `moui/core/text_paragraph_cache.mbt`，`layout_paragraph` 转发方法（text_layout.mbt:119-124）改为过缓存取结果：

- **键**：精确键 = text_system.id + 字体世代 + max_width + text/font 的长度前缀注入式编码；查找用 64-bit FNV-1a digest 桶 `Map[UInt64, Array[(String, TextParagraphLayoutResult)]]` + 命中校验精确键——照搬本会话已在生产压力下验证的 rich_text_cache 块高 digest 桶模式（碰撞语义无损）。
- **字体世代**：全局 Ref，`TextSystem::register_font_data` 转发方法内 bump（所有后端注册均经此入口，已核实）。
- **容量**：上限 4096 条，满则整体 clear + epoch bump（同 rich_text 模式）。
- **测试**（core 内联 wbtest）：命中返回等价结果；键注入性对抗用例（仿 block_key_wbtest 风格：不同 text/font/width 组合不得同键）；register_font_data 后旧条目失效；容量清理。
- **验收**：无任何消费方改动；全 workspace 单测绿。

## P2 text_area 单一折行源（删代码 + 三源对齐）

- **删**：`text_area_soft_break_after`、`text_area_wrap_line_ranges`、`text_area_line_index_for_offset`、`text_area_display_caret_rect` 内贪心与 `max_lines` 截断（text_area_layout.mbt:19-95,120-134,151-172）。
- **paint 正文/placeholder 分支**（text_area_paint.mbt:42-96）：行文本 = `paragraph.lines[i].text_range` 切片；行 y 仍用 `text_area_line_slot_y` 槽位网格（glyph 高经 `text_area_glyph_row_height` 居中，均保留）。
- **caret**：`text_area_display_caret_rect` 改为 `paragraph.caret_rect_at(visual_offset)` 取 x、槽位取 y；三个调用方（paint :135/:170、IME 状态 control:480）签名不变。
- **selection rect**：从 paragraph 的 per-line 矩形重投影到槽位网格（新增小 helper：行索引→slot y，x/宽沿用 paragraph 结果），composition 下划线同样对齐——从此 paint/caret/selection/hit-test 四者同一行模型。
- **每帧去重**：paint 单点算 paragraph；事件路径重复调用由 P1 缓存吸收。
- **测试**（新建 views/text 多行 wbtest，现状为零）：①断行强制下 paint 行切片 == paragraph.lines；②caret x == caret_rect_at；③selection 高亮与文字同槽位；④点选→caret→绘制 round-trip；⑤CJK/emoji/ZWJ/长词用例。
- **折行对齐语料**：放 moui_tests/skia 侧（core 不能依赖后端）：同一语料断言 skia native 与 core fallback 断点位置一致；若暴露既存分歧，以期望清单锚定现状并记录分歧（收敛留待后续，不在本计划扩大）。
- **验收**：`grep` 后 text_area 内 wrap 调用点仅剩 `text_area_paragraph` 一处；单测绿。

## P3 text_area 自带视口 + 光标跟随（RenderEditable 模式）

- **状态**：scroll offset 存 ViewState slot（照抄 scroll_view_layout.mbt:86-112 已验证模式），offset 纳入 declaration/paint 脏键（:253 模式，需实测渲染器重绘）。
- **布局**：内容高 = paragraph 行总数 × line_height；去掉 max_lines 截断语义——折全量、画可见区间。
- **paint**：定位首/末可见行，仅对区间 DrawText，y−=offset；selection/composition/caret 同步 −=offset；clip 已有不动。
- **事件**（control.mbt:108-124 分发处）：新增 Wheel 分支（clamp [0, content−viewport]，参照 `scroll_offset_after_wheel`）；hit_test/上下键坐标 +=offset；**caret-following（全库新增）**：键盘/点击/PageUp/Down/Home/End 改 caret 后，caret rect 越出视口则调 offset 使其入窗并随事件返回 state。
- **IME**：`text_input_state_for_multi_line` 输出视口换算后的 caret_rect。
- **测试**：输入超视口行数→断言 offset 调整且 caret 行入窗；滚动后点击落点正确（offset 参与逆变换）；顶部继续上滚不抖动。
- **验收**：超长文本全部可达可编辑；与 P2 的槽位网格一致。

## P4 undo 改 delta（范围 + before/after + 窗口归并升级）

- **条目改型**（core/view_protocol.mbt:188-192，pub(all) API break，不提供兼容层——与 relocation 同政策）：`{ start : Int, before : String, after : String, caret : Int, selection : TextRange? }`；undo=把 `[start, start+len(after))` 以 before 逆替换并回灌 caret/selection。mbti 与 examples/benchmark app 消费点 grep 同步。element_tree 每帧整栈 copy 因条目变小自然变便宜，不改逻辑。
- **入栈 4 处**（views text_input_apply.mbt:216-224、text_input_action_results.mbt:47-61；richtext rich_text_editor_helpers.mbt:219-229、rich_text_editor_caret_hit.mbt:449-459）：输入路径本就持有精确 replace range，显式下传 (start, before, after)；无法取得时的兜底走一次性 prefix/suffix diff（仅入栈时，不进每帧）。
- **恢复 2 处**：views/richtext 的 restore 从"快照顶掉全文"改"应用逆 delta"；redo 栈镜像。
- **合并窗升级**（rich_text_editor_history.mbt）：合并不再"跳过 push"，改为**改写栈顶 delta**（kind1：after 尾接新字符；kind2：start−1、before 头插；kind3：before 延伸）；分类器、500ms 窗、expected_stack_length/after_length 连续性校验全部保留为完整性守卫；全局单槽组状态语义不变（不扩大范围）。
- **examples app 命令栈**（MarkdownEditorHistoryEntry.source 全篇快照）：换用同一 core delta 类型，restore 走逆 delta 应用。
- **测试**：重写 rich_text_editor_history_wbtest（断言改为：归并后栈仅 1 条且 before/after 拼接正确、换向/超时/粘贴断组语义不变、假时钟继续驱动）；core/views 首次建立 undo 测试（打 abc→一条 undo 清全部；undo→输入断组；粘贴自成组）；wbtest 断言条目 before/after 长度 ≤ 编辑长度（不持有全文）。
- **验收**：行为与现状分组语义等价；MOUI_EDITOR_HOT_BENCH 每键 µs 不退化。

## 顺序、范围外、风险

- **顺序**：P1 → P2 → P3 串行（依赖递进）；P4 文件正交可并行穿插。每阶段独立可验收、可停靠，不留半吊子。
- **范围外**（明确不做）：P5 域簿记增量化与 wrap memo 委托（relocation 联动）；文档字符串 rope；undo 栈持久化；派生查询（selection_rects/hit_test）内部图素边界缓存；全矩阵基准重跑。
- **风险**：①折行对齐语料可能暴露 skia/fallback 既有分歧（已给锚定预案）；②`TextHistoryEntryContext` 改型是 API break，需 grep 全部消费点（examples、benchmark app、tester fixture）；③ViewState slot 的脏标记需在真实渲染器验证 offset 变更触发重绘；④MoonBit 工具链陷阱（StringBuilder 写法、UL 后缀、Array[T]、moon test 位置参数是名称过滤器）沿本会话已验证约定。