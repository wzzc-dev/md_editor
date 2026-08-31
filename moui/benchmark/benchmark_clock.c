#include <stdint.h>

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
#include <os/signpost.h>
#include <os/log.h>
#include <stdlib.h>
#include <sys/time.h>
#include <unistd.h>

double md_editor_benchmark_now_ms(void) {
  static mach_timebase_info_data_t timebase;
  if (timebase.denom == 0) {
    mach_timebase_info(&timebase);
  }
  return (double)mach_continuous_time() * (double)timebase.numer /
         (double)timebase.denom / 1000000.0;
}

double md_editor_benchmark_epoch_ms(void) {
  struct timeval value;
  gettimeofday(&value, NULL);
  return (double)value.tv_sec * 1000.0 + (double)value.tv_usec / 1000.0;
}

static os_log_t md_editor_benchmark_log(void) {
  static os_log_t log;
  if (log == NULL) {
    log = os_log_create("md_editor.benchmark", OS_LOG_CATEGORY_POINTS_OF_INTEREST);
  }
  return log;
}

void md_editor_benchmark_signpost_event(int32_t action_id) {
  os_log_t log = md_editor_benchmark_log();
  if (log != NULL) {
    os_log(log, "md_editor_action id=%d", action_id);
    os_signpost_event_emit(log, OS_SIGNPOST_ID_EXCLUSIVE,
                           "md_editor_action", "id=%d", action_id);
  }
}

void md_editor_benchmark_delay_ms(int32_t milliseconds) {
  if (milliseconds > 0) usleep((useconds_t)milliseconds * 1000u);
}

int32_t md_editor_benchmark_trace_tail_ms(void) {
  const char *value = getenv("UI_BENCHMARK_TRACE_TAIL_MS");
  if (value == NULL || *value == '\0') return 15000;
  char *end = NULL;
  long parsed = strtol(value, &end, 10);
  if (end == value || parsed < 0) return 15000;
  if (parsed > 120000) parsed = 120000;
  return (int32_t)parsed;
}
#else
#include <time.h>

double md_editor_benchmark_now_ms(void) {
  struct timespec value;
  clock_gettime(CLOCK_MONOTONIC, &value);
  return (double)value.tv_sec * 1000.0 + (double)value.tv_nsec / 1000000.0;
}

void md_editor_benchmark_signpost_event(int32_t action_id) {
  (void)action_id;
}

void md_editor_benchmark_delay_ms(int32_t milliseconds) {
  (void)milliseconds;
}

int32_t md_editor_benchmark_trace_tail_ms(void) {
  return 15000;
}
#endif

#if defined(_WIN32)
double md_editor_benchmark_epoch_ms(void) {
  FILETIME filetime;
  ULARGE_INTEGER ticks;
  GetSystemTimePreciseAsFileTime(&filetime);
  ticks.LowPart = filetime.dwLowDateTime;
  ticks.HighPart = filetime.dwHighDateTime;
  return (double)(ticks.QuadPart - 116444736000000000ULL) / 10000.0;
}
#elif !defined(__APPLE__)
double md_editor_benchmark_epoch_ms(void) {
  struct timespec value;
  clock_gettime(CLOCK_REALTIME, &value);
  return (double)value.tv_sec * 1000.0 + (double)value.tv_nsec / 1000000.0;
}
#endif
