---
type: value-object
package: core
module: user
status: implemented
source:
  - core/lib/src/user/value_objects/user_name_value_object.dart
tests:
  - core/test/user/value_objects/user_name_value_object_test.dart
---
# core.UserName

Module: [[core.user (module)]]
Rules: [[03-domain-layer#Value object]]

## Purpose

The user's display name.

## Validation

Trimmed, between 2 and 50 characters. Otherwise `InvalidUserNameError`.

## Factories

- `create(String)`
- `empty()`

## Relations

- Part of [[core.User]]
- Errors extend [[core.DomainError]]

## Testing

- Mother: `UserNameMother` (`core/lib/src/testing/user/user_name_mother.dart`)
