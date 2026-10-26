# VaniaWatch

Monorepo with three packages:

- `core/`: pure Dart domain package.
- `frontend/`: Flutter app.
- `backend/`: Dart Frog server.

`docs/` is an Obsidian vault and the single source of truth: rules, decisions, and a map of the code. Its rules are binding for all three packages.

@docs/README.md

## Workflow: read the vault graph, not the code

The full workflow is in docs/development/05-docs-vault.md.

### Before the task

1. Open docs/codebase/codebase.md. From there, go to the package note, then the module note, then the concept notes (named `<package>.<Name>`).
2. Follow `[[wikilinks]]` outward. Find backlinks by searching the docs for `[[<note name>`. This link graph is how you navigate.
3. Read the rule docs and decisions (docs/decisions/) linked from those notes.
4. Open only the files listed in the notes' `source` and `tests` frontmatter. Do not explore `lib/` broadly when the vault answers the question.
5. If the vault is missing something or contradicts the code, fix the vault as part of the task.

### During the task

Create notes for new concepts first, from `docs/_templates/` with `status: planned`. Then work test-first (TDD): write the failing test and run it, then implement, then refactor.

### After the task (definition of done)

- Create, update or delete a note for every concept touched. Keep `status`, `source` and `tests` accurate, and link the relations.
- Update the module and package notes.
- Record any architectural decision as an ADR in docs/decisions/, and add it to docs/decisions/decisions.md.
- If a rule changed, update the rule doc.
- `pnpm check` must be green. It includes `pnpm docs:check`.

## Code rules (summary; details in docs)

- Never write comments in code.
- Domain types go in `core` only.

## Commands

```sh
pnpm install
pnpm check
pnpm docs:check
```

Commits use `type(scope): description`, with scope `core`, `backend`, `frontend` or `repo`. Use `git commit -m "..."` in non-interactive shells. See docs/development/04-git-workflow.md.
