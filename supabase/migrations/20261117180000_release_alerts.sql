-- Alertes de nouveautés (PLAN_V4 phase 33) : nouveautés trouvées (une alerte traitée
-- sur un appareil ne revient pas sur l'autre ; id dérivé du contenu, donc une même
-- nouveauté trouvée sur deux appareils = une seule ligne) et auteurs suivis.
-- Mêmes règles que les autres tables (trigger, RLS par user_id).
-- À appliquer AVANT d'installer la version de l'appli qui synchronise ces tables :
-- sinon la synchro échoue (tables inconnues).

create table if not exists public.release_alerts (
  id uuid primary key,
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz,
  server_updated_at timestamptz not null default now(),
  key text not null,
  kind text not null check (kind in ('serie', 'auteur')),
  type text not null check (type in ('manga', 'bd', 'comic', 'livre')),
  title text not null,
  status text not null default 'nouveau'
    check (status in ('nouveau', 'vu', 'ignore', 'ajoute')),
  series_id uuid,
  volume_number text,
  author_name text,
  authors jsonb not null default '[]',
  isbn13 text,
  publisher text,
  publish_date text,
  cover_url text
);

create table if not exists public.followed_authors (
  id uuid primary key,
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz,
  server_updated_at timestamptz not null default now(),
  name text not null
);

create index if not exists release_alerts_user_sync_idx
  on public.release_alerts (user_id, server_updated_at);
create index if not exists followed_authors_user_sync_idx
  on public.followed_authors (user_id, server_updated_at);

drop trigger if exists release_alerts_sync on public.release_alerts;
create trigger release_alerts_sync before insert or update on public.release_alerts
  for each row execute function public.dupe_sync_row();
drop trigger if exists followed_authors_sync on public.followed_authors;
create trigger followed_authors_sync before insert or update on public.followed_authors
  for each row execute function public.dupe_sync_row();

alter table public.release_alerts enable row level security;
alter table public.followed_authors enable row level security;

drop policy if exists "own alerts: read" on public.release_alerts;
create policy "own alerts: read" on public.release_alerts
  for select to authenticated using ((select auth.uid()) = user_id);
drop policy if exists "own alerts: insert" on public.release_alerts;
create policy "own alerts: insert" on public.release_alerts
  for insert to authenticated with check ((select auth.uid()) = user_id);
drop policy if exists "own alerts: update" on public.release_alerts;
create policy "own alerts: update" on public.release_alerts
  for update to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

drop policy if exists "own authors: read" on public.followed_authors;
create policy "own authors: read" on public.followed_authors
  for select to authenticated using ((select auth.uid()) = user_id);
drop policy if exists "own authors: insert" on public.followed_authors;
create policy "own authors: insert" on public.followed_authors
  for insert to authenticated with check ((select auth.uid()) = user_id);
drop policy if exists "own authors: update" on public.followed_authors;
create policy "own authors: update" on public.followed_authors
  for update to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

revoke all on public.release_alerts, public.followed_authors from anon;
grant select, insert, update on public.release_alerts, public.followed_authors
  to authenticated;
