# Ccommit Groups

Use these defaults when the branch has pending changes and no narrower grouping guidance
overrides them.

## Split By Functional Area

- Keep agent workflow, command, skill, and repo-memory changes separate from editor, runtime,
  or tooling behavior changes when each area can be reviewed on its own.
- Keep Home Manager or install-wiring changes separate from downstream behavior changes when
  the behavior change still makes sense as its own reviewable unit.
- When one functional area enables another, order the commits so the prerequisite or shared
  infrastructure lands first and the consumer or activation change follows it.
- Do not collapse independent groups just because they touch the same file; split by hunk when
  the resulting commits still read cleanly.
- Keep validation fallout with the functional area that caused it, not with whichever commit is
  currently `HEAD`.

## Repo Examples

- If a patch updates `.agent/` or `dotfiles/agents/` and also updates `dotfiles/nvim/`,
  prefer separate commits unless one side is only mechanical fallout from the other.
- A workflow or agent-fix commit and a Neovim or plugin-fix commit should usually be separate
  commits.
- If a patch changes shared workflow or skill definitions and also changes Home Manager wiring,
  prefer one commit for the behavior or workflow definition and a later commit for the install
  or activation wiring when both can be reviewed independently.
