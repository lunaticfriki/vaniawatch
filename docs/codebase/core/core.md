---
type: package
package: core
status: implemented
source:
  - core/pubspec.yaml
  - core/lib/core.dart
  - core/lib/testing.dart
tests: []
---
# core

Map: [[codebase]]
Rules: [[01-monorepo#core is pure Dart]], [[03-domain-layer]]

## Purpose

The domain of VaniaWatch: entities, value objects, repository ports, domain services and domain errors. It is pure Dart with no I/O, and `frontend` and `backend` both depend on it.

## Entry points

- `core/lib/core.dart`: the public domain API, which exports every module.
- `core/lib/testing.dart`: the Object Mothers, imported only from tests. See [[02-testing#Object Mothers]].

## Modules

- [[core.user (module)]]: users who own private watch collections
- [[core.watch (module)]]: the watches in a collection, their repository port and errors

## Shared

- [[core.shared (module)]]: `DomainError`, `NotFoundError`, `InvalidUpdatedAtError`, `CreatedAt`, `UpdatedAt`, `UuidService`

## Public API

Every domain class above is exported from `core/lib/core.dart`. The tests import only `package:core/core.dart` and `package:core/testing.dart`.
