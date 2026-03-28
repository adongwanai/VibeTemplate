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
- `/execute-codex-phase`
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

默认权限策略：

- Claude 项目配置已经默认放开最大 Bash 权限
- Codex runner 默认使用最大权限执行
- 如果你想要更保守模式，需要你自己显式改回去

## 建议安装的 Skills

关键原则：

- `Claude Code` 和 `Codex` 两边都要装核心 skills
- 不要只给 Claude 装，Codex 不装
- 尤其是规划、前端设计、浏览器自动化这类能力，最好两边环境都准备好

### 1. GSD 工作流

建议先把 GSD 装到本机：

```bash
npx get-shit-done-cc@latest --claude --codex --global
```

这个模板默认就是围绕 GSD 的 `.planning/`、phase、verify-work 来组织的。

模板还自带默认 GSD 配置：

- `mode: yolo`
- `parallelization: true`
- `workflow.auto_advance: true`
- `git.branching_strategy: phase`

见 [config.json](/Users/mac/Desktop/2026-money/opc/my-template/.planning/config.json)。

### 2. Superpowers

如果你走这个模板的推荐流，`superpowers` 基本属于必装。

Claude Code：

```bash
claude plugins install superpowers
```

如果你更喜欢显式安装，也可以按 skill 装：

```bash
claude skill add superpowers:brainstorming
claude skill add superpowers:writing-plans
claude skill add superpowers:executing-plans
claude skill add superpowers:finishing-a-development-branch
```

Codex：

```bash
codex skill add superpowers:brainstorming
codex skill add superpowers:writing-plans
codex skill add superpowers:executing-plans
codex skill add superpowers:finishing-a-development-branch
```

### 3. 前端设计 / 审美增强 / 浏览器自动化

如果你做的是前端项目，建议至少准备下面这几类能力。

| Skill | 用途 | 安装命令 | 来源 |
|------|------|----------|------|
| Browser / Playwright 浏览器自动化 | 打开网页、点击、填表、截图、做网页 smoke test | 建议安装一个你常用的 browser automation / Playwright skill，并在 Claude Code 与 Codex 两边都装上 | 依所选 skill 而定 |
| `frontend-design` | 创建独特、高设计品质的前端界面，避免 AI 味太重 | `npx skills add vercel-labs/agent-skills --skill frontend-design` | Vercel / Anthropic |
| UI/UX Pro Max | 提升 AI 审美，补充更强的 UI 风格、配色、字体参考 | `npx skills add nextlevelbuilder/ui-ux-pro-max-skill` | nextlevelbuilder |

说明：

- 上面这类第三方 skills，建议 `Claude Code` 和 `Codex` 两边都装
- 如果你的环境里已经有 `agent-browser`、Playwright skill 或其他浏览器自动化 skill，也建议两边保持一致
- 这个模板本身不强绑定某一个前端 skill，但强烈建议你把设计和浏览器自动化能力预先装好

## 快速开始

### 1. 初始化模板目录

```bash
bash scripts/bootstrap-gsd.sh
bash init-continue.sh "MyProject" "Build and ship the project"
```

如果你是把这个仓库当模板复制出来做一个真实新项目，推荐直接用：

```bash
bash scripts/start-new-project.sh "MyProject" "Build and ship the project"
```

这个脚本会：

- 归档模板自带的 sample `.planning`
- 清空 sample runtime 状态
- 重新生成适合真实项目的初始目录
- 然后让你可以安全地跑 `/gsd:new-project`

### 2. 在 Claude Code 中开始

```text
/gsd:new-project
/gsd:plan-phase 1
/execute-codex-phase 1
/codex-status
/gsd:verify-work 1
```

### 3. 用内置 sample state 试跑

仓库已经自带最小可演示的 `.planning` 状态：

- [PROJECT.md](/Users/mac/Desktop/2026-money/opc/my-template/.planning/PROJECT.md)
- [REQUIREMENTS.md](/Users/mac/Desktop/2026-money/opc/my-template/.planning/REQUIREMENTS.md)
- [ROADMAP.md](/Users/mac/Desktop/2026-money/opc/my-template/.planning/ROADMAP.md)
- [STATE.md](/Users/mac/Desktop/2026-money/opc/my-template/.planning/STATE.md)
- [01-template-smoke](/Users/mac/Desktop/2026-money/opc/my-template/.planning/phases/01-template-smoke)

如果你只是想验证模板 wiring，不想先自己规划 phase，可以直接在非 `main` 分支运行：

```bash
bash scripts/execute-codex-phase.sh 1
```

这会走模板保留的高级 Codex bridge 路径，帮助你看到 checkpoint、日志和 reconcile 的输出结构。注意，这不是默认主流程。

## 极简操作手册

如果你以后每次开新项目都不想重新思考流程，就按这 10 行来：

### 新项目

```bash
bash scripts/start-new-project.sh "项目名" "一句话目标"
```

然后在 Claude Code 里：

```text
/gsd:new-project
/gsd:plan-phase 1
/execute-codex-phase 1
/codex-status
/gsd:verify-work 1
```

接着继续下一轮：

```text
/gsd:plan-phase 2
/execute-codex-phase 2
/gsd:verify-work 2
```

### 只看进度

```text
/codex-status
```

### 只做长期监控

```text
/loop 10m /codex-status
```

### 如果你明确要走本地 Codex bridge

```bash
CODEX_DRY_RUN=0 \
CODEX_RUNNER_SCRIPT=./scripts/codex-runner-example.sh \
bash scripts/execute-codex-phase.sh 1
```

这条不是默认主流程，只是高级可选。

## 这个项目目前支持一直跑吗？

支持，但要分情况理解。

### 已经支持的

- 用 `GSD` 做 phase 级持续推进
- 用 `/loop 10m /gsd:progress` 做长期轮询
- 用 `watchdog.sh` 做 shell 侧守护
- 用 `.planning/STATE.md`、`queue/failed/`、`runtime/` 做恢复

### 当前最推荐的“一直跑”方式

默认推荐：

```text
/gsd:new-project
/gsd:plan-phase N
/gsd:execute-phase N
/gsd:verify-work N
```

配合：

```text
/loop 10m /gsd:progress
```

或者 shell 侧：

```bash
bash scripts/watchdog.sh 1
```

### 还没完全到位的

- 高级 `Codex bridge` 路径还不是默认主流程
- `codex-runner-example.sh` 已经可用，但更适合作为桥接层，不是替代 GSD 原生执行
- 真正意义上的“完全无人值守 144h”还要靠你的环境稳定性、账号登录态、网络、模型额度一起保证

所以最准确的说法是：

- **作为模板工作流，已经支持长期持续运行**
- **作为零人工干预的 144h 全自动系统，还属于可用但未完全验证到极限的状态**

## 以后新开发项目怎么做

推荐你每次都按这个顺序：

1. 复制这个模板仓库
2. 进入新仓库后运行：

```bash
bash scripts/start-new-project.sh "你的项目名" "一句话目标"
```

3. 在 Claude Code 里执行：

```text
/gsd:new-project
```

4. 让 GSD 生成真实项目的 `PROJECT.md / ROADMAP.md / STATE.md`
5. 接着执行：

```text
/gsd:plan-phase 1
/execute-codex-phase 1
/codex-status
/gsd:verify-work 1
```

简化理解就是：

- 模板仓库自带 sample state 只用于演示
- 真实项目一开始就先跑 `start-new-project.sh`
- 然后用 `/gsd:new-project` 生成你自己的正式状态

## 标准工作流

这是一个以 `phase` 为核心的流程，默认走 `Claude → Codex` 执行。

```text
/gsd:new-project
→ 生成 .planning/PROJECT.md / ROADMAP.md / STATE.md

/gsd:plan-phase 1
→ 把 phase 拆成 plan 文件

/execute-codex-phase 1
→ 读取 phase plan
→ 分配给 Codex worker / runner
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

## Codex Runner 接入（默认执行层）

默认推荐你使用 `Claude → Codex` 这层 bridge：

当前执行层已经带了一个可直接调用 `codex exec` 的 runner：

- [codex-runner-example.sh](/Users/mac/Desktop/2026-money/opc/my-template/scripts/codex-runner-example.sh)

如果你想让执行器真正自动调 Codex，可以这样跑：

```bash
CODEX_DRY_RUN=0 \
CODEX_RUNNER_SCRIPT=./scripts/codex-runner-example.sh \
bash scripts/execute-codex-phase.sh 1
```

这个脚本现在会真实调用 `codex exec`，并且默认走最大权限模式。

它的默认行为：

- 优先在分配到的 worker worktree 中执行
- 如果 worktree 不可用，会自动回退到仓库根目录执行
- 不会自动 commit
- 会把 Codex 最后一条响应写入 `runtime/logs/<task>.codex.txt`
- 默认使用 `--dangerously-bypass-approvals-and-sandbox`

如果你想定制模型或 profile，可以加环境变量：

```bash
CODEX_MODEL=gpt-5.4 \
CODEX_PROFILE=default \
CODEX_DRY_RUN=0 \
CODEX_RUNNER_SCRIPT=./scripts/codex-runner-example.sh \
bash scripts/execute-codex-phase.sh 1
```

如果你想把 Codex runner 临时降回较保守模式：

```bash
CODEX_PERMISSION_MODE=safe \
CODEX_SANDBOX=workspace-write \
CODEX_DRY_RUN=0 \
CODEX_RUNNER_SCRIPT=./scripts/codex-runner-example.sh \
bash scripts/execute-codex-phase.sh 1
```

如果 sample run 之后想把运行时产物清掉：

```bash
bash scripts/clean-runtime.sh
```

## Backup / Secondary 命令面

`/gsd:execute-phase` 仍然保留，作为备用执行方案。

适用场景：

- 你更想要 GSD 原生 commit / SUMMARY / STATE 闭环
- 你不想走本地 `codex exec` bridge
- 你想把执行完全留在同一运行时体系里

除此之外，下面这些也仍然保留在仓库里，但不再是推荐主流程：

- `/gsd:execute-phase`
- `.claude/commands/generate-with-codex.md`
- `.claude/skills/generate-with-codex/SKILL.md`
- `.claude/commands/mutual-review.md`
- `.claude/skills/mutual-review/SKILL.md`

用途：

- `generate-with-codex`：适合临时小改、非 GSD phase 场景
- `mutual-review`：适合你明确想做额外双模型复审时

默认项目主流程仍然应该是：

```text
/gsd:new-project
/gsd:plan-phase N
/execute-codex-phase N
/gsd:verify-work N
```

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

- 它现在已经带了一个最小 sample `.planning` 状态，可用于演示
- 但第一次用于真实项目时，你仍然应该跑 `/gsd:new-project` 来生成属于你项目自己的状态

也就是说，当前状态已经适合：

- 作为模板仓库交付
- 作为新项目脚手架使用
- 作为 Claude 省成本、Codex 扛执行的工作流底座

但当前状态还不等于：

- 已经存在一个真实业务项目的 `.planning/STATE.md`
- 已经接入真实 Codex runner 并完成全自动执行

## 说明

- `.planning/STATE.md` 才是正式状态源
- `continue/` 只是操作者交接层
- `docs/plans/` 现在是可提交、可版本化的
- 实现必须从 feature/phase branch 开始，不能在 `main` 上直接跑
