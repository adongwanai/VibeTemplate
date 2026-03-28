# Architecture

## Overview

VibeTemplate is a branch-oriented workflow repository rather than a single app template.

`main` is the landing page. The real templates live in dedicated branches with different execution defaults.

## Branch Model

### `main`

- navigation branch
- explains branch selection
- documents workflow recommendations

### `template/gsd-default`

- GSD-native default execution
- best fit for stable product delivery
- uses GSD as planning, execution, progress, and verification spine

### `template/claude-codex-default`

- Claude/GSD for planning and verification
- Codex bridge for default execution
- best fit for cost-sensitive, high-iteration solo work

### `template/standalone-readiness`

- experimentation branch
- intended for more aggressive automation ideas

## Responsibility Split

### GSD

- project initialization
- `.planning/` state and roadmap
- phase planning
- execution orchestration
- verification and progress tracking

### superpowers

- requirement clarification
- design exploration
- implementation plan refinement
- optional quality gates
- branch finishing workflows

### Claude

- command surface
- high-level reasoning
- escalation handling
- final review and validation

### Codex

- implementation-heavy execution
- repetitive code generation
- optional bridge execution path where configured

## Why This Split Exists

The repository intentionally avoids making GSD and superpowers compete for the same responsibility.

- GSD is the project skeleton
- superpowers is the methodology and quality booster

## Design Principle

Humans steer. Agents execute. Repository docs are the system of record.
