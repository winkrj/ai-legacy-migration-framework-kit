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
5. **인용 없는 근거는 근거가 아니다** — 근거는 `파일경로:라인` + 코드 1~3줄 인용만 인정. 응답값만 보고 로직을 판단하지 않고, call chain의 각 hop을 직접 열어 확인한다.
6. **구현은 2-pass** — Pass 1(동작+테스트) 후 Pass 2(정리: 책임 분리/이름/조건문/null 흐름/중복·추상화)를 반드시 별도로 돌고 기록한다. 이름은 비즈니스 의도를 표현하고(`data`/`temp`/`util`류 금지), 성급한 추상화와 요청 범위 초과 리팩터링을 하지 않는다. Approved `binding-rules` 컨벤션은 구현 직전 재주입하고 규칙별 대조표를 남긴다.
7. push와 PR/MR 생성은 사용자가 명시적으로 요청할 때만 한다.

## 모드 선택

요청에 맞는 reference를 읽고 그대로 따른다.

- 컨벤션 직접 입력·참고 프로젝트 추출·현재 프로젝트 추출: `references/conventions.md`
- 일반 기능 분석과 스펙 초안: `references/start.md`
- 사람이 승인한 스펙 구현: `references/implement.md`
- 결제·인증·PII·공유 코드·cutover: `references/full.md`
- 이관 문서 구조 검사: `references/validate.md`

사용자가 명령 형식 없이 자연어로 요청해도 같은 절차를 적용한다. 분석·스펙 단계와 구현 단계를 한 턴에 이어서 수행하지 않는다.

## 도움말 메뉴

사용자가 "뭘 할 수 있어", "사용법", "도움말", "메뉴", "커맨드 목록"류를 묻거나, 요청이 어느 모드인지 판단이 안 되면 아래 표를 그대로 보여주고 어떤 작업인지 확인한다:

| 상황 | 이렇게 말하세요 |
|---|---|
| 팀 컨벤션 등록 (프로젝트당 1회 권장) | "컨벤션을 등록해줘. 참고 프로젝트는 <경로>" |
| 기능 이관 시작 — 분석 + 스펙 초안 | "<기능명> 이관을 분석 단계부터 시작해줘. 레거시 경로는 <경로>" |
| 스펙 승인 후 구현 | "<기능명> 스펙 승인했어. 승인된 범위만 구현해줘" |
| 이관 문서 검사 | "<기능명> 이관 문서를 validator로 검사해줘" |
| 결제·인증·PII·공유 코드 | "<기능명>을 Full 모드로 이관해줘. 레거시 경로는 <경로>" |
| 결과 반영 | "push하고 MR 만들어줘" (사용자가 말할 때만 수행) |
| 되돌리기 | "이번 이관 브랜치 삭제해줘" |

메뉴를 보여줄 때 현재 상태(컨벤션 등록 여부, 진행 중인 이관 케이스가 `docs/migration/`에 있는지)를 함께 알려주면 좋다.

## 문서 단위와 추적 (Full 모드)

- **문서 단위 3층**: 큰 단위 = 메뉴/feature, 상세 계약 단위 = API, 구현/검증 단위 = task ID.
- **`02_Specify.md`가 케이스의 단일 계약(SDD)**이다. `API 목록` 표는 색인이고, 표의 모든 API ID마다 `### API-NNN` 상세 섹션을 쓴다 — 목적 / 권한·사전조건 / 시나리오(Given/When/Then) / Request / Response(레거시 원 필드 매핑) / 레거시 호출 흐름(인용) / DB·외부 연동 / 변환 규칙 / 오류·빈 결과 / **Acceptance Criteria(AC ID)** / 연결 Task. **표 한 행은 계약이 아니다** — 셀 요약으로 끝내지 않는다. GWT/AC는 여기에만 쓴다(OpenSpec spec.md는 포인터). 깊이는 위험 비례.
- **`tasks.md`는 API ID 기준**으로 만든다: API마다 `PLAN-API-NNN` / `IMPL-API-NNN` / `VAL-API-NNN`. 각 task는 requirement/API spec과 연결한다.
- **구현은 task ID 기준**: Implementation Permission이 Granted된 `IMPL-API-NNN`만 구현한다. task ID 없는 구현은 하지 않는다. 예상 밖 API·파일·외부 연동을 발견하면 멈추고 질문한다.
- 이 구조는 Validator CLI가 기계 검사한다. Light 모드(3문서)는 이 표/triad를 요구하지 않는다.

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
