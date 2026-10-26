#!/usr/bin/env sh
set -u

cd "$(git rev-parse --show-toplevel)"

STASHED=0

restore_stash() {
  if [ "$STASHED" -eq 1 ]; then
    git stash pop --index --quiet >/dev/null || echo "⚠ Could not restore the stash automatically. Run: git stash pop"
  fi
}

trap restore_stash EXIT
trap 'exit 130' INT TERM

if [ -n "$(git status --porcelain)" ]; then
  git stash push --include-untracked --quiet -m "pre-push: uncommitted changes"
  STASHED=1
  echo "· Uncommitted changes stashed, testing committed code only"
fi

if sh scripts/check.sh; then
  echo "✓ Green, pushing"
  exit 0
fi

echo "✗ Push aborted. Your uncommitted changes have been restored."
exit 1
