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

## 근거(Evidence) 규칙

- 코드/쿼리에서 확인한 사실만 `Confirmed`로 기록한다. 나머지는 `미확인`/`Inferred`/`Open Question`으로 구분한다.
- 미확인 동작은 추측해서 구현하지 않는다. 애매하면 사용자에게 묻는다.
- 레거시의 동작이 곧 승인된 Target 동작인 것은 아니다 — 차이는 Policy Difference로 기록하고 사람이 결정한다.

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
