# 🛸 Standalone Readiness (独立无人值守版)

![Branch](https://img.shields.io/badge/Branch-standalone--readiness-purple?style=flat-square)
![Status](https://img.shields.io/badge/Autonomy-144h_Unattended-red?style=flat-square)

> **⚠️ 警告：这是最高阶的实验性分支！**  
> 这个分支被设计为一个**完全独立运行、144h 无人干预的自动化试验田**。它封装了所有的看护机制、重试逻辑、异常恢复以及守护进程，彻底剥夺你的人工参与感，让 AI 自转发电机全马力运行。

---

## 🧬 设计哲学：让 AI 忘了你

与另外两个日常工作流不同，此分支的终极目标是**断开所有必须的"人在回路" (Human in the loop)**。

- 🧠 **Claude (大脑区)**：仅在绝对致命的代码级死胡同时才被拉起，进行“主治医师会诊”。
- 🤖 **Codex Workers (干活区)**：像工蜂一样多开实例，默默拉取 `.planning/` 里的阶段计划，并无休止地提交、校验、报错、自我救赎。
- 🛡️ **Watchdog (系统守护区)**：用 Bash 编写的铁血护卫进程。负责从死机、网络异常、Claude Token 爆仓等物理维度把系统一次次拉起。

---

## 🛠️ 第一步：前置能力准备 (给机器的重装甲)

在开启这台机器前，你必须保证全局依赖安装了最强版本。

### 1. 基础依赖底座
不仅你的电脑要有 `get-shit-done-cc`，还要能跑通 `codex`：
```bash
# 全局守护包
npx get-shit-done-cc@latest --claude --codex --global
```

### 2. 双重 Skills 注入
确保双方的认知对称。这是你能放任系统跑 144h 的关键安全带：

**【给你的 Claude 装上大脑】**
```bash
claude plugins install superpowers
```

**【给你的 Codex 装上肌肉】**
```bash
codex skill add superpowers:brainstorming
codex skill add superpowers:writing-plans
codex skill add superpowers:executing-plans
```

---

## 🚀 第二步：发射系统点火

因为追求全自动化，所以连招会更加激进暴力：

### 📌 1. 为 AI 擦除历史，注入目标
将一切重置为一个白板的新基座：
```bash
bash scripts/start-new-project.sh "全自动飞船应用" "我要它自己写完一个带支付接口的电商后端"
```

### 📌 2. 在 Claude Code 为它点亮引线
生成全套 `.planning/STATE.md` 机体框架，然后规划首个阶段：
```text
/gsd:new-project
/gsd:plan-phase 1
```

### 📌 3. 无情轮回开启 (`/24h-loop`)
一旦规划完毕初期的状态，就直接将油门踩到底，无需一步步手动调用 execute：
```text
/24h-loop 1
```

或者使用完全独立于 Claude 会话的 Shell 层守护进程：
```bash
bash scripts/watchdog.sh 1
```

从这一秒开始，除了看监控终端和 `queue/failed/`，你不再需要敲任何代码。如果你中途想主动看看进度：
```text
/loop 10m /codex-status
```

---

## 🧯 应急逃生与监控舱

自动化不等于放手不管，这套分支有着严密的故障处理库：
- 🚨 `queue/failed/`：每次自动抢救失败超过 3 次的死循环，都会在这里被强制剥离和冷冻，绝不会导致全盘覆灭。
- 📝 `runtime/logs/`：心跳监控。你可以通过这里看到 Codex 兵团当前正活跃在哪几个 Worktree 里。
- 🛑 `bash scripts/clean-runtime.sh`：如果系统真跑飞了或者僵死了，用这把指令锤把正在进行的脏运行时全数砸碎。

---

## ✅ 发车前自测 (生死预检)

千万记得，在此分支下，一点微小的环境报错在 144h 放大后都是致命的。
必须跑过：
```bash
bash scripts/self-test.sh
```

**自测通过了吗？戴好安全带，把电源打开，去享受长达一周不用写代码的“Vibecoding”旅程吧！🏎️💨**
