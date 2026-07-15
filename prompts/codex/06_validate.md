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

# Validate — 한 검증과 안 한 검증을 구분

## 목적

문서·runtime evidence·승인된 구현을 명시적 근거로 검증하고 `05_Validate.md`를 작성한다.

## 사용 시점

검증 범위와 명령 실행 권한이 명확할 때만.

## 입력

- 검증 유형: Documentation / Runtime / Implementation
- SDD: `{{SPEC_DIR}}/02_Specify.md` (Acceptance Criteria 출처)
- Target 범위: `{{TARGET_SCOPE}}`
- 산출 위치: `{{OUTPUT_DIR}}`

## 지시

1. 테스트/빌드/runtime 호출/repo 쓰기 권한을 먼저 확인한다.
2. Validation Mode를 하나 고른다(실제 수행한 것만): `Test Verified` / `Manual Runtime Verified` / `Manual Evidence Pending` / `Review-only` / `Blocked by Environment`.
3. **검증 결과는 AC 단위로 기록한다** — 02_Specify의 모든 `AC-NNN-N`을 표에 올리고, 커버 안 된 AC는 빈 행으로 남겨 **보이게** 한다(validator `AC_COVERAGE`가 대조한다). 테스트 통과가 아니라 AC 커버리지가 완료 기준이다.
4. 외부 연동 API는 성공·빈 응답·부분 실패·HTTP 오류 케이스를 검증하거나, 못 하면 `Manual Evidence Pending`으로 수동 체크리스트를 준비한다.
5. 안전한 runtime이 없으면 evidence를 만들지 않는다 — "Pending"이 정답이다.
6. Validator CLI를 실행하고 결과를 기록한다 (report는 검사 root 밖).
7. 판정은 근거로만: `PASS` / `WARNING` / `BLOCKED` / `FAILED`.

## 산출물

- `05_Validate.md`: Validation Mode 표 / **AC 단위 검증 결과 표** / 호환성 점검 / 문서 검증 / 이월 조건 / 판정

## 금지

- 무단 테스트/빌드 실행, 근거 없는 검증 주장, 증거 없는 gap 종결, **runtime evidence 조작·허위 기록**, Validation Mode의 Production Readiness 자동 승격.

## 안전

- runtime evidence는 sanitize한다. 서버/API/DB/경로/credential 원본 값을 노출하지 않는다.

## Codex Execution Report

실행한/안 한 명령, 근거 한계, 판정, Git 상태, Human Review Required를 보고한다.
