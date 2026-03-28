---
phase: 01-template-smoke
plan: 01
objective: Validate the sample planning state and operator-facing docs.
wave: 1
requirements:
  - PLAN-01
  - PLAN-02
  - EXEC-03
files_modified:
  - .planning/PROJECT.md
  - .planning/REQUIREMENTS.md
  - .planning/ROADMAP.md
  - .planning/STATE.md
---

# Plan 01-01: Validate Sample State

## Goal

Confirm the sample `.planning` state is internally consistent and readable by an operator or downstream runtime.

## Tasks

1. Read `.planning/PROJECT.md`
2. Read `.planning/REQUIREMENTS.md`
3. Read `.planning/ROADMAP.md`
4. Read `.planning/STATE.md`
5. Confirm phase, requirements, and status language match

## Verification

- `npm test`
- `bash scripts/self-test.sh`

## Notes

This plan is intentionally documentation-heavy because the sample phase exists to demonstrate structure rather than ship a product feature.
