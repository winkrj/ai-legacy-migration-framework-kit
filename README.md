# AI Legacy Migration Kit

**AI에게 레거시 이관을 맡기되, 멋대로 하게 두지 않는 툴킷.**

레거시 기능을 AI가 read-only로 분석해서 근거 기반 스펙 문서를 만들고, **사람이 그 스펙을 승인해야만** 새 프로젝트에 구현합니다. 승인 전에 AI가 코드를 만지려고 하면 훅이 차단합니다.

Claude Code 플러그인과 Codex 플러그인을 모두 제공합니다.

---

## 왜 필요한가요?

AI에게 "이 레거시 기능 새 프로젝트로 옮겨줘"라고 하면 보통 이런 일이 생깁니다:

- 확인 안 된 동작을 **그럴듯하게 추측해서** 구현한다
- 레거시의 숨은 규칙(기본값, 조용한 실패, 삭제 필터)을 놓친다
- 팀 코드 컨벤션을 무시하고 자기 스타일로 짠다
- 물어봐야 할 것을 안 물어보고 임의로 결정한다

이 kit은 워크플로우를 **분석 → 스펙(사람 승인) → 구현 → 검증**으로 강제해서 위 문제를 막습니다. 핵심은 "AI를 믿는" 게 아니라 **구조와 도구로 강제하는** 것입니다:

| 장치 | 역할 |
|---|---|
| 단계 분리 커맨드 | 분석 커맨드에는 구현 지시가 아예 없음 — 스펙에서 구조적으로 멈춤 |
| 승인 게이트 훅 | 스펙의 승인 체크박스(사람만 체크)가 없으면 production 파일 수정을 차단 |
| 근거 분류 | 코드에서 확인한 사실만 Confirmed, 나머지는 미확인/Open Question — 추측 구현 금지 |
| 격리 브랜치 | 모든 작업은 `feature/ai-migration-*` 브랜치 — 롤백은 브랜치 삭제 |

## 설치

### Claude Code

```text
/plugin marketplace add winkrj/ai-legacy-migration-framework-kit
/plugin install legacy-migration@legacy-migration-kit
```

### Codex

```text
codex plugin marketplace add winkrj/ai-legacy-migration-framework-kit
```

이후 Plugins 화면(또는 CLI의 `/plugins`)에서 **Legacy Migration Kit**을 설치합니다.

플러그인 대신 커스텀 프롬프트로 쓰고 싶다면:

```bash
npx --yes github:winkrj/ai-legacy-migration-framework-kit
```

`~/.codex/prompts/`에 `/migrate-start` 등 프롬프트 5종이 설치됩니다. 상세는 [codex/INSTALL.md](codex/INSTALL.md).

### 설치 없이

zip으로 받아서 [`prompts/start-migration.md`](prompts/start-migration.md)의 프롬프트를 복붙해도 됩니다. Markdown 템플릿 모음이라 그걸로 충분히 동작합니다.

## 5분 시작하기

이관할 (새) 프로젝트를 AI로 열고:

**1. 이관 시작** — 빈칸은 기능명과 레거시 repo 경로 2개뿐입니다.

```text
/legacy-migration:start 공지사항목록 ~/work/legacy-admin
```

AI가 격리 브랜치를 만들고, 레거시를 추적(진입점 → 호출 흐름 → 쿼리 조건 → 정렬/페이징 → 숨은 규칙)해서 `docs/migration/공지사항목록/`에 분석 문서와 스펙 초안을 쓰고 **멈춥니다.**

**2. 스펙 검토 & 승인** — `02_Spec.md`를 열어 "사람이 결정할 것" 항목에 답하고, 맨 아래 승인 체크박스를 체크합니다.

```markdown
- [x] 위 계약대로 구현을 승인한다 (승인자: 홍길동 / 날짜: 2026-07-06)
```

이 체크박스는 사람만 체크합니다. 체크 전에는 훅이 이관 문서 밖의 모든 파일 수정을 차단합니다.

**3. 구현 지시**

```text
/legacy-migration:implement 공지사항목록
```

AI가 승인된 계약 범위만 구현하고, 테스트를 작성·실행하고(실패는 그대로 보고), 결과 문서를 남기고 commit 후 멈춥니다. push와 MR은 당신이 지시할 때만 합니다.

Codex에서는 플러그인 설치 후 자연어로 요청하거나(스킬이 같은 절차를 적용), 커스텀 프롬프트 `/migrate-start` → `/migrate-implement`를 사용합니다.

## 명령어

| Claude Code | Codex 프롬프트 | 하는 일 |
|---|---|---|
| `/legacy-migration:conventions [참고경로]` | `/migrate-conventions` | 컨벤션 등록 (아래 참고) |
| `/legacy-migration:start 기능명 경로` | `/migrate-start` | 레거시 분석 + 스펙 초안 → 멈춤 |
| `/legacy-migration:implement 기능명` | `/migrate-implement` | 승인 확인 후 구현 + 테스트 + commit |
| `/legacy-migration:validate 케이스명` | `/migrate-validate` | 이관 문서 구조 검사 (Validator CLI) |
| `/legacy-migration:full 기능명 경로` | `/migrate-full` | 고위험 케이스용 Full 모드 |

## 팀 컨벤션 주입

이관 결과물이 팀 스타일을 따르게 하려면 컨벤션을 먼저 등록하세요. 세 가지 방식을 지원합니다:

1. **직접 입력** — 대화로 규칙을 제시하면 템플릿 구조로 정규화
2. **참고 프로젝트에서 추출** — `/legacy-migration:conventions ~/work/team-guide` → 반복 패턴과 **반례**를 근거로 초안 생성
3. **현재 프로젝트에서 추출** — 인자 없이 실행

결과는 `docs/conventions/`에 **Draft**로 저장되고, 사람이 문서의 Human Decision을 Approved로 바꿔야만 이후 스펙/구현이 binding rule로 사용합니다. AI는 컨벤션을 발명하지 않고, 패턴이 갈리는 지점은 물어봅니다.

## 두 가지 모드

| | Light 모드 (기본) | Full 모드 |
|---|---|---|
| 문서 | 3개 (`templates/migration-docs-light/`) | 8개 + OpenSpec (`templates/migration-docs/`) |
| 대상 | 일반 기능의 실제 이관 | 결제·인증·PII·공유 코드·cutover 판단 |
| 검증 | 스펙 승인 체크 + 사람 리뷰 | Validator CLI + 단계별 Human Gate |

규칙은 두 모드 공통 3개: **레거시 read-only · 계약은 사람 승인 후 구현 · 격리 브랜치**.

AI가 분석 중 결제/인증/개인정보/공유 코드를 만나면 Light 모드로 계속하지 않고 멈춰서 보고합니다.

## 문서 검사 (Validator CLI)

이관 문서의 필수 문서/섹션/필드, 상태 어휘, 민감정보 패턴, 구현 경계를 검사하는 read-only CLI입니다. 설치 없이 실행됩니다:

```bash
npx --yes github:winkrj/legacy-migration-validator-cli \
  --root ./docs/migration/<case> \
  --report ./reports/<case>-validation-report.md
```

Validator 통과는 문서 구조 검사일 뿐 도메인 정확성 보장이 아닙니다 — 그건 사람 승인과 테스트의 몫입니다.

## 자주 묻는 질문

**Q. AI가 승인 전에 코드를 만들려고 하면?**
Claude Code에서는 훅이 자동 차단합니다. Codex에서는 훅 동작이 아직 검증되지 않았으니 분석 세션과 구현 세션을 분리해서 쓰고, 위반하면 "멈춰, 스펙 승인 전이야"라고 하면 됩니다.

**Q. 이관을 되돌리고 싶어요.**
모든 작업이 `feature/ai-migration-<기능명>` 브랜치에 격리되어 있습니다. 브랜치를 삭제하면 끝입니다.

**Q. 테스트가 실패한 채로 끝났어요.**
정상 동작입니다. kit은 실패를 숨기거나 assertion을 약화하는 것을 금지합니다. 결과 문서의 실패 내역을 보고 재지시하세요.

**Q. 스펙 문서가 꼭 필요한가요?**
스펙은 AI 산출물을 검증할 기준선입니다. 스펙 없이는 "구현이 맞는지"를 판단할 기준이 리뷰어의 기억뿐이고, 미확인 동작과 결정 필요 항목이 구현 후에야 드러납니다.

## Repository 구조

```text
.claude-plugin/           Claude Code 플러그인 매니페스트 + 마켓플레이스
.agents/plugins/          Codex 마켓플레이스
plugins/legacy-migration/ Codex 플러그인 (스킬 + 참조 문서 + 자체 템플릿)
commands/                 Claude Code 슬래시 커맨드 5종
skills/                   Claude Code 스킬
hooks/                    스펙 승인 게이트 훅 (PreToolUse)
codex/                    Codex 커스텀 프롬프트 5종 + 설치 가이드
templates/                이관 문서 / OpenSpec / 컨벤션 / 증거 템플릿
guides/                   walkthrough, 팀 사용 가이드, HTML 사용 가이드
prompts/                  복붙용 시작 프롬프트 (설치 없이 쓸 때)
examples/                 합성 예제 스켈레톤
decisions/                설계 결정 기록
```

## 이 Kit이 아닌 것

- Production-ready 이관 자동화 플랫폼 — 사람 승인과 리뷰가 워크플로우의 일부입니다
- 도메인 동작을 자동 결정하는 도구 — 애매한 건 물어봅니다
- Auto-fix 도구 — 훅은 차단만 하고, 코드를 대신 고치지 않습니다

## License

MIT — [LICENSE](LICENSE)
