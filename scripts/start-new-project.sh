#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

PROJECT_NAME="${1:-MyProject}"
OBJECTIVE="${2:-Build and ship the project.}"
ARCHIVE_DIR=".template-demo"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

log() {
  printf '[start-new-project] %s\n' "$1"
}

archive_demo_planning() {
  mkdir -p "$ARCHIVE_DIR"

  if [ -d .planning ]; then
    mv .planning "${ARCHIVE_DIR}/planning-${TIMESTAMP}"
    log "Archived demo .planning to ${ARCHIVE_DIR}/planning-${TIMESTAMP}"
  fi
}

reset_runtime_state() {
  rm -rf runtime/checkpoints runtime/logs runtime/workers
  mkdir -p runtime/checkpoints runtime/logs runtime/workers
  : > runtime/checkpoints/.gitkeep
  : > runtime/logs/.gitkeep
}

main() {
  archive_demo_planning
  reset_runtime_state
  bash scripts/bootstrap-gsd.sh
  bash init-continue.sh "$PROJECT_NAME" "$OBJECTIVE"

  log "Template is ready for a real project."
  log "Next step in Claude Code: /gsd:new-project"
}

main "$@"
