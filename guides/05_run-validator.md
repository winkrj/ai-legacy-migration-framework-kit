# Run the Validator CLI

## 언제 필요한가

**Light 모드에서는 필요 없다.** Validator는 Full 모드 8-file 문서 세트 전용이다.
결제·인증·PII·공유 코드·cutover 케이스로 Full 모드를 쓸 때만 아래 설치를 진행한다.

## 받기와 설치

CLI는 별도 private repo(`legacy-migration-validator-cli`)다. Kit에는 포함되지 않는다.

**요구사항:** Node.js 20 이상

```bash
# 1. 받기 — git clone 또는 zip (Code → Download ZIP)
#    zip으로 받아도 되지만, dist/는 커밋되어 있지 않으므로 빌드가 필요하다.

# 2. 빌드
cd legacy-migration-validator-cli
npm install
npm run build

# 3. 실행 방법 A — 직접 실행
node dist/index.js validate --root <docs> --report <report>

# 3. 실행 방법 B — 전역 명령으로 (선택)
npm link          # 이후 legacy-validator 명령 사용 가능
```

받은 CLI의 commit hash를 케이스 문서에 기록한다 (예: `Validator: 3044f17`).
Target project의 정식 dependency 등록(commit hash pinning)은 팀 도입 결정 후 진행한다.

## 실행

```text
legacy-validator validate --root ./docs/migration/<case> --report ./reports/<case>-validation-report.md
```

## 규칙

- Report path는 validation root **밖**에 둔다 (안이면 CLI가 거부한다).
- Generated report는 기본 ignore/미커밋 — report에 로컬 절대 경로가 포함된다.
- Light 모드 3-file 문서에 실행하면 required-document 오류가 나는 것이 정상이다.
- Validator exit 0 = 문서 구조 계약 통과. Domain 정확성, runtime 결과, production readiness를 의미하지 않는다.
