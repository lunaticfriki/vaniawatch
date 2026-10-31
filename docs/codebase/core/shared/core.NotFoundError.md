---
type: domain-error
package: core
module: shared
status: implemented
source:
  - core/lib/src/shared/errors/not_found_error.dart
tests: []
---
# core.NotFoundError

Module: [[core.shared (module)]]
Rules: [[03-domain-layer#Domain errors and warnings]]

## Purpose

The abstract base for every "this thing does not exist (for you)" outcome. It lets outer layers handle every not-found case at once. The backend maps any `NotFoundError` to HTTP 404 in [[backend.ErrorMiddleware]], with no list of concrete errors.

## Relations

- Extends [[core.DomainError]]
- Extended by [[core.WatchNotFoundError]]
