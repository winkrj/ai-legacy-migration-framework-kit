# Layer Responsibility Convention

## Current Project Rule

| Layer | Responsibility | Must Not Do |
|---|---|---|
| Controller / Entry Point |  |  |
| Application / Use Case |  |  |
| Domain |  |  |
| Repository / Mapper |  |  |

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
