# Resolved Agent Issues

This archive retains concise resolution records so regressions can be
recognized without distracting investigations in `.agent/issues.md`.

## ISSUE-20261105-02 — Sandbox Nix daemon lacked its required UID feature gate

- Status: Resolved
- Component: `codex-sandbox` Nix broker daemon
- First seen: 2026-11-05
- Last seen: 2026-11-05
- Resolved: 2026-11-05
- Occurrences: 5 agent turns
- Cause: The broker inherited `auto-allocate-uids = true` from ambient Nix configuration but did
  not enable that experimental feature; automatic UID allocation was also incompatible with its
  single-ID rootless user namespace.
- Resolution: The broker now explicitly enables the feature gate while forcing
  `auto-allocate-uids = false`. After a full broker restart, a unique derivation advanced past the
  old feature error. A separate nested build-sandbox failure is tracked as ISSUE-20261105-03.

## ISSUE-20261105-01 — Codex permissions masked the sandbox Nix Git cache read-only

- Status: Resolved
- Component: `codex-sandbox`, Codex permission profile, Nix cache
- First seen: 2026-11-05
- Last seen: 2026-11-05
- Resolved: 2026-11-05
- Occurrences: 6 agent turns
- Cause: Codex's inner command sandbox granted writes only to workspace roots, masking the
  writable Nix cache OverlayFS exposed by the outer Bubblewrap sandbox.
- Resolution: The wrapper now mounts a repo-managed `codex-sandbox` profile read-only and selects
  it on every launch; its `:root = "write"` rule delegates the filesystem boundary to Bubblewrap.
  In a fresh session, the Git cache was mounted read-write, a direct write probe succeeded, all
  15 launcher tests and 12 Nix tests passed, and the formerly failing Home Manager build advanced
  past Git fetching to the separately tracked daemon UID feature gate.

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
