---
type: value-object
package: core
module: watch
status: implemented
source:
  - core/lib/src/watch/value_objects/watch_category_value_object.dart
tests:
  - core/test/watch/value_objects/watch_category_value_object_test.dart
---
# core.WatchCategory

Module: [[core.watch (module)]]
Rules: [[03-domain-layer#Value object]]

## Purpose

The kind of movement.

## Validation

One of `mechanical` or `quartz`, matched ignoring case and surrounding spaces. Otherwise `InvalidWatchCategoryError`.

## Factories

- `mechanical()`
- `quartz()`
- `create(String)`

## Behavior

`isMechanical`, `isQuartz`

## Relations

- Part of [[core.Watch]]
- Errors extend [[core.DomainError]]

## Testing

- Mother: `WatchCategoryMother` (`core/lib/src/testing/watch/watch_category_mother.dart`)
