# Structure & Naming

## Vertical slicing

Folders are organized by **module** (bounded context or feature) first, and by layer second. Everything about "ordering" is found under one `ordering/` folder in each package.

- A module is named with a business noun (`ordering`, `catalog`, `watchlist`), never a technical one (`services`, `utils`).
- A new feature is a new module folder with its own layers. It is not a new branch inside an existing module.
- Modules talk to each other only through the other module's read or write services. They never reach into another module's internals.
- `shared/` holds truly cross-cutting pieces: the base `DomainError`, generic value objects such as `Money`, `ErrorManager` and notifications. If only one module uses something, it stays in that module.

## Package trees

### core

```
core/
  lib/
    core.dart
    testing.dart
    src/
      ordering/
        entities/
        value_objects/
        repositories/
        services/
        errors/
      shared/
        errors/
        value_objects/
      testing/
        ordering/
          order_mother.dart
          order_id_mother.dart
        shared/
          primitive_mother.dart
  test/
    ordering/
      entities/
        order_entity_test.dart
      value_objects/
        order_id_value_object_test.dart
    architecture/
      dependency_rule_test.dart
```

### frontend

```
frontend/
  lib/
    main.dart
    app.dart
    composition_root.dart
    modules/
      ordering/
        application/
          command/
          query/
          order_read_model.dart
          order_read_service.dart
          order_write_service.dart
        infrastructure/
          acl/
        presentation/
          cubit/
            order_details_cubit.dart
            order_details_state.dart
          order_details_page.dart
          order_details_view.dart
          order_details_skeleton.dart
    shared/
      errors/
      notifications/
  test/
    modules/ordering/...
    architecture/
      dependency_rule_test.dart
```

### backend

See [[07-backend-frog#Folder structure]]. `backend/lib/modules/<module>/` contains `application/`, `infrastructure/` and `presentation/`. `backend/routes/` holds the Frog entry points.

## Tests mirror lib

Dart tooling discovers tests under `test/` and keeps dev dependencies out of `lib/`. So tests live in `test/`, and that tree **mirrors `lib/` one-to-one**:

- `lib/src/ordering/entities/order_entity.dart` → `test/ordering/entities/order_entity_test.dart`

## File naming

Files are `snake_case`, named `<concept>_<kind>.dart`. The kind suffix comes from a fixed vocabulary, so a directory listing tells you what everything is:

| Kind | File | Class |
|---|---|---|
| Entity / aggregate | `order_entity.dart` | `Order` |
| Value object | `order_id_value_object.dart` | `OrderId` |
| Repository port | `order_repository.dart` | `OrderRepository` |
| Repository adapter | `http_order_repository.dart` | `HttpOrderRepository` |
| Domain service | `pricing_policy_service.dart` | `PricingPolicyService` |
| Domain error | `order_not_found_error.dart` | `OrderNotFoundError` |
| Domain warning | `stale_order_warning.dart` | `StaleOrderWarning` |
| Command | `confirm_order_command.dart` | `ConfirmOrderCommand` |
| Command handler | `confirm_order_command_handler.dart` | `ConfirmOrderCommandHandler` |
| Query | `get_order_query.dart` | `GetOrderQuery` |
| Query handler | `get_order_query_handler.dart` | `GetOrderQueryHandler` |
| Read model | `order_read_model.dart` | `OrderReadModel` |
| Read service | `order_read_service.dart` | `OrderReadService`, `OrderReadServiceImpl` |
| Write service | `order_write_service.dart` | `OrderWriteService`, `OrderWriteServiceImpl` |
| ACL mapper | `order_mapper.dart` | `OrderMapper` |
| Cubit | `order_details_cubit.dart` | `OrderDetailsCubit` |
| Cubit/Bloc state | `order_details_state.dart` | `OrderDetailsState` + subclasses |
| Bloc | `order_search_bloc.dart` | `OrderSearchBloc` |
| Bloc event | `order_search_event.dart` | `OrderSearchEvent` + subclasses |
| Page (container) | `order_details_page.dart` | `OrderDetailsPage` |
| View (component) | `order_details_view.dart` | `OrderDetailsView` |
| Skeleton | `order_details_skeleton.dart` | `OrderDetailsSkeleton` |
| HTTP response/request (backend) | `order_response.dart`, `confirm_order_request.dart` | `OrderResponse`, `ConfirmOrderRequest` |
| Object Mother | `order_mother.dart` | `OrderMother` |
| Test | `<file under test>_test.dart` | — |

Rules:

- Drop a word from the concept when the suffix already says it: `confirm_order_command.dart`, not `confirm_order_command_command.dart`.
- A port and its adapter are both `_repository.dart` files. They are told apart by folder and by the adapter's prefix (`http_`, `postgres_`, `in_memory_`).
- A contract and its implementation (`OrderReadService` and `OrderReadServiceImpl`) live in the same file.
- **Exempt** from the suffix rule: scaffold and entry-point files such as `main.dart`, `app.dart`, `composition_root.dart`, barrel files (`core.dart`, `testing.dart`), Frog `routes/` files and `_middleware.dart`.

## Barrel files

- `core/lib/core.dart` exports the public domain API. Other packages import only `package:core/core.dart`, never `package:core/src/...`.
- `core/lib/testing.dart` exports Object Mothers. It is imported only from `test/` folders.
- Inside a package, import with `package:` imports, not relative imports.
