---
type: ai-instruction
audience: ai
language: ko
tags:
  - ai-only
  - agent
  - codex
  - prompt
---

# OpenSpec Generate — proposal + tasks (spec.md는 포인터)

## 목적

`{{FEATURE_NAME}}`의 OpenSpec change(`proposal.md` + `tasks.md` + `specs/<capability>/spec.md`)를 생성한다. **계약의 단일 진실은 `02_Specify.md`다** — GWT/AC를 여기 복사하지 않는다.

## 사용 시점

`02_Specify.md`(SDD) 리뷰 후, Plan 전.

## 입력

- SDD: `{{SPEC_DIR}}/02_Specify.md`
- 템플릿: `templates/openspec-change/`
- 산출 위치: `{{OUTPUT_DIR}}`

## 지시

1. `proposal.md`: 필요성, 변경 대상, 레거시 동작 요약(인용 참조), Non-goals, 리스크, Open Questions.
2. `tasks.md`는 **API ID 기준**으로 생성: 02_Specify의 각 `API-NNN`마다 `PLAN-API-NNN`(계획·권한) / `IMPL-API-NNN`(구현) / `VAL-API-NNN`(AC별 검증) 세 task. 각 task에 연결 API와 spec 위치(§API-NNN)를 적는다.
3. `specs/<capability>/spec.md`는 **requirement 색인(포인터)만**: 한 줄 SHALL 요약 + API ID + 계약 위치. GWT를 복사하지 않는다.
4. 미해결 결정은 requirement로 위장하지 말고 `[DECISION PENDING]` 또는 Open Question으로 뺀다.
5. `Implementation Permission: Not Granted`를 유지한다 — 승인은 사람 몫.

## 산출물

- `proposal.md`, `tasks.md`(PLAN/IMPL/VAL triad — validator `TASK_ID_TRIAD` 통과), `specs/<capability>/spec.md`(포인터)

## 금지

- 구현 코드 작성, 미결 정책 은폐, GWT/AC의 spec.md 복사(진실 두 개 금지), 검증 안 된 동작 주장.

## 안전

- 사내 secret과 개인 절대경로를 넣지 않는다.

## Codex Execution Report

traceability 커버리지, 미결 결정, `Implementation: Not Performed`를 보고한다.
