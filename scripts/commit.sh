#!/usr/bin/env bash
set -euo pipefail

MESSAGE_FILE="${1:-}"
SOURCE="${2:-}"

if [[ -z "$MESSAGE_FILE" ]]; then
  exit 0
fi

case "$SOURCE" in
  message|merge|squash|commit)
    exit 0
    ;;
esac

if [[ ! -t 0 ]]; then
  exit 0
fi

TYPES=(
  'feat - a new feature'
  'fix - a bug fix'
  'docs - documentation only'
  'style - formatting without behavior changes'
  'refactor - code restructuring without behavior changes'
  'perf - a performance improvement'
  'test - adding or correcting tests'
  'build - build system or dependency changes'
  'ci - CI configuration changes'
  'chore - maintenance work'
  'revert - reverting a previous commit'
)

printf '%s\n' 'Select the type of change:'
INDEX=1
for LABEL in "${TYPES[@]}"; do
  printf '%2d) %s\n' "$INDEX" "$LABEL"
  INDEX=$((INDEX + 1))
done

while true; do
  if ! read -r -p 'Type (1-11): ' CHOICE; then
    printf '\n%s\n' 'No type selected. Commit aborted.' >&2
    exit 1
  fi

  case "$CHOICE" in
    1) TYPE=feat ;;
    2) TYPE=fix ;;
    3) TYPE=docs ;;
    4) TYPE=style ;;
    5) TYPE=refactor ;;
    6) TYPE=perf ;;
    7) TYPE=test ;;
    8) TYPE=build ;;
    9) TYPE=ci ;;
    10) TYPE=chore ;;
    11) TYPE=revert ;;
    *)
      printf '%s\n' 'Invalid selection.'
      continue
      ;;
  esac
  break
done

if ! read -r -p 'Comment: ' COMMENT; then
  printf '\n%s\n' 'Comment is required. Commit aborted.' >&2
  exit 1
fi
if [[ -z "${COMMENT//[[:space:]]/}" ]]; then
  printf '%s\n' 'Comment cannot be empty. Commit aborted.' >&2
  exit 1
fi

printf '%s: %s\n' "$TYPE" "$COMMENT" > "$MESSAGE_FILE"