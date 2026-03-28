# Architecture

## Overview

This repository follows a workflow-template architecture, not a product-application architecture.

There are four main layers:

1. Claude command and skill surface in `.claude/`
2. Project state and planning artifacts in `.planning/`, `docs/plans/`, and `continue/`
3. Runtime orchestration in `scripts/`, `runtime/`, and `queue/`
4. Template verification through `test-template.js` and `scripts/self-test.sh`

## Data Flow

### Planning Flow

1. Operator starts in Claude Code.
2. GSD creates or updates `.planning/PROJECT.md`, `.planning/ROADMAP.md`, `.planning/STATE.md`.
3. Phase plans are generated under `.planning/phases/*`.

### Execution Flow

1. `/execute-codex-phase <phase>` routes to `scripts/execute-codex-phase.sh`.
2. The script validates branch safety and GSD state.
3. It reads phase plan files from `.planning/phases/<phase>/`.
4. It writes worker checkpoint manifests to `runtime/checkpoints/`.
5. It triggers wave reconciliation through `scripts/reconcile-wave.sh`.

### Verification Flow

1. `scripts/reconcile-wave.sh` runs npm scripts and `scripts/self-test.sh`.
2. Claude uses `/codex-status` or `/gsd:verify-work` for the next operator step.

## Entry Points

- `README.md`
- `CLAUDE.md`
- `init-continue.sh`
- `scripts/bootstrap-gsd.sh`
- `.claude/commands/execute-codex-phase.md`
- `.claude/commands/codex-status.md`

## Architectural Strengths

- Clear split between planning and execution concerns
- Strong branch-safety posture
- Recovery-aware runtime layout
- Built-in template self-test

## Architectural Gaps

- No real scheduler beyond manifest assignment
- No concrete task dependency parser yet
- No implemented Codex runner adapter
- No application example proving an end-to-end project lifecycle
