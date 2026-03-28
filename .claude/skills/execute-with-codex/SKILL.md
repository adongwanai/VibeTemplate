---
name: execute-with-codex
description: Execute a planned GSD phase through the Codex-first runtime. Use when `.planning/phases/` already contains a planned phase and you want Codex workers to do implementation work with retries, wave validation, and failure packaging.
---

# Execute With Codex

This skill runs the default Codex bridge layer on this branch.

## Goal

Hand planned phase work to a local `codex exec` runner while keeping GSD responsible for project planning and verification.

## Preconditions

- `.planning/STATE.md` exists
- `.planning/phases/<phase>/` exists with runnable plan files
- Current branch is not `main`
- Runtime scaffold exists under `scripts/`, `queue/`, and `runtime/`

## Default Execution Model

- Up to 4 Codex worker slots
- Phase-aware execution
- Manifest/checkpoint output under `runtime/checkpoints/`
- Failure packages under `queue/failed/`
- Wave-level reconciliation through `scripts/reconcile-wave.sh`

## How To Run

1. Read `.planning/STATE.md`
2. Confirm the target phase is planned
3. Confirm the current branch is not `main`
4. Run:

```bash
bash scripts/execute-codex-phase.sh <phase-id>
```

5. Inspect:

```bash
find runtime/checkpoints -maxdepth 1 -type f | sort
find queue/failed -maxdepth 1 -type f | sort
```

6. If wave validation is green, continue toward:

```text
/gsd:verify-work <phase-id>
```

## Backup Path

Use `/gsd:execute-phase` instead when you explicitly want GSD-native commits, SUMMARY generation, and phase transition handling.

## Worker Policy

- Each worker gets an isolated worktree
- Tasks with overlapping write domains must not run together
- Shared high-risk files should be treated as exclusive
- Local retries stop after 2 attempts
- Repeated failure becomes a failed task package, not a global stop by default

## Escalate To Claude Only When

- branch safety is violated
- the same class of failure repeats across workers
- wave reconciliation keeps failing
- the plan itself is no longer correct

## Recovery

If execution stalls:

1. Review `queue/failed/`
2. Review `runtime/checkpoints/`
3. Run the recovery skill
4. Re-dispatch the phase or specific failed work after deciding whether the issue is runtime, plan, or architecture related
