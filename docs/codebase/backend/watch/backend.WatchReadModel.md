---
type: read-model
package: backend
module: watch
status: implemented
source:
  - backend/lib/modules/watch/application/watch_read_model.dart
tests:
  - backend/test/modules/watch/application/watch_read_model_test.dart
---
# backend.WatchReadModel

Module: [[backend.watch (module)]]
Rules: [[04-application-layer-cqrs#Read models are optional]]

## Purpose

An immutable snapshot of a [[core.Watch]] in primitives. A read model is required here because `Watch` has behavior and mutable state.

## Fields

`id`, `ownerId`, `name`, `description`, `brand`, `type`, `category`, `tags`, `complications`, `imageUrl` (null when there is no image), `createdAt`, `updatedAt`. The lists are unmodifiable. Equality is structural.

## Built from

`WatchReadModel.fromDomain(Watch)`

## Relations

- Returned by [[backend.GetWatchQuery]] and [[backend.ListWatchesQuery]]
- Serialized by `WatchResponse` in [[backend.WatchesRoute]]
- Test Mother: `WatchReadModelMother`
