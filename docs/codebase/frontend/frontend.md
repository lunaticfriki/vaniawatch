---
type: package
package: frontend
status: implemented
source:
  - frontend/pubspec.yaml
  - frontend/analysis_options.yaml
  - frontend/lib/main.dart
  - frontend/lib/app.dart
  - frontend/lib/composition_root.dart
  - frontend/macos/Runner/DebugProfile.entitlements
  - frontend/macos/Runner/Release.entitlements
tests:
  - frontend/test/app_test.dart
  - frontend/test/architecture/dependency_rule_test.dart
---
# frontend

Map: [[codebase]]
Rules: [[06-frontend-flutter]]

## Purpose

The VaniaWatch Flutter app (web and macOS), on top of [[core]]. For now it shows the current user's collection: the latest five watches on the home page, and all of them on `/watches`. It reads from the backend API ([[backend.WatchesRoute]]).

## Entry points

- `frontend/lib/main.dart`: builds [[frontend.ApiConfig]] from `--dart-define` and an `http.Client`, then runs the app inside the composition root.
- `frontend/lib/composition_root.dart`: builds the repositories, handlers and services, and exposes the services (never the repositories) with `MultiRepositoryProvider`. It is the only file that imports every layer.
- `frontend/lib/app.dart`: `VaniaWatchApp`, the `MaterialApp.router` and the `go_router` configuration. One `ShellRoute` wraps every page in [[frontend.AppShell]]. See [[ADR-0011 frontend app shell routing and api access]].

| Route | Page |
|---|---|
| `/` | [[frontend.LatestWatchesPage]] |
| `/watches` | [[frontend.WatchListPage]] |

## Running

See [[06-local-environment#Running the app]]. `make dev` starts the backend in Docker and the macOS app on the host. See [[ADR-0012 make dev runs the macos app on the host]].

## Modules

- [[frontend.watch (module)]]: the user's collection

## Shared

- [[frontend.shared (module)]]: the API configuration and the app layout

## Tooling notes

- Lints: `flutter_lints` plus package imports, single quotes, final locals and trailing commas. `one_member_abstracts` is ignored (it conflicts with "abstract classes as contracts").
- The application layer uses `package:meta` and `package:collection`, never `package:flutter`.
- The arch test (`test/architecture/dependency_rule_test.dart`) enforces the layer rules on `lib/`.
- `macos/` and `web/` are the `flutter create` scaffolding. The only change is the macOS `network.client` entitlement.

## Decisions

[[ADR-0011 frontend app shell routing and api access]]
