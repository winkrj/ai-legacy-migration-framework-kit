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

# Legacy Discover — 관찰만, 판단 없음

## 목적

`{{FEATURE_NAME}}`의 레거시 동작을 관찰해 `01_Discover.md`를 작성한다. 레거시 관찰을 Target 요구사항으로 승격하지 않는다.

## 사용 시점

사람이 기능을 선택한 뒤, Specify 전.

## 입력

- 레거시 범위: `{{LEGACY_SCOPE}}` (read-only)
- 기능: `{{FEATURE_NAME}}`
- 산출 위치: `{{OUTPUT_DIR}}`

## 지시

1. call chain을 추적한다: 진입점(JSP/URL) → Controller → Service → Client/DAO → 환경설정. **각 hop마다 파일을 직접 열어 `파일:라인` + 코드 1~3줄 인용을 남긴다.** 안 연 hop부터는 Inferred다.
2. **응답값만 보고 로직을 판단하지 않는다** — 조건/분기/기본값/조용한 실패를 코드에서 확인한다.
3. 외부 연동이 보이면 **직접 호출 vs 내부 프록시(gpapi류)** 를 환경설정 파일 인용으로 확정한다. 못 하면 Open Question.
4. Evidence Level 구분: Confirmed(인용 있음) / Observed(패턴 관찰) / Inferred(추론 — 구현 금지).
5. 확인 못 한 것은 전부 `99_Open-Questions.md`에 OQ-ID로 등록한다.
6. 민감정보는 값을 복사하지 말고 존재만 표시한다.

## 산출물

- `01_Discover.md`: 출처 표 / 발견 표(**인용 열 필수**) / 레거시 흐름(hop별 `:라인`) / 리스크 / 미결 질문

## 금지

- 구현, 레거시 동작의 Target 정책화, Open Question 임의 종결, 인용 없는 Confirmed.

## 안전

- credential, 서버 주소, 실DB명, 토큰, 원본 민감 evidence를 노출하지 않는다.

## Codex Execution Report

조사 파일, 근거 한계, 미해결 blocker, `Implementation: Not Performed`를 보고한다.
