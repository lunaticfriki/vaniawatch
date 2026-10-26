# VaniaWatch Copilot Instructions

This repo is a monorepo with three packages: `core/` (pure Dart domain), `frontend/` (Flutter) and `backend/` (Dart Frog). The full rules live in `docs/` (start at `docs/README.md`). Read the relevant doc before generating code. When these instructions and `docs/` disagree, `docs/` wins.

## Docs vault: read before, update after

`docs/` is an Obsidian vault containing a map of the code (`docs/codebase/`), with one note per concept, named `<package>.<Name>`.

- **Before generating code:** read `docs/codebase/codebase.md` and follow the wikilinks to the relevant package, module and concept notes. Open only the files listed in their `source` and `tests`.
- **With every code change:** create or update the matching notes, and keep `status`, `source`, `tests` and the relation links accurate. Record architectural decisions in `docs/decisions/`.
- `pnpm docs:check` fails on broken links, missing sources, or Dart files that no note documents.

See `docs/development/05-docs-vault.md`.

## Architecture

- **Hexagonal layers:** `domain` / `application` / `infrastructure` / `presentation`. Dependencies point inward only.
  - Presentation never imports infrastructure.
  - Only `composition_root.dart` imports every layer.
- **Domain:** all domain code lives in `core/`, which is pure Dart. It never imports Flutter, `dart:io`, `dart:ui`, `dart:html`, Dart Frog or any I/O package. `frontend/` and `backend/` never declare domain types.
- **No business logic outside the domain:** no business rules in handlers, services, Cubits, Blocs, widgets, routes, middleware or mappers.
- **CQRS:**
  - One handler per command or query.
  - Handlers are grouped in a `<Concept>WriteService` (commands) and a `<Concept>ReadService` (queries).
  - These services have no framework dependencies.
  - No "use case" classes and no `DataSource` layer.
- **Frontend state:** the frontend's state service is a Cubit (or a Bloc only when event transformers are needed). Cubits call only read and write services, never repositories.
- **Backend routes:** Frog routes are thin adapters. They parse a request into a command or query, call a service and map the result to a response. Domain errors are mapped to HTTP status codes only in the error middleware.

## Domain modeling

- Entities, value objects, read models, commands and queries have a private constructor `ClassName._(...)` plus named factories: `create`, `empty`, `restore` and domain-specific ones.
- No primitives in the domain. Meaningful concepts are value objects with structural equality.
- Ports and services are `abstract class`. Implementations use `implements`.
- Business failures throw a typed `DomainError` or `DomainWarning`, never a generic `Exception`.

## Code

- No comments of any kind: no `//`, no `///`, no `/* */`, no `TODO`, and no commented-out code.
- Use `final class` by default, `sealed class` for states, events and results, and `abstract final class` for static-only holders.
- Use `package:` imports. No `!` null assertions in production code.
- Files are named `<concept>_<kind>.dart`, for example `order_entity.dart`, `order_id_value_object.dart` and `confirm_order_command_handler.dart`.

## Tests

- TDD: every production change comes with tests that drive it.
- Build fixtures through Object Mothers only, not ad-hoc literals.
- Domain tests use no mocks. Application tests mock ports with `mocktail`. Cubits are tested with `bloc_test`.
- Tests mirror `lib/` under `test/`. Each package has an arch test in `test/architecture/`.
