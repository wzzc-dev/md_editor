#!/usr/bin/env python3
"""Emit an explicit benchmark error when GPUI cannot start on this host.

The real GPUI adapter remains in ``ui_benchmark.py``. This entrypoint is used
only by captures made in environments where AppKit/dyld leaves the GPUI
process in an uninterruptible startup wait, so reports do not silently omit
the framework or reuse stale measurements.
"""

import json
import sys


scenario = sys.argv[2] if len(sys.argv) > 2 else "-"
print(json.dumps({
    "adapter": "gpui",
    "measurement_scope": "ui-frame",
    "scenario": scenario,
    "status": "error",
    "error": "GPUI AppKit/dyld startup did not reach a benchmark frame in this environment",
}))
