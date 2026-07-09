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

# Legacy Discover

## Purpose

Document the observed legacy behavior of `{{FEATURE_NAME}}` without turning it into an approved Target requirement.

## When To Use

Use after human feature selection and before Specify.

## Inputs

- Legacy root/scope: `{{LEGACY_SCOPE}}`
- Feature: `{{FEATURE_NAME}}`
- Output: `{{OUTPUT_DIR}}`
- Optional framework rules: `{{VALIDATOR_RULES_DIR}}`

## Instructions

1. Keep the legacy repository read-only.
2. Record search scope and files inspected.
3. Trace API/UI entry points, call flow, DB/query map, status values, error behavior, and external dependencies.
4. Separate Confirmed Rules, Inferred Rules, and Open Questions.
5. Give every rule an Evidence Status and Implementation Permission.
6. Flag sensitive information without copying the value.

## Required Output

- Legacy Discover document
- API entry points and call flow
- DB/query map and state/status values
- External dependencies
- Rule table with evidence and permission
- Risks, sensitive-information warning, and Open Questions

## Constraints

- Do not implement.
- Do not convert Legacy behavior into Target policy.
- Do not close Open Questions.

## Safety Rules

Do not expose credentials, server addresses, production DB names, private tokens, or raw sensitive evidence.

## Codex Execution Report

Report inspected files, evidence limits, unresolved blockers, and `Implementation: Not Performed`.
