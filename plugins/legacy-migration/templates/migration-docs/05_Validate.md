# Validate

## Status

Status: Not Started
Implementation: Not Started
Automation: Deferred
MCP/Plugin: Deferred

## Validation Mode

| Field | Value |
|---|---|
| Validation Mode | Test Verified / Manual Runtime Verified / Manual Evidence Pending / Review-only / Blocked by Environment |
| Automated Test Status | Passed / Failed / Not Run / Blocked |
| Runtime Verification Status | Verified / Pending Manual Evidence / Not Required / Blocked by Environment |
| Manual Evidence Status | Available / Pending / Not Required |
| Evidence Location | Not Created |
| Production Readiness | Not Claimed |

Validation Mode describes how the case was validated. It does not grant Implementation Permission or Production Readiness.

## Validation Results

| Requirement | Evidence / Test | Expected | Observed | Result |
|---|---|---|---|---|
| REQ-001 | TEST-001 |  |  | Not Run |

## Compatibility Check

| Behavior | Legacy | Target | Result |
|---|---|---|---|
| <behavior> | <legacy expectation> | <target expectation> | Not Run |

## Documentation Validation

- Validator CLI: Not Run
- Report: `<outside-validation-root>`

## Residual Risks

- <risk>

## Carry-forward Conditions

| Item | Status | Owner | Required Before | Blocks Phase Archive | Blocks Production/Cutover |
|---|---|---|---|---|---|
|  | Pending Manual Evidence / Blocked by Environment / Deferred |  |  | Yes / No | Yes / No |

Use `templates/runtime-evidence/` only when verification is authorized. Do not create fake evidence. Sanitize runtime evidence before sharing or portfolio use.

## Validation Judgment

PASS / WARNING / BLOCKED / FAILED / Not Executed
