---
type: value-object
package: core
module: watch
status: implemented
source:
  - core/lib/src/watch/value_objects/watch_type_value_object.dart
tests:
  - core/test/watch/value_objects/watch_type_value_object_test.dart
---
# core.WatchType

Module: [[core.watch (module)]]
Rules: [[03-domain-layer#Value object]]

## Purpose

How the watch shows the time.

## Validation

One of `analog`, `digital` or `anadigi`, matched ignoring case and surrounding spaces. Otherwise `InvalidWatchTypeError`.

## Factories

- `analog()`
- `digital()`
- `anaDigi()`
- `create(String)`

## Behavior

`isAnalog`, `isDigital`, `isAnaDigi`

## Relations

- Part of [[core.Watch]]
- Errors extend [[core.DomainError]]

## Testing

- Mother: `WatchTypeMother` (`core/lib/src/testing/watch/watch_type_mother.dart`)
