---
date: 2026-10-10
type: change-record
decision: allow
tags:
  - action-log
---

# Add empty factories to domain entities

## Decision

ALLOW

## Affected Components

- Dart Frog backend
- Flutter frontend
- core domain
- project root or unclassified path
- project rules and documentation

## Changed Paths

- `core/auth/entities/user.entity.dart`
- `core/catalog/entities/watch.entity.dart`
- `core/auth/value_objects`
- `core/catalog/value_objects`
- `docs/architecture/rules.md`
- `docs/architecture/domain-model.md`
- `CLAUDE.md`

## Checks

- Core dependency boundary: passed
- Watch ownership boundary: passed
- Feature/fix summary: added `User.empty()` and `Watch.empty()` with
  supporting empty identity/detail value objects, Object Mother variants,
  entity tests, and documentation that empty sentinels are transient and
  non-persistable.
- Validation: `dart analyze .` passed from `core/`; all 11 domain tests passed
  with the three co-located test files run through `dart run test`.
