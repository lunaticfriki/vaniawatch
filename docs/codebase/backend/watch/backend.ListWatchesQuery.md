---
type: query
package: backend
module: watch
status: implemented
source:
  - backend/lib/modules/watch/application/query/list_watches_query.dart
  - backend/lib/modules/watch/application/query/list_watches_query_handler.dart
tests:
  - backend/test/modules/watch/application/query/list_watches_query_handler_test.dart
---
# backend.ListWatchesQuery

Module: [[backend.watch (module)]]
Rules: [[04-application-layer-cqrs#Commands and queries, no use cases]]

## Parameters

`ownerId`

## Returns

A list of [[backend.WatchReadModel]], newest first, in the order the repository returns. It is empty when the user has no watches.

## Errors

`InvalidUserIdError` for a malformed owner id.

## Relations

- Reads [[core.WatchRepository]] (`findByOwner`)
- Exposed by [[backend.WatchReadService]]
