# Conventions

## Documentation Style

- Workflow and command surfaces are documented in Markdown.
- Important operating rules are written as direct instructions instead of loose prose.
- File and command names are generally explicit and operator-oriented.

## Git and Branching

The most important convention is:

- do not execute implementation on `main`

This is reinforced in:

- `.claude/rules/git-workflow.md`
- `CLAUDE.md`
- `scripts/execute-codex-phase.sh`
- `scripts/reconcile-wave.sh`

## Shell Script Style

Common shell conventions:

- `set -euo pipefail`
- `ROOT_DIR` normalization at the top of the script
- helper functions like `log()` and `die()`
- readable exit codes for setup failures

## Template Validation

Two validation layers are used:

- `test-template.js` for structural smoke testing
- `scripts/self-test.sh` for full template readiness checks

## State Model Convention

- `.planning/STATE.md` is the formal state source
- `continue/` is the operator-facing handoff layer
- `queue/failed/` is the default landing zone for repeat failures

## Areas That Need Stronger Convention

- There is no formal JSON/YAML schema for worker checkpoint files yet.
- There is no enforced format for phase plan task metadata like `deps` or `files_expected`.
- The runtime is still convention-led rather than parser-led.
