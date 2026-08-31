# Benchmark protocol

Each run uses `bench/run_benchmark.py` with deterministic fixtures from
`scripts/generate_fixtures.py`. The hardware UI entrypoint is
`scripts/run_ui_benchmark.sh`. It builds each application once and uses the
same three scenarios for every adapter:

1. **open**: launch a fresh process, read the fixture and produce the first
   interactive frame. This records work and `first_interactive_ms`; there is
   no preceding display timestamp, so its interval sample list is empty.
2. **input**: perform one unrecorded input warm-up, then insert ten ASCII
   characters and wait for a frame after every character.
3. **scroll**: perform one unrecorded scroll warm-up, then apply 120 alternating
   document scroll targets and wait for a frame after each target.

The internal action warm-up is distinct from the runner's process warm-up. The
default full run starts one discarded process and records three fresh-process
repetitions. `action_count`, `frame_sample_count` and
`warmup_action_count` make both layers auditable.

The v2 runner reports framework work (`frame_work_ms`), display pacing
(`frame_interval_ms`), action-to-visible input latency
(`input_to_visible_ms`), dropped display frames, document-load and
`first_interactive_ms`. WGPU and Skia GPU offscreen/readback costs are
reported independently when instrumented. A stage that was not instrumented
is represented by `null` samples and `null` aggregate values; numeric `0`
means that the route measured that stage and observed no CPU work. Aggregate
percentiles are calculated from pooled raw samples, not by averaging per-run percentiles. Process elapsed time remains
diagnostic metadata and is never used as startup. Raw JSON also records OS release, CPU,
memory, best-effort GPU (`GPU_MODEL` overrides probing), renderer flags,
toolchain versions and exact commands. Missing tools are `skipped`; crashes,
timeouts and malformed output are `error` records. The adapter timeout is
configurable with `--timeout` or `BENCHMARK_TIMEOUT_SECONDS`; the UI wrapper
defaults to 120 seconds per adapter invocation.

Before accepting a `ui-frame` record, the runner verifies the scenario, the
1280x800 viewport, exact action/sample/warm-up counts, finite nonnegative timing
values and valid dropped-frame counts. Input records must contain one finite
latency sample per action. Adapter-emitted error status is preserved.

Use the checked-in hardware command rather than reconstructing adapter strings:

```sh
./scripts/run_ui_benchmark.sh
```

## UI timing sources

| Adapter | Work source | Display interval source | Input latency endpoint |
| --- | --- | --- | --- |
| MoUI | `profile_draw_frame` phases plus renderer submission | synchronous render completion on a headless host surface | action-to-render completion |
| GPUI | action dispatch work (not GPUI draw/paint) | interval between `Window::on_next_frame` callbacks | action-to-`on_next_frame` |
| Flutter | `buildDuration + rasterDuration` | `FrameTiming.vsyncStart` deltas | action-to-`SchedulerBinding.endOfFrame` |
| Electron | DOM/update work | Chromium `requestAnimationFrame` interval | action-to-next animation frame |

These clocks answer related but not identical questions. In particular,
Electron rAF is not compositor tracing, GPUI's callback is not an OS present
timestamp, and the default MoUI UI benchmark uses a headless host surface
rather than an AppKit display window. For a strict macOS comparison, run
`./scripts/run_ui_benchmark.sh` with `UI_BENCHMARK_SYSTEM_TRACE=1`. The runner
holds each adapter behind a trace gate, attaches `xctrace`'s `Animation
Hitches` template, and reports `system_present_*` fields from the target
process's `display-surface-swap` rows. It filters by target process swap or
Metal surface IDs; it never mixes another window's compositor events. If a
target surface cannot be associated (including the current headless MoUI
path), strict columns are `n/a` rather than framework-callback fallbacks.
`n/a` means unmeasured, never zero.

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
