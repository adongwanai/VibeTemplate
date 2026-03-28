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

## 推荐主流程

如果你不想在两套流里反复纠结，推荐先从 `template/gsd-default` 开始。

这条是当前最稳、最标准、最容易长期维护的主流程。

### 阶段 0：新项目起步

先切到：

```bash
git switch template/gsd-default
```

然后在新项目目录执行：

```bash
bash scripts/start-new-project.sh "项目名" "一句话目标"
```

再进入 Claude Code。

### 阶段 1：把模糊想法说清楚

如果你的需求还很模糊，比如：

> 我想做一个桌面 Agent APP

先用 `superpowers` 做前置澄清：

- `superpowers:brainstorming`

如果是 UI 很重的项目，再补：

- `frontend-design`
- 你装的 UI/UX skills
- 浏览器自动化相关 skill

这一层的目标不是写代码，而是把需求讲明白。

### 阶段 2：把项目正式立起来

需求清楚后，用 GSD 进入正式项目流：

```text
/gsd:new-project
```

这一步会生成：

- `.planning/PROJECT.md`
- `.planning/REQUIREMENTS.md`
- `.planning/ROADMAP.md`
- `.planning/STATE.md`

这几个文件以后就是项目大脑。

### 阶段 3：拆 phase

然后：

```text
/gsd:plan-phase 1
```

如果 phase 比较复杂，前面已经用过的 `superpowers:writing-plans` 可以继续辅助思考，但主输出还是让 GSD 管 phase。

### 阶段 4：执行

默认执行用：

```text
/gsd:execute-phase 1
```

这是主流程，不是 `/execute-codex-phase`。

因为这条路线已经固定成：

- `GSD` 负责主执行骨架
- `superpowers` 负责前置思考和质量增强
- `Codex runner` 是高级可选桥接，不是默认入口

### 阶段 5：看进度

中途想看状态：

```text
/gsd:progress
```

如果你真在用高级 Codex bridge，才看：

```text
/codex-status
```

### 阶段 6：验收

phase 执行完后：

```text
/gsd:verify-work 1
```

这是默认验收入口。

如果你还想加一层更严格质量门，再补：

- `superpowers:requesting-code-review`
- `superpowers:verification-before-completion`

### 阶段 7：收尾

分支收尾时用：

- `superpowers:finishing-a-development-branch`

## 一句话记忆法

主干靠 GSD：

```text
/gsd:new-project
/gsd:plan-phase N
/gsd:execute-phase N
/gsd:verify-work N
/gsd:progress
```

想法模糊时先上：

- `superpowers:brainstorming`

## 什么时候用 `execute-codex-phase`

只有一种情况：

你明确想绕开 GSD 默认执行器，直接把 phase 丢给本地 `codex exec runner`。

也就是说，这条是进阶分支能力，不是默认入口。

## 最短版本

如果你只想记最短版本，就记这个：

1. `start-new-project.sh`
2. 模糊需求先 `superpowers:brainstorming`
3. 正式立项用 `/gsd:new-project`
4. phase 用 `/gsd:plan-phase`
5. 执行用 `/gsd:execute-phase`
6. 验收用 `/gsd:verify-work`
7. 需要额外质量门时再用 `superpowers`

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
