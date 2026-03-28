# CLAUDE.md — Hybrid GSD + Codex 144h Template

## Purpose

This template is designed for a cost-aware workflow:

- `GSD` owns project state, phases, roadmap, and verification.
- `Codex` owns most implementation work.
- `Claude` stays on planning, review, escalation, and verification boundaries.

The goal is to keep Claude off the per-task hot path while still using it where judgment matters.

## Default Model Split

| System | Responsibility |
|--------|----------------|
| `GSD` | `.planning/` state, phase planning, progress, UAT |
| `Claude` | command surface, architecture decisions, escalation, verification |
| `Codex` | implementation, retries, local validation, worker execution |

## Canonical Flow

```text
/gsd:new-project
/gsd:plan-phase <phase>
/execute-codex-phase <phase>
/gsd:verify-work <phase>
```

Use Superpowers around the edges:

- `superpowers:brainstorming`
- `superpowers:writing-plans`
- `superpowers:executing-plans`
- `superpowers:finishing-a-development-branch`

## Branch Safety

- Never run implementation on `main`.
- Create or reuse a phase branch before Codex execution.
- Worker work must stay inside isolated worktrees.
- Formal project state lives in `.planning/STATE.md`.

## Runtime Defaults

- Balanced autonomy
- Up to 4 Codex worker slots
- Failed tasks go to `queue/failed/`
- Worker manifests go to `runtime/checkpoints/`
- Watchdog and reconciliation live under `scripts/`

## Recovery Rules

If something goes wrong:

1. Check `.planning/STATE.md`
2. Check `queue/failed/`
3. Check `runtime/checkpoints/`
4. Check `runtime/logs/`
5. Use the recovery skill instead of rebuilding context from memory

## Verification Rules

- Task-level validation happens inside worker execution
- Wave-level validation happens in `scripts/reconcile-wave.sh`
- Phase-level validation happens through `gsd:verify-work`
- The template itself must pass `bash scripts/self-test.sh`

## Fast Start

```bash
bash scripts/bootstrap-gsd.sh
```

Then in Claude Code:

```text
/gsd:new-project
/gsd:plan-phase 1
/execute-codex-phase 1
```
