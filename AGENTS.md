# Repo Policy

Agents (Codex, Claude, etc.) should not manually install or upgrade any programs managed by
this repository. All upgrades must be completed by a human.

## codex-sandbox

`dotfiles/scripts/bash/default/codex-sandbox` is the rootless Bubblewrap launcher used to run
Codex CLI with a deliberately restricted host view. It exposes the selected workspace and
persistent Codex configuration, keeps the rest of the filesystem isolated, and preserves the
repo's Nix workflow through a shared copy-on-write Nix broker, direnv preloading, and
sandbox-local Nix state. It also supports optional temporary SSH-agent access and DNS
diagnostics. Its purpose is to let Codex work normally in a Nix-backed repository without
giving the session broad access to the host; changes must preserve that security boundary,
concurrent broker lifecycle, cleanup behavior, and all existing CLI modes.

## Agent issue record

- Before every response that returns control to the user, retrospectively review the work since
  the previous handoff for repository, tooling, sandbox, documentation, or workflow failures,
  errors, warnings, and recurring workarounds that the agent itself encountered while executing
  commands or attempting to interact with the setup or software it uses.
- Record only actionable findings arising from those agent operations in `.agent/issues.md`. Do
  not record a user-reported bug, requested enhancement, design concern, or task subject merely
  because the user raised it or the agent investigated or fixed it. Reproducing a user-raised
  problem while fulfilling that request does not make it an agent issue; it qualifies only if the
  agent encounters it independently as an operational failure during separate work.
- Do nothing when there is nothing to report; do not add an empty entry or mention that the review
  found no issues.
- Reuse an existing issue when the underlying symptom and likely remediation are the same.
  Increment its occurrence count once per affected agent turn, update `Last seen`, and add only
  new observations that improve diagnosis or resolution. Do not duplicate an issue merely
  because the same error appeared repeatedly in command output during one turn.
- Create a new issue when no existing entry describes it. Keep evidence concise, redact secrets
  and personal data, distinguish observations from hypotheses, and include the impact and a
  useful next step when known.
- Track systemic or unresolved friction only when it actually disrupts or degrades an agent
  operation. Do not turn requested work or a successfully completed improvement into an issue
  record, including a direct entry in `.agent/issues-resolved.md`. Do not log ordinary successful
  operation, expected negative test results, user input errors, or transient failures that were
  immediately corrected and offer no future diagnostic value.
- Keep `.agent/issues.md` limited to active issues. When an issue is resolved, move its final
  occurrence count, resolution date, cause, and concise resolution summary to
  `.agent/issues-resolved.md` so completed work does not distract active investigations.
- Never delay an urgent user-facing failure report merely to update the record. Make a best
  effort to update it first, then clearly report any inability to do so.

## Validation

- Run `nix eval .#tests` after editing Nix files.
