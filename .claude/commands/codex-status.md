---
description: Show the current Codex runtime state for the active project.
model: sonnet
---

# Codex Status

Use this command to inspect the default Codex bridge runtime on this branch.

Use `/gsd:progress` when you want GSD's project-level view. Use `/codex-status` when you want bridge-level runtime details.

## Read

```bash
git branch --show-current
test -f .planning/STATE.md && sed -n '1,220p' .planning/STATE.md
find runtime/checkpoints -maxdepth 1 -type f | sort
find queue/failed -maxdepth 1 -type f | sort
find runtime/logs -maxdepth 1 -type f | sort
```

## Report

- current branch safety status
- active phase if present in `.planning/STATE.md`
- worker checkpoint files
- stale or missing heartbeat/log files
- failed task packages waiting for recovery
- recommended next command

## Routing

- Missing `.planning/STATE.md` → `/gsd:new-project`
- Missing phase plan files → `/gsd:plan-phase <phase-id>`
- Failed task packages present → use `recover-failed-wave`
- Clean runtime and phase complete → `/gsd:verify-work <phase-id>`
