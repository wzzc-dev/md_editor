# Markdown editor benchmark report

- Schema: `md-editor-benchmark/v1`
- Host: `macOS-26.3-arm64-arm-64bit` / `arm64` / `16.0 GiB`
- OS release: `25.3.0`; GPU: `Apple M4`
- Toolchains: `python=3.12.11, moon=moon 0.1.20260824 (dae026a 2026-08-24), rustc=rustc 1.94.0 (4a4ef493e 2026-03-02), cargo=cargo 1.94.0 (85eff7c80 2026-01-15), node=v25.2.1, npm=11.6.2, flutter=Flutter 3.47.1 • channel stable • https://github.com/flutter/flutter.git`
- Viewport: `1280x800 @ 60 Hz`

| Adapter | Fixture | Scenario | Scope | Mean ms | P95 ms | P99 ms | Input ms | Document load ms | Interactive ms | Startup ms | Actions | Frames | Dropped | Drop rate | Status |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| electron | large | input | ui-frame | 9.997 | 10.500 | 10.500 | 9.667 | 100.602 | 175.033 | - | 30 | 30 | 0 | 0.000% | measured |
| electron | large | open | ui-frame | 160.933 | 183.100 | 183.100 | - | 66.802 | 160.933 | 941.693 | 3 | 3 | 3 | 100.000% | measured |
| electron | large | scroll | ui-frame | 10.028 | 10.700 | 10.900 | - | 82.218 | 144.433 | - | 360 | 360 | 1 | 0.278% | measured |
| electron | medium | input | ui-frame | 10.017 | 10.800 | 11.100 | 9.723 | 66.831 | 178.233 | - | 30 | 30 | 0 | 0.000% | measured |
| electron | medium | open | ui-frame | 142.867 | 181.200 | 181.200 | - | 66.425 | 142.867 | 947.075 | 3 | 3 | 3 | 100.000% | measured |
| electron | medium | scroll | ui-frame | 10.055 | 10.500 | 10.900 | - | 63.618 | 142.700 | - | 360 | 360 | 2 | 0.556% | measured |
| electron | small | input | ui-frame | 10.007 | 11.600 | 12.000 | 9.943 | 97.317 | 144.267 | - | 30 | 30 | 0 | 0.000% | measured |
| electron | small | open | ui-frame | 143.700 | 183.300 | 183.300 | - | 45.811 | 143.700 | 994.663 | 3 | 3 | 3 | 100.000% | measured |
| electron | small | scroll | ui-frame | 9.993 | 11.500 | 11.900 | - | 64.697 | 142.100 | - | 360 | 360 | 0 | 0.000% | measured |
| electron | stress | input | ui-frame | 9.983 | 10.500 | 10.600 | 9.537 | 69.362 | 152.233 | - | 30 | 30 | 0 | 0.000% | measured |
| electron | stress | open | ui-frame | 124.467 | 170.200 | 170.200 | - | 48.190 | 124.467 | 931.881 | 3 | 3 | 3 | 100.000% | measured |
| electron | stress | scroll | ui-frame | 10.111 | 10.800 | 11.000 | - | 85.745 | 127.167 | - | 360 | 360 | 3 | 0.833% | measured |
| flutter-impeller | large | input | ui-frame | 11.430 | 51.444 | 56.669 | 17.921 | 0.392 | 225.937 | - | 30 | 30 | 8 | 26.667% | measured |
| flutter-impeller | large | open | ui-frame | 219.264 | 303.457 | 303.457 | - | 0.418 | 219.264 | 910.776 | 3 | 3 | 3 | 100.000% | measured |
| flutter-impeller | large | scroll | ui-frame | 2.310 | 4.535 | 5.195 | - | 0.412 | 222.251 | - | 360 | 360 | 0 | 0.000% | measured |
| flutter-impeller | medium | input | ui-frame | 17.818 | 112.936 | 113.993 | 26.637 | 0.146 | 76.117 | - | 30 | 30 | 8 | 26.667% | measured |
| flutter-impeller | medium | open | ui-frame | 101.512 | 187.148 | 187.148 | - | 0.152 | 101.512 | 815.859 | 3 | 3 | 3 | 100.000% | measured |
| flutter-impeller | medium | scroll | ui-frame | 2.446 | 4.089 | 5.244 | - | 0.148 | 200.262 | - | 360 | 360 | 1 | 0.278% | measured |
| flutter-impeller | small | input | ui-frame | 21.092 | 121.047 | 161.931 | 27.477 | 0.097 | 76.831 | - | 30 | 30 | 9 | 30.000% | measured |
| flutter-impeller | small | open | ui-frame | 139.325 | 301.671 | 301.671 | - | 0.103 | 139.325 | 839.714 | 3 | 3 | 3 | 100.000% | measured |
| flutter-impeller | small | scroll | ui-frame | 2.612 | 3.400 | 5.006 | - | 0.095 | 155.016 | - | 360 | 360 | 2 | 0.556% | measured |
| flutter-impeller | stress | input | ui-frame | 8.312 | 48.159 | 51.203 | 14.970 | 3.220 | 309.000 | - | 30 | 30 | 4 | 13.333% | measured |
| flutter-impeller | stress | open | ui-frame | 309.093 | 309.427 | 309.427 | - | 3.382 | 309.093 | 1023.329 | 3 | 3 | 3 | 100.000% | measured |
| flutter-impeller | stress | scroll | ui-frame | 2.245 | 4.153 | 5.151 | - | 3.284 | 307.704 | - | 360 | 360 | 0 | 0.000% | measured |
| flutter-skia | large | input | ui-frame | 17.443 | 112.363 | 112.389 | 26.132 | 0.421 | 140.768 | - | 30 | 30 | 8 | 26.667% | measured |
| flutter-skia | large | open | ui-frame | 159.345 | 261.184 | 261.184 | - | 0.400 | 159.345 | 867.506 | 3 | 3 | 3 | 100.000% | measured |
| flutter-skia | large | scroll | ui-frame | 2.226 | 4.204 | 5.127 | - | 0.418 | 175.275 | - | 360 | 360 | 0 | 0.000% | measured |
| flutter-skia | medium | input | ui-frame | 16.767 | 106.292 | 106.585 | 23.079 | 0.127 | 160.984 | - | 30 | 30 | 8 | 26.667% | measured |
| flutter-skia | medium | open | ui-frame | 164.549 | 246.709 | 246.709 | - | 0.158 | 164.549 | 858.078 | 3 | 3 | 3 | 100.000% | measured |
| flutter-skia | medium | scroll | ui-frame | 2.951 | 4.644 | 5.482 | - | 0.159 | 217.328 | - | 360 | 360 | 2 | 0.556% | measured |
| flutter-skia | small | input | ui-frame | 15.115 | 61.532 | 62.741 | 21.079 | 0.115 | 141.434 | - | 30 | 30 | 10 | 33.333% | measured |
| flutter-skia | small | open | ui-frame | 204.800 | 238.078 | 238.078 | - | 0.095 | 204.800 | 898.365 | 3 | 3 | 3 | 100.000% | measured |
| flutter-skia | small | scroll | ui-frame | 2.573 | 3.290 | 3.662 | - | 0.123 | 80.192 | - | 360 | 360 | 2 | 0.556% | measured |
| flutter-skia | stress | input | ui-frame | 9.022 | 50.104 | 56.985 | 15.503 | 3.368 | 311.270 | - | 30 | 30 | 5 | 16.667% | measured |
| flutter-skia | stress | open | ui-frame | 311.573 | 315.672 | 315.672 | - | 3.303 | 311.573 | 1032.330 | 3 | 3 | 3 | 100.000% | measured |
| flutter-skia | stress | scroll | ui-frame | 2.091 | 3.455 | 4.886 | - | 3.733 | 310.345 | - | 360 | 360 | 0 | 0.000% | measured |
| gpui | large | input | ui-frame | 45.314 | 70.657 | 119.141 | 45.314 | 2.333 | 568.194 | - | 30 | 30 | 21 | 70.000% | measured |
| gpui | large | open | ui-frame | 565.136 | 626.815 | 626.815 | - | 2.333 | 565.136 | 867.469 | 3 | 3 | 3 | 100.000% | measured |
| gpui | large | scroll | ui-frame | 57.192 | 60.209 | 60.416 | - | 2.333 | 551.489 | - | 360 | 360 | 351 | 97.500% | measured |
| gpui | medium | input | ui-frame | 44.589 | 60.288 | 66.221 | 44.589 | 0.333 | 554.761 | - | 30 | 30 | 22 | 73.333% | measured |
| gpui | medium | open | ui-frame | 600.408 | 672.387 | 672.387 | - | 0.667 | 600.408 | 845.430 | 3 | 3 | 3 | 100.000% | measured |
| gpui | medium | scroll | ui-frame | 57.538 | 60.191 | 60.305 | - | 0.000 | 533.463 | - | 360 | 360 | 351 | 97.500% | measured |
| gpui | small | input | ui-frame | 48.628 | 120.649 | 121.430 | 48.627 | 0.000 | 568.883 | - | 30 | 30 | 21 | 70.000% | measured |
| gpui | small | open | ui-frame | 564.205 | 568.801 | 568.801 | - | 0.000 | 564.205 | 865.614 | 3 | 3 | 3 | 100.000% | measured |
| gpui | small | scroll | ui-frame | 57.728 | 60.235 | 60.446 | - | 0.000 | 533.421 | - | 360 | 360 | 352 | 97.778% | measured |
| gpui | stress | input | ui-frame | 40.623 | 118.649 | 171.859 | 40.623 | 22.333 | 677.236 | - | 30 | 30 | 17 | 56.667% | measured |
| gpui | stress | open | ui-frame | 593.786 | 638.002 | 638.002 | - | 28.000 | 593.786 | 953.112 | 3 | 3 | 3 | 100.000% | measured |
| gpui | stress | scroll | ui-frame | 57.144 | 60.221 | 60.342 | - | 24.667 | 676.208 | - | 360 | 360 | 350 | 97.222% | measured |
| moui-skia-gpu | large | input | ui-frame | 61.483 | 82.757 | 85.768 | 62.650 | 2.584 | 232.110 | - | 30 | 30 | 30 | 100.000% | measured |
| moui-skia-gpu | large | open | ui-frame | 95.001 | 97.253 | 97.253 | - | 2.581 | 203.481 | 235.513 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-gpu | large | scroll | ui-frame | 32.051 | 54.632 | 59.676 | - | 2.263 | 196.458 | - | 360 | 360 | 298 | 82.778% | measured |
| moui-skia-gpu | medium | input | ui-frame | 48.221 | 86.225 | 87.650 | 48.876 | 0.283 | 204.538 | - | 30 | 30 | 24 | 80.000% | measured |
| moui-skia-gpu | medium | open | ui-frame | 105.589 | 115.235 | 115.235 | - | 0.312 | 213.360 | 243.486 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 31.269 | 54.860 | 59.141 | - | 0.382 | 197.913 | - | 360 | 360 | 302 | 83.889% | measured |
| moui-skia-gpu | small | input | ui-frame | 60.141 | 86.065 | 87.286 | 60.823 | 0.081 | 238.642 | - | 30 | 30 | 29 | 96.667% | measured |
| moui-skia-gpu | small | open | ui-frame | 102.527 | 118.668 | 118.668 | - | 0.089 | 201.191 | 231.115 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-gpu | small | scroll | ui-frame | 32.477 | 55.539 | 59.504 | - | 0.106 | 215.289 | - | 360 | 360 | 317 | 88.056% | measured |
| moui-skia-gpu | stress | input | ui-frame | 56.322 | 81.133 | 82.032 | 60.019 | 23.453 | 218.834 | - | 30 | 30 | 30 | 100.000% | measured |
| moui-skia-gpu | stress | open | ui-frame | 97.264 | 119.529 | 119.529 | - | 25.997 | 253.002 | 309.267 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 32.080 | 55.368 | 61.513 | - | 25.424 | 230.790 | - | 360 | 360 | 315 | 87.500% | measured |
| moui-skia-raster | large | input | ui-frame | 4.345 | 4.652 | 4.733 | 4.857 | 2.183 | 36.286 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-skia-raster | large | open | ui-frame | 25.583 | 26.542 | 26.542 | - | 2.318 | 34.536 | 64.754 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-raster | large | scroll | ui-frame | 11.945 | 15.752 | 16.369 | - | 2.560 | 34.763 | - | 360 | 360 | 1 | 0.278% | measured |
| moui-skia-raster | medium | input | ui-frame | 4.315 | 4.642 | 5.028 | 4.672 | 0.301 | 34.017 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-skia-raster | medium | open | ui-frame | 25.625 | 26.044 | 26.044 | - | 0.356 | 32.544 | 59.844 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-raster | medium | scroll | ui-frame | 11.951 | 15.829 | 16.521 | - | 0.316 | 32.717 | - | 360 | 360 | 2 | 0.556% | measured |
| moui-skia-raster | small | input | ui-frame | 4.512 | 5.142 | 5.794 | 4.877 | 0.106 | 34.708 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-skia-raster | small | open | ui-frame | 27.282 | 27.667 | 27.667 | - | 0.096 | 33.936 | 62.921 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-raster | small | scroll | ui-frame | 12.088 | 15.955 | 16.780 | - | 0.082 | 32.176 | - | 360 | 360 | 5 | 1.389% | measured |
| moui-skia-raster | stress | input | ui-frame | 4.524 | 5.060 | 5.116 | 7.212 | 26.362 | 59.090 | - | 30 | 30 | 0 | 0.000% | measured |
| moui-skia-raster | stress | open | ui-frame | 25.387 | 25.726 | 25.726 | - | 24.701 | 57.251 | 110.532 | 3 | 3 | 3 | 100.000% | measured |
| moui-skia-raster | stress | scroll | ui-frame | 11.998 | 16.004 | 16.869 | - | 26.062 | 57.039 | - | 360 | 360 | 6 | 1.667% | measured |

## Matching UI 2x screen

| Target | Baseline | Metric | Worst ratio | Fixture / scenario | Screen |
| --- | --- | --- | ---: | --- | --- |
| moui-skia-raster | flutter-skia | Frame mean | 5.738x | stress / scroll | over 2x |
| moui-skia-raster | flutter-skia | Frame P95 | 4.850x | small / scroll | over 2x |
| moui-skia-raster | flutter-skia | Frame P99 | 4.582x | small / scroll | over 2x |
| moui-skia-raster | flutter-skia | Input latency | 0.465x | stress / input | within 2x |
| moui-skia-raster | flutter-skia | Document load | 7.826x | stress / input | over 2x |
| moui-skia-raster | flutter-skia | First interactive | 0.401x | small / scroll | within 2x |
| moui-skia-raster | flutter-skia | Startup | 0.107x | stress / open | within 2x |
| moui-skia-raster | flutter-impeller | Frame mean | 5.344x | stress / scroll | over 2x |
| moui-skia-raster | flutter-impeller | Frame P95 | 4.693x | small / scroll | over 2x |
| moui-skia-raster | flutter-impeller | Frame P99 | 3.352x | small / scroll | over 2x |
| moui-skia-raster | flutter-impeller | Input latency | 0.482x | stress / input | within 2x |
| moui-skia-raster | flutter-impeller | Document load | 8.188x | stress / input | over 2x |
| moui-skia-raster | flutter-impeller | First interactive | 0.452x | small / input | within 2x |
| moui-skia-raster | flutter-impeller | Startup | 0.108x | stress / open | within 2x |
| moui-skia-raster | electron | Frame mean | 1.210x | small / scroll | within 2x |
| moui-skia-raster | electron | Frame P95 | 1.508x | medium / scroll | within 2x |
| moui-skia-raster | electron | Frame P99 | 1.534x | stress / scroll | within 2x |
| moui-skia-raster | electron | Input latency | 0.756x | stress / input | within 2x |
| moui-skia-raster | electron | Document load | 0.513x | stress / open | within 2x |
| moui-skia-raster | electron | First interactive | 0.460x | stress / open | within 2x |
| moui-skia-raster | electron | Startup | 0.119x | stress / open | within 2x |
| moui-skia-gpu | flutter-skia | Frame mean | 15.343x | stress / scroll | over 2x |
| moui-skia-gpu | flutter-skia | Frame P95 | 16.881x | small / scroll | over 2x |
| moui-skia-gpu | flutter-skia | Frame P99 | 16.249x | small / scroll | over 2x |
| moui-skia-gpu | flutter-skia | Input latency | 3.871x | stress / input | over 2x |
| moui-skia-gpu | flutter-skia | Document load | 7.870x | stress / open | over 2x |
| moui-skia-gpu | flutter-skia | First interactive | 2.685x | small / scroll | over 2x |
| moui-skia-gpu | flutter-skia | Startup | 0.300x | stress / open | within 2x |
| moui-skia-gpu | flutter-impeller | Frame mean | 14.289x | stress / scroll | over 2x |
| moui-skia-gpu | flutter-impeller | Frame P95 | 16.335x | small / scroll | over 2x |
| moui-skia-gpu | flutter-impeller | Frame P99 | 11.942x | stress / scroll | over 2x |
| moui-skia-gpu | flutter-impeller | Input latency | 4.009x | stress / input | over 2x |
| moui-skia-gpu | flutter-impeller | Document load | 7.743x | stress / scroll | over 2x |
| moui-skia-gpu | flutter-impeller | First interactive | 3.106x | small / input | over 2x |
| moui-skia-gpu | flutter-impeller | Startup | 0.302x | stress / open | within 2x |
| moui-skia-gpu | electron | Frame mean | 6.150x | large / input | over 2x |
| moui-skia-gpu | electron | Frame P95 | 7.984x | medium / input | over 2x |
| moui-skia-gpu | electron | Frame P99 | 8.168x | large / input | over 2x |
| moui-skia-gpu | electron | Input latency | 6.481x | large / input | over 2x |
| moui-skia-gpu | electron | Document load | 0.539x | stress / open | within 2x |
| moui-skia-gpu | electron | First interactive | 2.033x | stress / open | over 2x |
| moui-skia-gpu | electron | Startup | 0.332x | stress / open | within 2x |
| gpui | flutter-skia | Frame mean | 27.331x | stress / scroll | over 2x |
| gpui | flutter-skia | Frame P95 | 18.309x | small / scroll | over 2x |
| gpui | flutter-skia | Frame P99 | 16.506x | small / scroll | over 2x |
| gpui | flutter-skia | Input latency | 2.620x | stress / input | over 2x |
| gpui | flutter-skia | Document load | 8.476x | stress / open | over 2x |
| gpui | flutter-skia | First interactive | 6.652x | small / scroll | over 2x |
| gpui | flutter-skia | Startup | 1.000x | large / open | within 2x |
| gpui | flutter-impeller | Frame mean | 25.454x | stress / scroll | over 2x |
| gpui | flutter-impeller | Frame P95 | 17.716x | small / scroll | over 2x |
| gpui | flutter-impeller | Frame P99 | 12.075x | small / scroll | over 2x |
| gpui | flutter-impeller | Input latency | 2.714x | stress / input | over 2x |
| gpui | flutter-impeller | Document load | 8.278x | stress / open | over 2x |
| gpui | flutter-impeller | First interactive | 7.404x | small / input | over 2x |
| gpui | flutter-impeller | Startup | 1.036x | medium / open | within 2x |
| gpui | electron | Frame mean | 5.777x | small / scroll | over 2x |
| gpui | electron | Frame P95 | 11.300x | stress / input | over 2x |
| gpui | electron | Frame P99 | 16.213x | stress / input | over 2x |
| gpui | electron | Input latency | 4.890x | small / input | over 2x |
| gpui | electron | Document load | 0.581x | stress / open | within 2x |
| gpui | electron | First interactive | 5.317x | stress / scroll | over 2x |
| gpui | electron | Startup | 1.023x | stress / open | within 2x |

Raw samples are retained in the input JSON. The screen above uses only matching `ui-frame` rows with the same fixture and scenario. Verify viewport, repetitions and warm-ups in the raw records before treating a ratio as comparable. Timing sources remain framework-specific and are not compositor-equivalent.
