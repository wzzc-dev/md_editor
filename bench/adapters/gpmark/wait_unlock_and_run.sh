#!/bin/sh
# Wait for the macOS console session to be unlocked, then run the full UI
# benchmark matrix. The GpMark.mbt adapter drives its benchmark loop from GPUI
# on_next_frame (vsync pacing) and needs a window the WindowServer can
# present; while the console is locked at the lock screen the frame pump
# never ticks and the process stalls at 0% CPU in NSApplication run.
# Headless adapters are unaffected, but the matrix must run as one batch,
# so the whole run waits for an unlocked console.
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT" || exit 1
[ -f scripts/run_ui_benchmark.sh ] || { echo "run_ui_benchmark.sh not found under $ROOT"; exit 1; }
MAX_MINUTES="${MAX_MINUTES:-960}"
elapsed=0
while true; do
  python3 -c "
import sys
sys.path.insert(0, '$ROOT/bench')
try:
    from macos_display_trace import display_session_locked
    locked = display_session_locked()
except Exception as exc:  # fail closed: treat probe errors as locked
    print('lock probe failed:', exc)
    locked = True
sys.exit(0 if locked else 1)
" || break
  echo "[$(date '+%F %T')] console locked; waiting 60s (minute $((elapsed / 60))/${MAX_MINUTES})"
  sleep 60
  elapsed=$((elapsed + 60))
  if [ "$elapsed" -ge $((MAX_MINUTES * 60)) ]; then
    echo "[$(date '+%F %T')] giving up: console still locked after ${MAX_MINUTES} minutes"
    exit 2
  fi
done
echo "[$(date '+%F %T')] console unlocked; starting full matrix"
# Keep display/system awake so an automatic screensaver lock cannot stall the
# run after it has started (a manual lock would still stall windowed cells).
UI_BENCHMARK_TIMEOUT_SECONDS=600 exec caffeinate -dis ./scripts/run_ui_benchmark.sh
