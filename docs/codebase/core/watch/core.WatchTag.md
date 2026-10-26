---
type: value-object
package: core
module: watch
status: implemented
source:
  - core/lib/src/watch/value_objects/watch_tag_value_object.dart
tests:
  - core/test/watch/value_objects/watch_tag_value_object_test.dart
---
# core.WatchTag

Module: [[core.watch (module)]]
Rules: [[03-domain-layer#Value object]]

## Purpose

A free label the owner uses to organize the collection, for example "diver" or "vintage".

## Validation

Trimmed and lowercased, between 1 and 30 characters. Otherwise `InvalidWatchTagError`. Equality is therefore case-insensitive.

## Factories

- `create(String)`

## Relations

- Collected in [[core.WatchTags]]
- Errors extend [[core.DomainError]]

## Testing

- Mother: `WatchTagMother` (`core/lib/src/testing/watch/watch_tag_mother.dart`)
