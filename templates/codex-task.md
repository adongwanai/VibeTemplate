# Codex Task

## Objective

Describe the concrete outcome for this task in one or two sentences.

## Files

- List the files this worker is expected to touch.
- Call out any file that must remain read-only.

## Constraints

- Never write on `main`.
- Work only inside the assigned worktree.
- Keep changes inside the declared write domain.
- Report files changed and validation run.

## Acceptance Tests

- Local verification commands
- Required behavioral outcomes
- Any wave-level prerequisites that must remain intact

## Branch Rules

- Phase branch must already exist.
- Worker branch must be based on the phase branch.
- Do not merge back directly from the worker branch.

## Retry Context

- Include prior failure output here when this is a repair attempt.
- Note any assumptions that were locked by planning.
