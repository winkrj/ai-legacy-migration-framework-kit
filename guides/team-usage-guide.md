# Team Usage Guide

## 이 Kit은 무엇인가

AI Legacy Migration Framework Kit은 legacy migration의 evidence, target requirement, implementation permission과 validation 결과를 Markdown으로 관리하는 template과 AI Agent instruction 모음이다.

Production-ready migration platform, domain decision engine 또는 auto-fix 도구가 아니다.

## 언제 사용하는가

- Legacy와 Target 동작을 근거 기반으로 비교할 때
- OpenSpec으로 target requirement를 명확히 할 때
- AI Agent가 수정하기 전에 scope와 permission을 고정할 때
- 구현하지 않는 결정과 runtime carry-forward를 안전하게 기록할 때

## Workflow

`Discover → Specify → OpenSpec → Plan → Implement → Validate → Archive`

1. **Discover**: Legacy/Target source와 behavior evidence를 수집한다.
2. **Specify**: Confirmed rule, policy difference와 Open Question을 분리한다.
3. **OpenSpec**: Target project가 소유할 requirement contract를 작성한다.
4. **Plan**: 승인된 requirement만 task와 validation에 연결한다.
5. **Implement**: Rule-level Implementation Permission이 있을 때만 수행한다.
6. **Validate**: Validation Mode와 실제 evidence를 기록한다.
7. **Archive**: 검증 결과와 carry-forward condition을 보존한다.

## Teammate Flow

1. Target repository의 `AGENTS.md`, `CLAUDE.md`, project conventions와 문서 정책을 확인한다.
2. OpenSpec 및 migration template을 project 규칙에 맞는 위치로 복사한다.
3. AI Agent에게 read/write scope와 금지 범위를 명시한다.
4. Human이 policy, Open Question, implementation permission을 결정한다.
5. 승인된 작업만 실행하고 diff를 review한다.
6. Validator CLI로 migration docs 구조를 검사한다.
7. test/runtime evidence와 미검증 항목을 Validate/Archive에 기록한다.

## AI Agent가 할 수 있는 일

- 승인 범위의 read-only discovery
- Evidence classification과 document draft
- 기존 code pattern 기반 convention draft
- 명시적으로 승인된 작은 변경
- 승인된 test/Validator 실행과 결과 보고

AI Agent는 project convention, business policy, implementation permission 또는 production readiness를 승인할 수 없다.

## Human이 결정해야 하는 일

- Target behavior와 policy difference
- Project convention 승인
- Repository write scope
- Rule-level Implementation Permission
- Runtime/production environment 사용
- Public evidence와 repository visibility
- Cutover 및 production readiness

## Validator CLI 사용 시점

- Migration template 작성 직후
- Human decision 반영 후
- Archive 전
- Template/guide 변경 후 regression check

Validator는 문서 구조와 deterministic boundary를 검사하며 domain correctness를 판단하지 않는다. Report는 validation root 밖에 생성한다.

## Runtime Evidence

- 먼저 safe runtime feasibility를 확인한다.
- Evidence가 없으면 결과를 추정하거나 evidence 파일을 만들지 않는다.
- `Manual Evidence Pending` 또는 `Blocked by Environment`는 Archive with Conditions가 가능하지만 production/cutover claim은 허용하지 않는다.
- 공개 또는 portfolio 사용 전 반드시 sanitize한다.

## Safety Boundaries

- Secret, credential, token, private account와 내부 topology를 기록하지 않는다.
- 승인 없이 production data 또는 외부 서비스를 사용하지 않는다.
- Open Question을 구현 scope로 바꾸지 않는다.
- Auto-fix, source mutation, CI, MCP/Plugin과 executable hook은 포함하지 않는다.
- 어떤 Validation Mode도 Production Readiness를 자동으로 의미하지 않는다.

## Minimal Checklist

- [ ] Repository mode와 Source of Truth 확인
- [ ] Included/Excluded scope 확인
- [ ] Project conventions 확인 또는 evidence 기반 draft 작성
- [ ] Human decisions와 Implementation Permission 확인
- [ ] OpenSpec과 migration docs 연결
- [ ] Validation Mode와 evidence 기록
- [ ] Validator 실행
- [ ] Carry-forward와 production/cutover blocker 기록
- [ ] 공개 전 sensitive information 제거
