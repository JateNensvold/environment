# Agent Issues

This file contains only active recurring or actionable problems agents encounter
while operating in or modifying this repository. Move completed entries to
`.agent/issues-resolved.md` and findings that cannot be reproduced to
`.agent/issues-non-reproducible.md`. Occurrence counts represent affected agent
turns, not repeated copies of the same message within one command transcript.

## ISSUE-20261105-03 — Rootless broker cannot start Nix's nested build sandbox

- Status: Open
- Component: `codex-sandbox` Nix broker daemon
- First seen: 2026-11-05
- Last seen: 2026-11-20
- Occurrences: 7 agent turns
- Symptom: After the UID feature-gate fix, an uncached derivation now fails with `unable to start
  build process` while Nix is setting up its chroot environment.
- Impact: Default local builds still fail even though substitutions and builds explicitly run with
  `sandbox = false` work.
- Evidence: A fresh broker no longer reports the `auto-allocate-uids` error. The same unique
  derivation fails with the default inherited sandbox policy and succeeds with either
  `--option sandbox false` or, while retaining the sandbox, only
  `--option require-drop-supplementary-groups false`.
- Cause: `unshare --user --map-root-user` seals the outer namespace with `setgroups` denied. Nix
  normally calls `setgroups(0, 0)` before creating its nested build namespaces and treats the
  resulting `EPERM` as fatal because the daemon appears to be root.
- Observation: The October 7 shared-broker change introduced this daemon topology after the old
  sandbox had exposed only a read-only store. Its commit record validated concurrent startup but
  explicitly left full mutation testing pending, so cached paths and substitutions could work
  without ever exercising this local-builder startup path.
- The first non-root mapping attempt used a two-phase handshake but tried to clear supplementary
  groups before installing a GID map. Linux prohibits `setgroups()` until that map exists, so the
  broker failed immediately with `setpriv: setgroups failed: Operation not permitted`.
- A self-only delegated GID map also leaves `setgroups` denied: `newgidmap` requires at least one
  authorized subordinate-GID mapping before it can preserve `setgroups` for the new namespace.
  The launcher now maps one `/etc/subgid` allocation in addition to the identity GID, then runs
  `setpriv --clear-groups`. Runtime guards continue to reject root or retained groups.
- Next step: Run `dotfiles/scripts/bash/tests/codex-sandbox-nix-integration-test` from the host,
  end all broker leases, and verify an uncached derivation in a fresh sandbox. Archive the issue
  only after both builds pass without client overrides.

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
