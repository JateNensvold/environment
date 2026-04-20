#!/usr/bin/env python3

from __future__ import annotations

import json
import os
import subprocess
from pathlib import Path

DEFAULT_PATTERNS = "# Patterns & Conventions\n"
DEFAULT_CHANGELOG = "# Changelog\n"
MAX_CONTEXT_CHARS = 12_000


def load_hook_input() -> dict:
    raw = os.read(0, 1 << 20)
    if not raw:
        return {}
    return json.loads(raw.decode("utf-8"))


def repo_root_for(cwd: str | None) -> Path:
    working_dir = Path(cwd or os.getcwd()).resolve()
    try:
        proc = subprocess.run(
            ["git", "rev-parse", "--show-toplevel"],
            cwd=working_dir,
            check=True,
            capture_output=True,
            text=True,
        )
    except (FileNotFoundError, subprocess.CalledProcessError):
        return working_dir

    return Path(proc.stdout.strip()).resolve()


def choose_memory_dir(repo_root: Path) -> Path:
    agent_dir = repo_root / ".agent"
    legacy_dir = repo_root / ".claude"

    agent_exists = (
        agent_dir.exists()
        or (agent_dir / "patterns.md").exists()
        or (agent_dir / "changelog.md").exists()
    )
    legacy_exists = (
        legacy_dir.exists()
        or (legacy_dir / "patterns.md").exists()
        or (legacy_dir / "changelog.md").exists()
    )

    if agent_exists or not legacy_exists:
        return agent_dir

    return legacy_dir


def ensure_memory_files(repo_root: Path) -> dict:
    memory_dir = choose_memory_dir(repo_root)
    memory_dir.mkdir(parents=True, exist_ok=True)

    patterns_path = memory_dir / "patterns.md"
    changelog_path = memory_dir / "changelog.md"

    if not patterns_path.exists():
        patterns_path.write_text(DEFAULT_PATTERNS, encoding="utf-8")
    if not changelog_path.exists():
        changelog_path.write_text(DEFAULT_CHANGELOG, encoding="utf-8")

    return {
        "repo_root": repo_root,
        "memory_dir": memory_dir,
        "patterns_path": patterns_path,
        "changelog_path": changelog_path,
    }


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def global_agents_path() -> Path:
    return Path.home() / ".codex" / "AGENTS.md"


def truncate_text(text: str, limit: int = MAX_CONTEXT_CHARS) -> str:
    if len(text) <= limit:
        return text
    return text[:limit].rstrip() + "\n... [truncated]\n"


def build_context_text(memory: dict) -> str:
    memory_dir = memory["memory_dir"]
    canonical_hint = (
        "Canonical location is `.agent/`; `.claude/` remains a legacy fallback."
    )
    global_agents = ""
    agents_path = global_agents_path()
    if agents_path.exists():
        agents = truncate_text(read_text(agents_path))
        global_agents = (
            "Global agent instructions are stored in `~/.codex/AGENTS.md`.\n\n"
            f"Contents of `~/.codex/AGENTS.md`:\n{agents}\n\n"
        )
    patterns = truncate_text(read_text(memory["patterns_path"]))
    changelog = truncate_text(read_text(memory["changelog_path"]))

    return (
        f"{global_agents}"
        f"Agent memory is stored in `{memory_dir.relative_to(memory['repo_root'])}/`. "
        f"{canonical_hint}\n\n"
        f"Contents of `{memory['patterns_path'].relative_to(memory['repo_root'])}`:\n"
        f"{patterns}\n\n"
        f"Contents of `{memory['changelog_path'].relative_to(memory['repo_root'])}`:\n"
        f"{changelog}"
    )
