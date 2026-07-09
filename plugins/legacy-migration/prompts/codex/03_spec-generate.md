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

# Spec Generate

## Purpose

Generate a Domain Spec from approved Discover evidence for `{{FEATURE_NAME}}`.

## When To Use

Use after Discover evidence is reviewed and before planning or Gap Review.

## Inputs

- Discover documents: `{{SPEC_DIR}}`
- Framework templates: `{{FRAMEWORK_REPOSITORY_ROOT}}`
- Target project root when authorized: `{{TARGET_PROJECT_ROOT}}`
- Output: `{{OUTPUT_DIR}}`

## Instructions

1. Identify repository mode and the canonical output owner.
2. Create rules with stable IDs.
3. Document request/response behavior, DB mapping, status values, compatibility notes, and policy differences.
4. Record Evidence Status and Implementation Permission per rule.
5. Keep unresolved behavior as Open Question or Human Decision Required.
6. Make Target Project output developer-readable without Personal Obsidian.

## Required Output

- Domain Spec and rule table
- Request/response behavior
- DB mapping and status values
- Policy Differences
- Open Questions
- Implementation Permission per rule

## Constraints

- Do not promote Inferred rules to Confirmed.
- Do not approve Target policy.
- Do not invent missing domain logic or implementation code.

## Safety Rules

Use sanitized, portable references and avoid internal-only identifiers in reusable framework output.

## Codex Execution Report

Report source evidence, generated specs, permission state, and Human Review Required.
