---
type: map
---
# decisions

Architecture decision records. Add a new one from the `decision` template whenever a task makes or changes an architectural choice. Never edit an accepted decision: supersede it with a new one.

| ADR | Decision | Status |
|---|---|---|
| [[ADR-0001 core holds only the domain]] | `core` holds only the domain layer. The application layer lives in each app. | accepted |
| [[ADR-0002 tests mirror lib]] | Tests live under `test/`, mirroring `lib/`. Shared Mothers are exported from `core/lib/testing.dart`. | accepted |
| [[ADR-0003 commit menu in prepare-commit-msg]] | The commit menu runs in the `prepare-commit-msg` hook, with commitlint as a backstop. | accepted |
| [[ADR-0004 docs vault is the map of the code]] | The Obsidian vault is read before the code and updated after every task. | accepted |
| [[ADR-0005 entities receive time and reference owners by id]] | Entities receive `CreatedAt` and `UpdatedAt` from outside, timestamps only move forward, and a watch references its owner by `UserId`. | accepted |
| [[ADR-0006 complications are plain strings]] | `Watch.complications` is a plain `List<String>`, a scoped exception to the no-primitives rule. | accepted |
| [[ADR-0007 temporary user identification and private collections]] | Callers identify with `X-User-Id` until login exists; a foreign watch reads as not found. | accepted |
| [[ADR-0008 docker postgres and embedded migrations]] | Postgres and the API run in Docker Compose; schema migrations are embedded in Dart and applied at startup. | accepted |
| [[ADR-0009 dockerized dev server restarts on change]] | `make backend-dev` runs the API in Docker and restarts it on any source change, instead of Dart Frog hot reload. | accepted |
| [[ADR-0010 local seed goes through the write service]] | `make seed` loads demo watches for two fixed users through the write service, and is safe to run again. | accepted |
| [[ADR-0011 frontend app shell routing and api access]] | The app routes with `go_router` inside one shell, reads through an application-level port over HTTP, is configured with `--dart-define`, and the backend allows CORS. | accepted |
| [[ADR-0012 make dev runs the macos app on the host]] | `make dev` starts Postgres and the API in Docker, then `flutter run -d macos` on the host in the foreground. | accepted |
