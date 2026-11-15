#!/usr/bin/env bash
# Prints the line coverage of hand-written code from coverage/lcov.info
# (generated code excluded: *.g.dart, *.freezed.dart, *.drift.dart, l10n/gen).
# Usage: tool/ci/coverage_summary.sh [lcov.info]   (Markdown, for the job summary)
set -euo pipefail
export LC_NUMERIC=C

LCOV="${1:-coverage/lcov.info}"
[ -f "$LCOV" ] || { echo "No $LCOV: run flutter test --coverage" >&2; exit 1; }
awk '
  /^SF:/ { file = substr($0, 4)
           skip = (file ~ /\.(g|freezed|drift)\.dart$/ || file ~ /\/l10n\/gen\//) }
  /^LF:/ { if (!skip) found += substr($0, 4) }
  /^LH:/ { if (!skip) hit += substr($0, 4) }
  END {
    if (found == 0) { print "No coverage data"; exit 1 }
    printf "### Couverture des tests\n\n"
    printf "**%.1f %%** des lignes du code écrit à la main (%d / %d), hors code généré.\n", \
      100 * hit / found, hit, found
  }' "$LCOV"
