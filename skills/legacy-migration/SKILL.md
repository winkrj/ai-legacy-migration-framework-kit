---
name: legacy-migration
description: 레거시 기능을 별도 Target 프로젝트로 옮기는 이관 작업에 사용한다. 레거시 경로와 이관·수정 범위를 받아 분석·스펙·사람 승인·구현·테스트·수정·재검증을 수행한다. 진행 중인 이관에서 사용자가 "계속", "해", "완성해", "끝까지"처럼 짧게 이어가도 적용한다. 같은 프로젝트 안의 일반 개발·버그 수정·리팩터링·커밋에는 적용하지 않는다.
---

# Legacy Migration Workflow

레거시 기능을 근거 기반 스펙으로 정리하고, 사람이 승인한 범위만 새 프로젝트에 구현한다.

**적용 대상이 아니면 즉시 빠진다.** 요청이 이관(레거시 → 신규 프로젝트)이 아니라 같은 프로젝트 안의 일반 작업이면, 이 스킬의 절차를 적용하지 말고 평소대로 처리한다. 이관인지 애매하면 "이관 작업인가요, 이 프로젝트 내 작업인가요?"라고 한 번 묻는다.

## 불변 규칙 7조

1. **레거시 저장소는 read-only다.** credential·실서버 주소·실데이터는 어떤 문서에도 넣지 않는다.
2. **사람 승인 지점은 구현 전 한 번이다.** 분석·스펙·Plan을 승인 패키지로 준비하고, Light는 `02_Spec.md`, Full은 `03_Plan.md`에서 이관 범위·허용 수정 범위·task를 함께 승인한다. 승인 전 구현은 훅이 차단한다.
3. **인용 없는 근거는 근거가 아니다.** 근거는 `파일경로:라인` + 코드 1~3줄 인용만 인정한다. 인용이 없으면 "미확인"이고, 미확인은 추측해서 구현하지 않는다.
4. **구현 턴은 [완료 보고] 또는 [멈춤 보고]로만 끝난다.** `진행하겠습니다` 같은 실행 선언, 부분 패치, 컴파일 한 번은 종료가 아니다. 다음 안전한 작업이 있으면 도구 호출을 이어간다. 구현 검증 PASS는 `READY FOR HUMAN REVIEW`일 뿐이며, **사람 최종 승인 전에는 완료로 표시하지 않는다.**
5. **승인 후에는 `/legacy-migration:implement`의 지속 실행 루프를 따른다.** 승인 범위를 Goal로 등록하고 구현 → 테스트·검증 → 수정 → 재검증 → 독립 검토를 `READY FOR HUMAN REVIEW`까지 이어간다.
6. **멈춤은 새 사람 결정이 필요한 실제 blocker뿐이다.** 승인된 수정 범위 밖 변경 / 스펙·정책 변경 / credential·unsafe 환경 / 테스트를 약화해야만 통과 / 같은 실패가 3회 연속 진전 없음일 때만 멈춘다. 승인 범위에 기록된 기존 코드 교체·삭제·공유 코드 수정은 멈춤 사유가 아니다.
7. **push와 PR/MR 생성은 사용자가 명시적으로 요청할 때만 한다.** 테스트 실패를 숨기거나 없는 evidence를 만들지 않는다. 이관 작업은 `feature/ai-migration-<기능명>` 브랜치에서만 한다.

## 진행 방법

사용자가 이관을 요청하면 임의 절차를 만들지 말고 해당 커맨드의 절차를 그대로 실행한다. 커맨드 이름만 알려주고 응답을 끝내지 않는다:

| 상황 | 커맨드 |
|---|---|
| **프로젝트 최초 세팅 (프로젝트당 1회)** | `/legacy-migration:setup` |
| 컨벤션 등록 (직접 입력/참고 프로젝트 추출) | `/legacy-migration:conventions [참고경로]` |
| 일반 기능 이관 시작 (분석 + 스펙 초안) | `/legacy-migration:start <기능명> <레거시경로>` |
| 스펙 승인 후 구현 | `/legacy-migration:implement <기능명>` |
| 구현·검증 후 독립 검토 및 사람 최종 승인 준비 | `/legacy-migration:review <기능명>` |
| 결제·인증·PII·공유 코드·cutover | `/legacy-migration:full` |
| 이관 문서 구조 검사 | `/legacy-migration:validate <케이스명>` |

자연어 요청도 같은 절차를 따른다. 분석·스펙 단계와 구현 단계를 한 턴에 이어서 진행하지 않는다. 어느 단계인지 애매하거나 도움말을 물으면 위 표와 현재 상태(`docs/conventions/` 등록 여부, 진행 중 케이스)를 보여주고 확인한다.

### 상태 머신

`SCOPE → ANALYZE_AND_SPEC → AWAITING_HUMAN_APPROVAL → EXECUTION_LOOP → READY_FOR_HUMAN_REVIEW → COMPLETE`

- `ANALYZE_AND_SPEC`에서 Light/Full에 필요한 분석·스펙·Plan을 한 번에 준비한다. Full이라는 이유로 중간 승인을 추가하지 않는다.
- 사람은 이관 범위, 허용 수정 범위, task, 테스트 범위를 한 번 승인한다.
- `EXECUTION_LOOP`에서는 중간 사람 응답을 요구하지 않는다. 실패를 승인 범위 안에서 고치고 다시 검증한다.
- 진행 중 케이스가 `EXECUTION_LOOP`이면 `그래`, `해`, `완성해`, `계속`도 같은 Goal의 계속 요청이다.

### 사용자에게 보이는 기본 흐름

내부 문서 단계는 유지하되 사용자가 파일명이나 세부 명령을 외울 필요는 없게 한다.

1. "이 프로젝트를 이관용으로 세팅해줘" → setup
2. "기능을 레거시 경로에서 분석하고 스펙 검토 단계까지 진행해줘" → start / full
3. 사람이 스펙을 승인한 뒤 "승인 범위를 구현하고 검증해줘" → implement
4. "최종 검토해줘" → review, 이후 사람 최종 승인

setup 산출물이 없는데 start/full 요청이 오면 먼저 preflight를 수행하고, 기존 파일을 덮어쓰지 않는 setup을 선행한다.

## 서브에이전트 (분석 품질용)

메인 대화의 컨텍스트를 지키고 독립적 검증을 얻기 위해 아래 에이전트에 위임한다. 넷 다 읽기 전용이라 문서·코드를 고치지 못한다 — 결과는 사람이 확인하고 메인에서 반영한다.

| 언제 | 에이전트 |
|---|---|
| 화면·기능에서 도달 가능한 endpoint를 빠짐없이 찾을 때 (Discover) | `legacy-explorer` |
| 스펙 초안을 사람 승인에 올리기 전 (Specify 종료) | `spec-gap-hunter` |
| 개선 후보 대장을 채울 때 (Discover 이후) | `improvement-scout` |
| 구현·자동검증 종료 후 사람 최종 승인 전 | `migration-reviewer` |

## 리소스

- Light 템플릿(3문서): `${CLAUDE_PLUGIN_ROOT}/templates/migration-docs-light/`
- Full 템플릿(8문서): `${CLAUDE_PLUGIN_ROOT}/templates/migration-docs/` · OpenSpec: `${CLAUDE_PLUGIN_ROOT}/templates/openspec-change/`
- 컨벤션 템플릿: `${CLAUDE_PLUGIN_ROOT}/templates/conventions/` — `docs/conventions/`에서 **Approved** 문서만 binding이며, `binding-rules`(10줄)는 구현 직전 다시 읽는다. 컨벤션끼리 또는 스펙과 충돌하면 멈추고 묻는다.
- Full 모드 사람용 가이드: `${CLAUDE_PLUGIN_ROOT}/guides/walkthrough-full-mode.md`
