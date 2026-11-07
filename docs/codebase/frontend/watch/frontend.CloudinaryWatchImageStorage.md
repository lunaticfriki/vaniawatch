---
type: adapter
package: frontend
module: watch
status: implemented
source:
  - frontend/lib/modules/watch/infrastructure/cloudinary_config.dart
  - frontend/lib/modules/watch/infrastructure/cloudinary_watch_image_storage.dart
  - frontend/lib/modules/watch/infrastructure/unavailable_watch_image_storage.dart
tests:
  - frontend/test/modules/watch/infrastructure/cloudinary_config_test.dart
  - frontend/test/modules/watch/infrastructure/cloudinary_watch_image_storage_test.dart
  - frontend/test/modules/watch/infrastructure/unavailable_watch_image_storage_test.dart
---
# frontend.CloudinaryWatchImageStorage

Module: [[frontend.watch (module)]]
Rules: [[05-infrastructure-layer#Swappable implementations]]

## Purpose

Uploads watch photos to Cloudinary. See [[ADR-0013 watch images upload to cloudinary from the app]].

## Implements

[[frontend.WatchImageStorage]]

## Talks to

`POST https://api.cloudinary.com/v1_1/{cloudName}/image/upload`, an unsigned multipart upload with the `file` and the `upload_preset`. It reads `secure_url` from the answer and turns it into a [[core.WatchImageUrl]]. A non-200 status, a client error or an answer without `secure_url` becomes `WatchImageUploadFailedException`.

## Configuration

`CloudinaryConfig.fromEnvironment()` reads `CLOUDINARY_CLOUD_NAME` and `CLOUDINARY_UPLOAD_PRESET` from `--dart-define`. When either is blank, `isConfigured` is false and the composition root uses `UnavailableWatchImageStorage` instead: `isAvailable` is false and `upload` always throws.

## Relations

- Built in `frontend/lib/composition_root.dart`
