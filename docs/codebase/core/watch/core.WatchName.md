---
type: value-object
package: core
module: watch
status: implemented
source:
  - core/lib/src/watch/value_objects/watch_name_value_object.dart
tests:
  - core/test/watch/value_objects/watch_name_value_object_test.dart
---
# core.WatchName

Module: [[core.watch (module)]]
Rules: [[03-domain-layer#Value object]]

## Purpose

The name the owner gives a watch, for example "Speedmaster Moonwatch".

## Validation

Trimmed, between 1 and 100 characters. Otherwise `InvalidWatchNameError`.

## Factories

- `create(String)`
- `empty()`

## Relations

- Part of [[core.Watch]]
- Errors extend [[core.DomainError]]

## Testing

- Mother: `WatchNameMother` (`core/lib/src/testing/watch/watch_name_mother.dart`)
