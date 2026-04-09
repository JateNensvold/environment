Run formatting, linting, and tests for the current changes before submission.

1. Identify changed files with `git diff --name-only @{upstream}..HEAD` and `git diff --name-only` (unstaged).

2. Auto-detect the project toolchain by checking for config files at the repo root:
   - `package.json` → use `npm`/`yarn`/`pnpm` (check lockfiles to determine which)
   - `Cargo.toml` → use `cargo fmt`, `cargo clippy`, `cargo test`
   - `pyproject.toml` or `setup.py` → use `ruff`/`black` for formatting, `ruff`/`flake8` for linting, `pytest` for tests
   - `go.mod` → use `gofmt`, `go vet`, `go test ./...`
   - `Makefile` with `lint`/`test`/`fmt` targets → use those
   - If multiple apply (e.g. monorepo), run each for its relevant files

3. Run the formatter. If it made changes, stage and amend them into the current commit with `git add -u && git commit --amend --no-edit`.

4. Run the linter with auto-fix if available. If it made changes, stage and amend.

5. Run the test suite. Prefer running only tests relevant to changed files if the test framework supports it, otherwise run the full suite.

6. Report results: which tests passed, which failed, and any remaining lint warnings.
