# Infrastructure Layer (`frontend`, `backend`)

Infrastructure implements the ports declared in `core`, and occasionally ports declared in the application layer. It is the only layer that knows about HTTP clients, databases, file systems, local storage, platform channels and third-party SDKs.

## What belongs here

- Repository implementations: `HttpOrderRepository` (frontend), `PostgresOrderRepository` (backend), and `InMemoryOrderRepository` for tests and local development.
- The **Anti-Corruption Layer (ACL)**: mappers between external shapes and domain objects.
- Wrappers around third-party SDKs, so the rest of the code depends on our port and not on the SDK.
- Configuration such as base URLs and connection strings, read from the environment or config. Never hardcode it.

## Folder structure

```
infrastructure/
  http_order_repository.dart
  in_memory_order_repository.dart
  acl/
    order_mapper.dart
```

## Anti-Corruption Layer

An ACL mapper translates one external shape, such as JSON or a database row, into one domain shape, and back. The repository orchestrates the fetch or persist, and the mapper owns the translation.

```dart
abstract final class OrderMapper {
  static Order toDomain(Map<String, dynamic> json) => Order.restore(
        id: OrderId.create(json['id'] as String),
        customerId: CustomerId.create(json['customerId'] as String),
        lines: (json['lines'] as List<dynamic>)
            .cast<Map<String, dynamic>>()
            .map(OrderLineMapper.toDomain)
            .toList(),
        status: OrderStatus.create(json['status'] as String),
      );

  static Map<String, dynamic> toJson(Order order) => {
        'id': order.id.value,
        'customerId': order.customerId.value,
        'lines': order.lines.map(OrderLineMapper.toJson).toList(),
        'status': order.status.value,
      };
}
```

- Mappers build domain objects only through the domain's factories: `create`, `restore` and the others. Never bypass validation.
- External field names and formats never leak past the mapper.
- No code generation (`json_serializable`, `freezed`) for domain types. Mapping is explicit.

## Swappable implementations

Because application code depends on the port, infrastructure can provide several implementations behind it: a real one for production and an in-memory one for tests or offline mode. Neither inner layer changes.

```dart
final class InMemoryOrderRepository implements OrderRepository {
  final Map<OrderId, Order> _orders = {};

  @override
  Future<Order?> findById(OrderId id) async => _orders[id];

  @override
  Future<List<Order>> findByCustomer(CustomerId customerId) async =>
      _orders.values.where((order) => order.customerId == customerId).toList();

  @override
  Future<void> save(Order order) async => _orders[order.id] = order;
}
```

## Composition root

There is one place per app that instantiates adapters and injects them into handlers and services:

- **Frontend:** `frontend/lib/composition_root.dart`, exposed to the widget tree through `MultiRepositoryProvider`.
- **Backend:** `backend/lib/composition_root.dart`, exposed to routes through Frog `provider` middleware.

The composition root is the only file allowed to import infrastructure, application and domain together.

## What infrastructure MUST NOT do

- Contain business rules.
- Be imported by presentation.
- Construct domain objects by any route other than their factories.
- Introduce a `DataSource` abstraction between the repository and its client.
