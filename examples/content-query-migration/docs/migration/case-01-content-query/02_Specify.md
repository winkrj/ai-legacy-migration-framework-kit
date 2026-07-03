# Specify

## Status

Status: Planning
Implementation: Not Started
Automation: Not Started
MCP/Plugin: Deferred

## Domain Rules

| Rule ID | Rule | Evidence Level | Approval |
|---|---|---|---|
| RULE-001 | A valid query returns matching synthetic content. | Observed | Draft |
| RULE-002 | An empty query result returns an empty collection. | Observed | Draft |

## API Map

- Input: optional `category`, `publishedStatus`, `page`
- Output: synthetic content summaries as a paginated query result
- Error/Empty policy: an empty result returns an empty collection

## DB Map

- Data entity: `synthetic-content` (semantic alias, no real store)
- Query conditions: optional category and published-status filters
- Result shape: content identifier, title placeholder, category, published status

## Compatibility

- The example target keeps the legacy empty-result behavior: empty collection, no error.

## Open Questions

- OQ-EX-001

## Specify Gate

Needs Human Policy Decision
