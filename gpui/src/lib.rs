use gpui::{
    div, px, rgb, rgba, size, uniform_list, App, AppContext, Application, Bounds, Context, Div,
    Entity, FontStyle, FontWeight, HighlightStyle, InteractiveElement, IntoElement, MouseButton,
    MouseUpEvent, ParentElement, Render, ScrollStrategy, SharedString, Styled, StyledText,
    Subscription, UniformListScrollHandle, Window, WindowBounds, WindowOptions,
};
use gpui_component::input::{Input, InputEvent, InputState};
use serde_json::json;
use std::{
    cell::RefCell,
    fs,
    io::{self, Write},
    ops::Range,
    path::PathBuf,
    rc::Rc,
    slice,
    time::Instant,
};

#[derive(Clone, Debug, PartialEq, Eq)]
enum Block {
    Heading { level: usize, text: String },
    Paragraph(String),
    ListItem(String),
    Quote(String),
    Code(String),
}

fn inline_parts(value: &str) -> (String, Vec<(Range<usize>, HighlightStyle)>) {
    let mut text = String::with_capacity(value.len());
    let mut highlights: Vec<(Range<usize>, HighlightStyle)> = Vec::new();
    let mut cursor = 0;
    while cursor < value.len() {
        let rest = &value[cursor..];
        let marker = if rest.starts_with("**") {
            Some(("**", FontWeight::BOLD.into()))
        } else if rest.starts_with("__") {
            Some(("__", FontWeight::BOLD.into()))
        } else if rest.starts_with('*') {
            Some(("*", FontStyle::Italic.into()))
        } else if rest.starts_with('`') {
            Some(("`", rgb(0x8f3f71).into()))
        } else {
            None
        };
        let Some((marker, style)) = marker else {
            let ch = rest.chars().next().expect("valid cursor");
            text.push(ch);
            cursor += ch.len_utf8();
            continue;
        };
        let start = cursor + marker.len();
        let Some(end) = value[start..].find(marker).map(|offset| start + offset) else {
            text.push_str(marker);
            cursor += marker.len();
            continue;
        };
        let output_start = text.len();
        text.push_str(&value[start..end]);
        if output_start < text.len() {
            highlights.push((output_start..text.len(), style));
        }
        cursor = end + marker.len();
    }
    (text, highlights)
}

#[cfg(test)]
fn inline_visible(value: &str) -> String {
    inline_parts(value).0
}

fn inline_styled(value: &str) -> StyledText {
    let (text, highlights) = inline_parts(value);
    StyledText::new(SharedString::new(text)).with_highlights(highlights)
}

fn formatted_block(block: &Block) -> Div {
    match block {
        Block::Heading { level, text } => {
            let element = div()
                .font_weight(FontWeight::BOLD)
                .child(inline_styled(text));
            if *level == 1 {
                element.text_2xl()
            } else if *level == 2 {
                element.text_xl()
            } else {
                element.text_lg()
            }
        }
        Block::Paragraph(text) => div().child(inline_styled(text)),
        Block::ListItem(text) => div().child(inline_styled(&format!("• {text}"))),
        Block::Quote(text) => div()
            .border_l_2()
            .border_color(rgb(0x7b8794))
            .pl(px(10.))
            .text_color(rgb(0x59636e))
            .child(inline_styled(text)),
        Block::Code(text) => div()
            .bg(rgb(0xf0f2f4))
            .px(px(8.))
            .font_family("monospace")
            .child(text.clone()),
    }
}

fn parse_blocks(source: &str) -> Vec<Block> {
    let mut blocks = Vec::new();
    let mut paragraph = Vec::new();
    let mut code = Vec::new();
    let mut in_code = false;
    let flush = |blocks: &mut Vec<Block>, paragraph: &mut Vec<String>| {
        if !paragraph.is_empty() {
            blocks.push(Block::Paragraph(paragraph.join(" ")));
            paragraph.clear();
        }
    };
    for raw in source.lines() {
        let line = raw.trim_end();
        let value = line.trim();
        if value.starts_with("```") {
            if in_code {
                blocks.push(Block::Code(code.join("\n")));
                code.clear();
            } else {
                flush(&mut blocks, &mut paragraph);
            }
            in_code = !in_code;
        } else if in_code {
            code.push(line.to_owned());
        } else if value.is_empty() {
            flush(&mut blocks, &mut paragraph);
        } else if let Some(rest) = value.strip_prefix("> ") {
            flush(&mut blocks, &mut paragraph);
            blocks.push(Block::Quote(rest.to_owned()));
        } else if let Some(rest) = value
            .strip_prefix("- ")
            .or_else(|| value.strip_prefix("* "))
        {
            flush(&mut blocks, &mut paragraph);
            blocks.push(Block::ListItem(rest.to_owned()));
        } else if let Some((hashes, rest)) = value.split_once(' ') {
            if !hashes.is_empty() && hashes.len() <= 6 && hashes.chars().all(|ch| ch == '#') {
                flush(&mut blocks, &mut paragraph);
                blocks.push(Block::Heading {
                    level: hashes.len(),
                    text: rest.to_owned(),
                });
            } else {
                paragraph.push(value.to_owned());
            }
        } else {
            paragraph.push(value.to_owned());
        }
    }
    if in_code {
        blocks.push(Block::Code(code.join("\n")));
    }
    flush(&mut blocks, &mut paragraph);
    if blocks.is_empty() {
        blocks.push(Block::Paragraph(String::new()));
    }
    blocks
}

fn block_markdown(block: &Block) -> String {
    match block {
        Block::Heading { level, text } => format!("{} {text}", "#".repeat(*level)),
        Block::Paragraph(text) => text.clone(),
        Block::ListItem(text) => format!("- {text}"),
        Block::Quote(text) => format!("> {text}"),
        Block::Code(text) => format!("```\n{text}\n```"),
    }
}

fn serialize_blocks(blocks: &[Block]) -> String {
    blocks
        .iter()
        .map(block_markdown)
        .collect::<Vec<_>>()
        .join("\n\n")
        + "\n"
}

struct MarkdownEditor {
    input: Entity<InputState>,
    blocks: Vec<Block>,
    source: String,
    saved: String,
    path: Option<PathBuf>,
    active: Option<usize>,
    scroll: UniformListScrollHandle,
    _subscriptions: Vec<Subscription>,
}

impl MarkdownEditor {
    fn new(source: String, window: &mut Window, cx: &mut Context<Self>) -> Self {
        let blocks = parse_blocks(&source);
        let scroll = UniformListScrollHandle::new();
        scroll.scroll_to_item_strict(0, ScrollStrategy::Top);
        let input = cx.new(|cx| {
            InputState::new(window, cx)
                .multi_line(true)
                .rows(3)
                .soft_wrap(true)
        });
        let subscription =
            cx.subscribe(&input, |this: &mut Self, input, event: &InputEvent, cx| {
                if matches!(event, InputEvent::Change) {
                    if let Some(index) = this.active {
                        let value = input.read(cx).value().to_string();
                        let replacement = parse_blocks(&value)
                            .into_iter()
                            .next()
                            .unwrap_or(Block::Paragraph(value));
                        this.blocks[index] = replacement;
                        this.source = serialize_blocks(&this.blocks);
                        cx.notify();
                    }
                }
            });
        Self {
            input,
            blocks,
            source: source.clone(),
            saved: source,
            path: None,
            active: None,
            scroll,
            _subscriptions: vec![subscription],
        }
    }

    fn edit_block(&mut self, index: usize, window: &mut Window, cx: &mut Context<Self>) {
        self.active = Some(index);
        let value = block_markdown(&self.blocks[index]);
        self.input.update(cx, |input, cx| {
            input.set_value(value, window, cx);
            input.focus(window, cx);
        });
        cx.notify();
    }

    fn new_document(&mut self, _: &MouseUpEvent, window: &mut Window, cx: &mut Context<Self>) {
        self.replace_document("# Untitled\n\n".to_owned(), None, window, cx);
    }

    fn replace_document(
        &mut self,
        source: String,
        path: Option<PathBuf>,
        window: &mut Window,
        cx: &mut Context<Self>,
    ) {
        self.active = None;
        self.blocks = parse_blocks(&source);
        self.source = source.clone();
        self.saved = source;
        self.path = path;
        self.scroll.scroll_to_item_strict(0, ScrollStrategy::Top);
        self.input
            .update(cx, |input, cx| input.set_value("", window, cx));
        cx.notify();
    }

    fn open(&mut self, _: &MouseUpEvent, window: &mut Window, cx: &mut Context<Self>) {
        let Some(path) = rfd::FileDialog::new()
            .add_filter("Markdown", &["md", "markdown"])
            .pick_file()
        else {
            return;
        };
        let Ok(source) = fs::read_to_string(&path) else {
            return;
        };
        self.replace_document(source, Some(path), window, cx);
    }

    fn save(&mut self, _: &MouseUpEvent, _: &mut Window, cx: &mut Context<Self>) {
        let path = self.path.clone().or_else(|| {
            rfd::FileDialog::new()
                .add_filter("Markdown", &["md", "markdown"])
                .set_file_name("untitled.md")
                .save_file()
        });
        let Some(path) = path else { return };
        if fs::write(&path, &self.source).is_ok() {
            self.path = Some(path);
            self.saved = self.source.clone();
            cx.notify();
        }
    }

    fn prepare_benchmark(&mut self, scenario: &str, window: &mut Window, cx: &mut Context<Self>) {
        if scenario == "input" {
            self.edit_block(0, window, cx);
        }
    }

    fn drive_benchmark(
        &mut self,
        scenario: &str,
        index: usize,
        window: &mut Window,
        cx: &mut Context<Self>,
    ) {
        if scenario == "input" {
            let value = String::from_utf8(vec![b'a' + (index % 26) as u8]).expect("ASCII input");
            self.input
                .update(cx, |input, cx| input.insert(value, window, cx));
        } else {
            let last = self.blocks.len().saturating_sub(1);
            let target = if index % 2 == 0 {
                ((index + 1) * 10).min(last)
            } else {
                0
            };
            self.scroll
                .scroll_to_item_strict(target, ScrollStrategy::Top);
            cx.notify();
        }
    }
}

struct UiBenchmarkState {
    scenario: String,
    document_load_ms: f64,
    process_started: Instant,
    previous_frame: Option<Instant>,
    action_started: Option<Instant>,
    first_interactive_ms: f64,
    samples: Vec<f64>,
    latencies: Vec<f64>,
    completed: usize,
    target: usize,
    warming_up: bool,
}

impl UiBenchmarkState {
    fn new(scenario: String, document_load_ms: f64, process_started: Instant) -> Self {
        let target = if scenario == "open" {
            1
        } else if scenario == "scroll" {
            120
        } else {
            10
        };
        let warming_up = scenario != "open";
        Self {
            scenario,
            document_load_ms,
            process_started,
            previous_frame: None,
            action_started: None,
            first_interactive_ms: 0.,
            samples: Vec::with_capacity(target),
            latencies: Vec::with_capacity(target),
            completed: 0,
            target,
            warming_up,
        }
    }

    fn milliseconds(started: Instant, finished: Instant) -> f64 {
        finished.duration_since(started).as_secs_f64() * 1000.
    }

    fn report(&self) {
        let mut sorted = self.samples.clone();
        sorted.sort_by(f64::total_cmp);
        let mean = self.samples.iter().sum::<f64>() / self.samples.len() as f64;
        let percentile = |ratio: f64| sorted[((sorted.len() - 1) as f64 * ratio).round() as usize];
        let dropped = self.samples.iter().filter(|value| **value > 16.667).count();
        let input_latency = (self.scenario == "input")
            .then(|| self.latencies.iter().sum::<f64>() / self.latencies.len() as f64);
        println!(
            "{}",
            json!({
                "adapter": "gpui",
                "measurement_scope": "ui-frame",
                "timing_source": "gpui-Window.on_next_frame-interval",
                "latency_source": "action-to-Window.on_next_frame",
                "scenario": self.scenario,
                "samples_ms": self.samples,
                "mean_ms": mean,
                "p95_ms": percentile(0.95),
                "p99_ms": percentile(0.99),
                "dropped_frames": dropped,
                "dropped_frame_rate": dropped as f64 / self.samples.len() as f64,
                "action_count": self.target,
                "frame_sample_count": self.samples.len(),
                "warmup_action_count": if self.scenario == "open" { 0 } else { 1 },
                "input_latency_ms": input_latency,
                "input_latency_samples_ms": if self.scenario == "input" { self.latencies.clone() } else { Vec::new() },
                "first_interactive_ms": self.first_interactive_ms,
                "document_load_ms": self.document_load_ms,
                "viewport": { "width": 1280, "height": 800 },
            })
        );
        let _ = io::stdout().flush();
    }
}

fn schedule_benchmark_frame(
    window: &mut Window,
    editor: Entity<MarkdownEditor>,
    state: Rc<RefCell<UiBenchmarkState>>,
) {
    window.on_next_frame(move |window, cx| {
        let now = Instant::now();
        let mut benchmark = state.borrow_mut();
        if benchmark.previous_frame.is_none() {
            benchmark.first_interactive_ms =
                UiBenchmarkState::milliseconds(benchmark.process_started, now);
            if benchmark.scenario == "open" {
                let first_interactive_ms = benchmark.first_interactive_ms;
                benchmark.samples.push(first_interactive_ms);
                benchmark.report();
                cx.quit();
                return;
            }
        } else if benchmark.warming_up {
            benchmark.warming_up = false;
        } else {
            let previous = benchmark.previous_frame.expect("previous frame");
            benchmark
                .samples
                .push(UiBenchmarkState::milliseconds(previous, now));
            let action = benchmark.action_started.expect("action start");
            benchmark
                .latencies
                .push(UiBenchmarkState::milliseconds(action, now));
            benchmark.completed += 1;
            if benchmark.completed == benchmark.target {
                benchmark.report();
                cx.quit();
                return;
            }
        }

        benchmark.previous_frame = Some(now);
        benchmark.action_started = Some(Instant::now());
        let scenario = benchmark.scenario.clone();
        let index = benchmark.completed + usize::from(!benchmark.warming_up);
        drop(benchmark);
        editor.update(cx, |editor, cx| {
            editor.drive_benchmark(&scenario, index, window, cx)
        });
        schedule_benchmark_frame(window, editor, state);
    });
}

fn init_editor_components(cx: &mut App) {
    gpui_component::init(cx);
    gpui_component::Theme::global_mut(cx).foreground = rgba(0x00000000).into();
}

impl Render for MarkdownEditor {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let filename = self
            .path
            .as_ref()
            .and_then(|path| path.file_name())
            .and_then(|name| name.to_str())
            .unwrap_or("Untitled.md")
            .to_owned();
        let status = if self.source == self.saved {
            "Saved"
        } else {
            "Unsaved changes"
        };
        let input = self.input.clone();
        let active = self.active;
        div()
            .size_full()
            .bg(rgb(0xf5f6f8))
            .p(px(18.))
            .flex()
            .flex_col()
            .gap(px(10.))
            .text_color(rgb(0x20242a))
            .child(
                div()
                    .flex()
                    .gap(px(10.))
                    .child(
                        div()
                            .text_xl()
                            .font_weight(FontWeight::BOLD)
                            .child("GPUI MoonBit Markdown Editor"),
                    )
                    .child(div().flex_1())
                    .child(div().child(filename))
                    .child(
                        div()
                            .id("new")
                            .cursor_pointer()
                            .on_mouse_up(MouseButton::Left, cx.listener(Self::new_document))
                            .px(px(10.))
                            .bg(rgb(0xe4e7eb))
                            .child("New"),
                    )
                    .child(
                        div()
                            .id("open")
                            .cursor_pointer()
                            .on_mouse_up(MouseButton::Left, cx.listener(Self::open))
                            .px(px(10.))
                            .bg(rgb(0xe4e7eb))
                            .child("Open"),
                    )
                    .child(
                        div()
                            .id("save")
                            .cursor_pointer()
                            .on_mouse_up(MouseButton::Left, cx.listener(Self::save))
                            .px(px(10.))
                            .bg(rgb(0xd9e8ff))
                            .child("Save"),
                    ),
            )
            .child(
                div()
                    .flex_1()
                    .w_full()
                    .bg(rgb(0xffffff))
                    .border_1()
                    .border_color(rgb(0xd6d9de))
                    .rounded(px(4.))
                    .p(px(10.))
                    .child(
                        uniform_list(
                            "markdown-blocks",
                            self.blocks.len(),
                            cx.processor(move |this, range: Range<usize>, _window, cx| {
                                range
                                    .map(|index| {
                                        let row = div()
                                            .id(index)
                                            .h(px(48.))
                                            .px(px(14.))
                                            .py(px(6.))
                                            .overflow_hidden();
                                        let content = formatted_block(&this.blocks[index]);
                                        if active == Some(index) {
                                            row.relative().child(content).child(
                                                Input::new(&input)
                                                    .h(px(40.))
                                                    .appearance(false)
                                                    .absolute()
                                                    .size_full()
                                                    .text_color(rgba(0x00000000)),
                                            )
                                        } else {
                                            row.cursor_pointer()
                                                .on_mouse_up(
                                                    MouseButton::Left,
                                                    cx.listener(move |this, _, window, cx| {
                                                        this.edit_block(index, window, cx)
                                                    }),
                                                )
                                                .child(content)
                                        }
                                    })
                                    .collect::<Vec<_>>()
                            }),
                        )
                        .track_scroll(self.scroll.clone())
                        .h_full(),
                    ),
            )
            .child(div().text_sm().child(format!(
                "{status} | {} bytes | {} blocks | GPUI via MoonBit native FFI | 1280x800",
                self.source.len(),
                self.blocks.len()
            )))
    }
}

/// C ABI consumed by the MoonBit executable. The byte slice is borrowed only
/// while this call creates the initial Rust-owned String.
#[no_mangle]
pub unsafe extern "C" fn gpui_markdown_editor_run(source_ptr: *const u8, source_len: i32) -> i32 {
    if source_ptr.is_null() || source_len < 0 {
        return -1;
    }
    let source = String::from_utf8_lossy(slice::from_raw_parts(source_ptr, source_len as usize))
        .into_owned();
    let result = std::panic::catch_unwind(|| {
        Application::new().run(move |cx: &mut App| {
            init_editor_components(cx);
            let bounds = Bounds::centered(None, size(px(1280.), px(800.)), cx);
            cx.open_window(
                WindowOptions {
                    window_bounds: Some(WindowBounds::Windowed(bounds)),
                    ..Default::default()
                },
                move |window, cx| {
                    let editor = cx.new(|cx| MarkdownEditor::new(source, window, cx));
                    cx.new(|cx| gpui_component::Root::new(editor, window, cx))
                },
            )
            .expect("open GPUI window");
            cx.activate(true);
        });
    });
    if result.is_ok() {
        0
    } else {
        -2
    }
}

/// UI-frame benchmark entrypoint consumed by the MoonBit executable.
#[no_mangle]
pub unsafe extern "C" fn gpui_markdown_editor_benchmark_run(
    source_ptr: *const u8,
    source_len: i32,
    scenario_ptr: *const u8,
    scenario_len: i32,
    document_load_ms: f64,
) -> i32 {
    if source_ptr.is_null() || source_len < 0 || scenario_ptr.is_null() || scenario_len < 0 {
        return -1;
    }
    let process_started = Instant::now();
    let source = String::from_utf8_lossy(slice::from_raw_parts(source_ptr, source_len as usize))
        .into_owned();
    let scenario =
        String::from_utf8_lossy(slice::from_raw_parts(scenario_ptr, scenario_len as usize))
            .into_owned();
    if !matches!(scenario.as_str(), "open" | "input" | "scroll") {
        return -3;
    }
    let result = std::panic::catch_unwind(|| {
        Application::new().run(move |cx: &mut App| {
            init_editor_components(cx);
            let bounds = Bounds::centered(None, size(px(1280.), px(800.)), cx);
            cx.open_window(
                WindowOptions {
                    window_bounds: Some(WindowBounds::Windowed(bounds)),
                    ..Default::default()
                },
                move |window, cx| {
                    let state = Rc::new(RefCell::new(UiBenchmarkState::new(
                        scenario.clone(),
                        document_load_ms,
                        process_started,
                    )));
                    let editor = cx.new(|cx| MarkdownEditor::new(source, window, cx));
                    editor.update(cx, |editor, cx| {
                        editor.prepare_benchmark(&scenario, window, cx)
                    });
                    schedule_benchmark_frame(window, editor.clone(), state);
                    cx.new(|cx| gpui_component::Root::new(editor, window, cx))
                },
            )
            .expect("open GPUI benchmark window");
            cx.activate(true);
        });
    });
    if result.is_ok() {
        0
    } else {
        -2
    }
}

#[cfg(test)]
mod tests {
    use super::{block_markdown, inline_visible, parse_blocks, serialize_blocks, Block};
    #[test]
    fn parser_preserves_supported_shapes() {
        let blocks =
            parse_blocks("# Title\n\nA **bold** paragraph.\n\n- item\n\n> quote\n\n```\ncode\n```");
        assert!(matches!(blocks[0], Block::Heading { level: 1, .. }));
        assert_eq!(block_markdown(&blocks[2]), "- item");
        assert!(serialize_blocks(&blocks).contains("```\ncode\n```"));
    }

    #[test]
    fn wysiwyg_inline_text_hides_supported_markers() {
        assert_eq!(
            inline_visible("A **bold**, *italic*, and `code` value."),
            "A bold, italic, and code value."
        );
    }
}
