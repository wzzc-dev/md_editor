///|
fn main {
  let runtime = @app.program(environment=@macos_backend.app_environment())
  @runtime.run_app(
    "MoUI Markdown Editor",
    @runtime.new_program_with_dimensions(
      program=runtime,
      width=1280.0,
      height=800.0,
    ),
  )
  .render_all(
    @render_skia.from_env(platform=@render_skia.NativeGpuPlatform::MacOS),
  )
  .backend(@macos_backend.entry())
  .run()
}
