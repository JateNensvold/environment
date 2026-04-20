#!/usr/bin/env python3

from __future__ import annotations

import json

from agent_memory_common import (
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
