#!/usr/bin/env bash
# commit-msg hook (lefthook.yml): the first line must be a conventional commit
#   type(scope)!: description     types: feat fix chore docs test refactor ci
# Merge / Revert / fixup! / squash! / amend! messages made by git are accepted.
# Usage: tool/check_commit_msg.sh <file containing the message>
set -euo pipefail

FILE="${1:?commit message file}"
# First line that is neither empty nor a git comment.
HEADER=$(grep -v '^#' "$FILE" | sed -n '/[^[:space:]]/{p;q;}' || true)
TYPES='feat|fix|chore|docs|test|refactor|ci'

case "$HEADER" in
  'Merge '*|'Revert '*|'fixup! '*|'squash! '*|'amend! '*) exit 0 ;;
esac

if [[ ! "$HEADER" =~ ^($TYPES)(\([a-z0-9._/-]+\))?!?:\ [^[:space:]] ]]; then
  {
    echo "Message de commit refusé : « $HEADER »"
    echo "Format attendu : type(portée facultative): description"
    echo "Types : ${TYPES//|/, }. Exemples :"
    echo "  feat(scan): lampe torche dans l'écran caméra"
    echo "  fix: la synchro reçoit les lignes commitées en retard"
  } >&2
  exit 1
fi
if (( ${#HEADER} > 100 )); then
  echo "Message de commit refusé : première ligne de ${#HEADER} caractères (100 au plus)" >&2
  exit 1
fi
