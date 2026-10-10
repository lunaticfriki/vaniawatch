---
date: 2026-10-10
type: change-record
decision: allow
tags:
  - action-log
---

# Require an Object Mother for every domain entity

## Decision

ALLOW

## Affected Components

- project root or unclassified path
- project rules and documentation

## Changed Paths

- `docs/architecture/rules.md`
- `CLAUDE.md`

## Checks

- Core dependency boundary: passed
- Watch ownership boundary: passed
- Feature/fix summary: made a co-located Object Mother mandatory for each
  domain entity and required entity tests to use it for valid fixtures while
  asserting identity, invariants, and behavior. Clarified invalid-input and
  composed-mother guidance in the project and Claude instructions.
- Validation: the project change harness returned `ALLOW`; core dependency
  and owner-scoped repository checks passed.
