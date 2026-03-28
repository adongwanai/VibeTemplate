# 🛡️ GSD 原生工作流版 (最稳推荐)

![Branch](https://img.shields.io/badge/Branch-gsd--default-success?style=flat-square)
![Status](https://img.shields.io/badge/Stability-Production_Ready-blue?style=flat-square)

> **✨ 这是你启动新业务最稳妥的选择！**  
> 在这条分支上，所有的规划、执行、验证闭环都通过 **原生 GSD (`get-shit-done-cc`)** 来完成。不引入额外的执行中间层，系统状态清晰、可恢复、且具有最顺滑的 144h 不断更体验。

---

## 🏗️ 架构定位与职责划分
在这个体验中最突出的是完全融入 GSD 宇宙，分工极其明确：
- 🧠 **Claude (大脑)**：进行高强度的架构设计、需求细化、阻塞时的人工升级对话，并统筹全局进度的认知。
- ⚙️ **GSD (躯干)**：负责推进具体的 `.planning/PROJECT.md` 生命周期，自动划分 Phase，原生地执行代码、发起 Wave 级别任务调度并完成 UAT 验收。

---

## 🛠️ 第一步：前置能力准备
为了享受最极致的自动化快感，你需要有以下的利器做担保。

### 1. 全局安装 GSD
```bash
npx get-shit-done-cc@latest --claude --codex --global
```
> *(本模板内置了 `.planning/config.json`，已开启 `yolo` 全速并发模式)*

### 2. 必备的 Claude Skills
在终端启动 Claude Code 前，装好这些环境装备（如果你是做漂亮的前端/跨界应用，也不要错过下面的附加项）：
```bash
# 必装：GSD 及强大的规划与收尾能力
claude plugins install superpowers

# 可选但极度推荐：UI/UX 设计巅峰审美
npx skills add vercel-labs/agent-skills --skill frontend-design
npx skills add nextlevelbuilder/ui-ux-pro-max-skill
```

---

## 🚀 第二步：极速立项与启动 (10行代码闯天下)

这是最通用的 1-2-3-4 流程。没有心智负担，没有过度复杂：

### 📌 1. 新项目初始化
先清理模板，把名字刻进系统的核心。
```bash
bash scripts/start-new-project.sh "超级项目名称" "一句话形容你即将改变世界的宏大愿景"
```

### 📌 2. 在 Claude Code 召唤守护神
打开交互端并让系统生成强劲的分析大纲（包含 `PROJECT.md`, `ROADMAP.md`, `STATE.md`）：
```text
/gsd:new-project
```

### 📌 3. 原力觉醒：干活循环 (The Execution Loop)
对于该模板，接下来的每次迭代，只要重复输入这个节奏就行了（假设是第一个阶段 Phase 1）：
```text
/gsd:plan-phase 1     # 👉 [拆解] 把愿景撕成小小的待办
/gsd:execute-phase 1  # 👉 [落地] 全自动原生代码生成器出场！
/gsd:progress         # 👉 [观察] 喝水，看看当前卡在哪里
/gsd:verify-work 1    # 👉 [结案] UAT 验收并清理战场
```

然后，你可以进入下一次轮回： Phase 2、Phase 3...

---

## 💡 自动化监控与自检秘招

即使你离开电脑去洗澡，它也不能停！

🕵️ **定期询问进度（挂机利器）**
```text
/loop 10m /gsd:progress
```

🧯 **Shell 端独立守护不死进程**
```bash
bash scripts/watchdog.sh 1
```

✅ **启动自测检查**  
*(跑真实项目前跑一边求安稳)*
```bash
bash scripts/self-test.sh
```

---

## 🦾 黑科技：本地 Codex 控制桥（高级可选降级）
虽然这条分支主打纯 GSD 体验。但如果你中途由于 Claude 额度受限或其他原因，你想把具体实现的执行交棒给更廉价的本地 Codex，该分支依然保留了这个能力接口：
```bash
CODEX_DRY_RUN=0 CODEX_RUNNER_SCRIPT=./scripts/codex-runner-example.sh bash scripts/execute-codex-phase.sh 1
```
*(注：执行桥是子分支 `template/claude-codex-default` 的唯一真神，如果你频繁这样用，建议去切换那条分支！)*
