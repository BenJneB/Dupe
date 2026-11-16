#!/usr/bin/env bash
# Regenerates the generated code (build_runner, l10n) and fails when it
# differs from what git holds: in CI (stale file committed) and in the
# pre-commit hook (regenerated file not staged). Only generated paths are
# looked at, so other unstaged work never fails the check.
# Usage: tool/ci/check_generated.sh
set -euo pipefail

GENERATED=('*.g.dart' '*.freezed.dart' '*.drift.dart' 'lib/l10n/gen')

dart run build_runner build -d > /dev/null
flutter gen-l10n > /dev/null

# Second status column: changed in the working tree (or untracked) compared
# with the index.
STALE=$(git status --porcelain -- "${GENERATED[@]}" | awk 'substr($0, 2, 1) != " "')
if [ -n "$STALE" ]; then
  echo "Generated code out of date or not staged:" >&2
  echo "$STALE" >&2
  echo "Run 'dart run build_runner build -d' and 'flutter gen-l10n', then stage these files." >&2
  exit 1
fi
