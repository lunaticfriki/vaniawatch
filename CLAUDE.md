# Vaniawatch Project Instructions

Read [[index]] and [[architecture/README]] before changing project code.

## Current Scope

- The shared, framework-independent Dart domain lives in `core/`.
- `backend/` is reserved for Dart Frog. `frontend/` is reserved for Flutter.
- For this phase, implement domain concepts only; do not scaffold either app.
- A watch belongs to exactly one `UserId`. Every collection query and watch
  lookup must be owner-scoped. Never make the collection public or infer the
  owner from client-supplied watch data.
- Authentication credentials, tokens, database models, HTTP types, Flutter
  types, and Dart Frog types do not belong in `core/`.
- Firebase is not part of this project.

## Architecture Rules

- Follow [[architecture/rules]] and keep dependencies pointing inward.
- Keep domain code pure Dart with no package dependencies.
- Use private constructors and validating factories for entities and value
  objects. Give meaningful concepts value objects instead of raw primitives.
- Keep entity equality identity-based and value object equality structural.
- Provide `empty()` factories for domain entities with a meaningful neutral
  placeholder, including `User` and `Watch`. Empty sentinels are transient
  only and must never be persisted or treated as authenticated/owned data.
- Put tests beside the concept in a co-located `__tests__/` directory. Every
  domain entity must have its own Object Mother there; its tests must use the
  mother for valid instances and assert identity, invariants, and behavior.
  Mothers return valid fixtures and compose other mothers instead of
  repeating object construction inline. Test invalid factory inputs directly.
- Do not add application, infrastructure, or presentation behavior until the
  user asks for that phase.

## Change Gate And Records

- Before a proposed change, run `dart tool/change_harness.dart --action "..."
  --files path/to/file.dart` with the planned action and affected paths.
- A `PROHIBIT` result blocks the change. A `REVIEW` result needs an explicit
  human decision before proceeding.
- After each completed feature or fix, rerun the harness with the actual
  changed paths and `--record`. Preserve the generated note under
  `docs/action-log/`; never rewrite an earlier record.
- Update the Obsidian architecture pages when a boundary or policy changes.