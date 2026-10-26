---
applyTo: "core/**"
---

# core: domain package

- Pure Dart only. Never import `package:flutter`, `dart:ui`, `dart:io`, `dart:html`, `dart:js_interop`, `package:dart_frog` or any I/O package.
- This package holds only domain code: entities, value objects, repository ports, domain services and domain errors. Follow `docs/architecture/03-domain-layer.md`.
- Use a private constructor plus `create` / `empty` / `restore` factories. Use value objects instead of primitives.
- Export the public API from `lib/core.dart`. Object Mothers go in `lib/src/testing/` and are exported only from `lib/testing.dart`.
- Write the tests first, under `test/` mirroring `lib/src/`, with no mocks.
- Before coding, read the vault notes for this package (`docs/codebase/`). After coding, update them. See `docs/development/05-docs-vault.md`.
