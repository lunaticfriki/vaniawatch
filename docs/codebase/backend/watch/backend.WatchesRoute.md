---
type: route
package: backend
module: watch
status: implemented
source:
  - backend/routes/watches/_middleware.dart
  - backend/routes/watches/index.dart
  - backend/routes/watches/[id].dart
  - backend/lib/modules/watch/presentation/create_watch_request.dart
  - backend/lib/modules/watch/presentation/update_watch_request.dart
  - backend/lib/modules/watch/presentation/watch_response.dart
tests:
  - backend/test/routes/watches/index_test.dart
  - backend/test/routes/watches/[id]_test.dart
  - backend/test/modules/watch/presentation/create_watch_request_test.dart
  - backend/test/modules/watch/presentation/update_watch_request_test.dart
  - backend/test/modules/watch/presentation/watch_response_test.dart
---
# backend.WatchesRoute

Module: [[backend.watch (module)]]
Rules: [[07-backend-frog#Routes are thin adapters]]

## Endpoint

Every request needs the `X-User-Id` header ([[backend.RequestUser]]), and every operation is scoped to that user.

| Method | Path | Success | Errors |
|---|---|---|---|
| GET | `/watches` | 200, a list of watches | 400 |
| POST | `/watches` | 201, `{"id"}` and a `Location` header | 400 |
| GET | `/watches/{id}` | 200, the watch | 400, 404 |
| PUT | `/watches/{id}` | 204 | 400, 404, 409 |
| DELETE | `/watches/{id}` | 204 | 400, 404 |

Without the header, any of these is a 401. Any other method is a 405.

## Request / response

- `CreateWatchRequest` and `UpdateWatchRequest` turn a [[backend.JsonRequest]] into a command. The required fields are `name`, `brand`, `type` and `category`. `description`, `imageUrl`, `tags` and `complications` default to empty.
- `WatchResponse` serializes a [[backend.WatchReadModel]] to camelCase JSON, without `ownerId`, with ISO-8601 timestamps.

```json
{"name": "Speedmaster", "brand": "Omega", "type": "analog", "category": "mechanical",
 "description": "", "tags": ["chrono"], "complications": ["chronograph"], "imageUrl": "https://..."}
```

## Relations

- Calls [[backend.WatchReadService]] and [[backend.WatchWriteService]]
- Errors are mapped by [[backend.ErrorMiddleware]]
