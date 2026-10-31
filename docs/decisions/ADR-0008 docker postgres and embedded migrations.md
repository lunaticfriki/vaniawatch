---
type: decision
status: accepted
date: 2026-10-31
---
# ADR-0008 docker postgres and embedded migrations

Index: [[decisions]]

## Context

The backend needs Postgres locally, the same way on every machine, plus a way to evolve the schema as collections and users arrive.

## Decision

- **Docker Compose at the repo root** runs `db` (Postgres 17) and `api` (the backend image). An init script also creates `vaniawatch_test` for the integration tests. Every setting has a default, and `.env` (copied from `.env.example`) can override it.
- **Migrations are Dart constants** (`PostgresMigrations.all`), applied in order by [[backend.PostgresMigrator]] at server startup and recorded in `schema_migrations`. Embedding them avoids shipping SQL files into the `scratch` image and keeps one migration path for `make dev`, `make up` and the tests.
- **The image is AOT-compiled** into `scratch`, with the repo root as the build context because the backend depends on `../core`.

## Consequences

- A schema change is a new `PostgresMigration` with the next version. Never edit an applied one.
- Migrations run automatically, so a broken migration stops the server at startup.
- Running several API instances at once would need a migration lock, which is not needed yet.

## Related

[[06-local-environment]], [[backend]]
