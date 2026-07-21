---
name: legacy-migration
description: 레거시 코드 분석, 기능 이관, 마이그레이션 스펙 작성, 레거시-신규 프로젝트 비교, 프로젝트 컨벤션 추출을 요청할 때 사용한다. 분석과 구현을 사람 승인 게이트로 분리한다.
---

# Legacy Migration Workflow

레거시 기능을 근거 기반 스펙으로 정리하고, 사람이 승인한 범위만 Target 프로젝트에 구현한다.

## 불변 규칙 7조

1. **레거시 저장소는 read-only다.** credential·실서버 주소·실데이터는 어떤 문서에도 넣지 않는다.
2. **구현은 사람 승인 후에만 한다.** Light: `02_Spec.md`의 구현 승인 체크박스. Full: `03_Plan.md`의 `Implementation Permission: Granted`. 승인 범위는 task ID로 정의되며, task 없는 구현은 없다. (훅이 강제한다)
3. **인용 없는 근거는 근거가 아니다.** 근거는 `파일경로:라인` + 코드 1~3줄 인용만 인정한다. 인용이 없으면 "미확인"이고, 미확인은 추측해서 구현하지 않는다.
4. **모든 작업 턴은 [완료 보고] 또는 [멈춤 보고] 형식으로 끝난다.** 형식은 각 단계 reference에 정의돼 있다.
5. **구현을 시작할 때는 `references/implement.md`를 열고, 그 안의 [구현 착수] 블록을 채워 출력한 뒤 진행한다.** 착수 블록에 쓴 범위가 그 턴의 계약이다.
6. **멈춤 조건은 여섯 가지다** — 스펙 밖 동작 / task 없는 대상 / 기존 코드 교체·삭제 / 공유 코드 영향 / 미해결 테스트 실패 / 컨벤션·스펙 충돌. 이때만 [멈춤 보고]로 질문하고, 그 외에는 멈추지 않는다.
7. **push와 PR/MR 생성은 사용자가 명시적으로 요청할 때만 한다.** 테스트 실패를 숨기거나 없는 evidence를 만들지 않는다.

## 모드 선택

요청에 맞는 reference를 읽고 그대로 따른다.

| 상황 | reference |
|---|---|
| 컨벤션 등록/추출 | `references/conventions.md` |
| 기능 분석 + 스펙 초안 | `references/start.md` |
| 승인된 스펙 구현 | `references/implement.md` |
| 결제·인증·PII·공유 코드·cutover | `references/full.md` |
| 이관 문서 구조 검사 | `references/validate.md` |

사용자가 자연어로 요청해도 같은 절차를 적용한다. 요청이 어느 모드인지 애매하거나 도움말을 물으면 위 표를 보여주고 확인한다.

## 리소스

플러그인 루트는 설치 환경의 `PLUGIN_ROOT`다. (`${CLAUDE_PLUGIN_ROOT}`도 같은 위치로 해석)

- 템플릿: `${PLUGIN_ROOT}/templates/` (Light 3문서 / Full 8문서 / OpenSpec / 컨벤션 / runtime-evidence)
- Full 모드 사람용 가이드: `${PLUGIN_ROOT}/guides/walkthrough-full-mode.md`
- 컨벤션: `docs/conventions/`에서 **Approved** 문서만 binding이다. `binding-rules`(10줄)는 구현 직전 다시 읽는다.
