///|
/// Windows headless adapter for the shared benchmark protocol.
///
/// It reports two independent measurement scopes for each scenario:
///   * `headless-render` -- Markdown source split into blocks by a lightweight
///     line-based splitter (`split_blocks`) matching the GPUI, Electron and
///     Flutter adapters, so it is directly comparable across frameworks.
///   * `richtext-full` -- the same source formatted into a `RichTextDocument`
///     via `MarkdownDocumentSession`, MoUI's real framework render-preparation
///     path.
///     This is a heavier workload than the split-only rows and is NOT
///     comparable to the `headless-render` rows of the other adapters.
extern "C" fn now_ms() -> Double = "md_editor_benchmark_now_ms"

///|
fn percentile(values : Array[Double], ratio : Double) -> Double {
  let sorted = values.copy()
  sorted.sort()
  sorted[((sorted.length() - 1).to_double() * ratio).round().to_int()]
}

///|
fn json_number(value : Double) -> String {
  value.to_string()
}

///|
fn summarize(
  adapter : String,
  scope : String,
  scenario : String,
  samples : Array[Double],
) -> String {
  let total = samples.fold(init=0.0, fn(total, value) { total + value })
  let mean = total / samples.length().to_double()
  let dropped = samples.filter(value => value > 16.667).length()
  let values = samples.map(json_number).join(",")
  "{\"adapter\":\"" +
  adapter +
  "\",\"measurement_scope\":\"" +
  scope +
  "\",\"scenario\":\"" +
  scenario +
  "\",\"samples_ms\":[" +
  values +
  "],\"mean_ms\":" +
  json_number(mean) +
  ",\"p95_ms\":" +
  json_number(percentile(samples, 0.95)) +
  ",\"p99_ms\":" +
  json_number(percentile(samples, 0.99)) +
  ",\"dropped_frames\":" +
  dropped.to_string() +
  ",\"input_latency_ms\":" +
  (if scenario == "input" { json_number(mean) } else { "null" }) +
  "}"
}

///|
fn base_font() -> @text.FontSpec {
  @text.FontSpec::new(size=16.0)
}

///|
/// Lightweight line-based Markdown block splitter matching the GPUI
/// `parse_blocks`, Electron `format` and Flutter `_blocks` adapters: detect
/// ATX headings, bullet list items, blockquotes and fenced code blocks, and
/// fold everything else into paragraphs. This is the cross-framework
/// comparison layer -- it does not run the full CommonMark parser, so the
/// `headless-render` rows are directly comparable across all four frameworks.
/// It scans the source bytes without allocating per-line strings.
fn split_blocks(source : String) -> Int {
  let mut count = 0
  let mut in_code = false
  let mut paragraph = 0
  let mut line_start = 0
  let bytes = source.to_array()
  let n = bytes.length()
  let mut i = 0
  while i <= n {
    if i == n || bytes[i] == '\n' {
      // Skip leading spaces/tabs (the other adapters `trim` each line).
      let mut content_from = line_start
      while content_from < i &&
            (bytes[content_from] == ' ' || bytes[content_from] == '\t') {
        content_from = content_from + 1
      }
      // `fence` checks a three-byte prefix at `content_from`.
      let fence = content_from + 2 < i &&
        bytes[content_from] == '`' &&
        bytes[content_from + 1] == '`' &&
        bytes[content_from + 2] == '`'
      if in_code {
        if fence {
          count = count + 1
          in_code = false
        }
      } else if fence {
        paragraph = 0
        in_code = true
      } else {
        // Blank line (only spaces/tabs/CR)?
        let mut blank = true
        let mut j = content_from
        while j < i {
          if bytes[j] != ' ' && bytes[j] != '\t' && bytes[j] != '\r' {
            blank = false
            break
          }
          j = j + 1
        }
        if blank {
          paragraph = 0
        } else if content_from + 1 < i &&
          bytes[content_from] == '>' &&
          bytes[content_from + 1] == ' ' {
          paragraph = 0
          count = count + 1
        } else if content_from + 1 < i &&
          (
            (bytes[content_from] == '-' && bytes[content_from + 1] == ' ') ||
            (bytes[content_from] == '*' && bytes[content_from + 1] == ' ')
          ) {
          paragraph = 0
          count = count + 1
        } else {
          let mut hashes = 0
          while content_from + hashes < i && bytes[content_from + hashes] == '#' {
            hashes = hashes + 1
          }
          if hashes >= 1 &&
            hashes <= 6 &&
            content_from + hashes < i &&
            bytes[content_from + hashes] == ' ' {
            paragraph = 0
            count = count + 1
          } else {
            paragraph = paragraph + 1
          }
        }
      }
      line_start = i + 1
    }
    i = i + 1
  }
  if in_code {
    count = count + 1
  }
  if paragraph > 0 {
    count = count + 1
  }
  count
}

///|
fn main {
  let args = @env.args()
  if args.length() >= 4 && args[1] == "--ui-benchmark" {
    if @env.get_env_var("UI_BENCHMARK_SYSTEM_PRESENT").unwrap_or("") == "1" {
      // The strict system-present path drives a real AppKit window through
      // xctrace compositor timestamps; Windows has no equivalent trace
      // source in this benchmark, so the mode is refused explicitly rather
      // than silently falling back to the headless host-surface clock.
      abort(
        "MoUI Windows benchmark does not support UI_BENCHMARK_SYSTEM_PRESENT=1 (macOS-only xctrace path)",
      )
    }
    run_ui_benchmark(args[2], args[3])
    return
  }
  if args.length() < 3 {
    println(
      "usage: moon run moui/windows_benchmark --target native --release -- <fixture> <open|input|scroll>",
    )
    return
  }
  let source = @fs.read_file_to_string(args[1]) catch {
    _ => {
      println(
        "{\"adapter\":\"moui\",\"status\":\"error\",\"error\":\"fixture unreadable\"}",
      )
      return
    }
  }
  let scenario = args[2]
  let font = base_font()
  let renderer = @env.get_env_var("MOUI_SKIA_RENDERER").unwrap_or("")
  let adapter = if renderer == "skia-gpu" {
    "moui-skia-gpu"
  } else {
    "moui-skia-raster"
  }
  // Split each (possibly edited) source into Markdown blocks using the same
  // lightweight line-based splitter as the GPUI/Electron/Flutter adapters.
  // This is the cross-framework comparison layer.
  let parse_samples : Array[Double] = []
  let rich_samples : Array[Double] = []
  // `MarkdownDocumentSession` (the framework's real rich-text preparation path)
  // recomputes per-run source ranges with a full-source character scan per
  // block (O(blocks * chars)), so it scales super-linearly (medium ~1.1 s,
  // large ~92 s). Cap the heavier richtext-full sample at the small fixture
  // to keep the run bounded; the headless-render (split) row covers every
  // fixture.
  let rich_enabled = source.length() < 16_384
  let measure = fn(value : String) {
    let repeats = if value.length() < 100_000 { 8 } else { 1 }
    let parse_start = now_ms()
    for _ in 0..<repeats {
      ignore(split_blocks(value))
    }
    parse_samples.push((now_ms() - parse_start).max(0.0) / repeats.to_double())
    if rich_enabled {
      // Format the same source into a full rich-text snapshot via MoUI's
      // framework parser (per-run source ranges, outline, metadata).
      let rich_start = now_ms()
      ignore(
        @richtext.MarkdownDocumentSession::new(value).snapshot(base=font).blocks.length(),
      )
      rich_samples.push((now_ms() - rich_start).max(0.0))
    }
  }
  if scenario == "open" {
    measure(source)
  } else {
    let count = if scenario == "scroll" { 120 } else { 10 }
    for index in 0..<count {
      measure(
        if scenario == "input" {
          source + index.to_string()
        } else {
          source
        },
      )
    }
  }
  println(summarize(adapter, "headless-render", scenario, parse_samples))
  if rich_enabled {
    println(
      summarize(adapter + "-full", "richtext-full", scenario, rich_samples),
    )
  }
}
