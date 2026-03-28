# CLAUDE.local.md — 个人专属配置（不共享）

> 此文件不入 git，放你个人的偏好设置。

## 我的工作习惯

- 偏好中文回复
- 喜欢 ASCII 图解架构
- 每次会话结束前必须审查进度

## 常用介入信号

| 我说 | 意思 |
|------|------|
| "继续" | 执行下一批任务 |
| "停" | 立即停止，查看 queue/failed/ |
| "调整" | 方向需要调整 |
| "审查" | 我要看看当前进度 |

## 我的禁止事项

- 不要自动运行 `npm publish`
- 不要自动合并 PR
- 不要修改 `.env` 文件
- 不要跳过测试直接 commit

## 上下文防腐烂设置

- 会话上下文 > 50% 时提醒我 `/compact`
- 每 10 个任务后自动归档 `progress.txt` 到 `continue/archive/`

## Git Worktrees（并行开发）

```bash
# 创建并行工作树
git worktree add ../my-feature feature-branch
git worktree add ../my-fix fix-branch
# 在不同 terminal 中运行 Claude Code
```
