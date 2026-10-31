---
type: module
package: backend
module: shared
status: implemented
---
# backend.shared (module)

Package: [[backend]]

## Purpose

Cross-cutting backend plumbing: the clock, the database, migrations, HTTP error mapping, request identity and JSON parsing.

## Concepts

### Application

- [[backend.ClockService]]

### Infrastructure

- [[backend.PostgresDatabase]], [[backend.PostgresMigrator]]

### Presentation (HTTP)

- [[backend.ErrorMiddleware]], [[backend.RequestUser]], [[backend.JsonRequest]], [[backend.HealthRoute]]
