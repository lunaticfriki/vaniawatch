# Hexagonal Architecture (Ports & Adapters)

There are four layers and one rule: **dependencies point inward, always.**

```
presentation ──▶ application ──▶ domain
                                   ▲
infrastructure ──implements ports──┘
```

## Layers

### Domain (`core`)

The domain has no outward dependencies. It declares **ports**, such as repository contracts and external-service contracts, as `abstract class`. It says *what* it needs, never *how* that is provided. See [[03-domain-layer]].

### Application (`frontend`, `backend`)

The application layer orchestrates domain objects to run a command or answer a query. It depends only on the domain, and it reaches the outside world only through ports. It holds no business rules. See [[04-application-layer-cqrs]].

### Infrastructure (`frontend`, `backend`)

Infrastructure holds the adapters that implement the ports: repository implementations, HTTP clients, database access and SDK wrappers. It also owns the **Anti-Corruption Layer (ACL)**, which translates external shapes into domain objects and back. See [[05-infrastructure-layer]].

### Presentation (`frontend`, `backend`)

- **Frontend:** pages, views, skeletons and Cubits/Blocs. See [[06-frontend-flutter]].
- **Backend:** Frog routes and request/response mapping. See [[07-backend-frog]].

Presentation depends on the application layer. It MUST NOT import infrastructure.

## Ports and adapters

A **port** is a contract owned by the inner layer that needs the capability. An **adapter** is the concrete implementation of that port, owned by infrastructure.

```dart
abstract class OrderRepository {
  Future<Order?> findById(OrderId id);
  Future<void> save(Order order);
}
```

```dart
final class HttpOrderRepository implements OrderRepository {
  const HttpOrderRepository(this._client);

  final ApiClient _client;

  @override
  Future<Order?> findById(OrderId id) async {
    final json = await _client.get('/orders/${id.value}');
    return json == null ? null : OrderMapper.toDomain(json);
  }

  @override
  Future<void> save(Order order) =>
      _client.put('/orders/${order.id.value}', OrderMapper.toJson(order));
}
```

Presentation never sees `HttpOrderRepository`. It is wired to `OrderRepository` at the composition root.

## The dependency rule

The arch tests enforce these rules (see [[02-testing#Arch tests]]):

- `domain` imports nothing from `application`, `infrastructure` or `presentation`, and nothing framework-specific.
- `application` imports only from `domain` (`package:core`) and its own module's application files.
- `infrastructure` imports from `domain`. It MAY import `application` only for port definitions declared there. It never imports `presentation`.
- `presentation` imports from `application`. It MUST NOT import `infrastructure`.
- The **composition root** is the single place that constructs adapters and injects them into application services. It is the only file allowed to import every layer.

## Why

- The domain can be tested with zero mocks.
- Swapping infrastructure, for example REST to GraphQL or one database for another, never touches domain or application code.
- Swapping the UI or the HTTP framework never touches domain, application or infrastructure.
