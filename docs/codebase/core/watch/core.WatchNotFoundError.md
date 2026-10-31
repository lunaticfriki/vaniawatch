---
type: domain-error
package: core
module: watch
status: implemented
source:
  - core/lib/src/watch/errors/watch_not_found_error.dart
tests:
  - core/test/watch/errors/watch_not_found_error_test.dart
---
# core.WatchNotFoundError

Module: [[core.watch (module)]]
Rules: [[03-domain-layer#Domain errors and warnings]]

## Thrown when

- No watch has the given [[core.WatchId]].
- The watch exists but belongs to another user. Collections are private, so a foreign watch is reported as not found and its existence is not revealed. See [[ADR-0007 temporary user identification and private collections]].

## Surfaced as

- backend HTTP status: 404, through [[backend.ErrorMiddleware]]

## Relations

- Extends [[core.NotFoundError]]
- Thrown by the handlers in [[backend.watch (module)]]
