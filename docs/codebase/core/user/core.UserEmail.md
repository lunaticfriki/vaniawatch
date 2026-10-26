---
type: value-object
package: core
module: user
status: implemented
source:
  - core/lib/src/user/value_objects/user_email_value_object.dart
tests:
  - core/test/user/value_objects/user_email_value_object_test.dart
---
# core.UserEmail

Module: [[core.user (module)]]
Rules: [[03-domain-layer#Value object]]

## Purpose

The user's email address.

## Validation

Trimmed and lowercased, and must match `local@domain.tld` with no spaces. Otherwise `InvalidUserEmailError`. Equality is therefore case-insensitive.

## Factories

- `create(String)`
- `empty()`

## Relations

- Part of [[core.User]]
- Errors extend [[core.DomainError]]

## Testing

- Mother: `UserEmailMother` (`core/lib/src/testing/user/user_email_mother.dart`)
