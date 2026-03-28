# Requirements: Hybrid Template Demo

**Defined:** 2026-03-28
**Core Value:** 新项目可以在尽量少消耗 Claude 的前提下，快速进入结构化规划和可恢复的 Codex 执行流程。

## v1 Requirements

### Planning

- [ ] **PLAN-01**: 仓库包含 GSD 兼容的 `PROJECT.md`、`REQUIREMENTS.md`、`ROADMAP.md`、`STATE.md`
- [ ] **PLAN-02**: 模板包含至少一个可演示的 phase 目录

### Execution

- [ ] **EXEC-01**: 操作者可以在非 `main` 分支上运行 phase 执行入口
- [ ] **EXEC-02**: 执行入口会生成 worker checkpoint 并进行 wave 级验证
- [ ] **EXEC-03**: 缺少状态或 phase 时会清晰失败，不会误执行

### Recovery

- [ ] **RECV-01**: 模板具备失败队列与运行时日志目录
- [ ] **RECV-02**: 模板具备 watchdog、自测和恢复 skill

## v2 Requirements

### Runtime

- **RUN-01**: 直接接入 Codex runner，无需额外环境变量
- **RUN-02**: 支持真实依赖图和写域调度

## Out of Scope

| Feature | Reason |
|---------|--------|
| 真实产品业务需求 | 这是模板仓库 |
| 生产级调度中心 | 当前阶段先做可演示、可上手 |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| PLAN-01 | Phase 1 | Pending |
| PLAN-02 | Phase 1 | Pending |
| EXEC-01 | Phase 1 | Pending |
| EXEC-02 | Phase 1 | Pending |
| EXEC-03 | Phase 1 | Pending |
| RECV-01 | Phase 1 | Pending |
| RECV-02 | Phase 1 | Pending |

**Coverage:**
- v1 requirements: 7 total
- Mapped to phases: 7
- Unmapped: 0 ✓

---
*Requirements defined: 2026-03-28*
*Last updated: 2026-03-28 after sample planning bootstrap*
