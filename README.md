# AI Legacy Migration Framework Kit

## 프로젝트 목적

이 repository는 OpenSpec 기반 요구사항, migration documentation, AI Agent prompt와 safety policy를 함께 사용해 legacy migration을 일관되게 준비하는 Markdown-first Kit이다.

**Status: Framework Kit v1 Draft / Not Production Ready**

## 이 Kit이 제공하는 것

- Light 모드 실전 이관 문서 templates (3-file, 기본)
- OpenSpec change templates
- Discover → Specify → Plan → Implement → Validate → Archive 문서 templates (Full 모드)
- Codex/Claude prompt templates
- `AGENTS.md`와 `CLAUDE.md` templates
- Safety, context loading, no-guessing policies
- Validator CLI adoption guide
- Target project scaffold
- Synthetic public-safe example skeleton
- Runtime Evidence and Manual Verification templates
- Project Convention extraction/adoption templates

## 이 Kit이 아닌 것

- Production-ready migration platform
- Domain behavior를 자동 결정하는 도구
- Auto-fix 또는 source mutation 도구
- 회사 code나 private migration evidence 저장소
- Validator CLI source repository

## 구성요소 관계

- **OpenSpec**: target requirement contract
- **Migration docs**: legacy evidence, plan, validation, archive 기록
- **Codex/Claude prompts**: 실행과 review를 위한 reusable instructions
- **Validator CLI**: Markdown 문서 구조와 boundary candidate 검사
- **Target project B**: 실제 OpenSpec, migration docs와 승인된 implementation의 소유자

Validator CLI는 별도 repository의 private Git dependency로 사용하며 source를 이 Kit에 포함하지 않는다.

## 두 가지 모드

| | Light 모드 (기본) | Full 모드 |
|---|---|---|
| 문서 | 3개 (`templates/migration-docs-light/`) | 8개 + OpenSpec (`templates/migration-docs/`) |
| 대상 | 일반 기능의 실제 이관 | 결제·인증·PII·공유 코드·cutover 판단 |
| 검증 | Spec 승인 체크 + 사람 리뷰 | Validator CLI + Human Gate Checklist |

규칙은 두 모드 공통 3개: **레거시 read-only · 계약은 사람 승인 후 구현 · 격리 브랜치**.

## Quick Start

### Claude Code — 플러그인 설치 (권장)

이 repo는 Claude Code 플러그인이다. 설치는 1회, 이후 업데이트는 플러그인 매니저가 관리한다.

```text
/plugin marketplace add winkrj/ai-legacy-migration-framework-kit
/plugin install legacy-migration@legacy-migration-kit
```

설치되는 것:

| 구성요소 | 역할 |
|---|---|
| `/legacy-migration:start <기능명> <레거시경로>` | 브랜치 생성 → 레거시 분석(`01_Analysis.md`) → 스펙 초안(`02_Spec.md`). **구현 단계가 커맨드에 없어서 구조적으로 여기서 끝난다.** |
| `/legacy-migration:implement <기능명>` | `02_Spec.md` 승인 체크박스 확인 후, 승인된 범위만 구현 + 테스트 + `03_Result.md` + commit |
| `/legacy-migration:full` | 결제·인증·PII·공유 코드·cutover용 Full 모드 |
| `/legacy-migration:validate <케이스명>` | Validator CLI 실행 (npx, 별도 설치 불필요) |
| 스펙 승인 게이트 훅 | 이관 브랜치에서 승인 체크 전 production 파일 수정을 **차단** |
| legacy-migration 스킬 | 커맨드 없이 "이 기능 이관해줘"라고 해도 워크플로우 자동 적용 |

사용 흐름: `start` → AI가 스펙에서 멈춤 → 당신이 `02_Spec.md` 결정 항목 채우고 승인 체크 → `implement`. Push/MR은 당신 지시로만.

### Codex — 프롬프트 팩 설치

```bash
cp codex/prompts/*.md ~/.codex/prompts/
```

이후 `/migrate-start`, `/migrate-implement`, `/migrate-validate`, `/migrate-full`로 사용한다. 상세는 [codex/INSTALL.md](codex/INSTALL.md).

### 설치 없이 (zip / 프롬프트 복붙)

Kit은 zip으로 받아 [`prompts/start-migration.md`](prompts/start-migration.md)를 복붙하는 방식도 지원한다. 받은 kit commit hash만 케이스 문서에 기록한다.

각 단계를 손으로 직접 하고 싶으면 [따라하기 — 첫 이관 한 사이클](guides/walkthrough-first-cycle.md) 참조.
결제·인증·PII·공유 코드·cutover 케이스는 [Full 모드 상세 가이드](guides/walkthrough-full-mode.md)를 따른다.

### Validator CLI — 설치 대신 npx 실행

```bash
npx --yes github:winkrj/legacy-migration-validator-cli --root ./docs/migration/<case> --report ./reports/<case>-validation-report.md
```

repo 접근 권한만 있으면 별도 설치가 필요 없다. 고정 버전이 필요하면 target 프로젝트 devDependency로 commit hash pinning한다.

## Teammate Guides

- [Team Usage Guide](guides/team-usage-guide.md)
- [Migration Docs Versioning Policy](guides/migration-docs-versioning-policy.md)
- [Convention Adoption Guide](guides/convention-adoption-guide.md)

## Runtime Evidence

- [Runtime Evidence Template](templates/runtime-evidence/runtime-evidence-template.md)
- [Manual Verification Checklist](templates/runtime-evidence/manual-verification-checklist-template.md)

Runtime evidence는 실제 승인된 검증 결과만 기록하며 공개 또는 portfolio 사용 전에 sanitize한다. Evidence가 없으면 fake evidence를 만들지 않는다.

## Project Conventions

[Project Convention Templates](templates/conventions/00_Index.md)는 record/class, DTO, paging, layer responsibility, exception, date/time, testing과 AI Agent stop condition을 project별로 정리한다.

Kit은 convention을 발명하지 않는다. AI Agent는 기존 code pattern과 반례로 draft를 만들고 Human이 승인한 뒤에만 binding rule로 사용한다.

## Validation Mode

Validate 문서는 다음 mode 중 실제 수행 방식만 기록한다.

- `Test Verified`
- `Manual Runtime Verified`
- `Manual Evidence Pending`
- `Review-only`
- `Blocked by Environment`

어떤 Validation Mode도 Production Readiness를 자동으로 의미하지 않는다.

## Safety Boundaries

- 회사·내부 정보, credential과 실제 운영 식별자를 포함하지 않는다.
- Production readiness를 주장하지 않는다.
- Auto-fix와 source mutation을 수행하지 않는다.
- 훅은 read-only 게이트(승인 전 수정 차단)만 포함하며, 코드를 수정하는 훅은 포함하지 않는다.
- MCP는 Deferred다.
- CI는 Deferred다.

## 현재 제한

이 repository는 실제 target-project review flow에 한 차례 적용된 private Framework Kit draft다. Private remote는 연결됐지만 public conversion과 production use/readiness는 승인되지 않았다.
