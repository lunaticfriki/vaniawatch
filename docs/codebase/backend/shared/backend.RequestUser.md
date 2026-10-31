---
type: component
package: backend
module: shared
status: implemented
source:
  - backend/lib/shared/http/request_user.dart
  - backend/lib/shared/http/request_user_middleware.dart
tests:
  - backend/test/shared/http/request_user_middleware_test.dart
---
# backend.RequestUser

Module: [[backend.shared (module)]]
Rules: [[07-backend-frog#Middleware and the entrypoint]]

## Purpose

Identifies who is calling. **This is temporary until login exists.** The middleware reads the `X-User-Id` header, answers 401 when it is missing or blank, and provides a `RequestUser` to the route. The id is validated as a [[core.UserId]] later, in the handlers. It is installed only under `/watches` (`routes/watches/_middleware.dart`). See [[ADR-0007 temporary user identification and private collections]]. When authentication lands, replace this middleware; nothing else changes.

## Relations

- Used by [[backend.WatchesRoute]]
