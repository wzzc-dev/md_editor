# Windows amd64 reproduction

Windows performance evidence must be captured on a real Windows amd64 16 GiB
host. WSL results are not a substitute because the desktop renderer, window
system and GPU route differ.

## Prerequisites

- Rust with the MSVC x64 target and Visual Studio C++ build tools.
- MoonBit native toolchain.
- Python 3.12+.
- Node 22.12+ (required by Electron 44).
- Current stable Flutter with Windows desktop support.
- Git Bash to execute the shared POSIX scripts.

Check out MoUI next to this repository if its MoonBit packages are not resolved
from the registry. Then validate the toolchains:

```sh
moon update
moon check moui/app --target native
moon check gpui/app gpui/cmd/main --target native
moon test gpui/app --target native
npm ci --prefix electron
flutter doctor -v
```

## Full UI matrix

From Git Bash on an idle machine with power saving disabled:

```sh
UI_BENCHMARK_OUT=results/windows-amd64-ui.json \
  ./scripts/run_ui_benchmark.sh
```

The script selects `MOUI_GPU_ROUTE=direct3d`, builds Flutter Profile for
Windows, verifies its Skia/Impeller startup logs, builds the MoonBit/GPUI native
executable, installs the Electron runtime and runs all four fixtures and three
scenarios. Default settings are one discarded process warm-up and three
recorded repetitions.

For a fast integration check first:

```sh
UI_BENCHMARK_REPETITIONS=1 UI_BENCHMARK_WARMUPS=0 \
  ./scripts/run_ui_benchmark.sh --fixture small \
  --out results/windows-amd64-smoke-ui.json
```

The final JSON must report `machine` as `AMD64`/`x86_64`, `memory_gb` near 16,
the real GPU model, 1280x800 viewports, `ui-frame` scope and no skipped/error
rows. Commit both the raw JSON and generated Markdown report when the hardware
capture is available.

## CI scope

GitHub Actions regenerates fixtures and uploads Small headless and UI smoke
artifacts on Windows. Hosted-runner data validates reproducibility, not the
16 GiB hardware acceptance result; runner virtualization and GPU availability
must be kept distinct from a dedicated-machine capture.
