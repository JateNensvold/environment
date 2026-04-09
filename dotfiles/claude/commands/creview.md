Review the pending code changes about to be submitted. Run `git diff` to see uncommitted changes and `git log --oneline @{upstream}..HEAD` to understand the commit stack on the current branch. For each commit, run `git show <hash>` to review its full diff.

Check for:
- Bugs, logic errors, and edge cases
- Security issues (injection, XSS, OWASP top 10)
- Missing error handling
- Adherence to codebase conventions (check CLAUDE.md files in relevant directories)
- Dead code or unnecessary complexity introduced

Report findings concisely with file paths and line numbers. Categorize as critical (must fix before submit), warning (should fix), or note (consider changing).
