---
type: decision
status: accepted
date: 2026-10-31
---
# ADR-0007 temporary user identification and private collections

Index: [[decisions]]

## Context

Each user's watch collection is private, but login does not exist yet. The watch CRUD still needs to know who is calling.

## Decision

- **Temporary identity.** The caller sends `X-User-Id: <uuid>`. [[backend.RequestUser]] middleware, installed only under `/watches`, answers 401 when the header is missing and provides a `RequestUser` otherwise. The value is validated as a [[core.UserId]] in the handlers, so a malformed id is a 400.
- **Private by construction.** Every command and query carries `ownerId`. Handlers load the watch and check `Watch.isOwnedBy`. A watch of another user is reported as [[core.WatchNotFoundError]] (404), never 403, so its existence is not revealed.
- **No users table yet.** `watches.owner_id` has no foreign key until the user module exists.

## Consequences

- **This is not security.** Anyone can impersonate anyone by changing the header. It must not be exposed beyond local development.
- When login lands, replace `requestUserMiddleware` with an authentication middleware that provides the same `RequestUser`. Routes, handlers and tests of the domain do not change.
- Add the `users` table and the `owner_id` foreign key in a migration at that point.

## Related

[[backend.WatchesRoute]], [[ADR-0005 entities receive time and reference owners by id]]
