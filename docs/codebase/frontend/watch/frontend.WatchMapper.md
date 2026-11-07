---
type: mapper
package: frontend
module: watch
status: implemented
source:
  - frontend/lib/modules/watch/infrastructure/acl/watch_mapper.dart
tests:
  - frontend/test/modules/watch/infrastructure/acl/watch_mapper_test.dart
---
# frontend.WatchMapper

Module: [[frontend.watch (module)]]
Rules: [[05-infrastructure-layer#Anti-Corruption Layer]]

## Purpose

Translates between the API's watch JSON and the app's types:

- `toDomain`: one item of the API's watch JSON into a [[core.Watch]], through `Watch.restore`.
- `toJson`: a [[frontend.WatchDraft]] into the `WatchInput` body of `POST /watches`: `name`, `brand`, `type`, `category`, `description`, `tags`, `complications` and `imageUrl` (an empty string when there is no image).

## External shape

The `Watch` schema of `/openapi`: `id`, `name`, `description`, `brand`, `type`, `category`, `tags`, `complications`, `imageUrl` (nullable), `createdAt`, `updatedAt` (ISO 8601). The API does not return the owner, so the caller passes it: it is the user who asked.

## Domain shape

[[core.Watch]] and [[frontend.WatchDraft]]

## Relations

- Used by [[frontend.HttpWatchCollectionRepository]]
