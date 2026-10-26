---
applyTo: "backend/**"
---

# backend: Dart Frog server

- Follow `docs/architecture/07-backend-frog.md`.
- `routes/` files are thin adapters: request → command/query → read/write service → response. They contain no business logic and no repository access.
- Each module has `lib/modules/<module>/{application,infrastructure,presentation}`. Domain types come from `package:core/core.dart` only.
- Map domain errors to HTTP status codes only in `lib/shared/http/error_middleware.dart`.
- Wire dependencies in `lib/composition_root.dart` and provide them through `routes/_middleware.dart`.
- Write the tests first: `mocktail` for ports, services and `RequestContext`, and Object Mothers for fixtures.
- Before coding, read the vault notes for this package (`docs/codebase/`). After coding, update them. See `docs/development/05-docs-vault.md`.
