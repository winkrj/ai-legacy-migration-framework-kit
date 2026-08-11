---
description: 구현·자동검증 결과를 독립 대조하고 사람 최종 승인 단계까지 준비
argument-hint: <기능명>
---

자동 검증이 PASS한 뒤, 사람이 완료를 승인하기 전에 수행한다. 기능명: $1 (비어 있으면 현재 브랜치 `feature/ai-migration-<기능명>`에서 추출하고, 그래도 없으면 사용자에게 물어본다.)

**이 단계에서 새 기능을 구현하거나 발견 사항을 임의로 고치지 않는다.**

[0. 입력 확인 — 하나라도 없으면 `BLOCKED`로 보고하고 종료]
- Light: `01_Analysis.md`, 승인된 `02_Spec.md`(구현 승인 체크박스 `- [x]`), `03_Result.md`
- Full: `02_Specify.md`, `03_Plan.md`(`Implementation Permission: Granted*`), `04_Implement.md`, `05_Validate.md`, `changes/<change>/tasks.md`
- Approved `docs/conventions/binding-rules.md`
- 현재 브랜치의 base 대비 diff
- 완료 보고가 인용한 `reports/verify-*.txt` — **경로만 믿지 말고 파일을 열어 존재와 `결과: PASS`를 확인한다.**

[1. 독립 검토 — `migration-reviewer` 서브에이전트에 위임]

`migration-reviewer`(읽기 전용)를 호출해 다음을 대조하게 한다. **부모가 직접 대조하지 않는다** — 구현한 주체는 자기 누락을 보지 못한다.

1. 승인 API·AC ↔ 구현 코드·테스트
2. 범위 제외 ↔ 실제 diff
3. Approved binding 규칙 ↔ 변경 코드
4. 성공·빈 결과·잘못된 입력·외부 실패 검증 여부
5. 레거시와 다른 동작의 승인된 분류 여부
6. verify PASS 리포트의 실제 존재와 결과

에이전트에는 대조에 필요한 경로(스펙 문서, 변경 파일 목록, binding-rules, verify 리포트)를 명시해 넘긴다. 서브에이전트는 대화 맥락을 상속받지 않는다.

[2. 판정]
- **FIX REQUIRED** — 스펙 누락·범위 이탈·binding 위반·테스트/AC 누락이 있다. **직접 고치지 않는다.** 발견을 근거와 함께 보고하고 `/legacy-migration:implement`의 수정 루프로 돌려보낸다.
- **BLOCKED** — evidence 또는 사람 결정이 부족하다. 필요한 입력을 질문한다.
- **READY FOR HUMAN REVIEW** — 자동·독립 검토상 차단 항목이 없다. **완료 승인이 아니다.**

기록 위치: Light는 `03_Result.md`의 `독립 검토` 절에 범위·발견·확인하지 못한 범위를 적는다. Full은 `05_Validate.md`와 `06_Archive.md`의 최종 검토·carry-forward에 적는다.

[3. 사람 최종 승인 — 다음을 출력하고 멈춘다]

```
[최종 검토 준비 완료]
- 판정: READY FOR HUMAN REVIEW
- 승인 스펙 대조: <API/AC 범위>
- 변경 범위 대조: <범위 내 / 예외>
- 자동 검증: <리포트 경로> (PASS)
- 독립 검토: <발견 없음 / 남은 참고 항목>
- 남은 위험: <목록>
- 다음 행동: 결과 문서의 사람 최종 승인 체크박스를 직접 검토하고 체크
```

**사람 최종 승인 체크 전 상태는 완료가 아니라 `READY FOR HUMAN REVIEW`다. AI는 승인 체크박스를 대신 체크하지 않는다.**

commit·push·MR은 사용자가 명시적으로 요청할 때만 한다.
