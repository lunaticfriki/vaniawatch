---
type: value-object
package: core
module: watch
status: implemented
source:
  - core/lib/src/watch/value_objects/watch_tags_value_object.dart
tests:
  - core/test/watch/value_objects/watch_tags_value_object_test.dart
---
# core.WatchTags

Module: [[core.watch (module)]]
Rules: [[03-domain-layer#Value object]]

## Purpose

The set of tags on a watch.

## Validation

Duplicates are removed, keeping the first occurrence in order. At most 20 tags. Otherwise `InvalidWatchTagsError`.

## Factories

- `create(List<WatchTag>)`
- `empty()`

## Behavior

Immutable. `values` is unmodifiable.

- `length`, `isEmpty`, `contains(tag)`
- `add(tag)` returns new tags; adding an existing tag changes nothing.
- `remove(tag)` returns new tags.
- Equality ignores order.

## Relations

- Contains [[core.WatchTag]]
- Part of [[core.Watch]]
- Errors extend [[core.DomainError]]

## Testing

- Mother: `WatchTagsMother` (`core/lib/src/testing/watch/watch_tags_mother.dart`)
