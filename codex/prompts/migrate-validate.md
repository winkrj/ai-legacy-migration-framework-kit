# migrate-validate — 이관 문서 구조/경계 검사

인자: `<케이스명>`

1. `docs/migration/<케이스명>/`이 존재하는지 확인한다. 없으면 존재하는 케이스 목록을 보여주고 종료한다.
2. Validator 실행 (설치 불필요):

```bash
npx --yes github:winkrj/legacy-migration-validator-cli \
  --root ./docs/migration/<케이스명> \
  --report ./reports/<케이스명>-validation-report.md
```

private repo이므로 GitHub read 권한이 필요하다. 프로젝트에 devDependency로 있으면 `npx legacy-validator`를 사용한다.

3. 결과를 요약해 보고한다. Validator 통과는 문서 구조 검사일 뿐 domain correctness를 보장하지 않는다.
4. 검증을 통과시키기 위해 문서의 사실을 바꾸지 않는다 — 내용이 문제면 사용자에게 보고한다.
