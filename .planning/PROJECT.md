# Hybrid Template Demo

## What This Is

这是一个用于演示 `GSD 规划 + Codex 执行` 工作流的模板项目。它不是业务应用，而是一个可复用的项目骨架，目标是让新仓库能够快速进入 phase 规划、并发执行和恢复验证流程。

## Core Value

新项目可以在尽量少消耗 Claude 的前提下，快速进入结构化规划和可恢复的 Codex 执行流程。

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] 模板仓库具备 GSD 兼容的 `.planning/` 基础状态
- [ ] 模板仓库具备可演示的 phase 规划与执行入口
- [ ] 模板仓库具备分支保护、自测和失败恢复脚手架

### Out of Scope

- 真实业务功能实现 — 这个仓库是模板，不是产品
- 全自动 Codex 远程调度器 — 当前只提供运行时壳层和 runner hook

## Context

- 该模板面向 Claude Code + Codex 的混合工作流
- 重点解决长时间执行、低成本规划和失败恢复问题
- 当前仓库自带 sample `.planning` 状态，用于演示和 smoke run

## Constraints

- **Branching**: 实现不得在 `main` 上执行 — 避免模板项目直接污染主分支
- **Runtime**: 运行时默认最多 4 个 Codex worker — 保持并发与冲突风险平衡
- **State**: `.planning/STATE.md` 是正式状态源 — `continue/` 只做交接

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| GSD 管规划，Codex 管执行 | 符合成本模型 | ✓ Good |
| 模板自带 sample phase | 让仓库可演示而不只是骨架 | ✓ Good |
| 保留 manifest-first 执行层 | 先把结构和恢复路径跑通 | ⚠️ Revisit |

---
*Last updated: 2026-03-28 after sample planning bootstrap*
