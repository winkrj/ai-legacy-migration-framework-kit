# Manual Verification Checklist

## Status

Checklist Status: Not Started
Production Readiness: Not Claimed

## Verification Target

- Feature:
- Related Requirement / Rule / Open Question:
- Validation Mode: Manual Runtime Verified / Manual Evidence Pending / Blocked by Environment
- Approved Environment Type:
- Evidence Owner:

## Preconditions

- [ ] Runtime/test execution is explicitly authorized.
- [ ] Environment is local or approved non-production.
- [ ] External service and production-data boundaries are understood.
- [ ] Synthetic or approved safe fixture is available.
- [ ] Evidence storage and sanitization policy is confirmed.

## Verification Steps

| Step | Action | Expected Result | Evidence to Capture | Actual Result | Status |
|---:|---|---|---|---|---|
| 1 |  |  | Sanitized status/shape only |  | Not Run |

## Sanitization Checklist

- [ ] Host and environment name removed
- [ ] Token, cookie and credential removed
- [ ] Real ID, title, body and attachment removed
- [ ] Account/user information removed
- [ ] DB/server/internal domain removed
- [ ] Only generalized status, field shape and outcome retained

## Blockers

| Blocker | Impact | Owner | Follow-up |
|---|---|---|---|
|  |  |  |  |

## Final Result

- Verification Result: Not Run / PASS / WARNING / BLOCKED / FAILED
- Evidence Location: Not Created
- Carry-forward Conditions:
- Production Readiness: Not Claimed

Do not create fake evidence when verification is not performed. Manual evidence does not grant Implementation Permission or production/cutover approval.
