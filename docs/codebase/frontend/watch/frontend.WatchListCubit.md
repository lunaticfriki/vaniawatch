---
type: cubit
package: frontend
module: watch
status: implemented
source:
  - frontend/lib/modules/watch/presentation/cubit/watch_list_cubit.dart
  - frontend/lib/modules/watch/presentation/cubit/watch_list_state.dart
tests:
  - frontend/test/modules/watch/presentation/cubit/watch_list_cubit_test.dart
---
# frontend.WatchListCubit

Module: [[frontend.watch (module)]]
Rules: [[06-frontend-flutter#State service (Cubit)]]

## Purpose

The state service of both watch pages. Each page creates its own instance and loads it with its own [[frontend.ListWatchesQuery]].

## States

- `WatchListLoading`
- `WatchListLoaded(watches)`: possibly empty.
- `WatchListFailure`: the collection could not be loaded.

## Actions

- `load(ListWatchesQuery)`: emits loading, then loaded or failure. Calling it again retries.

## Relations

- Uses [[frontend.WatchReadService]]
- Drives [[frontend.LatestWatchesPage]] and [[frontend.WatchListPage]]
