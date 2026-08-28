///|
fn now_ms() -> Double {
  @env.now().reinterpret_as_int64().to_double()
}

///|
fn main {
  ignore(@gpui_link.LINK_MARKER)
  let args = @env.args()
  if args.length() >= 4 && args[1] == "--benchmark" {
    @app.run_benchmark(args[2], args[3])
    return
  }
  if args.length() >= 4 && args[1] == "--ui-benchmark" {
    let load_started = now_ms()
    let source = @fs.read_file_to_string(args[2]) catch {
      _ => abort("GPUI benchmark fixture is unreadable")
    }
    @app.run_ui_benchmark(source, args[3], (now_ms() - load_started).max(0.0))
    return
  }
  let path = if args.length() >= 2 { args[1] } else { "" }
  let source = if path != "" {
    @fs.read_file_to_string(path) catch {
      _ => @app.SAMPLE
    }
  } else {
    @app.SAMPLE
  }
  @app.initialize(source, path)
  @gpui.register_dispatch(@app.dispatch)
  @gpui.expect_ok(@app.build_tree(0), "initial build_tree")
  @app.sync_input(0)
  @gpui.expect_ok(@gpui.run_window(0, 1280.0, 800.0), "run_window")
}
