---
type: component
package: backend
module: watch
status: implemented
source:
  - backend/lib/modules/watch/application/watch_seed_catalog.dart
tests:
  - backend/test/modules/watch/application/watch_seed_catalog_test.dart
---
# backend.WatchSeedCatalog

Module: [[backend.watch (module)]]
Rules: [[04-application-layer-cqrs]]

## Purpose

The demo data for local development. It holds two fixed demo users (`collectorId` and `newcomerId`) and their watches, as [[backend.CreateWatchCommand]]s. The IDs are fixed so that they can be pasted into Swagger's **Authorize** dialog. A test runs every entry through [[backend.CreateWatchCommand]]'s handler, so the catalog cannot drift from the domain rules.

## Relations

- Seeded by [[backend.WatchSeeder]]
