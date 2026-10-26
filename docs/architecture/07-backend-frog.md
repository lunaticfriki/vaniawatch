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

## Middleware

- `routes/_middleware.dart` installs, in order, the **error middleware** and the **composition root** provider.
- **Error middleware** (`backend/lib/shared/http/error_middleware.dart`) is the single place that maps domain errors to HTTP responses:
  - `*NotFoundError` → `404`
  - validation errors (invalid value objects) → `400` or `422`
  - invariant violations → `409`
  - any other `DomainError` → `400`
  - anything unexpected → `500`, logged, with no internal details in the body
- **Composition root** (`backend/lib/composition_root.dart`) builds repositories, handlers and services once, and exposes the read and write services with `provider<T>`. Routes never see a repository.

## No state service

The backend is stateless per request, so there is no state service. Routes depend directly on `<Concept>ReadService` and `<Concept>WriteService`.

## Folder structure

```
backend/
  routes/
    _middleware.dart
    orders/
      [id].dart
      [id]/
        confirm.dart
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
      http/
        error_middleware.dart
```

## What the backend MUST NOT do

- Declare domain types. Those go in `core`.
- Put business rules in routes, middleware or request/response mappers.
- Return domain entities as JSON directly. Responses go through a presentation response mapper.
- Leak internal error details or stack traces in a response.
