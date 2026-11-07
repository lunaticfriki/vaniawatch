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

The VaniaWatch Flutter app (web and macOS), on top of [[core]]. For now it shows the current user's collection: the latest five watches on the home page, and all of them on `/watches`. `/add`, reached from the menu and a floating `+` button, adds a watch with an optional photo. On a compact screen the menu sits behind a burger. It reads and writes through the backend API ([[backend.WatchesRoute]]) and uploads photos to Cloudinary ([[ADR-0013 watch images upload to cloudinary from the app]]).

## Entry points

- `frontend/lib/main.dart`: builds [[frontend.ApiConfig]] and `CloudinaryConfig` ([[frontend.CloudinaryWatchImageStorage]]) from `--dart-define` and an `http.Client`, then runs the app inside the composition root.
- `frontend/lib/composition_root.dart`: builds the repositories, handlers and services, and exposes the services (never the repositories) with `MultiRepositoryProvider`, plus the [[frontend.WatchImagePicker]]. It picks Cloudinary for photos when it is configured, and `UnavailableWatchImageStorage` otherwise. It is the only file that imports every layer.
- `frontend/lib/app.dart`: `VaniaWatchApp`, the `MaterialApp.router` and the `go_router` configuration. One `ShellRoute` wraps every page in [[frontend.AppShell]]. See [[ADR-0011 frontend app shell routing and api access]].

| Route | Page |
|---|---|
| `/` | [[frontend.LatestWatchesPage]] |
| `/watches` | [[frontend.WatchListPage]] |
| `/add` | [[frontend.AddWatchPage]] |

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
- `macos/` and `web/` are the `flutter create` scaffolding. The only changes are the macOS `network.client` and `files.user-selected.read-only` entitlements, for the API and for the photo picker.

## Decisions

[[ADR-0011 frontend app shell routing and api access]], [[ADR-0013 watch images upload to cloudinary from the app]]
