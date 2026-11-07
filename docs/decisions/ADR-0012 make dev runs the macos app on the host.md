---
type: decision
status: accepted
date: 2026-11-07
---
# ADR-0012 make dev runs the macos app on the host

Index: [[decisions]]

## Context

One command should start the database, the backend and the app together. The database and the API already run in Docker ([[ADR-0009 dockerized dev server restarts on change]]). The app we work on day to day is the macOS desktop app. A macOS app cannot run in a Linux container, and a dockerized Flutter web server was tried and dropped for that reason.

## Decision

`make dev` runs `make backend-dev` first, so Postgres and the API dev server are up and `/health` answers. Then it runs `flutter run -d macos` on the host, in the foreground of the same terminal. It passes `API_URL` (from `API_PORT`) and `USER_ID` (from `APP_USER_ID`, defaulting to the seeded collector) as `--dart-define` ([[frontend.ApiConfig]]).

## Consequences

- `make dev` is the whole local setup, apart from `make seed`.
- The terminal is Flutter's: `r` hot reloads, `R` restarts, `q` quits the app. Quitting leaves Postgres and the API running. `make backend-stop` or `make down` stops them.
- Flutter, Xcode and the macOS toolchain are needed on the host.
- The web build is still available by hand with `flutter run -d chrome`.

## Related

[[06-local-environment]], [[ADR-0009 dockerized dev server restarts on change]], [[ADR-0011 frontend app shell routing and api access]], [[frontend]]
