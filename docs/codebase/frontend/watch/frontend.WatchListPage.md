---
type: page
package: frontend
module: watch
status: implemented
source:
  - frontend/lib/modules/watch/presentation/watch_list_page.dart
  - frontend/lib/modules/watch/presentation/watch_list_view.dart
tests:
  - frontend/test/modules/watch/presentation/watch_list_page_test.dart
  - frontend/test/modules/watch/presentation/watch_list_view_test.dart
---
# frontend.WatchListPage

Module: [[frontend.watch (module)]]
Rules: [[06-frontend-flutter#Widgets: page, view, skeleton]]

## Purpose

The `/watches` page: every watch of the collection, newest first.

## Branches

- loading: `WatchListSkeleton` ([[frontend.WatchCardView]])
- failure: `WatchListFailureView`, with a retry button
- loaded: `WatchListView`: the count, the cards, or an empty message

## User actions

- Retry after a failure.

## Relations

- State: [[frontend.WatchListCubit]] with `ListWatchesQuery.all()`
- Routed in `frontend/lib/app.dart`, inside [[frontend.AppShell]]
