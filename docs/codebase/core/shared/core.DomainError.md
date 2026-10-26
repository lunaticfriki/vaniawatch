---
type: domain-error
package: core
module: shared
status: implemented
source:
  - core/lib/src/shared/errors/domain_error.dart
tests: []
---
# core.DomainError

Module: [[core.shared (module)]]
Rules: [[03-domain-layer#Domain errors and warnings]]

## Purpose

The abstract base of every business failure. It `implements Exception` and carries a `message`. Every `Invalid*Error` in the domain extends it, and the tests assert `isA<DomainError>()` for each one.

## Relations

- Extended by [[core.InvalidUpdatedAtError]] and by every value object validation error
