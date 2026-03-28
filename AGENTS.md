# AGENTS.md

This branch is the Claude-plans, Codex-executes template.

## What This Branch Is

- default execution uses the local Codex bridge
- use this branch when you care more about Codex as the execution surface
- recommended for cost-sensitive solo work

## Read Order

1. `README.md`
2. `CLAUDE.md`
3. `.planning/config.json`

## Default Flow

```text
/gsd:new-project
/gsd:plan-phase N
/execute-codex-phase N
/gsd:verify-work N
/codex-status
```

## Backup Path

`/gsd:execute-phase` remains available when you want GSD-native execution instead.

## Detailed Docs

- `CLAUDE.md` — workflow constitution
- `ARCHITECTURE.md` — branch design and tool split
- `RELIABILITY.md` — self-test, runtime state, limits
