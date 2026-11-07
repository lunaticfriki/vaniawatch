---
type: port
package: frontend
module: watch
status: implemented
source:
  - frontend/lib/modules/watch/application/watch_image.dart
  - frontend/lib/modules/watch/application/watch_image_storage.dart
tests:
  - frontend/test/modules/watch/application/watch_image_test.dart
---
# frontend.WatchImageStorage

Module: [[frontend.watch (module)]]
Rules: [[05-infrastructure-layer#Swappable implementations]]

## Purpose

Stores a watch photo somewhere public and returns its URL. It is an application port, not a [[core]] repository: a photo file is a technical payload, and the domain only knows [[core.WatchImageUrl]]. See [[ADR-0013 watch images upload to cloudinary from the app]].

`WatchImage` is the file to store: its bytes and its file name. `create` rejects empty bytes or a blank name with an `ArgumentError`.

## Operations

- `isAvailable`: whether uploads are configured.
- `upload(WatchImage)`: returns a [[core.WatchImageUrl]]. Throws `WatchImageUploadFailedException` when the upload fails or is not configured.

## Adapters

- [[frontend.CloudinaryWatchImageStorage]]
- `UnavailableWatchImageStorage`, used while Cloudinary is not configured

## Relations

- Used by [[frontend.CreateWatchCommand]]
- `WatchImage` comes from [[frontend.WatchImagePicker]]
