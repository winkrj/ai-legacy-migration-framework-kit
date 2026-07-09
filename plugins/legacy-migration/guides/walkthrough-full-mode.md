# Full 모드 상세 가이드 — 위험한 이관을 단계별 gate로

결제·인증·개인정보·공유 코드·cutover가 걸린 이관을 위한 상세 절차다. Light 모드(3-file)와 달리 **단계마다 문서와 사람 gate가 있고, Validator CLI로 문서 계약을 기계 검사한다.**

## 0. Full 모드로 와야 하는지부터 확인

| 질문 | 하나라도 Yes면 Full |
|---|---|
| 결제·정산 로직을 건드리는가? | ✅ |
| 인증/인가(RBAC) 경계가 바뀌는가? | ✅ |
| 개인정보를 조회/저장/전송하는가? | ✅ |
| 여러 기능이 공유하는 코드/쿼리를 수정하는가? | ✅ |
| 레거시 중단(cutover) 판단이 포함되는가? | ✅ |

전부 No면 [Light 모드](walkthrough-first-cycle.md)로 돌아가라. Full 모드를 "더 정석"이라서 고르는 게 아니다 — **위험 비용이 문서 비용보다 클 때만** 고르는 것이다.

## 1. Light와 뭐가 다른가

| | Light | Full |
|---|---|---|
| 문서 | 3개 | **8개** (`templates/migration-docs/`) + OpenSpec 3개 (`templates/openspec-change/`) |
| 승인 | Spec 체크박스 1개 | **단계별 Human Gate** (아래 §4) |
| 검증 | 사람 리뷰 | 사람 리뷰 + **Validator CLI** (문서 계약 기계 검사) |
| 구현 권한 | 스펙 승인 = 구현 승인 | **rule/item 단위 Implementation Permission** (없으면 Not Granted) |
| 종료 | Result 기록 | **Archive 문서** + carry-forward 표 (archive 차단 vs production 차단 구분) |

## 2. 준비물

1. Kit의 `templates/migration-docs/` (8개), `templates/openspec-change/` (3개)
2. Validator CLI — 설치는 [guides/05_run-validator.md](05_run-validator.md) (Node 20+, 빌드 필요)
3. 단계별 AI 프롬프트 — `prompts/codex/` (아래 매핑 표)
4. 격리 브랜치 + rollback 방침 (merge 전 브랜치 폐기 = rollback)

## 3. 전체 흐름 — 단계별 상세

```text
Discover → Specify → OpenSpec → Plan → Implement → Validate → Archive
   (읽기)    (분류)    (계약승인)  (권한)   (승인범위만)  (증거)     (정직한 종료)
```

각 단계: **무엇을 만들고 → 누가 결정하고 → 무엇이 통과 조건인지**.

### 3-1. Discover — 관찰만, 판단 없음

- **산출물**: `01_Discover.md` (필수 섹션: Status / Sources / Findings / Open Questions)
- **AI 프롬프트**: `prompts/codex/02_legacy-discover.md`
- **핵심 규칙**: 레거시 read-only. 코드/쿼리/테스트에서 **본 것만** Findings에 적는다. Evidence Level을 구분한다 — Confirmed(코드로 확인) / Observed(패턴 관찰) / Inferred(추론, 구현 금지).
- **통과 조건**: 진입점→흐름→쿼리 조건이 추적됐고, 확인 못 한 것이 Open Questions에 ID로 등록됨.
- **함정**: "레거시가 이렇게 하니까 Target도 이래야 한다"는 판단을 여기서 하지 마라. Legacy 관찰 ≠ Target 요구사항.

### 3-2. Specify — 사실과 결정을 분리

- **산출물**: `02_Specify.md` (상태 / 도메인 규칙 / **API 상세 스펙** / 데이터 매핑 / 미결 질문)
- **AI 프롬프트**: `prompts/codex/03_spec-generate.md`
- **문서 단위**: 큰 단위는 **메뉴/feature**, 상세 계약 단위는 **API**, 구현/검증 단위는 **task ID**.
- **API 상세 스펙 표 필수**: 각 API를 한 행으로 적고, 행마다 최소 — API ID / Method·Path / 기능명 / 레거시 근거(JSP·config·controller·service·mapper·query) / 요청 파라미터·body / 응답 field / DB read·write / 외부 연동 / business rule / empty·error 정책 / 미결(OQ) / **연결 Task ID**. 표가 없거나 행에 API ID·Task ID가 없으면 Validator가 error(`API_SPEC_TABLE`/`API_TASK_LINK`)를 낸다.
- **핵심 작업**: Discover 결과를 rule/API 단위로 분해하고 각 항목에 표시:
  - **Evidence Status**: Legacy Confirmed / Target Confirmed / Inferred / Policy Difference ...
  - **Implementation Permission**: 기본 **Not Granted** — 사람이 명시해야만 바뀐다
- **차이를 만나면 3분류**: ① Policy Difference (사람이 정할 것) ② Intentional Improvement (개선 후보, 승인 필요) ③ Runtime Verification 필요 (실행해봐야 아는 것)
- **통과 조건**: 모든 API가 표에 행으로 있고 각 행에 연결 Task ID가 있으며, 모든 차이가 분류됐고, 사람이 결정할 항목이 질문 형태로 정리됨.

### 3-3. OpenSpec — 계약 승인 (첫 번째 큰 gate)

- **산출물**: `changes/<change-name>/` 아래 `proposal.md` + `tasks.md` + `specs/<capability>/spec.md`
- **AI 프롬프트**: `prompts/codex/04_openspec-generate.md`
- **tasks.md는 API ID 기준**: `02_Specify.md`의 각 API ID마다 `PLAN-API-NNN`(계획·권한) / `IMPL-API-NNN`(구현) / `VAL-API-NNN`(검증) 세 task를 만든다. NNN은 API ID와 같은 번호로 맞추고, 각 task는 어떤 requirement/API spec에 연결되는지 적는다. 세 종류가 다 없으면 Validator가 error(`TASK_ID_TRIAD`)를 낸다.
- **작성 요령**: Requirement + Given/When/Then Scenario. **미해결 결정은 requirement로 위장하지 말고** `[DECISION PENDING]`으로 표시하거나 Open Question으로 뺀다. Non-goals(안 하는 것)를 명시한다.
- **통과 조건**: 사람이 결정 항목을 모두 결정하고 proposal을 승인. 이때 `[DECISION PENDING]` → 결정 반영, runtime 확인 필요한 것만 `[RUNTIME VERIFICATION PENDING]`으로 남김.

### 3-4. Plan — 승인된 것만 작업으로

- **산출물**: `03_Plan.md` (Status / Implementation Plan / Test Plan / Risks)
- **핵심 작업**: Requirement ↔ Plan item ↔ Test 추적표. **승인 안 된 requirement는 plan에 넣지 않는다.** 공유 코드에 닿는 항목은 별도 표시 + 별도 승인.
- **통과 조건**: 각 구현 항목에 Implementation Permission이 명시됨 (item 단위). 문서 전체에 대한 포괄 승인은 인정 안 됨.

### 3-5. Implement — 권한 있는 것만

- **산출물**: 코드 + `04_Implement.md` (상태 / 구현 메모 / 변경 파일)
- **핵심 규칙**:
  - **Implementation Permission이 Granted된 `IMPL-API-NNN` task만** 구현한다. **task ID 없는 구현은 금지**한다.
  - 작은 단위로(1~5파일). 예상 밖 API·파일·외부 연동을 건드려야 하면 **멈추고 질문**한다.
  - 구현 후 해당 task와 validation evidence(연결 `VAL-API-NNN`)를 갱신한다.
  - 권한이 없는데 IMPL task를 완료(`- [x]`)로 표시하거나, 미해결 Open Question이 있는데 권한을 Granted로 바꾸면 Validator가 error(`PERMISSION_COMPLETION`/`PERMISSION_OPEN_QUESTION`)를 낸다.
  - 테스트 실패를 숨기거나 assertion을 약화하지 않는다.

### 3-6. Validate — 한 검증과 안 한 검증을 구분

- **산출물**: `05_Validate.md` (Status / Validation Results / Compatibility Check)
- **AI 프롬프트**: `prompts/codex/06_validate.md`
- **Validation Mode를 하나 고른다** (실제 수행한 것만): `Test Verified` / `Manual Runtime Verified` / `Manual Evidence Pending` / `Review-only` / `Blocked by Environment`
- **Runtime evidence**: `templates/runtime-evidence/` 사용. **승인된 비운영 환경에서 사람이 수행**하고, 복사 전에 sanitize. 증거가 없으면 만들어내지 않는다 — "Pending"이 정답이다.
- **Validator CLI 실행** (문서 계약 검사):

```bash
legacy-validator validate \
  --root ./docs/migration/<case-name> \
  --report ./reports/<case-name>-validation-report.md   # root 밖!
```

### 3-7. Archive — 정직한 종료

- **산출물**: `06_Archive.md` (Status / Decision / Archived Knowledge / Carry-forward)
- **AI 프롬프트**: `prompts/codex/07_archive.md`
- **Decision 선택지**: PASS / **Archive with Conditions** / BLOCKED / FAILED
- **Archive with Conditions는 실패가 아니다** — 남은 항목을 명시적으로 이관하는 정상 종료다. carry-forward 표에서 두 가지를 구분한다:
  - **Blocks Phase Archive**: 이게 Yes면 아직 못 닫는다
  - **Blocks Production/Cutover**: archive는 되지만 운영 전환은 못 한다 (예: runtime evidence 미확보)
- **통과 조건**: Verified/Not Verified 구분, carry-forward에 owner와 Required Before 기재, Archive ≠ production readiness 명시.

## 4. Human Gate 요약 — 사람이 결정하는 것

| 시점 | 결정할 것 |
|---|---|
| 시작 전 | Case type·scope, 브랜치/rollback, 민감정보 정책 |
| Specify 후 | Legacy 보존 vs Intentional Improvement, Policy Difference별 owner |
| OpenSpec | API/응답 경계, 에러 계약, 날짜/시간(형식·timezone·경계), 페이징(기본/최대/정렬), 보안·개인정보 |
| Plan | item별 Implementation Permission, 공유 코드 영향 승인, test/build 실행 허용 |
| Validate | Validation Mode 승인, evidence 인정, 환경 blocker의 carry-forward 승인 |
| Archive | Archive decision, carry-forward 승인 |
| 별도 | **Production/Cutover 승인 — Archive나 Validator PASS가 이걸 자동 승인하지 않는다** |

## 5. Validator를 첫 번에 통과하는 법 (실전 함정 모음)

실제 케이스에서 걸렸던 것들이다. 이것만 지키면 첫 실행에 exit 0이 나온다:

1. **파일 8개 이름을 바꾸지 마라** — `00_Index.md` ~ `99_Open-Questions.md` 이름 그대로. 하위 폴더 깊이는 자유.
2. **템플릿의 섹션 헤딩을 지우지 마라** — 헤딩은 한글/영어 alias를 함께 허용한다. 예: `02_Specify.md`의 `## API 상세 스펙`(= `API Map`/`API Spec`), `## 데이터 매핑`(= `DB Map`)은 비어 있어도 헤딩은 있어야 한다.
2-1. **`02_Specify.md`에는 API 상세 스펙 표가 필수** — `API ID` 열과 `연결 Task` 열이 있어야 하고, 각 행에 `API-NNN`과 `PLAN/IMPL/VAL-API-NNN`이 있어야 한다.
2-2. **`tasks.md`는 API ID 기준 triad** — 각 API 번호마다 `PLAN`/`IMPL`/`VAL` 세 task가 다 있어야 한다.
2-3. **권한 게이트** — 권한을 Granted 안 한 채 IMPL task를 `- [x]`로 표시하거나, `Open`인 Open Question이 남았는데 권한을 Granted로 바꾸면 error다.
3. **상태 값은 정해진 어휘만** — `Status:` `Decision:` `Implementation:` 등의 줄에는 다음 값만 허용:
   `Not Started / Planning / Preparation / In Progress / Ready for Review / Ready for Archive / Approved / Rejected / Archive with Conditions / Archived / Deferred / Accepted / Not Granted / Completed`
   ❌ 자주 틀리는 값: `Draft`, `Open`, `Pending`, `Done`, `WIP`
4. **용어 주의**: "Human Decision"이라고 쓰면 canonical-term 경고가 난다 → **"Human Policy Decision"**으로. "Conditional Archive" → **"Archive with Conditions"**.
5. **`Implementation: Not Started` 상태에서** 본문에 "implemented", "tests passed", "deployed" 같은 영어 표현을 쓰면 모순 경고가 난다 — 실제로 안 했으면 그 표현을 쓰지 마라 (한국어 서술은 무관).
6. **Report 경로는 validation root 밖** — 안이면 CLI가 실행을 거부한다.
7. **민감정보 후보 자동 검출**: `password=`, `jdbc:`, 사설 IP, `localhost:포트` 등이 있으면 경고. 문서에 애초에 넣지 마라.

## 6. 실제 사례 참조

- **Review case (코드 무변경)**: target 프로젝트의 `changes/migrate-notice-query-review/` — 이미 이관된 기능을 검증해 차이 4건을 분류·결정한 사례
- **Actual migration**: `changes/migrate-transfer-banner-list/` — 신규 이관 + 구현 + 테스트까지 간 사례. 커밋 전 리뷰에서 스펙 덕분에 blocker 4건을 잡았다.

## 7. 프롬프트 매핑

| 단계 | 프롬프트 파일 |
|---|---|
| (선택) 후보 조사 | `prompts/codex/01_feature-inventory.md` |
| Discover | `prompts/codex/02_legacy-discover.md` |
| Specify | `prompts/codex/03_spec-generate.md` |
| OpenSpec | `prompts/codex/04_openspec-generate.md` |
| (Review case) Gap 비교 | `prompts/codex/05_gap-review.md` |
| Validate | `prompts/codex/06_validate.md` |
| Archive | `prompts/codex/07_archive.md` |
| 리뷰 보조 (Claude) | `prompts/claude/review-spec.md` · `review-diff.md` · `review-open-questions.md` |

## 8. 언제든 멈춰야 하는 신호

- 정책/컨벤션이 애매한데 결정 없이 진행하고 싶어질 때
- 승인 범위 밖 파일을 건드려야 할 때
- 테스트 실패를 우회하고 싶을 때
- production 데이터·환경이 필요해질 때
- 민감정보가 문서/증거에 들어가려 할 때

멈추고 묻는 것이 이 프로세스의 정상 동작이다.
