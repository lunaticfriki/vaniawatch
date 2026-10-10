# Vaniawatch

Vaniawatch is a private watch collection for authenticated users. The shared
Dart domain is the current implementation; the Dart Frog backend and Flutter
frontend are planned consumers and have not been implemented yet.

## Project Structure

- `core/`: framework-independent Dart domain shared by future applications.
- `core/auth/`: user identity and email concepts.
- `core/catalog/`: watches, watch value objects, and the owner-scoped
  repository contract.
- `backend/`: reserved for the future Dart Frog application.
- `frontend/`: reserved for the future Flutter application.
- `docs/`: project architecture, change workflow, and Obsidian-ready notes.
- `tool/change_harness.dart`: policy checks, impact reporting, and action
  records.

Each watch has one owner. Repository operations are owner-scoped, and
collections are private by default. Firebase is not used in this project.

## Requirements

- Dart SDK `>=3.3.0 <4.0.0`
- Git
- Bash and POSIX shell for the repository hooks

## Core Setup And Checks

Use Make to resolve dependencies, analyze, and test:

```sh
make setup
make check
```

Individual commands are available when needed:

```sh
make core-get
make core-analyze
make core-test
```

The domain tests are co-located with their entities and value objects and use
Object Mothers for valid fixtures. See `make help` for all project targets.

## Docker Checks

Docker currently runs the core checks only; there is no backend or frontend
server to containerize yet. From the repository root:

```sh
make docker-check
```

See [Docker workflow](docs/docker.md) for what the service runs and how it
will expand when the applications exist.

## Git Hooks

Install the commit prompt and pre-push checks after cloning:

```sh
make hooks-install
```

Interactive commits show a conventional-commit type menu and ask for a
comment. Before pushing, the hook runs core analysis and tests against the
committed tree while preserving local changes. See [Git workflow](docs/git-workflow.md).

Use `make commit` for a normal interactive commit, or pass Git options with
`make commit ARGS="-m 'feat: add watch fields'"`. Run
`make pre-push-check` to invoke the same stash/test/restore guard manually.

## Documentation

Open `docs/` as an Obsidian vault for linked architecture notes and Mermaid
graphs. Start with [the documentation index](docs/index.md). Claude-specific
coding instructions are in [CLAUDE.md](CLAUDE.md).

Before a proposed change, use the [change harness](docs/change-harness.md)
through `make change-check ACTION="..." FILES="path,other-path"`. The
harness prints its decision, impacted components, and boundary checks; no
action log is saved. At the end of each requested change, the results and
verification are reported here in the conversation.