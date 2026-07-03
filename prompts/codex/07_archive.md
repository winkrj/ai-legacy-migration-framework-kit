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

# Archive

## Purpose

Archive a completed, conditionally completed, deferred, or rejected migration pilot while preserving evidence and uncertainty.

## When To Use

Use after validation or an explicit human decision to stop or defer.

## Inputs

- Feature: `{{FEATURE_NAME}}`
- Pilot documents: `{{SPEC_DIR}}`
- Validation evidence: `{{TARGET_SCOPE}}`
- Output: `{{OUTPUT_DIR}}`

## Instructions

1. Select `Archive`, `Archive with Conditions`, `Archive Deferred`, or `Archive Rejected`.
2. Record what was done and not done, implementation status, validation status, and final judgement.
3. Carry forward Open Questions and deferred/rejected candidate fixes.
4. Separate Human Policy Decision from Runtime Verification.
5. Record reusable rules, next phase, portfolio notes, public-writing notes, and internal-information checks.
6. Use Archive with Conditions when useful evidence exists but implementation is not approved or non-blocking conditions remain.

## Required Output

- Archive document and final judgement
- Work performed/not performed
- Implementation and validation status
- Open Question carry-forward table
- Deferred/rejected fixes
- Reusable rules and next phase
- Public-safe summary

## Constraints

- Do not hide unresolved items.
- Do not claim final domain certainty for conditional evidence.
- Do not treat Archive as proof that implementation occurred.

## Safety Rules

Remove internal identifiers and raw evidence from portfolio/public notes. Keep private details only in their authorized Source of Truth.

## Codex Execution Report

Report archive outcome, conditions, carry-forward, safety check, files changed, and Human Review Required.
