#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

PHASE_ID="${1:-}"
DRY_RUN="${CODEX_DRY_RUN:-1}"
MAX_WORKERS="${MAX_CODEX_WORKERS:-4}"
BASE_BRANCH="${CODEX_PHASE_BRANCH:-$(git branch --show-current 2>/dev/null || echo '')}"

log() {
  printf '[execute-codex-phase] %s\n' "$1"
}

die() {
  printf '[execute-codex-phase] ERROR: %s\n' "$1" >&2
  exit "${2:-1}"
}

usage() {
  cat <<'EOF'
Usage: bash scripts/execute-codex-phase.sh <phase-id>

Environment:
  MAX_CODEX_WORKERS   Maximum worker slots to assign (default: 4)
  CODEX_DRY_RUN       1 writes manifests only, 0 allows external runner hooks
  CODEX_RUNNER_SCRIPT Optional external runner called per assigned plan
  CODEX_PHASE_BRANCH  Override the phase branch used for worker worktrees
EOF
}

ensure_runtime_dirs() {
  mkdir -p runtime/logs runtime/checkpoints runtime/workers queue/failed queue/pending-review
}

ensure_branch_guard() {
  local current_branch
  current_branch="$(git branch --show-current 2>/dev/null || true)"
  if [ -z "$current_branch" ]; then
    die "Unable to determine the current branch." 64
  fi

  if [ "$current_branch" = "main" ] || [ "$current_branch" = "master" ]; then
    die "Refusing to execute Codex phase work on ${current_branch}. Switch to a phase branch first." 65
  fi
}

resolve_phase_dir() {
  local raw_phase="$1"
  local padded_phase=""
  if printf '%s' "$raw_phase" | grep -Eq '^[0-9]+$'; then
    padded_phase="$(printf '%02d' "$raw_phase")"
  fi

  find .planning/phases -maxdepth 1 -type d \
    \( -name "${raw_phase}-*" -o -name "${padded_phase}-*" \) \
    | sort \
    | head -n 1
}

load_phase_context() {
  if [ -z "$PHASE_ID" ]; then
    usage
    exit 64
  fi

  if [ ! -f .planning/STATE.md ]; then
    die "Missing .planning/STATE.md. Run /gsd:new-project first." 66
  fi

  PHASE_DIR="$(resolve_phase_dir "$PHASE_ID")"
  if [ -z "${PHASE_DIR:-}" ]; then
    die "Could not find a phase directory for phase ${PHASE_ID} under .planning/phases/." 67
  fi
}

build_ready_queue() {
  PLAN_FILES=()
  while IFS= read -r plan_file; do
    PLAN_FILES+=("$plan_file")
  done < <(
    find "$PHASE_DIR" -maxdepth 1 -type f -name '*.md' \
      ! -name '*CONTEXT.md' \
      ! -name '*UAT.md' \
      ! -name 'SUMMARY.md' \
      | sort
  )

  if [ "${#PLAN_FILES[@]}" -eq 0 ]; then
    die "No runnable plan files found in ${PHASE_DIR}." 68
  fi
}

ensure_worker_workspace() {
  local worker_id="$1"
  local worker_dir="runtime/workers/worker-${worker_id}"
  local worker_branch="${BASE_BRANCH}__w${worker_id}"

  mkdir -p "$worker_dir"

  if [ ! -d "${worker_dir}/.git" ] && [ ! -f "${worker_dir}/.git" ]; then
    log "Preparing worktree for worker ${worker_id} on ${worker_branch}"
    git worktree add --force -B "$worker_branch" "$worker_dir" "$BASE_BRANCH" >/dev/null 2>&1 || {
      log "Worktree creation failed for worker ${worker_id}; keeping manifest-only mode."
      return
    }
  fi
}

write_checkpoint() {
  local worker_id="$1"
  local plan_file="$2"
  local status="$3"
  local checkpoint_file="runtime/checkpoints/phase-${PHASE_ID}-worker-${worker_id}.json"
  local heartbeat_file="runtime/logs/worker-${worker_id}.heartbeat"
  local task_id
  task_id="$(basename "$plan_file" .md)"

  date '+%Y-%m-%dT%H:%M:%S%z' > "$heartbeat_file"

  cat > "$checkpoint_file" <<EOF
{
  "task_id": "${task_id}",
  "phase_id": "${PHASE_ID}",
  "worker_id": "${worker_id}",
  "branch": "${BASE_BRANCH}",
  "worktree": "runtime/workers/worker-${worker_id}",
  "plan_file": "${plan_file}",
  "status": "${status}",
  "dispatched_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "dry_run": ${DRY_RUN}
}
EOF
}

package_failure() {
  local worker_id="$1"
  local plan_file="$2"
  local reason="$3"
  local task_id
  task_id="$(basename "$plan_file" .md)"

  cat > "queue/failed/${task_id}.md" <<EOF
# Failed Task Package

- Phase: ${PHASE_ID}
- Worker: ${worker_id}
- Plan: ${plan_file}
- Reason: ${reason}
- Suggested next step: Inspect runtime/checkpoints/phase-${PHASE_ID}-worker-${worker_id}.json and retry with /execute-codex-phase or /codex-status.
EOF

  write_checkpoint "$worker_id" "$plan_file" "failed"
}

dispatch_task() {
  local worker_id="$1"
  local plan_file="$2"
  local runner_script="${CODEX_RUNNER_SCRIPT:-}"

  ensure_worker_workspace "$worker_id"

  if [ -n "$runner_script" ] && [ "$DRY_RUN" = "0" ]; then
    log "Dispatching $(basename "$plan_file") to worker ${worker_id} via ${runner_script}"
    if "$runner_script" "$PHASE_ID" "$plan_file" "runtime/workers/worker-${worker_id}"; then
      write_checkpoint "$worker_id" "$plan_file" "dispatched"
    else
      package_failure "$worker_id" "$plan_file" "External runner failed."
    fi
  else
    log "Prepared manifest for worker ${worker_id}: $(basename "$plan_file")"
    write_checkpoint "$worker_id" "$plan_file" "manifest-only"
  fi
}

run_wave_validation() {
  log "Running wave reconciliation for phase ${PHASE_ID}"
  bash scripts/reconcile-wave.sh "$PHASE_ID"
}

main() {
  ensure_runtime_dirs
  ensure_branch_guard
  load_phase_context
  build_ready_queue

  log "Phase directory: ${PHASE_DIR}"
  log "Assigning up to ${MAX_WORKERS} workers"

  local worker_id=1
  local assigned=0

  for plan_file in "${PLAN_FILES[@]}"; do
    dispatch_task "$worker_id" "$plan_file"
    assigned=$((assigned + 1))
    worker_id=$((worker_id + 1))
    if [ "$worker_id" -gt "$MAX_WORKERS" ]; then
      worker_id=1
    fi
  done

  log "Prepared ${assigned} plan assignment(s)"
  run_wave_validation
}

main "$@"
