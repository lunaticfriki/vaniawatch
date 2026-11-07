---
type: service
package: frontend
module: watch
status: implemented
source:
  - frontend/lib/modules/watch/application/watch_write_service.dart
tests:
  - frontend/test/modules/watch/application/watch_write_service_test.dart
---
# frontend.WatchWriteService

Module: [[frontend.watch (module)]]
Rules: [[04-application-layer-cqrs#Read, write and state services]]

## Kind

write

## Operations

- `create(CreateWatchCommand)`: returns the new watch id.
- `acceptsImages`: whether [[frontend.WatchImageStorage]] is configured, so the form can disable the image picker.

## Relations

- Groups [[frontend.CreateWatchCommand]]
- Used by [[frontend.AddWatchCubit]]
- Exposed to the widget tree by `frontend/lib/composition_root.dart`
