///|
#borrow(source)
extern "C" fn run_gpui(source : Bytes, length : Int) -> Int = "gpui_markdown_editor_run"

///|
#borrow(source, scenario)
extern "C" fn run_gpui_benchmark(
  source : Bytes,
  length : Int,
  scenario : Bytes,
  scenario_length : Int,
  document_load_ms : Double,
) -> Int = "gpui_markdown_editor_benchmark_run"

///|
fn now_ms() -> Double {
  @env.now().reinterpret_as_int64().to_double()
}

///|
fn main {
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
    let document_load_ms = (now_ms() - load_started).max(0.0)
    let source_bytes = @utf8.encode(source)
    let scenario_bytes = @utf8.encode(args[3])
    let status = run_gpui_benchmark(
      source_bytes,
      source_bytes.length(),
      scenario_bytes,
      scenario_bytes.length(),
      document_load_ms,
    )
    if status != 0 {
      abort("GPUI UI benchmark failed with status \{status}")
    }
    return
  }
  let source = if args.length() >= 2 {
    @fs.read_file_to_string(args[1]) catch {
      _ => @app.SAMPLE
    }
  } else {
    @app.SAMPLE
  }
  let bytes = @utf8.encode(source)
  let status = run_gpui(bytes, bytes.length())
  if status != 0 {
    abort("GPUI native host failed with status \{status}")
  }
}
