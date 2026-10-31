---
type: value-object
package: core
module: watch
status: implemented
source:
  - core/lib/src/watch/value_objects/watch_image_url_value_object.dart
tests:
  - core/test/watch/value_objects/watch_image_url_value_object_test.dart
---
# core.WatchImageUrl

Module: [[core.watch (module)]]
Rules: [[03-domain-layer#Value object]]

## Purpose

Where the watch's photo lives. It is optional.

## Validation

Trimmed, and must be an absolute `http` or `https` URL with a host. Otherwise `InvalidWatchImageUrlError`. A blank value is rejected; use `empty()` for "no image".

## Factories

- `create(String)`
- `empty()`
- `optional(String)`: a blank value gives `empty()`; anything else goes through `create`. Use it for user input where the image is optional.

## Relations

- Part of [[core.Watch]]
- Errors extend [[core.DomainError]]

## Testing

- Mother: `WatchImageUrlMother` (`core/lib/src/testing/watch/watch_image_url_mother.dart`)
