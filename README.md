# AI Legacy Migration Framework Kit

## 프로젝트 목적

이 repository는 OpenSpec 기반 요구사항, migration documentation, AI Agent prompt와 safety policy를 함께 사용해 legacy migration을 일관되게 준비하는 Markdown-first Kit이다.

**Status: Local Thin Bootstrap / Not Production Ready**

## 이 Kit이 제공하는 것

- OpenSpec change templates
- Discover → Specify → Plan → Implement → Validate → Archive 문서 templates
- Codex/Claude prompt templates
- `AGENTS.md`와 `CLAUDE.md` templates
- Safety, context loading, no-guessing policies
- Validator CLI adoption guide
- Target project scaffold
- Synthetic public-safe example skeleton

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

## Safety Boundaries

- 회사·내부 정보, credential과 실제 운영 식별자를 포함하지 않는다.
- Production readiness를 주장하지 않는다.
- Auto-fix와 source mutation을 수행하지 않는다.
- Executable hooks를 포함하지 않는다.
- MCP/Plugin은 Deferred다.
- CI는 Deferred다.
- Claude hooks는 placeholder 문서만 제공한다.

## 현재 제한

이 repository는 Phase 16-B local thin bootstrap이다. 실제 target project 적용, remote push, public conversion과 production use는 승인되지 않았다.
