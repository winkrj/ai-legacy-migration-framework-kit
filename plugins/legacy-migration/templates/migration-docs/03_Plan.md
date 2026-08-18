# 계획 (Plan)

## 상태

Status: Not Started
Implementation: Not Started
Automation: Not Started
MCP/Plugin: Deferred

## 승인된 범위

- 이관 범위: <승인할 OpenSpec requirement·API 목록>
- 허용 수정 범위: <파일·패키지·공유 컴포넌트>
- 교체·삭제 허용: <대상 또는 없음>
- 테스트 범위: <단위·통합·계약 테스트와 verify 명령>
- 범위 제외: <대상>

## 요구사항 추적

> API ID ↔ requirement ↔ task ID를 한 표에서 추적한다.

| API ID | Requirement | 계획/구현 Task | 검증 Task |
|---|---|---|---|
| API-001 | REQ-001 | PLAN-API-001 / IMPL-API-001 | VAL-API-001 |

## 구현 계획

1. <승인된 작은 변경 — 연결 IMPL-API-NNN>

## 테스트 계획

- <테스트 또는 evidence — 연결 VAL-API-NNN>

## 리스크

- <리스크>

## Permission

Implementation Permission: Not Granted

사람은 이 문서에서 위 범위와 아래 열거된 task를 한 번 검토한다. `Granted`는 열거된 task를 지속 Goal로 등록하고 구현 → 테스트·검증 → 수정 → 재검증 → 독립 검토를 `READY FOR HUMAN REVIEW`까지 실행하도록 승인한다. 목록 밖 task와 범위 확대는 승인하지 않는다.

`Open` 상태는 구현 전에 사람 결정이 필요한 질문에만 사용한다. 따라서 `Open`이 하나라도 있으면 권한을 `Granted`로 바꾸지 않는다. runtime evidence와 production/cutover 질문은 `Pending Manual Evidence` 또는 `Deferred`로 기록하고 구현을 막지 않는다.
