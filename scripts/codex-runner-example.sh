#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

PHASE_ID="${1:?phase id required}"
PLAN_FILE="${2:?plan file required}"
WORKTREE_DIR="${3:?worktree dir required}"

TASK_ID="$(basename "$PLAN_FILE" .md)"
CODEX_SANDBOX="${CODEX_SANDBOX:-workspace-write}"
CODEX_MODEL="${CODEX_MODEL:-}"
CODEX_PROFILE="${CODEX_PROFILE:-}"
OUTPUT_FILE="${ROOT_DIR}/runtime/logs/${TASK_ID}.codex.txt"
EXEC_CWD="$WORKTREE_DIR"
EXECUTION_MODE="worktree"

log() {
  printf '[codex-runner] %s\n' "$1"
}

case "$CODEX_SANDBOX" in
  seatbelt)
    CODEX_SANDBOX="workspace-write"
    ;;
esac

if [ ! -d "${WORKTREE_DIR}/.git" ] && [ ! -f "${WORKTREE_DIR}/.git" ]; then
  EXEC_CWD="$ROOT_DIR"
  EXECUTION_MODE="root-fallback"
  log "Assigned worktree is unavailable; falling back to repo root."
fi

mkdir -p "${ROOT_DIR}/runtime/logs"

PROMPT_FILE="$(mktemp "${TMPDIR:-/tmp}/codex-runner-prompt.XXXXXX.md")"
cleanup() {
  rm -f "$PROMPT_FILE"
}
trap cleanup EXIT

cat > "$PROMPT_FILE" <<EOF
You are executing a planned phase in a repository that uses GSD for planning and Codex for implementation.

Phase: ${PHASE_ID}
Plan file: ${PLAN_FILE}
Assigned worktree: ${WORKTREE_DIR}
Execution directory: ${EXEC_CWD}
Execution mode: ${EXECUTION_MODE}

Read these files first:
- ${PLAN_FILE}
- .planning/PROJECT.md
- .planning/STATE.md
- README.md

Rules:
- Stay on the current branch.
- Never switch branches.
- Never create commits.
- Keep changes minimal and inside the plan's intended file scope.
- Run the plan's verification commands when possible.
- If execution mode is root-fallback, be extra conservative with file changes.

Your final response must include:
1. Files changed
2. Commands run
3. Whether verification passed
4. Any blockers
EOF

CODEX_CMD=(codex exec --full-auto --sandbox "$CODEX_SANDBOX" -C "$EXEC_CWD" -o "$OUTPUT_FILE")

if [ -n "$CODEX_MODEL" ]; then
  CODEX_CMD+=(-m "$CODEX_MODEL")
fi

if [ -n "$CODEX_PROFILE" ]; then
  CODEX_CMD+=(-p "$CODEX_PROFILE")
fi

log "Running Codex for ${TASK_ID} in ${EXEC_CWD}"
"${CODEX_CMD[@]}" - < "$PROMPT_FILE"
log "Codex response saved to ${OUTPUT_FILE}"
