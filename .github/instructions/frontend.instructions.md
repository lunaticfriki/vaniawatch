---
applyTo: "frontend/**"
---

# frontend: Flutter app

- Follow `docs/architecture/06-frontend-flutter.md`.
- Each module has `lib/modules/<module>/{application,infrastructure,presentation}`. Domain types come from `package:core/core.dart` only.
- The state service is a Cubit (Bloc only for event transformers). Cubits depend only on read and write services.
- Pages own the `BlocProvider`/`BlocBuilder`. Views are pure widgets. Every page that loads data has a skeleton.
- Wire dependencies in `lib/composition_root.dart` through `MultiRepositoryProvider`.
- Write the tests first: `bloc_test` for Cubits, `mocktail` for ports and services, Object Mothers for fixtures.
- Before coding, read the vault notes for this package (`docs/codebase/`). After coding, update them. See `docs/development/05-docs-vault.md`.
