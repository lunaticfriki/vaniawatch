---
type: value-object
package: core
module: shared
status: implemented
source:
  - core/lib/src/shared/value_objects/created_at_value_object.dart
tests:
  - core/test/shared/value_objects/created_at_value_object_test.dart
---
# core.CreatedAt

Module: [[core.shared (module)]]
Rules: [[03-domain-layer#Value object]]

## Purpose

The moment an entity was created, always stored in UTC.

## Validation

None. Any `DateTime` is accepted and converted to UTC.

## Factories

- `create(DateTime)`: converts to UTC.
- `now()`: the current moment, for the application layer. Entities never call it.
- `empty()`: the unix epoch, and `isEmpty` is true.

## Relations

- Used by [[core.User]], [[core.Watch]] and [[core.UpdatedAt]]

## Testing

- Mother: `CreatedAtMother` (`core/lib/src/testing/shared/created_at_mother.dart`)
