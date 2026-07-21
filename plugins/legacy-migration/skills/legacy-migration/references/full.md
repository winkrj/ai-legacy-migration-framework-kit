---
description: Full 모드 이관 (결제·인증·PII·공유 코드·cutover — 8문서 + OpenSpec + Human Gate)
argument-hint: <기능명> <레거시-repo-경로>
---

민감/고위험 기능의 Full 모드 이관을 진행한다. 기능명: $1, 레거시 경로: $2

Full 모드 대상: 결제, 인증, 개인정보(PII), 여러 기능이 공유하는 코드, production cutover 판단이 필요한 케이스.

[진행 방식]
1. 단계 절차는 Discover → Specify → OpenSpec → Plan → Implement → Validate → Archive. 각 단계의 AI 절차는 `${PLUGIN_ROOT}/prompts/codex/01~07`을 따르고, 사람용 상세는 `${PLUGIN_ROOT}/guides/walkthrough-full-mode.md`.
2. 문서 템플릿: `${PLUGIN_ROOT}/templates/migration-docs/` (8문서) + `${PLUGIN_ROOT}/templates/openspec-change/`. **템플릿 구조가 곧 계약이다** — 섹션을 지우지 말고 채운다. (API 목록 표 + API별 상세 섹션, tasks.md의 PLAN/IMPL/VAL triad, External Route Matrix 등은 Validator가 기계 검사한다.)
3. 각 단계 산출물마다 Validator CLI로 문서 검사를 돌린다 (`--root docs/migration/<케이스>` + `--root changes/<change>`).

[Human Gate — 사람 확인 없이 다음 단계로 넘어가지 않는 지점]
- Discover, Specify, Plan 각각의 산출물 승인.
- 정책 차이·응답/에러/날짜/페이징·보안 결정은 전부 Open Question으로 기록하고 사람 결정을 기다린다. **Open OQ가 남아 있으면 Implementation Permission을 Granted하지 않는다.**
- Implementation Permission은 item(task) 단위로만 부여된다. 기록이 없으면 Not Granted다.

[구현 단계]
- `references/implement.md`의 절차를 그대로 따른다 — 승인 확인 → **[구현 착수] 블록 출력** → 세로 슬라이스 묶음 구현 → **[완료 보고]/[멈춤 보고]**로 종료.

[종료 조건]
케이스 타입/범위 불명확, 컨벤션 미승인, 정책 미결, 예상 밖 공유 영향, 테스트 환경 unsafe, 민감정보 노출 위험 — 하나라도 해당하면 [멈춤 보고]로 사용자에게 보고한다.
