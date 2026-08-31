///|
/// Strict macOS path: a real AppKit window and native host surface. The
/// compositor timestamps themselves are collected externally by xctrace.

///|
extern "C" fn native_signpost_event(action_id : Int) -> Unit = "md_editor_benchmark_signpost_event"

///|
extern "C" fn native_delay_ms(milliseconds : Int) -> Unit = "md_editor_benchmark_delay_ms"

///|
extern "C" fn native_trace_tail_ms() -> Int = "md_editor_benchmark_trace_tail_ms"

///|
fn native_null_samples(length : Int) -> String {
  Array::make(length, "null").join(",")
}

///|
fn native_frame_work(runtime : @runtime.AppRuntime) -> Double {
  runtime.inspector_snapshot().runtime().last_frame_timing().total_ms()
}

///|
fn native_record_sample(
  runtime : @runtime.AppRuntime,
  samples : UiTimingSamples,
  action_started : Double,
  previous_end : Double,
) -> Double {
  let ended = now_ms()
  samples.work_ms.push(native_frame_work(runtime))
  samples.interval_ms.push((ended - previous_end).max(0.0))
  samples.input_to_visible_ms.push((ended - action_started).max(0.0))
  ended
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
  native_null_samples(count) +
  "],\"readback_samples_ms\":[" +
  native_null_samples(count) +
  "],\"offscreen_readback_samples_ms\":[" +
  native_null_samples(count) +
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
  ",\"surface_route\":\"appkit-native-surface\",\"presentation_kind\":\"native-window\",\"window_mode\":\"native-window\",\"work_scope\":\"moui-build-layout-paint-draw\",\"display_timestamp_source\":\"macos-compositor-trace\",\"viewport\":{\"width\":1280,\"height\":800},\"font\":\"system-ui 16px\",\"line_height\":1.55,\"overscan\":3,\"virtual_row_height\":66}"
}

///|
async fn native_drive_benchmark(
  runtime : @runtime.AppRuntime,
  requests : @window_lifecycle.WindowRequestQueue,
  adapter : String,
  scenario : String,
  started : Double,
  document_load_ms : Double,
) -> Unit {
  @async.sleep(120)
  let first_interactive_ms = (now_ms() - started).max(0.0)
  let samples = ui_samples()
  let action_timestamps_epoch_ms : Array[Double] = []
  let mut action_window_end_epoch_ms = 0.0
  if scenario == "open" {
    samples.work_ms.push(native_frame_work(runtime))
  } else {
    if scenario == "input" && !runtime.focus_key("moui-markdown-editor") {
      abort("MoUI native benchmark could not focus the editor")
    }
    if scenario == "input" {
      ui_drive_input(runtime, 0)
    } else {
      ui_drive_scroll(runtime, 0)
    }
    @async.sleep(12)
    let count = if scenario == "scroll" { 120 } else { 10 }
    let mut previous_end = now_ms()
    for index in 0..<count {
      action_timestamps_epoch_ms.push(epoch_ms())
      native_signpost_event(index)
      let action_started = now_ms()
      if scenario == "input" {
        ui_drive_input(runtime, index + 1)
      } else {
        ui_drive_scroll(runtime, index + 1)
      }
      @async.sleep(12)
      previous_end = native_record_sample(
        runtime, samples, action_started, previous_end,
      )
    }
    action_window_end_epoch_ms = epoch_ms()
  }
  println(
    native_ui_report(
      adapter, scenario, samples, first_interactive_ms, document_load_ms, action_timestamps_epoch_ms,
      action_window_end_epoch_ms,
    ),
  )
  // Give an attached xctrace session time to flush compositor/os-log stores
  // before the native window teardown ends the target process.
  if @env.get_env_var("UI_BENCHMARK_SYSTEM_PRESENT").unwrap_or("") == "1" {
    native_delay_ms(native_trace_tail_ms())
  }
  requests.close_window(@backend.WindowId::new(1))
}

///|
async fn run_macos_native_ui_benchmark(
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
      environment=@macos_backend.app_environment(),
    ),
    width=1280.0,
    height=800.0,
  )
  let requests = @window_lifecycle.WindowRequestQueue::new()
  let window_task : async () -> Unit = async fn() {
    if renderer == "wgpu" {
      @runtime.run_app("MoUI Native UI Benchmark", runtime)
      .render(
        @render_wgpu.native(
          platform=@render_wgpu.WgpuNativePlatform::MacOS,
          text_engine=@render_wgpu.native_platform_text_engine_with_fallback(
            @wgpu_coretext.coretext_text_provider(),
            fallback=@wgpu_cosmic.cosmic_text_engine(),
          ),
        ),
      )
      .window_requests(requests.requests())
      .backend(
        @macos_backend.entry(
          options=@macos_backend.MacosHostAppOptions::new(
            frame_clock=Some(now_ms),
          ),
        ),
      )
      .run_async_pump(frame_interval_ms=8)
    } else {
      @runtime.run_app("MoUI Native UI Benchmark", runtime)
      .render_all(
        @skia_renderer.from_env(
          platform=@skia_renderer.NativeGpuPlatform::MacOS,
        ),
      )
      .window_requests(requests.requests())
      .backend(
        @macos_backend.entry(
          options=@macos_backend.MacosHostAppOptions::new(
            frame_clock=Some(now_ms),
          ),
        ),
      )
      .run_async_pump(frame_interval_ms=8)
    }
  }
  let benchmark_task : async () -> Unit = async fn() {
    native_drive_benchmark(
      runtime,
      requests,
      adapter,
      scenario,
      now_ms(),
      document_load_ms,
    )
  }
  ignore(@async.all([window_task, benchmark_task]))
}
