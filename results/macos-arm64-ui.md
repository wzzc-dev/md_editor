# Markdown editor benchmark report

- Schema: `md-editor-benchmark/v2`
- Host: `macOS-26.3-arm64-arm-64bit` / `arm64` / `16.0 GiB`
- OS release: `25.3.0`; GPU: `Apple M4`
- Toolchains: `python=3.12.11, moon=moon 0.1.20260824 (dae026a 2026-08-24), rustc=rustc 1.94.0 (4a4ef493e 2026-03-02), cargo=cargo 1.94.0 (85eff7c80 2026-01-15), node=v25.2.1, npm=11.6.2, flutter=Flutter 3.47.1 • channel stable • https://github.com/flutter/flutter.git`
- Viewport: `1280x800 @ 60 Hz`; font: `system-ui 16px`; line height: `1.55`; overscan: `3`; list: `fixed 66px`; GPU: `Metal`

- Fixtures: `small=5KB/100 blocks`; `medium=50KB/1,000 blocks`; `large=500KB/10,000 blocks`; `stress=5MB/100,000 blocks`

- Skia GPU benchmark route: `metal-gpu` with `HostGpuPresentTarget` direct drawable present; CPU `readback_ms` is expected to be zero.

| Adapter | Fixture | Scenario | Scope | Route / present | Work mean/P95 | Interval mean/P95 | Input->visible mean/P95 | Offscreen mean | Readback mean | First interactive | Dropped display frames | Status |
| --- | --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| electron | large | input | ui-frame | - | 2.230/4.100 | 10.237/12.000 | 9.617/11.900 | 0.000 | 0.000 | 101.400 | 1 | measured |
| electron | large | open | ui-frame | - | 96.367/98.300 | -/- | -/- | 0.000 | 0.000 | 96.367 | 0 | measured |
| electron | large | scroll | ui-frame | - | 1.876/2.500 | 10.022/11.600 | -/- | 0.000 | 0.000 | 100.267 | 1 | measured |
| electron | medium | input | ui-frame | - | 2.070/2.900 | 10.337/12.000 | 9.690/12.100 | 0.000 | 0.000 | 91.333 | 1 | measured |
| electron | medium | open | ui-frame | - | 90.700/93.900 | -/- | -/- | 0.000 | 0.000 | 90.700 | 0 | measured |
| electron | medium | scroll | ui-frame | - | 1.853/2.500 | 10.000/11.500 | -/- | 0.000 | 0.000 | 93.833 | 0 | measured |
| electron | small | input | ui-frame | - | 2.120/3.200 | 10.003/11.100 | 9.593/11.500 | 0.000 | 0.000 | 97.700 | 0 | measured |
| electron | small | open | ui-frame | - | 90.467/91.500 | -/- | -/- | 0.000 | 0.000 | 90.467 | 0 | measured |
| electron | small | scroll | ui-frame | - | 1.851/2.600 | 10.001/10.300 | -/- | 0.000 | 0.000 | 92.167 | 0 | measured |
| electron | stress | input | ui-frame | - | 2.027/4.200 | 9.987/10.900 | 9.583/11.100 | 0.000 | 0.000 | 125.167 | 0 | measured |
| electron | stress | open | ui-frame | - | 120.400/128.800 | -/- | -/- | 0.000 | 0.000 | 120.400 | 0 | measured |
| electron | stress | scroll | ui-frame | - | 1.896/2.500 | 9.993/10.900 | -/- | 0.000 | 0.000 | 119.467 | 0 | measured |
| flutter-impeller | large | input | ui-frame | - | 2.043/3.279 | 11.667/20.002 | 9.806/16.323 | 0.000 | 0.000 | 100.296 | 4 | measured |
| flutter-impeller | large | open | ui-frame | - | 93.719/96.924 | -/- | -/- | 0.000 | 0.000 | 93.719 | 0 | measured |
| flutter-impeller | large | scroll | ui-frame | - | 2.070/4.058 | 10.000/10.002 | -/- | 0.000 | 0.000 | 106.710 | 0 | measured |
| flutter-impeller | medium | input | ui-frame | - | 1.945/2.676 | 12.334/30.001 | 10.224/13.016 | 0.000 | 0.000 | 94.057 | 5 | measured |
| flutter-impeller | medium | open | ui-frame | - | 99.978/108.579 | -/- | -/- | 0.000 | 0.000 | 99.978 | 0 | measured |
| flutter-impeller | medium | scroll | ui-frame | - | 2.191/4.074 | 10.028/10.003 | -/- | 0.000 | 0.000 | 101.654 | 1 | measured |
| flutter-impeller | small | input | ui-frame | - | 1.990/2.829 | 14.223/50.005 | 10.416/18.036 | 0.000 | 0.000 | 101.771 | 9 | measured |
| flutter-impeller | small | open | ui-frame | - | 101.214/109.792 | -/- | -/- | 0.000 | 0.000 | 101.214 | 0 | measured |
| flutter-impeller | small | scroll | ui-frame | - | 1.825/3.393 | 10.000/10.003 | -/- | 0.000 | 0.000 | 99.238 | 0 | measured |
| flutter-impeller | stress | input | ui-frame | - | 2.258/3.382 | 17.485/50.007 | 11.296/19.475 | 0.000 | 0.000 | 122.032 | 15 | measured |
| flutter-impeller | stress | open | ui-frame | - | 136.104/140.509 | -/- | -/- | 0.000 | 0.000 | 136.104 | 0 | measured |
| flutter-impeller | stress | scroll | ui-frame | - | 2.010/3.765 | 10.000/10.002 | -/- | 0.000 | 0.000 | 118.961 | 0 | measured |
| flutter-skia | large | input | ui-frame | - | 2.179/4.187 | 14.001/50.004 | 11.086/22.990 | 0.000 | 0.000 | 106.479 | 9 | measured |
| flutter-skia | large | open | ui-frame | - | 97.726/101.432 | -/- | -/- | 0.000 | 0.000 | 97.726 | 0 | measured |
| flutter-skia | large | scroll | ui-frame | - | 2.021/4.025 | 10.000/10.002 | -/- | 0.000 | 0.000 | 102.539 | 0 | measured |
| flutter-skia | medium | input | ui-frame | - | 2.086/3.022 | 14.000/50.004 | 10.177/16.301 | 0.000 | 0.000 | 114.223 | 8 | measured |
| flutter-skia | medium | open | ui-frame | - | 100.056/106.260 | -/- | -/- | 0.000 | 0.000 | 100.056 | 0 | measured |
| flutter-skia | medium | scroll | ui-frame | - | 2.144/4.328 | 10.056/10.002 | -/- | 0.000 | 0.000 | 106.195 | 1 | measured |
| flutter-skia | small | input | ui-frame | - | 2.038/3.110 | 12.000/30.004 | 10.287/18.391 | 0.000 | 0.000 | 94.224 | 4 | measured |
| flutter-skia | small | open | ui-frame | - | 104.694/113.712 | -/- | -/- | 0.000 | 0.000 | 104.694 | 0 | measured |
| flutter-skia | small | scroll | ui-frame | - | 1.770/3.255 | 10.000/10.003 | -/- | 0.000 | 0.000 | 112.652 | 0 | measured |
| flutter-skia | stress | input | ui-frame | - | 2.098/3.341 | 15.788/30.004 | 10.497/19.098 | 0.000 | 0.000 | 118.171 | 11 | measured |
| flutter-skia | stress | open | ui-frame | - | 119.998/133.269 | -/- | -/- | 0.000 | 0.000 | 119.998 | 0 | measured |
| flutter-skia | stress | scroll | ui-frame | - | 2.090/3.994 | 10.056/10.002 | -/- | 0.000 | 0.000 | 128.357 | 1 | measured |
| gpui | large | input | ui-frame | - | 0.179/0.281 | 10.685/24.491 | 10.682/24.483 | 0.000 | 0.000 | 240.169 | 3 | measured |
| gpui | large | open | ui-frame | - | 0.000/0.000 | -/- | -/- | 0.000 | 0.000 | 217.373 | 0 | measured |
| gpui | large | scroll | ui-frame | - | 0.003/0.007 | 10.079/10.644 | -/- | 0.000 | 0.000 | 213.288 | 3 | measured |
| gpui | medium | input | ui-frame | - | 0.167/0.215 | 11.263/34.599 | 11.260/34.589 | 0.000 | 0.000 | 216.853 | 5 | measured |
| gpui | medium | open | ui-frame | - | 0.000/0.000 | -/- | -/- | 0.000 | 0.000 | 223.648 | 0 | measured |
| gpui | medium | scroll | ui-frame | - | 0.003/0.006 | 10.115/11.920 | -/- | 0.000 | 0.000 | 240.723 | 4 | measured |
| gpui | small | input | ui-frame | - | 0.161/0.218 | 10.788/27.016 | 10.784/27.011 | 0.000 | 0.000 | 249.123 | 3 | measured |
| gpui | small | open | ui-frame | - | 0.000/0.000 | -/- | -/- | 0.000 | 0.000 | 241.303 | 0 | measured |
| gpui | small | scroll | ui-frame | - | 0.003/0.006 | 10.070/11.622 | -/- | 0.000 | 0.000 | 226.067 | 3 | measured |
| gpui | stress | input | ui-frame | - | 0.178/0.305 | 10.664/25.825 | 10.660/25.806 | 0.000 | 0.000 | 226.356 | 3 | measured |
| gpui | stress | open | ui-frame | - | 0.000/0.000 | -/- | -/- | 0.000 | 0.000 | 197.181 | 0 | measured |
| gpui | stress | scroll | ui-frame | - | 0.003/0.007 | 10.069/10.762 | -/- | 0.000 | 0.000 | 220.007 | 3 | measured |
| moui-skia-gpu | large | input | ui-frame | metal-gpu / host-gpu-surface | 9.283/11.980 | 9.956/12.656 | 9.955/12.655 | 0.000 | 0.000 | 69.530 | 0 | measured |
| moui-skia-gpu | large | open | ui-frame | metal-gpu / host-gpu-surface | 64.983/70.322 | -/- | -/- | 0.000 | 0.000 | 69.217 | 0 | measured |
| moui-skia-gpu | large | scroll | ui-frame | metal-gpu / host-gpu-surface | 8.201/9.633 | 8.918/11.031 | -/- | 0.000 | 0.000 | 70.616 | 1 | measured |
| moui-skia-gpu | medium | input | ui-frame | metal-gpu / host-gpu-surface | 9.365/13.068 | 9.822/13.507 | 9.820/13.506 | 0.000 | 0.000 | 66.051 | 0 | measured |
| moui-skia-gpu | medium | open | ui-frame | metal-gpu / host-gpu-surface | 64.603/65.073 | -/- | -/- | 0.000 | 0.000 | 66.578 | 0 | measured |
| moui-skia-gpu | medium | scroll | ui-frame | metal-gpu / host-gpu-surface | 8.093/9.283 | 8.791/10.677 | -/- | 0.000 | 0.000 | 70.083 | 0 | measured |
| moui-skia-gpu | small | input | ui-frame | metal-gpu / host-gpu-surface | 9.341/12.280 | 9.770/12.729 | 9.769/12.729 | 0.000 | 0.000 | 65.501 | 0 | measured |
| moui-skia-gpu | small | open | ui-frame | metal-gpu / host-gpu-surface | 64.787/66.001 | -/- | -/- | 0.000 | 0.000 | 66.483 | 0 | measured |
| moui-skia-gpu | small | scroll | ui-frame | metal-gpu / host-gpu-surface | 8.069/9.212 | 8.779/10.603 | -/- | 0.000 | 0.000 | 65.459 | 0 | measured |
| moui-skia-gpu | stress | input | ui-frame | metal-gpu / host-gpu-surface | 6.895/10.176 | 10.578/13.606 | 10.577/13.604 | 0.000 | 0.000 | 91.560 | 0 | measured |
| moui-skia-gpu | stress | open | ui-frame | metal-gpu / host-gpu-surface | 64.443/66.008 | -/- | -/- | 0.000 | 0.000 | 91.519 | 0 | measured |
| moui-skia-gpu | stress | scroll | ui-frame | metal-gpu / host-gpu-surface | 8.062/9.274 | 8.760/10.668 | -/- | 0.000 | 0.000 | 91.962 | 0 | measured |
| moui-skia-raster | large | input | ui-frame | raster / cpu-pixel-frame | 0.583/0.767 | 5.759/6.392 | 5.758/6.392 | 0.000 | 4.537 | 63.381 | 0 | measured |
| moui-skia-raster | large | open | ui-frame | raster / cpu-pixel-frame | 50.613/51.366 | -/- | -/- | 0.000 | 6.286 | 61.354 | 0 | measured |
| moui-skia-raster | large | scroll | ui-frame | raster / cpu-pixel-frame | 2.276/4.967 | 7.636/11.306 | -/- | 0.000 | 4.673 | 64.058 | 0 | measured |
| moui-skia-raster | medium | input | ui-frame | raster / cpu-pixel-frame | 0.546/0.641 | 5.385/5.788 | 5.384/5.787 | 0.000 | 4.434 | 60.741 | 0 | measured |
| moui-skia-raster | medium | open | ui-frame | raster / cpu-pixel-frame | 52.474/55.776 | -/- | -/- | 0.000 | 7.153 | 61.607 | 0 | measured |
| moui-skia-raster | medium | scroll | ui-frame | raster / cpu-pixel-frame | 2.307/5.083 | 7.598/11.208 | -/- | 0.000 | 4.600 | 60.997 | 0 | measured |
| moui-skia-raster | small | input | ui-frame | raster / cpu-pixel-frame | 0.601/0.721 | 5.961/6.572 | 5.960/6.571 | 0.000 | 4.894 | 62.698 | 0 | measured |
| moui-skia-raster | small | open | ui-frame | raster / cpu-pixel-frame | 53.204/53.771 | -/- | -/- | 0.000 | 6.650 | 61.613 | 0 | measured |
| moui-skia-raster | small | scroll | ui-frame | raster / cpu-pixel-frame | 2.297/5.039 | 7.878/11.652 | -/- | 0.000 | 4.876 | 65.208 | 0 | measured |
| moui-skia-raster | stress | input | ui-frame | raster / cpu-pixel-frame | 0.668/0.902 | 8.876/10.156 | 8.875/10.155 | 0.000 | 4.513 | 85.416 | 0 | measured |
| moui-skia-raster | stress | open | ui-frame | raster / cpu-pixel-frame | 51.711/51.949 | -/- | -/- | 0.000 | 6.322 | 84.913 | 0 | measured |
| moui-skia-raster | stress | scroll | ui-frame | raster / cpu-pixel-frame | 2.274/5.005 | 7.528/11.031 | -/- | 0.000 | 4.565 | 84.210 | 0 | measured |
| moui-wgpu | large | input | ui-frame | wgpu / host-gpu-surface | 7.449/8.978 | 8.137/9.558 | 8.136/9.557 | 0.000 | 0.000 | 75.084 | 0 | measured |
| moui-wgpu | large | open | ui-frame | wgpu / host-gpu-surface | 71.523/73.210 | -/- | -/- | 0.000 | 0.000 | 75.995 | 0 | measured |
| moui-wgpu | large | scroll | ui-frame | wgpu / host-gpu-surface | 7.647/8.905 | 8.332/9.592 | -/- | 0.000 | 0.000 | 74.027 | 0 | measured |
| moui-wgpu | medium | input | ui-frame | wgpu / host-gpu-surface | 7.709/8.560 | 8.179/9.006 | 8.179/9.005 | 0.000 | 0.000 | 72.881 | 0 | measured |
| moui-wgpu | medium | open | ui-frame | wgpu / host-gpu-surface | 70.558/71.302 | -/- | -/- | 0.000 | 0.000 | 72.590 | 0 | measured |
| moui-wgpu | medium | scroll | ui-frame | wgpu / host-gpu-surface | 7.655/8.920 | 8.330/9.546 | -/- | 0.000 | 0.000 | 70.785 | 0 | measured |
| moui-wgpu | small | input | ui-frame | wgpu / host-gpu-surface | 7.736/9.138 | 8.160/9.635 | 8.159/9.635 | 0.000 | 0.000 | 73.619 | 0 | measured |
| moui-wgpu | small | open | ui-frame | wgpu / host-gpu-surface | 71.764/73.443 | -/- | -/- | 0.000 | 0.000 | 73.548 | 0 | measured |
| moui-wgpu | small | scroll | ui-frame | wgpu / host-gpu-surface | 7.722/8.934 | 8.426/9.582 | -/- | 0.000 | 0.000 | 72.607 | 1 | measured |
| moui-wgpu | stress | input | ui-frame | wgpu / host-gpu-surface | 4.514/6.480 | 8.289/9.987 | 8.288/9.986 | 0.000 | 0.000 | 97.320 | 0 | measured |
| moui-wgpu | stress | open | ui-frame | wgpu / host-gpu-surface | 69.715/70.540 | -/- | -/- | 0.000 | 0.000 | 97.026 | 0 | measured |
| moui-wgpu | stress | scroll | ui-frame | wgpu / host-gpu-surface | 7.649/8.975 | 8.330/9.604 | -/- | 0.000 | 0.000 | 96.525 | 0 | measured |

Metric definitions: `frame_work_ms` is framework build/layout/paint/draw work; `frame_interval_ms` is the interval between displayed frames; `input_to_visible_ms` is action-to-visible completion; `dropped_display_frames` counts refresh slots missed from displayed intervals. WGPU and Skia GPU report offscreen and CPU readback separately. `first_interactive_ms` is measured from adapter initialization to the first interactive frame; process lifetime is not used as a startup proxy.
