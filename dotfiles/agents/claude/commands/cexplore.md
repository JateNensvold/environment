Perform a thorough code review of an existing area of the codebase.

**Target**: If a path argument is provided (`$ARGUMENTS`), review that path. Otherwise, review from the repository root (determined by `git rev-parse --show-toplevel`).

## Process

1. **Orientation** — Check for README, CONTRIBUTING, CLAUDE.md, or similar documentation files in the target directory and parent directories to understand conventions, architecture, and development workflows.

2. **Structure survey** — Map out the directory structure, key modules, entry points, and how the code is organized. Identify the build system (package.json, Cargo.toml, pyproject.toml, Makefile, CMakeLists.txt, etc.) and test structure.

3. **Deep review** — Use subagents (via the Agent tool) in parallel to review different modules or subsystems independently to avoid context pollution. Each subagent should:
   - Read the source files in its assigned area
   - Check for bugs, security issues, dead code, and anti-patterns
   - Evaluate error handling, edge cases, and test coverage
   - Note any deviations from project conventions found in documentation or linter configs (.eslintrc, .editorconfig, rustfmt.toml, etc.)
   - Return findings with file paths and line numbers

4. **Cross-cutting concerns** — In the main context, after subagents complete, evaluate:
   - Dependency structure and coupling between modules
   - Consistency of patterns across the codebase (naming, error handling, logging)
   - Missing or inadequate test coverage
   - Documentation gaps
   - Potential performance issues or scalability concerns
   - Dependency health (outdated packages, known vulnerabilities, unnecessary dependencies)

5. **Report** — Synthesize all findings into a structured report:
   - **Architecture overview**: Brief summary of how the code is organized
   - **Critical issues**: Bugs, security vulnerabilities, data integrity risks
   - **Warnings**: Anti-patterns, missing error handling, test gaps
   - **Notes**: Style inconsistencies, documentation suggestions, potential improvements
   - **Strengths**: What the codebase does well — patterns worth preserving or replicating
