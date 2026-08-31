#!/usr/bin/env python3
"""Keep an xctrace-launched process alive while its adapter window tears down.

Xcode 26 may abandon deferred Animation Hitches stores when the process passed
to ``--launch`` exits before the recorder's time limit.  This tiny host keeps
that launch target alive, forwards the adapter's stdout, and records the child
PID so compositor rows can still be associated with the real window process.
"""

from __future__ import annotations

import argparse
import os
import signal
import subprocess
import sys
import time


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--pid-file", required=True)
    parser.add_argument("--tail-ms", type=int, default=60_000)
    parser.add_argument("command", nargs=argparse.REMAINDER)
    args = parser.parse_args()
    # Instruments ends a launched recording by signalling its target. Ignore
    # the soft signal so the recorder can finalize its deferred stores while
    # the host remains alive; the bounded tail below still guarantees exit.
    signal.signal(signal.SIGINT, signal.SIG_IGN)
    signal.signal(signal.SIGTERM, signal.SIG_IGN)
    command = list(args.command)
    if command[:1] == ["--"]:
        command = command[1:]
    if not command:
        print("trace launch host requires an adapter command", file=sys.stderr)
        return 64
    child = subprocess.Popen(
        command,
        cwd=os.getcwd(),
        env=os.environ.copy(),
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        bufsize=1,
        start_new_session=True,
    )
    try:
        with open(args.pid_file, "w", encoding="ascii") as handle:
            handle.write(str(child.pid))
    except OSError:
        pass

    # Relay both streams while the child is alive. The benchmark JSON is on
    # stdout; forwarding stderr makes adapter diagnostics visible in xctrace's
    # target output without changing the machine-readable result file.
    import selectors

    mirror_path = os.environ.get("UI_BENCHMARK_TRACE_MIRROR")
    mirror = open(mirror_path, "a", encoding="utf-8") if mirror_path else None
    selector = selectors.DefaultSelector()
    assert child.stdout is not None and child.stderr is not None
    selector.register(child.stdout, selectors.EVENT_READ, sys.stdout)
    selector.register(child.stderr, selectors.EVENT_READ, sys.stderr)
    while selector.get_map():
        for key, _ in selector.select(timeout=0.1):
            line = key.fileobj.readline()
            if line:
                key.data.write(line)
                key.data.flush()
                if mirror is not None and key.data is sys.stdout:
                    mirror.write(line)
                    mirror.flush()
            else:
                selector.unregister(key.fileobj)
                key.fileobj.close()
        if child.poll() is not None and not selector.get_map():
            break
    return_code = child.wait()
    if mirror is not None:
        mirror.close()
    # Keep xctrace's launched target alive past the recorder limit. The host
    # itself has no window and therefore does not affect surface association.
    tail_ms = max(0, min(args.tail_ms, 180_000))
    if tail_ms:
        time.sleep(tail_ms / 1000.0)
    return return_code


if __name__ == "__main__":
    raise SystemExit(main())
