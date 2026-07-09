# 검증 (Validate)

## 상태

Status: Not Started
Implementation: Not Started
Automation: Deferred
MCP/Plugin: Deferred

## Validation Mode

| 항목 | 값 |
|---|---|
| Validation Mode | Test Verified / Manual Runtime Verified / Manual Evidence Pending / Review-only / Blocked by Environment |
| Automated Test Status | Passed / Failed / Not Run / Blocked |
| Runtime Verification Status | Verified / Pending Manual Evidence / Not Required / Blocked by Environment |
| Manual Evidence Status | Available / Pending / Not Required |
| Evidence Location | Not Created |
| Production Readiness | Not Claimed |

Validation Mode는 케이스를 어떻게 검증했는지를 설명할 뿐, Implementation Permission이나 Production Readiness를 부여하지 않는다.

## 검증 결과

> API/Task 단위로 검증 결과를 남긴다. VAL task와 연결한다.

| API ID | Task | Evidence / Test | 기대 | 관찰 | 결과 |
|---|---|---|---|---|---|
| API-001 | VAL-API-001 | TEST-001 |  |  | Not Run |

## 호환성 점검

| 동작 | 레거시 | Target | 결과 |
|---|---|---|---|
| <동작> | <레거시 기대치> | <target 기대치> | Not Run |

## 문서 검증

- Validator CLI: Not Run
- Report: `<validation-root 밖 경로>`

## 잔여 리스크

- <리스크>

## 이월 조건

| 항목 | 상태 | Owner | Required Before | Blocks Phase Archive | Blocks Production/Cutover |
|---|---|---|---|---|---|
|  | Pending Manual Evidence / Blocked by Environment / Deferred |  |  | Yes / No | Yes / No |

`templates/runtime-evidence/`는 검증이 승인된 경우에만 사용한다. 없는 evidence를 만들지 않는다. runtime evidence는 공유·포트폴리오 전에 sanitize한다.

## Validation Judgment

PASS / WARNING / BLOCKED / FAILED / Not Executed
