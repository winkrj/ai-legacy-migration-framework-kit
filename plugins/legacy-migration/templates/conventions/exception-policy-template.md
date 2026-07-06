# Exception Policy Convention

## Current Project Rule

| Concern | Project Decision |
|---|---|
| Validation Error |  |
| Not Found |  |
| Conflict |  |
| External Dependency Error |  |
| Unexpected Error |  |
| Generalized Error Body |  |
| Logging / Sensitive Data |  |

## Existing Evidence

| Evidence ID | Handler / Test / API Doc | Observed Mapping | Counterexample |
|---|---|---|---|
| EV-EX-001 |  |  |  |

## Exceptions

| Endpoint / Feature | Exception | Reason |
|---|---|---|
|  |  |  |

## Open Questions

| ID | Question | Owner | Required Before | Status |
|---|---|---|---|---|
| OQ-EX-001 |  |  | Implementation | Open |

## Human Decision

- Decision: Pending / Approved / Rejected
- Approved By / At:

## AI Agent Rules

- Do not normalize error behavior without policy approval.
- Treat Legacy/Target difference as Policy Difference until classified.
- Never expose stack trace, secret or private identifier in error evidence.
