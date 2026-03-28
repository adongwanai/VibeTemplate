---
name: generate-with-codex
description: Generate code using Codex (GPT-5.4) via MCP tools. Use when implementing features, refactoring, or batch code modifications.
argument-hint: [intensity] [description]
user-invocable: true
model: sonnet
mcpServers:
  - codex
---

# Generate with Codex Skill

This skill invokes Codex for code generation via MCP tools.

## When to Use

- Implementing features from a plan
- Refactoring existing code
- Batch modifications across multiple files
- Writing tests
- Converting code between languages

## Intensity Levels

| Level | Use Case | Speed vs Quality |
|-------|----------|------------------|
| `low` | Quick fixes, typos, small changes | Fast, good |
| `medium` | Regular features, standard refactoring | Balanced |
| `high` | Complex features, architecture work | Quality first |

## Instructions

### Step 1: Check MCP Availability

Try to use Codex MCP tools:
- `mcp__codex__codex_exec` — Execute code generation

If MCP not available, fall back to Bash:
```bash
codex exec "..."
```

### Step 2: Prepare Prompt for Codex

Structure the prompt clearly:
```
Implement [feature] following this spec:

## Requirements
- [requirement 1]
- [requirement 2]

## Files to Create/Modify
- src/xxx.ts — Create with [description]
- src/yyy.ts — Modify to add [description]

## Coding Style
- TypeScript strict mode
- No mutation (immutable patterns)
- Error handling required
- Tests required

## Context
[Relevant existing code or patterns to follow]
```

### Step 3: Invoke Codex

**Via MCP (preferred):**
Use the `codex_exec` MCP tool with the structured prompt.

**Via Bash fallback:**
```bash
codex exec "Your detailed prompt here"
```

### Step 4: Process Output

1. Parse Codex's generated code
2. Review for obvious issues
3. Apply changes to files
4. Verify with type checking
5. Run tests

### Step 5: Error Handling

If Codex generates problematic code:
- Report specific issues to user
- Ask Codex to fix specific problems
- Manual intervention if needed

## Codex Model Selection

| Intensity | Model | Reasoning |
|-----------|-------|-----------|
| low | gpt-5-fast | Quick, less reasoning |
| medium | gpt-5.4 | Balanced |
| high | gpt-5.4-high | Maximum reasoning |

## Gotchas

- Always review Codex output before applying
- Codex may miss project-specific conventions
- Check generated code compiles before committing
- Type errors from Codex are common — fix before proceeding
