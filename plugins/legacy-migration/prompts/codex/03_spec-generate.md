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

# Spec Generate — 02_Specify.md (단일 계약 SDD)

## 목적

승인된 Discover 근거로 `{{FEATURE_NAME}}`의 `02_Specify.md`를 작성한다. **이 문서가 케이스의 단일 계약이다** — 시나리오(Given/When/Then)와 Acceptance Criteria도 여기에 쓴다.

## 사용 시점

Discover 리뷰 후, OpenSpec/Plan 전.

## 입력

- Discover 문서: `{{SPEC_DIR}}`
- 템플릿: `templates/migration-docs/02_Specify.md`
- 산출 위치: `{{OUTPUT_DIR}}`

## 지시

1. 템플릿의 SDD 구조를 그대로 따른다: 상태 / 범위와 용어 / 공통 규칙 / 도메인 규칙 / **API 목록(색인 표)** / **API별 상세 스펙** / (외부 연동 시) External Route Matrix / 미결 질문.
2. **표는 색인, 계약은 섹션** — API 목록 표의 모든 API ID(`API-NNN`)마다 `### API-NNN` 상세 섹션을 쓴다: 목적 / 권한·사전조건 / 시나리오(GWT) / Request / Response(**레거시 원 필드 매핑**) / 레거시 호출 흐름(hop별 인용) / DB·외부 연동 / 변환 규칙 / 오류·빈 결과 / **Acceptance Criteria(AC-NNN-N)** / 연결 Task.
3. **인용 없는 근거는 근거가 아니다** — 레거시 근거와 호출 흐름에 `파일:라인` + 코드 인용.
4. 공통 규칙(인증/응답/에러/페이징)은 **Approved 컨벤션을 링크하고 케이스 예외만** 적는다. 재서술 금지.
5. 외부 연동이 있는 API는 External Route Matrix에 행 추가 — 직접 vs 프록시, 환경별 host를 환경설정 인용으로 확정.
6. 각 항목에 Evidence Status를, 기본 `Implementation Permission: Not Granted`를 기록한다.
7. 차이를 만나면 3분류: Policy Difference / Intentional Improvement / Runtime Verification 필요 — 전부 사람 결정 대기.
8. 깊이는 위험 비례: 단순 CRUD는 항목당 한두 줄, 외부 연동·변환 많은 API는 꽉 채운다.

## 산출물

- `02_Specify.md` (SDD 전체 — validator `API_SPEC_TABLE`/`API_DETAIL_SECTION`/`EVIDENCE_CITATION`/`EXTERNAL_ROUTE_MATRIX` 통과)

## 금지

- Inferred의 Confirmed 승격, Target 정책 임의 승인, 없는 도메인 로직·구현 코드 발명, 표 셀 요약으로 계약 대체.

## 안전

- 재사용 산출물에는 sanitize된 이식 가능한 참조만 쓴다.

## Codex Execution Report

근거 출처, 생성 스펙, permission 상태, Human Review Required를 보고한다.
