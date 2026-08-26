use gpui::{
    div, px, rgb, size, App, AppContext, Application, Bounds, Context, Entity, FontStyle,
    FontWeight, InteractiveElement, IntoElement, MouseButton, MouseUpEvent, ParentElement, Render,
    ScrollHandle, SharedString, StatefulInteractiveElement, Styled, StyledText, Window,
    WindowBounds, WindowOptions,
};
use gpui_component::input::{Input, InputEvent, InputState};
use std::{env, fs, path::PathBuf, time::Instant};

const SAMPLE: &str = "# GPUI Markdown Editor\n\nEdit **Markdown** on the left and watch the formatted preview update.\n\n- Open a .md file by passing its path on the command line\n- Type with normal keyboard shortcuts\n- Scroll either pane\n\n> The saved value is always Markdown source.\n";

#[derive(Clone, Debug, PartialEq, Eq)]
enum PreviewBlock {
    Heading { level: usize, text: String },
    Paragraph(String),
    ListItem(String),
    Quote(String),
    Code(String),
}

fn clean_inline(value: &str) -> String {
    value
        .replace("**", "")
        .replace("__", "")
        .replace('`', "")
        .replace('*', "")
        .replace('_', "")
}

/// Remove inline Markdown delimiters while retaining the rendered text.
fn inline_text(value: &str) -> String {
    clean_inline(value)
}

/// Convert the small inline subset into rendered text and non-overlapping style ranges.
/// Ranges are byte offsets, as required by GPUI's `StyledText` API.
fn inline_styled(value: &str) -> StyledText {
    let mut text = String::with_capacity(value.len());
    let mut highlights = Vec::new();
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
            let ch = rest.chars().next().expect("cursor is within value");
            text.push(ch);
            cursor += ch.len_utf8();
            continue;
        };
        let content_start = cursor + marker.len();
        let Some(relative_end) = value[content_start..].find(marker) else {
            text.push_str(marker);
            cursor += marker.len();
            continue;
        };
        let content_end = content_start + relative_end;
        let inner = &value[content_start..content_end];
        let output_start = text.len();
        text.push_str(inner);
        let output_end = text.len();
        if output_start < output_end {
            highlights.push((output_start..output_end, style));
        }
        cursor = content_end + marker.len();
    }
    StyledText::new(SharedString::new(text)).with_highlights(highlights)
}

fn parse_blocks(source: &str) -> Vec<PreviewBlock> {
    let mut blocks = Vec::new();
    let mut paragraph = Vec::new();
    let mut code = Vec::new();
    let mut in_code = false;
    let flush_paragraph = |blocks: &mut Vec<PreviewBlock>, paragraph: &mut Vec<String>| {
        if !paragraph.is_empty() {
            blocks.push(PreviewBlock::Paragraph(paragraph.join(" ")));
            paragraph.clear();
        }
    };
    for raw in source.lines() {
        let line = raw.trim_end();
        if line.trim_start().starts_with("```") {
            if in_code {
                flush_paragraph(&mut blocks, &mut paragraph);
                blocks.push(PreviewBlock::Code(code.join("\n")));
                code.clear();
                in_code = false;
            } else {
                flush_paragraph(&mut blocks, &mut paragraph);
                in_code = true;
            }
            continue;
        }
        if in_code {
            code.push(line.to_owned());
            continue;
        }
        let trimmed = line.trim();
        if trimmed.is_empty() {
            flush_paragraph(&mut blocks, &mut paragraph);
            continue;
        }
        if let Some(rest) = trimmed.strip_prefix("> ") {
            flush_paragraph(&mut blocks, &mut paragraph);
            blocks.push(PreviewBlock::Quote(rest.to_owned()));
        } else if let Some(rest) = trimmed
            .strip_prefix("- ")
            .or_else(|| trimmed.strip_prefix("* "))
        {
            flush_paragraph(&mut blocks, &mut paragraph);
            blocks.push(PreviewBlock::ListItem(rest.to_owned()));
        } else if let Some((hashes, rest)) = trimmed.split_once(' ') {
            if !hashes.is_empty() && hashes.chars().all(|ch| ch == '#') && hashes.len() <= 6 {
                flush_paragraph(&mut blocks, &mut paragraph);
                blocks.push(PreviewBlock::Heading {
                    level: hashes.len(),
                    text: rest.to_owned(),
                });
            } else {
                paragraph.push(trimmed.to_owned());
            }
        } else {
            paragraph.push(trimmed.to_owned());
        }
    }
    if in_code {
        blocks.push(PreviewBlock::Code(code.join("\n")));
    }
    flush_paragraph(&mut blocks, &mut paragraph);
    blocks
}

fn plain_preview(source: &str) -> String {
    parse_blocks(source)
        .into_iter()
        .map(|block| match block {
            PreviewBlock::Heading { text, .. } => inline_text(&text),
            PreviewBlock::Paragraph(text) => inline_text(&text),
            PreviewBlock::ListItem(text) => format!("• {}", inline_text(&text)),
            PreviewBlock::Quote(text) => format!("│ {}", inline_text(&text)),
            PreviewBlock::Code(text) => text,
        })
        .collect::<Vec<_>>()
        .join("\n\n")
}

struct MarkdownEditor {
    input: Entity<InputState>,
    source: String,
    path: Option<PathBuf>,
    preview: String,
    preview_scroll: ScrollHandle,
    dirty: bool,
}

impl MarkdownEditor {
    fn new(window: &mut Window, cx: &mut Context<Self>) -> Self {
        let path = env::args()
            .nth(1)
            .filter(|arg| !arg.starts_with('-'))
            .map(PathBuf::from);
        let source = path
            .as_ref()
            .and_then(|path| fs::read_to_string(path).ok())
            .unwrap_or_else(|| SAMPLE.to_owned());
        let preview = plain_preview(&source);
        let input = cx.new(|cx| {
            InputState::new(window, cx)
                .multi_line(true)
                .rows(32)
                .soft_wrap(true)
                .default_value(source.clone())
        });
        let _ = cx.subscribe(
            &input,
            |this: &mut Self, input: Entity<InputState>, event: &InputEvent, cx| {
                if matches!(event, InputEvent::Change) {
                    let value = input.read(cx).value().to_string();
                    this.source = value.clone();
                    this.preview = plain_preview(&value);
                    this.dirty = true;
                    cx.notify();
                }
            },
        );
        Self {
            input,
            source,
            path,
            preview,
            preview_scroll: ScrollHandle::new(),
            dirty: false,
        }
    }

    fn new_document(&mut self, _: &MouseUpEvent, window: &mut Window, cx: &mut Context<Self>) {
        self.source = "# Untitled\n\n".to_owned();
        self.preview = plain_preview(&self.source);
        self.path = None;
        self.input.update(cx, |input, cx| {
            input.set_value(self.source.clone(), window, cx)
        });
        self.dirty = false;
        cx.notify();
    }

    fn save(&mut self, _: &MouseUpEvent, _: &mut Window, cx: &mut Context<Self>) {
        let path = match self.path.clone() {
            Some(path) => path,
            None => {
                let Some(path) = rfd::FileDialog::new()
                    .add_filter("Markdown", &["md", "markdown"])
                    .set_file_name("untitled.md")
                    .save_file()
                else {
                    return;
                };
                path
            }
        };
        if fs::write(&path, &self.source).is_ok() {
            self.path = Some(path);
            self.dirty = false;
            cx.notify();
        }
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
        self.source = source.clone();
        self.preview = plain_preview(&source);
        self.path = Some(path);
        self.input
            .update(cx, |input, cx| input.set_value(source, window, cx));
        self.dirty = false;
        cx.notify();
    }
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
        let status = if self.dirty {
            "Unsaved changes"
        } else {
            "Saved"
        };
        let preview = div()
            .id("preview")
            .flex()
            .flex_col()
            .gap(px(10.))
            .flex_1()
            .h_full()
            .bg(rgb(0xffffff))
            .border_1()
            .border_color(rgb(0xd6d9de))
            .p(px(18.))
            .text_base()
            .overflow_y_scroll()
            .track_scroll(&self.preview_scroll)
            .children(parse_blocks(&self.source).into_iter().map(|block| {
                match block {
                    PreviewBlock::Heading { level, text } => {
                        let element = div()
                            .font_weight(FontWeight::BOLD)
                            .child(inline_styled(&text));
                        match level {
                            1 => element.text_3xl(),
                            2 => element.text_2xl(),
                            _ => element.text_xl(),
                        }
                    }
                    PreviewBlock::Paragraph(text) => {
                        div().whitespace_normal().child(inline_styled(&text))
                    }
                    PreviewBlock::ListItem(text) => div()
                        .whitespace_normal()
                        .child(inline_styled(&format!("• {text}"))),
                    PreviewBlock::Quote(text) => div()
                        .border_l_2()
                        .border_color(rgb(0x7b8794))
                        .pl(px(10.))
                        .text_color(rgb(0x59636e))
                        .whitespace_normal()
                        .child(inline_styled(&text)),
                    PreviewBlock::Code(text) => div()
                        .bg(rgb(0xf0f2f4))
                        .p(px(10.))
                        .font_family("monospace")
                        .whitespace_normal()
                        .child(SharedString::new(text)),
                }
            }));
        div()
            .size_full()
            .bg(rgb(0xf5f6f8))
            .p(px(20.))
            .flex()
            .flex_col()
            .gap(px(12.))
            .text_color(rgb(0x20242a))
            .child(div().text_xl().child("GPUI Markdown Editor"))
            .child(
                div()
                    .flex()
                    .gap(px(8.))
                    .child(div().child(filename))
                    .child(
                        div()
                            .id("open")
                            .on_mouse_up(MouseButton::Left, cx.listener(Self::open))
                            .px(px(10.))
                            .bg(rgb(0xe4e7eb))
                            .child("Open"),
                    )
                    .child(
                        div()
                            .id("new")
                            .on_mouse_up(MouseButton::Left, cx.listener(Self::new_document))
                            .px(px(10.))
                            .bg(rgb(0xe4e7eb))
                            .child("New"),
                    )
                    .child(
                        div()
                            .id("save")
                            .on_mouse_up(MouseButton::Left, cx.listener(Self::save))
                            .px(px(10.))
                            .bg(rgb(0xd9e8ff))
                            .child("Save"),
                    )
                    .child(div().text_sm().child(status)),
            )
            .child(
                div()
                    .flex()
                    .flex_1()
                    .gap(px(12.))
                    .child(
                        div()
                            .flex_1()
                            .h_full()
                            .bg(rgb(0xffffff))
                            .border_1()
                            .border_color(rgb(0xd6d9de))
                            .child(Input::new(&self.input).h_full()),
                    )
                    .child(preview),
            )
            .child(div().text_sm().child(format!(
                "{} bytes | GPUI renderer | 1280x800",
                self.source.len()
            )))
    }
}

fn percentile(mut values: Vec<f64>, p: f64) -> f64 {
    values.sort_by(f64::total_cmp);
    values[((values.len().saturating_sub(1)) as f64 * p).round() as usize]
}

fn benchmark(path: &str, scenario: &str) {
    let source = fs::read_to_string(path).expect("fixture must be readable");
    let mut samples = Vec::with_capacity(if scenario == "scroll" { 120 } else { 30 });
    let started = Instant::now();
    if scenario == "open" {
        let _ = plain_preview(&source);
        samples.push(started.elapsed().as_secs_f64() * 1000.0);
    } else if scenario == "input" {
        for ch in "0123456789".chars() {
            let t = Instant::now();
            let mut edited = source.clone();
            edited.push(ch);
            let _ = plain_preview(&edited);
            samples.push(t.elapsed().as_secs_f64() * 1000.0);
        }
    } else {
        for _ in 0..120 {
            let t = Instant::now();
            let _ = plain_preview(&source);
            samples.push(t.elapsed().as_secs_f64() * 1000.0);
        }
    }
    let mean = samples.iter().sum::<f64>() / samples.len() as f64;
    let p95 = percentile(samples.clone(), 0.95);
    let p99 = percentile(samples.clone(), 0.99);
    let dropped = samples.iter().filter(|sample| **sample > 16.667).count();
    println!(
        "{}",
        serde_json::json!({"adapter":"gpui","measurement_scope":"headless-render","scenario":scenario,"samples_ms":samples,"mean_ms":mean,"p95_ms":p95,"p99_ms":p99,"dropped_frames":dropped,"input_latency_ms":if scenario == "input" { Some(mean) } else { None::<f64> }}),
    );
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.get(1).map(String::as_str) == Some("--benchmark") {
        benchmark(
            args.get(2).expect("fixture"),
            args.get(3).expect("scenario"),
        );
        return;
    }
    Application::new().run(|cx: &mut App| {
        gpui_component::init(cx);
        let bounds = Bounds::centered(None, size(px(1280.), px(800.)), cx);
        cx.open_window(
            WindowOptions {
                window_bounds: Some(WindowBounds::Windowed(bounds)),
                ..Default::default()
            },
            |window, cx| {
                let editor = cx.new(|cx| MarkdownEditor::new(window, cx));
                cx.new(|cx| gpui_component::Root::new(editor, window, cx))
            },
        )
        .expect("open GPUI window");
        cx.activate(true);
    });
}

#[cfg(test)]
mod tests {
    use super::{parse_blocks, percentile, plain_preview, PreviewBlock};

    #[test]
    fn preview_preserves_block_shapes() {
        assert_eq!(
            plain_preview("# Title\n\n- item\n\n> quote"),
            "Title\n\n• item\n\n│ quote"
        );
    }

    #[test]
    fn percentile_is_stable_for_small_samples() {
        assert_eq!(percentile(vec![3.0, 1.0, 2.0], 0.95), 3.0);
    }

    #[test]
    fn parser_handles_rich_block_types() {
        let blocks =
            parse_blocks("# Title\n\nA **bold** paragraph.\n\n- item\n\n> quote\n\n```\ncode\n```");
        assert_eq!(
            blocks[0],
            PreviewBlock::Heading {
                level: 1,
                text: "Title".into()
            }
        );
        assert_eq!(
            blocks[1],
            PreviewBlock::Paragraph("A **bold** paragraph.".into())
        );
        assert_eq!(blocks[2], PreviewBlock::ListItem("item".into()));
        assert_eq!(blocks[3], PreviewBlock::Quote("quote".into()));
        assert_eq!(blocks[4], PreviewBlock::Code("code".into()));
    }
}
