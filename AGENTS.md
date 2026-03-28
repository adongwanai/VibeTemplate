# AGENTS.md

This branch is the stable GSD-native template.

## What This Branch Is

- default execution stays inside GSD
- use this branch when you want the cleanest native lifecycle
- recommended for most users

## Read Order

1. `README.md`
2. `CLAUDE.md`
3. `.planning/config.json`

## Default Flow

```text
/gsd:new-project
/gsd:plan-phase N
/gsd:execute-phase N
/gsd:verify-work N
/gsd:progress
```

## Optional Path

`/execute-codex-phase` is retained only as an advanced fallback bridge.

## Detailed Docs

- `CLAUDE.md` — workflow constitution
- `ARCHITECTURE.md` — branch design and tool split
- `RELIABILITY.md` — self-test, runtime state, limits
