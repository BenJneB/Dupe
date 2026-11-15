#!/usr/bin/env bash
# Release notes (Markdown) of <tag> from the conventional commits since the
# previous stable tag (pre-release tags vX.Y.Z-suffix are skipped as a base).
# Used by release.yml as the description of the GitHub release.
# Usage: tool/ci/release_notes.sh v1.2.0
set -euo pipefail

TAG="${1:?tag like v1.2.0}"
PREVIOUS=$(git describe --tags --abbrev=0 --match 'v[0-9]*' --exclude '*-*' \
  "$TAG^" 2>/dev/null || true)
RANGE="${PREVIOUS:+$PREVIOUS..}$TAG"

if [ -n "$PREVIOUS" ]; then
  echo "## Changements depuis $PREVIOUS"
else
  echo "## Première version"
fi

git log --no-merges --reverse --format='%s' "$RANGE" | awk '
  BEGIN {
    n = split("feat fix refactor docs test ci chore other", order, " ")
    title["feat"] = "Nouveautés"; title["fix"] = "Corrections"
    title["refactor"] = "Remaniements"; title["docs"] = "Documentation"
    title["test"] = "Tests"; title["ci"] = "Intégration continue"
    title["chore"] = "Maintenance"; title["other"] = "Autres changements"
  }
  {
    line = $0
    if (match(line, /^(feat|fix|refactor|docs|test|ci|chore)(\([^)]*\))?!?: /)) {
      head = substr(line, 1, RLENGTH - 2); text = substr(line, RLENGTH + 1)
      type = head; sub(/[(!].*/, "", type)
      scope = ""
      if (match(head, /\([^)]*\)/)) scope = substr(head, RSTART + 1, RLENGTH - 2)
      breaking = (head ~ /!$/) ? "⚠️ " : ""
      entry = breaking (scope != "" ? "**" scope "** : " : "") text
    } else {
      type = "other"; entry = line
    }
    items[type] = items[type] "- " entry "\n"
  }
  END {
    for (i = 1; i <= n; i++) {
      t = order[i]
      if (t in items) printf "\n### %s\n\n%s", title[t], items[t]
    }
  }'
