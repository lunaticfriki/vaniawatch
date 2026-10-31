# Local Environment

Everything runs from the repo root through `make`. Run `make` on its own for the full list.

## Requirements

- Dart 3.13+ and Flutter
- Docker Desktop, running
- `dart_frog_cli`: `dart pub global activate dart_frog_cli`
- pnpm, for the git hooks: `pnpm install`

## Configuration

Every setting has a default, so no configuration is needed. To change one, copy `.env.example` to `.env`. `.env` is ignored by git, and both `make` and Docker Compose read it.

| Variable | Default | Used by |
|---|---|---|
| `DATABASE_NAME` | `vaniawatch` | db, api, `make dev` |
| `DATABASE_USER` / `DATABASE_PASSWORD` | `vaniawatch` | db, api, `make dev` |
| `DATABASE_PORT` | `5432` | the host port of Postgres |
| `API_PORT` | `8080` | the host port of the API |
| `TEST_DATABASE_NAME` | `vaniawatch_test` | the integration tests |

## Commands

| Command | What it does |
|---|---|
| `make up` | Builds the API image and starts Postgres and the API. It waits until both are healthy. The API is at `http://localhost:8080`. |
| `make down` | Stops the containers. The data is kept in the `db-data` volume. |
| `make logs` | Follows the API logs. |
| `make db` | Starts only Postgres. |
| `make db-shell` | Opens `psql` on the local database. |
| `make db-reset` | Stops everything and **deletes** the database volume. |
| `make dev` | Starts Postgres and runs the API on the host with hot reload (`dart_frog dev`) on port 8080. Run `make down` first if the `api` container is running. |
| `make test back` | Runs the unit tests. The integration tests are skipped. |
| `make test-integration` | Starts Postgres and runs the backend integration tests against `vaniawatch_test`. |

The schema is migrated automatically when the API starts. See [[backend.PostgresMigrator]].

## Trying the API

Until login exists, identify yourself with any UUID in `X-User-Id`. See [[ADR-0007 temporary user identification and private collections]].

```sh
U=5f0c7c2e-1d3a-4b6e-9f2a-3c4d5e6f7a8b
curl -X POST localhost:8080/watches -H "x-user-id: $U" \
  -d '{"name":"Speedmaster","brand":"Omega","type":"analog","category":"mechanical","complications":["chronograph"]}'
curl localhost:8080/watches -H "x-user-id: $U"
```

[[backend.WatchesRoute]] documents every endpoint.
