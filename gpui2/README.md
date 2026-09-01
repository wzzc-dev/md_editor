# GPUI2 Markdown Editor (md_mbt)

gpui2 is the second GPUI-based adapter in this benchmark: it runs the
[md_mbt](https://github.com/wzzc-dev/md_mbt) editor — a MoonBit Markdown
WYSIWYG core (velotype-style block model, live inline transforms, snapshot
undo) rendered through GPUI. Where the `gpui` adapter uses this repository's
own block editor with a native-input source overlay, gpui2 exercises a
different editor architecture on the same GPUI backend, so the two rows show
what the framework costs change when the MoonBit-side model changes.

The md_mbt checkout lives beside this repository (override with `MD_MBT_DIR`).
Its vendored `third_party/gpui-moonbit` is the same wzzc-dev fork pinned by
`gpui/vendor/gpui-moonbit`, including the window benchmark loop; the ui-frame
JSON row is emitted by that Rust loop with `UI_BENCHMARK_ADAPTER_NAME=gpui2`.

## Interaction with the harness

| Entry | Mode | Scope |
| --- | --- | --- |
| `gpui2/build.py` | builds `md_mbt` (`moon build --target native --release`) and installs `dist/gpui2-markdown-editor` | — |
| `gpui2/ui_benchmark.py` | `--ui-benchmark <fixture> <scenario>` | `ui-frame` (real window, vsync-paced Rust frame loop; input actions are injected as real `EVENT_TEXT` dispatches, scroll drives the retained `ScrollHandle`) |
| `gpui2/benchmark.py` | `--benchmark <fixture> <scenario>` | `headless-render` (parse + canonical serialize round-trip, no window/FFI) |

md_mbt renders the whole block tree in one retained GPUI tree with no
virtualization, so large fixtures cost proportionally more paint work than the
virtualized adapters; that difference is real data, not a harness artifact.

md_mbt itself is validated on macOS arm64 only. On other platforms the
adapters print the shared `{"status":"skipped"}` protocol row instead of
failing the run.

```shell
./build.sh
python3 ui_benchmark.py ../data/small.md input
python3 benchmark.py ../data/small.md open
```
