---
type: decision
status: accepted
date: 2026-11-06
---
# ADR-0010 local seed goes through the write service

Index: [[decisions]]

## Context

Local development and Swagger need realistic data without creating every watch by hand. A SQL dump would skip the domain rules and break silently whenever the schema or an invariant changes.

## Decision

- The seed is a Dart script (`backend/bin/seed.dart`, run with `make seed`). It connects with the same `DatabaseConfig`, runs [[backend.PostgresMigrator]], and builds the services through the composition root's `watchServices`.
- [[backend.WatchSeeder]] creates every watch through [[backend.WatchWriteService]], so each one passes `core`'s rules.
- The data lives in [[backend.WatchSeedCatalog]], with fixed demo user IDs. The seed first deletes the demo users' watches, so running it again is safe and other users' data stays untouched.

## Consequences

- Seeding needs Dart on the host and Postgres up (`make seed` starts it).
- The seed script is not part of the server image, because `dart_frog build` only compiles `main.dart` and the routes.
- A new module adds its own seeder and catalog, and `bin/seed.dart` calls them.

## Related

[[06-local-environment]], [[backend]], [[ADR-0007 temporary user identification and private collections]]
