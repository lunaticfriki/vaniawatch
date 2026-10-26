---
type: value-object
package: core
module: watch
status: implemented
source:
  - core/lib/src/watch/value_objects/watch_description_value_object.dart
tests:
  - core/test/watch/value_objects/watch_description_value_object_test.dart
---
# core.WatchDescription

Module: [[core.watch (module)]]
Rules: [[03-domain-layer#Value object]]

## Purpose

Free text about the watch. It is optional.

## Validation

Trimmed, at most 2000 characters. Otherwise `InvalidWatchDescriptionError`. A blank value equals `empty()`.

## Factories

- `create(String)`
- `empty()`

## Relations

- Part of [[core.Watch]]
- Errors extend [[core.DomainError]]

## Testing

- Mother: `WatchDescriptionMother` (`core/lib/src/testing/watch/watch_description_mother.dart`)
