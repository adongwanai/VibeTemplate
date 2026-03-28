# Stack

## Summary

This repository is a lightweight template project that combines:

- Claude project configuration under `.claude/`
- GSD-style planning artifacts under `.planning/` and `docs/plans/`
- shell runtime orchestration under `scripts/`
- Node-based self-test under `test-template.js`

## Languages and Runtimes

- JavaScript for `test-template.js`
- Bash for bootstrap and runtime orchestration in `scripts/*.sh`
- Markdown for command, skill, planning, and operator docs
- Python runtime dependency only for hook compilation validation via `python3 -m py_compile`

## Package and Tooling

Primary package definition is in `package.json`.

Available npm scripts:

- `npm test` → `node test-template.js`
- `npm run self-test` → `bash scripts/self-test.sh`
- `npm run typecheck` → placeholder echo command
- `npm run build` → placeholder echo command
- `npm run lint` → placeholder echo command

There are intentionally no external npm dependencies yet. This keeps the template minimal but also means build/lint/typecheck are placeholders rather than real project checks.

## Core Runtime Files

- `scripts/bootstrap-gsd.sh`
- `scripts/execute-codex-phase.sh`
- `scripts/reconcile-wave.sh`
- `scripts/watchdog.sh`
- `scripts/self-test.sh`

## Claude Project Surface

- `.claude/settings.json`
- `.claude/commands/24h-loop.md`
- `.claude/commands/execute-codex-phase.md`
- `.claude/commands/codex-status.md`
- `.claude/skills/execute-with-codex/SKILL.md`
- `.claude/skills/recover-failed-wave/SKILL.md`
- `.claude/skills/self-test-template/SKILL.md`

## Key Observations

- The repository is tool-driven rather than application-driven.
- It is currently usable as a template/workflow project, not as a product application.
- The runtime assumes GSD state will exist later in `.planning/STATE.md`, but does not create a real project state by itself.
