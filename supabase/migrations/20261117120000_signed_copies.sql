-- Dédicaces (PLAN_V4 phase 31) : champs de dédicace sur les ouvrages et table des
-- photos d'un ouvrage (fichiers dans le bucket privé `covers`, comme les photos de
-- couverture). Mêmes règles que les autres tables (trigger, RLS par user_id).
-- À appliquer AVANT d'installer la version de l'appli qui synchronise ces champs :
-- sinon la synchro des ouvrages est refusée (colonnes / table inconnues).

alter table public.items add column if not exists is_signed boolean not null default false;
alter table public.items add column if not exists signed_by text;
alter table public.items add column if not exists signed_on timestamptz;
alter table public.items add column if not exists signed_place text;
alter table public.items add column if not exists signing_note text;

create table if not exists public.item_photos (
  id uuid primary key,
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz,
  server_updated_at timestamptz not null default now(),
  item_id uuid not null,
  url text not null,
  kind text not null default 'dedicace' check (kind in ('dedicace', 'autre')),
  position integer not null default 0
);

create index if not exists item_photos_user_sync_idx
  on public.item_photos (user_id, server_updated_at);

drop trigger if exists item_photos_sync on public.item_photos;
create trigger item_photos_sync before insert or update on public.item_photos
  for each row execute function public.dupe_sync_row();

alter table public.item_photos enable row level security;

drop policy if exists "own photos: read" on public.item_photos;
create policy "own photos: read" on public.item_photos
  for select to authenticated using ((select auth.uid()) = user_id);
drop policy if exists "own photos: insert" on public.item_photos;
create policy "own photos: insert" on public.item_photos
  for insert to authenticated with check ((select auth.uid()) = user_id);
drop policy if exists "own photos: update" on public.item_photos;
create policy "own photos: update" on public.item_photos
  for update to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

revoke all on public.item_photos from anon;
grant select, insert, update on public.item_photos to authenticated;
