# Submission workflows

- `cprep` is the local pre-submit dry run:
  `creview` -> `ctest` -> memory update -> `ccommit` -> stop before push
- `creviewcommit` is the quick review-and-commit workflow:
  `creview` -> `ccommit` -> stop after local commit preparation
- `csubmit` is the full pre-submit pipeline:
  `creview` -> `ctest` -> memory update -> `ccommit` -> confirm push readiness -> push after
  approval
- Shared markdown workflows in `~/.agents/workflows` are the source of truth for `creview`,
  `ctest`, `ccommit`, `cprep`, `creviewcommit`, and `csubmit`
- `cprep`, `creviewcommit`, and `csubmit` orchestrate stage order, but control should return
  to the agent between stages so each stage can use full repo context
- The pre-`ccommit` memory-update stage should prefer `.agent/patterns.md` and
  `.agent/changelog.md`, fall back to `.claude/` only if needed, prune stale
  `patterns.md` entries, and merge same-day `changelog.md` notes into the existing date
  section instead of appending duplicate date blocks so those updates can be included in the
  intended local commit messages
