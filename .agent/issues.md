# Agent Issues

This file is the repository-local record of recurring or actionable problems agents encounter
while operating in or modifying this repository. Agents update it retrospectively before
returning control to the user. Occurrence counts represent affected agent turns, not repeated
copies of the same message within one command transcript.

## Open

### ISSUE-20261104-01 — Sandbox direnv cannot refresh the flake environment

- Status: Open
- Component: `codex-sandbox`, direnv preload, Nix store
- First seen: 2026-11-04
- Last seen: 2026-11-04
- Occurrences: 3 agent turns
- Symptom: Before shell commands run, `direnv` attempts `use flake`, Nix fails while creating a
  hard link under `/nix/store/.links`, and direnv falls back to a previous environment.
- Impact: Repository-scoped tools are not reliably exposed on `PATH`; in the observed fallback,
  basic tools such as `sed`, `cat`, and `rg` had to be invoked through explicit Nix-store paths.
- Evidence: Nix reports `filesystem error: cannot create hard link: Operation not permitted`
  between a path under `/nix/store/.links` and a path under `/nix/store/.tmp-link-*`.
- Observations:
  - The failure occurs during the automatic environment preload before the requested shell
    command, rather than in the command itself.
  - After a local commit changed the Git revision, Nix also failed to update
    `~/.cache/nix/fetcher-cache-v3.sqlite` because the database was read-only.
  - The fallback permits commands to continue, which makes the problem easy to overlook while
    producing repeated warning output and inconsistent tool availability.
- Next step: Reproduce the flake refresh inside `codex-sandbox`, inspect the shared local-overlay
  Nix store's hard-link behavior, and ensure the fallback environment retains the repository's
  required command-line tools.

## Resolved

Move resolved entries here rather than deleting them. Retain their final occurrence count,
resolution date, and a short description of the fix so regressions can be recognized.
