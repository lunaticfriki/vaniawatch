#!/usr/bin/env sh
set -u

ROOT="$(git rev-parse --show-toplevel)"
FAILED=""

has_tests() {
  [ -d test ] && [ -n "$(find test -name '*_test.dart' -print -quit)" ]
}

pub_get() {
  if git ls-files --error-unmatch pubspec.lock >/dev/null 2>&1; then
    "$1" pub get --enforce-lockfile
  else
    "$1" pub get
  fi
}

check_package() {
  dir="$1"
  tool="$2"
  if [ ! -f "$ROOT/$dir/pubspec.yaml" ]; then
    echo "· $dir: no pubspec.yaml, skipped"
    return 0
  fi
  echo "▶ $dir"
  (
    cd "$ROOT/$dir" &&
      pub_get "$tool" >/dev/null &&
      dart format --output=none --set-exit-if-changed . &&
      "$tool" analyze --fatal-infos &&
      if has_tests; then "$tool" test; else echo "· $dir: no tests yet"; fi
  ) || FAILED="$FAILED $dir"
}

echo "▶ docs"
node "$ROOT/scripts/docs/check.mjs" || FAILED="$FAILED docs"

check_package core dart
check_package backend dart
check_package frontend flutter

if [ -n "$FAILED" ]; then
  echo "✗ Checks failed in:$FAILED"
  exit 1
fi

echo "✓ All checks passed"
