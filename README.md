# VibeTemplate

这个仓库不是单一模板，而是一个**双模板导航仓库**。

`main` 分支只负责一件事：

- 告诉你该选哪条模板分支

真正用于项目启动的模板在下面两条分支里。

## 选哪条分支

### 1. `template/gsd-default`

适合：

- 你更看重稳定
- 你想尽量复用 GSD 原生能力
- 你不想维护自定义执行桥
- 你希望 phase / commit / SUMMARY / STATE / verify 都走同一套原生链路

默认主流程：

```text
/gsd:new-project
/gsd:plan-phase N
/gsd:execute-phase N
/gsd:verify-work N
```

推荐给：

- 正式产品项目
- 团队协作项目
- 长期维护项目
- 第一次使用这套模板的人

### 2. `template/claude-codex-default`

适合：

- 你明确想走 `Claude → Codex`
- 你想让 `Codex` 成为默认执行面
- 你更看重模型成本和执行效率
- 你愿意接受有一层自定义 bridge

默认主流程：

```text
/gsd:new-project
/gsd:plan-phase N
/execute-codex-phase N
/gsd:verify-work N
```

推荐给：

- 个人项目
- Agent / 自动化类项目
- 快速迭代项目
- 明确想把 `Codex` 当主执行器的人

## 最简单的选择规则

- 不确定选哪个：`template/gsd-default`
- 明确要 `Claude 规划 + Codex 干活`：`template/claude-codex-default`

## 怎么切到对应分支

### GSD 默认流

```bash
git switch template/gsd-default
```

### Claude → Codex 默认流

```bash
git switch template/claude-codex-default
```

## 推到本地后怎么开始

进入你选定的分支之后，看该分支自己的 `README.md`。

每条分支上都已经有：

- 上手指南
- skills 安装建议
- 新项目启动流程
- 长时间运行说明

## 仓库结构说明

- `main`
  - 导航页
  - 只负责说明怎么选模板

- `template/gsd-default`
  - GSD 原生默认执行流

- `template/claude-codex-default`
  - Claude 规划，Codex 默认执行流

## 推荐默认分支

如果你只是想把仓库发出去给别人看，`main` 就保持为默认分支。

如果你自己以后主要使用其中一套，再手动切到对应模板分支即可。
