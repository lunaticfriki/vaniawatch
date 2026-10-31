---
type: service
package: backend
module: watch
status: implemented
source:
  - backend/lib/modules/watch/application/watch_write_service.dart
tests:
  - backend/test/modules/watch/application/watch_write_service_test.dart
---
# backend.WatchWriteService

Module: [[backend.watch (module)]]
Rules: [[04-application-layer-cqrs#Read, write and state services]]

## Kind

write

## Operations

- `create(CreateWatchCommand)`: returns the new id.
- `update(UpdateWatchCommand)`
- `delete(DeleteWatchCommand)`

## Relations

- Groups [[backend.CreateWatchCommand]], [[backend.UpdateWatchCommand]] and [[backend.DeleteWatchCommand]]
- Used by [[backend.WatchesRoute]]
