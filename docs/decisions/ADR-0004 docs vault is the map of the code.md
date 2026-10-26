---
type: decision
status: accepted
date: 2026-10-26
---
# ADR-0004 docs vault is the map of the code

Index: [[decisions]]

## Context

Exploring code to understand the system is slow and loses business intent. AI assistants in particular spend effort re-deriving what a concept means and where it lives.

## Decision

`docs/` is an Obsidian vault with one note per concept in the code, linked into a graph. Everyone reads the graph before the code, and updates it as part of every task's definition of done. `pnpm docs:check` enforces that links resolve, that sources exist, and that every Dart file is documented.

## Consequences

- Every task carries the cost of updating notes.
- The vault is trustworthy enough to answer most questions without reading code.
- Pushes fail when code lands without its notes.

## Related

[[05-docs-vault]]
