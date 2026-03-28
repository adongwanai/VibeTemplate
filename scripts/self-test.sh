#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

FAILURES=0

pass() {
  printf '✅ %s\n' "$1"
}

fail() {
  printf '❌ %s\n' "$1"
  FAILURES=$((FAILURES + 1))
}

require_file() {
  local path="$1"
  if [ -f "$path" ]; then
    pass "file exists: $path"
  else
    fail "missing file: $path"
  fi
}

run_check() {
  local label="$1"
  shift
  if "$@"; then
    pass "$label"
  else
    fail "$label"
  fi
}

printf 'Running hybrid template self-test...\n'

run_check "template smoke test" npm test
run_check "hooks compile" python3 -m py_compile .claude/hooks/scripts/hooks.py

for path in \
  .planning/PROJECT.md \
  .planning/REQUIREMENTS.md \
  .planning/ROADMAP.md \
  .planning/STATE.md \
  .planning/config.json \
  .planning/phases/01-template-smoke/01-CONTEXT.md \
  .planning/phases/01-template-smoke/01-01-validate-sample-state.md \
  .planning/phases/01-template-smoke/01-02-runtime-smoke.md \
  .planning/phases/01-template-smoke/01-UAT.md \
  .claude/commands/execute-codex-phase.md \
  .claude/commands/codex-status.md \
  .claude/skills/recover-failed-wave/SKILL.md \
  .claude/skills/self-test-template/SKILL.md \
  scripts/bootstrap-gsd.sh \
  scripts/start-new-project.sh \
  scripts/clean-runtime.sh \
  scripts/codex-runner-example.sh \
  scripts/execute-codex-phase.sh \
  scripts/reconcile-wave.sh \
  scripts/watchdog.sh \
  templates/codex-task.md \
  templates/codex-fix.md \
  templates/codex-verify.md \
  queue/failed/.gitkeep \
  queue/pending-review/.gitkeep \
  runtime/logs/.gitkeep \
  runtime/checkpoints/.gitkeep
do
  require_file "$path"
done

if grep -q 'docs/plans/\*.md' .gitignore; then
  fail ".gitignore still blocks docs/plans markdown files"
else
  pass "docs/plans markdown files are versionable"
fi

run_check "plansDirectory matches docs/plans" node -e "const fs=require('fs'); const settings=JSON.parse(fs.readFileSync('.claude/settings.json', 'utf8')); process.exit(settings.plansDirectory === './docs/plans' ? 0 : 1)"
run_check "GSD config defaults to yolo + auto_advance + parallelization" node -e "const fs=require('fs'); const cfg=JSON.parse(fs.readFileSync('.planning/config.json','utf8')); const ok=cfg.mode==='yolo' && cfg.parallelization===true && cfg.workflow && cfg.workflow.auto_advance===true; process.exit(ok?0:1)"

if [ "$FAILURES" -eq 0 ]; then
  printf 'Hybrid template self-test passed.\n'
else
  printf 'Hybrid template self-test failed with %s issue(s).\n' "$FAILURES"
  exit 1
fi
