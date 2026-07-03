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

## Quick Start (Light 모드) — 프롬프트 하나로 시작

Kit은 git clone 없이 **zip으로 받아도 된다** (Markdown 템플릿 모음이므로). 받은 kit commit hash만 케이스 문서에 기록한다.

1. **받기**: Kit zip을 받고, 이관할 프로젝트를 AI(Claude Code / Codex)로 연다.
2. **붙여넣기**: [`prompts/start-migration.md`](prompts/start-migration.md)의 프롬프트에 빈칸 2개(기능명, 레거시 경로)를 채워 붙여넣는다.
   → AI가 브랜치 생성 → 레거시 분석(`01_Analysis.md`) → 스펙 초안(`02_Spec.md`)까지 만들고 **멈춘다.**
3. **승인**: `02_Spec.md`의 결정 항목을 채우고 승인 체크 → "승인"이라고 답한다.
   → AI가 승인된 범위만 구현 + 테스트 + `03_Result.md` 기록 후 commit까지 하고 멈춘다. Push/MR은 당신 지시로.

각 단계를 손으로 직접 하고 싶으면 [따라하기 — 첫 이관 한 사이클](guides/walkthrough-first-cycle.md) 참조.
Full 모드 절차는 `templates/migration-docs-light/README.md`의 승격 기준과 기존 6단계(scaffold → OpenSpec → migration docs → Agent instructions → Validator → Archive)를 따른다.

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
- Executable hooks를 포함하지 않는다.
- MCP/Plugin은 Deferred다.
- CI는 Deferred다.
- Claude hooks는 placeholder 문서만 제공한다.

## 현재 제한

이 repository는 실제 target-project review flow에 한 차례 적용된 private Framework Kit draft다. Private remote는 연결됐지만 public conversion과 production use/readiness는 승인되지 않았다.
