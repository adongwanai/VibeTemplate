#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

PHASE_ID="${1:-}"
SLEEP_SECONDS="${WATCHDOG_INTERVAL_SECONDS:-5}"
STALE_SECONDS="${WATCHDOG_STALE_SECONDS:-300}"
MAX_FAILURES="${WATCHDOG_MAX_FAILURES:-3}"
CURRENT_WORKERS="${MAX_CODEX_WORKERS:-4}"
FAILURES=0

log() {
  printf '[watchdog] %s\n' "$1"
}

die() {
  printf '[watchdog] ERROR: %s\n' "$1" >&2
  exit "${2:-1}"
}

check_stale_heartbeats() {
  local now stale_found=0
  now="$(date +%s)"

  for heartbeat in runtime/logs/worker-*.heartbeat; do
    [ -e "$heartbeat" ] || continue
    local modified
    modified="$(date -r "$heartbeat" +%s)"
    if [ $((now - modified)) -gt "$STALE_SECONDS" ]; then
      log "Stale heartbeat detected: ${heartbeat}"
      stale_found=1
    fi
  done

  return "$stale_found"
}

main() {
  if [ -z "$PHASE_ID" ]; then
    die "Usage: bash scripts/watchdog.sh <phase-id>" 64
  fi

  while true; do
    log "Starting phase ${PHASE_ID} with ${CURRENT_WORKERS} worker slot(s)"
    if MAX_CODEX_WORKERS="$CURRENT_WORKERS" bash scripts/execute-codex-phase.sh "$PHASE_ID"; then
      FAILURES=0
    else
      exit_code=$?
      if [ "$exit_code" -ge 64 ] && [ "$exit_code" -le 68 ]; then
        die "Fatal setup error from execute-codex-phase.sh (exit ${exit_code})." "$exit_code"
      fi

      FAILURES=$((FAILURES + 1))
      log "Execution failed (${FAILURES}/${MAX_FAILURES})"
    fi

    if check_stale_heartbeats; then
      log "All worker heartbeats are fresh"
    else
      FAILURES=$((FAILURES + 1))
    fi

    if [ "$FAILURES" -ge "$MAX_FAILURES" ]; then
      if [ "$CURRENT_WORKERS" -gt 1 ]; then
        CURRENT_WORKERS=$((CURRENT_WORKERS - 1))
        FAILURES=0
        log "Reducing concurrency to ${CURRENT_WORKERS} after repeated failures"
      else
        die "Watchdog reached maximum failures with one worker remaining." 70
      fi
    fi

    sleep "$SLEEP_SECONDS"
  done
}

main "$@"
