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

# Feature Inventory — 이관 후보 조사

## 목적

이관 후보 기능을 찾아 비교한다. 소스를 수정하지 않고, 최종 pilot을 임의로 확정하지 않는다.

## 사용 시점

Discover 대상 기능을 사람이 고르기 전.

## 입력

- 레거시 범위: `{{LEGACY_SCOPE}}` (read-only)
- 선택적 target 범위: `{{TARGET_SCOPE}}`
- 산출 위치: `{{OUTPUT_DIR}}`

## 지시

1. 레거시를 read-only로 훑고 후보 기능을 **메뉴/feature 단위**로 나열한다.
2. 후보마다 기록: 진입점(`파일:라인` 인용), 대략의 API 수, 외부 연동 여부, 공유 코드 여부, 결제·인증·PII 해당 여부.
3. **인용 없는 근거는 근거가 아니다** — 각 항목에 `파일경로:라인`을 붙인다.
4. 결제·인증·PII·공유 코드·cutover에 해당하면 Full 모드 대상으로 표시한다.
5. 추천 후보와 이유를 제시하되 **최종 선택은 사람에게 남긴다.**

## 산출물

- 후보 비교표 (기능명 / 진입점 인용 / API 수 / 외부 연동 / 위험 표시 / Light·Full 추천)
- 조사한 파일 목록, 미확인 항목(Open Questions)

## 금지

- 코드 수정, 비즈니스 정책 추론, 최종 후보 확정.

## 안전

- 재사용 산출물에서 secret과 사내 식별자를 제거하고 이식 가능한 placeholder를 쓴다.

## Codex Execution Report

`Implementation: Not Performed`, `Tests / Builds: Not Run`으로 보고한다.
