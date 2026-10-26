---
type: decision
status: accepted
date: 2026-10-26
---
# ADR-0002 tests mirror lib

Index: [[decisions]]

## Context

The shared standards put tests in co-located `__tests__/` folders. Dart tooling discovers tests under `test/` and keeps dev dependencies out of `lib/`. The app packages also need to reuse `core`'s Object Mothers.

## Decision

Tests live under `test/`, mirroring `lib/` one-to-one. `core`'s Object Mothers live in `core/lib/src/testing/` and are exported only through `core/lib/testing.dart`.

## Consequences

- Standard `dart test` and `flutter test` work with no configuration.
- Production code must never import the Mothers. The arch tests enforce this.

## Related

[[02-testing]], [[08-structure-and-naming#Tests mirror lib]]
