# Submission workflows

- `cdocument` is the standalone repo-memory documentation stage:
  refresh `.agent/` or `.claude/` memory files before commit preparation
- `cprep` is the local pre-submit dry run:
  `creview` -> `ctest` -> `cdocument` -> `ccommit` -> stop before push
- `creviewcommit` is the quick review-and-commit workflow:
  `creview` -> `ccommit` -> stop after local commit preparation
- `csubmit` is the full pre-submit pipeline:
  `creview` -> `ctest` -> `cdocument` -> `ccommit` -> confirm push readiness -> push after
  approval
- Shared markdown workflows in `~/.agents/workflows` are the source of truth for `creview`,
  `ctest`, `cdocument`, `ccommit`, `cprep`, `creviewcommit`, and `csubmit`
- `cprep`, `creviewcommit`, and `csubmit` orchestrate stage order, but control should return
  to the agent between stages so each stage can use full repo context
- The `cdocument` stage should prefer `.agent/patterns.md` and `.agent/changelog.md`, fall
  back to `.claude/` only if needed, prune stale `patterns.md` entries, and merge same-day
  `changelog.md` notes into the existing date section instead of appending duplicate date
  blocks so those updates can be included in the intended local commit messages

## Nix workflows

- Use `cnix` when a repo already uses Nix (`flake.nix`, `shell.nix`, `default.nix`, or a
  Nix-backed `.envrc`) or the user asks to initialize or install Nix-based tooling
- Prefer the repo `flakify` command to bootstrap a new flake and `.envrc`; use `nixify` only
  when the user explicitly wants legacy non-flake Nix files
- In sandboxes, prefer repo-scoped tooling through `nix develop` instead of ad hoc host
  installs, and avoid temporary `HOME` workarounds when the sandbox already exposes persistent
  Nix state
- `codex-sandbox` only preloads repo-scoped tools for Bash tool calls when the repo uses
  `direnv` with `use flake`; it delegates to `direnv export bash` and relies on the repo-local
  `.direnv/` cache instead of maintaining a separate Codex-managed env cache
- If `nix-command` or `flakes` are disabled, add
  `--extra-experimental-features 'nix-command flakes'` to the `nix` invocation instead of
  changing the repo
- Every tool added to a flake dev shell must include a short inline comment explaining why the
  repo needs it
