---
type: page
package: frontend
module: watch
status: implemented
source:
  - frontend/lib/modules/watch/presentation/latest_watches_page.dart
  - frontend/lib/modules/watch/presentation/latest_watches_view.dart
tests:
  - frontend/test/modules/watch/presentation/latest_watches_page_test.dart
  - frontend/test/modules/watch/presentation/latest_watches_view_test.dart
---
# frontend.LatestWatchesPage

Module: [[frontend.watch (module)]]
Rules: [[06-frontend-flutter#Widgets: page, view, skeleton]]

## Purpose

The home page (`/`). It shows the five newest watches of the collection.

## Branches

- loading: `WatchListSkeleton` ([[frontend.WatchCardView]])
- failure: `WatchListFailureView`, with a retry button
- loaded: `LatestWatchesView`: the cards, an empty message, and a "See all watches" button

## User actions

- Retry after a failure.
- "See all watches" goes to [[frontend.WatchListPage]].

## Relations

- State: [[frontend.WatchListCubit]] with `ListWatchesQuery.latest(5)`
- Routed in `frontend/lib/app.dart`, inside [[frontend.AppShell]]
