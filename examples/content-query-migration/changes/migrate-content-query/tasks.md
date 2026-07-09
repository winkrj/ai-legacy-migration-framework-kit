# Change Tasks: migrate-content-query

> tasks는 `02_Specify.md`의 API ID 기준으로 생성한다. 각 API는 PLAN/IMPL/VAL task를 가진다.

## API-001 콘텐츠 조회

- [ ] PLAN-API-001 — 계획·권한 확정 (연결: API-001, spec: `content-query §Requirement`)
- [ ] IMPL-API-001 — 승인된 범위만 구현 (연결: API-001) · PLAN 승인 + Implementation Permission Granted 이후에만
- [ ] VAL-API-001 — 테스트/evidence 확인 (연결: API-001)

## 승인·권한

- Implementation Permission: Not Granted
- IMPL task는 위 권한이 `Granted`로 바뀐 뒤에만 완료(`- [x]`)로 표시한다.
- 미해결(Open) Open Question이 있는 동안에는 권한을 `Granted`로 바꾸지 않는다.
