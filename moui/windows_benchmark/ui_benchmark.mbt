///|
struct UiTimingSamples {
  work_ms : Array[Double]
  interval_ms : Array[Double]
  build_ms : Array[Double]
  layout_ms : Array[Double]
  paint_ms : Array[Double]
  draw_ms : Array[Double]
  present_ms : Array[Double]
  input_to_visible_ms : Array[Double]
  offscreen_ms : Array[Double]
  readback_ms : Array[Double]
  offscreen_readback_ms : Array[Double]
}

///|
fn ui_samples() -> UiTimingSamples {
  {
    work_ms: [],
    interval_ms: [],
    build_ms: [],
    layout_ms: [],
    paint_ms: [],
    draw_ms: [],
    present_ms: [],
    input_to_visible_ms: [],
    offscreen_ms: [],
    readback_ms: [],
    offscreen_readback_ms: [],
  }
}

///|
/// Renderer-agnostic benchmark target: identical driving logic for every
/// MoUI backend, with only the frame submission and reporting labels swapped.
priv struct UiBenchmarkRenderer {
  adapter : String
  timing_source : String
  surface_route : String
  presentation_kind : String
  render : (@core.DrawFrame) -> (Double, Double, Double)
  text_system : @core.TextSystem?
  unsupported_command_count : () -> Int
}

///|
/// Windows surface-route default is the Direct3D Ganesh backend (the Metal
/// route only exists on macOS and is refused explicitly here).
fn ui_surface_route(renderer : String) -> @skia_renderer.SkiaSurfaceRoute {
  if renderer != "skia-gpu" {
    return RasterSurfaceRoute
  }
  match @env.get_env_var("MOUI_GPU_ROUTE").unwrap_or("direct3d") {
    "direct3d" => Direct3DGpuSurfaceRoute
    "vulkan" => VulkanGpuSurfaceRoute
    "egl" => EglGpuSurfaceRoute
    route =>
      abort("MoUI Windows benchmark does not support MOUI_GPU_ROUTE=\{route}")
  }
}

///|
extern "C" fn ui_u64_to_ptr(value : UInt64) -> @wgpu_c.OpaquePtr = "md_editor_benchmark_u64_to_ptr"

///|
extern "C" fn ui_offscreen_hwnd(
  width : Int,
  height : Int,
  scale_factor : Double,
) -> UInt64 = "md_editor_benchmark_offscreen_hwnd"

///|
extern "C" fn ui_offscreen_hinstance() -> UInt64 = "md_editor_benchmark_offscreen_hinstance"

///|
/// Offscreen WGPU renderer: a hidden, per-monitor-DPI-aware Win32 popup
/// window supplies the HWND that wgpu binds its D3D12 swapchain to, so the
/// benchmark renders real GPU frames without ever showing a window. This is
/// the Windows counterpart of the macOS offscreen CAMetalLayer path.
fn ui_renderer_wgpu(
  width : Double,
  height : Double,
) -> @render_wgpu.WgpuRenderer {
  let scale_factor = 1.0
  let hwnd = ui_offscreen_hwnd(
    (width * scale_factor).to_int(),
    (height * scale_factor).to_int(),
    scale_factor,
  )
  if hwnd == 0UL {
    abort("MoUI benchmark could not create the offscreen Win32 window")
  }
  let hinstance = ui_offscreen_hinstance()
  if hinstance == 0UL {
    abort("MoUI benchmark could not resolve the module instance")
  }
  let instance = @wgpu.Instance::create() catch {
    error => abort("MoUI WGPU instance unavailable: \{error.message()}")
  }
  let descriptor = @wgpu.surface_descriptor_windows_hwnd_new(
    ui_u64_to_ptr(hinstance),
    ui_u64_to_ptr(hwnd),
  )
  let surface = instance.create_surface(descriptor)
  @wgpu.surface_descriptor_free(descriptor)
  let host = @render_wgpu.HostWgpuSurface::new(instance~, surface~)
  let text_engine = @render_wgpu.native_platform_text_engine_with_fallback(
    @wgpu_directwrite.directwrite_text_provider(),
    fallback=@wgpu_cosmic.cosmic_text_engine(),
  )
  @render_wgpu.create_with_host_surface_and_text_engine(
    @core.SurfaceMetrics::from_logical(
      size=@core.Size::new(width~, height~),
      scale_factor~,
    ),
    host,
    text_engine~,
  ) catch {
    error => abort("MoUI WGPU renderer unavailable: \{error.message()}")
  }
}

///|
/// Windows Skia benchmark renderer. There is no host GPU present surface on
/// this platform route (no public swapchain-backed Skia window surface), so
/// even the Direct3D GPU route keeps the GPU-surface CPU-present fallback and
/// honestly reports its readback cost instead of pretending to have a
/// drawable target.
fn ui_skia_benchmark_renderer(
  renderer : String,
  width : Double,
  height : Double,
) -> UiBenchmarkRenderer {
  let route = ui_surface_route(renderer)
  let target = @skia_renderer.SkiaPresentTarget::new(
    description="markdown-ui-benchmark",
    present=_frame => true,
  )
  let result = @skia_renderer.create_with_present_target_and_route(
    @core.SurfaceMetrics::from_logical(size=@core.Size::new(width~, height~)),
    target,
    surface_route=route,
  ) catch {
    error => abort("MoUI UI renderer unavailable: \{error.message()}")
  }
  if (renderer == "skia-gpu") != result.surface_is_gpu() {
    abort(
      "MoUI renderer route did not produce the requested GPU/raster surface",
    )
  }
  let presentation_kind = match result.target_kind() {
    @skia_renderer.SkiaPresentKind::CpuPixelFrame => "cpu-pixel-frame"
    @skia_renderer.SkiaPresentKind::HostGpuSurface =>
      abort("MoUI Windows benchmark attached an unexpected host GPU target")
  }
  {
    adapter: if renderer == "skia-gpu" {
      "moui-skia-gpu"
    } else {
      "moui-skia-raster"
    },
    timing_source: "moui-headless-profile_draw_frame-plus-skia-render_frame",
    surface_route: result.surface_route().label(),
    presentation_kind,
    render: frame => {
      let render_started = now_ms()
      let present = result.render_frame(frame)
      if !present.presented {
        abort("MoUI Skia renderer did not present the benchmark frame")
      }
      let elapsed = (now_ms() - render_started).max(0.0)
      // The CPU pixel-frame presenter includes the GPU->CPU readback in the
      // render call, which the report breaks out separately.
      (elapsed, 0.0, elapsed)
    },
    text_system: Some(result.text_system()),
    unsupported_command_count: () => result.unsupported_command_count(),
  }
}

///|
fn ui_wgpu_benchmark_renderer(
  width : Double,
  height : Double,
) -> UiBenchmarkRenderer {
  let renderer = ui_renderer_wgpu(width, height)
  {
    adapter: "moui-wgpu",
    timing_source: "moui-headless-profile_draw_frame-plus-wgpu-render",
    surface_route: renderer.backend_kind().short_label(),
    presentation_kind: "host-gpu-surface",
    render: frame => {
      let render_started = now_ms()
      renderer.render(frame.commands)
      ((now_ms() - render_started).max(0.0), 0.0, 0.0)
    },
    text_system: Some(renderer.text_system()),
    unsupported_command_count: () => renderer.unsupported_command_count(),
  }
}

///|
fn ui_measure_frame(
  runtime : @runtime.AppRuntime,
  benchmark_renderer : UiBenchmarkRenderer,
  samples : UiTimingSamples,
  action_started : Double,
  previous_frame_end : Double,
) -> Double {
  let profiled = runtime.profile_draw_frame(now_ms)
  let timing = profiled.timing()
  let (present_ms, offscreen_ms, readback_ms) = (benchmark_renderer.render)(
    profiled.frame(),
  )
  // Cross-adapter unified accounting: `frame_work` covers the framework's
  // CPU-side frame production only (build/layout/paint/draw), the same scope
  // the native-window adapter declares as `moui-build-layout-paint-draw`.
  // Device rasterization and present completion — the raster CPU pixel frame,
  // the Direct3D/wgpu submit plus synchronous device wait — are reported
  // separately as `device_present_*` samples so every adapter's work number
  // measures the same kind of work.
  let frame_work_ms = timing.build_ms() +
    timing.layout_ms() +
    timing.paint_ms() +
    timing.draw_ms()
  let frame_end = now_ms()
  samples.work_ms.push(frame_work_ms)
  let interval_start = if previous_frame_end > 0.0 {
    previous_frame_end
  } else {
    action_started
  }
  samples.interval_ms.push((frame_end - interval_start).max(0.0))
  samples.build_ms.push(timing.build_ms())
  samples.layout_ms.push(timing.layout_ms())
  samples.paint_ms.push(timing.paint_ms())
  samples.draw_ms.push(timing.draw_ms())
  samples.present_ms.push(present_ms)
  samples.input_to_visible_ms.push((frame_end - action_started).max(0.0))
  samples.offscreen_ms.push(offscreen_ms)
  samples.readback_ms.push(readback_ms)
  samples.offscreen_readback_ms.push(offscreen_ms + readback_ms)
  frame_end
}

///|
fn ui_drive_input(runtime : @runtime.AppRuntime, index : Int) -> Unit {
  let tokens = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"]
  runtime.dispatch_event(TextInput(InsertText(tokens[index % tokens.length()])))
}

///|
fn ui_drive_scroll(runtime : @runtime.AppRuntime, index : Int) -> Unit {
  let direction = if index % 2 == 0 { -480.0 } else { 480.0 }
  let result = runtime.dispatch_pointer_input(
    @core.PointerEvent::new(
      position=@core.Point::new(x=480.0, y=360.0),
      phase=Move,
      wheel_delta=@core.Point::new(x=0.0, y=direction),
    ),
  )
  if !result.handled {
    abort("MoUI benchmark scroll event did not move the virtual document")
  }
}

///|
fn ui_json_array(values : Array[Double]) -> String {
  values.map(json_number).join(",")
}

///|
///  A null sample means that the stage was not instrumented for this route.
fn ui_null_array(length : Int) -> String {
  Array::make(length, "null").join(",")
}

///|
///  v2 protocol report. Timing arrays retain the raw samples so the runner
/// can pool repetitions without mixing work and display pacing semantics.
fn ui_report_v2(
  adapter : String,
  scenario : String,
  timing_source : String,
  samples : UiTimingSamples,
  first_interactive_ms : Double,
  document_load_ms : Double,
  surface_route : String,
  presentation_kind : String,
) -> String {
  let work_mean = samples.work_ms.fold(init=0.0, fn(total, value) {
      total + value
    }) /
    samples.work_ms.length().to_double()
  let interval_mean = if samples.interval_ms.length() > 0 {
    samples.interval_ms.fold(init=0.0, fn(total, value) { total + value }) /
    samples.interval_ms.length().to_double()
  } else {
    0.0
  }
  let input_mean = if scenario == "input" {
    samples.input_to_visible_ms.fold(init=0.0, fn(total, value) {
      total + value
    }) /
    samples.input_to_visible_ms.length().to_double()
  } else {
    0.0
  }
  let direct_gpu = presentation_kind == "host-gpu-surface"
  let offscreen_mean = samples.offscreen_ms.fold(init=0.0, fn(total, value) {
      total + value
    }) /
    samples.offscreen_ms.length().to_double()
  let readback_mean = samples.readback_ms.fold(init=0.0, fn(total, value) {
      total + value
    }) /
    samples.readback_ms.length().to_double()
  let present_mean = samples.present_ms.fold(init=0.0, fn(total, value) {
      total + value
    }) /
    samples.present_ms.length().to_double()
  "{\"adapter\":\"" +
  adapter +
  "\",\"measurement_scope\":\"ui-frame\",\"timing_source\":\"" +
  timing_source +
  "\",\"latency_source\":\"action-to-render-complete\",\"scenario\":\"" +
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
  (if direct_gpu {
    ui_null_array(samples.work_ms.length())
  } else {
    ui_json_array(samples.offscreen_ms)
  }) +
  "],\"readback_samples_ms\":[" +
  ui_json_array(samples.readback_ms) +
  "],\"offscreen_readback_samples_ms\":[" +
  ui_null_array(samples.work_ms.length()) +
  "],\"device_present_samples_ms\":[" +
  ui_json_array(samples.present_ms) +
  "],\"frame_work_ms\":" +
  json_number(work_mean) +
  ",\"frame_interval_ms\":" +
  (if samples.interval_ms.length() > 0 {
    json_number(interval_mean)
  } else {
    "null"
  }) +
  ",\"input_to_visible_ms\":" +
  (if scenario == "input" { json_number(input_mean) } else { "null" }) +
  ",\"offscreen_ms\":" +
  (if direct_gpu { "null" } else { json_number(offscreen_mean) }) +
  ",\"readback_ms\":" +
  json_number(readback_mean) +
  ",\"offscreen_readback_ms\":" +
  "null" +
  ",\"device_present_ms\":" +
  json_number(present_mean) +
  ",\"device_present_p95_ms\":" +
  json_number(percentile(samples.present_ms, 0.95)) +
  ",\"device_present_scope\":\"" +
  (if direct_gpu {
    "gpu-submit-plus-synchronous-present-wait"
  } else {
    "cpu-raster-plus-pixel-readback"
  }) +
  "\"" +
  ",\"frame_work_p95_ms\":" +
  json_number(percentile(samples.work_ms, 0.95)) +
  ",\"frame_interval_p95_ms\":" +
  (if samples.interval_ms.length() > 0 {
    json_number(percentile(samples.interval_ms, 0.95))
  } else {
    "null"
  }) +
  ",\"input_to_visible_p95_ms\":" +
  (if scenario == "input" {
    json_number(percentile(samples.input_to_visible_ms, 0.95))
  } else {
    "null"
  }) +
  // This adapter uses a synchronous host-surface completion clock, not a
  // compositor/vsync timestamp. Do not infer dropped display frames from it.
  ",\"dropped_display_frames\":null" +
  ",\"action_count\":" +
  samples.work_ms.length().to_string() +
  ",\"frame_sample_count\":" +
  samples.interval_ms.length().to_string() +
  ",\"warmup_action_count\":" +
  (if scenario == "open" { "0" } else { "1" }) +
  ",\"first_interactive_ms\":" +
  json_number(first_interactive_ms) +
  ",\"document_load_ms\":" +
  json_number(document_load_ms) +
  ",\"surface_route\":\"" +
  surface_route +
  "\",\"presentation_kind\":\"" +
  presentation_kind +
  "\",\"window_mode\":\"headless-host-surface\",\"work_scope\":\"moui-build-layout-paint-draw\",\"display_timestamp_source\":\"synchronous-render-completion-no-compositor-timestamp\",\"phase_samples_ms\":{\"build\":[" +
  ui_json_array(samples.build_ms) +
  "],\"layout\":[" +
  ui_json_array(samples.layout_ms) +
  "],\"paint\":[" +
  ui_json_array(samples.paint_ms) +
  "],\"draw\":[" +
  ui_json_array(samples.draw_ms) +
  "],\"present\":[" +
  ui_json_array(samples.present_ms) +
  "]},\"viewport\":{\"width\":1280,\"height\":800},\"font\":\"system-ui 16px\",\"line_height\":1.55,\"overscan\":3,\"virtual_row_height\":66}"
}

///|
fn run_ui_benchmark(fixture : String, scenario : String) -> Unit {
  let load_started = now_ms()
  let source = @fs.read_file_to_string(fixture) catch {
    _ => abort("MoUI benchmark fixture is unreadable")
  }
  let document_load_ms = (now_ms() - load_started).max(0.0)
  let renderer_name = @env.get_env_var("MOUI_SKIA_RENDERER").unwrap_or(
    "skia-raster",
  )
  let benchmark_renderer = if renderer_name == "wgpu" {
    ui_wgpu_benchmark_renderer(1280.0, 800.0)
  } else {
    ui_skia_benchmark_renderer(renderer_name, 1280.0, 800.0)
  }
  let started = now_ms()
  let runtime = @runtime.new_program_with_dimensions(
    program=@app.program_with_source(source),
    width=1280.0,
    height=800.0,
  )
  match benchmark_renderer.text_system {
    Some(text_system) => runtime.set_text_system(text_system)
    None => ()
  }
  let samples = ui_samples()
  let mut first_interactive_ms = 0.0
  if scenario == "open" {
    ignore(ui_measure_frame(runtime, benchmark_renderer, samples, started, 0.0))
    // A first frame has no preceding display timestamp. Keep its work sample
    // but leave interval/latency arrays empty for open, where they are not
    // comparable to a paced sequence.
    if samples.interval_ms.length() > 0 {
      ignore(samples.interval_ms.pop())
    }
    if samples.input_to_visible_ms.length() > 0 {
      ignore(samples.input_to_visible_ms.pop())
    }
    first_interactive_ms = (now_ms() - started).max(0.0)
  } else {
    if scenario == "input" {
      if !runtime.focus_key("moui-markdown-editor") {
        abort("MoUI benchmark could not focus the Markdown editor")
      }
    }
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
    let count = if scenario == "scroll" { 120 } else { 10 }
    for index in 0..<count {
      let action_started = now_ms()
      if scenario == "input" {
        ui_drive_input(runtime, index + 1)
      } else {
        ui_drive_scroll(runtime, index + 1)
      }
      previous_frame_end = ui_measure_frame(
        runtime, benchmark_renderer, samples, action_started, previous_frame_end,
      )
    }
  }
  if (benchmark_renderer.unsupported_command_count)() != 0 {
    abort("MoUI benchmark emitted unsupported renderer commands")
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
