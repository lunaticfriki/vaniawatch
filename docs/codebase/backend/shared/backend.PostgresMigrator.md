---
type: component
package: backend
module: shared
status: implemented
source:
  - backend/lib/shared/infrastructure/database/postgres_migration.dart
  - backend/lib/shared/infrastructure/database/postgres_migrations.dart
  - backend/lib/shared/infrastructure/database/postgres_migrator.dart
tests:
  - backend/test/shared/infrastructure/database/postgres_migrator_test.dart
---
# backend.PostgresMigrator

Module: [[backend.shared (module)]]
Rules: [[05-infrastructure-layer]]

## Purpose

Keeps the schema up to date. It runs at server startup (`init` in `backend/main.dart`). Applied versions are recorded in `schema_migrations`, and each migration runs in its own transaction. Running it again is a no-op.

## Migrations

| Version | Name | Creates |
|---|---|---|
| 1 | `create_watches` | the `watches` table and the `(owner_id, created_at DESC)` index |

To add a migration, append a `PostgresMigration` with the next version to `PostgresMigrations.all`. Never edit an applied migration. See [[ADR-0008 docker postgres and embedded migrations]].

## Relations

- Uses [[backend.PostgresDatabase]]
- Creates the table used by [[backend.PostgresWatchRepository]]
