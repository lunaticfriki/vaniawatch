# Monorepo

```
vaniawatch/
  core/       pure Dart package — the domain
  frontend/   Flutter app
  backend/    Dart Frog server
  docs/       these rules
```

## Dependency direction

```
frontend ──depends on──▶ core ◀──depends on── backend
```

- `frontend` and `backend` depend on `core` through a path dependency:

  ```yaml
  dependencies:
    core:
      path: ../core
  ```

- `core` MUST NOT depend on `frontend` or `backend`.
- `frontend` and `backend` MUST NOT depend on each other. They communicate only over HTTP.

## What lives where

| Layer | `core` | `frontend` | `backend` |
|---|---|---|---|
| Domain | yes, and only here | no | no |
| Application (CQRS) | no | yes | yes |
| Infrastructure | no | yes (HTTP client, local storage) | yes (database, external APIs) |
| Presentation | no | yes (widgets, Cubit/Bloc) | yes (Frog routes, request/response mapping) |

- Every entity, value object, repository port, domain error and domain service lives in `core`.
- `frontend` and `backend` MUST NOT declare domain types of their own. When an app needs a new business concept, add it to `core` first, with tests.
- A concept that only matters to the UI (scroll position, form draft state) or to HTTP (a request body shape) is not domain. It stays in that app's application or presentation layer.

## core is pure Dart

- It MUST NOT import `package:flutter`, `dart:ui`, `dart:io`, `dart:html`, `dart:js_interop`, `package:dart_frog` or any I/O, network or persistence package.
- Its runtime dependencies are limited to small, pure Dart packages with no I/O. Each one needs a reason, for example `uuid` for identity generation. Prefer zero runtime dependencies.
- Its public API is exported from `core/lib/core.dart`. Implementation files live under `core/lib/src/`.
- Test fixtures (Object Mothers) that other packages need are exported from `core/lib/testing.dart`. See [[02-testing#Object Mothers]].
