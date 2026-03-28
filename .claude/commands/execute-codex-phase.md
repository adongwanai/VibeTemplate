---
description: Execute a planned phase through the Codex-first runtime.
model: sonnet
---

# Execute Codex Phase

Run this after the target phase has been planned in `.planning/phases/`.

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

- Claude stays as the operator and reviewer
- Codex remains the default implementation engine
- If the script reports missing `.planning/STATE.md`, route back to `/gsd:new-project`
- If it reports missing phase plans, route back to `/gsd:plan-phase <phase-id>`
