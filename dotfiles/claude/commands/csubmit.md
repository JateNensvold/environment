Full pre-submission pipeline: review, test, commit metadata, and push. Run these steps in order:

1. **Review** — Run /creview. If any critical issues are found, fix them before proceeding. Amend fixes into the appropriate commits.

2. **Test** — Run /ctest. If tests or lint fail, fix the issues, amend into the appropriate commits, and re-run until clean.

3. **Commit metadata** — Run /ccommit. Ensure every unpushed commit on this branch has a complete, accurate commit message.

4. **Push** — Push the branch to origin with `git push -u origin HEAD`. Ask the user for confirmation before pushing.
