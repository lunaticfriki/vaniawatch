---
type: module
package: backend
module: shared
status: implemented
---
# backend.shared (module)

Package: [[backend]]

## Purpose

Cross-cutting backend plumbing: the clock, the database, migrations, HTTP error mapping, request identity, JSON parsing and the OpenAPI/Swagger documentation.

## Concepts

### Application

- [[backend.ClockService]]

### Infrastructure

- [[backend.PostgresDatabase]], [[backend.PostgresMigrator]]

### Presentation (HTTP)

- [[backend.ErrorMiddleware]], [[backend.RequestUser]], [[backend.JsonRequest]], [[backend.HealthRoute]]
- API documentation: [[backend.OpenApiDocument]], [[backend.ApiDocsRoute]]
