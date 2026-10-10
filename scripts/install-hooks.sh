#!/usr/bin/env sh
set -eu

ROOT_DIR=$(git rev-parse --show-toplevel)
git -C "$ROOT_DIR" config core.hooksPath .husky
chmod +x \
  "$ROOT_DIR/.husky/prepare-commit-msg" \
  "$ROOT_DIR/.husky/pre-push" \
  "$ROOT_DIR/scripts/commit.sh" \
  "$ROOT_DIR/scripts/pre-push-tests.sh" \
  "$ROOT_DIR/scripts/install-hooks.sh"

printf 'Git hooks installed from %s/.husky\n' "$ROOT_DIR"