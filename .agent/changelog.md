# Changelog

## 2026-04-20

- Merged the stray `.agents/` directory into `.agent/`, moving the repo-local settings file to
  `.agent/settings.local.json` and removing the duplicate directory
- Removed the Codex `Stop` hook after confirming it runs at the end of each prompt rather than
  once per session
- Deleted the unused `dotfiles/codex/hooks/stop_update_context.py` path and removed its Home
  Manager install entry
- Updated the Codex hook merge logic to deduplicate array entries so repeated `reload` runs do
  not append duplicate hook definitions
- Fixed the `merge-codex-config` Home Manager activation snippet so its Python heredoc
  terminator stays at column 0 and the generated shell script parses correctly
- Reformatted the new agent workflow docs and `.agent/` memory files to satisfy the repo's
  markdownlint rules
- Validated the updated docs, hooks, scripts, Lua files, JSON files, and Nix modules during a
  local `cprep` run
- Clarified in the `ccommit`, `cprep`, and `csubmit` instructions that local changes should be
  committed before the workflow stops or asks to push
- Replaced the script-backed workflow plan with shared markdown workflows under
  `~/.agents/workflows`, which now act as the source of truth for both Codex and Claude
- Recorded in `.agent/patterns.md` that `ccommit` should prefer repo-local
  `.agent/ccommit-groups.md` guidance when the repo provides it
- Tightened the shared `ccommit` workflow and `ctest` validation notes so multiple functional
  areas now default to multiple commits, including cases where all current changes are still
  uncommitted

## 2026-04-19

- Attempted a local `cprep` run but the session could not execute any shell commands because
  the configured `PreToolUse` hook referenced missing `~/.codex/hooks/pre_tool_use_guard.py`
- Recorded the missing-hook failure mode in `.agent/patterns.md` so future sessions can
  identify the blocker quickly
- Trimmed stop-hook memory updates to curated same-day notes instead of appending another
  duplicate `2026-04-19` block
- Investigated broken Codex hooks and confirmed the repo now contains
  `dotfiles/codex/hooks.json` plus the missing hook scripts under `dotfiles/codex/hooks/`
- Confirmed Home Manager installs live Codex hook files into `~/.codex/hooks/` and merges
  `dotfiles/codex/hooks.json` into `~/.codex/hooks.json`
- Identified the likely failure mode as a partial Home Manager activation:
  `~/.codex/hooks.json` was active while `~/.codex/hooks/*.py` were missing, which blocks
  agent shell commands before execution
- Recorded repo-specific agent policy from local `AGENTS.md`: agents should not run program
  installs or upgrades managed by this repo, including `home-manager` and `nix` rebuilds,
  unless explicitly directed by a human
- Confirmed the startup-context split for this Codex setup: platform system and developer
  instructions are injected automatically, but repo `AGENTS.md` is not; the custom startup
  path injects `.agent/` or `.claude/` memory instead
- Clarified current hook behavior: `PreToolUse` with matcher `Bash` fires for every shell-tool
  call, `Stop` is per-turn rather than per-session, and `Bash` refers to the tool or event
  name rather than the login shell
- Updated the Codex git guard to no-op for non-`git` commands and removed the visible
  `statusMessage` from the `PreToolUse` hook so unrelated shell commands no longer show policy
  noise
- Verified from the installed Codex 0.118.0 hook schema strings that the current hook surface
  includes `SessionStart`, `UserPromptSubmit`, `PreToolUse`, `PostToolUse`, and `Stop`, but
  not a true `SessionEnd` hook
- Added `cprep` as a dry-run companion to `csubmit`
- Added the Claude command at `dotfiles/claude/commands/cprep.md`
- Added the Codex skill at `dotfiles/codex/skills/cprep/`
- Updated the Home Manager file map so `cprep` is installed with the other Codex skills
- Recorded that `.agent/` is the canonical repo memory location and that stop-hook memory
  updates should stay deduplicated
- Updated both `cprep` and `csubmit` so they refresh repo memory files immediately after
  `ccommit`
- Moved the `cprep` and `csubmit` workflow notes out of repo memory into a new global Codex
  file at `dotfiles/codex/AGENTS.md`
- Added Home Manager support for a global `~/.codex/AGENTS.md` and updated the Codex
  session-start context to include it
- Recorded the convention that cross-repo Codex workflow policy belongs in global `AGENTS.md`,
  while `.agent/` stays repo-local

## 2026-04-07

- Fixed tmux `prefix+i` and `prefix+I` keybinds for `claude-sandbox`: they now run through
  `$SHELL -lic` so the login shell sets up `PATH` and interactive mode loads aliases for the
  work-device fallback
- Moved the `claude-sandbox = "claude"` alias from shared `zsh.nix` to per-host work configs
  so the shared alias no longer masks the real sandboxed script on the home host
- Moved the `claude-sandbox` script from `dotfiles/scripts/bash/home/` to
  `dotfiles/scripts/bash/default/` so it lives in `~/.local/bin/`, which stays on `PATH`
  without relying on `home.sessionPath` inside tmux
- Simplified `nix/hosts/home/home.nix` by removing the `home-bin` symlink and `sessionPath`;
  only the `cs` alias remains
- Removed old work host configurations and cleaned up the related `flake.nix` entries
- Added the global `~/.claude/CLAUDE.md` dotfile via Home Manager as the cross-repo Claude
  instructions file, separate from any project-specific `.claude/` config
- Unbound the default tmux `prefix+p` previous-window binding so only `prefix+n` and
  `prefix+m` navigate windows
- Added tmux `prefix+C-t` for `switch-client -l`, mirroring the existing `C-t` last-window
  binding
- Added the `se` alias for searching environment variables with `fzf`
- Set up `.claude/patterns.md` and `.claude/changelog.md` for cross-session context
  persistence
