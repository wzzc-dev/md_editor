///|
/// ui-frame benchmark over the vendored official example app
/// (`momark`, the standalone MoMark app). The fixture is delivered through
/// the app's real `OpenRecentDocument` service path via a deterministic,
/// synchronous file service, so every measured frame runs the same document
/// session and richtext preparation a manual open would produce. The driving
/// logic, timing envelope, and v2 report are shared with the simplified
/// benchmark app (`run_ui_benchmark`).
fn example_benchmark_renderer(renderer : String) -> UiBenchmarkRenderer {
  let base = if renderer == "wgpu" {
    ui_wgpu_benchmark_renderer(1280.0, 800.0)
  } else {
    ui_skia_benchmark_renderer(renderer, 1280.0, 800.0)
  }
  let adapter = if renderer == "wgpu" {
    "moui-md-wgpu"
  } else if renderer == "skia-gpu" {
    "moui-md-skia-gpu"
  } else {
    "moui-md-skia-raster"
  }
  { ..base, adapter, timing_source: base.timing_source + "+official-example" }
}

///|
/// The official editor's focusable key on `view_editor_surface`.
fn example_editor_key() -> String {
  "markdown-editor"
}

///|
fn example_ui_runtime(fixture : String) -> (@runtime.AppRuntime, Double) {
  let document_load_ms = Ref(0.0)
  let opened_documents = Ref(0)
  let services = @services.AppServices::new(
    files=@services.FileServices::new(
      read_text=path => {
        let started = now_ms()
        let text = @fs.read_file_to_string(path) catch {
          _ => abort("MoMark benchmark fixture is unreadable")
        }
        opened_documents.val = opened_documents.val + 1
        document_load_ms.val = (now_ms() - started).max(0.0)
        @services.ServiceTask::succeed(
          key="file:read-text",
          value=text,
          label="text file read",
        )
      },
      list_directory=_path => {
        @services.ServiceTask::succeed(
          key="file:list-directory",
          value=[],
          label="directory listing",
        )
      },
    ),
  )
  let runtime = @md_editor.runtime(
    environment=@services.AppEnvironment::new(services~),
    width=1280.0,
    height=800.0,
    initial_document_path=Some(fixture),
  )
  // Program init must have opened the fixture through the app's real
  // OpenRecentDocument path; measuring the built-in sample document instead
  // would silently produce a small-fixture number for every scenario.
  if opened_documents.val != 1 {
    abort("MoMark benchmark did not open the fixture document")
  }
  (runtime, document_load_ms.val)
}

///|
fn run_example_ui_benchmark(fixture : String, scenario : String) -> Unit {
  let renderer_name = @env.get_env_var("MOUI_SKIA_RENDERER").unwrap_or(
    "skia-raster",
  )
  let benchmark_renderer = example_benchmark_renderer(renderer_name)
  let started = now_ms()
  let (runtime, document_load_ms) = example_ui_runtime(fixture)
  match benchmark_renderer.text_system {
    Some(text_system) => runtime.set_text_system(text_system)
    None => ()
  }
  let samples = ui_samples()
  let mut first_interactive_ms = 0.0
  if scenario == "open" {
    ignore(ui_measure_frame(runtime, benchmark_renderer, samples, started, 0.0))
    if samples.interval_ms.length() > 0 {
      ignore(samples.interval_ms.pop())
    }
    if samples.input_to_visible_ms.length() > 0 {
      ignore(samples.input_to_visible_ms.pop())
    }
    first_interactive_ms = (now_ms() - started).max(0.0)
  } else {
    if scenario == "input" {
      if !runtime.focus_key(example_editor_key()) {
        abort("MoMark benchmark could not focus the editor")
      }
      if !runtime.focused_text_input().focused {
        abort("MoMark benchmark editor is not focused")
      }
    }
    let text_length_before_input = runtime.focused_text_input().text.length()
    let warmup = ui_samples()
    let mut previous_frame_end = ui_measure_frame(
      runtime, benchmark_renderer, warmup, started, 0.0,
    )
    first_interactive_ms = (now_ms() - started).max(0.0)
    let warmup_action_started = now_ms()
    if scenario == "input" {
      ui_drive_input(runtime, 0)
    } else {
      ui_drive_scroll(runtime, 0)
    }
    previous_frame_end = ui_measure_frame(
      runtime, benchmark_renderer, warmup, warmup_action_started, previous_frame_end,
    )
    // The editor must actually consume the warm-up action: an insert that
    // does not change the document session would make every later frame
    // sample meaningless.
    if scenario == "input" &&
      runtime.focused_text_input().text.length() <= text_length_before_input {
      abort("MoMark benchmark input did not change the document")
    }
    let count = if scenario == "scroll" { 120 } else { 10 }
    probe_reset()
    for index in 0..<count {
      let action_started = now_ms()
      if scenario == "input" {
        ui_drive_input(runtime, index + 1)
      } else {
        ui_drive_scroll(runtime, index + 1)
      }
      let measure_started = now_ms()
      previous_frame_end = ui_measure_frame(
        runtime, benchmark_renderer, samples, action_started, previous_frame_end,
      )
      probe_measure_us.val = probe_measure_us.val +
        (now_ms() - measure_started)
    }
    if scenario == "input" {
      probe_emit_means()
    }
  }
  if (benchmark_renderer.unsupported_command_count)() != 0 {
    abort(
      "MoMark benchmark emitted unsupported renderer commands",
    )
  }
  println(
    ui_report_v2(
      benchmark_renderer.adapter,
      scenario,
      benchmark_renderer.timing_source,
      samples,
      first_interactive_ms,
      document_load_ms,
      benchmark_renderer.surface_route,
      benchmark_renderer.presentation_kind,
    ),
  )
}

///|
/// Windowed variant of the official-example benchmark (`UI_BENCHMARK_WINDOWED=1`):
/// the app runs in a real AppKit window with the same renderer wiring as
/// `momark/macos_skia`, while the fixture delivery (the app's real
/// `OpenRecentDocument` service path), actions and timing follow the shared
/// native-window harness.
async fn run_example_native_ui_benchmark(
  fixture : String,
  scenario : String,
) -> Unit {
  let renderer = @env.get_env_var("MOUI_SKIA_RENDERER").unwrap_or(
    "skia-raster",
  )
  let adapter = if renderer == "wgpu" {
    "moui-md-wgpu"
  } else if renderer == "skia-gpu" {
    "moui-md-skia-gpu"
  } else {
    "moui-md-skia-raster"
  }
  let (runtime, document_load_ms) = example_ui_runtime(fixture)
  let started = now_ms()
  let first_frame_end_ms = Ref(0.0)
  let requests = @window_lifecycle.WindowRequestQueue::new()
  let window_task : async () -> Unit = async fn() {
    native_window_pump(
      "MoMark UI Benchmark",
      runtime,
      requests,
      renderer,
      native_window_frame_clock(first_frame_end_ms),
    )
  }
  let benchmark_task : async () -> Unit = async fn() {
    native_drive_benchmark(
      runtime,
      requests,
      adapter,
      scenario,
      started,
      document_load_ms,
      example_editor_key(),
      first_frame_end_ms,
    )
  }
  ignore(@async.all([window_task, benchmark_task]))
}
