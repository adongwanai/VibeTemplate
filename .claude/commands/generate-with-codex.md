---
description: Generate code using Codex (GPT-5.4) via MCP tools. Use low/medium/high intensity.
model: sonnet
---

# Generate with Codex Command

Generate code using Codex (GPT-5.4) via MCP tools with intensity control.

## When to Use

- Implementing features from a plan
- Refactoring existing code
- Batch modifications across files
- Test generation

## Usage

```
/generate-with-codex [intensity] [description]
```

- `intensity`: low | medium | high (default: medium)
- `description`: What code to generate

## Workflow

### Step 1: Check MCP Availability

Check if Codex MCP is configured:
- If MCP available: Use `mcp__codex__codex_exec` tool
- If MCP unavailable: Use `codex exec "..."` via Bash

### Step 2: Prepare Context

Gather for Codex:
- Plan/spec document
- Relevant existing code
- File locations to modify
- Coding style requirements

### Step 3: Invoke Codex

Use appropriate intensity:

**Low (Quick Fixes)**
```bash
codex exec "Fix the bug in src/utils.ts: the function returns undefined"
```

**Medium (Regular Features)**
```bash
codex exec "Implement user authentication with JWT:
1. Create auth service in src/auth/service.ts
2. Add JWT token generation and validation
3. Create middleware in src/auth/middleware.ts
Follow the existing project structure and coding style."
```

**High (Complex Features)**
For high complexity, use the codex-executor agent instead:
- Use Agent tool with codex-executor agent
- Pass detailed spec
- Set appropriate intensity

### Step 4: Review & Apply

After Codex generates code:
1. Review generated code
2. Check for obvious issues
3. Apply changes to codebase
4. Run tests

## Fallback

If Codex MCP fails:
1. Show Codex output to user
2. Offer to apply changes manually
3. Log the issue for MCP troubleshooting

## Example

```
/generate-with-codex medium Add a cache layer to the API client

-> Codex generates cache.ts with TTL support
-> Review for type safety and edge cases
-> Apply to codebase
-> Run tests
```
