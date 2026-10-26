---
type: domain-service
package: core
module: shared
status: implemented
source:
  - core/lib/src/shared/services/uuid_service.dart
tests:
  - core/test/shared/services/uuid_service_test.dart
---
# core.UuidService

Module: [[core.shared (module)]]
Rules: [[03-domain-layer#Domain services]]

## Purpose

Generates and validates UUIDs for identities, so `core` needs no `uuid` package dependency. It is pure apart from randomness: it uses `Random.secure()` from `dart:math`.

## Behavior

- `generate()`: a random UUID v4, in lowercase.
- `isValid(String)`: true for a UUID of versions 1 to 8 with the RFC variant, in any case.

## Relations

- Used by [[core.UserId]] and [[core.WatchId]]
