---
type: mapper
package: backend
module: watch
status: implemented
source:
  - backend/lib/modules/watch/infrastructure/acl/watch_mapper.dart
tests:
  - backend/test/modules/watch/infrastructure/acl/watch_mapper_test.dart
---
# backend.WatchMapper

Module: [[backend.watch (module)]]
Rules: [[05-infrastructure-layer#Anti-Corruption Layer]]

## External shape

A `watches` row: snake_case columns, `uuid` ids read as text, `text[]` tags and complications, a nullable `image_url`, and `timestamptz` timestamps.

## Domain shape

[[core.Watch]], rebuilt through `Watch.restore` and the value object factories. A row that breaks a domain rule throws.

## Relations

- Used by [[backend.PostgresWatchRepository]]
