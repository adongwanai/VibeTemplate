# GSD + Codex Hybrid Template Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Convert the current template into a branch-safe hybrid system where GSD owns planning and verification while Codex executes phase work with 4 parallel workers, retries, recovery artifacts, and template self-tests.

**Architecture:** Keep GSD as the formal state and phase layer, keep Superpowers for design and plan quality, and add a Codex-first runtime that reads phase plans, schedules safe task waves, runs isolated worker worktrees, and reconciles results before phase verification. The runtime must be cheaper than Claude-driven execution and robust enough for 144h unattended loops.

**Tech Stack:** Markdown docs, Claude project commands/skills, shell scripts, Node.js self-test, Git branches/worktrees

---

### Task 1: Normalize Template Baseline

**Files:**
- Modify: `.gitignore`
- Modify: `package.json`
- Modify: `test-template.js`
- Modify: `.claude/settings.json`
- Test: `test-template.js`

**Step 1: Write the failing template assertions**

Add assertions in `test-template.js` for:

- `.claude/commands/execute-codex-phase.md`
- `.claude/commands/codex-status.md`
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

Also change the hook syntax check to compile:

```js
const hookPath = path.join(__dirname, '.claude/hooks/scripts/hooks.py');
```

Update `.gitignore` so plan files can be versioned. Replace the broad ignore with an allowlist strategy or remove the `docs/plans/*.md` ignore rule entirely.

**Step 2: Run the template test to verify it fails**

Run: `npm test`

Expected: FAIL because the new files do not exist yet, while the hook path assertion now points to the correct location.

**Step 3: Align config defaults**

Update `.claude/settings.json` so `plansDirectory` points to:

```json
"plansDirectory": "./docs/plans"
```

Update `package.json` scripts to include:

```json
{
  "test": "node test-template.js",
  "self-test": "bash scripts/self-test.sh",
  "lint": "echo 'No linter configured'",
  "build": "echo 'No build configured'"
}
```

**Step 4: Run the template test again after the later scaffold exists**

Run: `npm test`

Expected: PASS once the scaffold from later tasks is in place.

**Step 5: Commit**

```bash
git add .gitignore package.json test-template.js .claude/settings.json
git commit --no-verify -m "chore: normalize template baseline"
```

### Task 2: Add Runtime and Queue Scaffold

**Files:**
- Create: `queue/failed/.gitkeep`
- Create: `queue/pending-review/.gitkeep`
- Create: `runtime/logs/.gitkeep`
- Create: `runtime/checkpoints/.gitkeep`
- Create: `templates/codex-task.md`
- Create: `templates/codex-fix.md`
- Create: `templates/codex-verify.md`

**Step 1: Write the prompt template skeletons**

Create `templates/codex-task.md` with sections:

```md
# Codex Task
## Objective
## Files
## Constraints
## Acceptance Tests
## Branch Rules
## Retry Context
```

Create `templates/codex-fix.md` with sections:

```md
# Codex Repair Task
## Original Task
## Failure Output
## Files Touched
## Allowed Fix Scope
## Acceptance Tests
```

Create `templates/codex-verify.md` with sections:

```md
# Codex Verification Task
## Wave
## Commands
## Expected Results
## Reporting Format
```

**Step 2: Create queue and runtime anchors**

Create the four `.gitkeep` files so the queue and runtime directories exist in a fresh clone.

**Step 3: Add branch-safety language inside templates**

Each template must explicitly say:

```md
- Never write on main.
- Work only inside the assigned worktree.
- Report files changed and validation run.
```

**Step 4: Verify scaffold presence**

Run: `find queue runtime templates -maxdepth 2 -type f | sort`

Expected: All new files listed exactly once.

**Step 5: Commit**

```bash
git add queue runtime templates
git commit --no-verify -m "chore: add codex runtime scaffold"
```

### Task 3: Add Bootstrap and Self-Test Scripts

**Files:**
- Create: `scripts/bootstrap-gsd.sh`
- Create: `scripts/self-test.sh`
- Modify: `init-continue.sh`
- Test: `scripts/self-test.sh`

**Step 1: Write `scripts/bootstrap-gsd.sh`**

Create a script that:

- creates `.planning/`, `queue/`, `runtime/`, `templates/`, and `docs/plans/`
- creates missing `.gitkeep` files
- prints the next recommended commands:
  - `/gsd:new-project`
  - `/gsd:plan-phase 1`
  - `/execute-codex-phase 1`

Use a safe shell pattern:

```bash
set -euo pipefail
mkdir -p .planning docs/plans queue/failed queue/pending-review runtime/logs runtime/checkpoints templates scripts
```

**Step 2: Write `scripts/self-test.sh`**

Create a script that runs:

```bash
set -euo pipefail
npm test
python3 -m py_compile .claude/hooks/scripts/hooks.py
test -f .claude/commands/execute-codex-phase.md
test -f scripts/watchdog.sh
```

Add readable output for pass/fail groups.

**Step 3: Update `init-continue.sh`**

Keep `continue/` creation, but also ensure it creates:

- `docs/plans`
- `queue/failed`
- `queue/pending-review`
- `runtime/logs`
- `runtime/checkpoints`

Change the final instructions so they point to the new hybrid flow.

**Step 4: Run self-test before the later command files exist**

Run: `bash scripts/self-test.sh`

Expected: FAIL until later tasks create the new command and script files.

**Step 5: Commit**

```bash
git add scripts/bootstrap-gsd.sh scripts/self-test.sh init-continue.sh
git commit --no-verify -m "chore: add bootstrap and self-test scripts"
```

### Task 4: Build the Codex Phase Execution Scripts

**Files:**
- Create: `scripts/execute-codex-phase.sh`
- Create: `scripts/reconcile-wave.sh`
- Create: `scripts/watchdog.sh`
- Test: `scripts/execute-codex-phase.sh`

**Step 1: Write the execution script shell**

Create `scripts/execute-codex-phase.sh` with command phases:

```bash
set -euo pipefail

PHASE_ID="${1:?phase id required}"
MAX_WORKERS="${MAX_CODEX_WORKERS:-4}"

# load phase files
# derive task queue
# assign ready tasks to workers
# run local validation
# package failures
# call reconcile
```

The script does not need to contain the full scheduler on the first pass, but it must define stable function boundaries:

- `load_phase_context`
- `build_ready_queue`
- `dispatch_task`
- `package_failure`
- `run_wave_validation`

**Step 2: Write the reconciliation script**

Create `scripts/reconcile-wave.sh` with functions to:

- verify workers are on a non-`main` branch
- collect changed files from worker worktrees
- detect overlapping writes
- run wave-level validation
- print a summary report

**Step 3: Write the watchdog script**

Create `scripts/watchdog.sh` to:

- monitor a phase execution command
- restart on non-zero exit
- detect stale worker heartbeats
- lower concurrency or stop after repeated failures

Seed the main loop with:

```bash
while true; do
  bash scripts/execute-codex-phase.sh "$PHASE_ID" || true
  sleep 5
done
```

Then replace the loose loop with guarded exit conditions.

**Step 4: Smoke-test script entrypoints**

Run:

```bash
bash scripts/execute-codex-phase.sh 1 || true
bash scripts/reconcile-wave.sh 1 || true
bash scripts/watchdog.sh 1 || true
```

Expected: Scripts parse arguments and fail gracefully with readable messages if `.planning/` is not initialized yet.

**Step 5: Commit**

```bash
git add scripts/execute-codex-phase.sh scripts/reconcile-wave.sh scripts/watchdog.sh
git commit --no-verify -m "feat: add codex phase runtime scripts"
```

### Task 5: Rewrite the Claude Command Surface

**Files:**
- Modify: `.claude/commands/24h-loop.md`
- Create: `.claude/commands/execute-codex-phase.md`
- Create: `.claude/commands/codex-status.md`
- Modify: `.claude/skills/execute-with-codex/SKILL.md`

**Step 1: Write the new execution command**

Create `.claude/commands/execute-codex-phase.md` that instructs Claude to:

- validate current branch is not `main`
- read `.planning/STATE.md`
- call `bash scripts/execute-codex-phase.sh <phase>`
- summarize worker status and failed tasks

**Step 2: Add a status command**

Create `.claude/commands/codex-status.md` that reads:

- `.planning/STATE.md`
- `queue/failed/`
- `runtime/checkpoints/`
- `runtime/logs/`

and reports current phase, worker activity, stalled tasks, and next action.

**Step 3: Rewrite the execution skill**

Update `.claude/skills/execute-with-codex/SKILL.md` so it no longer describes a single serial task loop. Replace that with:

- phase-based execution
- 4-worker default
- local retry policy
- failed task packaging
- branch-only execution
- wave validation and Claude escalation rules

**Step 4: Rewrite `24h-loop.md`**

Change the documented flow to:

```text
/gsd:new-project
/gsd:plan-phase N
/execute-codex-phase N
/gsd:verify-work N
```

The loop command should point to the phase executor, not the old task-by-task loop.

**Step 5: Commit**

```bash
git add .claude/commands/24h-loop.md .claude/commands/execute-codex-phase.md .claude/commands/codex-status.md .claude/skills/execute-with-codex/SKILL.md
git commit --no-verify -m "feat: add hybrid codex command surface"
```

### Task 6: Enforce Git and Recovery Rules

**Files:**
- Modify: `.claude/rules/git-workflow.md`
- Create: `.claude/skills/recover-failed-wave/SKILL.md`
- Create: `.claude/skills/self-test-template/SKILL.md`
- Modify: `CLAUDE.md`

**Step 1: Update git rules**

In `.claude/rules/git-workflow.md`, add explicit rules:

- never implement on `main`
- create or switch to a phase branch before execution
- workers must use isolated worktrees
- reconciliation happens before merge

**Step 2: Add recovery skill**

Create `.claude/skills/recover-failed-wave/SKILL.md` with a flow:

- inspect `queue/failed/`
- inspect `runtime/checkpoints/`
- classify failures into retry, plan gap, or Claude escalation
- produce a recovery recommendation

**Step 3: Add template self-test skill**

Create `.claude/skills/self-test-template/SKILL.md` that runs:

```bash
bash scripts/self-test.sh
```

and explains how to interpret failures.

**Step 4: Update `CLAUDE.md`**

Rewrite it around the hybrid system:

- GSD owns planning
- Codex owns execution
- Claude is not the per-task driver
- balanced autonomy defaults
- branch rule is mandatory

**Step 5: Commit**

```bash
git add .claude/rules/git-workflow.md .claude/skills/recover-failed-wave/SKILL.md .claude/skills/self-test-template/SKILL.md CLAUDE.md
git commit --no-verify -m "feat: enforce branch and recovery rules"
```

### Task 7: Rewrite User-Facing Documentation

**Files:**
- Modify: `README.md`
- Modify: `continue/AGENT.MD`
- Modify: `continue/progress.txt`
- Modify: `continue/task.json`

**Step 1: Rewrite README flow**

Document the new lifecycle:

- bootstrap template
- initialize GSD
- plan a phase
- execute via Codex runtime
- verify via GSD

Add an explicit cost model section:

- Claude for planning and verification
- Codex for long-running execution

**Step 2: Update continue protocol**

Keep `continue/` as session memory, but make it clear that `.planning/STATE.md` is the formal source of truth.

**Step 3: Seed progress examples**

Update the example `continue/progress.txt` and `continue/task.json` so they reference the hybrid system rather than the old serial Codex loop.

**Step 4: Run a docs sanity pass**

Run:

```bash
rg -n "superpowers:|execute-with-codex|docs/plans|main" README.md CLAUDE.md continue .claude -S
```

Expected: The docs consistently describe the new flow and branch rule.

**Step 5: Commit**

```bash
git add README.md continue/AGENT.MD continue/progress.txt continue/task.json
git commit --no-verify -m "docs: rewrite template for hybrid gsd codex flow"
```

### Task 8: Final Verification and Handoff

**Files:**
- Test: `package.json`
- Test: `scripts/self-test.sh`
- Test: `test-template.js`

**Step 1: Run the full template validation**

Run:

```bash
npm test
bash scripts/self-test.sh
```

Expected: PASS with no missing-file errors and no hook path errors.

**Step 2: Smoke-test branch guard behavior**

Run from the feature branch:

```bash
bash scripts/execute-codex-phase.sh 1 || true
```

Expected: The script confirms branch safety and reports missing `.planning/` state gracefully if the project has not been initialized yet.

**Step 3: Review queue and runtime behavior**

Run:

```bash
find queue runtime -maxdepth 2 -type f | sort
```

Expected: Queue and runtime files exist in expected locations.

**Step 4: Prepare implementation summary**

Write a short summary noting:

- hybrid architecture in place
- branch guard in place
- 4-worker runtime scaffold in place
- self-test green

**Step 5: Commit**

```bash
git add .
git commit --no-verify -m "chore: finalize hybrid template verification"
```
