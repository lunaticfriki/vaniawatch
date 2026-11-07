---
type: command
package: frontend
module: watch
status: implemented
source:
  - frontend/lib/modules/watch/application/command/create_watch_command.dart
  - frontend/lib/modules/watch/application/command/create_watch_command_handler.dart
tests:
  - frontend/test/modules/watch/application/command/create_watch_command_handler_test.dart
---
# frontend.CreateWatchCommand

Module: [[frontend.watch (module)]]
Rules: [[04-application-layer-cqrs#Commands and queries, no use cases]]

## Purpose

Adds a new watch to the current user's collection, with an optional photo.

## Payload

`name`, `brand`, `type`, `category`, `description`, `tags` and `complications` as the user typed them, plus an optional [[frontend.WatchImageStorage]] `WatchImage` (the picked file's bytes and name).

## Handler steps

1. Build a [[frontend.WatchDraft]] without an image. This validates every field through [[core]] value objects before anything is uploaded.
2. If there is an image, upload it with [[frontend.WatchImageStorage]] and put the returned [[core.WatchImageUrl]] on the draft.
3. Add the draft with [[frontend.WatchCollectionRepository]] and return the new id.

## Errors

- `WatchDraftRejectedException`: one or more fields are invalid. Nothing is uploaded or saved.
- `WatchImageUploadFailedException`: the image could not be uploaded. Nothing is saved.
- `WatchCollectionUnavailableException`: the API could not save the watch.

## Relations

- Grouped in [[frontend.WatchWriteService]]
- Mirrors [[backend.CreateWatchCommand]], which receives the result over HTTP
