---
name: cnix
description: Create and use Nix flake dev shells when a repo already uses Nix or needs Nix setup.
---

# Cnix

Use this skill when the repository already uses Nix, when the user asks to initialize Nix for
the repo, or when the requested tooling should stay repo-scoped instead of being installed on
the host.

## Workflow

1. Detect the existing Nix entrypoints first.
Look for `flake.nix`, `flake.lock`, `shell.nix`, `default.nix`, or `.envrc` entries such as
`use flake` or `use nix`.
If those files already exist, extend the existing Nix workflow instead of introducing a second
tooling path.

2. Prefer flake-based development for new setup.
Use the repo `flakify` command to initialize a new `flake.nix` plus `.envrc`.
Use `nixify` only if the user explicitly asks for legacy non-flake Nix setup.

3. Prefer repo-scoped tools through Nix.
When the repo already uses Nix, run formatter, lint, and test tools through `nix develop`
unless those tools are already on `PATH` inside the current environment.
Do not install those tools globally just to satisfy a single repo task.

4. Keep sandbox behavior aligned with the wrapper.
Inside Codex or Claude sandboxes, do not switch to an ad hoc temporary `HOME` just to make
Nix work unless a human explicitly asks for that workaround.
Prefer the sandbox's persistent Nix state, and if the command fails because `nix-command` or
`flakes` are disabled, rerun it as:
`nix --extra-experimental-features 'nix-command flakes' develop ...`
When running inside `codex-sandbox`, expect Bash tool calls to delegate to
`direnv export bash` and reuse the repo-local `.direnv/` cache when the repo uses `direnv`
with `use flake`.

5. Document every dev-shell tool addition.
Each package added to a flake dev shell must include a short inline comment explaining why the
repo needs that tool.
Keep the comment adjacent to the package entry.

6. Preserve repo-local intent.
If a flake already exists, add tools to the existing `devShell` or `devShells.default`
definition instead of creating parallel shells unless the repo already names multiple shells.
When adding tools, keep comments concise and specific to the repo task, such as
`# shellcheck: lint shell scripts in this repo.`
