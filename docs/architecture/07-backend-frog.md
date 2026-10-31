# Backend: Dart Frog

The backend follows the same layers, the same dependency rule and the same CQRS split. Frog's file-based `routes/` folder is the **presentation layer**: thin HTTP adapters that turn a request into a command or query, call a read or write service, and turn the result into a response.

## Routes are thin adapters

A route handler does exactly four things:

1. Reject unsupported HTTP methods.
2. Parse the request into a command or query, using primitives only.
3. Call the read or write service obtained from `context.read<T>()`.
4. Map the result to a `Response`.

```dart
Future<Response> onRequest(RequestContext context, String id) async {
  return switch (context.request.method) {
    HttpMethod.get => _get(context, id),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _get(RequestContext context, String id) async {
  final order = await context.read<OrderReadService>().getById(GetOrderQuery.create(id));
  return Response.json(body: OrderResponse.fromReadModel(order).toJson());
}
```

- No business logic, no repository access and no domain construction in a route.
- Request parsing and response serialization live in `backend/lib/modules/<module>/presentation/`, for example `OrderResponse` and `ConfirmOrderRequest`. They do not live in the route file.
- Routes do not catch domain errors. The error middleware does.

## Middleware and the entrypoint

- `backend/main.dart` is the Frog custom entrypoint.
  - `init` opens the Postgres pool and runs the migrations.
  - `run` wraps the whole handler in the **composition root** (`backend/lib/composition_root.dart`). The composition root builds the repositories, handlers and services once, and exposes only the read and write services with `provider<T>`. Routes never see a repository.
- `routes/_middleware.dart` installs the **error middleware** for every route.
- Feature folders install their own middleware. `routes/watches/_middleware.dart` installs the request user middleware, so `/health` needs no identity.
- **Error middleware** (`backend/lib/shared/http/error_middleware.dart`) is the single place that maps errors to HTTP responses:

  | Error | Status |
  |---|---|
  | `InvalidRequestError` (malformed JSON, missing or wrong-typed fields) | 400 |
  | any `NotFoundError` (from `core`) | 404 |
  | `InvalidUpdatedAtError` | 409 |
  | any other `DomainError`, which covers validation errors | 400 |
  | anything unexpected | 500, logged to stderr; the body has no internal details |

- A resource owned by another user is reported as **not found** (404), never 403. See [[ADR-0007 temporary user identification and private collections]].
- `PUT` is full replacement: omitted optional fields are cleared.

## No state service

The backend is stateless per request, so there is no state service. Routes depend directly on `<Concept>ReadService` and `<Concept>WriteService`.

## Folder structure

```
backend/
  main.dart
  Dockerfile
  routes/
    _middleware.dart
    health.dart
    orders/
      _middleware.dart
      index.dart
      [id].dart
  lib/
    composition_root.dart
    modules/
      ordering/
        application/
        infrastructure/
        presentation/
          order_response.dart
          confirm_order_request.dart
    shared/
      application/
        clock_service.dart
      infrastructure/
        system_clock_service.dart
        database/
      http/
        error_middleware.dart
        json_request.dart
        request_user_middleware.dart
```

[[backend]] shows the real tree, and [[06-local-environment]] covers how to run it.

## What the backend MUST NOT do

- Declare domain types. Those go in `core`.
- Put business rules in routes, middleware or request/response mappers.
- Return domain entities as JSON directly. Responses go through a presentation response mapper.
- Leak internal error details or stack traces in a response.
