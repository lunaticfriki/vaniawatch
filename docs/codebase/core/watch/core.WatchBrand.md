---
type: value-object
package: core
module: watch
status: implemented
source:
  - core/lib/src/watch/value_objects/watch_brand_value_object.dart
tests:
  - core/test/watch/value_objects/watch_brand_value_object_test.dart
---
# core.WatchBrand

Module: [[core.watch (module)]]
Rules: [[03-domain-layer#Value object]]

## Purpose

The brand that made the watch, for example "Seiko". It is a value object for now. Promote it to an entity if brands gain their own lifecycle.

## Validation

Trimmed, between 1 and 50 characters. Otherwise `InvalidWatchBrandError`.

## Factories

- `create(String)`
- `empty()`

## Relations

- Part of [[core.Watch]]
- Errors extend [[core.DomainError]]

## Testing

- Mother: `WatchBrandMother` (`core/lib/src/testing/watch/watch_brand_mother.dart`)
