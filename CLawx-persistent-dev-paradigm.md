# ClawX 持久化开发范式 - Gotchas

>
> 基于 70+ 个 Session、300+ 条测试的实战经验。
>
> ## Gotcha: Skills 容易踩坑的地方
>
> ### 1. 表 append-only
`progress.txt` 只追加，从不删除或修改历史记录。
> **为什么**: Claude 容易"忘记"之前的状态，导致重复工作。
>
> ### 2. 字段一致性
`task.json` 的 `current_focus` 必须与 `tasks` 数组中的 task `id` 匹配
> **修复**: 使用 YAML 验证脚本或启动时检查
>
> ### 3. 状态跳跃
Claude 可能跳过 `brainstorming` 直接到 `in_progress`
> **修复**: 在 AGENT.MD 中明确禁止
>
> ### 4. Git 提交时机
每个任务完成后立即 commit，> **为什么**: checkpoint 是 Claude 的"记忆"，但 commit 时机太晚会打断流畅
>
> ### 5. 上下文窗口
每个会话保持上下文 < 50%
> **为什么**: Claude 会"忘记"早期讨论的内容
>
> ## 最佳实践
>
> 1. **Skills 文件夹结构**: 使用 references/、 scripts/、 examples/ 子目录
> 2. **描述触发条件**: 写"什么时候触发"而非"功能摘要"
> 3. **渐进披露**: 不一次性加载所有内容
> 4. **Helper 脚本**: 让 Claude 调用而非手写
>
> ## Hooks 示例
>
> **Post-edit hook**: 自动 format代码
> **Pre-destructive hook**: 拦截危险命令
> **Stop hook**: 提醒验证和提交
