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

# Gap Review — 차이 분류, 수정 자동 승인 없음

## 목적

레거시 근거, `02_Specify.md`(SDD), Target 동작, Open Questions를 비교해 차이를 분류한다. 수정을 자동으로 승인하지 않는다.

## 사용 시점

레거시와 Target 근거가 모두 준비된 뒤 (review 케이스 또는 구현 후 대조).

## 입력

- 레거시 근거: `{{LEGACY_SCOPE}}`
- Target 근거: `{{TARGET_SCOPE}}`
- SDD: `{{SPEC_DIR}}/02_Specify.md`
- 산출 위치: `{{OUTPUT_DIR}}`

## 지시

1. 레거시/스펙/Target 근거를 **각각 `파일:라인` 인용으로** 분리 기록한다. 인용 없는 근거는 근거가 아니다.
2. 항목마다 분류: `Confirmed Gap` / `Policy Difference` / `Intentional Improvement 후보` / `Open Question` / `No Gap`. **API ID 단위로** 정리한다.
3. 심각도와 `Blocked By`(Human Policy Decision / Runtime Verification / Missing Evidence / External Owner Confirmation / None)를 지정한다.
4. 후보 수정안·필요 검증·수정하지 않는 이유를 기록하되 Implementation Permission은 바꾸지 않는다.
5. Open Questions를 임의로 닫지 않는다.

## 산출물

- Gap 표 (API ID / 분류 / 심각도 / Blocked By / 근거 인용 3종 / 후보 조치 / 사람 결정 필요 여부)

## 금지

- Policy Difference의 버그 취급, 사람 승인 없는 구현 허가, Open Question 종결.

## 안전

- 원본 secret과 내부 토폴로지를 복사하지 않는다.

## Codex Execution Report

gap 수, permission 상태, blocker, 수행한 검증을 보고한다.
