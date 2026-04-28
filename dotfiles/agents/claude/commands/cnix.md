# Cnix

Use this command when the repository already uses Nix, when the user asks to initialize Nix
for the repo, or when the requested tooling should stay repo-scoped instead of being installed
on the host.

1. Detect existing Nix entrypoints first.
Check for `flake.nix`, `flake.lock`, `shell.nix`, `default.nix`, or `.envrc` entries such as
`use flake` or `use nix`.
Extend the existing Nix workflow instead of introducing a second tooling path.

2. Prefer flake-based setup for new work.
Use the repo `flakify` command to initialize a new `flake.nix` plus `.envrc`.
Use `nixify` only if the user explicitly asks for legacy non-flake Nix files.

3. Prefer direct invocation for repo-local Nix tools.
When the repo already uses Nix, invoke formatter, lint, and test tools directly when they are
already on `PATH` inside the current environment.
In `codex-sandbox`, Bash tool calls should pick up flake-provided tools through the wrapper's
`direnv export bash` preload, including tools added mid-session after the next command run.
After changing a flake, verify availability with `command -v <tool>` when needed.
Use `nix develop -c ...` only as a fallback when the repo-scoped tool is not yet available on
`PATH`.
Do not install those tools globally just to satisfy a single repo task.

4. Match sandbox behavior.
Inside sandboxes, do not switch to an ad hoc temporary `HOME` unless a human explicitly asks
for that workaround.
Prefer the sandbox's persistent Nix state, and if `nix-command` or `flakes` are disabled,
rerun the command as:
`nix --extra-experimental-features 'nix-command flakes' ...`
In `codex-sandbox`, expect Bash tool calls to delegate to `direnv export bash` and reuse the
repo-local `.direnv/` cache when the repo uses `direnv` with `use flake`.

5. Comment every dev-shell tool.
Each package added to a flake dev shell must include a short inline comment explaining why the
repo needs that tool, with the comment adjacent to the package entry.
