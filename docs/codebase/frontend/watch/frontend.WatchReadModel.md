---
type: read-model
package: frontend
module: watch
status: implemented
source:
  - frontend/lib/modules/watch/application/watch_read_model.dart
tests:
  - frontend/test/modules/watch/application/watch_read_model_test.dart
---
# frontend.WatchReadModel

Module: [[frontend.watch (module)]]
Rules: [[04-application-layer-cqrs#Read models are optional]]

## Purpose

The flat shape the views render. [[core.Watch]] has behavior, so views never receive it.

## Fields

`id`, `name`, `description`, `brand`, `type`, `category`, `tags`, `complications`, `imageUrl` (nullable), `createdAt`.

## Built from

`WatchReadModel.fromDomain(Watch)`.

## Relations

- Returned by [[frontend.ListWatchesQuery]]
- Rendered by [[frontend.WatchCardView]]
