---
type: service
package: frontend
module: watch
status: implemented
source:
  - frontend/lib/modules/watch/application/watch_read_service.dart
tests:
  - frontend/test/modules/watch/application/watch_read_service_test.dart
---
# frontend.WatchReadService

Module: [[frontend.watch (module)]]
Rules: [[04-application-layer-cqrs#Read, write and state services]]

## Kind

read

## Operations

- `list(ListWatchesQuery)`: returns `List<WatchReadModel>`.

Changes go through [[frontend.WatchWriteService]].

## Relations

- Groups [[frontend.ListWatchesQuery]]
- Used by [[frontend.WatchListCubit]]
- Exposed to the widget tree by `frontend/lib/composition_root.dart`
