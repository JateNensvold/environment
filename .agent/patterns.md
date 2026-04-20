# Patterns & Conventions

## Agent memory

- `.agent/` is the canonical repo memory location; `.claude/` is a legacy fallback
- Treat memory files as curated notes, not append-only logs; merge same-day updates into the
  existing date section and prune duplicate stop-hook noise

## Activation gotcha

- Claude commands and Codex skills in this repo are installed from flake-managed files, so new
  command or skill definitions in the repo are not live until a human runs the normal
  `reload`
- Global Codex instructions are managed in `dotfiles/codex/AGENTS.md` and installed to
  `~/.codex/AGENTS.md`, parallel to the global Claude file at `dotfiles/claude/CLAUDE.md`
- Put cross-repo Codex workflow policy such as `cprep` and `csubmit` guidance in the global
  `dotfiles/codex/AGENTS.md`; keep `.agent/` focused on repo-local memory
- Local Codex command execution depends on the configured `PreToolUse` hook path existing; if
  `~/.codex/hooks/pre_tool_use_guard.py` is missing, even basic repo inspection commands fail
  before execution
- Shell heredoc terminators inside `home.activation` snippets must start at column 0 in the
  generated shell script, or Home Manager activation will fail to parse them

## Codex hooks

- Do not use the Codex `Stop` hook for end-of-session memory updates in this repo; it fires at
  the end of each prompt, so the repo now relies on explicit memory updates instead

## Documentation

- Repo Markdown files are checked against `dotfiles/markdownlint/markdownlint.yaml`; keep
  headings spaced correctly and wrap prose to 100 columns
- `cprep` and `csubmit` should leave the branch with a real local commit stack; if the branch
  only has staged or working-tree changes, `ccommit` should create the commit before
  summarizing readiness
- The shared `~/.agents/workflows/*.md` files are the source of truth for `creview`, `ctest`,
  `ccommit`, `cprep`, and `csubmit`; the Codex and Claude command text should read those
  workflow files first instead of encoding the workflow separately
- In `cprep` and `csubmit`, update `.agent/patterns.md` and `.agent/changelog.md` before
  running `ccommit` so those memory-file edits can land in the intended commit group and be
  reflected in the commit message
- Sandbox wrappers that launch Codex or Claude should expose `~/.agents` read-only so the
  shared workflow markdown remains available inside sandboxed sessions
- `cprep` and `csubmit` enforce stage order, but each stage should return control to the agent
  for context-heavy reasoning before the next stage runs

## Commit grouping

- `ccommit` should prefer repo-local grouping guidance from `.agent/ccommit-groups.md` when the
  repo provides it, and otherwise split commits by actual functionality rather than path
  prefixes alone
- When pending work spans multiple functional areas, `ccommit` should create multiple commits
  by default rather than treating a clean branch state as a reason to collapse everything into
  one commit
