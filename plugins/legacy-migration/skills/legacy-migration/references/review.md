---
description: 구현·자동검증 결과를 독립 대조하고 사람 최종 승인 단계까지 준비
argument-hint: <기능명>
---

# 최종 검토 절차

자동 검증 PASS 이후, 사람이 완료를 승인하기 전에 수행한다. 이 단계에서 새로운 기능을 구현하거나 발견 사항을 임의로 고치지 않는다.

## 0. 입력 확인

- Light: `01_Analysis.md`, 승인된 `02_Spec.md`, `03_Result.md`
- Full: `02_Specify.md`, `03_Plan.md`, `04_Implement.md`, `05_Validate.md`, tasks.md
- Approved `docs/conventions/`와 `binding-rules.md`
- 현재 branch의 base 대비 diff
- 완료 보고가 인용한 실제 `reports/verify-*.txt` PASS 리포트

문서, 승인, PASS 리포트 중 하나라도 없으면 `BLOCKED`로 보고한다.

## 1. 독립 검토

`migration_reviewer`를 읽기 전용으로 호출해 다음을 대조한다.

1. 승인 API·AC와 구현 코드·테스트
2. 범위 제외와 실제 diff
3. Approved binding 규칙과 변경 코드
4. 성공·빈 결과·잘못된 입력·외부 실패 검증
5. 레거시와 다른 동작의 승인된 분류 여부
6. verify PASS 리포트의 실제 존재와 결과

role이 설치되지 않았으면 새 스레드가 필요한지 안내한다. 새 스레드를 열 수 없는 환경에서는 부모가 같은 체크리스트를 수행하되 독립 검토가 아니었음을 명시한다.

## 2. 판정

- `FIX REQUIRED`: 스펙 누락, 범위 이탈, binding 위반, 테스트/AC 누락이 있음. reviewer는 고치지 않지만 부모 구현 agent는 발견이 승인된 수정 범위 안이면 같은 Goal에서 자동 수정 → 대상 테스트 → verify → 독립 검토를 반복한다. 새 스펙 결정이나 범위 확대가 필요할 때만 사람에게 보고한다.
- `BLOCKED`: evidence 또는 사람 결정이 부족함. 필요한 입력을 질문한다.
- `READY FOR HUMAN REVIEW`: 자동·독립 검토상 차단 항목이 없음. 이것은 완료 승인이 아니다.

Light는 `03_Result.md`의 `독립 검토`에 범위·발견·미확인을 기록한다. Full은 `05_Validate.md`와 `06_Archive.md`의 최종 검토/carry-forward에 기록한다.

## 3. 사람 최종 승인

다음을 사용자에게 보여주고 멈춘다.

```text
[최종 검토 준비 완료]
- 판정: READY FOR HUMAN REVIEW
- 승인 스펙 대조: <API/AC 범위>
- 변경 범위 대조: <범위 내 / 예외>
- 자동 검증: <리포트 경로> (PASS)
- 독립 검토: <발견 없음 / 남은 참고 항목>
- 남은 위험: <목록>
- 다음 행동: 결과 문서의 사람 최종 승인 체크박스를 직접 검토하고 체크
```

사람 최종 승인 체크 전 상태는 완료가 아니라 `READY FOR HUMAN REVIEW`다. AI는 승인 체크박스를 대신 체크하지 않는다.

`FIX REQUIRED`는 사람에게 중간 승인을 다시 받는 단계가 아니다. 승인 범위 안의 수정이면 final 응답을 보내지 않고 implement 루프로 복귀한다.
