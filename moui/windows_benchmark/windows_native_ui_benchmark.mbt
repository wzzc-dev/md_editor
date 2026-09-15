///|
/// Native Windows path: a real Win32 window and native host surface. This is
/// the unified-scope default (`native-window`) for the six MoUI/MoMark
/// adapters on Windows, mirroring the macOS harness: framework-callback
/// wall-clock diagnostics observed on an approximately 12 ms cadence after
/// each action. The strict system-present xctrace path stays macOS-only and
/// is refused in main.
///
/// Unlike the macOS harness, which drives the actions from a concurrent
/// async task, the Windows harness runs inside the backend's async pump via
/// `WindowsHostAppOptions::pump_tick`: every runtime mutation (action
/// dispatch, focus, sample bookkeeping) happens on the pump thread between
/// pump iterations, so no task ever touches the runtime state concurrently.
/// First presentation is timestamped by `on_frame_presented`.

///|
extern "C" fn native_signpost_event(action_id : Int) -> Unit = "md_editor_benchmark_signpost_event"

///|
fn native_frame_work(runtime : @runtime.AppRuntime) -> Double {
  runtime.inspector_snapshot().runtime().last_frame_timing().total_ms()
}

///|
priv struct NativeBenchState {
  runtime : @runtime.AppRuntime
  scenario : String
  adapter : String
  editor_key : String
  started : Double
  document_load_ms : Double
  samples : UiTimingSamples
  first_present_ms : Ref[Double]
  action_timestamps_epoch_ms : Array[Double]
  mut step : Int
  mut action_index : Int
  mut action_started : Double
  mut previous_end : Double
  mut action_window_end_epoch_ms : Double
}

///|
/// First-frame safety valve: if the window never presents within 30 s, fall
/// back to the elapsed wall clock instead of looping forever.
fn native_first_interactive_ms(state : NativeBenchState) -> Double {
  if state.first_present_ms.val > 0.0 {
    (state.first_present_ms.val - state.started).max(0.0)
  } else if now_ms() - state.started > 30000.0 {
    (now_ms() - state.started).max(0.0)
  } else {
    0.0
  }
}

///|
/// One pump-loop iteration of the benchmark driver. Returns true when the
/// report has been emitted and the pump should stop.
async fn native_bench_tick(state : NativeBenchState) -> Bool {
  if state.step == 0 {
    // Wait for the first presented frame.
    if state.first_present_ms.val == 0.0 && now_ms() - state.started <= 30000.0 {
      return false
    }
    if state.scenario == "open" {
      state.samples.work_ms.push(native_frame_work(state.runtime))
      println(
        native_ui_report(
          state.adapter,
          state.scenario,
          state.samples,
          native_first_interactive_ms(state),
          state.document_load_ms,
          state.action_timestamps_epoch_ms,
          0.0,
        ),
      )
      return true
    }
    if state.scenario == "input" && !state.runtime.focus_key(state.editor_key) {
      abort("MoUI native benchmark could not focus the editor")
    }
    // Warm-up action (index 0, not recorded).
    if state.scenario == "input" {
      ui_drive_input(state.runtime, 0)
    } else {
      ui_drive_scroll(state.runtime, 0)
    }
    state.action_started = now_ms()
    state.step = 1
    return false
  }
  if state.step == 1 {
    // The warm-up frame has been given its pump window; start the recorded
    // sequence at action index 1.
    state.previous_end = now_ms()
    state.action_index = 1
    state.step = 2
  } else {
    // Record the action dispatched one pump window ago (~12 ms cadence, the
    // same wall-clock observation class as the macOS harness).
    let ended = now_ms()
    state.samples.work_ms.push(native_frame_work(state.runtime))
    state.samples.interval_ms.push((ended - state.previous_end).max(0.0))
    if state.scenario == "input" {
      state.samples.input_to_visible_ms.push(
        (ended - state.action_started).max(0.0),
      )
    }
    state.previous_end = ended
    state.action_index = state.action_index + 1
    if state.action_index > native_action_count(state.scenario) {
      state.action_window_end_epoch_ms = epoch_ms()
      println(
        native_ui_report(
          state.adapter,
          state.scenario,
          state.samples,
          native_first_interactive_ms(state),
          state.document_load_ms,
          state.action_timestamps_epoch_ms,
          state.action_window_end_epoch_ms,
        ),
      )
      return true
    }
  }
  state.action_timestamps_epoch_ms.push(epoch_ms())
  let action_index = state.action_index
  native_signpost_event(action_index)
  state.action_started = now_ms()
  if state.scenario == "input" {
    ui_drive_input(state.runtime, action_index)
  } else {
    ui_drive_scroll(state.runtime, action_index)
  }
  false
}

///|
fn native_action_count(scenario : String) -> Int {
  if scenario == "scroll" {
    120
  } else {
    10
  }
}

///|
fn native_ui_report(
  adapter : String,
  scenario : String,
  samples : UiTimingSamples,
  first_interactive_ms : Double,
  document_load_ms : Double,
  action_timestamps_epoch_ms : Array[Double],
  action_window_end_epoch_ms : Double,
) -> String {
  let count = samples.work_ms.length()
  let work_mean = samples.work_ms.fold(init=0.0, fn(total, value) {
      total + value
    }) /
    count.to_double()
  let interval_mean = if samples.interval_ms.is_empty() {
    0.0
  } else {
    samples.interval_ms.fold(init=0.0, fn(total, value) { total + value }) /
    samples.interval_ms.length().to_double()
  }
  let input_mean = if scenario == "input" {
    samples.input_to_visible_ms.fold(init=0.0, fn(total, value) {
      total + value
    }) /
    samples.input_to_visible_ms.length().to_double()
  } else {
    0.0
  }
  let dropped = samples.interval_ms.fold(init=0, fn(total, value) {
    total + ((value / 16.667).ceil().to_int() - 1).max(0)
  })
  // The standalone windowed mode only has this harness's frame observation,
  // so the source must not claim compositor timestamps.
  let display_timestamp_source = "moui-native-frame-callback"
  "{\"adapter\":\"" +
  adapter +
  "\",\"measurement_scope\":\"ui-frame\",\"timing_source\":\"moui-native-runtime-frame-phases\",\"latency_source\":\"action-to-native-frame-observation\",\"scenario\":\"" +
  scenario +
  "\",\"frame_work_samples_ms\":[" +
  ui_json_array(samples.work_ms) +
  "],\"frame_interval_samples_ms\":[" +
  ui_json_array(samples.interval_ms) +
  "],\"input_to_visible_samples_ms\":[" +
  (if scenario == "input" {
    ui_json_array(samples.input_to_visible_ms)
  } else {
    ""
  }) +
  "],\"offscreen_samples_ms\":[" +
  ui_null_array(count) +
  "],\"readback_samples_ms\":[" +
  ui_null_array(count) +
  "],\"offscreen_readback_samples_ms\":[" +
  ui_null_array(count) +
  "],\"frame_work_ms\":" +
  json_number(work_mean) +
  ",\"frame_interval_ms\":" +
  (if samples.interval_ms.is_empty() {
    "null"
  } else {
    json_number(interval_mean)
  }) +
  ",\"input_to_visible_ms\":" +
  (if scenario == "input" { json_number(input_mean) } else { "null" }) +
  ",\"offscreen_ms\":null,\"readback_ms\":null,\"offscreen_readback_ms\":null,\"dropped_display_frames\":" +
  dropped.to_string() +
  ",\"action_count\":" +
  count.to_string() +
  ",\"frame_sample_count\":" +
  samples.interval_ms.length().to_string() +
  ",\"warmup_action_count\":" +
  (if scenario == "open" { "0" } else { "1" }) +
  ",\"action_timestamps_epoch_ms\":[" +
  ui_json_array(action_timestamps_epoch_ms) +
  "],\"action_window_start_epoch_ms\":" +
  (if action_timestamps_epoch_ms.is_empty() {
    "null"
  } else {
    json_number(action_timestamps_epoch_ms[0])
  }) +
  ",\"action_window_end_epoch_ms\":" +
  (if action_timestamps_epoch_ms.is_empty() {
    "null"
  } else {
    json_number(action_window_end_epoch_ms)
  }) +
  ",\"first_interactive_ms\":" +
  json_number(first_interactive_ms) +
  ",\"document_load_ms\":" +
  json_number(document_load_ms) +
  ",\"surface_route\":\"win32-native-surface\",\"presentation_kind\":\"native-window\",\"window_mode\":\"native-window\",\"work_scope\":\"moui-build-layout-paint-draw\",\"display_timestamp_source\":\"" +
  display_timestamp_source +
  "\",\"viewport\":{\"width\":1280,\"height\":800},\"font\":\"system-ui 16px\",\"line_height\":1.55,\"overscan\":3,\"virtual_row_height\":66}"
}

///|
/// Real-window Win32 pump shared by the simplified benchmark app and the
/// official MoMark example app. Renderer wiring matches the platform GPU
/// route from the environment: Skia via `from_env` (raster or the Direct3D
/// GPU route), WGPU with the DirectWrite + cosmic fallback text engine.
async fn native_window_pump(
  title : String,
  state : NativeBenchState,
  requests : @window_lifecycle.WindowRequestQueue,
  renderer : String,
) -> Unit {
  let options = @windows_backend.WindowsHostAppOptions::new(
    // The clock presence makes the driver profile every frame, which keeps
    // `last_frame_timing` (the frame work samples) populated; the harness
    // itself observes frames through `on_frame_presented` and `pump_tick`.
    frame_clock=Some(fn() { now_ms() }),
    on_frame_presented=Some(fn() {
      if state.first_present_ms.val == 0.0 {
        state.first_present_ms.val = now_ms()
      }
    }),
    pump_tick=Some(async fn() -> Bool {
      native_bench_tick(state)
    }),
  )
  if renderer == "wgpu" {
    @runtime.run_app(title, state.runtime)
    .render(
      @render_wgpu.native(
        platform=@render_wgpu.WgpuNativePlatform::Windows,
        text_engine=@render_wgpu.native_platform_text_engine_with_fallback(
          @wgpu_directwrite.directwrite_text_provider(),
          fallback=@wgpu_cosmic.cosmic_text_engine(),
        ),
      ),
    )
    .window_requests(requests.requests())
    .backend(@windows_backend.entry(options~))
    .run_async_pump(frame_interval_ms=12)
  } else {
    @runtime.run_app(title, state.runtime)
    .render_all(
      @skia_renderer.from_env(platform=@skia_renderer.NativeGpuPlatform::Windows),
    )
    .window_requests(requests.requests())
    .backend(@windows_backend.entry(options~))
    .run_async_pump(frame_interval_ms=12)
  }
}

///|
async fn run_windows_native_ui_benchmark(
  fixture : String,
  scenario : String,
) -> Unit {
  let load_started = now_ms()
  let source = @fs.read_file_to_string(fixture) catch {
    _ => abort("MoUI native benchmark fixture is unreadable")
  }
  let document_load_ms = (now_ms() - load_started).max(0.0)
  let renderer = @env.get_env_var("MOUI_SKIA_RENDERER").unwrap_or("skia-raster")
  let adapter = if renderer == "wgpu" {
    "moui-wgpu"
  } else if renderer == "skia-gpu" {
    "moui-skia-gpu"
  } else {
    "moui-skia-raster"
  }
  let runtime = @runtime.new_program_with_dimensions(
    program=@app.program_with_source(
      source,
      environment=@windows_backend.app_environment(),
    ),
    width=1280.0,
    height=800.0,
  )
  // 统一口径：first_interactive 从进程起点（main 入口打点）起算，
  // runtime 构建与窗口创建全部计入。
  let state : NativeBenchState = {
    runtime,
    scenario,
    adapter,
    editor_key: "moui-markdown-editor",
    started: scope_started.val,
    document_load_ms,
    samples: ui_samples(),
    first_present_ms: Ref::new(0.0),
    action_timestamps_epoch_ms: [],
    step: 0,
    action_index: 0,
    action_started: 0.0,
    previous_end: 0.0,
    action_window_end_epoch_ms: 0.0,
  }
  native_window_pump(
    "MoUI Native UI Benchmark",
    state,
    @window_lifecycle.WindowRequestQueue::new(),
    renderer,
  )
}
