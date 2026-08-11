---
description: Full 모드 이관 (결제·인증·PII·공유 코드·cutover — 8문서 + OpenSpec + Human Gate)
argument-hint: <기능명> <레거시-repo-경로>
---

민감/고위험 기능의 Full 모드 이관을 진행한다. 기능명: $1, 레거시 경로: $2

Full 모드 대상: 결제, 인증, 개인정보(PII), 여러 기능이 공유하는 코드, production cutover 판단이 필요한 케이스.

[진행 방식]
1. `${CLAUDE_PLUGIN_ROOT}/guides/walkthrough-full-mode.md`의 단계 절차(Discover → Specify → OpenSpec → Plan → Implement → Validate → Archive)를 따른다.
2. 문서 템플릿: `${CLAUDE_PLUGIN_ROOT}/templates/migration-docs/` (8문서) + `${CLAUDE_PLUGIN_ROOT}/templates/openspec-change/`. **템플릿 구조가 곧 계약이다** — 섹션을 지우지 말고 채운다. (API 목록 표 + API별 상세 섹션, tasks.md의 PLAN/IMPL/VAL triad, External Route Matrix 등은 Validator가 기계 검사한다.)
3. 각 단계 산출물마다 `/legacy-migration:validate`로 문서 검사를 돌린다 (`--root docs/migration/<케이스>` + `--root changes/<change>`).

[Human Gate — 사람 확인 없이 다음 단계로 넘어가지 않는 지점]
- Discover, Specify, Plan 각각의 산출물 승인.
- 정책 차이·응답/에러/날짜/페이징·보안 결정은 전부 Open Question으로 기록하고 사람 결정을 기다린다. **Open OQ가 남아 있으면 Implementation Permission을 Granted하지 않는다.**
- Implementation Permission은 item(task) 단위로만 부여된다. 기록이 없으면 Not Granted다.

[구현 단계]
- `/legacy-migration:implement`의 절차를 그대로 따른다 — 승인 확인(Approved binding + PASS baseline 또는 승인된 baseline 예외) → **[구현 착수] 블록 출력** → 세로 슬라이스 묶음 구현 → verify 최대 3회 수정 루프 → **[완료 보고]/[멈춤 보고]**로 종료.
- 자동 검증 PASS는 완료가 아니라 `READY FOR HUMAN REVIEW`다.

[검토 단계 — Full도 동일하게 거친다]
- `/legacy-migration:review`로 `migration-reviewer`(읽기 전용) 독립 대조를 수행한다. 결과는 `05_Validate.md`와 `06_Archive.md`의 최종 검토·carry-forward에 기록한다.
- `FIX REQUIRED`면 구현 수정 루프로 돌려보낸다. AI가 발견 사항을 임의로 고치지 않는다.

[승인 3종을 구분한다 — 서로를 대신하지 않는다]

| 승인 | 의미 | 근거 |
|---|---|---|
| **Implementation Permission** | 이 task를 구현해도 된다 | `03_Plan.md`, item 단위 |
| **사람 최종 승인(완료)** | 구현 결과를 완료로 인정한다 | 결과 문서의 승인 체크박스 |
| **Production / Cutover 승인** | 운영 전환해도 된다 | 별도 판단 |

- **Validator PASS는 문서 구조 품질 게이트일 뿐이다.** 완료도, domain correctness도, Production Readiness도 의미하지 않는다.
- **Archive와 Production/Cutover를 구분한다.** `Archive with Conditions`는 정상 종료지만 운영 전환 승인이 아니다. `06_Archive.md`의 carry-forward에서 `Blocks Phase Archive`와 `Blocks Production/Cutover`를 따로 표시한다.
- AI는 어떤 승인 체크박스도 대신 체크하지 않는다.

[종료 조건]
케이스 타입/범위 불명확, 컨벤션 미승인, 정책 미결, 예상 밖 공유 영향, 테스트 환경 unsafe, 민감정보 노출 위험 — 하나라도 해당하면 [멈춤 보고]로 사용자에게 보고한다.
