# Phase 1: Template Smoke Flow - Context

**Gathered:** 2026-03-28
**Status:** Ready for planning

## Phase Boundary

This phase exists only to prove the template wiring. It covers sample planning state, sample phase plans, and a smoke execution path that writes manifests and runs reconciliation without requiring a real product codebase.

## Implementation Decisions

### Demo shape
- **D-01:** The sample phase should be minimal and template-focused, not a fake app feature.
- **D-02:** The sample phase should remain safe to run on a fresh clone.

### Execution behavior
- **D-03:** Manifest-first execution is acceptable for the sample.
- **D-04:** The operator must still be on a non-`main` branch.

### the agent's Discretion
- Naming of sample plan files
- Exact wording of operator guidance

## Specific Ideas

- Keep the example obviously placeholder but fully structured.
- Make the sample phase useful as an onboarding walkthrough.

## Canonical References

### Runtime
- `scripts/execute-codex-phase.sh` — Phase execution entrypoint and branch guard
- `scripts/reconcile-wave.sh` — Wave validation and runtime report behavior
- `scripts/self-test.sh` — Template readiness checks

### Operator docs
- `README.md` — Chinese quick start and operator flow
- `CLAUDE.md` — Model split and workflow rules

## Existing Code Insights

### Reusable Assets
- `scripts/bootstrap-gsd.sh`: Initializes the required directory layout
- `templates/codex-task.md`: Can be referenced by future worker adapters

### Established Patterns
- Shell scripts normalize `ROOT_DIR` and use `set -euo pipefail`
- `.planning/STATE.md` is the formal state source

### Integration Points
- `.claude/commands/execute-codex-phase.md`
- `.claude/commands/codex-status.md`

## Deferred Ideas

- Real task dependency parsing
- Native Codex runner integration
- Example business project built on top of the template

---
*Phase: 01-template-smoke*
*Context gathered: 2026-03-28*
