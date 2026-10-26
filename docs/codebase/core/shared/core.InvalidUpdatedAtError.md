---
type: domain-error
package: core
module: shared
status: implemented
source:
  - core/lib/src/shared/errors/invalid_updated_at_error.dart
tests: []
---
# core.InvalidUpdatedAtError

Module: [[core.shared (module)]]
Rules: [[03-domain-layer#Domain errors and warnings]]

## Thrown when

- `restore` receives an update moment before the creation moment.
- A change on an entity receives an `at` before the entity's current `updatedAt`.

## Relations

- Extends [[core.DomainError]]
- Thrown by [[core.User]] and [[core.Watch]]
- Uses [[core.UpdatedAt]] and [[core.CreatedAt]]
