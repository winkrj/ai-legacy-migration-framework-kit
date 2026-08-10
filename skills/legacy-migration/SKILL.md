---
name: legacy-migration
description: 레거시 프로젝트의 기능을 별도의 신규 프로젝트로 옮기는 "이관(migration)" 작업에만 사용한다. 사용자가 레거시 경로를 지목하며 이관·마이그레이션·포팅을 요청하거나, 이관 스펙 승인·구현·검증을 요청할 때 적용한다. 레거시 분석 → 스펙 승인 → 구현 → 검증 워크플로우와 컨벤션 주입 규칙을 제공한다. 같은 프로젝트 안에서 하는 일반 작업(새 기능 개발, 버그 수정, 리팩터링, 코드 읽기·질문, 테스트 작성, 커밋·PR)에는 적용하지 않는다.
---

# Legacy Migration Workflow

레거시 기능을 근거 기반 스펙으로 정리하고, 사람이 승인한 범위만 새 프로젝트에 구현한다.

**적용 대상이 아니면 즉시 빠진다.** 요청이 이관(레거시 → 신규 프로젝트)이 아니라 같은 프로젝트 안의 일반 작업이면, 이 스킬의 절차를 적용하지 말고 평소대로 처리한다. 이관인지 애매하면 "이관 작업인가요, 이 프로젝트 내 작업인가요?"라고 한 번 묻는다.

## 불변 규칙 7조

1. **레거시 저장소는 read-only다.** credential·실서버 주소·실데이터는 어떤 문서에도 넣지 않는다.
2. **구현은 사람 승인 후에만 한다.** Light: `02_Spec.md`의 구현 승인 체크박스. Full: `03_Plan.md`의 `Implementation Permission: Granted`. 승인 범위는 task ID로 정의되며, task 없는 구현은 없다. (플러그인 훅이 강제한다)
3. **인용 없는 근거는 근거가 아니다.** 근거는 `파일경로:라인` + 코드 1~3줄 인용만 인정한다. 인용이 없으면 "미확인"이고, 미확인은 추측해서 구현하지 않는다.
4. **모든 작업 턴은 [완료 보고] 또는 [멈춤 보고] 형식으로 끝난다.** 형식은 단계 커맨드에 정의돼 있다.
5. **구현을 시작할 때는 `/legacy-migration:implement`의 절차를 따라 [구현 착수] 블록을 채워 출력한 뒤 진행한다.** 착수 블록에 쓴 범위가 그 턴의 계약이다.
6. **멈춤 조건은 여섯 가지다** — 스펙 밖 동작 / task 없는 대상 / 기존 코드 교체·삭제 / 공유 코드 영향 / 미해결 테스트 실패 / 컨벤션·스펙 충돌. 이때만 [멈춤 보고]로 질문하고, 그 외에는 멈추지 않는다.
7. **push와 PR/MR 생성은 사용자가 명시적으로 요청할 때만 한다.** 테스트 실패를 숨기거나 없는 evidence를 만들지 않는다. 이관 작업은 `feature/ai-migration-<기능명>` 브랜치에서만 한다.

## 진행 방법

사용자가 이관을 요청하면 임의 절차를 만들지 말고 단계 커맨드로 안내하거나 그 커맨드의 절차를 그대로 따른다:

| 상황 | 커맨드 |
|---|---|
| **프로젝트 최초 세팅 (프로젝트당 1회)** | `/legacy-migration:setup` |
| 컨벤션 등록 (직접 입력/참고 프로젝트 추출) | `/legacy-migration:conventions [참고경로]` |
| 일반 기능 이관 시작 (분석 + 스펙 초안) | `/legacy-migration:start <기능명> <레거시경로>` |
| 스펙 승인 후 구현 | `/legacy-migration:implement <기능명>` |
| 결제·인증·PII·공유 코드·cutover | `/legacy-migration:full` |
| 이관 문서 구조 검사 | `/legacy-migration:validate <케이스명>` |

자연어 요청도 같은 절차를 따른다. 분석·스펙 단계와 구현 단계를 한 턴에 이어서 진행하지 않는다. 어느 단계인지 애매하거나 도움말을 물으면 위 표와 현재 상태(`docs/conventions/` 등록 여부, 진행 중 케이스)를 보여주고 확인한다.

## 서브에이전트 (분석 품질용)

메인 대화의 컨텍스트를 지키고 독립적 검증을 얻기 위해 아래 에이전트에 위임한다. 셋 다 읽기 전용이라 문서·코드를 고치지 못한다 — 결과는 사람이 확인하고 메인에서 반영한다.

| 언제 | 에이전트 |
|---|---|
| 화면·기능에서 도달 가능한 endpoint를 빠짐없이 찾을 때 (Discover) | `legacy-explorer` |
| 스펙 초안을 사람 승인에 올리기 전 (Specify 종료) | `spec-gap-hunter` |
| 개선 후보 대장을 채울 때 (Discover 이후) | `improvement-scout` |

## 리소스

- Light 템플릿(3문서): `${CLAUDE_PLUGIN_ROOT}/templates/migration-docs-light/`
- Full 템플릿(8문서): `${CLAUDE_PLUGIN_ROOT}/templates/migration-docs/` · OpenSpec: `${CLAUDE_PLUGIN_ROOT}/templates/openspec-change/`
- 컨벤션 템플릿: `${CLAUDE_PLUGIN_ROOT}/templates/conventions/` — `docs/conventions/`에서 **Approved** 문서만 binding이며, `binding-rules`(10줄)는 구현 직전 다시 읽는다. 컨벤션끼리 또는 스펙과 충돌하면 멈추고 묻는다.
- Full 모드 사람용 가이드: `${CLAUDE_PLUGIN_ROOT}/guides/walkthrough-full-mode.md`
