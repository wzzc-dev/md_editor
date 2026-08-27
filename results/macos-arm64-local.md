# Markdown editor benchmark report

- Schema: `md-editor-benchmark/v1`
- Host: `macOS-26.3-arm64-arm-64bit` / `arm64` / `16.0 GiB`
- OS release: `25.3.0`; GPU: `Apple M4`
- Toolchains: `python=3.12.11, moon=moon 0.1.20260824 (dae026a 2026-08-24), rustc=rustc 1.94.0 (4a4ef493e 2026-03-02), cargo=cargo 1.94.0 (85eff7c80 2026-01-15), node=v25.2.1, npm=11.6.2, flutter=Flutter 3.47.1 • channel stable • https://github.com/flutter/flutter.git`
- Viewport: `1280x800 @ 60 Hz`

| Adapter | Fixture | Scenario | Scope | Mean ms | P95 ms | P99 ms | Input ms | Startup ms | Samples | Dropped | Drop rate | Status |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| electron | large | input | headless-render | 0.937 | 1.469 | 1.469 | 0.937 | - | 30 | 0 | 0.000% | measured |
| electron | large | open | headless-render | 1.489 | 1.489 | 1.489 | - | 229.472 | 3 | 0 | 0.000% | measured |
| electron | large | scroll | headless-render | 0.646 | 0.923 | 1.217 | - | - | 360 | 0 | 0.000% | measured |
| electron | medium | input | headless-render | 0.125 | 0.269 | 0.269 | 0.125 | - | 30 | 0 | 0.000% | measured |
| electron | medium | open | headless-render | 0.280 | 0.280 | 0.280 | - | 266.193 | 3 | 0 | 0.000% | measured |
| electron | medium | scroll | headless-render | 0.077 | 0.144 | 0.314 | - | - | 360 | 0 | 0.000% | measured |
| electron | small | input | headless-render | 0.030 | 0.121 | 0.121 | 0.030 | - | 30 | 0 | 0.000% | measured |
| electron | small | open | headless-render | 0.107 | 0.107 | 0.107 | - | 249.419 | 3 | 0 | 0.000% | measured |
| electron | small | scroll | headless-render | 0.012 | 0.023 | 0.054 | - | - | 360 | 0 | 0.000% | measured |
| electron | stress | input | headless-render | 9.871 | 14.354 | 14.354 | 9.871 | - | 30 | 0 | 0.000% | measured |
| electron | stress | open | headless-render | 13.582 | 13.582 | 13.582 | - | 242.178 | 3 | 0 | 0.000% | measured |
| electron | stress | scroll | headless-render | 7.716 | 9.355 | 13.541 | - | - | 360 | 0 | 0.000% | measured |
| electron-full | small | input | wysiwyg-full | 5.802 | 18.339 | 18.339 | 5.802 | - | 30 | 3 | 10.000% | measured |
| electron-full | small | open | wysiwyg-full | 17.777 | 17.777 | 17.777 | - | 249.419 | 3 | 3 | 100.000% | measured |
| electron-full | small | scroll | wysiwyg-full | 3.225 | 4.075 | 5.626 | - | - | 360 | 2 | 0.556% | measured |
| flutter-impeller | large | input | headless-render | 8.512 | 17.890 | 17.890 | 8.512 | - | 30 | 3 | 10.000% | measured |
| flutter-impeller | large | open | headless-render | 23.059 | 23.059 | 23.059 | - | 214.078 | 3 | 3 | 100.000% | measured |
| flutter-impeller | large | scroll | headless-render | 6.467 | 7.473 | 13.017 | - | - | 360 | 3 | 0.833% | measured |
| flutter-impeller | medium | input | headless-render | 1.533 | 5.921 | 5.921 | 1.533 | - | 30 | 0 | 0.000% | measured |
| flutter-impeller | medium | open | headless-render | 5.961 | 5.961 | 5.961 | - | 195.276 | 3 | 0 | 0.000% | measured |
| flutter-impeller | medium | scroll | headless-render | 0.682 | 0.835 | 2.364 | - | - | 360 | 0 | 0.000% | measured |
| flutter-impeller | small | input | headless-render | 0.552 | 2.349 | 2.349 | 0.552 | - | 30 | 0 | 0.000% | measured |
| flutter-impeller | small | open | headless-render | 2.451 | 2.451 | 2.451 | - | 189.730 | 3 | 0 | 0.000% | measured |
| flutter-impeller | small | scroll | headless-render | 0.134 | 0.338 | 0.589 | - | - | 360 | 0 | 0.000% | measured |
| flutter-impeller | stress | input | headless-render | 74.425 | 86.593 | 86.593 | 74.425 | - | 30 | 30 | 100.000% | measured |
| flutter-impeller | stress | open | headless-render | 81.782 | 81.782 | 81.782 | - | 282.921 | 3 | 3 | 100.000% | measured |
| flutter-impeller | stress | scroll | headless-render | 71.479 | 74.065 | 79.234 | - | - | 360 | 360 | 100.000% | measured |
| flutter-skia | large | input | headless-render | 8.861 | 18.548 | 18.548 | 8.861 | - | 30 | 3 | 10.000% | measured |
| flutter-skia | large | open | headless-render | 17.581 | 17.581 | 17.581 | - | 204.025 | 3 | 3 | 100.000% | measured |
| flutter-skia | large | scroll | headless-render | 6.723 | 7.673 | 13.354 | - | - | 360 | 3 | 0.833% | measured |
| flutter-skia | medium | input | headless-render | 1.526 | 5.855 | 5.855 | 1.526 | - | 30 | 0 | 0.000% | measured |
| flutter-skia | medium | open | headless-render | 5.983 | 5.983 | 5.983 | - | 193.363 | 3 | 0 | 0.000% | measured |
| flutter-skia | medium | scroll | headless-render | 0.693 | 0.833 | 2.239 | - | - | 360 | 0 | 0.000% | measured |
| flutter-skia | small | input | headless-render | 0.550 | 2.340 | 2.340 | 0.550 | - | 30 | 0 | 0.000% | measured |
| flutter-skia | small | open | headless-render | 2.318 | 2.318 | 2.318 | - | 189.921 | 3 | 0 | 0.000% | measured |
| flutter-skia | small | scroll | headless-render | 0.132 | 0.322 | 0.584 | - | - | 360 | 0 | 0.000% | measured |
| flutter-skia | stress | input | headless-render | 73.618 | 84.128 | 84.128 | 73.618 | - | 30 | 30 | 100.000% | measured |
| flutter-skia | stress | open | headless-render | 84.778 | 84.778 | 84.778 | - | 274.771 | 3 | 3 | 100.000% | measured |
| flutter-skia | stress | scroll | headless-render | 70.854 | 73.875 | 84.717 | - | - | 360 | 360 | 100.000% | measured |
| gpui | large | input | headless-render | 1.300 | 2.000 | 2.000 | 1.300 | - | 30 | 0 | 0.000% | measured |
| gpui | large | open | headless-render | 1.667 | 1.667 | 1.667 | - | 25.365 | 3 | 0 | 0.000% | measured |
| gpui | large | scroll | headless-render | 1.258 | 2.000 | 2.000 | - | - | 360 | 0 | 0.000% | measured |
| gpui | medium | input | headless-render | 0.127 | 0.135 | 0.135 | 0.127 | - | 30 | 0 | 0.000% | measured |
| gpui | medium | open | headless-render | 0.125 | 0.125 | 0.125 | - | 31.066 | 3 | 0 | 0.000% | measured |
| gpui | medium | scroll | headless-render | 0.125 | 0.125 | 0.135 | - | - | 360 | 0 | 0.000% | measured |
| gpui | small | input | headless-render | 0.012 | 0.013 | 0.013 | 0.012 | - | 30 | 0 | 0.000% | measured |
| gpui | small | open | headless-render | 0.013 | 0.013 | 0.013 | - | 34.961 | 3 | 0 | 0.000% | measured |
| gpui | small | scroll | headless-render | 0.012 | 0.013 | 0.013 | - | - | 360 | 0 | 0.000% | measured |
| gpui | stress | input | headless-render | 12.833 | 13.333 | 13.333 | 12.833 | - | 30 | 0 | 0.000% | measured |
| gpui | stress | open | headless-render | 13.000 | 13.000 | 13.000 | - | 60.374 | 3 | 0 | 0.000% | measured |
| gpui | stress | scroll | headless-render | 12.978 | 13.333 | 16.000 | - | - | 360 | 3 | 0.833% | measured |
| moui-skia-gpu | large | input | headless-render | 1.300 | 2.000 | 2.000 | 1.300 | - | 30 | 0 | 0.000% | measured |
| moui-skia-gpu | large | open | headless-render | 1.333 | 1.333 | 1.333 | - | 509.448 | 3 | 0 | 0.000% | measured |
| moui-skia-gpu | large | scroll | headless-render | 1.244 | 2.000 | 2.000 | - | - | 360 | 0 | 0.000% | measured |
| moui-skia-gpu | medium | input | headless-render | 0.125 | 0.125 | 0.125 | 0.125 | - | 30 | 0 | 0.000% | measured |
| moui-skia-gpu | medium | open | headless-render | 0.125 | 0.125 | 0.125 | - | 513.897 | 3 | 0 | 0.000% | measured |
| moui-skia-gpu | medium | scroll | headless-render | 0.123 | 0.125 | 0.125 | - | - | 360 | 0 | 0.000% | measured |
| moui-skia-gpu | small | input | headless-render | 0.008 | 0.083 | 0.083 | 0.008 | - | 30 | 0 | 0.000% | measured |
| moui-skia-gpu | small | open | headless-render | 0.000 | 0.000 | 0.000 | - | 512.223 | 3 | 0 | 0.000% | measured |
| moui-skia-gpu | small | scroll | headless-render | 0.012 | 0.125 | 0.125 | - | - | 360 | 0 | 0.000% | measured |
| moui-skia-gpu | stress | input | headless-render | 12.833 | 13.000 | 13.000 | 12.833 | - | 30 | 0 | 0.000% | measured |
| moui-skia-gpu | stress | open | headless-render | 13.000 | 13.000 | 13.000 | - | 548.785 | 3 | 0 | 0.000% | measured |
| moui-skia-gpu | stress | scroll | headless-render | 12.825 | 13.000 | 14.000 | - | - | 360 | 0 | 0.000% | measured |
| moui-skia-gpu-full | small | input | richtext-full | 4.100 | 5.000 | 5.000 | 4.100 | - | 30 | 0 | 0.000% | measured |
| moui-skia-gpu-full | small | open | richtext-full | 4.000 | 4.000 | 4.000 | - | 512.223 | 3 | 0 | 0.000% | measured |
| moui-skia-gpu-full | small | scroll | richtext-full | 4.086 | 5.000 | 5.000 | - | - | 360 | 0 | 0.000% | measured |
| moui-skia-raster | large | input | headless-render | 1.200 | 2.000 | 2.000 | 1.200 | - | 30 | 0 | 0.000% | measured |
| moui-skia-raster | large | open | headless-render | 1.000 | 1.000 | 1.000 | - | 493.563 | 3 | 0 | 0.000% | measured |
| moui-skia-raster | large | scroll | headless-render | 1.231 | 2.000 | 2.000 | - | - | 360 | 0 | 0.000% | measured |
| moui-skia-raster | medium | input | headless-render | 0.121 | 0.125 | 0.125 | 0.121 | - | 30 | 0 | 0.000% | measured |
| moui-skia-raster | medium | open | headless-render | 0.083 | 0.083 | 0.083 | - | 506.375 | 3 | 0 | 0.000% | measured |
| moui-skia-raster | medium | scroll | headless-render | 0.120 | 0.125 | 0.125 | - | - | 360 | 0 | 0.000% | measured |
| moui-skia-raster | small | input | headless-render | 0.013 | 0.083 | 0.083 | 0.013 | - | 30 | 0 | 0.000% | measured |
| moui-skia-raster | small | open | headless-render | 0.042 | 0.042 | 0.042 | - | 509.576 | 3 | 0 | 0.000% | measured |
| moui-skia-raster | small | scroll | headless-render | 0.012 | 0.125 | 0.125 | - | - | 360 | 0 | 0.000% | measured |
| moui-skia-raster | stress | input | headless-render | 12.567 | 13.000 | 13.000 | 12.567 | - | 30 | 0 | 0.000% | measured |
| moui-skia-raster | stress | open | headless-render | 13.000 | 13.000 | 13.000 | - | 524.551 | 3 | 0 | 0.000% | measured |
| moui-skia-raster | stress | scroll | headless-render | 12.731 | 13.000 | 14.333 | - | - | 360 | 0 | 0.000% | measured |
| moui-skia-raster-full | small | input | richtext-full | 4.000 | 4.333 | 4.333 | 4.000 | - | 30 | 0 | 0.000% | measured |
| moui-skia-raster-full | small | open | richtext-full | 4.000 | 4.000 | 4.000 | - | 509.576 | 3 | 0 | 0.000% | measured |
| moui-skia-raster-full | small | scroll | richtext-full | 4.033 | 4.333 | 4.667 | - | - | 360 | 0 | 0.000% | measured |

Raw samples are retained in the input JSON. Do not compare rows with different fixture, renderer, viewport or repetition settings.
