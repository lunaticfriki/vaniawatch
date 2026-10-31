---
type: adapter
package: backend
module: watch
status: implemented
source:
  - backend/lib/modules/watch/infrastructure/postgres_watch_repository.dart
tests:
  - backend/test/modules/watch/infrastructure/postgres_watch_repository_test.dart
---
# backend.PostgresWatchRepository

Module: [[backend.watch (module)]]
Rules: [[05-infrastructure-layer#Swappable implementations]]

## Implements

[[core.WatchRepository]]

## Talks to

Postgres, through a `postgres` `Session` (the pool from [[backend.PostgresDatabase]]), using the `watches` table from [[backend.PostgresMigrator]].

- `save` is an upsert (`ON CONFLICT (id) DO UPDATE`). `owner_id` and `created_at` are never overwritten.
- `findByOwner` orders by `created_at DESC, id`.
- Its tests are integration tests, tagged `integration`: run them with `make test-integration`.

## Relations

- Maps rows with [[backend.WatchMapper]]
- Wired in `backend/lib/composition_root.dart` (see [[backend]])
