---
type: route
package: backend
module: shared
status: implemented
source:
  - backend/routes/health.dart
  - backend/lib/shared/http/health_openapi.dart
tests:
  - backend/test/routes/health_test.dart
---
# backend.HealthRoute

Module: [[backend.shared (module)]]
Rules: [[07-backend-frog#Routes are thin adapters]]

## Endpoint

| Method | Path | Success | Errors |
|---|---|---|---|
| GET | `/health` | 200 `{"status": "ok"}` | 405 for other methods |

It needs no `X-User-Id`. It is documented by `HealthOpenApi.section` ([[backend.OpenApiDocument]]).

## Relations

- Wrapped by [[backend.ErrorMiddleware]]
