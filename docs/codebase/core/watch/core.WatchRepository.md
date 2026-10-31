---
type: port
package: core
module: watch
status: implemented
source:
  - core/lib/src/watch/repositories/watch_repository.dart
tests: []
---
# core.WatchRepository

Module: [[core.watch (module)]]
Rules: [[03-domain-layer#Repository ports]]

## Purpose

The persistence contract for [[core.Watch]]. The domain says what it needs, and infrastructure decides how.

## Operations

- `findById(WatchId)`: returns `Watch?`.
- `findByOwner(UserId)`: returns all watches of an owner, newest first.
- `save(Watch)`: inserts or updates.
- `delete(WatchId)`

The port does not enforce privacy. The application handlers check `Watch.isOwnedBy` after loading.

## Adapters

- [[backend.PostgresWatchRepository]]

## Relations

- Persists [[core.Watch]]
- Used by every handler in [[backend.watch (module)]]
