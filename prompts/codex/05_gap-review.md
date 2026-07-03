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

# Gap Review

## Purpose

Compare Legacy evidence, Domain Spec, Target behavior, and Open Questions without automatically authorizing a fix.

## When To Use

Use after Legacy and Target evidence are available.

## Inputs

- Legacy evidence: `{{LEGACY_SCOPE}}`
- Target evidence: `{{TARGET_SCOPE}}`
- Specs: `{{SPEC_DIR}}`
- Output: `{{OUTPUT_DIR}}`

## Instructions

1. Cite Legacy, Spec, and Target evidence separately.
2. Classify each item as `Confirmed Gap`, `Policy Difference`, `Improvement / Intentional Change Candidate`, `Open Question`, or `No Gap`.
3. Assign severity and `Blocked By`: `Human Policy Decision`, `Runtime Verification`, `Missing Evidence`, `External Owner Confirmation`, or `None`.
4. Record Implementation Permission, candidate fix, required validation, and no-fix justification.
5. Preserve all unresolved Open Questions.

## Required Output

- Gap Review and gap table
- Gap type, severity, Blocked By, and evidence
- Implementation Permission
- Candidate fix or no-fix justification
- Required validation and Human Decision Needed

## Constraints

- Do not treat Policy Difference as a bug.
- Do not authorize implementation without human approval.
- Do not close Open Questions.

## Safety Rules

Keep internal evidence sanitized and do not copy raw secrets or private topology.

## Codex Execution Report

Report gap counts, permission state, blockers, files changed, and validation performed.
