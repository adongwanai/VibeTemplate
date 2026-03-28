# Reliability

## Current Reliability Model

This repository aims to be dependable as a workflow template, not yet a fully proven zero-touch 144h autonomous system.

## What Is Checked Today

Use:

```bash
bash scripts/self-test.sh
```

That script verifies:

- required files exist
- Python hooks compile
- `.planning/config.json` contains automation-friendly defaults
- `README.md` still contains branch navigation and workflow guidance
- core paths such as `docs/plans/` remain versionable

## Runtime Artifacts

- `runtime/checkpoints/` — task and worker manifests
- `runtime/logs/` — runtime logs and heartbeats
- `queue/failed/` — failed task packages
- `queue/pending-review/` — waiting for human review

These paths are operational state, not source-of-truth design docs.

## Recovery Model

If execution goes wrong, inspect in this order:

1. `.planning/STATE.md`
2. `queue/failed/`
3. `runtime/checkpoints/`
4. `runtime/logs/`

## Operational Limits

- `template/gsd-default` is the safest default branch
- `template/claude-codex-default` is more aggressive and cost-optimized, but carries more bridge complexity
- Codex bridge execution is usable, but still not equivalent to a fully native GSD executor stack
- fully unattended 144h operation still depends on environment stability, login state, quotas, and network conditions

## Recommended Reliability Practice

- prefer the GSD-native branch unless you have a clear reason not to
- use superpowers to clarify and plan before execution
- keep `README.md`, `CLAUDE.md`, and `AGENTS.md` aligned
- run self-test before publishing or forking the template
