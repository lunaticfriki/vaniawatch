---
type: command
package: backend
module: watch
status: implemented
source:
  - backend/lib/modules/watch/application/command/create_watch_command.dart
  - backend/lib/modules/watch/application/command/create_watch_command_handler.dart
tests:
  - backend/test/modules/watch/application/command/create_watch_command_handler_test.dart
---
# backend.CreateWatchCommand

Module: [[backend.watch (module)]]
Rules: [[04-application-layer-cqrs#Commands and queries, no use cases]]

## Purpose

Adds a watch to a user's collection.

## Payload

`ownerId`, `name`, `description`, `brand`, `type`, `category`, `tags`, `complications` and `imageUrl`, all primitives. The lists are copied as unmodifiable.

## Handler steps

1. Build every value object. Invalid input throws the value object's `DomainError` before anything is saved.
2. `Watch.create` with `WatchId.generate()` and `CreatedAt` from [[backend.ClockService]]. `imageUrl` goes through `WatchImageUrl.optional`.
3. `save` it.
4. Return the new id as a `String`.

## Errors

Any `Invalid*Error` from the value objects, which becomes a 400.

## Relations

- Creates [[core.Watch]]
- Uses [[core.WatchRepository]] and [[backend.ClockService]]
- Exposed by [[backend.WatchWriteService]]
- Built from HTTP by `CreateWatchRequest` in [[backend.WatchesRoute]]
