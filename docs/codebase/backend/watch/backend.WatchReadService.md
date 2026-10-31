---
type: service
package: backend
module: watch
status: implemented
source:
  - backend/lib/modules/watch/application/watch_read_service.dart
tests:
  - backend/test/modules/watch/application/watch_read_service_test.dart
---
# backend.WatchReadService

Module: [[backend.watch (module)]]
Rules: [[04-application-layer-cqrs#Read, write and state services]]

## Kind

read

## Operations

- `getById(GetWatchQuery)`
- `list(ListWatchesQuery)`

`WatchReadServiceImpl` delegates to the handlers. It has no framework dependencies.

## Relations

- Groups [[backend.GetWatchQuery]] and [[backend.ListWatchesQuery]]
- Provided to routes by the composition root
- Used by [[backend.WatchesRoute]]
