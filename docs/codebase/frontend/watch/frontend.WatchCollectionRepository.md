---
type: port
package: frontend
module: watch
status: implemented
source:
  - frontend/lib/modules/watch/application/watch_collection_repository.dart
tests: []
---
# frontend.WatchCollectionRepository

Module: [[frontend.watch (module)]]
Rules: [[05-infrastructure-layer]], [[04-application-layer-cqrs]]

## Purpose

The frontend's read port for the current user's collection. It is declared in the application layer, not in `core`, because the app does not own identity or persistence: the API decides who the user is (from `X-User-Id`) and assigns ids. [[core.WatchRepository]] keeps describing the server side. See [[ADR-0011 frontend app shell routing and api access]].

## Operations

- `findAll()`: returns the current user's watches as [[core.Watch]], newest first.
- Throws `WatchCollectionUnavailableException` when the collection cannot be loaded (network, unexpected status).

## Adapters

- [[frontend.HttpWatchCollectionRepository]]

## Relations

- Used by [[frontend.ListWatchesQuery]]
