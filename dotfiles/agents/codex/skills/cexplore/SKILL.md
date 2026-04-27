---
name: cexplore
description: Deep review of a codebase area.
---

# Cexplore

Review an existing area of the codebase in depth and report the most important findings first.

## Workflow

1. Orient on the target area.
If the user names a path, focus there. Otherwise start at the repository root.
Read nearby `README`, `CONTRIBUTING`, `CLAUDE.md`, `AGENTS.md`, and linter or formatter
config files to understand project conventions.

2. Map the structure before judging it.
Identify entry points, important modules, the build system, and the test layout.
Call out the boundaries between subsystems and any obvious dependency hotspots.

3. Review for behavior and maintainability issues.
Prioritize bugs, security issues, dead code, weak error handling, missing edge cases, and
inadequate tests.
Check whether the implementation follows local patterns for naming, logging, validation, and data flow.

4. Evaluate cross-cutting concerns after reading the concrete files.
Look for coupling problems, duplicated patterns, documentation gaps, and performance or
scalability risks.

5. Report findings in descending severity.
Lead with actionable issues and include file paths with line numbers when possible.
Keep architecture notes brief and secondary to the findings.
