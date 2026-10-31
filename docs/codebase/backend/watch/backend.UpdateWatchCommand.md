---
type: command
package: backend
module: watch
status: implemented
source:
  - backend/lib/modules/watch/application/command/update_watch_command.dart
  - backend/lib/modules/watch/application/command/update_watch_command_handler.dart
tests:
  - backend/test/modules/watch/application/command/update_watch_command_handler_test.dart
---
# backend.UpdateWatchCommand

Module: [[backend.watch (module)]]
Rules: [[04-application-layer-cqrs#Commands and queries, no use cases]]

## Purpose

Replaces every editable field of a watch. This is full replacement (HTTP `PUT`): an omitted optional field is cleared.

## Payload

`id`, `ownerId`, and the same fields as [[backend.CreateWatchCommand]].

## Handler steps

1. Build every value object first, so invalid input leaves the watch untouched.
2. Loads the watch and throws [[core.WatchNotFoundError]] when it is missing **or** not owned by `ownerId`, so foreign watches stay invisible ([[ADR-0007 temporary user identification and private collections]]).
3. Apply `rename`, `describe`, `rebrand`, `changeType`, `changeCategory`, `retag`, `changeComplications` and `changeImage`, all with one `at` from [[backend.ClockService]].
4. `save`.

## Errors

[[core.WatchNotFoundError]] becomes a 404. Validation errors become a 400. [[core.InvalidUpdatedAtError]] becomes a 409.

## Relations

- Changes [[core.Watch]]
- Uses [[core.WatchRepository]] and [[backend.ClockService]]
- Exposed by [[backend.WatchWriteService]]
