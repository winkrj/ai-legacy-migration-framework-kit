# Capability: content-query

## Requirements

### Requirement: Query migrated content

The example target SHALL return matching synthetic content for an approved query.

#### Scenario: Basic query
- **Given** synthetic content exists
- **When** a valid query is submitted
- **Then** matching summaries are returned

#### Scenario: Empty result
- **Given** no content matches
- **When** a valid query is submitted
- **Then** an empty collection is returned

#### Scenario: Filtered result
- **Given** synthetic categories exist
- **When** a category filter is supplied
- **Then** only matching summaries are returned

#### Scenario: Invalid parameter
- **Given** a parameter violates the approved contract
- **When** the query is submitted
- **Then** a documented validation error is returned
