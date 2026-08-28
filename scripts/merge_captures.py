#!/usr/bin/env python3
"""Merge a supplementary benchmark capture into an audited base capture.

Used to extend an existing full-suite capture with rows from a newly added
adapter (for example `moui-wgpu`) without re-running the other toolchains.
The merged JSON records the provenance of every contributing capture.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("base", type=Path, help="audited base capture JSON")
    parser.add_argument("extra", type=Path, help="supplementary capture JSON")
    parser.add_argument("--adapter", required=True, help="adapter name to copy from the extra capture")
    parser.add_argument("--out", type=Path, required=True)
    args = parser.parse_args()

    base = json.loads(args.base.read_text(encoding="utf-8"))
    extra = json.loads(args.extra.read_text(encoding="utf-8"))

    for field in ("platform", "machine", "gpu"):
        if base.get(field) != extra.get(field):
            print(
                f"warning: {field} differs: base={base.get(field)!r} extra={extra.get(field)!r}",
                file=sys.stderr,
            )

    copied = [
        record
        for record in extra["records"]
        if record.get("adapter") == args.adapter and record.get("status") == "measured"
    ]
    if not copied:
        raise SystemExit(f"no measured records for adapter {args.adapter!r} in {args.extra}")

    base["records"] = [record for record in base["records"] if record.get("adapter") != args.adapter]
    base["records"].extend(copied)
    merged = base.setdefault("merged_captures", [])
    merged.append(
        {
            "adapter": args.adapter,
            "source": str(args.extra),
            "generated_at_utc": extra.get("generated_at_utc"),
            "records": len(copied),
        }
    )
    args.out.write_text(json.dumps(base, indent=2) + "\n", encoding="utf-8")
    print(f"wrote {args.out} ({len(copied)} {args.adapter} records merged)")


if __name__ == "__main__":
    main()
