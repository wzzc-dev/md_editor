# Markdown editor benchmark report

- Schema: `md-editor-benchmark/v2`
- Host: `macOS-26.3-arm64-arm-64bit` / `arm64` / `16.0 GiB`
- OS release: `25.3.0`; GPU: `Apple M4`
- Toolchains: `python=3.12.11, moon=moon 0.1.20260824 (dae026a 2026-08-24), rustc=rustc 1.94.0 (4a4ef493e 2026-03-02), cargo=cargo 1.94.0 (85eff7c80 2026-01-15), node=v25.2.1, npm=11.6.2, flutter=Flutter 3.47.1 • channel stable • https://github.com/flutter/flutter.git`
- Viewport: `1280x800 @ 60 Hz`; font: `system-ui 16px`; line height: `1.55`; overscan: `3`; list: `fixed 66px`; GPU: `Metal`

| Adapter | Fixture | Scenario | Scope | Work mean/P95 | Interval mean/P95 | Input->visible mean/P95 | Offscreen mean | Readback mean | First interactive | Dropped display frames | Status |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| electron | large | input | ui-frame | 2.260/2.800 | 10.010/12.000 | 9.440/12.100 | 0.000 | 0.000 | 91.500 | 0 | measured |
| electron | large | open | ui-frame | 93.600/93.600 | -/- | -/- | 0.000 | 0.000 | 93.600 | 0 | measured |
| electron | large | scroll | ui-frame | 1.888/2.600 | 10.000/11.100 | -/- | 0.000 | 0.000 | 93.000 | 0 | measured |
| electron | medium | input | ui-frame | 2.170/2.400 | 10.000/11.000 | 9.750/11.100 | 0.000 | 0.000 | 90.600 | 0 | measured |
| electron | medium | open | ui-frame | 91.100/91.100 | -/- | -/- | 0.000 | 0.000 | 91.100 | 0 | measured |
| electron | medium | scroll | ui-frame | 1.908/2.800 | 10.000/10.900 | -/- | 0.000 | 0.000 | 87.100 | 0 | measured |
| electron | small | input | ui-frame | 2.250/2.900 | 9.990/10.000 | 9.960/10.100 | 0.000 | 0.000 | 90.900 | 0 | measured |
| electron | small | open | ui-frame | 121.500/121.500 | -/- | -/- | 0.000 | 0.000 | 121.500 | 0 | measured |
| electron | small | scroll | ui-frame | 1.828/2.600 | 10.000/10.600 | -/- | 0.000 | 0.000 | 92.600 | 0 | measured |
| electron | stress | input | ui-frame | 2.160/3.400 | 9.870/10.900 | 9.600/10.800 | 0.000 | 0.000 | 106.700 | 0 | measured |
| electron | stress | open | ui-frame | 114.200/114.200 | -/- | -/- | 0.000 | 0.000 | 114.200 | 0 | measured |
| electron | stress | scroll | ui-frame | 1.891/2.700 | 10.000/10.500 | -/- | 0.000 | 0.000 | 106.800 | 0 | measured |
| flutter-impeller | large | input | ui-frame | 1.922/2.678 | 11.000/20.001 | 10.857/19.995 | 0.000 | 0.000 | 41.889 | 1 | measured |
| flutter-impeller | large | open | ui-frame | 37.551/37.551 | -/- | -/- | 0.000 | 0.000 | 37.551 | 0 | measured |
| flutter-impeller | large | scroll | ui-frame | 2.030/4.218 | 10.167/10.002 | -/- | 0.000 | 0.000 | 45.488 | 1 | measured |
| flutter-impeller | medium | input | ui-frame | 1.818/2.348 | 10.000/10.003 | 10.538/15.560 | 0.000 | 0.000 | 35.311 | 0 | measured |
| flutter-impeller | medium | open | ui-frame | 36.617/36.617 | -/- | -/- | 0.000 | 0.000 | 36.617 | 0 | measured |
| flutter-impeller | medium | scroll | ui-frame | 2.170/4.164 | 10.000/10.003 | -/- | 0.000 | 0.000 | 35.480 | 0 | measured |
| flutter-impeller | small | input | ui-frame | 1.765/2.227 | 11.000/20.003 | 12.135/23.221 | 0.000 | 0.000 | 35.108 | 1 | measured |
| flutter-impeller | small | open | ui-frame | 33.841/33.841 | -/- | -/- | 0.000 | 0.000 | 33.841 | 0 | measured |
| flutter-impeller | small | scroll | ui-frame | 1.862/3.298 | 10.083/10.003 | -/- | 0.000 | 0.000 | 36.512 | 1 | measured |
| flutter-impeller | stress | input | ui-frame | 2.015/2.456 | 10.000/10.003 | 9.977/14.024 | 0.000 | 0.000 | 68.481 | 0 | measured |
| flutter-impeller | stress | open | ui-frame | 70.958/70.958 | -/- | -/- | 0.000 | 0.000 | 70.958 | 0 | measured |
| flutter-impeller | stress | scroll | ui-frame | 2.163/4.273 | 10.000/10.002 | -/- | 0.000 | 0.000 | 61.963 | 0 | measured |
| flutter-skia | large | input | ui-frame | 1.872/2.594 | 10.000/10.001 | 9.984/10.125 | 0.000 | 0.000 | 33.821 | 0 | measured |
| flutter-skia | large | open | ui-frame | 32.583/32.583 | -/- | -/- | 0.000 | 0.000 | 32.583 | 0 | measured |
| flutter-skia | large | scroll | ui-frame | 2.021/4.068 | 10.083/10.003 | -/- | 0.000 | 0.000 | 34.674 | 1 | measured |
| flutter-skia | medium | input | ui-frame | 1.826/2.274 | 10.000/10.001 | 10.466/15.061 | 0.000 | 0.000 | 35.838 | 0 | measured |
| flutter-skia | medium | open | ui-frame | 31.963/31.963 | -/- | -/- | 0.000 | 0.000 | 31.963 | 0 | measured |
| flutter-skia | medium | scroll | ui-frame | 1.989/3.758 | 10.000/10.003 | -/- | 0.000 | 0.000 | 35.039 | 0 | measured |
| flutter-skia | small | input | ui-frame | 2.505/7.822 | 11.000/20.003 | 11.869/18.782 | 0.000 | 0.000 | 36.578 | 1 | measured |
| flutter-skia | small | open | ui-frame | 64.372/64.372 | -/- | -/- | 0.000 | 0.000 | 64.372 | 0 | measured |
| flutter-skia | small | scroll | ui-frame | 1.766/3.158 | 10.250/10.003 | -/- | 0.000 | 0.000 | 34.379 | 3 | measured |
| flutter-skia | stress | input | ui-frame | 2.065/2.611 | 11.000/20.004 | 9.986/15.137 | 0.000 | 0.000 | 74.196 | 1 | measured |
| flutter-skia | stress | open | ui-frame | 72.307/72.307 | -/- | -/- | 0.000 | 0.000 | 72.307 | 0 | measured |
| flutter-skia | stress | scroll | ui-frame | 2.124/4.181 | 10.000/10.003 | -/- | 0.000 | 0.000 | 75.531 | 0 | measured |
| gpui | large | input | ui-frame | 0.204/0.310 | 10.695/25.628 | 10.692/25.620 | 0.000 | 0.000 | 167.517 | 1 | measured |
| gpui | large | open | ui-frame | 0.000/0.000 | -/- | -/- | 0.000 | 0.000 | 165.789 | 0 | measured |
| gpui | large | scroll | ui-frame | 0.004/0.008 | 10.040/10.053 | -/- | 0.000 | 0.000 | 170.290 | 1 | measured |
| gpui | medium | input | ui-frame | 0.198/0.265 | 10.756/27.390 | 10.752/27.381 | 0.000 | 0.000 | 160.641 | 1 | measured |
| gpui | medium | open | ui-frame | 0.000/0.000 | -/- | -/- | 0.000 | 0.000 | 161.866 | 0 | measured |
| gpui | medium | scroll | ui-frame | 0.003/0.006 | 10.100/10.298 | -/- | 0.000 | 0.000 | 166.427 | 1 | measured |
| gpui | small | input | ui-frame | 0.226/0.297 | 10.283/25.940 | 10.278/25.930 | 0.000 | 0.000 | 194.919 | 1 | measured |
| gpui | small | open | ui-frame | 0.000/0.000 | -/- | -/- | 0.000 | 0.000 | 252.830 | 0 | measured |
| gpui | small | scroll | ui-frame | 0.004/0.008 | 10.058/10.342 | -/- | 0.000 | 0.000 | 176.698 | 1 | measured |
| gpui | stress | input | ui-frame | 0.243/0.329 | 10.643/27.716 | 10.638/27.695 | 0.000 | 0.000 | 158.144 | 1 | measured |
| gpui | stress | open | ui-frame | 0.000/0.000 | -/- | -/- | 0.000 | 0.000 | 164.999 | 0 | measured |
| gpui | stress | scroll | ui-frame | 0.004/0.009 | 10.082/10.057 | -/- | 0.000 | 0.000 | 162.554 | 1 | measured |
| moui-skia-gpu | large | input | ui-frame | 24.372/26.469 | 24.944/26.996 | 24.944/26.996 | 0.000 | 0.000 | 118.310 | 10 | measured |
| moui-skia-gpu | large | open | ui-frame | 111.660/111.660 | -/- | -/- | 0.000 | 0.000 | 120.232 | 0 | measured |
| moui-skia-gpu | large | scroll | ui-frame | 68.104/80.244 | 68.775/81.147 | -/- | 0.000 | 0.000 | 105.859 | 420 | measured |
| moui-skia-gpu | medium | input | ui-frame | 24.735/27.827 | 25.126/28.292 | 25.125/28.290 | 0.000 | 0.000 | 117.864 | 10 | measured |
| moui-skia-gpu | medium | open | ui-frame | 93.809/93.809 | -/- | -/- | 0.000 | 0.000 | 100.158 | 0 | measured |
| moui-skia-gpu | medium | scroll | ui-frame | 68.840/81.266 | 69.522/82.068 | -/- | 0.000 | 0.000 | 100.309 | 428 | measured |
| moui-skia-gpu | small | input | ui-frame | 25.820/30.255 | 26.199/30.617 | 26.198/30.615 | 0.000 | 0.000 | 117.945 | 10 | measured |
| moui-skia-gpu | small | open | ui-frame | 101.611/101.611 | -/- | -/- | 0.000 | 0.000 | 107.690 | 0 | measured |
| moui-skia-gpu | small | scroll | ui-frame | 67.443/80.345 | 68.111/81.599 | -/- | 0.000 | 0.000 | 106.827 | 421 | measured |
| moui-skia-gpu | stress | input | ui-frame | 27.323/28.597 | 29.999/31.021 | 29.998/31.020 | 0.000 | 0.000 | 145.216 | 10 | measured |
| moui-skia-gpu | stress | open | ui-frame | 93.519/93.519 | -/- | -/- | 0.000 | 0.000 | 124.595 | 0 | measured |
| moui-skia-gpu | stress | scroll | ui-frame | 68.424/80.776 | 69.117/81.295 | -/- | 0.000 | 0.000 | 125.829 | 424 | measured |
| moui-skia-raster | large | input | ui-frame | 18.305/18.433 | 23.374/23.670 | 23.373/23.668 | 0.000 | 4.440 | 115.209 | 10 | measured |
| moui-skia-raster | large | open | ui-frame | 83.539/83.539 | -/- | -/- | 0.000 | 6.960 | 99.270 | 0 | measured |
| moui-skia-raster | large | scroll | ui-frame | 62.569/76.907 | 67.946/82.486 | -/- | 0.000 | 4.661 | 115.095 | 428 | measured |
| moui-skia-raster | medium | input | ui-frame | 18.374/18.842 | 23.162/23.795 | 23.161/23.794 | 0.000 | 4.369 | 114.259 | 10 | measured |
| moui-skia-raster | medium | open | ui-frame | 83.579/83.579 | -/- | -/- | 0.000 | 6.189 | 96.209 | 0 | measured |
| moui-skia-raster | medium | scroll | ui-frame | 64.145/80.269 | 69.580/87.199 | -/- | 0.000 | 4.694 | 95.786 | 440 | measured |
| moui-skia-raster | small | input | ui-frame | 44.914/63.033 | 55.252/73.381 | 55.251/73.380 | 0.000 | 9.534 | 187.610 | 28 | measured |
| moui-skia-raster | small | open | ui-frame | 136.305/136.305 | -/- | -/- | 0.000 | 7.957 | 152.100 | 0 | measured |
| moui-skia-raster | small | scroll | ui-frame | 66.720/83.326 | 72.331/89.508 | -/- | 0.000 | 4.876 | 165.911 | 446 | measured |
| moui-skia-raster | stress | input | ui-frame | 18.548/19.088 | 26.061/26.966 | 26.060/26.965 | 0.000 | 4.309 | 137.312 | 10 | measured |
| moui-skia-raster | stress | open | ui-frame | 82.044/82.044 | -/- | -/- | 0.000 | 6.086 | 119.594 | 0 | measured |
| moui-skia-raster | stress | scroll | ui-frame | 61.196/72.908 | 66.385/78.855 | -/- | 0.000 | 4.502 | 118.425 | 422 | measured |
| moui-wgpu | large | input | ui-frame | 7.543/8.547 | 8.156/9.267 | 8.155/9.267 | 0.000 | 0.000 | 78.809 | 0 | measured |
| moui-wgpu | large | open | ui-frame | 67.890/67.890 | -/- | -/- | 0.000 | 0.000 | 76.559 | 0 | measured |
| moui-wgpu | large | scroll | ui-frame | 8.428/9.808 | 9.038/10.934 | -/- | 0.000 | 0.000 | 71.477 | 0 | measured |
| moui-wgpu | medium | input | ui-frame | 7.785/9.066 | 8.236/9.496 | 8.235/9.495 | 0.000 | 0.000 | 72.602 | 0 | measured |
| moui-wgpu | medium | open | ui-frame | 67.153/67.153 | -/- | -/- | 0.000 | 0.000 | 73.558 | 0 | measured |
| moui-wgpu | medium | scroll | ui-frame | 8.456/9.787 | 9.064/10.988 | -/- | 0.000 | 0.000 | 71.440 | 0 | measured |
| moui-wgpu | small | input | ui-frame | 7.515/8.463 | 7.934/8.950 | 7.934/8.949 | 0.000 | 0.000 | 73.580 | 0 | measured |
| moui-wgpu | small | open | ui-frame | 250.095/250.095 | -/- | -/- | 0.000 | 0.000 | 256.370 | 0 | measured |
| moui-wgpu | small | scroll | ui-frame | 8.407/9.915 | 9.033/11.019 | -/- | 0.000 | 0.000 | 71.622 | 0 | measured |
| moui-wgpu | stress | input | ui-frame | 4.991/6.790 | 8.660/10.431 | 8.659/10.430 | 0.000 | 0.000 | 95.860 | 0 | measured |
| moui-wgpu | stress | open | ui-frame | 67.723/67.723 | -/- | -/- | 0.000 | 0.000 | 99.438 | 0 | measured |
| moui-wgpu | stress | scroll | ui-frame | 8.422/9.995 | 9.036/11.059 | -/- | 0.000 | 0.000 | 94.631 | 0 | measured |

Metric definitions: `frame_work_ms` is framework build/layout/paint/draw work; `frame_interval_ms` is the interval between displayed frames; `input_to_visible_ms` is action-to-visible completion; `dropped_display_frames` counts refresh slots missed from displayed intervals. WGPU and Skia GPU report offscreen and CPU readback separately. `first_interactive_ms` is measured from adapter initialization to the first interactive frame; process lifetime is not used as a startup proxy.
