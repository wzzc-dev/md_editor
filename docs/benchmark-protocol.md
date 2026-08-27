# Benchmark protocol

Each run uses `bench/run_benchmark.py` with deterministic fixtures from
`scripts/generate_fixtures.py`. The hardware UI entrypoint is
`scripts/run_ui_benchmark.sh`. It builds each application once and uses the
same three scenarios for every adapter:

1. **open**: launch a fresh process, read the fixture and produce the first
   interactive frame.
2. **input**: perform one unrecorded input warm-up, then insert ten ASCII
   characters and wait for a frame after every character.
3. **scroll**: perform one unrecorded scroll warm-up, then apply 120 alternating
   document scroll targets and wait for a frame after each target.

The internal action warm-up is distinct from the runner's process warm-up. The
default full run starts one discarded process and records three fresh-process
repetitions. `action_count`, `frame_sample_count` and
`warmup_action_count` make both layers auditable.

The runner reports mean, P95, P99, dropped frames (`frame_ms > 16.667`), input
latency, document-load, startup and first-interactive time. Raw JSON also records OS release,
CPU, memory, best-effort GPU (`GPU_MODEL` overrides probing), renderer flags,
toolchain versions and exact commands. Missing tools are `skipped`; crashes,
timeouts and malformed output are `error` records.

Use the checked-in hardware command rather than reconstructing adapter strings:

```sh
./scripts/run_ui_benchmark.sh
```

## UI timing sources

| Adapter | Frame source | Input latency endpoint |
| --- | --- | --- |
| MoUI | `profile_draw_frame` phases plus synchronous Skia `render_frame` | `render_frame` completion |
| GPUI | interval between `Window::on_next_frame` callbacks | next-frame callback |
| Flutter | engine `FrameTiming.totalSpan` | `SchedulerBinding.endOfFrame` |
| Electron | Chromium `requestAnimationFrame` interval | next animation-frame callback |

These clocks answer related but not identical questions. In particular,
Electron rAF is not compositor tracing, GPUI's callback is not an OS present
timestamp, and MoUI's GPU route uses an offscreen/readback present target. The
report's 2x table is therefore a screening calculation, not proof of
compositor-equivalent performance.

Flutter Profile is launched twice with engine switches. The wrapper rejects a
row unless startup output contains the matching `Using the Skia rendering
backend` or `Using the Impeller rendering backend` marker and the runtime
viewport is 1280x800. A transient renderer process crash is retried once and
recorded as `wrapper_retry_count`; persistent failure remains an error.

## Headless diagnostics

The separate command-line adapters remain useful for deterministic parser and
block-split regressions, but they are not UI renderer measurements:

- MoUI emits `headless-render` from the shared lightweight splitter and a
  Small-only `richtext-full` row from `markdown_document`.
- GPUI and Flutter emit the corresponding lightweight `headless-render` row.
- Electron emits `headless-render` plus a Small-only `wysiwyg-full` row from
  Vditor's bundled Lute `Md2VditorDOM` parser.

Run them with `scripts/run_benchmark.sh`. Never relabel its existing
`results/macos-arm64-local.*` capture as UI data.

## Comparison rules

The report includes `platform`, `machine`, `cpu`, `memory_gb`, GPU, renderer
verification and commands. Apply the acceptance screen only to matching
fixture, scenario, viewport, warm-up, repetition and `measurement_scope`
settings. The generated ratio table uses matching `ui-frame` rows only, but
the framework-specific clocks above still limit how strongly those ratios can
be interpreted.
