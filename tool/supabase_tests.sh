#!/usr/bin/env bash
# Runs the tests tagged `supabase` against a LOCAL Supabase (Docker), never the
# remote project. Starts it if needed (migrations of supabase/migrations/).
# Usage (project root): tool/supabase_tests.sh [extra flutter test args]
# Needs: Docker usable without sudo, Supabase CLI 2.122.1 (installed, or run
# through npx at the same pinned version), psql (README).
set -euo pipefail

CLI_VERSION=2.122.1
supabase_cli() {
  if command -v supabase > /dev/null; then supabase "$@"
  else npx -y "supabase@$CLI_VERSION" "$@"; fi
}

cd "$(dirname "$0")/.."
supabase_cli status > /dev/null 2>&1 || supabase_cli start
# API_URL, ANON_KEY, DB_URL… of the local stack (well-known local values).
eval "$(supabase_cli status -o env)"
case "$API_URL" in
  http://127.0.0.1:*|http://localhost:*) ;;
  *) echo "Refusing to test against $API_URL: local Supabase only" >&2; exit 1 ;;
esac
SUPABASE_TEST_URL="$API_URL" \
SUPABASE_TEST_ANON_KEY="$ANON_KEY" \
SUPABASE_TEST_DB_URL="$DB_URL" \
  flutter test -P supabase "$@"
