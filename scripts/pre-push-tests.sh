#!/usr/bin/env sh
set -u

STASHED=0

restore_worktree() {
  RESULT=$?
  trap - EXIT

  if [ "$STASHED" -eq 1 ]; then
    if ! git stash pop --index --quiet; then
      printf '%s\n' 'Unable to fully restore the pre-push stash; inspect git status and git stash list.' >&2
      if [ "$RESULT" -eq 0 ]; then
        RESULT=1
      fi
    fi
  fi

  exit "$RESULT"
}

trap restore_worktree EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

if [ -n "$(git status --porcelain)" ]; then
  if ! git stash push --include-untracked --quiet -m 'pre-push-guard'; then
    printf '%s\n' 'Could not stash local changes; push aborted.' >&2
    exit 1
  fi
  STASHED=1
fi

ROOT_DIR=$(git rev-parse --show-toplevel) || exit 1
cd "$ROOT_DIR/core" || exit 1

printf '%s\n' 'Analyzing committed core...'
if ! dart analyze .; then
  printf '%s\n' 'Dart analysis failed. Push aborted.' >&2
  exit 1
fi

printf '%s\n' 'Running committed core tests...'
if ! dart run test \
  catalog/entities/__tests__/watch.entity_test.dart \
  auth/value_objects/__tests__/email_address.value_object_test.dart \
  auth/entities/__tests__/user.entity_test.dart; then
  printf '%s\n' 'Core tests failed. Push aborted.' >&2
  exit 1
fi