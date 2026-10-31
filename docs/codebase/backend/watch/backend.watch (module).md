---
type: module
package: backend
module: watch
status: implemented
---
# backend.watch (module)

Package: [[backend]]

## Purpose

CRUD for the watches in a user's private collection, over HTTP and Postgres. Collections and other features will come as new commands and queries, or as new modules.

## Concepts

### Domain

From core: [[core.Watch]], [[core.WatchRepository]], [[core.WatchNotFoundError]]

### Application

- Commands: [[backend.CreateWatchCommand]], [[backend.UpdateWatchCommand]], [[backend.DeleteWatchCommand]]
- Queries: [[backend.GetWatchQuery]], [[backend.ListWatchesQuery]]
- [[backend.WatchReadModel]]
- [[backend.WatchReadService]], [[backend.WatchWriteService]]

### Infrastructure

- [[backend.PostgresWatchRepository]], [[backend.WatchMapper]]

### Presentation

- [[backend.WatchesRoute]]

## Depends on

- [[core.watch (module)]]
- [[backend.shared (module)]]
