# Testing

## Current Testing Surface

The repository currently uses template-level smoke testing rather than application-level testing.

Primary files:

- `test-template.js`
- `scripts/self-test.sh`

## What Is Actually Verified

### `npm test`

Runs `node test-template.js` and checks:

- required file presence
- JSON validity
- Python hook compilation
- `plansDirectory` consistency
- `.gitignore` not blocking `docs/plans/`

### `bash scripts/self-test.sh`

Checks:

- `npm test`
- hook compilation again
- presence of critical runtime/command/skill/template files
- `.gitignore` plan-file safety
- `plansDirectory` correctness

## Coverage Strength

For a workflow template, current coverage is good enough to catch:

- missing files
- path drift
- config drift
- hook syntax errors

## Coverage Gaps

The following are not yet tested:

- real GSD initialization flow
- actual `.planning/STATE.md` creation through a live command
- real worker worktree creation against an initialized phase
- actual Codex execution through a runner
- end-to-end example project bootstrap

## Readiness Take

This is enough to say the repository is structurally usable as a template, but not yet fully proven as an end-to-end autonomous runtime.
