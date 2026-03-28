# GSD + Codex Hybrid 144h Template Design

**Status:** Approved

**Date:** 2026-03-28

## Goal

Turn the current template into a `GSD plans + Codex executes` system that can run for long stretches with low Claude usage, strong recovery, and built-in self-testing.

## Problem

The current template is still Claude-driven at execution time. It documents a loop where Claude reads plans, calls Codex, validates output, and repeats. That keeps Claude on the hot path, makes long-running execution expensive, and does not support structured phase state, wave-based concurrency, or reliable 144h recovery.

## Locked Decisions

- Planning and project state live in `.planning/` through GSD artifacts.
- Execution defaults to `Balanced` autonomy.
- The template runs up to `4` Codex workers in parallel.
- Claude remains the default command entrypoint.
- All implementation work must run on a non-`main` branch.
- Failed tasks do not stop the whole run unless they indicate architectural drift or repeated global breakage.

## Target Outcomes

- Claude is used for `new-project`, `discuss-phase`, `plan-phase`, `verify-work`, and escalation only.
- Codex is the default implementation engine for phase tasks and retry loops.
- The template can run task-level, wave-level, and phase-level verification without human babysitting.
- The system leaves durable recovery artifacts when workers fail, stall, or hit merge conflicts.
- The template validates itself before users trust it on real projects.

## Architecture

### 1. Planning Layer

GSD owns the project memory and planning flow:

- `.planning/PROJECT.md`
- `.planning/REQUIREMENTS.md`
- `.planning/ROADMAP.md`
- `.planning/STATE.md`
- `.planning/phases/*`

Claude uses GSD and Superpowers at high-value decision points:

- `superpowers:brainstorming`
- `superpowers:writing-plans`
- `gsd-new-project`
- `gsd-plan-phase`
- `gsd-verify-work`

This layer decides what to build, in which order, and with which acceptance criteria.

### 2. Execution Layer

Codex owns implementation:

- Reads phase plans and extracts executable tasks
- Builds a dependency graph
- Groups tasks into execution waves
- Runs up to 4 workers in parallel
- Performs local retries and local validation
- Produces recovery bundles for failed tasks

This layer is intentionally cheaper than keeping Claude in the loop for every task.

### 3. Recovery Layer

The runtime layer keeps long-running automation healthy:

- worker heartbeats
- stalled task detection
- failed task packaging
- watchdog restarts
- wave reconciliation
- project-level validation before advancing

## Directory Model

```text
.planning/
  PROJECT.md
  REQUIREMENTS.md
  ROADMAP.md
  STATE.md
  config.json
  phases/
    01-<phase>/
      01-CONTEXT.md
      01-01-<plan>.md
      01-02-<plan>.md
      01-UAT.md
      SUMMARY.md

continue/
  AGENT.MD
  task.json
  progress.txt

queue/
  failed/
  pending-review/

runtime/
  workers/
    worker-1/
    worker-2/
    worker-3/
    worker-4/
  logs/
  checkpoints/

templates/
  codex-task.md
  codex-fix.md
  codex-verify.md

scripts/
  bootstrap-gsd.sh
  execute-codex-phase.sh
  reconcile-wave.sh
  watchdog.sh
  self-test.sh
```

`continue/` remains useful as session memory and human handoff, but `.planning/` becomes the single formal project state source.

## Execution Lifecycle

1. Claude starts or resumes the project through GSD.
2. GSD creates or updates the phase artifacts.
3. Claude triggers a Codex-focused phase command.
4. The execution script reads plan files and derives runnable tasks.
5. Tasks are grouped into waves based on dependencies and file write domains.
6. Up to 4 Codex workers execute ready tasks in isolated worktrees.
7. Each task runs local verification and retries up to two times.
8. Failed tasks are serialized into `queue/failed/` and `runtime/checkpoints/`.
9. After a wave completes, the system runs project-level validation.
10. After the phase completes cleanly, Claude returns for `gsd-verify-work`.

## Concurrency Model

### Task Metadata

Every executable task needs:

- `task_id`
- `phase_id`
- `plan_id`
- `deps`
- `files_expected`
- `verification_scope`
- `priority`
- `exclusive`

### Wave Rules

- Only dependency-free ready tasks can enter the current wave queue.
- Ready tasks with overlapping `files_expected` cannot run together.
- Shared high-risk files are `exclusive` and must run alone.
- A later wave never starts until the current wave has either completed or packaged its failures.

### Worktree Isolation

Each worker runs in its own worktree rooted under `runtime/workers/worker-N`.

Benefits:

- no direct write contention in the main worktree
- easier cleanup after crashes
- clearer attribution for failed tasks
- simpler merge and reconciliation logic

## Validation Strategy

### Task-Level Validation

Each task runs the smallest useful checks first:

- focused tests
- local lint
- local typecheck
- task smoke command

### Wave-Level Validation

After a wave finishes:

- full template test
- project lint
- build
- integration smoke checks

Wave validation failure creates repair work before the next wave advances.

### Phase-Level Validation

After all waves complete successfully, Claude runs `gsd-verify-work` and records results in `UAT.md`.

## Failure Policy

- A task gets up to 2 automatic repair attempts.
- Repeated local failure becomes a failed task package and does not freeze the whole phase.
- Repeated failure across workers, repeated write conflicts, or sustained global validation failures escalate to Claude.
- Recovery data must be readable without replaying the whole session.

Failed task packages contain:

- task description
- worker id
- changed files
- last error output
- retry count
- recommended next action
- escalation flag

## Branching Strategy

The template enforces branch safety:

- implementation never starts on `main`
- phase execution creates or reuses a phase branch
- workers operate from worktrees attached to that branch
- reconciliation lands on the phase branch first
- merge to `main` remains an explicit human action

This rule must be enforced in docs, commands, and guard scripts rather than left as tribal knowledge.

## Superpowers and GSD Coordination

### Superpowers

- `brainstorming` for requirement and design shaping
- `writing-plans` for detailed implementation plans
- `executing-plans` for optional manual execution mode
- `finishing-a-development-branch` for branch completion

### GSD

- state model
- roadmap and phase structure
- verification flow
- workstream management
- autonomous routing when desired

### Codex Runtime

- task execution
- retries
- validation loops
- queueing
- concurrent worker orchestration

## Template Changes Required

### Existing Files to Update

- `.gitignore`
- `README.md`
- `CLAUDE.md`
- `package.json`
- `test-template.js`
- `init-continue.sh`
- `.claude/settings.json`
- `.claude/rules/git-workflow.md`
- `.claude/commands/24h-loop.md`
- `.claude/skills/execute-with-codex/SKILL.md`

### New Files to Add

- `.claude/commands/execute-codex-phase.md`
- `.claude/commands/codex-status.md`
- `.claude/skills/recover-failed-wave/SKILL.md`
- `.claude/skills/self-test-template/SKILL.md`
- `scripts/bootstrap-gsd.sh`
- `scripts/execute-codex-phase.sh`
- `scripts/reconcile-wave.sh`
- `scripts/watchdog.sh`
- `scripts/self-test.sh`
- `templates/codex-task.md`
- `templates/codex-fix.md`
- `templates/codex-verify.md`
- `queue/failed/.gitkeep`
- `queue/pending-review/.gitkeep`
- `runtime/logs/.gitkeep`
- `runtime/checkpoints/.gitkeep`

## Acceptance Criteria

- The template initializes into a GSD-compatible project structure.
- Phase execution can be routed through a Codex-specific command without using `main`.
- The runtime supports 4 concurrent Codex workers with write-domain safety.
- The template produces recovery artifacts for failed tasks.
- The template includes a self-test that catches path drift, config drift, and missing runtime pieces.
- Docs clearly explain when Claude is used and when Codex is used.

## Non-Goals

- Replacing every GSD workflow with custom logic
- Full autonomous phase planning without any Claude checkpoints
- Removing `continue/`
- Solving every merge conflict automatically

## Rollout Order

1. Fix template consistency and branch guards.
2. Add runtime scaffolding and verification scripts.
3. Replace the current sequential Codex loop with phase-aware execution.
4. Update docs and command surface.
5. Validate the template through self-tests.
