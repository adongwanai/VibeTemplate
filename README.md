# GSD + Codex 混合 144h 模板

这个模板只服务一个目标：让 `Claude` 少出场、只做高价值判断，让 `Codex` 便宜且长时间持续执行。

这里的职责划分是：

- `GSD` 负责项目状态、phase、roadmap、UAT
- `Codex` 负责大部分实现、重试和局部验证
- `Claude` 负责命令入口、规划、升级决策和最终验收

## 你能得到什么

- `.planning/`：正式的 GSD 项目状态目录
- `continue/`：面向操作者的交接和恢复记忆
- `scripts/`：bootstrap、执行、汇总、自测、watchdog
- `runtime/`：worker checkpoint、心跳、运行日志
- `queue/failed/`：失败任务包，不会悄悄丢失上下文
- 非 `main` 分支执行保护，避免直接在主分支上跑实现

## 成本模型

适合你这种“Claude 贵、Codex 便宜”的用法。

`Claude` 负责：

- `/gsd:new-project`
- `/gsd:plan-phase`
- `/gsd:verify-work`
- 架构决策
- 阻塞升级

`Codex` 负责：

- 代码实现
- 自动重试
- 局部验证
- 并发 worker 执行

## 前置条件

先确保你在 Claude Code 里有 GSD 和 Superpowers，再确保本机可用 `codex`。

建议具备这些 skills：

- `superpowers:brainstorming`
- `superpowers:writing-plans`
- `superpowers:executing-plans`
- `superpowers:finishing-a-development-branch`

如果你希望 Claude 通过 MCP 调 Codex，再执行：

```bash
claude mcp add --scope project codex -- codex mcp-server
```

## 快速开始

### 1. 初始化模板目录

```bash
bash scripts/bootstrap-gsd.sh
bash init-continue.sh "MyProject" "Build and ship the project"
```

### 2. 在 Claude Code 中开始

```text
/gsd:new-project
/gsd:plan-phase 1
/execute-codex-phase 1
/codex-status
/gsd:verify-work 1
```

## 标准工作流

这是一个以 `phase` 为核心的流程，不是旧式的“单 task 串行循环”。

```text
/gsd:new-project
→ 生成 .planning/PROJECT.md / ROADMAP.md / STATE.md

/gsd:plan-phase 1
→ 把 phase 拆成 plan 文件

/execute-codex-phase 1
→ 读取 phase plan
→ 分配给 Codex worker
→ 产出 checkpoint
→ 跑 wave 级验证

/codex-status
→ 看当前 phase、worker、失败任务、日志

/gsd:verify-work 1
→ 做 phase 级 UAT 验收
```

## 24 小时循环

在 Claude Code 里：

```text
/24h-loop 1
```

如果只想做监控：

```text
/loop 10m /codex-status
```

如果你要 shell 侧守护：

```bash
bash scripts/watchdog.sh 1
```

## 运行时行为

- 默认并发：4 个 Codex worker 槽位
- 执行保护：禁止在 `main` / `master` 上跑实现
- worker 隔离：`runtime/workers/worker-1..4`
- 失败策略：
  - 局部自动重试最多 2 次
  - 重复失败写入 `queue/failed/`
  - 只有不再是局部问题时才升级给 Claude

## 目录结构

```text
.planning/              # GSD 正式项目状态
continue/               # 会话交接和恢复记忆
docs/plans/             # 设计和实施计划
queue/failed/           # 失败任务包
queue/pending-review/   # 等待人工确认的项目
runtime/checkpoints/    # worker 分配和状态清单
runtime/logs/           # 心跳和汇总日志
scripts/                # bootstrap / execute / reconcile / watchdog / self-test
templates/              # Codex 的 task / fix / verify 模板
```

## 自测

在正式使用前，先跑：

```bash
bash scripts/self-test.sh
```

它会检查：

- 关键模板文件是否存在
- Python hooks 是否可编译
- `plansDirectory` 是否正确指向 `docs/plans`
- `.gitignore` 是否错误忽略了计划文件
- 当前模板 smoke test 是否通过

## 当前上手姿势

这个模板现在已经能作为“可上手的模板项目”使用，但要注意一件事：

- 它不是“零上下文一键即跑”
- 第一次真正进入执行前，你必须先跑 `/gsd:new-project`

也就是说，当前状态已经适合：

- 作为模板仓库交付
- 作为新项目脚手架使用
- 作为 Claude 省成本、Codex 扛执行的工作流底座

但当前状态还不等于：

- 已经存在一个真实业务项目的 `.planning/STATE.md`
- 已经有可直接执行的 phase plan

## 说明

- `.planning/STATE.md` 才是正式状态源
- `continue/` 只是操作者交接层
- `docs/plans/` 现在是可提交、可版本化的
- 实现必须从 feature/phase branch 开始，不能在 `main` 上直接跑
