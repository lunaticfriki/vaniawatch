# Docs Vault (Obsidian)

`docs/` is an Obsidian vault. It is the **map of the system**: the rules, the decisions, and a note for every piece of code. Humans and AI assistants navigate the vault's graph *before* reading code, and update it *after* every task.

## Why

- Reading the graph is faster and cheaper than exploring the code. A note says what a concept means, which rules apply, where its code and tests live, and what it relates to.
- The vault holds what code cannot: business meaning, invariants and the reasons behind decisions.
- A stale map is worse than no map. That is why updating the vault is part of every task's definition of done, and `pnpm docs:check` enforces it.

## Vault layout

```
docs/
  README.md               entry point: rules index and non-negotiables
  architecture/           architecture rules
  development/            process rules
  codebase/               one note per concept in the code
    codebase.md           map of all packages
    core/
      core.md             package note: lists modules
      <module>/
        core.<module>.md  module note: lists every concept in the module
        core.<Name>.md    concept notes
    frontend/
    backend/
  decisions/              architecture decision records (ADRs)
    decisions.md          index of ADRs
  _templates/             note templates (excluded from graph and checks)
  glossary.md
```

## Codebase notes

### Naming

- Every codebase note is named `<package>.<Name>`, for example `core.Order`, `core.OrderId`, `frontend.OrderDetailsCubit` or `backend.OrderReadService`. The prefix keeps names unique across packages, since `OrderReadService` exists in both apps, and it shows the package in the graph.
- A module note is named `<package>.<module>`, for example `core.ordering`.
- A package note is named after the package: `core`, `frontend`, `backend`.

### One note per concept

A note covers one concept and lists **all** its files in `source`:

| Note type | Covers |
|---|---|
| `entity`, `value-object`, `port`, `domain-service`, `domain-error` | that domain file. A value object's validation error is part of the value-object note. |
| `command` / `query` | the command or query **and** its handler |
| `read-model`, `service`, `adapter`, `mapper` | that file. A service note covers the contract and its `Impl`. |
| `cubit` | the Cubit or Bloc, its state, and its events |
| `page` | the page, its view and its skeleton |
| `route` | the Frog route file and its request/response mappers |
| `component` | anything else: shared services, middleware, the composition root, widgets that are not pages |

### Frontmatter

```yaml
---
type: entity
package: core
module: ordering
status: implemented
source:
  - core/lib/src/ordering/entities/order_entity.dart
tests:
  - core/test/ordering/entities/order_entity_test.dart
---
```

- **`status`** is `planned` (designed in the vault, not written yet) or `implemented`. A note can be written *before* the code, as part of design and TDD. It switches to `implemented` when the code lands.
- **`source`** and **`tests`** are paths from the repo root. They MUST exist when the status is `implemented`.

### Body

The body explains what the code alone does not:

- **Purpose:** the business meaning, in the ubiquitous language.
- **Invariants, factories and behavior**, as applicable to the type.
- **Relations:** wikilinks to every concept it uses or is used by, such as `[[core.OrderId]]` or `[[core.OrderRepository]]`. These links *are* the graph.
- **Rules:** a link to the rule doc that governs this type, for example `[[03-domain-layer#Entity / aggregate root]]`.

Don't paste code into notes. Link to it through `source`.

## The workflow

### Before a task: read the graph, not the code

1. Start at [[README]] and go to [[codebase]], then the package note, then the module note, then the concept notes.
2. Follow wikilinks outward, and backlinks inward, to find everything the task touches. An AI assistant finds backlinks by searching the vault for `[[<note name>`.
3. Read the rule docs linked from those notes.
4. Open **only** the code files listed in the relevant notes' `source` and `tests`. Do not explore `lib/` broadly when the vault can answer the question.
5. If the vault is missing something or contradicts the code, that is a docs bug. Fix it as part of the task.

### During a task: design in the vault

For new concepts, create the notes from `_templates/` with `status: planned` before writing tests. The note's relations section is the design.

### After a task: update the vault (definition of done)

- [ ] Every added, changed or removed concept has its note created, updated or deleted.
- [ ] `status`, `source` and `tests` are accurate.
- [ ] Relations are linked both ways where they matter.
- [ ] Module and package notes list the new or removed concepts.
- [ ] Any architectural decision is recorded as an ADR in `decisions/` and linked from [[decisions]].
- [ ] If a rule changed, the rule doc in `architecture/` or `development/` is updated.
- [ ] `pnpm docs:check` is green.

A task is not done until the vault reflects it.

## `pnpm docs:check`

`scripts/docs/check.mjs` runs on its own and as part of `pnpm check` and `pre-push`. It fails when:

- A wikilink points to a note or heading that doesn't exist.
- An `implemented` note lists a `source` or `tests` path that doesn't exist.
- A Dart file is not listed in any note's `source`. This applies to the following folders:
  - `core/lib/src/`, except `src/testing/`
  - `frontend/lib/modules/`
  - `frontend/lib/shared/`
  - `backend/lib/modules/`
  - `backend/lib/shared/`
  - `backend/routes/`

Entry points and barrels (`main.dart`, `app.dart`, `composition_root.dart`, `core.dart`, `testing.dart`) are documented in their package note's `source`, and are not required.

## Obsidian setup

- Open `docs/` as a vault.
- Links are wikilinks, and Obsidian rewrites them automatically when a note is renamed.
- New notes go to `codebase/` by default.
- Templates live in `_templates/`. Insert one with the core Templates plugin, through the command palette ("Templates: Insert template").
- Graph colors:
  - core: blue
  - frontend: green
  - backend: orange
  - architecture: purple
  - development: yellow
  - decisions: grey
