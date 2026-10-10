---
date: 2026-10-10
type: change-record
decision: allow
tags:
  - action-log
---

# Establish shared watch domain and project governance

## Decision

ALLOW

## Affected Components

- Dart Frog backend
- Flutter frontend
- core domain
- project root or unclassified path

## Changed Paths

- `core`
- `docs`
- `CLAUDE.md`
- `tool`

## Checks

- Core dependency boundary: passed
- Watch ownership boundary: passed
- Feature/fix summary: added the shared auth and watch domain package,
  owner-scoped watch repository port, project-specific architecture pages,
  Claude instructions, Obsidian vault index, and change impact/prohibition
  harness. Backend and Flutter implementations remain deferred.
- Validation: `dart analyze core` passed; `dart analyze
  tool/change_harness.dart` passed; all 5 domain tests passed via `dart run
  test catalog/entities/__tests__/watch.entity_test.dart
  auth/value_objects/__tests__/email_address.value_object_test.dart` from
  `core/`. Harness allow and prohibit scenarios behaved as expected.
