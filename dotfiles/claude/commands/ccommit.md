Prepare local commits with complete metadata, ready for submission.

1. Check for uncommitted changes with `git status`. If there are pending changes that should be committed, create a new commit with `git commit`.

2. Run `git log --format='%h %s' @{upstream}..HEAD` to list all unpushed commits on the current branch.

3. For each unpushed commit on the branch:
   a. Run `git show <hash>` to review the full diff content.
   b. Evaluate the existing commit message against the actual code changes.
   c. If the commit message is incomplete, vague, or inaccurate: rewrite it with a concise title (under 70 chars), a body explaining what changed and why, and relevant file/function references. Use `git commit --amend` for the HEAD commit. For non-HEAD commits, detach at the target commit with `git checkout <hash>`, amend it, then run `git rebase --onto HEAD <hash> <branch>` to replay subsequent commits on top.

4. Always split unrelated changes into separate commits. If a single commit contains logically distinct changes, ask the user before splitting.

5. After all commits are clean, report a summary of the final commit stack.
