# Markdown editor benchmark report

- Schema: `md-editor-benchmark/v1`
- Host: `macOS-26.3-arm64-arm-64bit` / `arm64` / `16.0 GiB`
- OS release: `25.3.0`; GPU: `Apple M4`
- Toolchains: `python=3.12.11, moon=moon 0.1.20260824 (dae026a 2026-08-24), rustc=rustc 1.94.0 (4a4ef493e 2026-03-02), cargo=cargo 1.94.0 (85eff7c80 2026-01-15), node=v25.2.1, npm=11.6.2, flutter=Flutter 3.47.1 • channel stable • https://github.com/flutter/flutter.git`
- Viewport: `1280x800 @ 60 Hz`

| Adapter | Fixture | Scenario | Scope | Mean ms | P95 ms | P99 ms | Input ms | Document load ms | Interactive ms | Startup ms | Actions | Frames | Dropped | Drop rate | Status |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| electron | large | input | ui-frame | 10.003 | 10.967 | 10.967 | 9.593 | 7.689 | 99.967 | - | 30 | 30 | 0 | 0.000% | measured |
| electron | large | open | ui-frame | 92.433 | 92.433 | 92.433 | - | 3.689 | 92.433 | 345.503 | 3 | 3 | 3 | 100.000% | measured |
| electron | large | scroll | ui-frame | 9.998 | 11.000 | 11.000 | - | 6.284 | 92.467 | - | 360 | 360 | 0 | 0.000% | measured |
| electron | medium | input | ui-frame | 10.347 | 13.600 | 13.600 | 9.920 | 5.319 | 91.900 | - | 30 | 30 | 1 | 3.333% | measured |
| electron | medium | open | ui-frame | 109.800 | 109.800 | 109.800 | - | 5.136 | 109.800 | 374.037 | 3 | 3 | 3 | 100.000% | measured |
| electron | medium | scroll | ui-frame | 10.000 | 11.000 | 11.000 | - | 3.544 | 90.567 | - | 360 | 360 | 0 | 0.000% | measured |
| electron | small | input | ui-frame | 10.300 | 13.633 | 13.633 | 9.703 | 5.667 | 96.100 | - | 30 | 30 | 1 | 3.333% | measured |
| electron | small | open | ui-frame | 103.333 | 103.333 | 103.333 | - | 2.972 | 103.333 | 442.761 | 3 | 3 | 3 | 100.000% | measured |
| electron | small | scroll | ui-frame | 9.999 | 11.000 | 11.000 | - | 4.976 | 100.633 | - | 360 | 360 | 0 | 0.000% | measured |
| electron | stress | input | ui-frame | 10.067 | 11.000 | 11.000 | 9.643 | 5.918 | 107.433 | - | 30 | 30 | 0 | 0.000% | measured |
| electron | stress | open | ui-frame | 108.667 | 108.667 | 108.667 | - | 9.681 | 108.667 | 360.836 | 3 | 3 | 3 | 100.000% | measured |
| electron | stress | scroll | ui-frame | 10.002 | 10.967 | 11.000 | - | 9.303 | 106.867 | - | 360 | 360 | 0 | 0.000% | measured |
| flutter-impeller | large | input | ui-frame | 1.913 | 3.219 | 3.219 | 9.974 | 0.392 | 46.276 | - | 30 | 30 | 0 | 0.000% | measured |
| flutter-impeller | large | open | ui-frame | 37.497 | 37.497 | 37.497 | - | 0.416 | 38.194 | 234.821 | 3 | 3 | 3 | 100.000% | measured |
| flutter-impeller | large | scroll | ui-frame | 2.392 | 4.029 | 7.506 | - | 0.355 | 55.716 | - | 360 | 360 | 2 | 0.556% | measured |
| flutter-impeller | medium | input | ui-frame | 3.314 | 10.896 | 10.896 | 11.340 | 0.136 | 38.104 | - | 30 | 30 | 0 | 0.000% | measured |
| flutter-impeller | medium | open | ui-frame | 41.110 | 41.110 | 41.110 | - | 0.117 | 44.675 | 245.753 | 3 | 3 | 3 | 100.000% | measured |
| flutter-impeller | medium | scroll | ui-frame | 2.392 | 4.376 | 7.626 | - | 0.120 | 47.475 | - | 360 | 360 | 2 | 0.556% | measured |
| flutter-impeller | small | input | ui-frame | 3.203 | 10.613 | 10.613 | 10.816 | 0.089 | 41.403 | - | 30 | 30 | 1 | 3.333% | measured |
| flutter-impeller | small | open | ui-frame | 36.297 | 36.297 | 36.297 | - | 0.124 | 48.741 | 281.887 | 3 | 3 | 3 | 100.000% | measured |
| flutter-impeller | small | scroll | ui-frame | 2.188 | 3.651 | 7.763 | - | 0.111 | 47.097 | - | 360 | 360 | 3 | 0.833% | measured |
| flutter-impeller | stress | input | ui-frame | 3.520 | 11.190 | 11.190 | 10.626 | 2.678 | 79.488 | - | 30 | 30 | 0 | 0.000% | measured |
| flutter-impeller | stress | open | ui-frame | 71.813 | 71.813 | 71.813 | - | 2.780 | 71.813 | 267.326 | 3 | 3 | 3 | 100.000% | measured |
| flutter-impeller | stress | scroll | ui-frame | 2.216 | 4.068 | 5.489 | - | 2.637 | 84.599 | - | 360 | 360 | 0 | 0.000% | measured |
| flutter-skia | large | input | ui-frame | 4.003 | 16.439 | 16.439 | 11.604 | 0.395 | 52.897 | - | 30 | 30 | 1 | 3.333% | measured |
| flutter-skia | large | open | ui-frame | 41.115 | 41.115 | 41.115 | - | 0.495 | 41.115 | 237.732 | 3 | 3 | 3 | 100.000% | measured |
| flutter-skia | large | scroll | ui-frame | 2.381 | 4.245 | 7.615 | - | 0.407 | 38.497 | - | 360 | 360 | 2 | 0.556% | measured |
| flutter-skia | medium | input | ui-frame | 4.023 | 15.526 | 15.526 | 11.694 | 0.145 | 50.614 | - | 30 | 30 | 2 | 6.667% | measured |
| flutter-skia | medium | open | ui-frame | 31.652 | 31.652 | 31.652 | - | 0.098 | 50.506 | 267.239 | 3 | 3 | 3 | 100.000% | measured |
| flutter-skia | medium | scroll | ui-frame | 2.340 | 3.802 | 8.622 | - | 0.135 | 46.213 | - | 360 | 360 | 2 | 0.556% | measured |
| flutter-skia | small | input | ui-frame | 2.744 | 6.107 | 6.107 | 9.932 | 0.083 | 51.861 | - | 30 | 30 | 0 | 0.000% | measured |
| flutter-skia | small | open | ui-frame | 34.655 | 34.655 | 34.655 | - | 0.094 | 46.981 | 232.054 | 3 | 3 | 3 | 100.000% | measured |
| flutter-skia | small | scroll | ui-frame | 2.382 | 3.300 | 19.253 | - | 0.097 | 53.332 | - | 360 | 360 | 5 | 1.389% | measured |
| flutter-skia | stress | input | ui-frame | 3.769 | 11.472 | 11.472 | 10.887 | 2.817 | 76.387 | - | 30 | 30 | 0 | 0.000% | measured |
| flutter-skia | stress | open | ui-frame | 64.832 | 64.832 | 64.832 | - | 2.859 | 81.237 | 289.969 | 3 | 3 | 3 | 100.000% | measured |
| flutter-skia | stress | scroll | ui-frame | 2.157 | 3.898 | 4.409 | - | 2.917 | 75.585 | - | 360 | 360 | 0 | 0.000% | measured |
| gpui | large | input | ui-frame | 10.857 | 25.726 | 25.726 | 10.856 | 2.667 | 139.352 | - | 30 | 30 | 3 | 10.000% | measured |
| gpui | large | open | ui-frame | 147.016 | 147.016 | 147.016 | - | 2.667 | 147.016 | 298.265 | 3 | 3 | 3 | 100.000% | measured |
| gpui | large | scroll | ui-frame | 10.113 | 11.202 | 15.714 | - | 2.667 | 156.835 | - | 360 | 360 | 4 | 1.111% | measured |
| gpui | medium | input | ui-frame | 10.676 | 24.384 | 24.384 | 10.676 | 0.333 | 150.251 | - | 30 | 30 | 3 | 10.000% | measured |
| gpui | medium | open | ui-frame | 145.651 | 145.651 | 145.651 | - | 1.000 | 145.651 | 257.531 | 3 | 3 | 3 | 100.000% | measured |
| gpui | medium | scroll | ui-frame | 10.092 | 11.020 | 17.161 | - | 0.333 | 156.466 | - | 360 | 360 | 4 | 1.111% | measured |
| gpui | small | input | ui-frame | 10.952 | 23.625 | 23.625 | 10.952 | 0.000 | 143.578 | - | 30 | 30 | 4 | 13.333% | measured |
| gpui | small | open | ui-frame | 166.927 | 166.927 | 166.927 | - | 0.000 | 166.927 | 262.998 | 3 | 3 | 3 | 100.000% | measured |
| gpui | small | scroll | ui-frame | 10.079 | 11.001 | 14.220 | - | 0.000 | 159.395 | - | 360 | 360 | 3 | 0.833% | measured |
| gpui | stress | input | ui-frame | 11.942 | 31.189 | 31.189 | 11.942 | 25.333 | 149.278 | - | 30 | 30 | 3 | 10.000% | measured |
| gpui | stress | open | ui-frame | 142.848 | 142.848 | 142.848 | - | 25.667 | 142.848 | 283.529 | 3 | 3 | 3 | 100.000% | measured |
| gpui | stress | scroll | ui-frame | 10.159 | 11.013 | 15.960 | - | 26.667 | 163.069 | - | 360 | 360 | 5 | 1.389% | measured |
| moui-skia-gpu | large | input | ui-frame | 6.629 | 10.516 | 10.516 | 7.205 | 2.324 | 79.526 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-skia-gpu | large | open | ui-frame | 28.471 | 28.471 | 28.471 | - | 2.435 | 68.763 | 98.608 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-gpu | large | scroll | ui-frame | 15.569 | 20.351 | 22.420 | - | 2.499 | 69.793 | - | 360 | 360 | 107 | 29.722% | measured |
| moui-skia-gpu | medium | input | ui-frame | 7.052 | 18.500 | 18.500 | 7.490 | 0.321 | 72.238 | - | 30 | 30 | 1 | 3.333% | measured |
| moui-skia-gpu | medium | open | ui-frame | 33.589 | 33.589 | 33.589 | - | 0.377 | 76.406 | 109.395 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 15.927 | 20.709 | 22.143 | - | 0.274 | 68.655 | - | 360 | 360 | 120 | 33.333% | measured |
| moui-skia-gpu | small | input | ui-frame | 6.035 | 10.048 | 10.048 | 6.389 | 0.083 | 70.271 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-skia-gpu | small | open | ui-frame | 28.797 | 28.797 | 28.797 | - | 0.076 | 62.347 | 90.346 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-gpu | small | scroll | ui-frame | 17.514 | 26.311 | 39.716 | - | 0.095 | 72.511 | - | 360 | 360 | 142 | 39.444% | measured |
| moui-skia-gpu | stress | input | ui-frame | 5.899 | 9.900 | 9.900 | 8.722 | 22.023 | 89.776 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-skia-gpu | stress | open | ui-frame | 30.158 | 30.158 | 30.158 | - | 22.419 | 91.368 | 146.279 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 14.938 | 19.286 | 20.449 | - | 22.496 | 98.424 | - | 360 | 360 | 85 | 23.611% | measured |
| moui-skia-raster | large | input | ui-frame | 4.291 | 4.535 | 4.535 | 4.804 | 2.423 | 35.350 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-skia-raster | large | open | ui-frame | 25.541 | 25.541 | 25.541 | - | 2.553 | 34.694 | 65.057 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-raster | large | scroll | ui-frame | 15.886 | 22.127 | 28.319 | - | 2.746 | 39.086 | - | 360 | 360 | 98 | 27.222% | measured |
| moui-skia-raster | medium | input | ui-frame | 4.300 | 4.523 | 4.523 | 4.655 | 0.306 | 33.327 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-skia-raster | medium | open | ui-frame | 25.594 | 25.594 | 25.594 | - | 0.319 | 32.849 | 61.167 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-raster | medium | scroll | ui-frame | 14.571 | 18.474 | 22.743 | - | 0.327 | 32.918 | - | 360 | 360 | 59 | 16.389% | measured |
| moui-skia-raster | small | input | ui-frame | 4.403 | 5.031 | 5.031 | 4.754 | 0.079 | 33.121 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-skia-raster | small | open | ui-frame | 25.240 | 25.240 | 25.240 | - | 0.075 | 31.773 | 59.858 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-raster | small | scroll | ui-frame | 14.522 | 18.547 | 24.227 | - | 0.084 | 32.390 | - | 360 | 360 | 54 | 15.000% | measured |
| moui-skia-raster | stress | input | ui-frame | 5.239 | 6.159 | 6.159 | 8.260 | 23.992 | 66.563 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-skia-raster | stress | open | ui-frame | 35.877 | 35.877 | 35.877 | - | 28.416 | 88.925 | 153.495 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-raster | stress | scroll | ui-frame | 15.651 | 20.970 | 34.384 | - | 20.349 | 58.985 | - | 360 | 360 | 89 | 24.722% | measured |

## Matching UI 2x screen

| Target | Baseline | Metric | Worst ratio | Fixture / scenario | Screen |
| --- | --- | --- | ---: | --- | --- |
| moui-skia-raster | flutter-skia | Frame mean | 7.255x | stress / scroll | over 2x |
| moui-skia-raster | flutter-skia | Frame P95 | 5.621x | small / scroll | over 2x |
| moui-skia-raster | flutter-skia | Frame P99 | 7.798x | stress / scroll | over 2x |
| moui-skia-raster | flutter-skia | Input latency | 0.759x | stress / input | within 2x |
| moui-skia-raster | flutter-skia | Document load | 9.939x | stress / open | over 2x |
| moui-skia-raster | flutter-skia | First interactive | 1.095x | stress / open | within 2x |
| moui-skia-raster | flutter-skia | Startup | 0.529x | stress / open | within 2x |
| moui-skia-raster | flutter-impeller | Frame mean | 7.063x | stress / scroll | over 2x |
| moui-skia-raster | flutter-impeller | Frame P95 | 5.492x | large / scroll | over 2x |
| moui-skia-raster | flutter-impeller | Frame P99 | 6.264x | stress / scroll | over 2x |
| moui-skia-raster | flutter-impeller | Input latency | 0.777x | stress / input | within 2x |
| moui-skia-raster | flutter-impeller | Document load | 10.222x | stress / open | over 2x |
| moui-skia-raster | flutter-impeller | First interactive | 1.238x | stress / open | within 2x |
| moui-skia-raster | flutter-impeller | Startup | 0.574x | stress / open | within 2x |
| moui-skia-raster | electron | Frame mean | 1.589x | large / scroll | within 2x |
| moui-skia-raster | electron | Frame P95 | 2.012x | large / scroll | over 2x |
| moui-skia-raster | electron | Frame P99 | 3.126x | stress / scroll | over 2x |
| moui-skia-raster | electron | Input latency | 0.857x | stress / input | within 2x |
| moui-skia-raster | electron | Document load | 4.054x | stress / input | over 2x |
| moui-skia-raster | electron | First interactive | 0.818x | stress / open | within 2x |
| moui-skia-raster | electron | Startup | 0.425x | stress / open | within 2x |
| moui-skia-gpu | flutter-skia | Frame mean | 7.353x | small / scroll | over 2x |
| moui-skia-gpu | flutter-skia | Frame P95 | 7.974x | small / scroll | over 2x |
| moui-skia-gpu | flutter-skia | Frame P99 | 4.638x | stress / scroll | over 2x |
| moui-skia-gpu | flutter-skia | Input latency | 0.801x | stress / input | within 2x |
| moui-skia-gpu | flutter-skia | Document load | 7.842x | stress / open | over 2x |
| moui-skia-gpu | flutter-skia | First interactive | 1.813x | large / scroll | within 2x |
| moui-skia-gpu | flutter-skia | Startup | 0.504x | stress / open | within 2x |
| moui-skia-gpu | flutter-impeller | Frame mean | 8.003x | small / scroll | over 2x |
| moui-skia-gpu | flutter-impeller | Frame P95 | 7.207x | small / scroll | over 2x |
| moui-skia-gpu | flutter-impeller | Frame P99 | 5.116x | small / scroll | over 2x |
| moui-skia-gpu | flutter-impeller | Input latency | 0.821x | stress / input | within 2x |
| moui-skia-gpu | flutter-impeller | Document load | 8.530x | stress / scroll | over 2x |
| moui-skia-gpu | flutter-impeller | First interactive | 1.896x | medium / input | within 2x |
| moui-skia-gpu | flutter-impeller | Startup | 0.547x | stress / open | within 2x |
| moui-skia-gpu | electron | Frame mean | 1.752x | small / scroll | within 2x |
| moui-skia-gpu | electron | Frame P95 | 2.392x | small / scroll | over 2x |
| moui-skia-gpu | electron | Frame P99 | 3.611x | small / scroll | over 2x |
| moui-skia-gpu | electron | Input latency | 0.904x | stress / input | within 2x |
| moui-skia-gpu | electron | Document load | 3.721x | stress / input | over 2x |
| moui-skia-gpu | electron | First interactive | 0.921x | stress / scroll | within 2x |
| moui-skia-gpu | electron | Startup | 0.405x | stress / open | within 2x |
| gpui | flutter-skia | Frame mean | 4.817x | small / open | over 2x |
| gpui | flutter-skia | Frame P95 | 4.817x | small / open | over 2x |
| gpui | flutter-skia | Frame P99 | 4.817x | small / open | over 2x |
| gpui | flutter-skia | Input latency | 1.103x | small / input | within 2x |
| gpui | flutter-skia | Document load | 10.169x | medium / open | over 2x |
| gpui | flutter-skia | First interactive | 4.074x | large / scroll | over 2x |
| gpui | flutter-skia | Startup | 1.255x | large / open | within 2x |
| gpui | flutter-impeller | Frame mean | 5.677x | large / input | over 2x |
| gpui | flutter-impeller | Frame P95 | 7.991x | large / input | over 2x |
| gpui | flutter-impeller | Frame P99 | 7.991x | large / input | over 2x |
| gpui | flutter-impeller | Input latency | 1.124x | stress / input | within 2x |
| gpui | flutter-impeller | Document load | 10.111x | stress / scroll | over 2x |
| gpui | flutter-impeller | First interactive | 3.943x | medium / input | over 2x |
| gpui | flutter-impeller | Startup | 1.270x | large / open | within 2x |
| gpui | electron | Frame mean | 1.615x | small / open | within 2x |
| gpui | electron | Frame P95 | 2.835x | stress / input | over 2x |
| gpui | electron | Frame P99 | 2.835x | stress / input | over 2x |
| gpui | electron | Input latency | 1.238x | stress / input | within 2x |
| gpui | electron | Document load | 4.281x | stress / input | over 2x |
| gpui | electron | First interactive | 1.728x | medium / scroll | within 2x |
| gpui | electron | Startup | 0.863x | large / open | within 2x |

Raw samples are retained in the input JSON. The screen above uses only matching `ui-frame` rows with the same fixture and scenario. Verify viewport, repetitions and warm-ups in the raw records before treating a ratio as comparable. Timing sources remain framework-specific and are not compositor-equivalent.
