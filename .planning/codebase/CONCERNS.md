# Concerns

## Overall Verdict

The repository is close to being a ready-to-use workflow template, but it is not yet a fully proven autonomous system.

## Main Concerns

### 1. Sample State Is Demonstration State

The repository now includes a real sample `.planning/STATE.md` and a sample phase.

That improves onboarding, but it is still demonstration state. For a real project, the operator should still replace it by running:

- `/gsd:new-project`

### 2. Execution Layer Is Still Early-Stage

`scripts/execute-codex-phase.sh` can now dispatch into a real Codex starter runner through:

- `scripts/codex-runner-example.sh`

That closes the biggest gap, but the runtime is still early-stage because:

- scheduling is still simple round-robin, not true dependency-aware orchestration
- worktree creation may fail in constrained environments and then fall back to repo root
- wave reconciliation is stronger than task execution semantics

### 3. Placeholder Build Tooling

`package.json` still uses placeholder scripts for:

- `typecheck`
- `build`
- `lint`

This is acceptable for a template repository, but it means green checks do not represent real application compilation or linting.

### 4. Example Phase Is Structural, Not Productive

The sample phase under `.planning/phases/01-template-smoke/` proves the structure and runtime path, but it is not a business feature and it does not prove full autonomous coding.

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

1. Add a documented `CODEX_RUNNER_SCRIPT` example.
2. Decide whether to keep or trim the legacy generate/review commands.
3. Add one end-to-end example proving the operator flow from bootstrap to verification on a toy app.
