# Markdown editor benchmark report

- Schema: `md-editor-benchmark/v1`
- Host: `macOS-26.3-arm64-arm-64bit` / `arm64` / `16.0 GiB`
- OS release: `25.3.0`; GPU: `Apple M4`
- Toolchains: `python=3.12.11, moon=moon 0.1.20260824 (dae026a 2026-08-24), rustc=rustc 1.94.0 (4a4ef493e 2026-03-02), cargo=cargo 1.94.0 (85eff7c80 2026-01-15), node=v25.2.1, npm=11.6.2, flutter=Flutter 3.47.1 • channel stable • https://github.com/flutter/flutter.git`
- Viewport: `1280x800 @ 60 Hz`

| Adapter | Fixture | Scenario | Scope | Mean ms | P95 ms | P99 ms | Input ms | Document load ms | Interactive ms | Startup ms | Actions | Frames | Dropped | Drop rate | Status |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| electron | large | input | ui-frame | 10.013 | 10.600 | 10.800 | 9.707 | 2.915 | 86.167 | - | 30 | 30 | 0 | 0.000% | measured |
| electron | large | open | ui-frame | 85.300 | 85.600 | 85.600 | - | 2.784 | 85.300 | 293.070 | 3 | 3 | 3 | 100.000% | measured |
| electron | large | scroll | ui-frame | 10.001 | 10.600 | 10.900 | - | 3.618 | 85.833 | - | 360 | 360 | 0 | 0.000% | measured |
| electron | medium | input | ui-frame | 10.000 | 11.000 | 11.000 | 9.430 | 2.732 | 90.100 | - | 30 | 30 | 0 | 0.000% | measured |
| electron | medium | open | ui-frame | 84.033 | 85.000 | 85.000 | - | 2.618 | 84.033 | 286.814 | 3 | 3 | 3 | 100.000% | measured |
| electron | medium | scroll | ui-frame | 10.005 | 10.700 | 11.000 | - | 2.804 | 87.767 | - | 360 | 360 | 0 | 0.000% | measured |
| electron | small | input | ui-frame | 10.000 | 11.000 | 11.000 | 9.297 | 2.125 | 83.533 | - | 30 | 30 | 0 | 0.000% | measured |
| electron | small | open | ui-frame | 83.933 | 86.300 | 86.300 | - | 2.902 | 83.933 | 298.068 | 3 | 3 | 3 | 100.000% | measured |
| electron | small | scroll | ui-frame | 9.999 | 10.800 | 11.000 | - | 2.250 | 83.133 | - | 360 | 360 | 0 | 0.000% | measured |
| electron | stress | input | ui-frame | 9.980 | 10.800 | 11.000 | 9.397 | 4.275 | 110.067 | - | 30 | 30 | 0 | 0.000% | measured |
| electron | stress | open | ui-frame | 107.033 | 114.500 | 114.500 | - | 4.453 | 107.033 | 321.533 | 3 | 3 | 3 | 100.000% | measured |
| electron | stress | scroll | ui-frame | 10.000 | 10.900 | 11.000 | - | 4.796 | 104.733 | - | 360 | 360 | 0 | 0.000% | measured |
| flutter-impeller | large | input | ui-frame | 2.185 | 3.808 | 6.177 | 9.561 | 0.361 | 64.462 | - | 30 | 30 | 0 | 0.000% | measured |
| flutter-impeller | large | open | ui-frame | 37.339 | 67.089 | 67.089 | - | 0.375 | 60.924 | 232.248 | 3 | 3 | 3 | 100.000% | measured |
| flutter-impeller | large | scroll | ui-frame | 2.636 | 4.374 | 4.654 | - | 0.552 | 68.720 | - | 360 | 360 | 0 | 0.000% | measured |
| flutter-impeller | medium | input | ui-frame | 2.080 | 3.031 | 7.081 | 9.934 | 0.128 | 58.948 | - | 30 | 30 | 0 | 0.000% | measured |
| flutter-impeller | medium | open | ui-frame | 48.805 | 64.430 | 64.430 | - | 0.106 | 61.058 | 241.417 | 3 | 3 | 3 | 100.000% | measured |
| flutter-impeller | medium | scroll | ui-frame | 2.611 | 4.347 | 4.974 | - | 0.126 | 65.361 | - | 360 | 360 | 0 | 0.000% | measured |
| flutter-impeller | small | input | ui-frame | 2.044 | 3.085 | 6.527 | 9.825 | 0.082 | 60.427 | - | 30 | 30 | 0 | 0.000% | measured |
| flutter-impeller | small | open | ui-frame | 33.630 | 59.431 | 59.431 | - | 0.086 | 58.280 | 226.050 | 3 | 3 | 3 | 100.000% | measured |
| flutter-impeller | small | scroll | ui-frame | 2.226 | 3.308 | 4.452 | - | 0.080 | 63.225 | - | 360 | 360 | 0 | 0.000% | measured |
| flutter-impeller | stress | input | ui-frame | 2.354 | 5.016 | 7.330 | 9.636 | 2.851 | 95.810 | - | 30 | 30 | 0 | 0.000% | measured |
| flutter-impeller | stress | open | ui-frame | 98.758 | 99.784 | 99.784 | - | 2.833 | 98.758 | 266.546 | 3 | 3 | 3 | 100.000% | measured |
| flutter-impeller | stress | scroll | ui-frame | 2.604 | 4.142 | 4.487 | - | 2.963 | 97.030 | - | 360 | 360 | 0 | 0.000% | measured |
| flutter-skia | large | input | ui-frame | 2.011 | 3.633 | 4.191 | 9.349 | 0.368 | 68.043 | - | 30 | 30 | 0 | 0.000% | measured |
| flutter-skia | large | open | ui-frame | 66.906 | 68.740 | 68.740 | - | 0.376 | 66.906 | 228.106 | 3 | 3 | 3 | 100.000% | measured |
| flutter-skia | large | scroll | ui-frame | 2.525 | 4.211 | 5.470 | - | 0.475 | 66.100 | - | 360 | 360 | 0 | 0.000% | measured |
| flutter-skia | medium | input | ui-frame | 2.223 | 2.825 | 10.246 | 9.740 | 0.111 | 66.310 | - | 30 | 30 | 0 | 0.000% | measured |
| flutter-skia | medium | open | ui-frame | 64.341 | 66.108 | 66.108 | - | 0.104 | 64.341 | 229.385 | 3 | 3 | 3 | 100.000% | measured |
| flutter-skia | medium | scroll | ui-frame | 2.615 | 4.274 | 6.036 | - | 0.117 | 62.455 | - | 360 | 360 | 0 | 0.000% | measured |
| flutter-skia | small | input | ui-frame | 2.270 | 5.134 | 10.751 | 9.681 | 0.083 | 61.470 | - | 30 | 30 | 0 | 0.000% | measured |
| flutter-skia | small | open | ui-frame | 104.121 | 178.592 | 178.592 | - | 0.096 | 104.121 | 286.375 | 3 | 3 | 3 | 100.000% | measured |
| flutter-skia | small | scroll | ui-frame | 2.244 | 3.095 | 3.425 | - | 0.086 | 67.144 | - | 360 | 360 | 0 | 0.000% | measured |
| flutter-skia | stress | input | ui-frame | 2.587 | 7.600 | 8.341 | 9.390 | 3.001 | 96.871 | - | 30 | 30 | 0 | 0.000% | measured |
| flutter-skia | stress | open | ui-frame | 97.400 | 99.073 | 99.073 | - | 3.092 | 97.400 | 265.296 | 3 | 3 | 3 | 100.000% | measured |
| flutter-skia | stress | scroll | ui-frame | 2.583 | 4.094 | 4.422 | - | 3.125 | 96.442 | - | 360 | 360 | 0 | 0.000% | measured |
| gpui | large | input | moonbit-command-buffer | 36.200 | 38.000 | 38.000 | 36.200 | 2.667 | - | - | 30 | 30 | 30 | 100.000% | measured |
| gpui | large | open | moonbit-command-buffer | 37.333 | 38.000 | 38.000 | - | 2.667 | - | 64.754 | 3 | 3 | 3 | 100.000% | measured |
| gpui | large | scroll | moonbit-command-buffer | 36.492 | 38.000 | 44.000 | - | 2.667 | - | - | 360 | 360 | 360 | 100.000% | measured |
| gpui | medium | input | moonbit-command-buffer | 3.500 | 4.000 | 4.000 | 3.500 | 0.333 | - | - | 30 | 30 | 0 | 0.000% | measured |
| gpui | medium | open | moonbit-command-buffer | 4.000 | 4.000 | 4.000 | - | 0.000 | - | 27.788 | 3 | 3 | 0 | 0.000% | measured |
| gpui | medium | scroll | moonbit-command-buffer | 3.539 | 4.000 | 4.000 | - | 0.333 | - | - | 360 | 360 | 0 | 0.000% | measured |
| gpui | small | input | moonbit-command-buffer | 0.367 | 1.000 | 1.000 | 0.367 | 0.333 | - | - | 30 | 30 | 0 | 0.000% | measured |
| gpui | small | open | moonbit-command-buffer | 0.667 | 1.000 | 1.000 | - | 0.000 | - | 30.894 | 3 | 3 | 0 | 0.000% | measured |
| gpui | small | scroll | moonbit-command-buffer | 0.350 | 1.000 | 1.000 | - | 0.000 | - | - | 360 | 360 | 0 | 0.000% | measured |
| gpui | stress | input | moonbit-command-buffer | 372.600 | 382.000 | 383.000 | 372.600 | 22.667 | - | - | 30 | 30 | 30 | 100.000% | measured |
| gpui | stress | open | moonbit-command-buffer | 373.000 | 375.000 | 375.000 | - | 25.000 | - | 432.579 | 3 | 3 | 3 | 100.000% | measured |
| gpui | stress | scroll | moonbit-command-buffer | 369.694 | 381.000 | 389.000 | - | 24.667 | - | - | 360 | 360 | 360 | 100.000% | measured |
| moui-skia-gpu | large | input | ui-frame | 7.604 | 10.022 | 11.041 | 8.091 | 2.375 | 39.965 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-skia-gpu | large | open | ui-frame | 30.425 | 32.833 | 32.833 | - | 1.846 | 38.991 | 86.564 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-gpu | large | scroll | ui-frame | 12.029 | 16.140 | 16.685 | - | 2.446 | 39.106 | - | 360 | 360 | 6 | 1.667% | measured |
| moui-skia-gpu | medium | input | ui-frame | 6.863 | 9.991 | 10.214 | 7.204 | 0.270 | 36.882 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-skia-gpu | medium | open | ui-frame | 30.033 | 33.633 | 33.633 | - | 0.283 | 36.355 | 85.749 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 12.113 | 16.205 | 17.112 | - | 0.286 | 36.738 | - | 360 | 360 | 10 | 2.778% | measured |
| moui-skia-gpu | small | input | ui-frame | 6.866 | 10.410 | 17.441 | 7.185 | 0.068 | 36.574 | - | 30 | 30 | 1 | 3.333% | measured |
| moui-skia-gpu | small | open | ui-frame | 27.949 | 28.283 | 28.283 | - | 0.058 | 33.994 | 78.408 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-gpu | small | scroll | ui-frame | 12.139 | 15.769 | 16.967 | - | 0.064 | 35.653 | - | 360 | 360 | 7 | 1.944% | measured |
| moui-skia-gpu | stress | input | ui-frame | 7.512 | 8.778 | 8.798 | 9.930 | 25.646 | 60.180 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-skia-gpu | stress | open | ui-frame | 27.917 | 27.963 | 27.963 | - | 25.636 | 58.796 | 133.706 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 12.073 | 16.035 | 16.685 | - | 24.894 | 59.044 | - | 360 | 360 | 5 | 1.389% | measured |
| moui-skia-raster | large | input | ui-frame | 4.221 | 4.692 | 5.181 | 4.701 | 2.232 | 34.077 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-skia-raster | large | open | ui-frame | 24.958 | 26.349 | 26.349 | - | 2.160 | 33.775 | 63.913 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-raster | large | scroll | ui-frame | 11.593 | 15.444 | 16.349 | - | 2.218 | 33.005 | - | 360 | 360 | 2 | 0.556% | measured |
| moui-skia-raster | medium | input | ui-frame | 4.275 | 4.783 | 4.886 | 4.606 | 0.303 | 32.230 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-skia-raster | medium | open | ui-frame | 24.431 | 24.667 | 24.667 | - | 0.299 | 30.779 | 57.792 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-raster | medium | scroll | ui-frame | 11.514 | 15.361 | 16.041 | - | 0.309 | 31.600 | - | 360 | 360 | 3 | 0.833% | measured |
| moui-skia-raster | small | input | ui-frame | 4.217 | 4.882 | 5.345 | 4.536 | 0.062 | 32.327 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-skia-raster | small | open | ui-frame | 23.836 | 24.167 | 24.167 | - | 0.066 | 29.899 | 56.592 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-raster | small | scroll | ui-frame | 11.529 | 15.255 | 15.817 | - | 0.066 | 30.814 | - | 360 | 360 | 1 | 0.278% | measured |
| moui-skia-raster | stress | input | ui-frame | 4.232 | 4.419 | 4.420 | 6.668 | 21.740 | 55.943 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-skia-raster | stress | open | ui-frame | 23.971 | 24.307 | 24.307 | - | 25.587 | 54.395 | 107.100 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-raster | stress | scroll | ui-frame | 11.555 | 15.266 | 16.375 | - | 22.893 | 54.985 | - | 360 | 360 | 4 | 1.111% | measured |
| moui-wgpu | large | input | ui-frame | 12.721 | 13.347 | 13.504 | 13.281 | 2.404 | 90.931 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-wgpu | large | open | ui-frame | 71.476 | 72.571 | 72.571 | - | 2.414 | 80.135 | 128.528 | 3 | 3 | 3 | 100.000% | measured |
| moui-wgpu | large | scroll | ui-frame | 38.388 | 46.687 | 48.097 | - | 2.461 | 81.098 | - | 360 | 360 | 360 | 100.000% | measured |
| moui-wgpu | medium | input | ui-frame | 12.568 | 13.277 | 13.325 | 12.942 | 0.281 | 88.800 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-wgpu | medium | open | ui-frame | 74.086 | 75.006 | 75.006 | - | 0.287 | 80.472 | 127.963 | 3 | 3 | 3 | 100.000% | measured |
| moui-wgpu | medium | scroll | ui-frame | 38.559 | 47.174 | 49.661 | - | 0.259 | 78.537 | - | 360 | 360 | 360 | 100.000% | measured |
| moui-wgpu | small | input | ui-frame | 12.998 | 14.325 | 14.438 | 13.383 | 0.054 | 89.281 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-wgpu | small | open | ui-frame | 78.239 | 82.618 | 82.618 | - | 0.060 | 84.569 | 134.946 | 3 | 3 | 3 | 100.000% | measured |
| moui-wgpu | small | scroll | ui-frame | 38.400 | 47.294 | 49.059 | - | 0.068 | 79.204 | - | 360 | 360 | 360 | 100.000% | measured |
| moui-wgpu | stress | input | ui-frame | 13.079 | 13.856 | 14.148 | 15.855 | 25.169 | 116.420 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-wgpu | stress | open | ui-frame | 74.544 | 78.083 | 78.083 | - | 26.819 | 105.777 | 180.086 | 3 | 3 | 3 | 100.000% | measured |
| moui-wgpu | stress | scroll | ui-frame | 38.431 | 47.131 | 49.244 | - | 24.614 | 105.800 | - | 360 | 360 | 360 | 100.000% | measured |

## Matching UI 2x screen

| Target | Baseline | Metric | Worst ratio | Fixture / scenario | Screen |
| --- | --- | --- | ---: | --- | --- |
| moui-skia-raster | flutter-skia | Frame mean | 5.138x | small / scroll | over 2x |
| moui-skia-raster | flutter-skia | Frame P95 | 4.929x | small / scroll | over 2x |
| moui-skia-raster | flutter-skia | Frame P99 | 4.618x | small / scroll | over 2x |
| moui-skia-raster | flutter-skia | Input latency | 0.710x | stress / input | within 2x |
| moui-skia-raster | flutter-skia | Document load | 8.276x | stress / open | over 2x |
| moui-skia-raster | flutter-skia | First interactive | 0.577x | stress / input | within 2x |
| moui-skia-raster | flutter-skia | Startup | 0.404x | stress / open | within 2x |
| moui-skia-raster | flutter-impeller | Frame mean | 5.180x | small / scroll | over 2x |
| moui-skia-raster | flutter-impeller | Frame P95 | 4.612x | small / scroll | over 2x |
| moui-skia-raster | flutter-impeller | Frame P99 | 3.649x | stress / scroll | over 2x |
| moui-skia-raster | flutter-impeller | Input latency | 0.692x | stress / input | within 2x |
| moui-skia-raster | flutter-impeller | Document load | 9.032x | stress / open | over 2x |
| moui-skia-raster | flutter-impeller | First interactive | 0.584x | stress / input | within 2x |
| moui-skia-raster | flutter-impeller | Startup | 0.402x | stress / open | within 2x |
| moui-skia-raster | electron | Frame mean | 1.159x | large / scroll | within 2x |
| moui-skia-raster | electron | Frame P95 | 1.457x | large / scroll | within 2x |
| moui-skia-raster | electron | Frame P99 | 1.500x | large / scroll | within 2x |
| moui-skia-raster | electron | Input latency | 0.710x | stress / input | within 2x |
| moui-skia-raster | electron | Document load | 5.746x | stress / open | over 2x |
| moui-skia-raster | electron | First interactive | 0.525x | stress / scroll | within 2x |
| moui-skia-raster | electron | Startup | 0.333x | stress / open | within 2x |
| moui-skia-gpu | flutter-skia | Frame mean | 5.409x | small / scroll | over 2x |
| moui-skia-gpu | flutter-skia | Frame P95 | 5.095x | small / scroll | over 2x |
| moui-skia-gpu | flutter-skia | Frame P99 | 4.954x | small / scroll | over 2x |
| moui-skia-gpu | flutter-skia | Input latency | 1.058x | stress / input | within 2x |
| moui-skia-gpu | flutter-skia | Document load | 8.546x | stress / input | over 2x |
| moui-skia-gpu | flutter-skia | First interactive | 0.621x | stress / input | within 2x |
| moui-skia-gpu | flutter-skia | Startup | 0.504x | stress / open | within 2x |
| moui-skia-gpu | flutter-impeller | Frame mean | 5.454x | small / scroll | over 2x |
| moui-skia-gpu | flutter-impeller | Frame P95 | 4.767x | small / scroll | over 2x |
| moui-skia-gpu | flutter-impeller | Frame P99 | 3.811x | small / scroll | over 2x |
| moui-skia-gpu | flutter-impeller | Input latency | 1.030x | stress / input | within 2x |
| moui-skia-gpu | flutter-impeller | Document load | 9.049x | stress / open | over 2x |
| moui-skia-gpu | flutter-impeller | First interactive | 0.640x | large / open | within 2x |
| moui-skia-gpu | flutter-impeller | Startup | 0.502x | stress / open | within 2x |
| moui-skia-gpu | electron | Frame mean | 1.214x | small / scroll | within 2x |
| moui-skia-gpu | electron | Frame P95 | 1.523x | large / scroll | within 2x |
| moui-skia-gpu | electron | Frame P99 | 1.586x | small / input | within 2x |
| moui-skia-gpu | electron | Input latency | 1.057x | stress / input | within 2x |
| moui-skia-gpu | electron | Document load | 6.000x | stress / input | over 2x |
| moui-skia-gpu | electron | First interactive | 0.564x | stress / scroll | within 2x |
| moui-skia-gpu | electron | Startup | 0.416x | stress / open | within 2x |
| moui-wgpu | flutter-skia | Frame mean | 17.112x | small / scroll | over 2x |
| moui-wgpu | flutter-skia | Frame P95 | 15.281x | small / scroll | over 2x |
| moui-wgpu | flutter-skia | Frame P99 | 14.324x | small / scroll | over 2x |
| moui-wgpu | flutter-skia | Input latency | 1.688x | stress / input | within 2x |
| moui-wgpu | flutter-skia | Document load | 8.675x | stress / open | over 2x |
| moui-wgpu | flutter-skia | First interactive | 1.452x | small / input | within 2x |
| moui-wgpu | flutter-skia | Startup | 0.679x | stress / open | within 2x |
| moui-wgpu | flutter-impeller | Frame mean | 17.253x | small / scroll | over 2x |
| moui-wgpu | flutter-impeller | Frame P95 | 14.297x | small / scroll | over 2x |
| moui-wgpu | flutter-impeller | Frame P99 | 11.020x | small / scroll | over 2x |
| moui-wgpu | flutter-impeller | Input latency | 1.645x | stress / input | within 2x |
| moui-wgpu | flutter-impeller | Document load | 9.467x | stress / open | over 2x |
| moui-wgpu | flutter-impeller | First interactive | 1.506x | medium / input | within 2x |
| moui-wgpu | flutter-impeller | Startup | 0.676x | stress / open | within 2x |
| moui-wgpu | electron | Frame mean | 3.854x | medium / scroll | over 2x |
| moui-wgpu | electron | Frame P95 | 4.409x | medium / scroll | over 2x |
| moui-wgpu | electron | Frame P99 | 4.515x | medium / scroll | over 2x |
| moui-wgpu | electron | Input latency | 1.687x | stress / input | within 2x |
| moui-wgpu | electron | Document load | 6.023x | stress / open | over 2x |
| moui-wgpu | electron | First interactive | 1.069x | small / input | within 2x |
| moui-wgpu | electron | Startup | 0.560x | stress / open | within 2x |

Raw samples are retained in the input JSON. The screen above uses only matching `ui-frame` rows with the same fixture and scenario. Verify viewport, repetitions and warm-ups in the raw records before treating a ratio as comparable. Timing sources remain framework-specific and are not compositor-equivalent.
