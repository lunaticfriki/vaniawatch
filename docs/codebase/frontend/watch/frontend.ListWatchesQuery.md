---
type: query
package: frontend
module: watch
status: implemented
source:
  - frontend/lib/modules/watch/application/query/list_watches_query.dart
  - frontend/lib/modules/watch/application/query/list_watches_query_handler.dart
tests:
  - frontend/test/modules/watch/application/query/list_watches_query_handler_test.dart
---
# frontend.ListWatchesQuery

Module: [[frontend.watch (module)]]
Rules: [[04-application-layer-cqrs#Commands and queries, no use cases]]

## Purpose

Lists the current user's watches, newest first.

## Parameters

Built through factories:

- `ListWatchesQuery.all()`: every watch.
- `ListWatchesQuery.latest(count)`: only the newest `count` watches. The home page uses 5.

## Returns

`List<WatchReadModel>` ([[frontend.WatchReadModel]]), in the order of [[frontend.WatchCollectionRepository]].

## Errors

Propagates `WatchCollectionUnavailableException` and any `DomainError` from the mapping.

## Relations

- Grouped by [[frontend.WatchReadService]]
