---
type: component
package: backend
module: shared
status: implemented
source:
  - backend/routes/_middleware.dart
  - backend/lib/shared/http/error_middleware.dart
  - backend/lib/shared/http/invalid_request_error.dart
tests:
  - backend/test/shared/http/error_middleware_test.dart
---
# backend.ErrorMiddleware

Module: [[backend.shared (module)]]
Rules: [[07-backend-frog#Middleware and the entrypoint]]

## Purpose

The single place that maps errors to HTTP status codes, installed for every route:

| Error | Status |
|---|---|
| `InvalidRequestError` (bad JSON or missing fields) | 400 |
| [[core.NotFoundError]] | 404 |
| [[core.InvalidUpdatedAtError]] | 409 |
| any other [[core.DomainError]] (validation) | 400 |
| anything else | 500, logged to stderr; the body says only `Internal server error` |

Every error body is `{"error": message}`.

## Relations

- Wraps [[backend.WatchesRoute]] and [[backend.HealthRoute]]
- `InvalidRequestError` is thrown by [[backend.JsonRequest]]
