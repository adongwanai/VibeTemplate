---
name: recover-failed-wave
description: Recover failed Codex runtime work by inspecting queue packages, worker checkpoints, and reconciliation logs.
---

# Recover Failed Wave

Use this skill when `queue/failed/` or `runtime/checkpoints/` shows incomplete or failed work.

## Process

1. Read the failed task packages:

```bash
find queue/failed -maxdepth 1 -type f | sort
```

2. Read the worker checkpoints:

```bash
find runtime/checkpoints -maxdepth 1 -type f | sort
```

3. Read the reconciliation and heartbeat logs if they exist:

```bash
find runtime/logs -maxdepth 1 -type f | sort
```

4. Classify each failure as one of:
- runtime issue
- branch/worktree issue
- plan gap
- real architecture escalation

5. Recommend the next action:
- retry same phase dispatch
- re-plan the phase
- manually inspect a worker worktree
- escalate to Claude for a decision

## Recovery Principle

Do not guess from memory. Use the queue package, checkpoint, and log files as the source of truth.
