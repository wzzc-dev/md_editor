# Windows amd64 reproduction

The benchmark protocol is operating-system agnostic and the same
`scripts/run_benchmark.sh` runs on Windows. The instructions below cover a
native Windows amd64 host (16 GiB) using Git Bash; WSL2 is also acceptable as
long as the adapters build native Windows binaries.

## Prerequisites

- **Rust** (`cargo`) for the GPUI adapter and editor.
- **MoonBit** (`moon`) for the MoUI adapter and editor; check out the MoUI
  workspace next to this repo (see `docs/build-and-run.md`).
- **Node 20+** for the Electron adapter.
- **Flutter/Dart** (optional) for the Flutter rows; if absent these are
  recorded as `skipped`.
- **Git Bash** (or any POSIX shell) to run `scripts/run_benchmark.sh`.

## Build checks

```sh
moon check moui/app --target native
cargo check --manifest-path gpui/Cargo.toml
npm install --prefix electron
```

`moon run moui/windows_skia --target native` opens the MoUI editor on Windows;
set `MOUI_SKIA_RENDERER=skia-raster` or `skia-gpu` to select the renderer.

## Run the full matrix

```sh
./scripts/run_benchmark.sh
```

This regenerates the fixtures, runs all adapters across the four fixtures
(small/medium/large/stress) and three scenarios (open/input/scroll), and writes
`results/local.json` plus `results/local.md`. The MoUI adapter uses
`env MOUI_SKIA_RENDERER=...`, which Git Bash exposes as the `env` executable.

For a Windows capture under a dedicated name, copy the output:

```sh
cp results/local.json results/windows-amd64-local.json
cp results/local.md  results/windows-amd64-local.md
python3 bench/report.py results/windows-amd64-local.json
```

## Notes

- The macOS arm64 capture (`results/macos-arm64-local.json`) confirms MoUI and
  GPUI are within 2x of Electron on every fixture/scenario for the comparable
  `headless-render` scope. The Windows capture is the remaining piece of
  deliverable #6 (MacOS arm64 + Windows amd64 results); it must be produced on a
  real Windows amd64 host, as Windows runtime metrics and OS metadata cannot be
  synthesized faithfully on macOS.
- Report rows with `measurement_scope=richtext-full` only appear for the small
  fixture by design (see `docs/limitations.md`); the `headless-render` row covers
  every fixture.
- Run on an idle machine with power saving disabled and a fixed 1280x800
  window. The report records OS release, CPU, memory, GPU and toolchain
  versions, so a Windows capture is directly comparable to the macOS one.
