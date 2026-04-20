# Submission workflows

- `cprep` is the local pre-submit dry run:
  `creview` -> `ctest` -> `ccommit` -> memory update -> stop before push
- `csubmit` is the full pre-submit pipeline:
  `creview` -> `ctest` -> `ccommit` -> memory update -> confirm push readiness -> push after
  approval
- Shared markdown workflows in `~/.agents/workflows` are the source of truth for `creview`,
  `ctest`, `ccommit`, `cprep`, and `csubmit`
- `cprep` and `csubmit` orchestrate stage order, but control should return to the agent
  between stages so each stage can use full repo context
- The post-`ccommit` memory-update stage should prefer `.agent/patterns.md` and
  `.agent/changelog.md`, fall back to `.claude/` only if needed, prune stale
  `patterns.md` entries, and merge same-day `changelog.md` notes into the existing date
  section instead of appending duplicate date blocks
