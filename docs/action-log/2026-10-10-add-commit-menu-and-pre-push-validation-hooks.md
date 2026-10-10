---
date: 2026-10-10
type: change-record
decision: allow
tags:
  - action-log
---

# Add commit menu and pre-push validation hooks

## Decision

ALLOW

## Affected Components

- project root or unclassified path
- project rules and documentation

## Changed Paths

- `.husky`
- `scripts`
- `docs/git-workflow.md`
- `docs/index.md`
- `docs/architecture/rules.md`

## Checks

- Core dependency boundary: passed
- Watch ownership boundary: passed
- Feature/fix summary: added a `prepare-commit-msg` type/comment menu, a
  pre-push stash/test/restore guard, a local hook installer, and Git workflow
  documentation. Installed `core.hooksPath=.husky` for this repository.
- Validation: shell syntax checks passed; the interactive type/comment prompt
  passed under Expect; `dart analyze .` and all 11 core tests passed. The full
  pre-push wrapper was not run because this repository has no commit yet.
