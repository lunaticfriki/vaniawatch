# Glossary

**ACL (Anti-Corruption Layer)**: Infrastructure mappers that translate an external shape (JSON, a database row) into domain objects and back. Lives in `infrastructure/acl/`.

**Aggregate / aggregate root**: A consistency boundary of entities and value objects. Outside code references and modifies it only through its root.

**Arch test**: A test that reads the source and fails when an import breaks the dependency rule.

**Command**: A request to change state, handled by exactly one command handler. It returns no read model.

**Composition root**: The single place per app that instantiates adapters and wires them into handlers and services.

**Cubit / Bloc**: The frontend's state service. A Cubit is the default. A Bloc is used only when event streams and transformers are needed.

**Domain error / domain warning**: Typed exceptions declared in `core`. An error stops the operation. A warning is surfaced to the user but stops nothing.

**Domain service**: Pure domain logic that spans aggregates or doesn't belong to one entity.

**Entity**: A domain object whose identity persists across state changes. Equality is by identity.

**Error Manager**: The frontend shared service that turns unexpected domain errors and warnings into user notifications.

**Factory methods**: Named constructors (`create`, `empty`, `restore`, …) that are the only way to build entities and value objects.

**Mother (Object Mother)**: A test-only factory of valid, named fixtures (`random()`, `empty()`, `confirmed()`).

**Page / View / Skeleton**:
- A page is a Flutter container that owns the Cubit and picks a branch.
- A view is a pure widget rendered from its parameters.
- A skeleton is the loading placeholder that mirrors the view's layout.

**Port / adapter**: A port is a contract (`abstract class`) declared by an inner layer. An adapter is its infrastructure implementation.

**Query**: A request to read state, handled by exactly one query handler. It never mutates anything.

**Read model**: A flat DTO returned by a query. It is optional for read-only entities.

**Read service / write service**: The CQRS groupings of query handlers and command handlers. They have no framework dependencies.

**State service**: The reactive state holder. It exists only in the frontend, where it is a Cubit or Bloc.

**Value object**: An immutable domain object with no identity, compared structurally. It replaces primitives in the domain.

**Vertical slicing**: Organizing code by module first and by layer second.

**Vault**: The `docs/` folder opened in Obsidian. Its graph of linked notes is read before the code. See [[05-docs-vault]].

**Codebase note**: A vault note named `<package>.<Name>` that documents one concept in the code. Its `source` and `tests` list the files that implement it.

**ADR (architecture decision record)**: A note in `decisions/` that records one architectural decision with its context and consequences.
