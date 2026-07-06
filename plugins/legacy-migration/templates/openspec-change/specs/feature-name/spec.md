# Capability: <feature-name>

## Requirements

### Requirement: Query migrated content

The target system SHALL return content that satisfies the approved query contract.

#### Scenario: Basic query

- **Given** approved sample content exists
- **When** a valid query is submitted
- **Then** matching content is returned

#### Scenario: Empty result

- **Given** no content matches
- **When** a valid query is submitted
- **Then** an empty result is returned without inventing data

#### Scenario: Filtered result

- **Given** content has public-safe category values
- **When** an approved filter is supplied
- **Then** only matching content is returned

#### Scenario: Invalid parameter

- **Given** a parameter violates the approved contract
- **When** the query is submitted
- **Then** the documented validation error is returned

## Open Questions

- <OQ-ID and required decision>
