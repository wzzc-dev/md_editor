///|
fn main {
  let runtime = @app.program(environment=@macos_backend.app_environment())
  @runtime.run_app(
    "MoUI Markdown Editor (WGPU)",
    @runtime.new_program_with_dimensions(
      program=runtime,
      width=1280.0,
      height=800.0,
    ),
  )
  .render(
    @render_wgpu.native(
      platform=@render_wgpu.WgpuNativePlatform::MacOS,
      text_engine=@render_wgpu.native_platform_text_engine_with_fallback(
        @wgpu_coretext.coretext_text_provider(),
        fallback=@wgpu_cosmic.cosmic_text_engine(),
      ),
    ),
  )
  .backend(@macos_backend.entry())
  .run()
}
