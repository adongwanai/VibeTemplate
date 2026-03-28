#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

PHASE_ID="${1:-}"

log() {
  printf '[reconcile-wave] %s\n' "$1"
}

die() {
  printf '[reconcile-wave] ERROR: %s\n' "$1" >&2
  exit "${2:-1}"
}

ensure_branch_guard() {
  local current_branch
  current_branch="$(git branch --show-current 2>/dev/null || true)"
  if [ "$current_branch" = "main" ] || [ "$current_branch" = "master" ]; then
    die "Refusing to reconcile from ${current_branch}. Use a phase branch." 65
  fi
}

collect_worker_diffs() {
  local report_file="runtime/logs/phase-${PHASE_ID}-reconcile.txt"
  : > "$report_file"

  for worker_dir in runtime/workers/worker-*; do
    [ -e "$worker_dir" ] || continue

    printf '## %s\n' "$worker_dir" >> "$report_file"
    if [ -d "${worker_dir}/.git" ] || [ -f "${worker_dir}/.git" ]; then
      git -C "$worker_dir" diff --name-only --relative >> "$report_file" || true
    else
      printf '(no worktree)\n' >> "$report_file"
    fi
    printf '\n' >> "$report_file"
  done

  log "Wrote diff report to ${report_file}"
}

detect_overlap() {
  local overlap_output
  overlap_output="$(
    for worker_dir in runtime/workers/worker-*; do
      [ -e "$worker_dir" ] || continue
      if [ -d "${worker_dir}/.git" ] || [ -f "${worker_dir}/.git" ]; then
        git -C "$worker_dir" diff --name-only --relative
      fi
    done | sort | uniq -d
  )"

  if [ -n "$overlap_output" ]; then
    printf '%s\n' "$overlap_output" > "runtime/logs/phase-${PHASE_ID}-overlap.txt"
    die "Detected overlapping writes. See runtime/logs/phase-${PHASE_ID}-overlap.txt." 69
  fi
}

has_npm_script() {
  local script_name="$1"
  node -e "const fs=require('fs'); const pkg=JSON.parse(fs.readFileSync('package.json','utf8')); process.exit(pkg.scripts && pkg.scripts['${script_name}'] ? 0 : 1)"
}

run_validation() {
  local candidate

  for candidate in typecheck test build lint; do
    if has_npm_script "$candidate"; then
      log "Running npm run ${candidate}"
      npm run "$candidate"
    fi
  done

  if [ -f scripts/self-test.sh ]; then
    log "Running bash scripts/self-test.sh"
    bash scripts/self-test.sh
  fi
}

main() {
  if [ -z "$PHASE_ID" ]; then
    die "Usage: bash scripts/reconcile-wave.sh <phase-id>" 64
  fi

  ensure_branch_guard
  mkdir -p runtime/logs
  collect_worker_diffs
  detect_overlap
  run_validation
  log "Wave reconciliation complete for phase ${PHASE_ID}"
}

main "$@"
