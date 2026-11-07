---
type: port
package: frontend
module: watch
status: implemented
source:
  - frontend/lib/modules/watch/application/watch_image_picker.dart
  - frontend/lib/modules/watch/infrastructure/file_selector_watch_image_picker.dart
tests:
  - frontend/test/modules/watch/infrastructure/file_selector_watch_image_picker_test.dart
---
# frontend.WatchImagePicker

Module: [[frontend.watch (module)]]
Rules: [[05-infrastructure-layer#Swappable implementations]]

## Purpose

Lets the user choose a photo from their computer.

## Operations

- `pick()`: returns a `WatchImage` ([[frontend.WatchImageStorage]]), or `null` when the user cancels.

## Adapters

- `FileSelectorWatchImagePicker`: opens the system file dialog with `package:file_selector`, limited to JPEG, PNG, WebP, GIF and HEIC. On macOS this needs the `files.user-selected.read-only` entitlement.

## Relations

- Read by [[frontend.AddWatchPage]], which hands the picked image to [[frontend.AddWatchCubit]]
