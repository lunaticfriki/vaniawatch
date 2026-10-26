---
type: decision
status: accepted
date: 2026-10-26
---
# ADR-0005 entities receive time and reference owners by id

Index: [[decisions]]

## Context

[[core.User]] and [[core.Watch]] track `createdAt` and `updatedAt`, and each watch belongs to exactly one user, whose collection is private. Two questions follow:

- Should entities read the clock themselves?
- Should a watch hold its owner as a `User` or as a `UserId`?

## Decision

- **Time comes in from outside.** `create` receives a [[core.CreatedAt]], and every change receives `at:` [[core.UpdatedAt]]. Entities never call `now()`. The application layer does that.
- **Timestamps only move forward.** A `restore` with `updatedAt` before `createdAt`, or a change with `at` before the current `updatedAt`, throws [[core.InvalidUpdatedAtError]] and changes nothing.
- **The owner is a reference.** `Watch.owner` is a [[core.UserId]]. `User` and `Watch` are separate aggregates, and privacy is checked with `Watch.isOwnedBy(UserId)`.

## Consequences

- Domain tests are deterministic. They need no clock mocks.
- Loading a watch never loads its user. Repositories filter by owner id.
- Command handlers must pass `UpdatedAt.now()` (or an injected clock) on every change.

## Related

[[03-domain-layer]], [[core.user (module)]], [[core.watch (module)]], [[core.shared (module)]]
