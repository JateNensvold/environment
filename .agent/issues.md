# Agent Issues

This file contains only active recurring or actionable problems agents encounter
while operating in or modifying this repository. Move completed entries to
`.agent/issues-resolved.md`. Occurrence counts represent affected agent turns,
not repeated copies of the same message within one command transcript.

## ISSUE-20261104-04 — Markdown lint conflicts with repository wrapping

- Status: Open
- Component: Markdown validation and formatting conventions
- First seen: 2026-11-04
- Last seen: 2026-11-04
- Occurrences: 1 agent turn
- Symptom: `markdownlint` reports MD013 failures throughout `AGENTS.md` and
  `.agent/` files even though their established formatting wraps prose near 95
  columns.
- Impact: The documentation validation stage cannot distinguish new line-length
  regressions from the repository baseline.
- Next step: Either configure MD013 to match the repository's wrapping width or
  reformat the affected documentation and record 80 columns as the convention.
