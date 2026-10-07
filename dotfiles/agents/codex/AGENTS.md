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
  back to `.claude/` only if needed, keep `patterns.md` to durable repo-specific notes with a
  small startup footprint, and merge same-day `changelog.md` notes into the existing date
  section instead of appending duplicate date blocks so those updates can be included in the
  intended local commit messages

## Copy-paste payloads

- When providing text intended for the user to copy into an unformatted text field or another
  agent session, output only the raw payload. Do not use Markdown markers, blockquotes, code
  fences, headings, or surrounding quotation marks.

## Displayed URLs

- Do not use Markdown link syntax for URLs shown to the user.
- Render every displayed URL with a space inside surrounding parentheses, for example
  `( https://github.com/NixOS/nix/issues/created_by/10991 )`. Never place a closing parenthesis
  or other punctuation directly after a URL; this keeps the clickable URL free of trailing
  punctuation in plain-text renderers.

## Nix workflows

- Use `cnix` when a repo already uses Nix (`flake.nix`, `shell.nix`, `default.nix`, or a
  Nix-backed `.envrc`) or the user asks to initialize or install Nix-based tooling
- Prefer the repo `flakify` command to bootstrap a new flake and `.envrc`; use `nixify` only
  when the user explicitly wants legacy non-flake Nix files
- In sandboxes, prefer direct invocation of repo-scoped tools when the wrapper has already
  exposed them on `PATH`, and fall back to `nix develop -c ...` only when a tool is not yet
  available; avoid ad hoc host installs and temporary `HOME` workarounds when the sandbox
  already exposes persistent Nix state
- `codex-sandbox` only preloads repo-scoped tools for Bash tool calls when the repo uses
  `direnv` with `use flake`; it delegates to `direnv export bash` and relies on the repo-local
  `.direnv/` cache instead of maintaining a separate Codex-managed env cache, so newly added
  flake tools should become directly invokable on the next Bash command once they resolve on
  `PATH`
- If `nix-command` or `flakes` are disabled, add
  `--extra-experimental-features 'nix-command flakes'` to the `nix` invocation instead of
  changing the repo
- Every tool added to a flake dev shell must include a short inline comment explaining why the
  repo needs it
