# Code Style

## No comments

Source code contains **no comments of any kind**: no `//`, no `///` dartdoc, no `/* */`, no `TODO` or `FIXME`, and no commented-out code.

- If code needs a comment to be understood, rename or restructure it. Extract a well-named method, value object or variable.
- Missing work is tracked in issues, not in `TODO`s.
- The only exception is an analyzer directive (`// ignore: rule_name`) when there is genuinely no other way. Prefer fixing the code.
- This applies to `lib/`, `test/`, `routes/` and generated scaffolding we keep. Strip scaffold comments when creating files.

## Dart idioms

- Use `final class` by default. Use `sealed class` for closed hierarchies such as Cubit states, Bloc events and result types. Use `abstract class` for contracts (ports and services). Use `abstract final class` for static-only holders such as mappers and Mothers.
- Use private constructors (`ClassName._`) plus named factories (`create`, `empty`, `restore`, …) for entities, value objects, read models, commands and queries.
- Constructor injection is the only kind of injection. These classes take their dependencies through a regular `const` constructor where possible: services, handlers, repositories, Cubits, Blocs and mappers with dependencies. Widgets, Cubit states and Bloc events also keep normal constructors, as Flutter requires.
- Implementations `implements` their `abstract class` contract.
- Prefer `final` locals. Never use `var` for something that isn't reassigned. Avoid `dynamic` outside ACL mappers.
- Use exhaustive `switch` expressions over `sealed` types instead of `if`/`is` chains.
- Use no `!` null assertions in production code. Model absence explicitly with `empty()` or a nullable return from a port.
- Use `package:` imports, not relative imports.
- Keep methods small and give each class a single reason to change.

## Formatting and analysis

- Format with `dart format .` and leave the result untouched.
- `dart analyze` (or `flutter analyze`) MUST report zero issues.
- Lints:
  - `core` and `backend` use `package:lints/recommended.yaml`.
  - `frontend` uses `package:flutter_lints/flutter.yaml`.
  - Stricter rules can be added per package in `analysis_options.yaml` and are then applied repo-wide by agreement.
- No code generation (`build_runner`, `freezed`, `json_serializable`) unless it is explicitly agreed and documented here.

## Naming

- Use the ubiquitous language. Class and method names come from the business vocabulary, the same words used in conversation.
- File and folder naming follows [[08-structure-and-naming]].
- Booleans read as predicates: `isConfirmed`, `hasLines`, `canBeCancelled`.
