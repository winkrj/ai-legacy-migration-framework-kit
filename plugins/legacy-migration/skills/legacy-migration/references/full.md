---
description: Full 모드 이관 (결제·인증·PII·공유 코드·cutover — 8문서 + OpenSpec + Human Gate)
argument-hint: <기능명> <레거시-repo-경로>
---

민감/고위험 기능의 Full 모드 이관을 진행한다. 기능명: $1, 레거시 경로: $2

Full 모드 대상: 결제, 인증, 개인정보(PII), 여러 기능이 공유하는 코드, production cutover 판단이 필요한 케이스.

[진행 방식]
1. `${CLAUDE_PLUGIN_ROOT}/guides/walkthrough-full-mode.md`를 읽고 그 절차를 따른다.
2. 문서 템플릿은 `${CLAUDE_PLUGIN_ROOT}/templates/migration-docs/` (Discover → Specify → Plan → Implement → Validate → Archive + Open Questions)를 사용한다.
3. OpenSpec change는 `${CLAUDE_PLUGIN_ROOT}/templates/openspec-change/`를 사용한다.
4. 각 단계 산출물마다 `/legacy-migration:validate`로 문서 검사를 돌린다.

[Light 모드와 동일한 절대 규칙에 추가되는 것]
- 단계별 Human Gate: Discover, Specify, Plan 각각의 산출물에 대해 사용자 확인 없이 다음 단계로 넘어가지 않는다.
- **문서 단위**: 큰 단위 = 메뉴/feature, 상세 계약 단위 = API, 구현/검증 단위 = task ID.
- **`02_Specify.md`는 API 상세 스펙 표 필수** — 각 API를 한 행으로, 행마다 API ID / Method·Path / 기능명 / 레거시 근거 / 요청 / 응답 / DB R·W / 외부연동 / business rule / empty·error 정책 / 미결(OQ) / 연결 Task ID.
- **`tasks.md`는 API ID 기준으로 생성** — 각 API마다 `PLAN-API-NNN` / `IMPL-API-NNN` / `VAL-API-NNN` 세 task를 만들고 requirement/API spec과 연결한다.
- **인용 없는 근거는 근거가 아니다** — 모든 레거시 근거는 `파일경로:라인` + 코드 1~3줄 인용. 응답값만 보고 로직을 판단하지 않는다.
- **외부 연동이 있는 API는 External Route Matrix 필수** — 직접 vs 프록시를 환경설정 인용으로 확정, 환경별 host/base path/인증 표.
- **구현은 task ID 기준 + 2-pass** — Implementation Permission이 Granted된 `IMPL-API-NNN`만 구현한다. task ID 없는 구현은 금지. Pass 1(동작+테스트) 후 Pass 2(정리)를 별도로 돌고 04_Implement에 기록한다. Approved binding 컨벤션은 구현 직전 재주입. 예상 밖 API·파일·외부 연동을 발견하면 멈추고 질문한다. 구현 후 task와 validation evidence를 갱신한다.
- Policy Difference, 응답/에러/날짜·시간/페이징, 보안/권한 관련 결정은 전부 Open Question으로 기록하고 사람 결정을 기다린다. **미해결(Open) Open Question이 있으면 Implementation Permission을 Granted하지 않는다.**
- Runtime evidence는 실제 수행한 것만 기록한다. 없는 evidence를 만들지 않는다.

[종료 조건]
케이스 타입/범위 불명확, 컨벤션 미승인, 정책 미결, 예상 밖 공유 영향, 테스트 환경 unsafe, 민감정보 노출 위험 — 하나라도 해당하면 멈추고 사용자에게 보고한다.
