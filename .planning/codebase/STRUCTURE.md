# Structure

## Top-Level Layout

- `.claude/` — Claude Code commands, skills, rules, settings
- `.planning/` — GSD state and codebase mapping
- `continue/` — operator handoff state
- `docs/plans/` — design and implementation plans
- `queue/` — failed and pending review task packages
- `runtime/` — worker checkpoints, logs, and worktree roots
- `scripts/` — shell entrypoints for bootstrap, execute, reconcile, watchdog, self-test
- `templates/` — Codex prompt templates
- `test-template.js` — Node-based smoke test
- `package.json` — npm script surface

## Important Directories

### `.claude/`

Key paths:

- `.claude/commands/24h-loop.md`
- `.claude/commands/execute-codex-phase.md`
- `.claude/commands/codex-status.md`
- `.claude/rules/git-workflow.md`
- `.claude/settings.json`

### `.planning/`

Currently contains:

- `.planning/codebase/STACK.md`
- `.planning/codebase/INTEGRATIONS.md`
- `.planning/codebase/ARCHITECTURE.md`
- `.planning/codebase/STRUCTURE.md`
- `.planning/codebase/CONVENTIONS.md`
- `.planning/codebase/TESTING.md`
- `.planning/codebase/CONCERNS.md`

The repository does not yet contain a real `.planning/STATE.md`, so it is not yet an initialized project instance.

### `scripts/`

Execution-oriented shell commands:

- `scripts/bootstrap-gsd.sh`
- `scripts/execute-codex-phase.sh`
- `scripts/reconcile-wave.sh`
- `scripts/watchdog.sh`
- `scripts/self-test.sh`

### `runtime/`

Reserved runtime paths:

- `runtime/checkpoints/`
- `runtime/logs/`
- `runtime/workers/`

## Naming Conventions

- command files use kebab-case markdown names
- skill directories use kebab-case names with `SKILL.md`
- runtime scripts use kebab-case shell file names
- plan documents use date-prefixed filenames in `docs/plans/`

## Practical Readability

The repository is organized well enough for a new operator to navigate quickly. The main missing structure is a concrete example phase under `.planning/phases/`.
