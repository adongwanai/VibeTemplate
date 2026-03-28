#!/usr/bin/env bash

set -euo pipefail

PHASE_ID="${1:?phase id required}"
PLAN_FILE="${2:?plan file required}"
WORKTREE_DIR="${3:?worktree dir required}"

cat <<EOF
[codex-runner-example] This is an example runner hook.
[codex-runner-example] Phase: ${PHASE_ID}
[codex-runner-example] Plan: ${PLAN_FILE}
[codex-runner-example] Worktree: ${WORKTREE_DIR}

To make this real, replace this script body with your preferred Codex invocation.

Example idea:
  codex exec --cwd "${WORKTREE_DIR}" "\
Read ${PLAN_FILE}.
Follow the task requirements exactly.
Stay on the assigned branch and worktree.
Run local verification and report changed files."
EOF
