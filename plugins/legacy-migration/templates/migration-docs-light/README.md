# Light 모드 — 실전 이관용 최소 문서 세트

기능 하나를 실제로 이관할 때 쓰는 기본 모드다. 파일 3개, 규칙 3개.

## 규칙 3개

1. **레거시는 read-only.** 분석 단계에서 AI는 레거시 코드를 읽기만 한다.
2. **계약은 사람이 승인한 뒤 구현한다.** `02_Spec.md`의 승인 체크 전에는 코드를 만지지 않는다.
3. **격리 브랜치에서만 작업한다.** merge 전 리뷰 필수, 실패하면 브랜치 삭제가 곧 롤백이다.

## 파일 3개

| 파일 | 내용 | 언제 쓰나 |
|---|---|---|
| `01_Analysis.md` | 레거시가 하는 일 + Target 현재 상태 + 차이 | 시작할 때 (AI 분석 결과 기록) |
| `02_Spec.md` | 이관 후 동작 계약 + 사람 결정 체크 + 구현 승인 | 코드 작성 전 |
| `03_Result.md` | 구현·검증한 것 / 못 한 것 / 롤백 방법 | 끝낼 때 |

## Full 모드로 올려야 할 때

다음 중 하나라도 해당하면 `templates/migration-docs/` 8-file 세트를 사용한다
(절차는 [Full 모드 상세 가이드](../../guides/walkthrough-full-mode.md) 참조):

- 결제, 인증/인가, 개인정보 처리
- 여러 feature가 공유하는 코드/쿼리 변경
- 외부 시스템 연동 write 흐름
- cutover(레거시 중단) 판단 포함

## Validator 주의

현재 Validator CLI는 **Full 모드 8-file 세트 전용**이다. Light 모드 문서에 실행하면
required-document 오류가 나는 것이 정상이며, Light 모드 검증은 `02_Spec.md` 승인 체크와
사람 리뷰로 대신한다. (Light 모드 검사 지원은 validator vNext 후보)
