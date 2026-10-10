---
title: Git Workflow
tags:
  - git
  - workflow
---

# Git Workflow

Vaniawatch uses portable shell hooks in `.husky/`; no Node package is needed
for the Dart project.

## Install

Run once after cloning or initializing the repository:

```sh
sh scripts/install-hooks.sh
```

The installer sets the local Git `core.hooksPath` to `.husky` and marks hook
scripts executable.

## Commit Prompt

On an interactive `git commit` without a supplied message,
`prepare-commit-msg` displays a numbered menu of conventional-commit types
and prompts for a comment. The resulting message is `<type>: <comment>`.
Commits with an explicit message, reused message, merge, or non-interactive
commit UI skip the prompt and retain their normal Git behavior.

## Pre-Push Guard

Before pushing, the hook stashes staged, unstaged, and untracked changes,
runs `dart analyze .` and the core domain tests from the committed tree, then
restores the stash. Any analysis or test failure blocks the push. If stash
restoration encounters a conflict, the hook reports it and leaves the stash
available for manual recovery.