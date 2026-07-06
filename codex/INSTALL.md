# Codex 플러그인 설치 가이드

이 저장소는 Codex 팀 marketplace와 `legacy-migration` 플러그인을 함께 제공한다.

## 1. 한 줄 설치

```bash
npx --yes github:winkrj/ai-legacy-migration-framework-kit
```

설치기는 다음 명령을 수행한다.

```bash
codex plugin marketplace add winkrj/ai-legacy-migration-framework-kit
codex plugin marketplace upgrade legacy-migration-kit
codex plugin add legacy-migration@legacy-migration-kit
```

설치 후에는 새 Codex thread를 연다. 플러그인 훅은 최초 사용 시 정의를 검토하고 신뢰해야 실행된다.

## 2. 사용

자연어로 요청하면 플러그인의 `legacy-migration` 스킬이 필요한 워크플로를 선택한다.

- `참고 프로젝트에서 컨벤션 초안을 추출해줘`
- `공지사항 목록 기능 이관을 분석 단계부터 시작해줘. 레거시는 ~/work/legacy-admin이야`
- `승인된 공지사항 목록 스펙을 구현해줘`
- `이 이관 문서를 검증해줘`
- `인증 기능이므로 Full 모드로 이관을 시작해줘`

분석 단계는 `01_Analysis.md`와 `02_Spec.md`를 작성하고 멈춘다. 사람이 결정 항목을 채우고 구현 승인 체크박스를 체크한 뒤 별도 요청으로 구현한다.

## 3. 플러그인 구성

- manifest: `plugins/legacy-migration/.codex-plugin/plugin.json`
- skill: `plugins/legacy-migration/skills/legacy-migration/SKILL.md`
- 워크플로 reference: `plugins/legacy-migration/skills/legacy-migration/references/`
- 템플릿: `plugins/legacy-migration/templates/`
- 승인 게이트 훅: `plugins/legacy-migration/hooks/`
- 팀 marketplace: `.agents/plugins/marketplace.json`

## 4. 업데이트

```bash
codex plugin marketplace upgrade legacy-migration-kit
codex plugin add legacy-migration@legacy-migration-kit
```

업데이트 후 새 thread를 열어야 변경된 skill과 훅이 확실하게 적용된다.

## 기존 프롬프트 팩

`codex/prompts/`는 이전 설치 방식과의 호환을 위해 남겨두지만 신규 설치에는 사용하지 않는다. 신규 사용자는 플러그인 방식을 사용한다.
