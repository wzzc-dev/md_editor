///|
/// Native headless adapter for the shared benchmark protocol.
/// It executes the same MoUI runtime draw pipeline as the desktop app.
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
fn json_number(value : Double) -> String {
  value.to_string()
}

///|
fn main {
  let args = @env.args()
  if args.length() < 3 {
    println(
      "usage: moon run moui/benchmark --target native -- <fixture> <open|input|scroll>",
    )
    return
  }
  let source = @fs.read_file_to_string(args[1]) catch {
    _ => {
      println(
        "{\"adapter\":\"moui\",\"status\":\"error\",\"error\":\"fixture unreadable\"}",
      )
      return
    }
  }
  let scenario = args[2]
  let samples : Array[Double] = []
  let measure = fn(value : String) {
    // `env.now` is millisecond-resolution on native hosts. Repeat small
    // documents so their timings remain observable without changing the
    // large-document workload materially.
    let repeats = if value.length() < 100_000 { 8 } else { 1 }
    let start = now_ms()
    for _ in 0..<repeats {
      let runtime = @runtime.new_program_with_dimensions(
        program=@app.program_with_source(value),
        width=1280.0,
        height=800.0,
      )
      ignore(runtime.draw_frame())
      runtime.destroy()
    }
    samples.push((now_ms() - start).max(0.0) / repeats.to_double())
  }
  if scenario == "open" {
    measure(source)
  } else {
    let count = if scenario == "scroll" { 120 } else { 10 }
    for index in 0..<count {
      measure(
        if scenario == "input" {
          source + index.to_string()
        } else {
          source
        },
      )
    }
  }
  let total = samples.fold(init=0.0, fn(total, value) { total + value })
  let mean = total / samples.length().to_double()
  let dropped = samples.filter(value => value > 16.667).length()
  let values = samples.map(json_number).join(",")
  println(
    "{\"adapter\":\"moui\",\"measurement_scope\":\"headless-render\",\"scenario\":\"" +
    scenario +
    "\",\"samples_ms\":[" +
    values +
    "],\"mean_ms\":" +
    json_number(mean) +
    ",\"p95_ms\":" +
    json_number(percentile(samples, 0.95)) +
    ",\"p99_ms\":" +
    json_number(percentile(samples, 0.99)) +
    ",\"dropped_frames\":" +
    dropped.to_string() +
    ",\"input_latency_ms\":" +
    (if scenario == "input" { json_number(mean) } else { "null" }) +
    "}",
  )
}
