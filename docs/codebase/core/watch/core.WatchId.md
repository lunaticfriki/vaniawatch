---
type: value-object
package: core
module: watch
status: implemented
source:
  - core/lib/src/watch/value_objects/watch_id_value_object.dart
tests:
  - core/test/watch/value_objects/watch_id_value_object_test.dart
---
# core.WatchId

Module: [[core.watch (module)]]
Rules: [[03-domain-layer#Value object]]

## Purpose

The identity of a watch.

## Validation

Must be a UUID. The value is trimmed and lowercased. Otherwise `InvalidWatchIdError`.

## Factories

- `create(String)`
- `generate()`
- `empty()`

## Relations

- Generated and validated by [[core.UuidService]]
- Identity of [[core.Watch]]
- Errors extend [[core.DomainError]]

## Testing

- Mother: `WatchIdMother` (`core/lib/src/testing/watch/watch_id_mother.dart`)
