# Adapter protocol

An adapter receives a fixture path and one scenario (`open`, `input` or
`scroll`) and prints one JSON object per line. The core payload is:

```json
{"adapter":"name","measurement_scope":"ui-frame","scenario":"scroll","samples_ms":[1.2],"mean_ms":1.2,"p95_ms":1.2,"p99_ms":1.2,"dropped_frames":0,"action_count":120,"frame_sample_count":120,"warmup_action_count":1,"input_latency_ms":null}
```

`run_benchmark.py` adds process elapsed time, command and environment metadata.
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
