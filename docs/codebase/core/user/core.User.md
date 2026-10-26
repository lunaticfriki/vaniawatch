---
type: entity
package: core
module: user
status: implemented
source:
  - core/lib/src/user/entities/user_entity.dart
tests:
  - core/test/user/entities/user_entity_test.dart
---
# core.User

Module: [[core.user (module)]]
Rules: [[03-domain-layer#Entity / aggregate root]]

## Purpose

A person who owns a private collection of watches. Watches reference their owner by [[core.UserId]]. A user does not hold its watches.

## Identity

[[core.UserId]]. Equality is by id.

## Invariants

- `updatedAt` is never before `createdAt`.
- `updatedAt` never moves backwards.

## Factories

- `create(id, name, email, createdAt)`: `updatedAt` starts at `createdAt`.
- `restore(id, name, email, createdAt, updatedAt)`: rejects an `updatedAt` before `createdAt`.
- `empty()`: `isEmpty` is true.

## Behavior

Every change takes `at: UpdatedAt` (the entity never reads the clock) and rejects a moment before the current `updatedAt`. When a change is rejected, nothing changes.

- `rename(UserName, at:)`
- `changeEmail(UserEmail, at:)`

## Relations

- Fields: [[core.UserId]], [[core.UserName]], [[core.UserEmail]], [[core.CreatedAt]], [[core.UpdatedAt]]
- Raises [[core.InvalidUpdatedAtError]]
- Owns [[core.Watch]] (by id)
- Decision: [[ADR-0005 entities receive time and reference owners by id]]

## Testing

- Mother: `UserMother` (`core/lib/src/testing/user/user_mother.dart`)
