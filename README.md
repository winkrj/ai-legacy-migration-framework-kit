# AI Legacy Migration Kit

레거시 기능을 새 프로젝트로 이관할 때, AI가 분석과 스펙 작성까지만 하고 멈추게 하는 툴킷입니다. 사람이 스펙을 승인해야 구현이 시작됩니다.

```
레거시 분석  →  스펙 문서  →  ✅ 사람 승인  →  구현  →  검증
             (AI는 여기서 멈춤)            (승인 범위만)
```

Claude Code · Codex 플러그인 · MIT License

---

## 무엇을 하나

- 레거시를 read-only로 분석해 동작을 문서화합니다. 근거는 `파일:라인` 인용으로 남깁니다.
- 이관 후 동작 계약(스펙)을 작성하고 멈춥니다. 사람이 결정할 항목은 질문으로 정리합니다.
- 승인된 범위만 구현하고, 테스트와 결과를 기록합니다.
- 승인 전 코드 수정은 훅이 차단합니다.

## 언제 쓰나

**쓰기 좋은 경우**
- 레거시 화면 하나에 API가 여러 개 걸려 있고, 숨은 조건(soft delete, 정렬 tie-breaker, 페이징 상한)을 놓치기 쉬울 때
- 이관 결과를 리뷰할 기준선이 필요할 때
- 결제·인증·개인정보처럼 잘못 옮기면 곤란한 기능일 때

**안 맞는 경우**
- 파일 한두 개 복사로 끝나는 작업. 문서 비용이 더 큽니다
- 레거시 없이 새로 만드는 기능

---

## 설치

**Claude Code**

```
/plugin marketplace add winkrj/ai-legacy-migration-framework-kit
/plugin install legacy-migration@legacy-migration-kit
```

**Codex**

```bash
npx --yes github:winkrj/ai-legacy-migration-framework-kit
```

Codex는 서브에이전트 role을 플러그인으로 배포할 수 없어 한 단계가 더 필요합니다. 이관할 프로젝트에서 실행하세요.

```bash
PLUGIN_DIR=$(codex plugin list | awk '/legacy-migration@legacy-migration-kit/ {print $NF}') && mkdir -p .codex/agents && cp "$PLUGIN_DIR"/codex/agents/*.toml .codex/agents/
```

Codex 플러그인은 슬래시 커맨드 대신 자연어로 씁니다. "notice-list 이관을 분석 단계부터 시작해줘"처럼 말하면 됩니다.

**업데이트**

```bash
codex plugin marketplace upgrade legacy-migration-kit
```
```
/plugin marketplace update legacy-migration-kit
```

---

## 사용법

이관해서 넣을 프로젝트(레거시 아님)에서 AI를 엽니다.

### 1. 분석과 스펙 작성

```
/legacy-migration:start notice-list ~/work/legacy-admin
```

`feature/ai-migration-notice-list` 브랜치를 만들고, 레거시를 분석하고, `docs/migration/notice-list/`에 문서를 만든 뒤 멈춥니다.

### 2. 스펙 검토와 승인

`02_Spec.md`에 이관 후 동작 계약과 "사람이 결정할 것" 목록이 있습니다. 결정 항목을 채우고 체크박스를 체크합니다.

```markdown
- [x] 위 계약대로 구현을 승인한다 (승인자: 홍길동 / 날짜: 2026-07-15)
```

### 3. 구현

```
/legacy-migration:implement notice-list
```

구현 전에 AI가 이번 작업 범위를 먼저 출력합니다.

```
[구현 착수]
- 이번 묶음: IMPL-API-001, IMPL-API-002
- 건드릴 파일·패키지: src/main/java/.../notice/
- binding 컨벤션: 다른 도메인 repository 직접 호출 금지, 외부 실패를 null로 삼키지 않기
- 멈춤 조건 해당 없음 확인: 기존 코드 교체 없음 / 스펙 밖 없음 / 공유 코드 없음
- 이 턴의 끝: [완료 보고]
```

이후 API 단위로 domain → repository → controller → 테스트까지 구현하고 커밋합니다. push와 MR은 지시할 때만 합니다.

---

## 만들어지는 문서

Light 모드(기본)는 3개입니다.

| 파일 | 내용 |
|---|---|
| `01_Analysis.md` | 레거시 동작 분석. 16문항 체크리스트와 인용 |
| `02_Spec.md` | 이관 후 동작 계약. 사람이 승인하는 문서 |
| `03_Result.md` | 변경 사항 / 설계 판단 / 검증 결과 / 남은 위험 |

Full 모드는 8문서 + OpenSpec change를 만듭니다. API별 상세 스펙, 외부 연동 경로 매트릭스, AC 단위 검증 기록, 개선 후보 대장이 추가되고 Validator CLI가 구조를 검사합니다.

| | Light | Full |
|---|---|---|
| 대상 | 일반 기능 | 결제·인증·PII·공유 코드·cutover |
| 문서 | 3개 | 8개 + OpenSpec |
| 검증 | 스펙 승인 + 사람 리뷰 | 단계별 Human Gate + Validator CLI |

Full은 더 정석이라서 고르는 게 아니라 위험 비용이 문서 비용보다 클 때 고릅니다. 분석 중 고위험 코드를 만나면 AI가 Light로 계속하지 않고 멈춰 보고합니다.

---

## 동작 방식

**승인 게이트** — PreToolUse 훅이 이관 브랜치에서 파일 수정을 가로챕니다. 스펙에 승인 표시가 없으면 차단하고, 셸 리다이렉트나 heredoc 우회도 막습니다. 빌드·git 명령은 통과합니다. `docs/migration/`과 `reports/`는 승인 전에도 쓸 수 있습니다.

```
BLOCKED by legacy-migration spec gate: 아직 구현이 승인되지 않았습니다 —
Light 모드는 02_Spec.md의 구현 승인 체크박스, Full 모드는 03_Plan.md의
'Implementation Permission: Granted'가 필요합니다.
```

**인용 근거** — 레거시 근거는 `파일:라인`과 코드 인용만 인정합니다. 산문 요약은 읽지 않고도 쓸 수 있어서 검증이 안 됩니다. 인용이 있으면 사람이 짧게 대조할 수 있습니다.

**심문 체크리스트** — API마다 16문항에 답하게 합니다. 정렬 tie-breaker, 페이징 상한, 트랜잭션 경계, 목록 순회 중 추가 쿼리, null 처리 등입니다. 각 칸은 답변과 인용을 요구하고, 빈 칸은 검사기가 잡습니다. 이 중 성능 관련 문항에서 나온 N+1·캐싱 후보는 `07_Improvements.md`에 따로 기록합니다.

**이관과 개선의 분리** — 개선 후보는 기본값이 `Not Approved`이고, 승인되더라도 이관 task와 커밋을 분리합니다. 옮기는 변경과 고치는 변경이 섞이면 문제가 났을 때 원인을 가릴 수 없습니다.

**서브에이전트** — 탐색과 검증은 읽기 전용 서브에이전트에 맡깁니다. 스펙을 쓴 에이전트는 자기 누락을 찾지 못하므로, 검사는 쓰지 않은 쪽이 합니다. Claude Code는 `disallowedTools`로, Codex는 훅이 `agent_type`을 보고 쓰기를 차단합니다.

---

## 커맨드

| 상황 | Claude Code |
|---|---|
| 컨벤션 등록 (프로젝트당 1회) | `/legacy-migration:conventions [참고경로]` |
| 이관 시작 (분석 + 스펙) | `/legacy-migration:start <기능명> <레거시경로>` |
| 승인 후 구현 | `/legacy-migration:implement <기능명>` |
| 문서 구조 검사 | `/legacy-migration:validate <케이스명>` |
| 고위험 기능 | `/legacy-migration:full <기능명> <레거시경로>` |

---

## 더 알아보기

[따라하기 가이드 (HTML)](guides/Kit-Usage-Guide.html) — 설치부터 첫 이관·승인·MR까지 화면 단위로 정리했습니다.

| | |
|---|---|
| 팀 컨벤션 주입 | [convention-adoption-guide](guides/convention-adoption-guide.md) |
| Full 모드 상세 절차 | [walkthrough-full-mode](guides/walkthrough-full-mode.md) |
| Codex 서브에이전트 설치 | [codex/agents/README.md](codex/agents/README.md) |
| 문서 검사 CLI | [legacy-migration-validator-cli](https://github.com/winkrj/legacy-migration-validator-cli) |
| 설치 없이 프롬프트만 | [prompts/start-migration.md](prompts/start-migration.md) |

---

## FAQ

<details>
<summary><b>승인 전에 AI가 코드를 만들려고 하면?</b></summary>

훅이 차단합니다. 편집 도구와 셸 우회를 모두 막고, AI는 멈춰서 승인을 요청합니다.
</details>

<details>
<summary><b>이관을 되돌리려면?</b></summary>

작업이 `feature/ai-migration-<기능명>` 브랜치에만 쌓입니다.

```bash
git checkout main && git branch -D feature/ai-migration-<기능명>
```
</details>

<details>
<summary><b>테스트가 실패한 채로 끝났는데요</b></summary>

정상 동작입니다. 실패를 숨기거나 assertion을 약화하는 것을 금지합니다. `03_Result.md`에 실패가 기록되니 확인하고 재지시하세요.
</details>

<details>
<summary><b>컨벤션은 어떻게 반영되나요?</b></summary>

`docs/conventions/`에서 승인(Approved)된 문서만 binding으로 씁니다. 그중 위반 시 반려할 규칙은 `binding-rules.md`에 10줄 이내로 추리고, 구현 직전에 다시 읽습니다. 구현 후에는 규칙별로 지켰는지 대조표를 남깁니다.
</details>

<details>
<summary><b>Repository 구조</b></summary>

```
commands/     Claude Code 슬래시 커맨드
skills/       Claude Code 스킬
agents/       Claude Code 서브에이전트 (read-only)
codex/agents/ Codex agent role (수동 설치)
hooks/        스펙 승인 게이트 훅
templates/    이관 문서 · OpenSpec · 컨벤션 템플릿
guides/       상세 가이드
plugins/      Codex 플러그인 사본 (sync 스크립트로 생성)
```
</details>

---

## 변경 이력

### 1.2.1 — Codex 훅이 실행되지 않던 문제

Codex에서 `PreToolUse hook (failed) — hook exited with code 127`이 반복됐습니다. 127은 명령을 찾지 못했다는 뜻입니다.

Codex용 `hooks.json`의 command가 `"\"${PLUGIN_ROOT}/hooks/spec-gate.sh\""`처럼 따옴표를 포함하고 있었는데, Codex는 훅 명령을 셸을 거치지 않고 실행하기 때문에 따옴표가 경로의 일부로 취급됐습니다. 그래서 **Codex에서는 승인 게이트 훅이 한 번도 동작하지 않았습니다.** Claude Code는 셸을 거치므로 영향이 없습니다.

Codex 쪽 command에서 따옴표를 제거했습니다. 이 버전부터 Codex에서도 승인 전 코드 수정과 읽기 전용 서브에이전트의 쓰기가 실제로 차단됩니다.

### 1.2.0 — Codex 서브에이전트 지원

Codex가 서브에이전트를 지원하지 않는 줄 알고 Claude Code에만 붙였는데, CLI 0.146.0을 확인해보니 `spawn_agent`가 있고 `multi_agent`가 활성 상태였습니다. Codex용 agent role 3종(`legacy_explorer`, `spec_gap_hunter`, `improvement_scout`)을 추가했습니다.

Codex에는 role 단위 도구 제한이 없고 role 설정의 `sandbox_mode = "read-only"`도 spawn 시 부모 permission profile이 다시 적용돼 신뢰할 수 없습니다. 대신 PreToolUse 훅이 서브에이전트에도 적용되고 입력에 `agent_type`이 들어오는 점을 이용해, 훅에서 이 세 role의 쓰기를 차단하도록 했습니다.

Codex 기본 지침이 "스킬이 명시적으로 요청하지 않으면 서브에이전트를 쓰지 말 것"이고 "read-only 탐색보다 코드 변경 위임을 선호할 것"이어서, 스킬에서 두 가지를 명시적으로 뒤집었습니다.

### 1.1.0 — 분석 깊이와 개선 제안

분석이 얕은 경우가 있었습니다. 응답값만 보고 로직을 판단하거나 화면이 실제 호출하는 API를 빠뜨렸고, N+1 같은 개선점을 발견해도 기록할 곳이 없었습니다.

API별 16문항 심문 체크리스트를 추가했습니다. 빈 칸은 "확인하지 않았다"는 뜻이므로 검사기가 경고합니다. 개선 후보는 `07_Improvements.md`에 따로 기록하고 이관 구현과 분리했습니다. 탐색·검증·개선 탐지용 서브에이전트 3종도 추가했습니다.

규칙은 늘리지 않고 산출물 양식과 도구 권한으로 강제했습니다.

### 1.0.1 — 승인 게이트 버그 수정

승인을 했는데도 훅이 계속 차단하는 문제가 있었습니다. 승인 파일을 `docs/migration/<브랜치명>/`에서만 찾았기 때문에, 케이스 폴더명이 브랜치명과 다르면(예: 브랜치 `feature/ai-migration-visitreview`, 폴더 `case-01-visit-review`) 승인 표시를 발견하지 못했습니다.

차단된 AI가 편집 도구 대신 셸(`cat > file <<EOF`)로 우회하면서 줄바꿈이 깨진 파일이 생기거나, 구현을 포기하고 설명만 하는 증상이 여기서 나왔습니다. 프롬프트 문제로 보였지만 원인은 훅이었습니다.

승인 탐색을 폴더명과 무관하게 바꾸고, 셸 우회도 차단했습니다. 회귀 테스트 12개를 CI에 넣었습니다.

### 1.0.0 — 규칙 축소

문제가 생길 때마다 규칙을 추가한 결과 규칙 133개, 지시문 3,350단어가 됐습니다. 그 시점부터 규칙이 지켜지기도 하고 안 지켜지기도 하는 상태가 됐습니다. 모델이 한 턴에 추적할 수 있는 제약 수를 넘어서면 준수가 확률적이 됩니다.

핵심 규칙 7개만 남기고 나머지는 다른 층으로 옮겼습니다. 되돌릴 수 없는 것은 훅으로, 기계 검사가 가능한 것은 Validator로, 보여주면 되는 것은 예시로 옮겼습니다. 금지문 대신 `[완료 보고]`/`[멈춤 보고]` 출력 형식을 정의했고, 구현 시작 시 작업 범위를 직접 쓰게 하는 착수 블록을 넣었습니다. 지시문은 909단어로 줄었습니다.

### 0.9.x — 구현 단위와 턴 종료

계층별로 끊어서 보고하는 문제가 있었습니다. "domain 만들었습니다, 다음은 controller 만들겠습니다" 식이면 직접 구현하는 게 빠릅니다. 또 "진행하겠습니다"라고 선언만 하고 턴을 끝내는 경우도 있었습니다.

구현 단위를 API 하나(domain부터 테스트까지 관통)로 정의하고, 승인된 task가 여러 개면 중간 보고 없이 연속 수행하도록 했습니다. 턴은 완료 보고나 멈춤 보고로만 끝나게 하고, 멈춰야 하는 상황 6가지(스펙 밖 동작, 기존 코드 교체, 공유 코드 영향 등)를 명시했습니다.

<details>
<summary><b>0.4.0 ~ 0.8.0</b></summary>

**0.8.0** — 매 요청마다 코드 품질 규칙을 프롬프트로 붙여넣던 것을 플러그인에 내장했습니다. 프로젝트와 무관한 원칙(이름, 조건문, 성급한 추상화)은 플러그인에, 계층 책임처럼 프로젝트마다 다른 규칙은 컨벤션 문서로 분리했습니다.

**0.7.0** — AI 지시문은 구버전 문서 구조를 시키는데 검사기는 새 구조를 요구하는 모순이 있었습니다. 지시문 7종을 새로 쓰고 CI를 붙였습니다. Full 모드에서 승인해도 훅이 차단하던 버그도 함께 고쳤습니다.

**0.6.0** — API마다 표 한 줄로 계약을 적게 했더니 요청·응답·변환 규칙이 한 칸에 뭉개져, 구현 시 부족한 부분이 즉흥으로 채워졌습니다. 표는 색인으로 두고 API별 상세 섹션(시나리오·Request·Response·Acceptance Criteria)으로 분리했습니다.

**0.5.0** — 인용 없는 근거를 무효로 하고, binding 컨벤션을 10줄로 추려 구현 직전에 재주입하도록 했습니다. 구현을 동작 구현과 정리 두 단계로 나눴고, 외부 연동이 있는 API에는 환경별 host·프록시 경로 매트릭스를 요구했습니다.

**0.4.0** — Full 모드 문서를 한글로 재작성하고(상태값 등 고정 토큰은 영어 유지), API ID 기준으로 `PLAN`/`IMPL`/`VAL` task를 추적하도록 했습니다.

</details>

---

## License

MIT — [LICENSE](LICENSE)
