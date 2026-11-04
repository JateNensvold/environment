# Resolved Agent Issues

This archive retains concise resolution records so regressions can be
recognized without distracting investigations in `.agent/issues.md`.

## ISSUE-20261104-03 — Hook activation retained superseded entries

- Status: Resolved
- Component: Home Manager activation, Codex hook configuration
- First seen: 2026-11-04
- Last seen: 2026-11-04
- Resolved: 2026-11-04
- Occurrences: 2 agent turns
- Cause: `merge-codex-hooks` deduplicated entries only by full JSON equality,
  so changing the managed matcher left the older entry installed.
- Resolution: The merge now identifies managed hooks by event and nested
  command, removes superseded entries, preserves unrelated hooks, and remains
  idempotent. After Home Manager reload, the live configuration contains one
  SessionStart entry and a resume invocation returns valid injected context.

## ISSUE-20261104-02 — Sandbox environment dropped required tools

- Status: Resolved
- Component: `codex-sandbox`, direnv preload, `PATH` construction
- First seen: 2026-11-04
- Last seen: 2026-11-04
- Resolved: 2026-11-04
- Occurrences: 3 agent turns
- Cause: The wrapper did not include Python and Git among its baseline hook
  dependencies, and direnv could replace the safe sandbox path with a
  host-derived path containing unavailable entries.
- Resolution: The wrapper now supplies Python and Git in its baseline and
  preserves that explicit path across direnv preload. After restart, Python,
  Git, ripgrep, direnv, and the flake probe all resolve from Nix paths; no
  unmounted host path entries remain, and SessionStart returns valid output.

## ISSUE-20261104-01 — Sandbox direnv could not refresh the flake

- Status: Resolved
- Component: `codex-sandbox`, direnv preload, Nix store
- First seen: 2026-11-04
- Last seen: 2026-11-04
- Resolved: 2026-11-04
- Occurrences: 8 agent turns
- Cause: The private rootless daemon inherited automatic store optimization and
  tried to hard-link a host-owned lower-store `.links` object whose UID was
  unmapped inside the user namespace.
- Resolution: `codex-sandbox-broker` now starts its daemon with
  `--option auto-optimise-store false`. After all leases ended, a fresh broker
  loaded the cached direnv dev shell without fallback, created
  `.direnv/flake-profile`, and exposed the flake's `hello` probe on `PATH`.
