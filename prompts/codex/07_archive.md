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

# Archive — 정직한 종료

## 목적

완료·조건부 완료·보류·중단된 이관 케이스를 근거와 불확실성을 보존한 채 보관한다.

## 사용 시점

검증 후, 또는 사람이 중단/보류를 명시적으로 결정한 뒤.

## 입력

- 기능: `{{FEATURE_NAME}}`
- 케이스 문서: `{{SPEC_DIR}}`
- 검증 evidence: `{{TARGET_SCOPE}}`
- 산출 위치: `{{OUTPUT_DIR}}`

## 지시

1. Decision 선택: `PASS` / `Archive with Conditions` / `BLOCKED` / `FAILED`.
2. Verified와 Not Verified를 구분해 기록한다 — **커버 안 된 AC는 Not Verified에 명시**한다.
3. Open Questions와 보류·기각된 수정 후보를 carry-forward 표로 이월한다: owner / Required Before / Blocks Phase Archive / Blocks Implementation / Blocks Production·Cutover 구분.
4. Human Policy Decision과 Runtime Verification을 분리한다.
5. 재사용 규칙·컨벤션 후보·다음 단계를 기록한다.
6. **Archive ≠ production readiness** — 케이스 보관이 cutover 승인을 뜻하지 않음을 명시한다.

## 산출물

- `06_Archive.md`: 결정 / Verified·Not Verified / 보관 지식 / carry-forward 표 / 잔여 리스크 / Readiness Boundary

## 금지

- 미해결 항목 은폐, 조건부 evidence의 확정 주장, Archive의 구현 증명 취급.

## 안전

- 공개/포트폴리오 노트에서 내부 식별자와 원본 evidence를 제거한다.

## Codex Execution Report

archive 결과, 조건, carry-forward, 안전 점검, 변경 파일, Human Review Required를 보고한다.
