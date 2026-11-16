-- Suggestions écartées (« Pas intéressé », PLAN_V4 phase 30), synchronisées pour
-- qu'une suggestion écartée sur un appareil ne revienne pas sur l'autre.
-- Mêmes règles que les autres tables : server_updated_at par trigger, dernier
-- updated_at gagnant, lignes de l'utilisateur seulement (RLS).
-- À appliquer AVANT d'installer la version de l'appli qui synchronise cette table :
-- sinon la synchro échoue (table inconnue).

create table if not exists public.recommendation_feedback (
  id uuid primary key,
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz,
  server_updated_at timestamptz not null default now(),
  suggestion_key text not null,
  reason_kind text not null,
  reason_key text not null
);

create index if not exists recommendation_feedback_user_sync_idx
  on public.recommendation_feedback (user_id, server_updated_at);

drop trigger if exists recommendation_feedback_sync on public.recommendation_feedback;
create trigger recommendation_feedback_sync
  before insert or update on public.recommendation_feedback
  for each row execute function public.dupe_sync_row();

alter table public.recommendation_feedback enable row level security;

drop policy if exists "own feedback: read" on public.recommendation_feedback;
create policy "own feedback: read" on public.recommendation_feedback
  for select to authenticated using ((select auth.uid()) = user_id);
drop policy if exists "own feedback: insert" on public.recommendation_feedback;
create policy "own feedback: insert" on public.recommendation_feedback
  for insert to authenticated with check ((select auth.uid()) = user_id);
drop policy if exists "own feedback: update" on public.recommendation_feedback;
create policy "own feedback: update" on public.recommendation_feedback
  for update to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

revoke all on public.recommendation_feedback from anon;
grant select, insert, update on public.recommendation_feedback to authenticated;
