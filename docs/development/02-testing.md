# Testing

Testing mirrors the layers:

| Layer | Approach |
|---|---|
| Domain (`core`) | Use real objects and no mocks at all. |
| Application | Mock the ports with `mocktail`. |
| Infrastructure | Test against an in-memory or real dependency, or recorded fixtures. |
| Presentation (frontend) | Use `bloc_test` for Cubits/Blocs, widget tests with a mocked Cubit for pages, and plain parameters for views. |
| Presentation (backend) | Test routes with a mocked `RequestContext`, and middleware in isolation. |
| Architecture | Arch tests enforce the dependency rule. |

## Tooling

| Package | Runner | Mocks | Extra |
|---|---|---|---|
| `core` | `dart test` | none | |
| `backend` | `dart test` | `mocktail` | |
| `frontend` | `flutter test` | `mocktail` | `bloc_test` |

`mockito` code generation is not used.

## Running

`make <command> [core|back|front]`, run from the repo root. Without a scope, the command runs on every package and skips packages that don't exist yet. With a scope, a missing package is an error.

| Command | Runs |
|---|---|
| `make test core` | `dart test` in `core` |
| `make test back` | `dart test` in `backend` |
| `make test front` | `flutter test` in `frontend` |
| `make test` | all of the above |
| `make analyze [scope]` | `analyze --fatal-infos` |
| `make format [scope]` | `format .` |
| `make check` | `pnpm check`: the docs check plus format, analyze and test for every package, the same as pre-push |
| `make docs` | `pnpm docs:check` |
| `make test-integration` | starts Postgres in Docker and runs the backend tests tagged `integration` |

## Domain tests: no mocks

```dart
void main() {
  group('Order', () {
    test('cannot add a line once confirmed', () {
      final order = OrderMother.confirmed();

      expect(
        () => order.addLine(OrderLineMother.random()),
        throwsA(isA<OrderAlreadyConfirmedError>()),
      );
    });
  });
}
```

If a domain test seems to need a mock, the class has an outward dependency it shouldn't have.

## Application tests: mock the ports

```dart
class MockOrderRepository extends Mock implements OrderRepository {}

void main() {
  group('ConfirmOrderCommandHandler', () {
    late MockOrderRepository repository;
    late ConfirmOrderCommandHandler handler;

    setUp(() {
      repository = MockOrderRepository();
      handler = ConfirmOrderCommandHandler(repository);
    });

    test('confirms an existing order and persists it', () async {
      final order = OrderMother.random();
      when(() => repository.findById(order.id)).thenAnswer((_) async => order);
      when(() => repository.save(order)).thenAnswer((_) async {});

      await handler.handle(ConfirmOrderCommand.create(order.id.value));

      expect(order.status.isConfirmed, isTrue);
      verify(() => repository.save(order)).called(1);
    });

    test('throws when the order does not exist', () async {
      when(() => repository.findById(any())).thenAnswer((_) async => null);

      expect(
        () => handler.handle(ConfirmOrderCommand.create(OrderIdMother.random().value)),
        throwsA(isA<OrderNotFoundError>()),
      );
    });
  });
}
```

- Mock only **ports** and **services**. Never mock a domain object. Build real domain objects with Object Mothers.
- Register fallback values for value objects used with `any()`, in `setUpAll` with `registerFallbackValue`.

## Cubit tests

```dart
blocTest<OrderDetailsCubit, OrderDetailsState>(
  'emits loading then loaded when the order exists',
  setUp: () => when(() => readService.getById(any()))
      .thenAnswer((_) async => OrderReadModelMother.random()),
  build: () => OrderDetailsCubit(readService, writeService, errorManager),
  act: (cubit) => cubit.load(OrderIdMother.random().value),
  expect: () => [isA<OrderDetailsLoading>(), isA<OrderDetailsLoaded>()],
);
```

## Widget tests

- **Page:** provide a `MockCubit` from `bloc_test`, stub its state, and assert that the right branch renders: the skeleton, the failure view or the loaded view.
- **View:** pump the widget with plain parameters from Object Mothers. No mocks are needed.

## Integration tests

Tests that need a real dependency, such as the Postgres repository and the migrator, are tagged:

```dart
@Tags(['integration'])
library;
```

`backend/dart_test.yaml` skips that tag by default, so `make test`, `pnpm check` and pre-push stay fast and need no Docker. `make test-integration` runs them against the `vaniawatch_test` database, migrating it and truncating tables between tests.

## Backend route tests

Mock `RequestContext` and `Request` with `mocktail`, stub `context.read<OrderReadService>()`, call `onRequest`, and assert on the status code and body. Test the error middleware separately, one test per mapped error.

## Object Mothers

Every fixture is built through an Object Mother. Ad-hoc literals scattered across tests are not allowed.

```dart
abstract final class OrderMother {
  static Order random() => Order.create(
        id: OrderIdMother.random(),
        customerId: CustomerIdMother.random(),
      )..addLine(OrderLineMother.random());

  static Order empty() => Order.empty();

  static Order confirmed() => random()..confirm();
}
```

- Write one Mother per entity, value object or read model that is used across tests.
- `random()` returns a fully valid instance. Named variants cover scenarios: `confirmed()`, `withoutLines()`, `expired()`.
- Mothers compose other Mothers. `OrderMother` uses `CustomerIdMother`, not a hand-built id.
- Random primitives come from a shared `PrimitiveMother` built on `dart:math`, with no faker dependency in `core`.
- **Where Mothers live:**
  - **`core`:** in `core/lib/src/testing/<module>/`, exported only through `core/lib/testing.dart`, so `frontend` and `backend` tests can reuse them. Production code MUST NOT import them, and the arch test enforces this.
  - **`frontend` and `backend`:** Mothers for their own types (read models, requests, responses) live in their `test/` tree, next to the tests that use them.

## Arch tests

Each package has `test/architecture/dependency_rule_test.dart`. It reads every `.dart` file under `lib/` and asserts that its imports respect the rules below. A violation fails the normal test run, so no extra tooling is needed.

`core`:

- No imports of `package:flutter`, `dart:ui`, `dart:io`, `dart:html`, `dart:js_interop` or `package:dart_frog`.
- No file outside `lib/src/testing/` imports from `lib/src/testing/`.

`frontend` and `backend`:

- `application/` imports only `package:core/core.dart`, the Dart SDK and application files.
- `infrastructure/` never imports `presentation/`.
- `presentation/` never imports `infrastructure/`.
- No module imports another module's `infrastructure/` or `presentation/`.
- Only `composition_root.dart` imports every layer.
- No file under `lib/` imports `package:core/src/...` or `package:core/testing.dart`.
