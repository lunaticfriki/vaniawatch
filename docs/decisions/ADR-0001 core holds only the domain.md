---
type: decision
status: accepted
date: 2026-10-26
---
# ADR-0001 core holds only the domain

Index: [[decisions]]

## Context

Three packages share one business model: `core`, `frontend` and `backend`. Command and query handlers depend only on ports, so they could live in `core` too.

## Decision

`core` holds only the domain layer: entities, value objects, repository ports, domain services and domain errors. The application layer (CQRS handlers, read/write services), infrastructure and presentation live in `frontend` and `backend`.

## Consequences

- `core` stays small, pure and focused on business rules.
- Each app shapes its own application layer. The backend has no state service, and the frontend's state service is a Cubit.
- Some handlers may be duplicated across the two apps. If that becomes a real cost, revisit this decision with a new ADR.

## Related

[[01-monorepo]], [[04-application-layer-cqrs]], [[core]]
