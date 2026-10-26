# Git Workflow

## Setup

Node tooling is managed with **pnpm**. Never use npm.

```sh
pnpm install
```

`pnpm install` runs the `prepare` script, which activates Husky by setting `core.hooksPath` to `.husky/_`.

## Commit messages

Every commit message follows `type(scope): description`. Both the type and the scope are required.

| Scope | When |
|---|---|
| `core` | Changes in `core/` |
| `backend` | Changes in `backend/` |
| `frontend` | Changes in `frontend/` |
| `repo` | Docs, tooling, root configuration |

| Type | When |
|---|---|
| `feat` | A new feature |
| `fix` | A bug fix |
| `test` | Adding or correcting tests |
| `refactor` | Neither a fix nor a feature |
| `docs` | Documentation only |
| `style` | Formatting only, with no change in meaning |
| `perf` | A performance improvement |
| `build` | Build system or dependency changes |
| `ci` | CI configuration |
| `chore` | Anything else |
| `revert` | Reverts a previous commit |

The list of scopes and types lives only in `scripts/git/commit-conventions.mjs`. Both the menu and commitlint read it.

## Hooks

### `prepare-commit-msg`: the commit menu

Running `git commit` from a terminal opens three prompts:

1. **Folder:** `core`, `backend`, `frontend` or `repo`. It is preselected when all staged files belong to one folder.
2. **Type of change:** `feat`, `fix`, `test` and the other types above.
3. **Commit message:** the description.

The menu writes `type(scope): description` and the commit completes. Ctrl+C aborts the commit.

The menu is skipped in these cases, and the existing message is kept:

- `git commit -m` / `-F`
- merges, squashes, `--amend`
- non-interactive commits, such as IDE commit panels and CI

### `commit-msg`: commitlint

This hook validates every message, including the ones that skip the menu. A missing or unknown scope or type rejects the commit.

### `pre-push`: test only what is committed

1. It stashes all uncommitted work, including untracked files.
2. It runs `scripts/check.sh` against exactly what is committed.
3. It always restores the stash, whatever the result.
4. If the checks pass, the push goes ahead. If anything fails, the push is aborted.

`scripts/check.sh` first runs `pnpm docs:check` (see [[05-docs-vault]]). Then it runs the following for each package that has a `pubspec.yaml`:

- `pub get`, with `--enforce-lockfile` when `pubspec.lock` is committed
- `dart format --set-exit-if-changed`
- `analyze --fatal-infos`
- `test`, when the package has any `*_test.dart` files

`core` and `backend` use `dart`, and `frontend` uses `flutter`.

Run the same checks manually with `pnpm check`.

## Rules

- Never push red. Bypassing the hooks with `--no-verify` is not allowed.
- Commits are small and cohesive. A TDD cycle (a test plus the code that makes it pass) belongs in one commit.
- One scope per commit. If a change spans packages, split it into one commit per package where possible.
- Do not mix formatting changes with behavior changes in the same commit.
