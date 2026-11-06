---
type: decision
status: accepted
date: 2026-11-06
---
# ADR-0011 frontend app shell routing and api access

Index: [[decisions]]

## Context

The Flutter app needs to navigate between a home page and a full list with a shared header and footer, to read the watches from the backend, and to identify the user before login exists.

## Decision

- **Routing with `go_router`.** One `ShellRoute` wraps every page in [[frontend.AppShell]]. Routes live in `frontend/lib/app.dart`. The shell views get the location and an `onNavigate` callback, so they stay router-free.
- **An application-level read port.** The frontend reads through [[frontend.WatchCollectionRepository]] (`findAll()` for the current user), not through [[core.WatchRepository]]. The API owns identity and ids, so an HTTP adapter cannot honestly implement `save` or `findById` without an owner. Writes will get their own port when the app needs them.
- **Configuration with `--dart-define`.** [[frontend.ApiConfig]] reads `API_URL` and `USER_ID`, defaulting to the local API and the seeded collector.
- **CORS on the backend.** [[backend.CorsMiddleware]] allows any origin, so `flutter run -d chrome` works against `make backend-dev`. The macOS app has the `network.client` entitlement.
- **One Cubit for both pages.** [[frontend.WatchListCubit]] takes the [[frontend.ListWatchesQuery]] to load. Each page creates its own instance.

## Consequences

- Adding a page means adding a `GoRoute` under the shell.
- When login arrives, `USER_ID` goes away and the adapter sends a token instead. Only infrastructure changes.
- The CORS origin must be narrowed before the API is exposed with cookies or real credentials.

## Related

[[06-frontend-flutter]], [[frontend]], [[ADR-0007 temporary user identification and private collections]]
