---
title: Project Rules
tags:
  - architecture
  - policy
---

# Project Rules

These rules specialize the shared architecture standards for Vaniawatch.

## Domain

- `core/` is the single source of truth for domain concepts and is shared by
  backend and frontend consumers.
- Domain code has no dependency on Flutter, Dart Frog, HTTP, persistence,
  serialization, or any third-party package.
- Entities and value objects have private constructors and validating
  factories. Use typed domain errors for invalid invariants.
- Meaningful concepts such as watch IDs, user IDs, brand, model, and email
  are value objects, not unvalidated primitives in domain APIs.
- Entity equality is by identity; value object equality is structural.
- Domain entities MUST expose `empty()` when they have a meaningful neutral
  placeholder state. `User.empty()` and `Watch.empty()` are the canonical
  examples.
- Empty entity/value-object sentinels are transient placeholders only. They
  MUST NOT be persisted or treated as authenticated identity or an owned
  watch. Use validated `create(...)` factories for actual domain data.

## Privacy And Ownership

- Each `Watch` has exactly one `ownerId`.
- Repository reads are scoped by owner: lookup takes both watch ID and owner
  ID; collection listing takes owner ID.
- A future adapter must enforce ownership in its query, not load globally and
  rely only on the UI to filter.
- User authentication and authorization are application/infrastructure
  concerns. The domain models identity and ownership but never stores
  credentials or tokens.
- Making collections public, allowing cross-user access, or bypassing owner
  checks is prohibited.

## Layers And Stack

- The only current layer is the domain in `core/`.
- Future backend: Dart Frog, with transport and persistence in backend
  adapters, outside `core/`.
- Future frontend: Flutter; presentation depends inward through application
  services and must not call infrastructure directly.
- Firebase is prohibited. The backend is in this repository and will own
  persistence adapters when that phase is requested.
- Do not introduce application, infrastructure, presentation, database, or
  deployment scaffolding in the domain-only phase.

## Tests And Documentation

- Co-locate domain tests under the relevant `__tests__/` directory.
- Every domain entity MUST have its own Object Mother in the entity's
  co-located `__tests__/` directory (for example,
  `entities/__tests__/watch.mother.dart`).
- Entity tests MUST use that entity's Object Mother to create valid instances,
  then assert its identity, invariants, and behavior. Test invalid factory
  inputs directly when the input itself is the subject of the test.
- Object Mothers MUST return valid domain objects by default and MUST compose
  other mothers instead of duplicating their fixture construction.
- Value objects reused as fixtures across tests SHOULD have their own
  co-located Object Mothers.
- Domain tests use real domain objects and need no mocks.
- Run `dart analyze core` and, from `core/`,
  `dart run test catalog/entities/__tests__/watch.entity_test.dart
  auth/value_objects/__tests__/email_address.value_object_test.dart
  auth/entities/__tests__/user.entity_test.dart` for domain changes.
- Run the change harness before a change. Do not persist action logs; report
  the completed change and validation results to the user in the conversation.
- Install the repository's commit and pre-push hooks with
  `sh scripts/install-hooks.sh`; the workflow is documented in
  [[../git-workflow]].
- Keep this documentation in Obsidian-compatible Markdown with wikilinks and
  Mermaid diagrams. `docs/` is the intended vault root.