#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include "flutter_window.h"
#include "utils.h"

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger. Skip when stdio was
  // redirected (benchmark harnesses capture the engine log through pipes):
  // ATTACH_PARENT_PROCESS would rebind stderr to the parent console and
  // hide the renderer startup line from the capturing pipe.
  DWORD console_mode = 0;
  const HANDLE stderr_handle = ::GetStdHandle(STD_ERROR_HANDLE);
  const bool stdio_redirected =
      stderr_handle != nullptr && stderr_handle != INVALID_HANDLE_VALUE &&
      ::GetConsoleMode(stderr_handle, &console_mode) == FALSE;
  if (!stdio_redirected) {
    if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
      CreateAndAttachConsole();
    }
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(1280, 800);
  if (!window.Create(L"cross_framework_markdown_flutter", origin, size)) {
    return EXIT_FAILURE;
  }

  // Win32 window sizes are physical pixels. On a scaled monitor (e.g. 125%
  // DPI) creating the client area at 1280x800 physical leaves Flutter with
  // a ~1024x640 logical viewport, which fails the benchmark's 1280x800
  // logical gate. Resize so the client area is exactly 1280x800 logical at
  // the window's current monitor DPI.
  if (HWND hwnd = window.GetHandle()) {
    const UINT dpi = ::GetDpiForWindow(hwnd);
    if (dpi > 0) {
      RECT client{0, 0, static_cast<LONG>(1280.0 * dpi / 96.0 + 0.5),
                  static_cast<LONG>(800.0 * dpi / 96.0 + 0.5)};
      const BOOL adjusted = ::AdjustWindowRectExForDpi(
          &client, ::GetWindowLongW(hwnd, GWL_STYLE), FALSE,
          ::GetWindowLongW(hwnd, GWL_EXSTYLE), dpi);
      if (adjusted) {
        ::SetWindowPos(hwnd, nullptr, 0, 0, client.right - client.left,
                       client.bottom - client.top,
                       SWP_NOMOVE | SWP_NOZORDER | SWP_NOACTIVATE);
      }
    }
  }

  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
