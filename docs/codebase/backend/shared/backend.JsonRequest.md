---
type: component
package: backend
module: shared
status: implemented
source:
  - backend/lib/shared/http/json_request.dart
tests:
  - backend/test/shared/http/json_request_test.dart
---
# backend.JsonRequest

Module: [[backend.shared (module)]]
Rules: [[07-backend-frog#Routes are thin adapters]]

## Purpose

Safe, typed access to a JSON object body. `read(Request)` and `fromObject` reject non-JSON or non-object bodies. `requiredString`, `optionalString` (null or missing gives `''`) and `stringList` (missing gives `[]`) throw `InvalidRequestError` on a wrong type.

## Relations

- Used by the request mappers in [[backend.WatchesRoute]]
- Errors are mapped by [[backend.ErrorMiddleware]]
