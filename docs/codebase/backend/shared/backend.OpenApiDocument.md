---
type: component
package: backend
module: shared
status: implemented
source:
  - backend/lib/shared/http/openapi_document.dart
tests:
  - backend/test/shared/http/openapi_document_test.dart
---
# backend.OpenApiDocument

Module: [[backend.shared (module)]]
Rules: [[07-backend-frog#API documentation]]

## Purpose

Builds the OpenAPI 3.1 document from **sections**. Each module contributes one `OpenApiSection` (its paths and schemas), so the documentation is vertically sliced like the code.

The shared parts are:

- the info block
- the `userId` API key security scheme for the `X-User-Id` header, which Swagger UI's Authorize button fills in ([[ADR-0007 temporary user identification and private collections]])
- the `Error` schema
- the reusable `BadRequest`, `Unauthorized`, `NotFound` and `Conflict` responses, which mirror [[backend.ErrorMiddleware]]

`OpenApiRefs` builds `$ref`s and the per-operation `security` requirement.

## Relations

- Sections: [[backend.HealthRoute]] (`HealthOpenApi`), [[backend.WatchesRoute]] (`WatchOpenApi`)
- Assembled by `backend/lib/api_document.dart` (see [[backend]]) and served by [[backend.ApiDocsRoute]]
