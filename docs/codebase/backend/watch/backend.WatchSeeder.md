---
type: service
package: backend
module: watch
status: implemented
source:
  - backend/lib/modules/watch/application/watch_seeder.dart
tests:
  - backend/test/modules/watch/application/watch_seeder_test.dart
---
# backend.WatchSeeder

Module: [[backend.watch (module)]]
Rules: [[04-application-layer-cqrs#Read, write and state services]]

## Purpose

Fills the local database with demo watches. For every owner in the seed, it deletes that owner's current watches, then creates the seed through [[backend.WatchWriteService]]. Every seeded watch passes the domain rules, and running it again leaves the same data. Watches of other users are never touched.

## Kind

write

## Operations

- `seed(List<CreateWatchCommand>)`: returns how many watches were created.

## Relations

- Uses [[backend.WatchReadService]] (to find the current watches) and [[backend.WatchWriteService]]
- Seeds [[backend.WatchSeedCatalog]]
- Run by `backend/bin/seed.dart` (`make seed`), see [[06-local-environment]] and [[ADR-0010 local seed goes through the write service]]
