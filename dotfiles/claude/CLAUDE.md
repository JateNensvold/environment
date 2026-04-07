# Git commits

- Never add `Co-Authored-By` lines to commit messages

# Session workflow

- Never resume sessions — always start fresh
- On session start, read `<repo-root>/.claude/patterns.md` and `<repo-root>/.claude/changelog.md` to re-familiarize with the codebase and recent work. If either file is missing, create it at the repo root.

## `<repo-root>/.claude/patterns.md` — codebase knowledge

- Persistent knowledge: conventions, architectural decisions, gotchas, file layout, tooling quirks
- Update when you discover or establish a pattern worth preserving
- Prune entries that become outdated or wrong
- Keep concise and actionable, not narrative

## `<repo-root>/.claude/changelog.md` — work journal

- Running log of features added, bugs fixed, refactors, and other changes
- Prepend new entries (newest first) with a date and short summary
- Include enough detail that a fresh session can pick up where the last left off or understand recent context for related work
- Format: `## YYYY-MM-DD` header, then bullet points per change
