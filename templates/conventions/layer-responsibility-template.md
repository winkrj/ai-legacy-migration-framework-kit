# Layer Responsibility Convention

## Current Project Rule

> 예시는 참고용 초안이다 — 실제 프로젝트의 관찰된 패턴(Existing Evidence)으로 교체하고 Human 승인 후에만 binding이 된다.

| Layer | Responsibility | Must Not Do |
|---|---|---|
| Controller / Entry Point | <예: HTTP 바인딩, 요청 검증 위임, UseCase 호출, 응답 변환> | <예: 비즈니스 로직 작성, repository 직접 호출> |
| Application / Use Case | <예: 흐름 조율, 트랜잭션 경계, 외부 연동 orchestration> | <예: HTTP 관심사, 다른 도메인 repository 직접 호출> |
| Domain | <예: 불변식·비즈니스 규칙, 상태 전이> | <예: 인프라 의존, 외부 API 호출> |
| Repository / Mapper | <예: 영속성 접근, 쿼리> | <예: 비즈니스 판단> |

**비즈니스 규칙의 위치 판단**: 새 규칙을 구현하기 전에 그 규칙이 **도메인 객체**(엔티티 자신의 불변식·상태 판단)에 속하는지 **UseCase**(여러 객체/외부 연동의 조율)에 속하는지 먼저 판단하고, 애매하면 질문한다.

## Existing Evidence

| Evidence ID | File / Symbol | Observed Responsibility | Counterexample |
|---|---|---|---|
| EV-LAYER-001 |  |  |  |

## Exceptions

| Feature / Module | Exception | Reason | Scope |
|---|---|---|---|
|  |  |  |  |

## Open Questions

| ID | Question | Owner | Status |
|---|---|---|---|
| OQ-LAYER-001 | Domain logic의 canonical location은 어디인가? |  | Open |

## Human Decision

- Decision: Pending / Approved / Rejected
- Approved Scope:
- Approved By / At:

## AI Agent Rules

- Existing evidence와 approved rule을 우선한다.
- 선호 architecture를 강제하지 않는다.
- Layer 이동이나 shared abstraction은 별도 승인을 받는다.
