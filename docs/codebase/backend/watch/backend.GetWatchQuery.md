---
type: query
package: backend
module: watch
status: implemented
source:
  - backend/lib/modules/watch/application/query/get_watch_query.dart
  - backend/lib/modules/watch/application/query/get_watch_query_handler.dart
tests:
  - backend/test/modules/watch/application/query/get_watch_query_handler_test.dart
---
# backend.GetWatchQuery

Module: [[backend.watch (module)]]
Rules: [[04-application-layer-cqrs#Commands and queries, no use cases]]

## Parameters

`id`, `ownerId`

## Returns

[[backend.WatchReadModel]]

## Errors

Loads the watch and throws [[core.WatchNotFoundError]] when it is missing **or** not owned by `ownerId`, so foreign watches stay invisible ([[ADR-0007 temporary user identification and private collections]]).

## Relations

- Reads [[core.WatchRepository]]
- Exposed by [[backend.WatchReadService]]
