---
type: entity
package: core
module: watch
status: implemented
source:
  - core/lib/src/watch/entities/watch_entity.dart
tests:
  - core/test/watch/entities/watch_entity_test.dart
---
# core.Watch

Module: [[core.watch (module)]]
Rules: [[03-domain-layer#Entity / aggregate root]]

## Purpose

A watch in a user's private collection. It is the aggregate root of the watch module. Only its owner may see or change it, and the application layer checks that with `isOwnedBy`.

## Complications

These are plain strings, for example `chronograph` or `moon phase`. This is a deliberate exception to the no-primitives rule; see [[ADR-0006 complications are plain strings]]. The watch keeps an unmodifiable copy of the list it receives, so callers can't change it from outside. The strings are not validated, normalized or deduplicated.

## Identity

[[core.WatchId]]. Equality is by id.

## Invariants

- `updatedAt` is never before `createdAt`.
- `updatedAt` never moves backwards.
- `owner` and `createdAt` never change.

## Factories

- `create(id, owner, name, description, brand, type, category, tags, complications, imageUrl, createdAt)`: `updatedAt` starts at `createdAt`. Pass `empty()` for a missing description, tags or image, and `[]` for no complications.
- `restore(... , updatedAt)`: rejects an `updatedAt` before `createdAt`.
- `empty()`: `isEmpty` is true.

## Behavior

`isOwnedBy(UserId)`.

Every change takes `at: UpdatedAt`, rejects a moment before the current `updatedAt`, and changes nothing when rejected:

- `rename(WatchName)`
- `describe(WatchDescription)`
- `rebrand(WatchBrand)`
- `changeType(WatchType)`
- `changeCategory(WatchCategory)`
- `retag(WatchTags)`
- `changeComplications(List<String>)`
- `changeImage(WatchImageUrl)`

## Relations

- Fields: [[core.WatchId]], [[core.WatchName]], [[core.WatchDescription]], [[core.WatchBrand]], [[core.WatchType]], [[core.WatchCategory]], [[core.WatchTags]], [[core.WatchImageUrl]], [[core.CreatedAt]], [[core.UpdatedAt]]
- Owner: [[core.UserId]] of a [[core.User]]
- Raises [[core.InvalidUpdatedAtError]]
- Decisions: [[ADR-0005 entities receive time and reference owners by id]], [[ADR-0006 complications are plain strings]]

## Testing

- Mother: `WatchMother` (`core/lib/src/testing/watch/watch_mother.dart`)
