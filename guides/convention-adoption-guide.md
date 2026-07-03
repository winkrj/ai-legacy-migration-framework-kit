# Convention Adoption Guide

## Principle

Framework Kit은 convention template을 제공하지만 universal architecture 또는 Target project rule을 정하지 않는다.

AI Agent는 project convention을 발명하면 안 된다. 기존 code, test와 문서에서 반복 pattern과 반례를 수집해 draft만 작성한다. Human approval 전에는 binding rule이 아니다.

## Extraction Workflow

1. **Scope**: 대상 module, layer와 feature를 정한다.
2. **Inspect**: 관련 code, tests, API docs와 기존 guide를 읽는다.
3. **Collect Evidence**: 동일 pattern의 여러 사례와 반례를 기록한다.
4. **Draft**: `templates/conventions/`를 사용해 current rule 후보와 uncertainty를 작성한다.
5. **Review**: Human이 rule, exception, 적용 범위와 owner를 검토한다.
6. **Approve**: 승인 metadata를 기록한다.
7. **Adopt**: `AGENTS.md`/`CLAUDE.md`가 승인된 convention 위치를 참조한다.
8. **Revisit**: 실제 변경에서 충돌이 발견되면 Open Question 또는 exception으로 되돌린다.

Lifecycle:

`Observed Patterns → Draft Convention → Human Review → Approved Convention`

## Evidence Minimum

- 한 사례만으로 universal rule을 만들지 않는다.
- 가능한 경우 둘 이상의 일관된 사례를 확인한다.
- 반례와 legacy-only pattern을 구분한다.
- 확인하지 못한 내용은 Open Question으로 남긴다.

## Target Project Location

정확한 위치는 Target repository가 결정한다. 권장 후보:

- `docs/conventions/`
- `guide/conventions/`
- 기존 project engineering guide 하위

Personal Obsidian draft가 Target project의 approved convention을 대체하지 않는다.

## Agent References

`AGENTS.md`와 `CLAUDE.md`에는 전체 convention을 복제하지 않고 다음을 명시한다.

- Canonical convention directory
- Approval status 확인 규칙
- Feature exception 위치
- Convention 미확인 시 stop condition

## Feature-specific Exceptions

- Target requirement 차이는 OpenSpec에 기록한다.
- Migration-specific exception과 evidence는 migration docs에 기록한다.
- Exception은 project-wide convention을 자동 변경하지 않는다.
- 새로운 binding rule은 Human approval이 필요하다.

## Prohibited Behavior

- 선호 architecture를 Target convention으로 선언
- 단일 class pattern을 team rule로 승격
- Draft convention을 구현 permission으로 해석
- Human approval 없이 exception을 일반화
