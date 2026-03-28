---
description: Run the hybrid GSD + Codex 24h loop for a phase.
model: sonnet
---

# 24h Hybrid Loop

Use this command when the project already has `.planning/` state and you want Claude to stay on the command surface while Codex handles most execution work.

## Flow

```text
/gsd:new-project
/gsd:plan-phase <phase>
/gsd:execute-phase <phase>
/gsd:verify-work <phase>
```

## Default Behavior

- Claude handles planning, escalation, and final verification.
- GSD handles phase orchestration, commits, and summary lifecycle.
- Codex remains the preferred implementation model inside the broader workflow.
- The runtime uses up to 4 worker slots by default.
- Execution must happen on a non-`main` branch.

## Recommended Loop

```text
/24h-loop 1
→ confirm you are not on main
→ run /gsd:execute-phase 1
→ inspect /gsd:progress
→ return for /gsd:verify-work 1 when wave execution is clean
```

For unattended monitoring:

```text
/loop 10m /gsd:progress
```

## Operator Rules

- Do not start this loop before phase planning exists.
- Do not run implementation on `main`.
- Treat `.planning/STATE.md` as the formal source of truth.
- Use `queue/failed/` and `runtime/checkpoints/` for recovery instead of redoing work from memory.
