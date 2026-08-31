///|
fn now_ms() -> Double {
  @env.now().reinterpret_as_int64().to_double()
}

///|
fn percentile(values : Array[Double], ratio : Double) -> Double {
  let sorted = values.copy()
  sorted.sort()
  sorted[((sorted.length() - 1).to_double() * ratio).round().to_int()]
}

///|
pub fn block_count(source : String) -> Int {
  parse_markdown_blocks(source).length()
}

///|
fn summary(
  scope : String,
  scenario : String,
  samples : Array[Double],
  document_load_ms : Double,
) -> String {
  let mean = samples.fold(init=0.0, fn(total, value) { total + value }) /
    samples.length().to_double()
  let dropped = 0
  "{\"adapter\":\"gpui\",\"measurement_scope\":\"" +
  scope +
  "\",\"scenario\":\"" +
  scenario +
  "\",\"frame_work_samples_ms\":[" +
  samples.map(value => value.to_string()).join(",") +
  "],\"frame_interval_samples_ms\":[],\"input_to_visible_samples_ms\":[" +
  (if scenario == "input" {
    samples.map(value => value.to_string()).join(",")
  } else {
    ""
  }) +
  "],\"offscreen_samples_ms\":[" +
  samples.map(_ => "null").join(",") +
  "],\"readback_samples_ms\":[" +
  samples.map(_ => "null").join(",") +
  "],\"offscreen_readback_samples_ms\":[" +
  samples.map(_ => "null").join(",") +
  "],\"frame_work_ms\":" +
  mean.to_string() +
  ",\"frame_interval_ms\":null,\"input_to_visible_ms\":" +
  (if scenario == "input" { mean.to_string() } else { "null" }) +
  ",\"offscreen_ms\":null,\"readback_ms\":null,\"offscreen_readback_ms\":null,\"frame_work_p95_ms\":" +
  percentile(samples, 0.95).to_string() +
  ",\"frame_interval_p95_ms\":null,\"input_to_visible_p95_ms\":" +
  (if scenario == "input" {
    percentile(samples, 0.95).to_string()
  } else {
    "null"
  }) +
  ",\"dropped_display_frames\":" +
  dropped.to_string() +
  ",\"first_interactive_ms\":null,\"document_load_ms\":" +
  document_load_ms.to_string() +
  ",\"viewport\":{\"width\":1280,\"height\":800},\"font\":\"system-ui 16px\",\"line_height\":1.55,\"overscan\":3,\"virtual_row_height\":66}"
}

///|
fn benchmark_source(
  source : String,
  scenario : String,
  scope : String,
  document_load_ms : Double,
) -> Unit {
  let samples : Array[Double] = []
  let count = if scenario == "open" {
    1
  } else if scenario == "scroll" {
    120
  } else {
    10
  }
  for index in 0..<count {
    let value = if scenario == "input" {
      source + index.to_string()
    } else {
      source
    }
    let started = now_ms()
    let blocks = parse_markdown_blocks(value)
    if scope == "moonbit-command-buffer" {
      initialize(value, "")
      ignore(build_tree(0))
    } else {
      ignore(blocks.length())
    }
    samples.push((now_ms() - started).max(0.0))
  }
  println(summary(scope, scenario, samples, document_load_ms))
}

///|
pub fn run_benchmark(fixture : String, scenario : String) -> Unit {
  let source = @fs.read_file_to_string(fixture) catch {
    _ => {
      println(
        "{\"adapter\":\"gpui\",\"status\":\"error\",\"error\":\"fixture unreadable\"}",
      )
      return
    }
  }
  benchmark_source(source, scenario, "headless-render", 0.0)
}

///|
extern "C" fn gpui_run_window_benchmark_ffi(
  view : Int,
  width : Float,
  height : Float,
  scenario : Int,
  target : Int,
  stride : Float,
  document_load_ms : Double,
) -> Int = "gpui_run_window_benchmark"

///|
const BENCHMARK_VIEWPORT_WIDTH : Float = 1280.0

///|
const BENCHMARK_VIEWPORT_HEIGHT : Float = 800.0

///|
/// Wheel stride in logical px per scroll action, matching the deltas the
/// MoUI/Electron adapters send.
const BENCHMARK_SCROLL_STRIDE : Float = 480.0

///|
/// Real-window `ui-frame` benchmark: open a GPUI window on the committed
/// tree and let the Rust-side frame loop measure every vsync-paced frame
/// while driving one action per frame through the real input/scroll path.
/// Same scope as the MoUI/Flutter/Electron adapters. The Rust loop prints
/// the JSON report to stdout and then terminates the process (macOS quit
/// does not unwind), so this function never returns on success.
pub fn run_ui_benchmark(
  source : String,
  scenario : String,
  document_load_ms : Double,
) -> Unit {
  @gpui.register_dispatch(dispatch)
  initialize(source, "")
  @gpui.expect_ok(build_tree(0), "ui-benchmark initial build_tree")
  let scenario_id = if scenario == "open" {
    0
  } else if scenario == "input" {
    1
  } else {
    2
  }
  let target = if scenario == "open" {
    1
  } else if scenario == "scroll" {
    120
  } else {
    10
  }
  let status = gpui_run_window_benchmark_ffi(
    0,
    BENCHMARK_VIEWPORT_WIDTH,
    BENCHMARK_VIEWPORT_HEIGHT,
    scenario_id,
    target,
    BENCHMARK_SCROLL_STRIDE,
    document_load_ms,
  )
  // Reaching this line means the window failed to start: a successful run
  // ends with the Rust-side report + process termination.
  abort("GPUI benchmark window failed with status \{status}")
}
