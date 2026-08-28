///|
fn now_ms() -> Double {
  @env.now().reinterpret_as_int64().to_double()
}

///|
fn percentile(values : Array[Double], ratio : Double) -> Double {
  let sorted = values.copy()
  sorted.sort()
  sorted[((sorted.length() - 1).to_double() * ratio).round().to_int()]
}

///|
pub fn block_count(source : String) -> Int {
  parse_markdown_blocks(source).length()
}

///|
fn summary(
  scope : String,
  scenario : String,
  samples : Array[Double],
  document_load_ms : Double,
) -> String {
  let mean = samples.fold(init=0.0, fn(total, value) { total + value }) /
    samples.length().to_double()
  let dropped = samples.filter(value => value > 16.667).length()
  "{\"adapter\":\"gpui\",\"measurement_scope\":\"" +
  scope +
  "\",\"scenario\":\"" +
  scenario +
  "\",\"samples_ms\":[" +
  samples.map(value => value.to_string()).join(",") +
  "],\"mean_ms\":" +
  mean.to_string() +
  ",\"p95_ms\":" +
  percentile(samples, 0.95).to_string() +
  ",\"p99_ms\":" +
  percentile(samples, 0.99).to_string() +
  ",\"dropped_frames\":" +
  dropped.to_string() +
  ",\"input_latency_ms\":" +
  (if scenario == "input" { mean.to_string() } else { "null" }) +
  ",\"document_load_ms\":" +
  document_load_ms.to_string() +
  "}"
}

///|
fn benchmark_source(
  source : String,
  scenario : String,
  scope : String,
  document_load_ms : Double,
) -> Unit {
  let samples : Array[Double] = []
  let count = if scenario == "open" {
    1
  } else if scenario == "scroll" {
    120
  } else {
    10
  }
  for index in 0..<count {
    let value = if scenario == "input" {
      source + index.to_string()
    } else {
      source
    }
    let started = now_ms()
    let blocks = parse_markdown_blocks(value)
    if scope == "moonbit-command-buffer" {
      initialize(value, "")
      ignore(build_tree(0))
    } else {
      ignore(blocks.length())
    }
    samples.push((now_ms() - started).max(0.0))
  }
  println(summary(scope, scenario, samples, document_load_ms))
}

///|
pub fn run_benchmark(fixture : String, scenario : String) -> Unit {
  let source = @fs.read_file_to_string(fixture) catch {
    _ => {
      println(
        "{\"adapter\":\"gpui\",\"status\":\"error\",\"error\":\"fixture unreadable\"}",
      )
      return
    }
  }
  benchmark_source(source, scenario, "headless-render", 0.0)
}

///|
pub fn run_ui_benchmark(
  source : String,
  scenario : String,
  document_load_ms : Double,
) -> Unit {
  benchmark_source(source, scenario, "moonbit-command-buffer", document_load_ms)
}
