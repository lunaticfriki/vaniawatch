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
| `make backend-dev` | **Day-to-day development.** Starts Postgres if it is not up, then the API dev server if it is not up. Both run in Docker. It waits for `/health` and prints the URLs. Running it again is safe: it only starts what is missing. It stops the production-like `api` container first if that one holds the port. |
| `make backend-logs` | Follows the API logs (dev or production-like). |
| `make backend-stop` | Stops the API and keeps Postgres running. |
| `make up` | Builds the production-like image (AOT, `scratch`) and starts it with Postgres. Use it to check the real container. It stops the dev server first. |
| `make down` | Stops every container. The data is kept in the `db-data` volume. |
| `make db` | Starts only Postgres. |
| `make db-shell` | Opens `psql` on the local database. |
| `make db-reset` | Stops everything and **deletes** the database volume. |
| `make test back` | Runs the unit tests on the host. The integration tests are skipped. |
| `make test-integration` | Starts Postgres and runs the backend integration tests against `vaniawatch_test`. |

### How the dev server reloads

The `api-dev` service (`backend/Dockerfile.dev`) mounts `core/` and `backend/` from your machine. Its entrypoint (`backend/docker/dev/entrypoint.sh`) fingerprints `backend/routes`, `backend/lib`, `backend/main.dart`, `core/lib` and both pubspecs every second, and restarts `dart_frog dev` when anything changes. A change shows up in about 4 seconds. Watch it with `make backend-logs`.

Dart Frog's own hot reload is not used. See [[ADR-0009 dockerized dev server restarts on change]].

The schema is migrated automatically when the API starts. See [[backend.PostgresMigrator]].

## Trying the API

The easiest way is **Swagger UI** at `http://localhost:8080/docs`. Click **Authorize**, enter any UUID as the `X-User-Id`, and try every endpoint from the browser. The raw OpenAPI document is at `http://localhost:8080/openapi`.

With curl:

Until login exists, identify yourself with any UUID in `X-User-Id`. See [[ADR-0007 temporary user identification and private collections]].

```sh
U=5f0c7c2e-1d3a-4b6e-9f2a-3c4d5e6f7a8b
curl -X POST localhost:8080/watches -H "x-user-id: $U" \
  -d '{"name":"Speedmaster","brand":"Omega","type":"analog","category":"mechanical","complications":["chronograph"]}'
curl localhost:8080/watches -H "x-user-id: $U"
```

[[backend.WatchesRoute]] documents every endpoint.
