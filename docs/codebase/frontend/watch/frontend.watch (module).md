---
type: module
package: frontend
module: watch
status: implemented
---
# frontend.watch (module)

Package: [[frontend]]

## Purpose

Shows the watches of the current user's private collection: the latest five on the home page, and all of them on `/watches`. It is read-only for now.

## Concepts

### Domain

From core: [[core.Watch]]

### Application

- Port: [[frontend.WatchCollectionRepository]]
- Query: [[frontend.ListWatchesQuery]]
- [[frontend.WatchReadModel]]
- [[frontend.WatchReadService]]

### Infrastructure

- [[frontend.HttpWatchCollectionRepository]], [[frontend.WatchMapper]]

### Presentation

- State service: [[frontend.WatchListCubit]]
- Pages: [[frontend.LatestWatchesPage]] (`/`), [[frontend.WatchListPage]] (`/watches`)
- Shared views: [[frontend.WatchCardView]]

## Depends on

- [[core.watch (module)]]
- [[frontend.shared (module)]]
- The backend API: [[backend.WatchesRoute]]
