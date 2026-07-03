# AI Legacy Migration Framework Kit

## 프로젝트 목적

이 repository는 OpenSpec 기반 요구사항, migration documentation, AI Agent prompt와 safety policy를 함께 사용해 legacy migration을 일관되게 준비하는 Markdown-first Kit이다.

**Status: Framework Kit v1 Draft / Not Production Ready**

## 이 Kit이 제공하는 것

- OpenSpec change templates
- Discover → Specify → Plan → Implement → Validate → Archive 문서 templates
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

## Quick Start

1. `templates/target-project/` scaffold를 target project에 적용한다.
2. `templates/openspec-change/`로 OpenSpec change를 작성한다.
3. `templates/migration-docs/`로 migration 문서를 작성한다.
4. `prompts/`와 `agent/`의 승인된 Agent instructions를 사용한다.
5. Validator CLI로 migration docs를 검사한다.
6. 검증 결과와 남은 질문을 Archive 문서에 기록한다.

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
