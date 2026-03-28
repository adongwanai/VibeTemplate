---
phase: 01-template-smoke
plan: 02
objective: Exercise the manifest-first runtime path and produce worker checkpoints.
wave: 1
requirements:
  - EXEC-01
  - EXEC-02
  - RECV-01
  - RECV-02
files_modified:
  - runtime/checkpoints/
  - runtime/logs/
  - queue/failed/
---

# Plan 01-02: Runtime Smoke

## Goal

Run the phase executor in safe mode so a new operator can see how the runtime behaves before a real Codex runner is attached.

## Tasks

1. Ensure the current branch is not `main`
2. Run `bash scripts/execute-codex-phase.sh 1`
3. Inspect `runtime/checkpoints/`
4. Inspect `runtime/logs/`
5. Inspect `queue/failed/`

## Verification

- `bash scripts/execute-codex-phase.sh 1`
- `bash scripts/reconcile-wave.sh 1`

## Notes

The sample path is allowed to stay manifest-first. It is demonstrating structure, not full autonomous implementation.
