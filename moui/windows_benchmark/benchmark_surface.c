/*
 * Offscreen Win32 window for the WGPU UI benchmark.
 *
 * The WGPU renderer binds through an HWND surface (wgpu creates a D3D12
 * swapchain on it), so the benchmark can render frames without ever showing
 * a window. The process is made per-monitor DPI aware first so the client
 * area stays exactly `width x height` physical pixels under display scaling,
 * matching the 1:1 drawable semantics of the macOS CAMetalLayer stub. The
 * whole file degrades to a no-op on non-Windows platforms.
 */
#include <stdint.h>

#if defined(_WIN32)
#include <windows.h>
#endif

void *md_editor_benchmark_u64_to_ptr(uint64_t value) {
  return (void *)(uintptr_t)value;
}

#if defined(_WIN32)
typedef BOOL(WINAPI *md_benchmark_set_dpi_context)(DPI_AWARENESS_CONTEXT);

static void md_editor_benchmark_make_dpi_aware(void) {
  static int attempted = 0;
  if (attempted) {
    return;
  }
  attempted = 1;
  HMODULE user32 = LoadLibraryA("user32.dll");
  if (user32 != NULL) {
    md_benchmark_set_dpi_context set_context =
        (md_benchmark_set_dpi_context)GetProcAddress(
            user32, "SetProcessDpiAwarenessContext");
    if (set_context != NULL &&
        set_context(DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2)) {
      return;
    }
  }
  SetProcessDPIAware();
}
#endif

uint64_t md_editor_benchmark_offscreen_hinstance(void) {
#if defined(_WIN32)
  return (uint64_t)(uintptr_t)GetModuleHandleW(NULL);
#else
  return 0;
#endif
}

uint64_t md_editor_benchmark_offscreen_hwnd(int32_t width, int32_t height,
                                            double scale_factor) {
  (void)scale_factor;
#if defined(_WIN32)
  static ATOM atom = 0;
  if (atom == 0) {
    md_editor_benchmark_make_dpi_aware();
    WNDCLASSW window_class;
    ZeroMemory(&window_class, sizeof(window_class));
    window_class.lpfnWndProc = DefWindowProcW;
    window_class.hInstance = GetModuleHandleW(NULL);
    window_class.lpszClassName = L"MoUIBenchmarkOffscreenWindow";
    atom = RegisterClassW(&window_class);
    if (atom == 0) {
      return 0;
    }
  }
  HWND hwnd = CreateWindowExW(
      0, L"MoUIBenchmarkOffscreenWindow", L"MoUI Benchmark", WS_POPUP, 0, 0,
      width, height, NULL, NULL, GetModuleHandleW(NULL), NULL);
  return (uint64_t)(uintptr_t)hwnd;
#else
  (void)width;
  (void)height;
  return 0;
#endif
}
