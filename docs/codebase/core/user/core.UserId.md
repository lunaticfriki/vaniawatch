---
type: value-object
package: core
module: user
status: implemented
source:
  - core/lib/src/user/value_objects/user_id_value_object.dart
tests:
  - core/test/user/value_objects/user_id_value_object_test.dart
---
# core.UserId

Module: [[core.user (module)]]
Rules: [[03-domain-layer#Value object]]

## Purpose

The identity of a user. It is also the owner reference stored on each [[core.Watch]].

## Validation

Must be a UUID. The value is trimmed and lowercased. Otherwise `InvalidUserIdError`.

## Factories

- `create(String)`
- `generate()`: a new random UUID v4.
- `empty()`

## Relations

- Generated and validated by [[core.UuidService]]
- Identity of [[core.User]]
- Owner of [[core.Watch]]
- Errors extend [[core.DomainError]]

## Testing

- Mother: `UserIdMother` (`core/lib/src/testing/user/user_id_mother.dart`)
