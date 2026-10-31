---
type: package
package: backend
status: implemented
source:
  - backend/pubspec.yaml
  - backend/analysis_options.yaml
  - backend/dart_test.yaml
  - backend/main.dart
  - backend/lib/composition_root.dart
  - backend/Dockerfile
  - backend/docker/postgres/01-create-test-database.sql
  - docker-compose.yml
tests:
  - backend/test/architecture/dependency_rule_test.dart
---
# backend

Map: [[codebase]]
Rules: [[07-backend-frog]]

## Purpose

The VaniaWatch HTTP API: a Dart Frog server on top of [[core]], persisting to Postgres. For now it offers CRUD for watches. Collections, user registration and login come later.

## Entry points

- `backend/main.dart`: the Frog custom entrypoint.
  - `init` opens the pool ([[backend.PostgresDatabase]]) and runs [[backend.PostgresMigrator]].
  - `run` wraps every request in the composition root.
- `backend/lib/composition_root.dart`: builds the repositories, handlers and services once, and exposes [[backend.WatchReadService]] and [[backend.WatchWriteService]] to the routes with `provider`. It is the only file that imports every layer.
- `backend/Dockerfile`: a multi-stage build (`dart_frog build`, then `dart compile exe`) into a `scratch` image of about 17 MB. The build context is the repo root, because the backend depends on `../core`.
- `docker-compose.yml` (repo root): `db` (Postgres 17, which also creates `vaniawatch_test`) and `api`. See [[06-local-environment]].

## Modules

- [[backend.watch (module)]]: watch CRUD

## Shared

- [[backend.shared (module)]]: the clock, the database, migrations, error mapping, request identity, JSON parsing and the health check

## Tooling notes

- Lints: `dart_frog_lint/recommended`, with `public_member_api_docs` disabled (it conflicts with the no-comments rule) and `one_member_abstracts` ignored (it conflicts with "abstract classes as contracts").
- Tests tagged `integration` are skipped by default (`dart_test.yaml`) and run with `make test-integration`.
- The arch test (`test/architecture/dependency_rule_test.dart`) enforces the layer rules on `lib/` and `routes/`.

## Decisions

[[ADR-0007 temporary user identification and private collections]], [[ADR-0008 docker postgres and embedded migrations]]
