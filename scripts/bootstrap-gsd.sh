#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

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

printf 'Bootstrap complete.\n'
printf 'Recommended next commands:\n'
printf '  1. /gsd:new-project\n'
printf '  2. /gsd:plan-phase 1\n'
printf '  3. /execute-codex-phase 1\n'
