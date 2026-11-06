---
type: adapter
package: frontend
module: watch
status: implemented
source:
  - frontend/lib/modules/watch/infrastructure/http_watch_collection_repository.dart
tests:
  - frontend/test/modules/watch/infrastructure/http_watch_collection_repository_test.dart
---
# frontend.HttpWatchCollectionRepository

Module: [[frontend.watch (module)]]
Rules: [[05-infrastructure-layer#Swappable implementations]]

## Purpose

Loads the collection from the backend with `package:http`.

## Implements

[[frontend.WatchCollectionRepository]]

## Talks to

`GET {API_URL}/watches` with the `X-User-Id` header from [[frontend.ApiConfig]] ([[backend.WatchesRoute]]). A non-200 status or a client error becomes `WatchCollectionUnavailableException`. Every item goes through [[frontend.WatchMapper]].

## Relations

- Built in `frontend/lib/composition_root.dart`
