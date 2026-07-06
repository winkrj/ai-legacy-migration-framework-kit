# migrate-full — Full 모드 이관 (결제·인증·PII·공유 코드·cutover)

인자: `<기능명> <레거시-repo-경로>`

민감/고위험 기능의 Full 모드 이관을 진행한다. Kit의 `guides/walkthrough-full-mode.md` 절차와 `templates/migration-docs/`(Discover → Specify → Plan → Implement → Validate → Archive + Open Questions), `templates/openspec-change/`를 사용한다.

[Light 모드 규칙에 추가]
- 단계별 Human Gate: Discover, Specify, Plan 각각의 산출물에 대해 사용자 확인 없이 다음 단계로 넘어가지 않는다.
- Policy Difference, 응답/에러/날짜·시간/페이징, 보안/권한 결정은 전부 Open Question으로 기록하고 사람 결정을 기다린다.
- Implementation Permission이 rule 단위로 명시된 항목만 구현한다. 기록이 없으면 `Not Allowed`다.
- Runtime evidence는 실제 수행한 것만 기록한다. 없는 evidence를 만들지 않는다.
- 각 단계 산출물마다 `/migrate-validate`로 문서 검사를 돌린다.

[종료 조건]
케이스 타입/범위 불명확, 컨벤션 미승인, 정책 미결, 예상 밖 공유 영향, 테스트 환경 unsafe, 민감정보 노출 위험 — 하나라도 해당하면 멈추고 사용자에게 보고한다.
