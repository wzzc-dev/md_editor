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
