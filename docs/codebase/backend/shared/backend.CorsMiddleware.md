---
type: component
package: backend
module: shared
status: implemented
source:
  - backend/lib/shared/http/cors_middleware.dart
tests:
  - backend/test/shared/http/cors_middleware_test.dart
---
# backend.CorsMiddleware

Module: [[backend.shared (module)]]
Rules: [[07-backend-frog]]

## Purpose

Lets the Flutter web app call the API from another origin. It adds `Access-Control-Allow-Origin: *`, the allowed methods and the `Content-Type` and `X-User-Id` headers to every response. It answers a preflight `OPTIONS` with `204` without reaching the routes. The origin is open because the API uses no cookies, and identity only comes from `X-User-Id`. See [[ADR-0011 frontend app shell routing and api access]].

## Relations

- Applied in `backend/routes/_middleware.dart`, outside [[backend.ErrorMiddleware]]
