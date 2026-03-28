# CLAUDE.md — Hybrid GSD + Codex 144h Template

## Purpose

This template is designed for a cost-aware workflow:

- `GSD` owns project state, phases, roadmap, and verification.
- `Codex` owns most implementation work.
- `Claude` stays on planning, review, escalation, and verification boundaries.

The goal is to keep Claude off the per-task hot path while still using it where judgment matters.

## Default Model Split

| System | Responsibility |
|--------|----------------|
| `GSD` | `.planning/` state, phase planning, progress, UAT |
| `Claude` | command surface, architecture decisions, escalation, verification |
| `Codex` | implementation, retries, local validation, worker execution |

## Canonical Flow

```text
/gsd:new-project
/gsd:plan-phase <phase>
/execute-codex-phase <phase>
/gsd:verify-work <phase>
```

Use Superpowers around the edges:

- `superpowers:brainstorming`
- `superpowers:writing-plans`
- `superpowers:executing-plans`
- `superpowers:finishing-a-development-branch`

## Branch Safety

- Never run implementation on `main`.
- Create or reuse a phase branch before Codex execution.
- Worker work must stay inside isolated worktrees.
- Formal project state lives in `.planning/STATE.md`.

## Runtime Defaults

- Balanced autonomy
- Up to 4 Codex worker slots
- Failed tasks go to `queue/failed/`
- Worker manifests go to `runtime/checkpoints/`
- Watchdog and reconciliation live under `scripts/`
- Permissions default to maximum openness for both Claude and Codex in this template

## Constitutional Rules

### Core Rule: Do Not Stall

- 遇到歧义时，选最合理方案，记录假设，继续
- 遇到报错时，先自动重试，再决定是否降级或入队
- 不要停下来等一句“继续”
- 不要频繁把局部问题升级成人类阻塞

### Error Handling

- 命令报错先重试最多 3 次
- 同类问题修不动时写入 `queue/failed/`
- wave 级验证持续失败时再升级给 Claude

### Default Technical Choices

- 包管理器默认 `npm`
- 规划默认走 GSD
- 执行默认走 Codex runner
- 验证默认先局部，再 wave，再 phase

### Permission Posture

- Claude project settings default to fully open Bash permissions
- Codex runner defaults to `--dangerously-bypass-approvals-and-sandbox`
- 只有在你主动改环境变量时才降回较保守模式

## Recovery Rules

If something goes wrong:

1. Check `.planning/STATE.md`
2. Check `queue/failed/`
3. Check `runtime/checkpoints/`
4. Check `runtime/logs/`
5. Use the recovery skill instead of rebuilding context from memory

## Verification Rules

- Task-level validation happens inside worker execution
- Wave-level validation happens in `scripts/reconcile-wave.sh`
- Phase-level validation happens through `gsd:verify-work`
- The template itself must pass `bash scripts/self-test.sh`

## Fast Start

```bash
bash scripts/bootstrap-gsd.sh
```

Then in Claude Code:

```text
/gsd:new-project
/gsd:plan-phase 1
/execute-codex-phase 1
```
