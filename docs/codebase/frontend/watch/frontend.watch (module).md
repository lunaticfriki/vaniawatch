---
type: module
package: frontend
module: watch
status: implemented
---
# frontend.watch (module)

Package: [[frontend]]

## Purpose

The current user's private collection: the latest five watches on the home page, all of them on `/watches`, and a form on `/add` to add one with an optional photo uploaded to Cloudinary.

## Concepts

### Domain

From core: [[core.Watch]]

### Application

- Ports: [[frontend.WatchCollectionRepository]], [[frontend.WatchImageStorage]], [[frontend.WatchImagePicker]]
- Query: [[frontend.ListWatchesQuery]]
- Command: [[frontend.CreateWatchCommand]]
- [[frontend.WatchReadModel]], [[frontend.WatchDraft]]
- [[frontend.WatchReadService]], [[frontend.WatchWriteService]]

### Infrastructure

- [[frontend.HttpWatchCollectionRepository]], [[frontend.WatchMapper]]
- [[frontend.CloudinaryWatchImageStorage]] (and `UnavailableWatchImageStorage`)
- `FileSelectorWatchImagePicker` ([[frontend.WatchImagePicker]])

### Presentation

- State services: [[frontend.WatchListCubit]], [[frontend.AddWatchCubit]]
- Pages: [[frontend.LatestWatchesPage]] (`/`), [[frontend.WatchListPage]] (`/watches`), [[frontend.AddWatchPage]] (`/add`)
- Shared views: [[frontend.WatchCardView]]

## Depends on

- [[core.watch (module)]]
- [[frontend.shared (module)]]
- The backend API: [[backend.WatchesRoute]]
- Cloudinary, for photos: [[ADR-0013 watch images upload to cloudinary from the app]]
