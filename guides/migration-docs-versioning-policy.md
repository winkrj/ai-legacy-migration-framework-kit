# Migration Docs Versioning Policy

## Purpose

Migration document의 저장 위치, versioning 책임과 공개 가능 범위를 명확히 한다. 모든 문서를 한 저장소에 강제로 commit하지 않는다.

## Storage Modes

### Versioned Target Repository Docs

- 팀이 함께 review하고 유지해야 하는 developer-facing contract에 사용한다.
- OpenSpec은 안전하고 repository policy가 허용하면 기본적으로 versioning한다.
- Migration docs도 팀 재현성이 필요하고 sensitive information이 없을 때 versioning할 수 있다.
- Target repository의 naming, review와 ownership rule을 우선한다.

### Ignored / Local-only Docs

- 개인 분석, 제한된 evidence 또는 재생성 가능한 실행 기록에 사용한다.
- Index에 `Local-only` 또는 `Ignored`임을 명시한다.
- Human decision과 durable summary는 승인된 Source of Truth에 별도로 남긴다.
- `.gitignore`를 우회해 강제 commit하지 않는다.

### Obsidian-only Evidence

- 개인 운영 기록, decision history와 회고에 사용한다.
- Target OpenSpec 또는 developer-facing project contract를 대체하지 않는다.
- Target 구현자가 필요한 결정은 Target repository의 승인 문서에도 반영한다.

### Generated Reports

- 기본값은 ignored/local-only다.
- Validation root 밖에 생성한다.
- Commit은 team review 목적과 sanitization이 명시적으로 승인된 경우에만 허용한다.
- Absolute local path 또는 sensitive match가 포함될 수 있음을 전제로 한다.

### Runtime Evidence

- Sanitized evidence만 migration docs 또는 공유 위치에 기록한다.
- Production data와 production environment evidence는 명시적 승인 없이는 수집하지 않는다.
- Evidence가 없으면 파일이나 결과를 만들지 않는다.
- Raw response, host, token/cookie, real ID, account, DB/server/environment name을 제거한다.

### Public-safe Evidence

- 회사명, 내부 repository/path, 실제 API/DB/table, host/domain/IP, 계정과 실데이터를 제거한다.
- Generic placeholder와 synthetic example만 사용한다.
- Production readiness 또는 실제 cutover 성공을 과장하지 않는다.

## Recommended Default

| Artifact | Default |
|---|---|
| OpenSpec | Safe하면 Target repository에 versioned |
| Migration evidence | Sensitivity에 따라 Obsidian-first 또는 local-only |
| Generated Validator report | Ignored/local-only |
| Runtime evidence | Sanitized only |
| Portfolio evidence | Public-safe abstraction only |

## Decision Record

각 case Index 또는 Archive에 다음을 기록한다.

- Storage Mode
- Canonical Source of Truth
- Versioned / Ignored 여부
- Evidence owner
- Public-safe 여부
- Retention 또는 carry-forward 위치
