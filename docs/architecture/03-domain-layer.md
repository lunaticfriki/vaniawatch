# Domain Layer (`core`)

The domain is the core of the system. Everything depends on it, and it depends on nothing beyond the Dart SDK's pure libraries (`dart:core`, `dart:math`, `dart:collection`, `dart:async`).

## What belongs here

- Entities and aggregates
- Value objects
- Domain services: logic that spans aggregates or doesn't belong to one entity
- Repository ports (`abstract class`)
- Domain errors and warnings
- Domain events, when needed

## What does NOT belong here

- Framework types: widgets, HTTP requests and responses, database rows
- JSON serialization and formatting for display
- Orchestration across repositories (that is the application layer's job)
- Anything that changes because a library changed, rather than because a business rule changed

## Folder structure

Each module is split by concept:

```
core/lib/src/
  ordering/
    entities/
      order_entity.dart
    value_objects/
      order_id_value_object.dart
      order_status_value_object.dart
    repositories/
      order_repository.dart
    services/
      pricing_policy_service.dart
    errors/
      order_not_found_error.dart
  shared/
    errors/
      domain_error.dart
      domain_warning.dart
```

Add a folder only when the module needs it.

## No primitives in the domain

If a concept has meaning in the ubiquitous language, such as an id, an email, a price, a title or a date range, it MUST be a value object.
A raw `String`, `int`, `double` or `bool` in an entity field, a factory parameter or a port signature is a missing value object.

Primitives are allowed only in these places:

- Inside a value object, as its wrapped `value`.
- At the boundaries, in commands, queries, read models and JSON. Handlers and mappers convert primitives into value objects.
- For a closed set with no validation logic. Use a Dart `enum` for that.

Rule of thumb: if you would validate the same format or range in more than one place, it is a value object you haven't extracted yet.

## Private constructors and named factories

Entities, aggregates and value objects MUST NOT expose a public generative constructor. Every one has a private constructor `ClassName._(...)`, and construction goes through factories:

| Factory | Purpose |
|---|---|
| `create(...)` | Validates input and returns a valid instance. Throws a `DomainError` on invalid input. |
| `empty()` | A neutral "nothing yet" instance, used as an initial state or null object. Add it only when the domain genuinely has an empty state. |
| `restore(...)` | Rebuilds an existing instance from already-valid value objects. It is used by ACL mappers when reading persisted data. It does not generate ids or emit events. |
| Domain-named factories | `OrderId.generate()`, `OrderStatus.draft()`, `Money.zero()` and similar. |

Fields fixed at construction are `final` and public. Fields that change through behavior methods are private, with a getter, so a caller can never bypass the method that guards the invariant.

### Value object

```dart
final class OrderId {
  const OrderId._(this.value);

  factory OrderId.create(String value) {
    if (value.trim().isEmpty) {
      throw InvalidOrderIdError(value);
    }
    return OrderId._(value);
  }

  factory OrderId.empty() => const OrderId._('');

  final String value;

  bool get isEmpty => value.isEmpty;

  @override
  bool operator ==(Object other) => other is OrderId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

final class InvalidOrderIdError extends DomainError {
  InvalidOrderIdError(String value) : super('"$value" is not a valid order id');
}
```

- Value objects are immutable. A "mutation" returns a new instance.
- Equality is structural: override `==` and `hashCode`.
- A value object's own validation error lives in the same file as the value object.

### Entity / aggregate root

```dart
final class Order {
  Order._({
    required this.id,
    required this.customerId,
    required List<OrderLine> lines,
    required OrderStatus status,
  })  : _lines = lines,
        _status = status;

  factory Order.create({required OrderId id, required CustomerId customerId}) =>
      Order._(id: id, customerId: customerId, lines: const [], status: OrderStatus.draft());

  factory Order.restore({
    required OrderId id,
    required CustomerId customerId,
    required List<OrderLine> lines,
    required OrderStatus status,
  }) =>
      Order._(id: id, customerId: customerId, lines: lines, status: status);

  factory Order.empty() => Order._(
        id: OrderId.empty(),
        customerId: CustomerId.empty(),
        lines: const [],
        status: OrderStatus.draft(),
      );

  final OrderId id;
  final CustomerId customerId;
  List<OrderLine> _lines;
  OrderStatus _status;

  List<OrderLine> get lines => List.unmodifiable(_lines);
  OrderStatus get status => _status;

  void addLine(OrderLine line) {
    if (_status.isConfirmed) {
      throw OrderAlreadyConfirmedError(id);
    }
    _lines = [..._lines, line];
  }

  void confirm() {
    _status = _status.confirm();
  }

  @override
  bool operator ==(Object other) => other is Order && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
```

- **Entity:** has an identity that persists across state changes. Equality is by identity.
- **Value object:** has no identity. Equality is structural, and it is immutable.
- **Aggregate:** a consistency boundary with one root. Code outside the aggregate references only the root, and only the root exposes behavior that touches the whole cluster's invariants.

## Domain services

When behavior spans aggregates or doesn't belong to one entity, put it in a domain service. A domain service is still pure, with no ports or I/O.

```dart
final class PricingPolicyService {
  const PricingPolicyService();

  Money discountFor(Order order, Customer customer) =>
      customer.isLoyal && order.total.isAbove(Money.create(100))
          ? order.total.percentageOff(10)
          : order.total;
}
```

## Repository ports

The domain declares what it needs persisted or fetched, as an `abstract class`. Infrastructure `implements` it.

```dart
abstract class OrderRepository {
  Future<Order?> findById(OrderId id);
  Future<List<Order>> findByCustomer(CustomerId customerId);
  Future<void> save(Order order);
}
```

Port signatures use value objects and entities, never primitives.

## Domain errors and warnings

The base types live in `core/lib/src/shared/errors/`:

```dart
abstract class DomainError implements Exception {
  const DomainError(this.message);

  final String message;

  @override
  String toString() => message;
}

abstract class DomainWarning implements Exception {
  const DomainWarning(this.message);

  final String message;

  @override
  String toString() => message;
}
```

- A **`DomainError`** stops the current operation: an invalid value object, a "not found" outcome, a broken invariant.
- A **`DomainWarning`** is worth surfacing but stops nothing, for example a fallback to cached data.
- **Validation errors** live in the value object's own file.
- **Condition and outcome errors** that aren't tied to one value object live in the module's `errors/` folder, for example `OrderNotFoundError` and `OrderAlreadyConfirmedError`.
- Error types belong to the domain even when an application handler is what detects the condition. "No order with this id exists" is a statement about the domain.
- Never throw a generic `Exception` or `StateError` for a business condition.
