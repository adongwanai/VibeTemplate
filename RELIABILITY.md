# Reliability

## Reliability Posture

This is the safest branch in the repository.

Use it when you want:

- the most standard flow
- the least bridge complexity
- the clearest state and verification lifecycle

## What Is Verified

Run:

```bash
bash scripts/self-test.sh
```

This verifies:

- required files exist
- core docs exist
- hooks compile
- `.planning/config.json` keeps automation-friendly defaults
- branch docs still align with the GSD-native flow

## Runtime Notes

- `gsd:execute-phase` is the default execution path
- `watchdog.sh` and runtime folders still exist
- `execute-codex-phase.sh` is available, but not the default recommendation here

## Recovery Order

1. `.planning/STATE.md`
2. `queue/failed/`
3. `runtime/checkpoints/`
4. `runtime/logs/`

## Practical Limit

This branch is reliable as a workflow template, but still depends on:

- environment stability
- model availability
- credentials and quotas
- user choosing sane phase boundaries
