---
type: component
package: frontend
module: watch
status: implemented
source:
  - frontend/lib/modules/watch/presentation/watch_card_view.dart
  - frontend/lib/modules/watch/presentation/watch_list_skeleton.dart
  - frontend/lib/modules/watch/presentation/watch_list_failure_view.dart
tests:
  - frontend/test/modules/watch/presentation/watch_card_view_test.dart
  - frontend/test/modules/watch/presentation/watch_list_skeleton_test.dart
  - frontend/test/modules/watch/presentation/watch_list_failure_view_test.dart
---
# frontend.WatchCardView

Module: [[frontend.watch (module)]]
Rules: [[06-frontend-flutter#Widgets: page, view, skeleton]]

## Purpose

The views shared by both watch pages:

- `WatchCardView`: one [[frontend.WatchReadModel]]: name, brand, type, category and tags.
- `WatchListSkeleton`: the loading placeholder, a column of card-shaped boxes.
- `WatchListFailureView`: the failure message and a retry callback.

## Relations

- Used by [[frontend.LatestWatchesPage]] and [[frontend.WatchListPage]]
