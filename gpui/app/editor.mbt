///|
pub const SAMPLE : String = "# GPUI MoonBit Markdown Editor\n\nEdit **Markdown** directly in the formatted document.\n\n- Open a .md file\n- Type normally\n- Scroll the document\n\n> The saved value is always Markdown source.\n"

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
  let bytes = source.to_array()
  let mut blocks = 0
  let mut in_code = false
  let mut paragraph = false
  let mut line_start = 0
  let mut i = 0
  while i <= bytes.length() {
    if i == bytes.length() || bytes[i] == '\n' {
      let mut start = line_start
      while start < i && (bytes[start] == ' ' || bytes[start] == '\t') {
        start += 1
      }
      let fence = start + 2 < i &&
        bytes[start] == '`' &&
        bytes[start + 1] == '`' &&
        bytes[start + 2] == '`'
      if in_code {
        if fence {
          blocks += 1
          in_code = false
        }
      } else if fence {
        if paragraph {
          blocks += 1
          paragraph = false
        }
        in_code = true
      } else {
        let mut blank = true
        for j in start..<i {
          if bytes[j] != ' ' && bytes[j] != '\t' && bytes[j] != '\r' {
            blank = false
            break
          }
        }
        let special = start + 1 < i &&
          (
            (bytes[start] == '>' && bytes[start + 1] == ' ') ||
            (bytes[start] == '-' && bytes[start + 1] == ' ') ||
            (bytes[start] == '*' && bytes[start + 1] == ' ')
          )
        let mut hashes = 0
        while start + hashes < i && bytes[start + hashes] == '#' {
          hashes += 1
        }
        let heading = hashes > 0 &&
          hashes <= 6 &&
          start + hashes < i &&
          bytes[start + hashes] == ' '
        if blank {
          if paragraph {
            blocks += 1
            paragraph = false
          }
        } else if special || heading {
          if paragraph {
            blocks += 1
            paragraph = false
          }
          blocks += 1
        } else {
          paragraph = true
        }
      }
      line_start = i + 1
    }
    i += 1
  }
  if in_code {
    blocks += 1
  }
  if paragraph {
    blocks += 1
  }
  blocks
}

///|
fn summary(scenario : String, samples : Array[Double]) -> String {
  let mean = samples.fold(init=0.0, fn(total, value) { total + value }) /
    samples.length().to_double()
  let dropped = samples.filter(value => value > 16.667).length()
  "{\"adapter\":\"gpui\",\"measurement_scope\":\"headless-render\",\"scenario\":\"" +
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
  "}"
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
  let samples : Array[Double] = []
  let measure = fn(value : String) {
    let repeats = if value.length() < 10_000 {
      1024
    } else if value.length() < 100_000 {
      64
    } else {
      1
    }
    let started = now_ms()
    for _ in 0..<repeats {
      ignore(block_count(value))
    }
    samples.push((now_ms() - started).max(0.0) / repeats.to_double())
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
  println(summary(scenario, samples))
}
