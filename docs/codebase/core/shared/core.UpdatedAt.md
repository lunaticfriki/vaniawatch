---
type: value-object
package: core
module: shared
status: implemented
source:
  - core/lib/src/shared/value_objects/updated_at_value_object.dart
tests:
  - core/test/shared/value_objects/updated_at_value_object_test.dart
---
# core.UpdatedAt

Module: [[core.shared (module)]]
Rules: [[03-domain-layer#Value object]]

## Purpose

The moment an entity last changed, always stored in UTC. It never moves backwards.

## Validation

None on its own. Entities use `isBefore` and `isBeforeCreation` to enforce their invariants.

## Factories

- `create(DateTime)`: converts to UTC.
- `now()`: the current moment.
- `fromCreatedAt(CreatedAt)`: the initial update moment.
- `empty()`: the unix epoch.

## Behavior

- `isBefore(UpdatedAt)`
- `isBeforeCreation(CreatedAt)`

## Relations

- Compared with [[core.CreatedAt]]
- Violations raise [[core.InvalidUpdatedAtError]]
- Used by [[core.User]] and [[core.Watch]]

## Testing

- Mother: `UpdatedAtMother` (`core/lib/src/testing/shared/updated_at_mother.dart`)
