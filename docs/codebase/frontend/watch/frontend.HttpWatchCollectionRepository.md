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

Loads and adds watches through the backend with `package:http`.

## Implements

[[frontend.WatchCollectionRepository]]

## Talks to

Both calls send the `X-User-Id` header from [[frontend.ApiConfig]] ([[backend.WatchesRoute]]), and every body goes through [[frontend.WatchMapper]].

- `findAll`: `GET {API_URL}/watches`, expects 200.
- `add`: `POST {API_URL}/watches` with a JSON body, expects 201 and reads the new `id`.

An unexpected status or a client error becomes `WatchCollectionUnavailableException`.

## Relations

- Built in `frontend/lib/composition_root.dart`
