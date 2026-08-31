# Adapter protocol

An adapter receives a fixture path and one scenario (`open`, `input` or
`scroll`) and prints one JSON object per line. The core payload is:

```json
{"adapter":"name","measurement_scope":"ui-frame","scenario":"scroll","frame_work_samples_ms":[1.2],"frame_interval_samples_ms":[16.7],"input_to_visible_samples_ms":[],"offscreen_samples_ms":[null],"readback_samples_ms":[null],"offscreen_readback_samples_ms":[null],"frame_work_ms":1.2,"frame_interval_ms":16.7,"input_to_visible_ms":null,"dropped_display_frames":0,"first_interactive_ms":12.0,"action_count":120,"frame_sample_count":120,"warmup_action_count":1}
```

The v2 protocol keeps framework work (`frame_work_*`) separate from display
pacing (`frame_interval_*`). Input actions use `input_to_visible_*`; dropped
frames are inferred from display intervals. WGPU and Skia GPU adapters expose
`offscreen_*` and `readback_*` independently. Uninstrumented stages use
`null`; numeric zero means an instrumented zero-cost stage. `first_interactive_ms`
is the first usable frame, never the total process lifetime. `run_benchmark.py`
adds process elapsed time, command and environment metadata but does not turn
it into a startup metric.
An adapter may emit multiple scopes; its emitted `adapter` field is
authoritative. Missing executables become `skipped`, while non-zero exits,
timeouts or absent JSON become `error`.

## Strict macOS display timing

Use `--system-present-trace` for a compositor-backed run. On macOS the runner
attaches `xctrace`'s `Animation Hitches` template to each measured process,
releases the adapter only after attach, and adds `system_present_timestamps_ms`,
`system_present_interval_samples_ms`, `system_input_to_present_samples_ms`,
`system_dropped_display_frames` and `system_first_present_ms`. The report uses
these fields for pacing, drop and first-present columns and does not fall back
to framework callback timestamps. Trace packages are kept under
`results/system-traces` by default; set `--system-trace-dir` to override. On
non-macOS hosts, or when a native surface cannot be associated, strict fields
are rendered as `n/a`.

## Real-window run

Use the build-once wrapper for comparable UI records:

```sh
./scripts/run_ui_benchmark.sh
```

The wrapper directly invokes built MoUI and GPUI binaries, Flutter Profile and
the installed Electron runtime. It writes `results/<platform>-ui.json` and the
corresponding Markdown report. Pass any harness options after the script, for
example `--fixture small --repetitions 1 --warmups 0`.

## Headless diagnostics

`scripts/run_benchmark.sh` retains the parser/block-split baseline. Its
`headless-render`, `richtext-full` and `wysiwyg-full` scopes are diagnostics;
they must not be compared to `ui-frame` rows or labelled as renderer timing.

See `docs/benchmark-protocol.md` for scenario definitions, clocks and
comparison rules.
