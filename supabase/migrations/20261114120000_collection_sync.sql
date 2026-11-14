-- Dupe: schéma de synchronisation (miroir des tables SQLite locales).
--
-- SQLite est la source de vérité ; ce schéma est une réplique par
-- utilisateur. Règles (PLAN.md §6) :
--   * RLS : chaque utilisateur ne voit et n'écrit que ses lignes
--     (user_id = auth.uid()). Pas de DELETE : suppression logique
--     (deleted_at), indispensable pour propager les suppressions.
--   * server_updated_at : horodatage serveur posé par trigger, sert de
--     curseur de synchro (les horloges des appareils peuvent dériver).
--   * Dernière écriture gagnante : une écriture plus ancienne (updated_at
--     client) que la ligne existante est ignorée.
--   * Pas de clés étrangères entre tables : l'ordre d'arrivée des lignes
--     d'une synchro à l'autre n'est pas garanti (réplique, pas référentiel).

create table public.series (
  id uuid primary key,
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz,
  server_updated_at timestamptz not null default now(),
  type text not null check (type in ('manga', 'bd', 'comic', 'livre')),
  title text not null,
  original_title text,
  authors jsonb not null default '[]',
  publisher text,
  collection text,
  status_publication text not null default 'inconnue'
    check (status_publication in ('en_cours', 'terminee', 'inconnue')),
  total_volumes integer,
  cover_url text,
  description text,
  external_ids jsonb not null default '{}',
  followed boolean not null default true,
  notes text
);

create table public.items (
  id uuid primary key,
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz,
  server_updated_at timestamptz not null default now(),
  series_id uuid,
  type text not null check (type in ('manga', 'bd', 'comic', 'livre')),
  title text not null,
  volume_number text,
  isbn13 text,
  upc text,
  authors jsonb not null default '[]',
  publisher text,
  edition text,
  format text,
  publish_date text,
  page_count integer,
  language text,
  cover_url text,
  description text,
  ownership text not null default 'possede'
    check (ownership in ('possede', 'envie')),
  reading_status text not null default 'non_lu'
    check (reading_status in ('non_lu', 'en_cours', 'lu', 'abandonne')),
  read_date timestamptz,
  rating integer check (rating between 0 and 5),
  is_first_edition boolean not null default false,
  is_variant boolean not null default false,
  condition text,
  purchase_price double precision,
  purchase_date timestamptz,
  cover_price double precision,
  estimated_value double precision,
  currency text not null default 'EUR',
  wishlist_priority integer,
  wishlist_max_price double precision,
  location text,
  notes text,
  source text,
  source_id text
);

create table public.loans (
  id uuid primary key,
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz,
  server_updated_at timestamptz not null default now(),
  item_id uuid not null,
  borrower_name text not null,
  loaned_at timestamptz not null,
  due_at timestamptz,
  returned_at timestamptz,
  notes text
);

-- Pull query: changes of one user since a cursor.
create index series_user_sync_idx on public.series (user_id, server_updated_at);
create index items_user_sync_idx on public.items (user_id, server_updated_at);
create index loans_user_sync_idx on public.loans (user_id, server_updated_at);

-- Server timestamp + last-write-wins on updated_at (client time).
create function public.dupe_sync_row() returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if tg_op = 'UPDATE' then
    if new.updated_at < old.updated_at then
      return null; -- older write: keep the newer row
    end if;
    new.user_id := old.user_id; -- a row never changes owner
  end if;
  new.server_updated_at := clock_timestamp();
  return new;
end;
$$;

create trigger series_sync before insert or update on public.series
  for each row execute function public.dupe_sync_row();
create trigger items_sync before insert or update on public.items
  for each row execute function public.dupe_sync_row();
create trigger loans_sync before insert or update on public.loans
  for each row execute function public.dupe_sync_row();

alter table public.series enable row level security;
alter table public.items enable row level security;
alter table public.loans enable row level security;

create policy "own series: read" on public.series for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "own series: insert" on public.series for insert to authenticated
  with check ((select auth.uid()) = user_id);
create policy "own series: update" on public.series for update to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

create policy "own items: read" on public.items for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "own items: insert" on public.items for insert to authenticated
  with check ((select auth.uid()) = user_id);
create policy "own items: update" on public.items for update to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

create policy "own loans: read" on public.loans for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "own loans: insert" on public.loans for insert to authenticated
  with check ((select auth.uid()) = user_id);
create policy "own loans: update" on public.loans for update to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

-- No grants to anon: the app only syncs once signed in.
revoke all on public.series, public.items, public.loans from anon;
grant select, insert, update on public.series, public.items, public.loans to authenticated;
