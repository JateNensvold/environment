# Agent Issues

This file contains only active recurring or actionable problems agents encounter
while operating in or modifying this repository. Move completed entries to
`.agent/issues-resolved.md` and findings that cannot be reproduced to
`.agent/issues-non-reproducible.md`. Occurrence counts represent affected agent
turns, not repeated copies of the same message within one command transcript.

## ISSUE-20261105-01 — Codex permissions mask the sandbox Nix Git cache read-only

- Status: Open
- Component: `codex-sandbox`, Codex permission profile, Nix cache
- First seen: 2026-11-05
- Last seen: 2026-11-05
- Occurrences: 6 agent turns
- Symptom: Building a Home Manager activation package fails while opening a lock under
  `/home/tosh/.cache/nix/gitv3/` because that cache is read-only in the sandbox.
- Impact: Agents can evaluate the flake but cannot realize Home Manager-generated files for
  exact integration testing when evaluation requires a Git input fetch or cache update.
- Evidence: `nix build
  .#homeConfigurations.tosh-home-default-x86_64-linux.activationPackage --no-link` reaches the
  cheatsheet `builtins.fetchGit` and fails opening its lock under
  `/home/tosh/.cache/nix/gitv3/` with `Read-only file system`.
- Observations:
  - Basic flake evaluation and `nix eval .#tests` work; the failure occurs only when lazy
    evaluation forces the Git-backed Home Manager file source.
  - The fetch is for the pinned public `cheat/cheatsheets` repository used at
    `.config/cheat/cheatsheets/community`, not for Home Manager itself.
  - The broker creates a writable OverlayFS upper layer for the Nix cache, but the final
    sandbox sees `/home/tosh/.cache/nix` and the other broker-exported overlays mounted
    read-only. A direct write probe fails before any network access is attempted.
  - The OverlayFS superblock remains read-write and names the expected `cache-upper` and work
    directories, while its client-visible VFS mount is read-only. `/tmp` and the workspace have
    matching read-only mounts followed by writable overmounts, consistent with Codex's active
    `workspace-with-git` filesystem policy.
  - Codex permission profiles configure filesystem and network access independently. The
    installed CLI accepts both an exact cache-path write rule and a standalone `:root = "write"`
    filesystem profile, so the filesystem restriction can be widened without disabling approval
    or network policy controls.
  - Even a read-only CLI query emits a warning when Codex cannot create its PATH aliases outside
    the configured writable roots, showing that the inner filesystem policy also masks other
    writable paths exposed by the outer Bubblewrap launcher.
  - A dedicated repo-managed `codex-sandbox` profile is mounted read-only over
    `$CODEX_HOME/codex-sandbox.config.toml` only inside Bubblewrap and selected by every normal
    Codex launch from the wrapper. Unit tests cover both the mount and CLI argument.
- Cause: Codex's command sandbox applies its own read-only filesystem layer inside
  `codex-sandbox` and grants write access only to the workspace roots configured in the active
  permission profile. The profile includes `.git`, but not the broker-managed Nix cache, so it
  masks the otherwise writable COW mount.
- Next step: Start a new `codex-sandbox` session and verify a Git fetch and Home Manager
  activation-package build before moving this issue to `.agent/issues-resolved.md`.

## ISSUE-20261105-02 — Sandbox Nix daemon lacks its required UID feature gate

- Status: Open
- Component: `codex-sandbox` Nix broker daemon
- First seen: 2026-11-05
- Last seen: 2026-11-05
- Occurrences: 1 agent turn
- Symptom: Realizing even a trivial text derivation fails with `experimental Nix feature
  'auto-allocate-uids' is disabled`.
- Impact: After client-side fetches are unblocked, the broker daemon may still be unable to build
  derivations needed for a Home Manager activation package.
- Evidence: `nix build --expr` consistently reaches the broker daemon and fails on the feature
  gate; enabling `auto-allocate-uids` on the client invocation does not change the daemon error.
- Observation: The broker deliberately clears `build-users-group` for its rootless daemon and
  enables the `local-overlay-store`, `daemon-trust-override`, and `read-only-local-store`
  experimental features, but does not enable `auto-allocate-uids`.
- Next step: Confirm whether the rootless daemon should enable `auto-allocate-uids` or explicitly
  disable automatic UID allocation, add the matching broker option and regression coverage, then
  realize a minimal derivation through a newly started broker.

## ISSUE-20261104-04 — Markdown lint conflicts with repository wrapping

- Status: Open
- Component: Markdown validation and formatting conventions
- First seen: 2026-11-04
- Last seen: 2026-11-04
- Occurrences: 2 agent turns
- Symptom: `markdownlint` reports MD013 failures throughout `AGENTS.md` and
  `.agent/` files even though their established formatting wraps prose near 95
  columns.
- Impact: The documentation validation stage cannot distinguish new line-length
  regressions from the repository baseline.
- Evidence: `markdownlint AGENTS.md .agent/*.md` reports MD013 failures at the
  tool's default 80-column limit, while the same command with
  `--config dotfiles/markdownlint/markdownlint.yaml` passes at the repository's
  configured 100-column limit.
- Next step: Make the repository's Markdown config discoverable by default or
  ensure every documentation validation entry point passes it explicitly.
