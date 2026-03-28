# 🦾 Claude 🧠 × Codex 🦾 混合流 (高阶极客专享)

![Branch](https://img.shields.io/badge/Branch-claude--codex--default-orange?style=flat-square)
![Status](https://img.shields.io/badge/Cost_Efficiency-Extreme-green?style=flat-square)

> **⚡ 这是为极致成本与自动化玩家准备的最短路径！**  
> 这是一个以 Phase 节点为核心的工作流。它剥离了常规执行环节的昂贵计费点：让 **Claude 仅作出神入化的顶层规划与验收判断**，把粗活与重复劳动交给 **无情的本地 Codex Runner**。

---

## 🎯 系统架构：各司其职的黄金搭档

在这个特殊的项目骨架中，两个灵魂控制着整个系统：
- 🧠 **Claude (你的首席架构师)**：负责 `/gsd:new-project` 生成蓝图，负责 `/gsd:plan-phase` 切割需求，更负责最后的 `/gsd:verify-work` 来为交付盖章验证。
- 🦾 **Codex (你的 007 打工人)**：负责所有 `execute-codex-phase` 环节。包含自动写代码、自动重试报错、局部验证。它是你的无限并发分身。

---

## 🛠️ 第一步：前置能力准备 (武装你的双环境)

因为有两个不同的 Agent 在接力，你**必须**在两套环境里都准备好对应的技能 (Skills)。

### 1. 基础依赖底座
不仅你的电脑要有 `get-shit-done-cc`，还要能跑通 `codex`：
```bash
# 装上 GSD 全局流
npx get-shit-done-cc@latest --claude --codex --global

# (可选进阶) 让 Claude 通过 MCP 直接命令 Codex：
claude mcp add --scope project codex -- codex mcp-server
```

### 2. 双重 Skills 注入
确保双方的认知对称：

**【给你的 Claude 装上大脑】**
```bash
claude plugins install superpowers
# 或者如果你喜欢手动点播：
claude skill add superpowers:brainstorming
claude skill add superpowers:writing-plans
claude skill add superpowers:finishing-a-development-branch
```

**【给你的 Codex 装上肌肉】**
```bash
codex skill add superpowers:brainstorming
codex skill add superpowers:writing-plans
codex skill add superpowers:executing-plans
```

> *(🌐 如果做前端界面，推荐给双方都配好 `agent-browser`, `frontend-design` 等扩展包！)*

---

## 🚀 第二步：启动你的无情印钞机

这 10 行命令，将深刻改变你交付项目的速度与成本结构。

### 📌 1. 激活项目骨架
清理冗余，赋予新项目真正的灵魂：
```bash
bash scripts/start-new-project.sh "核动力应用" "旨在打破常规的一氧化碳生成器"
```

### 📌 2. 在 Claude Code 让主脑连线
正式确立大脑的中枢矩阵（`PROJECT.md`, `ROADMAP.md`）：
```text
/gsd:new-project
```

### 📌 3. 执行闭环：降级落地的艺术
请将这套连招设为你的快捷键：
```text
/gsd:plan-phase 1         # 👉 [脑域] 让顶级大语言模型深思熟虑
/execute-codex-phase 1    # 👉 [肌肉] 轰鸣吧，本地执行桥接层！
/codex-status             # 👉 [观察] 喝咖啡，看看执行工人们卡在何处
/gsd:verify-work 1        # 👉 [脑域] 用最严格的眼光执行全量 UAT
```

Phase 1 打通之后，下一战就只剩 `plan-phase 2` 和 `execute-codex-phase 2` 的复读了。

---

## 💡 发动机微调 (Codex Runner 定制)

我们默认为你提供了一层超级简易的控制桥 `codex-runner-example.sh`。如果你对模型或权限有洁癖，可以通过环境变量直接劫持它。

🛡️ **想套上一层约束沙盒？**
```bash
CODEX_PERMISSION_MODE=safe \
CODEX_SANDBOX=workspace-write \
CODEX_DRY_RUN=0 \
CODEX_RUNNER_SCRIPT=./scripts/codex-runner-example.sh \
bash scripts/execute-codex-phase.sh 1
```

🔥 **你想让 Codex 直接换芯？(比方说用个 GPT-5.4 破境一下)**
```bash
CODEX_MODEL=gpt-5.4 \
CODEX_PROFILE=default \
bash scripts/execute-codex-phase.sh 1
```

---

## ✅ 发车前自测 (离线预检)

当你第一次拉下本模板，先跑一下系统自测：
```bash
bash scripts/self-test.sh
```

**万事具备，愿你能尽享大模型廉价执行力带来的无尽快感！🍻**
