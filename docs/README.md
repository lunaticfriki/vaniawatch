# VaniaWatch Engineering Rules

This folder is an Obsidian vault. It holds the rules for architecture and for how we develop, the decisions behind them, and a map of the code. It is the single source of truth.
It is written for human developers and for AI coding assistants. Rules use MUST / MUST NOT / SHOULD.

The same rules apply to all three packages:

| Package | Path | Role |
|---|---|---|
| `core` | `core/` | Pure Dart package. The domain: entities, value objects, repository ports, domain errors, domain services. |
| `frontend` | `frontend/` | Flutter app. Application, infrastructure and presentation (Cubit/Bloc) layers built on `core`. |
| `backend` | `backend/` | Dart Frog server. Application, infrastructure and HTTP presentation layers built on `core`. |

The AI assistant configuration (`CLAUDE.md`, `.claude/`, `GEMINI.md`, `.gemini/`, `.github/copilot-instructions.md`, `.github/instructions/`) only points back here. When the two disagree, `docs/` wins.

## The rule that outranks all others

**Domain logic lives in the domain, and the domain lives in `core`.**
The application, infrastructure and presentation layers MUST NOT contain business rules or validate business invariants. Their job is to orchestrate, adapt and render, not to make business decisions.
If in doubt, the logic belongs in `core`, unless it is strictly technical: I/O, framework wiring or rendering.

## Non-negotiables

1. **No comments in code.** No `//`, no `///`, no `/* */`, no `TODO`. Names and structure carry the meaning. See [[03-code-style]].
2. **Hexagonal architecture.** The layers are `domain` / `application` / `infrastructure` / `presentation`, and dependencies only point inward. See [[02-hexagonal-architecture]].
3. **DDD tactical patterns.** Use entities, value objects, aggregates, domain services and typed domain errors. See [[03-domain-layer]].
4. **Private constructors and named factories.** Construct objects through factories such as `create`, `empty` and `restore`, never through a public constructor.
5. **Value objects, not primitives, in the domain.** A raw `String`, `int`, `double` or `bool` in a domain model is a missing value object.
6. **Abstract classes as contracts.** Ports and application services are `abstract class`. Concrete classes `implements` them.
7. **CQRS. No use cases.** Commands go to command handlers grouped in a **write service**. Queries go to query handlers grouped in a **read service**. Reactive UI state lives in a separate **state service**, which in the frontend is a Cubit/Bloc. See [[04-application-layer-cqrs]].
8. **No use-case classes and no data-source layer.** A repository implementation talks to the API or DB directly.
9. **Cubit by default, Bloc only when needed.** The frontend uses Cubit, and switches to Bloc only when a screen genuinely needs event streams (debounce, transformers). See [[06-frontend-flutter]].
10. **TDD.** Write the failing test first, then the code that makes it pass, then refactor. See [[01-tdd]].
11. **Object Mothers** build every test fixture. No ad-hoc literals scattered across tests. See [[02-testing]].
12. **Arch tests** enforce the dependency rule. A layer violation fails the test suite.
13. **Vertical slicing.** Organize by module (bounded context) first and by layer second. See [[08-structure-and-naming]].
14. **Docs first, docs after.** Read the vault graph ([[codebase]]) before reading code, and update it after every task. `pnpm docs:check` enforces this. See [[05-docs-vault]].

## Where to start a task

1. [[codebase]]: the map of the code. Go from package to module to concept notes, and follow the links.
2. [[decisions]]: why things are the way they are.
3. The rule docs below, linked from each note.

## Reading order

### Architecture

1. [[01-monorepo]]: the three packages and how they depend on each other.
2. [[02-hexagonal-architecture]]: layers, ports and adapters, the dependency rule.
3. [[03-domain-layer]]: entities, value objects, factories, domain errors.
4. [[04-application-layer-cqrs]]: commands, queries, read/write/state services.
5. [[05-infrastructure-layer]]: adapters, the ACL, the composition root.
6. [[06-frontend-flutter]]: Cubit/Bloc, page/view/skeleton.
7. [[07-backend-frog]]: routes as thin adapters, middleware, error mapping.
8. [[08-structure-and-naming]]: folder trees and file naming.

### Development process

1. [[01-tdd]]: the red-green-refactor workflow and the order to build a feature in.
2. [[02-testing]]: test types per layer, Object Mothers, mocktail, bloc_test, arch tests.
3. [[03-code-style]]: no comments, lints, formatting, Dart idioms.
4. [[04-git-workflow]]: conventional commits and the pre-push test guard.
5. [[05-docs-vault]]: the vault layout, codebase notes, and the read-before and update-after workflow.

[[glossary]] defines the terms used across these docs.
