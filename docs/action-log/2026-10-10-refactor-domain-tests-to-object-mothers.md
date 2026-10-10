---
date: 2026-10-10
type: change-record
decision: allow
tags:
  - action-log
---

# Refactor domain tests to Object Mothers

## Decision

ALLOW

## Affected Components

- Dart Frog backend
- Flutter frontend
- core domain
- project root or unclassified path
- project rules and documentation

## Changed Paths

- `core/auth/entities/__tests__`
- `core/auth/value_objects/__tests__`
- `core/catalog/entities/__tests__`
- `docs/architecture/rules.md`
- `CLAUDE.md`

## Checks

- Core dependency boundary: passed
- Watch ownership boundary: passed
- Feature/fix summary: added co-located Object Mothers for User, Watch, and
  their composed value objects; refactored domain tests to use valid fixtures
  from those mothers; added a User entity test; documented the convention.
- Validation: `dart analyze .` passed from `core/`; all 6 domain tests passed
  with `dart run test catalog/entities/__tests__/watch.entity_test.dart
  auth/value_objects/__tests__/email_address.value_object_test.dart
  auth/entities/__tests__/user.entity_test.dart` from `core/`.
