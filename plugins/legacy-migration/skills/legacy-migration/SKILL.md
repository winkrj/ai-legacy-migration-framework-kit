---
name: legacy-migration
description: 레거시 코드 분석, 기능 이관, 마이그레이션 스펙 작성, 레거시-신규 프로젝트 비교, 프로젝트 컨벤션 추출을 요청할 때 사용한다. 분석과 구현을 사람 승인 게이트로 분리한다.
---

# Legacy Migration Workflow

레거시 기능을 근거 기반 스펙으로 정리하고, 사람이 스펙을 승인한 뒤에만 Target 프로젝트에 구현한다.

## 불변 규칙

1. 레거시 저장소는 read-only다.
2. `02_Spec.md`의 구현 승인 체크박스는 사람만 체크한다. 승인 전에는 production 코드를 수정하지 않는다.
3. 이관 작업은 `feature/ai-migration-<기능명>` 브랜치에서만 수행한다.
4. 확인한 사실과 추론, 미확인 항목을 구분한다. 미확인 동작을 추측해서 구현하지 않는다.
5. push와 PR/MR 생성은 사용자가 명시적으로 요청할 때만 한다.

## 모드 선택

요청에 맞는 reference를 읽고 그대로 따른다.

- 컨벤션 직접 입력·참고 프로젝트 추출·현재 프로젝트 추출: `references/conventions.md`
- 일반 기능 분석과 스펙 초안: `references/start.md`
- 사람이 승인한 스펙 구현: `references/implement.md`
- 결제·인증·PII·공유 코드·cutover: `references/full.md`
- 이관 문서 구조 검사: `references/validate.md`

사용자가 명령 형식 없이 자연어로 요청해도 같은 절차를 적용한다. 분석·스펙 단계와 구현 단계를 한 턴에 이어서 수행하지 않는다.

## 플러그인 리소스

플러그인 루트는 설치 환경의 `PLUGIN_ROOT`다.

- Light 템플릿: `${PLUGIN_ROOT}/templates/migration-docs-light/`
- Full 템플릿: `${PLUGIN_ROOT}/templates/migration-docs/`
- 컨벤션 템플릿: `${PLUGIN_ROOT}/templates/conventions/`
- OpenSpec 템플릿: `${PLUGIN_ROOT}/templates/openspec-change/`
- Full 모드 가이드: `${PLUGIN_ROOT}/guides/walkthrough-full-mode.md`

reference에 `${CLAUDE_PLUGIN_ROOT}`가 있으면 Codex에서는 `${PLUGIN_ROOT}`와 같은 플러그인 루트로 해석한다.

## 안전 경계

- credential, 실서버 주소, 실데이터, 내부 식별자를 문서에 넣지 않는다.
- 테스트 실패를 숨기거나 assertion을 약화하지 않는다.
- 없는 검증 evidence를 만들지 않는다.
- 컨벤션이나 스펙이 충돌하면 결정하지 말고 사용자에게 묻는다.
