# Patterns & Conventions

## Memory

- `.agent/` is the canonical repo memory location; `.claude/` is a legacy fallback. Startup
  hooks preserve tracked memory directories and locally exclude newly created untracked ones.
- Startup context should inject `patterns.md` only; `changelog.md` is on-demand history.
- Keep `patterns.md` to durable repo-specific rules and gotchas; target about 12 short bullets
  or <= 600 tokens.
- Prune stale or duplicate notes; do not copy changelog history, temporary task notes, or
  global guidance into this file unless the repo has a local exception.

## Activation gotchas

- Repo-managed Claude/Codex commands, skills, and hooks usually need a human `reload`; tmux
  config and edits under `dotfiles/scripts/bash/default/` are linked live from the repo.
- If `~/.codex/skills` points at the repo tree, ignore the mirrored
  `dotfiles/agents/codex/skills/.system` subtree.
- Local Codex shell commands fail before execution if `~/.codex/hooks/pre_tool_use_guard.py`
  is missing.
- Shell heredoc terminators inside `home.activation` snippets must start at column 0.
- `codex-sandbox` must not `exec` the final `bwrap` process when an `EXIT` trap is responsible
  for cleanup such as temporary `ssh-agent` teardown.
- Point macOS Dock entries at `~/Applications/Nix Trampolines`, not versioned Nix store app
  paths, so rebuilds do not split running and pinned app icons.
- Generate Oh My Posh shell initialization per shell via the Nix-resolved executable; its
  generated code contains version- and session-specific state and must not be persisted.

## Workflow

- Shared `~/.agents/workflows/*.md` files are the source of truth for `creview`, `ctest`,
  `cdocument`, `ccommit`, `cprep`, `creviewcommit`, and `csubmit`.
- `cdocument` is the standalone repo-memory stage and should run before `ccommit` so memory
  edits land in the intended commit group.
- `ccommit` should prefer `.agent/ccommit-groups.md`, build an ordered commit plan first, and
  split same-file hunks by functionality when needed.

## Nix and sandboxing

- Use `cnix` when repo work should stay Nix-scoped; prefer `flakify` over `nixify` unless the
  user explicitly wants legacy non-flake files.
- When `.envrc` uses `use flake`, `codex-sandbox` can preload `direnv export bash`; bind
  direnv config and state so allowlists survive inside the sandbox.
- Sandbox wrappers can bind persistent host Nix state and optionally expose SSH via
  `--ssh-key`.
