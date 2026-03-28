#!/bin/bash
# Hybrid GSD + Codex bootstrap script
# Usage: bash init-continue.sh "ProjectName" "One sentence objective"

set -euo pipefail

PROJECT_NAME="${1:-MyProject}"
OBJECTIVE="${2:-Build and ship the project.}"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%S+00:00")

mkdir -p \
  .planning/phases \
  continue \
  docs/plans \
  queue/failed \
  queue/pending-review \
  runtime/logs \
  runtime/checkpoints \
  runtime/workers \
  templates \
  scripts

for worker_id in 1 2 3 4; do
  mkdir -p "runtime/workers/worker-${worker_id}"
done

for keep_file in \
  "queue/failed/.gitkeep" \
  "queue/pending-review/.gitkeep" \
  "runtime/logs/.gitkeep" \
  "runtime/checkpoints/.gitkeep"
do
  if [ ! -f "$keep_file" ]; then
    : > "$keep_file"
  fi
done

cat > continue/AGENT.MD << 'AGENT_EOF'
# Continue Protocol

## Purpose

`continue/` is the human-readable handoff layer for a hybrid GSD + Codex project.

Formal project state lives in `.planning/STATE.md`.
`continue/` exists to preserve recovery notes, current focus, and operator-visible session context.

## Mandatory Session Recovery Workflow

1. Read `.planning/STATE.md` first if it exists.
2. Read `continue/task.json`.
3. Read `continue/progress.txt`.
4. Confirm `current_focus`, active phase, and latest progress entry before making edits.

If `.planning/STATE.md` conflicts with `continue/`, update `continue/` to match the formal state.

## Required Status Flow

Allowed lifecycle:
`brainstorming -> planned -> in_progress -> review -> done`

Rules:
- Do not skip forward statuses.
- Do not move a task backward unless blocked by explicit new evidence.
- Keep `current_focus` aligned with the active task in `task.json`.

## Design-to-Implementation Gate

- Design and plan work must be approved before execution begins.
- Codex execution must run on a non-`main` branch.
- Parallel Codex workers must use isolated worktrees.
- Failed tasks go to `queue/failed/` rather than blocking the whole system by default.

## Session End Requirements

At the end of every session:
1. Update `continue/task.json` task states, `current_focus`, and `last_updated`.
2. Append to `continue/progress.txt` with changes, decisions, blockers, and next step.
3. Ensure `continue/` reflects `.planning/STATE.md`.

## Role Division

| Role | Tool | Responsibility |
|------|------|----------------|
| **Claude Code** | GSD + command surface | Planning, review, escalation, verification |
| **Codex** | Runtime worker | Implementation, retries, local validation |
AGENT_EOF

python3 -c "
import json, sys
data = {
    'project': sys.argv[1],
    'objective': sys.argv[2],
    'current_phase': 'bootstrap',
    'current_focus': 'PLAN-001',
    'last_updated': sys.argv[3],
    'tasks': [
        {
            'id': 'PLAN-001',
            'title': 'Initialize GSD project state and hybrid runtime scaffold',
            'type': 'planning',
            'status': 'planned',
            'priority': 'P0'
        }
    ]
}
with open('continue/task.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
" "$PROJECT_NAME" "$OBJECTIVE" "$TIMESTAMP"

cat > continue/progress.txt << PROG_EOF
[$(date '+%Y-%m-%d %H:%M %z')] Session: HYBRID-BOOTSTRAP initialization
Focus: Initialize hybrid GSD planning and Codex execution scaffolding

Work completed:
- Created .planning/, continue/, queue/, runtime/, templates/, and docs/plans/
- Created continue/AGENT.MD with hybrid recovery workflow
- Created continue/task.json as session handoff state
- Created continue/progress.txt initial checkpoint

Decisions:
- GSD owns formal project state in .planning/
- Codex is the default execution engine
- Claude stays at planning, verification, and escalation boundaries

Blockers:
- None

Next recommended step:
- Run: /gsd:new-project
- Then: /gsd:plan-phase 1
- Then: /execute-codex-phase 1
PROG_EOF

echo "✅ hybrid runtime initialized for project: $PROJECT_NAME"
echo "   Next: /gsd:new-project"
echo "   Then: /gsd:plan-phase 1"
echo "   Then: /execute-codex-phase 1"
