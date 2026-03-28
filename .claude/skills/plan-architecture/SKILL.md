---
name: plan-architecture
description: Design architecture and create detailed implementation plan. Invoke when user wants to plan a new feature, system, or complex refactoring.
argument-hint: [feature-name]
user-invocable: true
model: opus
---

# Plan Architecture Skill

This skill guides architecture design and implementation planning.

## When to Use

- User wants to plan a new feature
- System redesign or refactoring needed
- Architectural decision required
- Complex multi-phase implementation

## Instructions

### 1. Clarify Requirements

Ask user clarifying questions if needed:
- What is the core functionality?
- What are the constraints?
- What tech stack/preferences?
- What is the priority?

### 2. Design Architecture

Create ASCII diagram showing:
- Components and their relationships
- Data flow between components
- API endpoints (if applicable)
- Database schema (if applicable)

### 3. Document Decisions

For each major decision:
- What are the options?
- What did you choose and why?
- What are the trade-offs?

### 4. Create Phased Plan

Divide implementation into phases:
- Each phase should be completable in 1-2 sessions
- Each phase has specific tasks
- Each phase has a test gate

### 5. Output Format

```markdown
# Architecture Plan: [Feature Name]

## Overview
[Brief description of what we're building]

## Architecture
[ASCII diagram]

## Key Decisions
- [Decision 1]: [Choice] — [Rationale]
- [Decision 2]: [Choice] — [Rationale]

## Implementation Phases

### Phase 1: [Name]
**Goal**: [What this achieves]
**Tasks**:
- [ ] [Task 1]
- [ ] [Task 2]
**Test Gate**: [How to verify completion]

### Phase 2: [Name]
...

## Files to Create/Modify
| File | Action |
|------|--------|
| src/... | Create |
| src/... | Modify |

## Complexity
[low | medium | high]
```

## Important Notes

- Keep plan under 500 lines
- Focus on actionable tasks
- Test gates should be verifiable
- Consider edge cases in planning
- Save plan to `plans/{feature-name}.md`
