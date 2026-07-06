# Date and Time Policy Convention

## Current Project Rule

| Concern | Project Decision |
|---|---|
| Input Date Format |  |
| Input Date-time Format |  |
| Timezone |  |
| Storage Type |  |
| JSON Serialization |  |
| Range Boundary | Inclusive / Exclusive / Other |
| Invalid Input Behavior |  |

## Existing Evidence

| Evidence ID | File / API / Test | Observed Pattern | Counterexample |
|---|---|---|---|
| EV-TIME-001 |  |  |  |

## Exceptions

| Feature | Exception | Compatibility Reason |
|---|---|---|
|  |  |  |

## Open Questions

| ID | Question | Owner | Required Before | Status |
|---|---|---|---|---|
| OQ-TIME-001 |  |  | Production/Cutover | Open |

## Human Decision

- Decision: Pending / Approved / Rejected
- Approved By / At:

## AI Agent Rules

- Do not infer timezone or serialization from type name alone.
- Use runtime evidence when static code cannot prove output format.
- Do not preserve malformed-input behavior without explicit compatibility decision.
