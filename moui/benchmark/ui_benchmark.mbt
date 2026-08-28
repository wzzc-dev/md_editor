///|
struct UiTimingSamples {
  frame_ms : Array[Double]
  build_ms : Array[Double]
  layout_ms : Array[Double]
  paint_ms : Array[Double]
  draw_ms : Array[Double]
  present_ms : Array[Double]
  latency_ms : Array[Double]
}

///|
fn ui_samples() -> UiTimingSamples {
  {
    frame_ms: [],
    build_ms: [],
    layout_ms: [],
    paint_ms: [],
    draw_ms: [],
    present_ms: [],
    latency_ms: [],
  }
}

///|
/// Renderer-agnostic benchmark target: identical driving logic for every
/// MoUI backend, with only the frame submission and reporting labels swapped.
struct UiBenchmarkRenderer {
  adapter : String
  timing_source : String
  surface_route : String
  render : (@core.DrawFrame) -> Unit
  text_system : @core.TextSystem?
  unsupported_command_count : () -> Int
}

///|
fn ui_surface_route(renderer : String) -> @skia_renderer.SkiaSurfaceRoute {
  if renderer != "skia-gpu" {
    return RasterSurfaceRoute
  }
  match @env.get_env_var("MOUI_GPU_ROUTE").unwrap_or("metal") {
    "direct3d" => Direct3DGpuSurfaceRoute
    "vulkan" => VulkanGpuSurfaceRoute
    "egl" => EglGpuSurfaceRoute
    _ => MetalGpuSurfaceRoute
  }
}

///|
extern "C" fn ui_u64_to_ptr(value : UInt64) -> @wgpu_c.OpaquePtr = "md_editor_benchmark_u64_to_ptr"

///|
extern "C" fn ui_offscreen_metal_layer(
  width : Int,
  height : Int,
  scale_factor : Double,
) -> UInt64 = "md_editor_benchmark_offscreen_metal_layer"

///|
fn ui_renderer_wgpu(
  width : Double,
  height : Double,
) -> @render_wgpu.WgpuRenderer {
  let scale_factor = 1.0
  let layer = ui_offscreen_metal_layer(
    (width * scale_factor).to_int(),
    (height * scale_factor).to_int(),
    scale_factor,
  )
  if layer == 0UL {
    abort("MoUI benchmark could not create the offscreen CAMetalLayer")
  }
  let instance = @wgpu.Instance::create() catch {
    error => abort("MoUI WGPU instance unavailable: \{error.message()}")
  }
  let descriptor = @wgpu.surface_descriptor_metal_layer_new(
    ui_u64_to_ptr(layer),
  )
  let surface = instance.create_surface(descriptor)
  @wgpu.surface_descriptor_free(descriptor)
  let host = @render_wgpu.HostWgpuSurface::new(instance~, surface~)
  let text_engine = @render_wgpu.native_platform_text_engine_with_fallback(
    @wgpu_coretext.coretext_text_provider(),
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
fn ui_skia_benchmark_renderer(
  renderer : String,
  width : Double,
  height : Double,
) -> UiBenchmarkRenderer {
  let target = @skia_renderer.SkiaPresentTarget::new(
    description="markdown-ui-benchmark",
    present=_frame => true,
  )
  let route = ui_surface_route(renderer)
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
  {
    adapter: if renderer == "skia-gpu" {
      "moui-skia-gpu"
    } else {
      "moui-skia-raster"
    },
    timing_source: "moui-profile_draw_frame-plus-skia-render_frame",
    surface_route: result.surface_route().label(),
    render: frame => {
      let present = result.render_frame(frame)
      if !present.presented {
        abort("MoUI Skia renderer did not present the benchmark frame")
      }
    },
    text_system: None,
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
    timing_source: "moui-profile_draw_frame-plus-wgpu-render",
    surface_route: renderer.backend_kind().short_label(),
    render: frame => renderer.render(frame.commands),
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
) -> Unit {
  let profiled = runtime.profile_draw_frame(now_ms)
  let timing = profiled.timing()
  let present_started = now_ms()
  (benchmark_renderer.render)(profiled.frame())
  let present_ms = (now_ms() - present_started).max(0.0)
  let frame_ms = timing.build_ms() +
    timing.layout_ms() +
    timing.paint_ms() +
    timing.draw_ms() +
    present_ms
  samples.frame_ms.push(frame_ms)
  samples.build_ms.push(timing.build_ms())
  samples.layout_ms.push(timing.layout_ms())
  samples.paint_ms.push(timing.paint_ms())
  samples.draw_ms.push(timing.draw_ms())
  samples.present_ms.push(present_ms)
  samples.latency_ms.push((now_ms() - action_started).max(0.0))
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
fn ui_report(
  adapter : String,
  scenario : String,
  timing_source : String,
  samples : UiTimingSamples,
  first_interactive_ms : Double,
  document_load_ms : Double,
  surface_route : String,
) -> String {
  let total = samples.frame_ms.fold(init=0.0, fn(total, value) { total + value })
  let mean = total / samples.frame_ms.length().to_double()
  let dropped = samples.frame_ms.filter(value => value > 16.667).length()
  let latency_total = samples.latency_ms.fold(init=0.0, fn(total, value) {
    total + value
  })
  let latency_mean = latency_total / samples.latency_ms.length().to_double()
  "{\"adapter\":\"" +
  adapter +
  "\",\"measurement_scope\":\"ui-frame\",\"timing_source\":\"" +
  timing_source +
  "\",\"latency_source\":\"synchronous-action-to-render_frame-complete\",\"scenario\":\"" +
  scenario +
  "\",\"samples_ms\":[" +
  ui_json_array(samples.frame_ms) +
  "],\"mean_ms\":" +
  json_number(mean) +
  ",\"p95_ms\":" +
  json_number(percentile(samples.frame_ms, 0.95)) +
  ",\"p99_ms\":" +
  json_number(percentile(samples.frame_ms, 0.99)) +
  ",\"dropped_frames\":" +
  dropped.to_string() +
  ",\"dropped_frame_rate\":" +
  json_number(dropped.to_double() / samples.frame_ms.length().to_double()) +
  ",\"action_count\":" +
  samples.frame_ms.length().to_string() +
  ",\"frame_sample_count\":" +
  samples.frame_ms.length().to_string() +
  ",\"warmup_action_count\":" +
  (if scenario == "open" { "0" } else { "1" }) +
  ",\"input_latency_ms\":" +
  (if scenario == "input" { json_number(latency_mean) } else { "null" }) +
  ",\"input_latency_samples_ms\":[" +
  (if scenario == "input" { ui_json_array(samples.latency_ms) } else { "" }) +
  "],\"first_interactive_ms\":" +
  json_number(first_interactive_ms) +
  ",\"document_load_ms\":" +
  json_number(document_load_ms) +
  ",\"surface_route\":\"" +
  surface_route +
  "\",\"phase_samples_ms\":{\"build\":[" +
  ui_json_array(samples.build_ms) +
  "],\"layout\":[" +
  ui_json_array(samples.layout_ms) +
  "],\"paint\":[" +
  ui_json_array(samples.paint_ms) +
  "],\"draw\":[" +
  ui_json_array(samples.draw_ms) +
  "],\"present\":[" +
  ui_json_array(samples.present_ms) +
  "]},\"viewport\":{\"width\":1280,\"height\":800}}"
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
    ui_measure_frame(runtime, benchmark_renderer, samples, started)
    first_interactive_ms = (now_ms() - started).max(0.0)
  } else {
    if scenario == "input" {
      if !runtime.focus_key("moui-markdown-editor") {
        abort("MoUI benchmark could not focus the Markdown editor")
      }
    }
    let warmup = ui_samples()
    ui_measure_frame(runtime, benchmark_renderer, warmup, started)
    first_interactive_ms = (now_ms() - started).max(0.0)
    let warmup_action_started = now_ms()
    if scenario == "input" {
      ui_drive_input(runtime, 0)
    } else {
      ui_drive_scroll(runtime, 0)
    }
    ui_measure_frame(runtime, benchmark_renderer, warmup, warmup_action_started)
    let count = if scenario == "scroll" { 120 } else { 10 }
    for index in 0..<count {
      let action_started = now_ms()
      if scenario == "input" {
        ui_drive_input(runtime, index + 1)
      } else {
        ui_drive_scroll(runtime, index + 1)
      }
      ui_measure_frame(runtime, benchmark_renderer, samples, action_started)
    }
  }
  if (benchmark_renderer.unsupported_command_count)() != 0 {
    abort("MoUI benchmark emitted unsupported renderer commands")
  }
  println(
    ui_report(
      benchmark_renderer.adapter,
      scenario,
      benchmark_renderer.timing_source,
      samples,
      first_interactive_ms,
      document_load_ms,
      benchmark_renderer.surface_route,
    ),
  )
}
