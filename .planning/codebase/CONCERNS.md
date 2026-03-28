# Concerns

## Overall Verdict

The repository is close to being a ready-to-use workflow template, but it is not yet a fully proven autonomous system.

## Main Concerns

### 1. No Real `.planning/STATE.md` Yet

The runtime correctly refuses to execute without `.planning/STATE.md`.

That is good for safety, but it also means the current repo is a template shell until the operator runs:

- `/gsd:new-project`

### 2. Execution Layer Is Manifest-First

`scripts/execute-codex-phase.sh` prepares worker manifests and worktree slots, but does not yet directly run Codex unless an external runner is supplied through `CODEX_RUNNER_SCRIPT`.

That means:

- the execution architecture is in place
- the fully automated worker bridge is not yet implemented

### 3. Placeholder Build Tooling

`package.json` still uses placeholder scripts for:

- `typecheck`
- `build`
- `lint`

This is acceptable for a template repository, but it means green checks do not represent real application compilation or linting.

### 4. No Example Phase

There is no sample `.planning/phases/01-*/` directory showing a live runnable phase. That makes onboarding slightly less concrete.

### 5. Partial Legacy Surface Remains

There are still legacy files in `.claude/` related to older Codex workflows, such as:

- `.claude/commands/generate-with-codex.md`
- `.claude/skills/generate-with-codex/SKILL.md`

They do not block usage, but they may confuse a new operator unless clearly documented as secondary.

## What Still Makes It Usable

- independent git repo can be initialized locally
- README and command surface explain the intended flow
- branch guard exists
- runtime scaffold exists
- self-test passes
- recovery directories exist

## Recommended Next Hardening Steps

1. Add a sample initialized phase under `.planning/phases/`.
2. Add a documented `CODEX_RUNNER_SCRIPT` example.
3. Decide whether to keep or trim the legacy generate/review commands.
4. Add one end-to-end example proving the operator flow from bootstrap to verification.
