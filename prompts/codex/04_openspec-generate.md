---
type: ai-instruction
audience: ai
language: en
tags:
  - ai-only
  - agent
  - codex
  - prompt
---

# OpenSpec Generate

## Purpose

Generate an implementation-neutral, developer-facing OpenSpec-style change specification.

## When To Use

Use after Domain Spec review and before Plan or implementation approval.

## Inputs

- Feature: `{{FEATURE_NAME}}`
- Domain Spec: `{{SPEC_DIR}}`
- Framework root: `{{FRAMEWORK_REPOSITORY_ROOT}}`
- Target project root: `{{TARGET_PROJECT_ROOT}}`
- Output: `{{OUTPUT_DIR}}`

## Instructions

1. Select Framework Repository or Target Project Repository output mode.
2. Write traceable requirements and Given/When/Then scenarios.
3. Add acceptance criteria, impacted APIs, impacted DB/query areas, migration compatibility notes, and non-goals.
4. Preserve policy decisions and Open Questions explicitly.
5. Ensure Target Project output is understandable without Personal Obsidian.

## Required Output

- Requirements and scenarios
- Acceptance criteria
- Impacted API and DB/query areas
- Migration compatibility notes
- Non-goals and Open Questions
- Requirement-to-scenario traceability

## Constraints

- Do not write implementation code.
- Do not hide unresolved policy decisions.
- Do not claim unverified behavior.

## Safety Rules

Do not include internal secrets or personal absolute paths. Sanitize reusable examples.

## Codex Execution Report

Report output mode, traceability coverage, unresolved decisions, and `Implementation: Not Performed`.
