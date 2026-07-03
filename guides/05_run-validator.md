# Run the Validator CLI

Example:

```text
legacy-validator validate --root ./docs/migration --report ./reports/migration-validation-report.md
```

- Report path must be outside the validation root.
- Generated reports are ignored by default until Phase 17 confirms policy.
- Validator pinning is finalized in Phase 17.
- Commit hash pinning is the default future recommendation.
- The Validator checks deterministic documentation consistency, not domain correctness.
