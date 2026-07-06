---
description: Validator CLI로 이관 문서 구조/경계 검사 (Full 모드 문서 대상)
argument-hint: <케이스명>
---

이관 문서를 Validator CLI로 검사한다. 케이스명: $1

1. 검사 대상 확인: `docs/migration/<케이스명>/`. 없으면 존재하는 케이스 목록을 보여주고 종료한다.
2. Validator 실행 (설치 불필요 — npx로 실행):

```bash
npx --yes github:winkrj/legacy-migration-validator-cli \
  --root ./docs/migration/<케이스명> \
  --report ./reports/<케이스명>-validation-report.md
```

- private repo이므로 실행하는 사람에게 GitHub read 권한이 필요하다. 실패하면 에러를 그대로 보여주고 권한/네트워크 문제인지 구분해 보고한다.
- 프로젝트에 validator가 devDependency로 이미 있으면 `npx legacy-validator`를 대신 사용한다.

3. Report는 validation root 밖(`reports/`)에 둔다.
4. 결과를 요약해 보고한다. Validator 통과는 문서 구조 검사일 뿐 domain correctness를 보장하지 않는다는 점을 함께 명시한다.
5. 실패 항목이 있으면 문서를 고쳐서 통과시키되, **검증을 통과시키기 위해 사실을 바꾸지 않는다** — 내용이 문제면 사용자에게 보고한다.
