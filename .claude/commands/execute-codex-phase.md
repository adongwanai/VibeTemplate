---
description: Execute a planned phase through the Codex-first runtime.
model: sonnet
---

# Execute Codex Phase

Run this only when you intentionally want to bridge a planned phase into the local `codex exec` runner.

This is an advanced path. The default path is:

```text
/gsd:execute-phase <phase-id>
```

## Usage

```text
/execute-codex-phase <phase-id>
```

## Command Contract

1. Read `.planning/STATE.md`
2. Confirm the current branch is not `main`
3. Confirm `.planning/phases/<phase>/` exists
4. Run:

```bash
bash scripts/execute-codex-phase.sh <phase-id>
```

5. Summarize:
- assigned worker manifests
- failed task packages
- whether reconciliation passed
- what should happen next

## Notes

- Prefer `/gsd:execute-phase` unless you explicitly need the local Codex bridge
- This command does not try to replace GSD's native commit/SUMMARY/state lifecycle
- If the script reports missing `.planning/STATE.md`, route back to `/gsd:new-project`
- If it reports missing phase plans, route back to `/gsd:plan-phase <phase-id>`
