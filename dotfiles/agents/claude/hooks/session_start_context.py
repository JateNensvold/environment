#!/usr/bin/env python3

from __future__ import annotations

import json
import os
import sys

# Python realpaths sys.path[0], which lands in a nix-store output containing only
# this file. agent_memory_common is a sibling symlink in the shim dir
# (~/.claude/hooks/), so prepend the pre-realpath dir to sys.path first.
sys.path.insert(0, os.path.dirname(os.path.abspath(sys.argv[0])))

from agent_memory_common import (  # noqa: E402
    build_context_text,
    ensure_memory_files,
    load_hook_input,
    repo_root_for,
)


def main() -> None:
    payload = load_hook_input()
    repo_root = repo_root_for(payload.get("cwd"))
    memory = ensure_memory_files(repo_root)

    output = {
        "hookSpecificOutput": {
            "hookEventName": "SessionStart",
            "additionalContext": build_context_text(memory),
        }
    }
    print(json.dumps(output))


if __name__ == "__main__":
    main()
