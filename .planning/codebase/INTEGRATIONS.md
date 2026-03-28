# Integrations

## Summary

The template integrates primarily with local developer tooling rather than remote services.

## Local Tool Integrations

### Claude Code

Primary Claude-facing integration points:

- `.claude/settings.json`
- `.claude/commands/*.md`
- `.claude/skills/*/SKILL.md`
- `.claude/rules/*.md`

These define the command surface and runtime behavior expected inside Claude Code.

### Codex

The template assumes `codex` is available on the machine and may be wired through MCP:

- `.mcp.json`
- `README.md`
- `CLAUDE.md`

The runtime scripts do not directly call Codex yet. Instead, they create the execution shell, manifest, and reconciliation points needed for Codex-backed execution.

### GSD

The template is designed around GSD-generated state:

- `.planning/`
- `.planning/phases/`
- `docs/plans/`

Expected command flow:

- `/gsd:new-project`
- `/gsd:plan-phase`
- `/gsd:verify-work`

## External Services

No external API, database, auth provider, webhook, or cloud integration is implemented in this repository.

## Missing Integration Surface

There is no implemented bridge yet that programmatically launches Codex workers from `scripts/execute-codex-phase.sh`. Current execution is manifest-first and runner-hook-ready, not fully automated Codex invocation.

## Practical Readiness

As a local workflow template, integrations are sufficient to get started.

As a fully autonomous production orchestrator, one more layer is still missing:

- either a Codex runner integration
- or a documented operator loop that consumes the generated manifests
