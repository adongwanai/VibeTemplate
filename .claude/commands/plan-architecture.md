---
description: Design architecture and create detailed implementation plan for a feature or system
model: opus
---

# Plan Architecture Command

Design architecture and create a detailed implementation plan.

## When to Use

- New feature development
- System redesign
- Complex refactoring
- Any task requiring architectural decisions

## Workflow

### Step 1: Understand Requirements

Ask clarifying questions using AskUserQuestion if the request is ambiguous:
- Functional requirements
- Non-functional requirements (performance, scale, etc.)
- Constraints (deadline, tech stack, team size)
- Priority order

### Step 2: Architecture Design

Design the system architecture:
- Component diagram (ASCII art)
- Data flow
- API design
- Database schema (if applicable)
- Key decisions and trade-offs

### Step 3: Phased Plan

Create implementation plan with phases and test gates:

```markdown
## Implementation Plan: [Feature Name]

### Phase 1: Foundation
- Tasks: [list]
- Test Gate: [verification criteria]

### Phase 2: Core Feature
- Tasks: [list]
- Test Gate: [verification criteria]

### Phase 3: Polish
- Tasks: [list]
- Test Gate: [verification criteria]
```

### Step 4: Output to Plans Directory

Save the plan to `plans/{feature-name}.md`

## Output Summary

Provide:
- Architecture diagram
- Key decisions with rationale
- Phased implementation plan
- Test gates for each phase
- Estimated complexity (low/medium/high)

## Example

Input: "Add user authentication to our app"
Output: Complete architecture design with JWT/OAuth decision, database schema, API endpoints, and 3-phase implementation plan
