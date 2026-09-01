# Markdown editor benchmark report

- Schema: `md-editor-benchmark/v1`
- Host: `macOS-26.3-arm64-arm-64bit` / `arm64` / `16.0 GiB`
- OS release: `25.3.0`; GPU: `Apple M4`
- Toolchains: `python=3.12.11, moon=moon 0.1.20260824 (dae026a 2026-08-24), rustc=rustc 1.94.0 (4a4ef493e 2026-03-02), cargo=cargo 1.94.0 (85eff7c80 2026-01-15), node=v25.2.1, npm=11.6.2, flutter=Flutter 3.47.1 • channel stable • https://github.com/flutter/flutter.git`
- Viewport: `1280x800 @ 60 Hz`

| Adapter | Fixture | Scenario | Scope | Mean ms | P95 ms | P99 ms | Input ms | Document load ms | Interactive ms | Startup ms | Actions | Frames | Dropped | Drop rate | Status |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| electron | large | input | ui-frame | 10.353 | 11.000 | 20.000 | 9.870 | 2.684 | 87.100 | - | 30 | 30 | 1 | 3.333% | measured |
| electron | large | open | ui-frame | 86.467 | 89.900 | 89.900 | - | 2.848 | 86.467 | 322.600 | 3 | 3 | 3 | 100.000% | measured |
| electron | large | scroll | ui-frame | 10.024 | 10.900 | 11.000 | - | 2.834 | 85.400 | - | 360 | 360 | 1 | 0.278% | measured |
| electron | medium | input | ui-frame | 10.003 | 11.000 | 11.000 | 9.590 | 2.357 | 85.867 | - | 30 | 30 | 0 | 0.000% | measured |
| electron | medium | open | ui-frame | 85.533 | 87.300 | 87.300 | - | 2.570 | 85.533 | 321.645 | 3 | 3 | 3 | 100.000% | measured |
| electron | medium | scroll | ui-frame | 10.000 | 10.900 | 11.000 | - | 2.305 | 86.700 | - | 360 | 360 | 0 | 0.000% | measured |
| electron | small | input | ui-frame | 9.947 | 11.000 | 11.000 | 9.493 | 2.349 | 86.933 | - | 30 | 30 | 0 | 0.000% | measured |
| electron | small | open | ui-frame | 86.633 | 89.000 | 89.000 | - | 2.285 | 86.633 | 323.152 | 3 | 3 | 3 | 100.000% | measured |
| electron | small | scroll | ui-frame | 9.996 | 10.900 | 11.000 | - | 2.687 | 89.967 | - | 360 | 360 | 0 | 0.000% | measured |
| electron | stress | input | ui-frame | 10.067 | 11.000 | 11.000 | 9.340 | 4.923 | 98.633 | - | 30 | 30 | 0 | 0.000% | measured |
| electron | stress | open | ui-frame | 96.567 | 96.800 | 96.800 | - | 4.738 | 96.567 | 342.362 | 3 | 3 | 3 | 100.000% | measured |
| electron | stress | scroll | ui-frame | 10.001 | 10.900 | 11.000 | - | 4.329 | 97.233 | - | 360 | 360 | 0 | 0.000% | measured |
| flutter-impeller | large | input | ui-frame | 2.610 | 7.735 | 9.280 | 9.571 | 0.373 | 83.744 | - | 30 | 30 | 0 | 0.000% | measured |
| flutter-impeller | large | open | ui-frame | 84.670 | 95.990 | 95.990 | - | 0.396 | 84.670 | 306.755 | 3 | 3 | 3 | 100.000% | measured |
| flutter-impeller | large | scroll | ui-frame | 1.976 | 3.417 | 4.452 | - | 0.477 | 82.564 | - | 360 | 360 | 0 | 0.000% | measured |
| flutter-impeller | medium | input | ui-frame | 2.668 | 6.591 | 11.542 | 9.938 | 0.155 | 77.404 | - | 30 | 30 | 0 | 0.000% | measured |
| flutter-impeller | medium | open | ui-frame | 76.296 | 83.034 | 83.034 | - | 0.113 | 76.296 | 290.602 | 3 | 3 | 3 | 100.000% | measured |
| flutter-impeller | medium | scroll | ui-frame | 2.390 | 4.199 | 4.605 | - | 0.120 | 80.203 | - | 360 | 360 | 0 | 0.000% | measured |
| flutter-impeller | small | input | ui-frame | 2.628 | 5.246 | 13.039 | 10.142 | 0.110 | 83.836 | - | 30 | 30 | 0 | 0.000% | measured |
| flutter-impeller | small | open | ui-frame | 79.956 | 81.641 | 81.641 | - | 0.100 | 79.956 | 290.626 | 3 | 3 | 3 | 100.000% | measured |
| flutter-impeller | small | scroll | ui-frame | 2.077 | 3.255 | 3.684 | - | 0.102 | 85.317 | - | 360 | 360 | 0 | 0.000% | measured |
| flutter-impeller | stress | input | ui-frame | 2.468 | 4.545 | 11.463 | 9.949 | 3.239 | 110.420 | - | 30 | 30 | 0 | 0.000% | measured |
| flutter-impeller | stress | open | ui-frame | 110.202 | 112.734 | 112.734 | - | 3.505 | 110.202 | 320.574 | 3 | 3 | 3 | 100.000% | measured |
| flutter-impeller | stress | scroll | ui-frame | 2.445 | 4.253 | 5.049 | - | 4.239 | 120.264 | - | 360 | 360 | 0 | 0.000% | measured |
| flutter-skia | large | input | ui-frame | 2.672 | 6.126 | 9.046 | 9.742 | 0.399 | 82.161 | - | 30 | 30 | 0 | 0.000% | measured |
| flutter-skia | large | open | ui-frame | 85.110 | 88.091 | 88.091 | - | 0.490 | 85.110 | 293.987 | 3 | 3 | 3 | 100.000% | measured |
| flutter-skia | large | scroll | ui-frame | 2.356 | 4.224 | 4.537 | - | 0.365 | 87.364 | - | 360 | 360 | 0 | 0.000% | measured |
| flutter-skia | medium | input | ui-frame | 2.292 | 5.545 | 5.906 | 9.489 | 0.116 | 74.865 | - | 30 | 30 | 0 | 0.000% | measured |
| flutter-skia | medium | open | ui-frame | 82.285 | 90.019 | 90.019 | - | 0.117 | 82.285 | 284.938 | 3 | 3 | 3 | 100.000% | measured |
| flutter-skia | medium | scroll | ui-frame | 2.246 | 3.790 | 4.320 | - | 0.116 | 84.925 | - | 360 | 360 | 0 | 0.000% | measured |
| flutter-skia | small | input | ui-frame | 1.826 | 2.462 | 2.489 | 9.941 | 0.082 | 31.991 | - | 30 | 30 | 0 | 0.000% | measured |
| flutter-skia | small | open | ui-frame | 31.338 | 32.596 | 32.596 | - | 0.074 | 31.338 | 204.957 | 3 | 3 | 3 | 100.000% | measured |
| flutter-skia | small | scroll | ui-frame | 1.936 | 2.980 | 6.558 | - | 0.076 | 49.677 | - | 360 | 360 | 0 | 0.000% | measured |
| flutter-skia | stress | input | ui-frame | 2.235 | 4.613 | 5.296 | 10.023 | 3.729 | 124.771 | - | 30 | 30 | 0 | 0.000% | measured |
| flutter-skia | stress | open | ui-frame | 117.918 | 119.279 | 119.279 | - | 3.928 | 117.918 | 319.011 | 3 | 3 | 3 | 100.000% | measured |
| flutter-skia | stress | scroll | ui-frame | 2.342 | 4.116 | 4.492 | - | 3.577 | 114.370 | - | 360 | 360 | 0 | 0.000% | measured |
| gpui | large | input | skipped | - | - | - | - | - | - | - | - | - | - | - | skipped (no command supplied) |
| gpui | large | open | skipped | - | - | - | - | - | - | - | - | - | - | - | skipped (no command supplied) |
| gpui | large | scroll | skipped | - | - | - | - | - | - | - | - | - | - | - | skipped (no command supplied) |
| gpui | medium | input | skipped | - | - | - | - | - | - | - | - | - | - | - | skipped (no command supplied) |
| gpui | medium | open | skipped | - | - | - | - | - | - | - | - | - | - | - | skipped (no command supplied) |
| gpui | medium | scroll | skipped | - | - | - | - | - | - | - | - | - | - | - | skipped (no command supplied) |
| gpui | small | input | skipped | - | - | - | - | - | - | - | - | - | - | - | skipped (no command supplied) |
| gpui | small | open | skipped | - | - | - | - | - | - | - | - | - | - | - | skipped (no command supplied) |
| gpui | small | scroll | skipped | - | - | - | - | - | - | - | - | - | - | - | skipped (no command supplied) |
| gpui | stress | input | skipped | - | - | - | - | - | - | - | - | - | - | - | skipped (no command supplied) |
| gpui | stress | open | skipped | - | - | - | - | - | - | - | - | - | - | - | skipped (no command supplied) |
| gpui | stress | scroll | skipped | - | - | - | - | - | - | - | - | - | - | - | skipped (no command supplied) |
| moui-skia-gpu | large | input | ui-frame | 6.586 | 10.074 | 10.492 | 7.060 | 2.215 | 37.666 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-skia-gpu | large | open | ui-frame | 28.018 | 30.067 | 30.067 | - | 2.081 | 36.483 | 91.692 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-gpu | large | scroll | ui-frame | 11.788 | 15.435 | 16.159 | - | 1.900 | 36.789 | - | 360 | 360 | 2 | 0.556% | measured |
| moui-skia-gpu | medium | input | ui-frame | 4.723 | 5.341 | 7.477 | 5.039 | 0.278 | 36.110 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-skia-gpu | medium | open | ui-frame | 29.452 | 30.668 | 30.668 | - | 0.303 | 35.896 | 89.484 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 11.770 | 15.665 | 16.463 | - | 0.258 | 33.015 | - | 360 | 360 | 1 | 0.278% | measured |
| moui-skia-gpu | small | input | ui-frame | 5.041 | 5.958 | 6.609 | 5.397 | 0.064 | 39.384 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-skia-gpu | small | open | ui-frame | 28.964 | 31.045 | 31.045 | - | 0.053 | 35.054 | 88.435 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-gpu | small | scroll | ui-frame | 12.262 | 15.830 | 17.567 | - | 0.062 | 37.026 | - | 360 | 360 | 6 | 1.667% | measured |
| moui-skia-gpu | stress | input | ui-frame | 7.476 | 9.587 | 11.975 | 9.885 | 24.609 | 59.450 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-skia-gpu | stress | open | ui-frame | 30.339 | 35.985 | 35.985 | - | 20.686 | 61.386 | 135.940 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 11.753 | 15.507 | 16.161 | - | 21.781 | 57.558 | - | 360 | 360 | 2 | 0.556% | measured |
| moui-skia-raster | large | input | ui-frame | 4.581 | 5.699 | 6.222 | 5.068 | 2.023 | 34.279 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-skia-raster | large | open | ui-frame | 23.400 | 23.871 | 23.871 | - | 2.394 | 32.097 | 60.566 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-raster | large | scroll | ui-frame | 11.821 | 16.060 | 17.123 | - | 2.096 | 32.666 | - | 360 | 360 | 10 | 2.778% | measured |
| moui-skia-raster | medium | input | ui-frame | 4.251 | 4.962 | 5.088 | 4.586 | 0.285 | 31.702 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-skia-raster | medium | open | ui-frame | 24.209 | 25.485 | 25.485 | - | 0.262 | 30.568 | 58.018 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-raster | medium | scroll | ui-frame | 12.146 | 16.541 | 17.482 | - | 0.283 | 30.988 | - | 360 | 360 | 16 | 4.444% | measured |
| moui-skia-raster | small | input | ui-frame | 4.202 | 4.675 | 4.747 | 4.523 | 0.054 | 31.732 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-skia-raster | small | open | ui-frame | 23.302 | 23.392 | 23.392 | - | 0.051 | 29.503 | 55.051 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-raster | small | scroll | ui-frame | 11.755 | 15.538 | 16.449 | - | 0.093 | 30.664 | - | 360 | 360 | 4 | 1.111% | measured |
| moui-skia-raster | stress | input | ui-frame | 4.249 | 4.593 | 4.610 | 6.713 | 22.737 | 55.897 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-skia-raster | stress | open | ui-frame | 26.585 | 27.462 | 27.462 | - | 25.041 | 59.448 | 115.142 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-raster | stress | scroll | ui-frame | 11.439 | 15.319 | 15.647 | - | 24.489 | 54.142 | - | 360 | 360 | 0 | 0.000% | measured |
| moui-wgpu | large | input | ui-frame | 13.375 | 14.770 | 15.438 | 14.000 | 2.498 | 97.226 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-wgpu | large | open | ui-frame | 80.154 | 82.877 | 82.877 | - | 2.393 | 89.350 | 144.141 | 3 | 3 | 3 | 100.000% | measured |
| moui-wgpu | large | scroll | ui-frame | 41.836 | 52.503 | 76.890 | - | 2.513 | 87.072 | - | 360 | 360 | 360 | 100.000% | measured |
| moui-wgpu | medium | input | ui-frame | 13.461 | 14.526 | 14.978 | 13.887 | 0.308 | 93.801 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-wgpu | medium | open | ui-frame | 76.908 | 77.416 | 77.416 | - | 0.309 | 83.469 | 134.028 | 3 | 3 | 3 | 100.000% | measured |
| moui-wgpu | medium | scroll | ui-frame | 40.641 | 51.202 | 56.745 | - | 0.274 | 84.445 | - | 360 | 360 | 360 | 100.000% | measured |
| moui-wgpu | small | input | ui-frame | 12.742 | 13.406 | 13.465 | 13.106 | 0.056 | 84.349 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-wgpu | small | open | ui-frame | 71.142 | 75.551 | 75.551 | - | 0.061 | 77.498 | 124.694 | 3 | 3 | 3 | 100.000% | measured |
| moui-wgpu | small | scroll | ui-frame | 40.196 | 52.556 | 66.498 | - | 0.093 | 75.706 | - | 360 | 360 | 360 | 100.000% | measured |
| moui-wgpu | stress | input | ui-frame | 14.894 | 16.694 | 17.188 | 18.287 | 21.926 | 127.611 | - | 30 | 30 | 2 | 6.667% | measured |
| moui-wgpu | stress | open | ui-frame | 80.025 | 87.480 | 87.480 | - | 24.913 | 113.147 | 187.953 | 3 | 3 | 3 | 100.000% | measured |
| moui-wgpu | stress | scroll | ui-frame | 40.608 | 50.221 | 59.847 | - | 26.300 | 107.668 | - | 360 | 360 | 360 | 100.000% | measured |

## Matching UI 2x screen

| Target | Baseline | Metric | Worst ratio | Fixture / scenario | Screen |
| --- | --- | --- | ---: | --- | --- |
| moui-skia-raster | flutter-skia | Frame mean | 6.073x | small / scroll | over 2x |
| moui-skia-raster | flutter-skia | Frame P95 | 5.214x | small / scroll | over 2x |
| moui-skia-raster | flutter-skia | Frame P99 | 4.047x | medium / scroll | over 2x |
| moui-skia-raster | flutter-skia | Input latency | 0.670x | stress / input | within 2x |
| moui-skia-raster | flutter-skia | Document load | 6.847x | stress / scroll | over 2x |
| moui-skia-raster | flutter-skia | First interactive | 0.992x | small / input | within 2x |
| moui-skia-raster | flutter-skia | Startup | 0.361x | stress / open | within 2x |
| moui-skia-raster | flutter-impeller | Frame mean | 5.982x | large / scroll | over 2x |
| moui-skia-raster | flutter-impeller | Frame P95 | 4.774x | small / scroll | over 2x |
| moui-skia-raster | flutter-impeller | Frame P99 | 4.465x | small / scroll | over 2x |
| moui-skia-raster | flutter-impeller | Input latency | 0.675x | stress / input | within 2x |
| moui-skia-raster | flutter-impeller | Document load | 7.145x | stress / open | over 2x |
| moui-skia-raster | flutter-impeller | First interactive | 0.539x | stress / open | within 2x |
| moui-skia-raster | flutter-impeller | Startup | 0.359x | stress / open | within 2x |
| moui-skia-raster | electron | Frame mean | 1.215x | medium / scroll | within 2x |
| moui-skia-raster | electron | Frame P95 | 1.517x | medium / scroll | within 2x |
| moui-skia-raster | electron | Frame P99 | 1.589x | medium / scroll | within 2x |
| moui-skia-raster | electron | Input latency | 0.719x | stress / input | within 2x |
| moui-skia-raster | electron | Document load | 5.658x | stress / scroll | over 2x |
| moui-skia-raster | electron | First interactive | 0.616x | stress / open | within 2x |
| moui-skia-raster | electron | Startup | 0.336x | stress / open | within 2x |
| moui-skia-gpu | flutter-skia | Frame mean | 6.335x | small / scroll | over 2x |
| moui-skia-gpu | flutter-skia | Frame P95 | 5.312x | small / scroll | over 2x |
| moui-skia-gpu | flutter-skia | Frame P99 | 3.811x | medium / scroll | over 2x |
| moui-skia-gpu | flutter-skia | Input latency | 0.986x | stress / input | within 2x |
| moui-skia-gpu | flutter-skia | Document load | 6.599x | stress / input | over 2x |
| moui-skia-gpu | flutter-skia | First interactive | 1.231x | small / input | within 2x |
| moui-skia-gpu | flutter-skia | Startup | 0.431x | small / open | within 2x |
| moui-skia-gpu | flutter-impeller | Frame mean | 5.966x | large / scroll | over 2x |
| moui-skia-gpu | flutter-impeller | Frame P95 | 4.863x | small / scroll | over 2x |
| moui-skia-gpu | flutter-impeller | Frame P99 | 4.768x | small / scroll | over 2x |
| moui-skia-gpu | flutter-impeller | Input latency | 0.994x | stress / input | within 2x |
| moui-skia-gpu | flutter-impeller | Document load | 7.598x | stress / input | over 2x |
| moui-skia-gpu | flutter-impeller | First interactive | 0.557x | stress / open | within 2x |
| moui-skia-gpu | flutter-impeller | Startup | 0.424x | stress / open | within 2x |
| moui-skia-gpu | electron | Frame mean | 1.227x | small / scroll | within 2x |
| moui-skia-gpu | electron | Frame P95 | 1.452x | small / scroll | within 2x |
| moui-skia-gpu | electron | Frame P99 | 1.597x | small / scroll | within 2x |
| moui-skia-gpu | electron | Input latency | 1.058x | stress / input | within 2x |
| moui-skia-gpu | electron | Document load | 5.032x | stress / scroll | over 2x |
| moui-skia-gpu | electron | First interactive | 0.636x | stress / open | within 2x |
| moui-skia-gpu | electron | Startup | 0.397x | stress / open | within 2x |
| moui-wgpu | flutter-skia | Frame mean | 20.765x | small / scroll | over 2x |
| moui-wgpu | flutter-skia | Frame P95 | 17.636x | small / scroll | over 2x |
| moui-wgpu | flutter-skia | Frame P99 | 16.947x | large / scroll | over 2x |
| moui-wgpu | flutter-skia | Input latency | 1.825x | stress / input | within 2x |
| moui-wgpu | flutter-skia | Document load | 7.353x | stress / scroll | over 2x |
| moui-wgpu | flutter-skia | First interactive | 2.637x | small / input | over 2x |
| moui-wgpu | flutter-skia | Startup | 0.608x | small / open | within 2x |
| moui-wgpu | flutter-impeller | Frame mean | 21.172x | large / scroll | over 2x |
| moui-wgpu | flutter-impeller | Frame P95 | 16.146x | small / scroll | over 2x |
| moui-wgpu | flutter-impeller | Frame P99 | 18.051x | small / scroll | over 2x |
| moui-wgpu | flutter-impeller | Input latency | 1.838x | stress / input | within 2x |
| moui-wgpu | flutter-impeller | Document load | 7.108x | stress / open | over 2x |
| moui-wgpu | flutter-impeller | First interactive | 1.212x | medium / input | within 2x |
| moui-wgpu | flutter-impeller | Startup | 0.586x | stress / open | within 2x |
| moui-wgpu | electron | Frame mean | 4.173x | large / scroll | over 2x |
| moui-wgpu | electron | Frame P95 | 4.822x | small / scroll | over 2x |
| moui-wgpu | electron | Frame P99 | 6.990x | large / scroll | over 2x |
| moui-wgpu | electron | Input latency | 1.958x | stress / input | within 2x |
| moui-wgpu | electron | Document load | 6.076x | stress / scroll | over 2x |
| moui-wgpu | electron | First interactive | 1.294x | stress / input | within 2x |
| moui-wgpu | electron | Startup | 0.549x | stress / open | within 2x |

Raw samples are retained in the input JSON. The screen above uses only matching `ui-frame` rows with the same fixture and scenario. Verify viewport, repetitions and warm-ups in the raw records before treating a ratio as comparable. Timing sources remain framework-specific and are not compositor-equivalent.
