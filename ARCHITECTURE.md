# Architecture

## Overview

This branch is the GSD-native default workflow template.

The design goal is simple:

- use GSD as the project skeleton
- use superpowers as the design and quality booster
- keep Codex available, but not as the default execution spine

## Primary Execution Model

The branch assumes this path:

```text
/gsd:new-project
/gsd:plan-phase N
/gsd:execute-phase N
/gsd:verify-work N
```

## Responsibility Split

### GSD

- project initialization
- `.planning/` state
- phase planning
- phase execution
- progress and verification

### superpowers

- brainstorming before implementation
- writing finer-grained plans when needed
- extra review and branch completion workflows

### Claude

- high-level reasoning
- architectural tradeoffs
- escalation handling

### Codex

- optional implementation acceleration
- advanced fallback through the bridge path

## Why This Branch Exists

It is the least surprising branch:

- fewer moving parts
- fewer custom runtime assumptions
- closest to upstream GSD behavior

## Design Principle

Humans steer. GSD orchestrates. Agents execute.
