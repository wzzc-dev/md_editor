#!/usr/bin/env python3
"""Summarize the non-measured rows of a benchmark result as Markdown.

A benchmark run that fails `--fail-on-error` prints only a count at the end of
a long, otherwise quiet log — and until the artifacts were uploaded even that
count was the only clue. CI writes this table into `$GITHUB_STEP_SUMMARY` so a
red smoke run names the adapter, the fixture, the scenario and the reason in
the job page itself.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("usage: summary.py results/benchmark.json")
    payload = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
    records = payload.get("records", [])
    unmeasured = [record for record in records if record.get("status") != "measured"]
    print(f"{len(records) - len(unmeasured)}/{len(records)} measured")
    if not unmeasured:
        return
    print()
    print("| adapter | fixture | scenario | status | reason |")
    print("| --- | --- | --- | --- | --- |")
    for record in unmeasured:
        reason = record.get("error") or record.get("reason") or "no reason reported"
        # Markdown table cells cannot span lines; the adapter's own output stays
        # in the JSON artifact.
        reason = " ".join(str(reason).split())[:300] or "no reason reported"
        reason = reason.replace("|", "\\|")
        print(
            f"| {record.get('adapter')} | {record.get('fixture')} | "
            f"{record.get('scenario')} | {record.get('status')} | {reason} |"
        )


if __name__ == "__main__":
    main()
