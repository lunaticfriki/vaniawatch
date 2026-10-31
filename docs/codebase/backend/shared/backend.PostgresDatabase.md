---
type: component
package: backend
module: shared
status: implemented
source:
  - backend/lib/shared/infrastructure/database/database_config.dart
  - backend/lib/shared/infrastructure/database/postgres_database.dart
tests:
  - backend/test/shared/infrastructure/database/database_config_test.dart
---
# backend.PostgresDatabase

Module: [[backend.shared (module)]]
Rules: [[05-infrastructure-layer]]

## Purpose

`DatabaseConfig.fromEnvironment` reads `DATABASE_HOST`, `DATABASE_PORT`, `DATABASE_NAME`, `DATABASE_USER` and `DATABASE_PASSWORD`. Each defaults to the local Docker values (`localhost:5432`, `vaniawatch`). `DatabaseConfig.forTests` switches to `TEST_DATABASE_NAME`, which defaults to `vaniawatch_test`. `PostgresDatabase.connect` opens a connection pool with SSL disabled, for local use.

## Relations

- Opened in `backend/main.dart` (see [[backend]])
- Used by [[backend.PostgresMigrator]] and [[backend.PostgresWatchRepository]]
- Environment: [[06-local-environment]]
