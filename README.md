# AI Legacy Migration Kit

> AI에게 레거시 이관을 맡기되, 멋대로 하게 두지 않는 툴킷.

```
레거시 분석  →  스펙 문서  →  ✅ 사람 승인  →  구현  →  검증
             (여기서 AI가 멈춤)              (승인 범위만)
```

AI가 레거시 코드를 read-only로 분석해 스펙 문서를 만들면 **거기서 멈춥니다.**
사람이 스펙을 검토·승인해야만 구현이 시작되고, 승인 전에 코드를 만지려 하면 **훅이 차단합니다.**

Claude Code 플러그인 · Codex 플러그인 제공 · MIT License

---

## 왜 쓰나요

AI에게 그냥 "이 기능 옮겨줘"라고 하면 생기는 일 → 이 kit의 해결책:

- 미확인 동작을 그럴듯하게 추측 구현 → **확인한 사실만 기록, 미확인은 사람에게 질문**
- 스펙 쓰다 말고 멋대로 구현 진행 → **분석/구현 커맨드 분리 + 승인 게이트 훅이 물리적으로 차단**
- 팀 컨벤션 무시 → **승인된 컨벤션 문서를 스펙·구현에 강제 반영**
- 사고 나면 복구 어려움 → **격리 브랜치에서만 작업, 롤백 = 브랜치 삭제**

---

## 설치

### Claude Code

```
/plugin marketplace add winkrj/ai-legacy-migration-framework-kit
/plugin install legacy-migration@legacy-migration-kit
```

### Codex

```
npx --yes github:winkrj/ai-legacy-migration-framework-kit
```

마켓플레이스 등록 + 플러그인 설치를 한 번에 실행합니다. 수동으로 하려면:

```
codex plugin marketplace add winkrj/ai-legacy-migration-framework-kit
```

→ Plugins 화면(`/plugins`)에서 **Legacy Migration Kit** 설치.

> ⚠️ Codex 플러그인은 슬래시 커맨드가 아니라 **자연어**로 씁니다.
> `/migrate-*` 커맨드를 원하면 [codex/prompts/](codex/prompts/)를 `~/.codex/prompts/`에 복사하세요.

**업데이트**: kit이 갱신되면 `codex plugin marketplace upgrade legacy-migration-kit` /
Claude Code는 `/plugin marketplace update legacy-migration-kit`

---

## 사용법 — 3단계

이관할 **신규 프로젝트**에서 AI를 열고:

**① 이관 시작** — 기능명과 레거시 경로만 넣으면 됩니다.

```
/legacy-migration:start notice-list ~/work/legacy-admin
```

→ AI가 분석하고 `docs/migration/notice-list/02_Spec.md`(스펙 초안)까지 만들고 멈춥니다.

**② 스펙 승인** — `02_Spec.md`를 열어 결정 항목에 답하고, 체크박스를 체크합니다.

```markdown
- [x] 위 계약대로 구현을 승인한다 (승인자: 홍길동 / 날짜: 2026-07-06)
```

**③ 구현 지시**

```
/legacy-migration:implement notice-list
```

→ 승인 범위만 구현 + 테스트 + commit 후 멈춤. push/MR은 당신이 지시할 때만.

---

## 명령어

| 상황 | Claude Code |
|---|---|
| 컨벤션 등록 (프로젝트당 1회 권장) | `/legacy-migration:conventions [참고경로]` |
| 이관 시작 (분석 + 스펙) | `/legacy-migration:start <기능명> <레거시경로>` |
| 승인 후 구현 | `/legacy-migration:implement <기능명>` |
| 문서 검사 | `/legacy-migration:validate <케이스명>` |
| 고위험 기능 (결제·인증·PII) | `/legacy-migration:full <기능명> <레거시경로>` |

**Codex 플러그인**은 같은 작업을 자연어로:

- "컨벤션을 등록해줘. 참고 프로젝트는 ~/work/team-guide"
- "notice-list 이관을 분석 단계부터 시작해줘. 레거시 경로는 ~/work/legacy-admin"
- "notice-list 스펙 승인했어. 승인된 범위만 구현해줘"
- 뭘 해야 할지 모르겠으면: "이 플러그인으로 뭘 할 수 있어?"

---

## 📖 상세 가이드

**[따라하기 가이드 (HTML)](guides/Kit-Usage-Guide.html)** — 설치부터 첫 이관·승인·MR까지,
모든 입력값과 결과 화면을 한 단계씩 보여줍니다. 파일을 받아 브라우저로 여세요.

| 더 알아보기 | |
|---|---|
| 팀 컨벤션 주입 (직접 입력 / 참고 프로젝트 추출) | [convention-adoption-guide](guides/convention-adoption-guide.md) |
| Full 모드 (결제·인증·PII·공유 코드) | [walkthrough-full-mode](guides/walkthrough-full-mode.md) |
| Codex 설치 상세 | [codex/INSTALL.md](codex/INSTALL.md) |
| 문서 검사 CLI | [legacy-migration-validator-cli](https://github.com/winkrj/legacy-migration-validator-cli) |
| 설치 없이 쓰기 (프롬프트 복붙) | [prompts/start-migration.md](prompts/start-migration.md) |

---

## 자주 묻는 질문

<details>
<summary><b>AI가 승인 전에 코드를 만들려고 하면?</b></summary>

Claude Code에서는 훅이 자동 차단합니다. Codex에서는 훅 동작이 아직 검증되지 않았으니
분석 세션과 구현 세션을 분리해서 쓰고, 위반하면 "멈춰, 스펙 승인 전이야"라고 하면 됩니다.
</details>

<details>
<summary><b>이관을 되돌리고 싶어요</b></summary>

모든 작업이 `feature/ai-migration-<기능명>` 브랜치에 격리되어 있습니다.

```bash
git checkout main && git branch -D feature/ai-migration-<기능명>
```
</details>

<details>
<summary><b>테스트가 실패한 채로 끝났어요</b></summary>

정상 동작입니다. kit은 실패를 숨기거나 assertion을 약화하는 것을 금지합니다.
결과 문서(`03_Result.md`)의 실패 내역을 보고 재지시하세요.
</details>

<details>
<summary><b>스펙 문서가 꼭 필요한가요?</b></summary>

스펙은 AI 산출물을 검증할 기준선입니다. 스펙 없이는 "구현이 맞는지" 판단할 기준이
리뷰어의 기억뿐이고, 미확인 동작과 결정 필요 항목이 구현 후에야 드러납니다.
</details>

<details>
<summary><b>Light 모드와 Full 모드의 차이는?</b></summary>

| | Light (기본) | Full |
|---|---|---|
| 문서 | 3개 | 8개 + OpenSpec |
| 대상 | 일반 기능 | 결제·인증·PII·공유 코드·cutover |
| 검증 | 스펙 승인 + 사람 리뷰 | Validator CLI + 단계별 Human Gate |

AI가 분석 중 고위험 코드를 만나면 Light로 계속하지 않고 멈춰서 보고합니다.
</details>

<details>
<summary><b>Repository 구조</b></summary>

```
.claude-plugin/           Claude Code 플러그인 매니페스트 + 마켓플레이스
.agents/plugins/          Codex 마켓플레이스
plugins/legacy-migration/ Codex 플러그인 (스킬 + 템플릿)
commands/                 Claude Code 슬래시 커맨드
skills/                   Claude Code 스킬
hooks/                    스펙 승인 게이트 훅
codex/                    Codex 커스텀 프롬프트 + 설치 가이드
templates/                이관 문서 / OpenSpec / 컨벤션 템플릿
guides/                   상세 가이드
prompts/                  복붙용 시작 프롬프트
```
</details>

---

## 변경 이력

### 0.6.0 — 스펙 문서를 SDD로: 표는 색인, 계약은 섹션
- `02_Specify.md`(Full)·`02_Spec.md`(Light)를 **SDD 구조**로 개편: 범위와 용어 / 공통 규칙(컨벤션 참조+예외만) / API 목록(색인 표) / **API별 상세 스펙 섹션** — 목적 / 권한·사전조건 / 시나리오(GWT) / Request / Response(레거시 원 필드 매핑) / 레거시 호출 흐름(인용) / DB·외부 연동 / 변환 규칙 / 오류·빈 결과 / **Acceptance Criteria** / 연결 Task
- **GWT/AC의 단일 진실은 02_Spec** — OpenSpec `spec.md`는 requirement 색인(포인터)으로 축소, 두 곳 복사로 인한 drift 차단
- `05_Validate`는 **AC 단위 검증 결과** 기록 — 테스트 통과가 아니라 AC 커버리지가 완료 기준
- Validator 0.4.0의 `API_DETAIL_SECTION` 룰과 연동 — 표의 API ID마다 상세 섹션·필수 하위 섹션을 기계 검사
- 깊이는 위험 비례: 단순 CRUD는 항목당 한두 줄, 외부 연동 API는 꽉 채움

### 0.5.0 — 사용성은 유지하고 품질 강화 (규칙 3개)
- **인용 없는 근거는 근거가 아니다**: 분석·스펙의 모든 레거시 근거는 `파일:라인` + 코드 인용 필수. 응답값만 보고 로직 판단 금지, call chain 각 hop 직접 확인
- **binding 컨벤션 10줄**: `binding-rules-template.md` 신규 — 위반=리젝 규칙만 10줄 이내. 구현 직전 재주입 + 규칙별 `지켰음`/`예외` 대조표 기록
- **2-pass 구현**: Pass 1(동작+테스트) → Pass 2(책임 분리·이름·null 흐름·중복) 분리 수행·기록. 외부 연동 실패를 null로 삼키지 않기
- **External Route Matrix**: 외부 연동 있는 API만 필수 — 직접 vs 프록시(gpapi류), 환경별 host를 환경설정 인용으로 확정
- 마찰은 위험에 비례: 일반 API는 기록 부담 거의 없음, 외부 연동에만 표 하나 추가

### 0.4.0
- Full 모드 문서를 **한글 기본**으로 재작성 (Status 값·Given/When/Then 등 고정 토큰만 영어 유지)
- `02_Specify.md`에 **API 단위 상세 스펙 표** 필수화 — API ID / 레거시 근거 / 요청·응답 / DB R·W / 외부연동 / business rule / empty·error / 미결(OQ) / 연결 Task
- `tasks.md`를 **API ID 기준 `PLAN`/`IMPL`/`VAL` triad**로, `03_Plan`에 API↔requirement↔task 추적표 추가
- 구현 규칙 강화: task ID 없는 구현 금지, 예상 밖 API·파일 발견 시 중단
- `npm run sync-codex`로 루트→Codex 사본 동기화(prompts 누락 해소)
- 문서 구조 검사는 [Validator CLI](https://github.com/winkrj/legacy-migration-validator-cli) 0.2.0(API 표/task ID/승인 게이트 룰)과 함께 동작

---

## License

MIT — [LICENSE](LICENSE)
