///|
fn main {
  @runtime.run_app(
    "MoUI Markdown Editor",
    @runtime.new_program_with_dimensions(
      program=@app.program(),
      width=1280.0,
      height=800.0,
    ),
  )
  .render_all(@render_skia.from_env(platform=MacOS))
  .backend(@macos.entry())
  .run()
}
