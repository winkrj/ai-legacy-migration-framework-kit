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
- Validation Mode: Test Verified / Manual Runtime Verified / Manual Evidence Pending / Review-only / Blocked by Environment
- Specs: `{{SPEC_DIR}}`
- Target scope: `{{TARGET_SCOPE}}`
- Validator rules: `{{VALIDATOR_RULES_DIR}}`
- Output: `{{OUTPUT_DIR}}`

## Instructions

1. Confirm authorization for tests, builds, runtime calls, and repository writes.
2. Judge runtime feasibility before starting a runtime or external call.
3. Select and report the Validation Mode.
4. If a safe runtime is unavailable, use `Manual Evidence Pending` or `Blocked by Environment` and prepare a manual checklist.
5. Map every validation result to a requirement or rule.
6. Separate documentation validation, runtime validation, and implementation validation.
7. Record tests/builds run, runtime checks, API compatibility, gap closure evidence, failed checks, and remaining risks.
8. Use `PASS`, `WARNING`, `BLOCKED`, or `FAILED` based only on evidence.

## Required Output

- Validate Report
- Requirement Validation Matrix
- Tests/builds and runtime checks
- API compatibility and gap-closure evidence
- Validation Mode, evidence location, carry-forward conditions, and Production Readiness state
- Remaining risks, failed checks, and next actions

## Constraints

- Do not run tests/builds unless authorized.
- Do not claim validation without evidence.
- Do not close a gap without proof.
- Do not fabricate runtime evidence or create a populated evidence record when verification was not performed.
- No Validation Mode automatically grants Production Readiness.

## Safety Rules

Sanitize runtime evidence. Do not expose raw server, API, DB, path, credential, or company-specific values.

## Codex Execution Report

State commands run, commands not run, evidence limits, result, Git status, and Human Review Required.
