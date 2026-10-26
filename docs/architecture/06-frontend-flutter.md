# Frontend: Flutter + Cubit/Bloc

The frontend follows the same layers, the same dependency rule and the same CQRS split. The **state service is a Cubit**, or a Bloc when that is genuinely needed. The goal is the simplest code that keeps the layering.

## Cubit by default, Bloc when needed

- **Cubit** is the default: plain methods (`load`, `confirm`) that `emit` states.
- **Bloc** only when the screen must react to a *stream* of events and needs event transformers: debounced search, throttling, `restartable` or `droppable` concurrency.
- Use one Cubit/Bloc per screen or feature state. Do not create a god-Cubit for the whole app.

## State service (Cubit)

The Cubit depends on the read and write services. It orchestrates loading, error and loaded states, and contains **zero business logic**. It decides *when* to call a service and *how* to shape UI state, never *whether* a business rule holds.

```dart
sealed class OrderDetailsState {
  const OrderDetailsState();
}

final class OrderDetailsLoading extends OrderDetailsState {
  const OrderDetailsLoading();
}

final class OrderDetailsLoaded extends OrderDetailsState {
  const OrderDetailsLoaded(this.order);

  final OrderReadModel order;
}

final class OrderDetailsFailure extends OrderDetailsState {
  const OrderDetailsFailure(this.message);

  final String message;
}
```

```dart
final class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  OrderDetailsCubit(this._readService, this._writeService, this._errorManager)
      : super(const OrderDetailsLoading());

  final OrderReadService _readService;
  final OrderWriteService _writeService;
  final ErrorManager _errorManager;

  Future<void> load(String orderId) async {
    emit(const OrderDetailsLoading());
    try {
      final order = await _readService.getById(GetOrderQuery.create(orderId));
      emit(OrderDetailsLoaded(order));
    } on OrderNotFoundError catch (error) {
      emit(OrderDetailsFailure(error.message));
    } on DomainError catch (error) {
      emit(OrderDetailsFailure(error.message));
      _errorManager.handle(error);
    }
  }

  Future<void> confirm(String orderId) async {
    await _writeService.confirm(ConfirmOrderCommand.create(orderId));
    await load(orderId);
  }
}
```

- States are `sealed` classes with `final` subclasses, so `switch` is exhaustive.
- Cubits are never created in `main` or in a widget's `build` outside a `BlocProvider`.
- Do not call `load` in the constructor. The page triggers it (`..load(id)`), which keeps tests deterministic.

## Widgets: page, view, skeleton

| Kind | Role | Knows about |
|---|---|---|
| **Page** (container) | Owns the `BlocProvider`/`BlocBuilder` and picks the loading, failure or loaded branch. | Cubit, application layer |
| **View** (component) | Pure rendering from constructor parameters. Emits callbacks. | Only its parameters |
| **Skeleton** | Loading placeholder that mirrors the view's layout. | Nothing |

```dart
class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({required this.orderId, super.key});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderDetailsCubit(
        context.read<OrderReadService>(),
        context.read<OrderWriteService>(),
        context.read<ErrorManager>(),
      )..load(orderId),
      child: BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
        builder: (context, state) => switch (state) {
          OrderDetailsLoading() => const OrderDetailsSkeleton(),
          OrderDetailsFailure(:final message) => OrderDetailsFailureView(message: message),
          OrderDetailsLoaded(:final order) => OrderDetailsView(
              order: order,
              onConfirm: () => context.read<OrderDetailsCubit>().confirm(orderId),
            ),
        },
      ),
    );
  }
}
```

- Views never import a Cubit, a service or a domain type that has behavior. They receive read models or plain values.
- Every page that loads data has a skeleton, placed next to its view.
- Keep `build` methods small. Extract private widgets into their own classes instead of helper methods that return widgets.

## Dependency injection

`frontend/lib/composition_root.dart` builds repositories, handlers and services, and exposes the services (never the repositories) through `MultiRepositoryProvider` above `MaterialApp`. Pages read services with `context.read<T>()`.

## Shared services

These cross-cutting services live in `frontend/lib/shared/`. They follow the same pattern as a feature module:

- `notifications/`: a `Notification` entity (in `core` if it carries domain meaning, otherwise a UI read model), a pure `NotificationService`, and a `NotificationsCubit` as its state service.
- `errors/`: `ErrorManager`, an `abstract class` whose implementation turns a `DomainError` or `DomainWarning` into a notification. It holds no state of its own.

Only route *unexpected* failures through `ErrorManager`. An expected outcome, such as "not found" from a bad id, is local Cubit state only.

## What the frontend MUST NOT do

- Declare domain types. Those go in `core`.
- Put business rules in a Cubit, Bloc or widget.
- Import infrastructure from presentation.
- Call a repository from a Cubit. Cubits talk only to read and write services.
