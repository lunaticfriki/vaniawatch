---
type: route
package: backend
module: shared
status: implemented
source:
  - backend/routes/openapi.dart
  - backend/routes/docs.dart
  - backend/lib/shared/http/swagger_ui_page.dart
tests:
  - backend/test/routes/openapi_test.dart
  - backend/test/routes/docs_test.dart
  - backend/test/routes/openapi_contract_test.dart
---
# backend.ApiDocsRoute

Module: [[backend.shared (module)]]
Rules: [[07-backend-frog#API documentation]]

## Endpoint

| Method | Path | Success | Errors |
|---|---|---|---|
| GET | `/openapi` | 200, the OpenAPI 3.1 document as JSON | 405 |
| GET | `/docs` | 200, the Swagger UI page | 405 |

Neither needs `X-User-Id`.

## Request / response

- `SwaggerUiPage` renders a small HTML page that loads `swagger-ui-dist` (version pinned in `SwaggerUiPage.version`) from jsdelivr and points it at `/openapi`. The browser needs internet access. Authorization is persisted across reloads.
- **Contract test:** `openapi_contract_test.dart` derives every `METHOD /path` from the `routes/` files and fails when the document lists more or fewer operations than the routes implement. Only the documentation endpoints themselves are excluded.

## Relations

- Serves [[backend.OpenApiDocument]]
