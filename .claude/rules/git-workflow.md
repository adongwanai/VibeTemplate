# Git Workflow

## Core Rule

Implementation does not run on `main`.

If the current branch is `main` or `master`, stop and create or switch to a feature or phase branch before running Codex execution.

## Branching Model

1. Planning and design can happen anywhere.
2. Before implementation, create or switch to a phase branch.
3. Codex workers use isolated worktrees rooted under `runtime/workers/`.
4. Reconciliation lands on the phase branch first.
5. Merge to `main` stays a deliberate human action.

## Commit Rules

- Commit often.
- Prefer focused commits over giant snapshots.
- Use `--no-verify` only for worker or orchestration commits that are later covered by wave-level validation.
- Run validation before declaring the phase ready for verification.

## Review Flow

1. Plan with GSD and Superpowers.
2. Execute on a non-`main` branch through the Codex runtime.
3. Reconcile and validate the wave.
4. Run `gsd:verify-work`.
5. Finish the branch after verification passes.
