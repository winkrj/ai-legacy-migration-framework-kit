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

# Validate

## Purpose

Validate documentation, runtime evidence, or an approved implementation with explicit evidence.

## When To Use

Use only when validation scope and command permission are clear.

## Inputs

- Validation type: Documentation / Runtime / Implementation
- Specs: `{{SPEC_DIR}}`
- Target scope: `{{TARGET_SCOPE}}`
- Validator rules: `{{VALIDATOR_RULES_DIR}}`
- Output: `{{OUTPUT_DIR}}`

## Instructions

1. Confirm authorization for tests, builds, runtime calls, and repository writes.
2. Map every validation result to a requirement or rule.
3. Separate documentation validation, runtime validation, and implementation validation.
4. Record tests/builds run, runtime checks, API compatibility, gap closure evidence, failed checks, and remaining risks.
5. Use `PASS`, `WARNING`, `BLOCKED`, or `FAILED` based only on evidence.

## Required Output

- Validate Report
- Requirement Validation Matrix
- Tests/builds and runtime checks
- API compatibility and gap-closure evidence
- Remaining risks, failed checks, and next actions

## Constraints

- Do not run tests/builds unless authorized.
- Do not claim validation without evidence.
- Do not close a gap without proof.

## Safety Rules

Sanitize runtime evidence. Do not expose raw server, API, DB, path, credential, or company-specific values.

## Codex Execution Report

State commands run, commands not run, evidence limits, result, Git status, and Human Review Required.
