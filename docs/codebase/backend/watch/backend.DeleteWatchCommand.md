---
type: command
package: backend
module: watch
status: implemented
source:
  - backend/lib/modules/watch/application/command/delete_watch_command.dart
  - backend/lib/modules/watch/application/command/delete_watch_command_handler.dart
tests:
  - backend/test/modules/watch/application/command/delete_watch_command_handler_test.dart
---
# backend.DeleteWatchCommand

Module: [[backend.watch (module)]]
Rules: [[04-application-layer-cqrs#Commands and queries, no use cases]]

## Purpose

Removes a watch from its owner's collection.

## Payload

`id`, `ownerId`

## Handler steps

1. Loads the watch and throws [[core.WatchNotFoundError]] when it is missing **or** not owned by `ownerId`, so foreign watches stay invisible ([[ADR-0007 temporary user identification and private collections]]).
2. `delete`.

## Errors

[[core.WatchNotFoundError]] and `InvalidWatchIdError`.

## Relations

- Uses [[core.WatchRepository]]
- Exposed by [[backend.WatchWriteService]]
