# Codex 설치 가이드

Codex CLI에서 이 Kit을 슬래시 커맨드처럼 쓰는 방법. 설치는 복사 한 번이다.

## 1. 커스텀 프롬프트 설치 (1회)

```bash
npx --yes github:winkrj/ai-legacy-migration-framework-kit
```

repo를 이미 clone했다면 `node scripts/install-codex.mjs` 또는 수동 복사도 된다:

```bash
mkdir -p ~/.codex/prompts
cp codex/prompts/*.md ~/.codex/prompts/
```

이후 Codex 세션에서 `/migrate-conventions`, `/migrate-start`, `/migrate-implement`, `/migrate-validate`, `/migrate-full`로 호출한다.

## 2. AGENTS.md 배치 (타겟 프로젝트당 1회)

타겟 프로젝트 루트에 `agent/codex/AGENTS.md`를 복사(또는 기존 AGENTS.md에 병합)한다.
이 파일이 evidence 규칙, Implementation Permission, 컨벤션 규칙을 상시 적용한다.

```bash
cp agent/codex/AGENTS.md <target-project>/AGENTS.md
```

## 3. 템플릿 배치 (타겟 프로젝트당 1회, 선택)

```bash
mkdir -p <target-project>/docs/migration
cp -R templates/migration-docs-light <target-project>/docs/migration/_templates-light
```

템플릿이 프로젝트에 없으면 프롬프트가 같은 구조의 파일을 직접 생성하므로 생략해도 된다.

## Claude Code와의 차이

Codex에는 스펙 승인 게이트 훅이 없다. 승인 전 구현 차단은 프롬프트 분리(analyze/implement가 별도 커맨드)와 AGENTS.md 규칙에 의존하므로, **분석 세션과 구현 세션을 분리**해서 쓰는 것을 권장한다.
