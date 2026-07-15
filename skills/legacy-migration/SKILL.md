---
name: legacy-migration
description: 레거시 프로젝트의 코드나 기획서를 새 프로젝트로 이관(migration)할 때 사용한다. 사용자가 레거시 코드 분석, 기능 이관, 마이그레이션, 스펙 문서 작성, 레거시-신규 프로젝트 비교를 요청하면 이 스킬을 적용한다. 레거시 분석 → 스펙 승인 → 구현 → 검증 워크플로우와 컨벤션 주입 규칙을 제공한다.
---

# Legacy Migration Workflow

레거시 기능을 근거 기반 스펙으로 정리하고, **사람이 스펙을 승인한 뒤에만** 새 프로젝트에 구현하는 워크플로우다.

## 불변 규칙 3가지 (모든 케이스 공통)

1. **레거시 read-only** — 레거시 repo의 파일은 절대 수정하지 않는다.
2. **계약은 사람 승인 후 구현** — `02_Spec.md`의 구현 승인 체크박스는 사람만 체크하고, 체크 전에는 production 코드를 작성하지 않는다. (플러그인 훅이 이를 강제한다.)
3. **격리 브랜치** — 이관 작업은 `feature/ai-migration-<기능명>` 브랜치에서만 한다.

## 진행 방법

사용자가 이관을 요청하면 임의 절차를 만들지 말고 단계 커맨드로 안내하거나 그 커맨드의 절차를 그대로 따른다:

| 상황 | 커맨드 |
|---|---|
| 컨벤션 등록 (직접 입력/참고 프로젝트 추출) | `/legacy-migration:conventions [참고경로]` |
| 일반 기능 이관 시작 (분석 + 스펙 초안) | `/legacy-migration:start <기능명> <레거시경로>` |
| 스펙 승인 후 구현 | `/legacy-migration:implement <기능명>` |
| 결제·인증·PII·공유 코드·cutover | `/legacy-migration:full` |
| 이관 문서 구조 검사 | `/legacy-migration:validate <케이스명>` |

사용자가 커맨드 없이 자연어로 요청해도 같은 절차를 따른다. 특히 **분석·스펙 단계와 구현 단계를 한 턴에 이어서 진행하지 않는다** — 스펙 초안까지 만들고 반드시 사용자 승인을 기다린다.

사용자가 "뭘 할 수 있어", "사용법", "도움말", "커맨드 목록"류를 묻거나 요청이 어느 단계인지 판단이 안 되면, 위 커맨드 표를 상황 설명과 함께 보여주고 어떤 작업인지 확인한다. 이때 현재 상태(`docs/conventions/` 등록 여부, `docs/migration/`에 진행 중인 케이스가 있는지)도 함께 알려준다.

## 근거(Evidence) 규칙

- **인용 없는 근거는 근거가 아니다** — 근거는 `파일경로:라인` + 실제 코드 1~3줄 인용만 인정한다. 산문 요약은 무효. 사람이 30초 안에 열어서 대조할 수 있어야 한다.
- 코드/쿼리에서 확인한 사실만 `Confirmed`로 기록한다. 나머지는 `미확인`/`Inferred`/`Open Question`으로 구분한다.
- **응답값만 보고 로직을 판단하지 않는다** — 조건/분기/기본값은 코드에서 확인한다. call chain의 각 hop을 직접 열어 확인하고, 안 연 hop부터는 Inferred다.
- 외부 연동은 직접 호출인지 내부 프록시 경유인지 환경설정 인용으로 확정한다. 확정 못 하면 미확인.
- 미확인 동작은 추측해서 구현하지 않는다. 애매하면 사용자에게 묻는다.
- 레거시의 동작이 곧 승인된 Target 동작인 것은 아니다 — 차이는 Policy Difference로 기록하고 사람이 결정한다.

## 구현 품질 규칙

- **2-pass 구현**: Pass 1(동작+테스트) → Pass 2(정리: 책임 분리 / 이름·magic value / null 흐름·원인 로그 보존 / 중복·추상화). Pass 2 없이 완료 표시하지 않는다.
- **binding 컨벤션 재주입**: `docs/conventions/binding-rules.md`(Approved, 10줄 이내)를 구현 직전 다시 읽고, 구현 후 규칙별 `지켰음`/`예외(사유)` 대조표를 남긴다.
- 외부 연동 실패를 null로 삼키지 않는다 — 원인 로그를 보존하고 명시적 실패 타입으로 표현한다.

## 문서 단위와 추적 (Full 모드)

- **문서 단위 3층**: 큰 단위 = 메뉴/feature, 상세 계약 단위 = **API**, 구현/검증 단위 = **task ID**.
- **`02_Specify.md`가 케이스의 단일 계약(SDD)**이다. `API 목록` 표는 색인이고, 표의 모든 API ID마다 `### API-NNN` 상세 섹션을 쓴다 — 목적 / 권한·사전조건 / 시나리오(Given/When/Then) / Request / Response(레거시 원 필드 매핑) / 레거시 호출 흐름(인용) / DB·외부 연동 / 변환 규칙 / 오류·빈 결과 / **Acceptance Criteria(AC ID)** / 연결 Task. **표 한 행은 계약이 아니다** — 셀 요약으로 끝내지 않는다. GWT/AC는 여기에만 쓴다(OpenSpec spec.md는 포인터). 깊이는 위험 비례: 단순 CRUD는 한두 줄, 외부 연동은 꽉 채운다.
- **`tasks.md`는 API ID 기준**으로 만든다: API마다 `PLAN-API-NNN`(계획·권한) / `IMPL-API-NNN`(구현) / `VAL-API-NNN`(검증). 각 task는 requirement/API spec과 연결한다.
- **구현은 task ID 기준**: Implementation Permission이 Granted된 `IMPL-API-NNN`만 구현한다. task ID 없는 구현은 하지 않는다. 예상 밖 API·파일·외부 연동을 발견하면 멈추고 질문한다. 구현 후 task와 evidence를 갱신한다.
- 이 구조는 Validator CLI가 기계 검사한다(`/legacy-migration:validate`). Light 모드(3문서)는 이 표/triad를 요구하지 않는다.

## 컨벤션 주입 규칙

1. Target 프로젝트의 `docs/conventions/`에서 Human Decision이 **Approved**인 문서를 먼저 읽고, 스펙과 구현에 그대로 반영한다. Draft는 참고만 한다.
2. 사용자가 대화에서 컨벤션/아키텍처/비즈니스 로직을 제시하면 그것이 최우선이다. 문서로 남길 가치가 있으면 `/legacy-migration:conventions`로 등록을 제안한다.
3. 사용자가 팀 가이드/참고 프로젝트를 주면 `/legacy-migration:conventions <경로>`로 패턴+반례를 추출해 Draft를 만든다. 컨벤션을 발명하거나 관찰된 패턴 하나를 프로젝트 규칙으로 승격하지 않는다.
4. 컨벤션끼리, 또는 컨벤션과 스펙이 충돌하면 멈추고 사용자에게 묻는다.

컨벤션 문서 템플릿: `${CLAUDE_PLUGIN_ROOT}/templates/conventions/`

## 안전 경계

- credential, 실서버 주소, 실데이터, 내부 식별자를 문서에 넣지 않는다.
- 테스트 실패를 숨기거나 assertion을 약화하지 않는다. 없는 검증 evidence를 만들지 않는다.
- commit은 구현 완료 시점에 하되, push/MR은 사용자 지시가 있을 때만 한다.
- production readiness를 주장하지 않는다.

## 리소스

- Light 모드 템플릿(3문서): `${CLAUDE_PLUGIN_ROOT}/templates/migration-docs-light/`
- Full 모드 템플릿(8문서): `${CLAUDE_PLUGIN_ROOT}/templates/migration-docs/`
- OpenSpec change 템플릿: `${CLAUDE_PLUGIN_ROOT}/templates/openspec-change/`
- Full 모드 절차: `${CLAUDE_PLUGIN_ROOT}/guides/walkthrough-full-mode.md`
