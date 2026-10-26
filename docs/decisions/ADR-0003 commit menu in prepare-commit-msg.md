---
type: decision
status: accepted
date: 2026-10-26
---
# ADR-0003 commit menu in prepare-commit-msg

Index: [[decisions]]

## Context

Every commit should be `type(scope): description`, with the scope chosen from a menu (`core`, `backend`, `frontend`, `repo`). Git's `pre-commit` hook cannot set the message.

## Decision

Husky (installed with pnpm) runs an interactive menu in `prepare-commit-msg`. commitlint validates every message in `commit-msg`, including commits made with `-m` or from an IDE. `pre-push` stashes uncommitted work, then runs `pnpm check` against committed code only.

## Consequences

- Plain `git commit` in a terminal always produces a valid message.
- Node and pnpm are needed for the root tooling, but not for the Dart packages.

## Related

[[04-git-workflow]]
