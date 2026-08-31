#include <os/log.h>
#include <os/signpost.h>
#include <stdio.h>
#include <stdlib.h>

int main(void) {
  os_log_t log = os_log_create("md_editor.benchmark", OS_LOG_CATEGORY_POINTS_OF_INTEREST);
  char line[64];
  while (fgets(line, sizeof(line), stdin) != NULL) {
    char *end = NULL;
    long id = strtol(line, &end, 10);
    if (end == line) continue;
    os_log(log, "md_editor_action id=%ld", id);
    if (log != NULL) {
      os_signpost_event_emit(log, OS_SIGNPOST_ID_EXCLUSIVE,
                             "md_editor_action", "id=%ld", id);
    }
  }
  return 0;
}
