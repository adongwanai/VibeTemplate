# Roadmap: Hybrid Template Demo

## Overview

这个 roadmap 不是产品路线图，而是模板演示路线图。它的目的是证明仓库从 sample planning 到 sample execution 的路径可以走通，并为真实项目初始化提供最小参照。

## Phases

- [ ] **Phase 1: Template Smoke Flow** - 用 sample state 和 sample phase 验证模板的最小可执行路径

## Phase Details

### Phase 1: Template Smoke Flow
**Goal**: 提供一个最小 phase，让操作者可以看到 GSD 状态、phase plan、Codex 运行时入口如何协同工作。
**Depends on**: Nothing (first phase)
**Requirements**: PLAN-01, PLAN-02, EXEC-01, EXEC-02, EXEC-03, RECV-01, RECV-02
**Success Criteria** (what must be TRUE):
  1. 操作者可以看到完整的 sample `.planning` 状态文件
  2. 在非 `main` 分支运行 phase 执行入口时，会生成 checkpoint 或 manifest
  3. 自测命令和 phase 级 smoke run 都能给出可理解结果
**Plans**: 2 plans

Plans:
- [ ] 01-01: Validate sample planning state and operator docs
- [ ] 01-02: Run manifest-first execution smoke path and reconcile output

## Progress

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Template Smoke Flow | 0/2 | Not started | - |
