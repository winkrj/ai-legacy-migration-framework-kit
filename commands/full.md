---
description: 고위험 이관의 분석·스펙·Plan 승인 패키지 작성 (사람 승인 1회)
argument-hint: <기능명> <레거시-repo-경로>
---

민감/고위험 기능의 Full 모드 이관을 진행한다. 기능명: $1, 레거시 경로: $2

Full 모드 대상: 결제, 인증, 개인정보(PII), 여러 기능이 공유하는 코드, production cutover 판단이 필요한 케이스.

[진행 방식]
1. 내부 문서 순서는 Discover → Specify → OpenSpec → Plan → Implement → Validate → Archive지만, 사용자에게 보이는 흐름은 **범위 입력 → 분석·스펙·Plan 패키지 → 사람 승인 1회 → 지속 실행 루프**다. `${CLAUDE_PLUGIN_ROOT}/guides/walkthrough-full-mode.md`를 따른다.
2. 문서 템플릿: `${CLAUDE_PLUGIN_ROOT}/templates/migration-docs/` (8문서) + `${CLAUDE_PLUGIN_ROOT}/templates/openspec-change/`. **템플릿 구조가 곧 계약이다** — 섹션을 지우지 말고 채운다. (API 목록 표 + API별 상세 섹션, tasks.md의 PLAN/IMPL/VAL triad, External Route Matrix 등은 Validator가 기계 검사한다.)
3. Discover·Specify·Plan을 연속 작성하고 `/legacy-migration:validate`로 승인 패키지를 검사한다 (`--root docs/migration/<케이스>` + `--root changes/<change>`). production 코드는 아직 작성하지 않는다.

[단일 Human Gate]
- 사람은 `03_Plan.md`에서 이관 범위, 허용 수정 범위, 교체·삭제·공유 코드 변경, task, 테스트 범위를 한 번에 검토한다.
- `Open` 상태는 구현 전에 사람 결정이 필요한 질문에만 사용한다. `Open`이 하나라도 있으면 승인하지 않는다. runtime evidence와 cutover 질문은 `Pending Manual Evidence` 또는 `Deferred`로 분류하며 구현을 막지 않는다.
- 이미 사용자 결정이나 Approved 컨벤션으로 답이 난 항목은 `Resolved`로 기록하고 다시 묻지 않는다.
- `Implementation Permission: Granted`는 `03_Plan.md`에 열거된 task 전체와 구현 → 테스트·검증 → 수정 → 재검증 루프를 승인한다. 목록 밖 task는 승인되지 않는다.

[구현 단계]
- 승인 후 `/legacy-migration:implement`를 따른다. 승인 범위를 지속 Goal로 등록하고 구현 → 대상 테스트 → 수정 → 전체 verify → 수정 → 독립 검토를 완료까지 이어간다.
- 자동 검증 PASS는 완료가 아니라 `READY FOR HUMAN REVIEW`다.

[검토 단계 — Full도 동일하게 거친다]
- `/legacy-migration:review`로 `migration-reviewer`(읽기 전용) 독립 대조를 수행한다. 결과는 `05_Validate.md`와 `06_Archive.md`의 최종 검토·carry-forward에 기록한다.
- `FIX REQUIRED`면 승인 범위 안의 발견은 같은 지속 Goal의 구현 수정 루프로 자동 반환한다. 범위·스펙 변경이 필요할 때만 사람에게 묻는다.

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
승인된 수정 범위 밖 변경, 스펙·정책 변경, credential·unsafe 환경, 테스트를 약화해야만 통과, 같은 실패가 3회 연속 진전 없음일 때만 [멈춤 보고]한다. 승인 문서에 포함된 기존 기능 교체·삭제·공유 코드 영향은 멈춤 조건이 아니다.
