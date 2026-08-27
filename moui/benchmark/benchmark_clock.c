#ifdef _WIN32
#include <windows.h>

double md_editor_benchmark_now_ms(void) {
  LARGE_INTEGER counter;
  LARGE_INTEGER frequency;
  QueryPerformanceCounter(&counter);
  QueryPerformanceFrequency(&frequency);
  return (double)counter.QuadPart * 1000.0 / (double)frequency.QuadPart;
}
#elif defined(__APPLE__)
#include <mach/mach_time.h>

double md_editor_benchmark_now_ms(void) {
  static mach_timebase_info_data_t timebase;
  if (timebase.denom == 0) {
    mach_timebase_info(&timebase);
  }
  return (double)mach_continuous_time() * (double)timebase.numer /
         (double)timebase.denom / 1000000.0;
}
#else
#include <time.h>

double md_editor_benchmark_now_ms(void) {
  struct timespec value;
  clock_gettime(CLOCK_MONOTONIC, &value);
  return (double)value.tv_sec * 1000.0 + (double)value.tv_nsec / 1000000.0;
}
#endif
