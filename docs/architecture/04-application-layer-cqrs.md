# Application Layer & CQRS (`frontend`, `backend`)

The application layer orchestrates. It loads through a port, calls domain behavior and persists through a port. It holds **no business rules**. A conditional on business state, a calculation or an invariant check belongs in `core`.

## Commands and queries, no use cases

There are no "use case" classes. Application code is split by CQRS:

- **Command:** a request to change state. It has exactly one command handler. It returns `Future<void>`, or at most the new identity, and never a read model.
- **Query:** a request to read state. It has exactly one query handler. It returns a read model or a domain entity and never mutates anything.

A class is either a command handler or a query handler, never both.

```dart
final class ConfirmOrderCommand {
  const ConfirmOrderCommand._(this.orderId);

  factory ConfirmOrderCommand.create(String orderId) => ConfirmOrderCommand._(orderId);

  final String orderId;
}

final class ConfirmOrderCommandHandler {
  const ConfirmOrderCommandHandler(this._orders);

  final OrderRepository _orders;

  Future<void> handle(ConfirmOrderCommand command) async {
    final id = OrderId.create(command.orderId);
    final order = await _orders.findById(id);
    if (order == null) {
      throw OrderNotFoundError(id);
    }
    order.confirm();
    await _orders.save(order);
  }
}
```

```dart
final class GetOrderQuery {
  const GetOrderQuery._(this.orderId);

  factory GetOrderQuery.create(String orderId) => GetOrderQuery._(orderId);

  final String orderId;
}

final class GetOrderQueryHandler {
  const GetOrderQueryHandler(this._orders);

  final OrderRepository _orders;

  Future<OrderReadModel> handle(GetOrderQuery query) async {
    final id = OrderId.create(query.orderId);
    final order = await _orders.findById(id);
    if (order == null) {
      throw OrderNotFoundError(id);
    }
    return OrderReadModel.fromDomain(order);
  }
}
```

The invariant check ("can this order be confirmed?") lives on `Order.confirm()`, not in the handler. A handler does three things: load, delegate, persist.

## Read, write and state services

Handlers are grouped behind three distinct contracts per module:

| Service | Groups | Depends on | Lives in |
|---|---|---|---|
| `<Concept>WriteService` | command handlers | ports only | `frontend`, `backend` |
| `<Concept>ReadService` | query handlers | ports only | `frontend`, `backend` |
| `<Concept>StateService` | read + write services | read/write services | `frontend` only, implemented as a Cubit/Bloc |

```dart
abstract class OrderWriteService {
  Future<void> confirm(ConfirmOrderCommand command);
}

final class OrderWriteServiceImpl implements OrderWriteService {
  const OrderWriteServiceImpl(this._confirmOrder);

  final ConfirmOrderCommandHandler _confirmOrder;

  @override
  Future<void> confirm(ConfirmOrderCommand command) => _confirmOrder.handle(command);
}
```

```dart
abstract class OrderReadService {
  Future<OrderReadModel> getById(GetOrderQuery query);
}

final class OrderReadServiceImpl implements OrderReadService {
  const OrderReadServiceImpl(this._getOrder);

  final GetOrderQueryHandler _getOrder;

  @override
  Future<OrderReadModel> getById(GetOrderQuery query) => _getOrder.handle(query);
}
```

Rules:

- Read and write services MUST have **zero framework dependencies**: no `flutter_bloc`, no `dart_frog`, no streams for UI. They are plain classes returning `Future`s, usable from a test, a CLI or any UI.
- A consumer that only reads depends only on the read service. Its constructor shows its blast radius.
- The **state service** is the only place that holds reactive state. In the frontend it is a Cubit or Bloc. See [[06-frontend-flutter]].
- The backend has no state service, because each request is stateless. Frog routes call the read and write services directly. See [[07-backend-frog]].

## No data sources

There is no `DataSource` layer between a repository and its API or database. The repository implementation talks to the client directly. If it needs to combine sources, such as a cache and the network, that composition lives inside the repository implementation, behind the one port.

## Read models are optional

A query handler returns a **read model**: a flat, behavior-free DTO built with a `fromDomain` factory. A query MAY return the domain entity directly instead, but only when that entity is read-only, meaning every field is `final` and it has no behavior methods.

Keep the read model when any of these is true:

- The entity has behavior, such as `order.confirm()`.
- The entity has mutable private state.
- The read shape diverges from the domain shape, for example it aggregates several entities.

## What an application service MUST NOT do

- Contain a business rule.
- Import an infrastructure class. It imports only the port.
- Import presentation: widgets, Cubits or Frog types.
- Reach into another aggregate's internals instead of going through that aggregate's root or repository.
- Call another module's handlers directly. Cross-module calls go through that module's read or write service.
