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

# Feature Inventory

## Purpose

Find and compare candidate migration features without modifying source code or approving a final pilot.

## When To Use

Use before selecting a feature for Discover.

## Inputs

- Repository mode and root
- Legacy scope: `{{LEGACY_SCOPE}}`
- Optional target scope: `{{TARGET_SCOPE}}`
- Output directory: `{{OUTPUT_DIR}}`
- Framework rules: `{{VALIDATOR_RULES_DIR}}`

## Instructions

1. Confirm repository boundaries and read-only mode.
2. Search entry points, service/repository flow, data access, dependencies, states, paging, and external integration.
3. Produce a feature inventory and candidate matrix.
4. Rate risk and migration suitability using evidence.
5. Recommend a first pilot candidate, but leave final selection to a human.
6. Record files inspected and Open Questions.

## Required Output

- Feature inventory
- Candidate list and comparison
- Risk level and dependency notes
- Recommended candidate with evidence
- Files inspected
- Open Questions and Human Review Required

## Constraints

- Do not modify code.
- Do not infer business policy.
- Do not make the final feature selection.

## Safety Rules

Remove secrets and company-specific identifiers from reusable output. Use portable placeholders instead of personal paths.

## Codex Execution Report

Return the standard report with `Implementation: Not Performed`, `Tests / Builds: Not Run`, and `Staging: Not Performed`.
