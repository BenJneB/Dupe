-- Keep-alive (PLAN_V3 phase 16). Supabase pauses Free projects after 7 days of
-- low database activity. .github/workflows/keep-alive.yml calls this function
-- once a day through PostgREST (POST /rest/v1/rpc/keep_alive): a real query on
-- the database, which returns the server time and exposes no data.
create or replace function public.keep_alive()
returns timestamptz
language sql
stable
security definer
set search_path = ''
as $$ select pg_catalog.now() $$;

comment on function public.keep_alive() is
  'Daily ping from GitHub Actions so that the Free project is not paused.';

-- Only this function is callable without signing in; it reads no table.
revoke all on function public.keep_alive() from public;
grant execute on function public.keep_alive() to anon, authenticated;
