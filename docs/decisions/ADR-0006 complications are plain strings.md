---
type: decision
status: accepted
date: 2026-10-26
---
# ADR-0006 complications are plain strings

Index: [[decisions]]

## Context

The domain rule is "no primitives": every meaningful concept is a value object. Complications were first modeled as `WatchComplication` (trimmed, lowercased, at most 50 characters) collected in `WatchComplications` (deduplicated, at most 20). That was more structure than the product needs.

## Decision

[[core.Watch]] stores `complications` as a plain `List<String>`. The watch keeps an unmodifiable copy of the list it receives. There is no validation, normalization or deduplication.

This is an explicit, scoped exception to [[03-domain-layer#No primitives in the domain]]. It is not a precedent for other fields.

## Consequences

- The domain is simpler, and complications are free text exactly as the user typed them.
- Duplicates, blank entries or case variants are possible. If that becomes a problem, reintroduce a value object with a new ADR.
- Tags remain a value object ([[core.WatchTags]]).

## Related

[[core.Watch]], [[core.watch (module)]]
