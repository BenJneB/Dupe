-- Photos de couverture prises par l'utilisateur : bucket privé.
-- Chemin : <user_id>/<item_id>.jpg ; chaque utilisateur n'accède qu'à son
-- dossier.

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('covers', 'covers', false, 5242880, array['image/jpeg', 'image/png'])
on conflict (id) do nothing;

create policy "own covers: read" on storage.objects for select to authenticated
  using (bucket_id = 'covers' and (storage.foldername(name))[1] = (select auth.uid())::text);
create policy "own covers: insert" on storage.objects for insert to authenticated
  with check (bucket_id = 'covers' and (storage.foldername(name))[1] = (select auth.uid())::text);
create policy "own covers: update" on storage.objects for update to authenticated
  using (bucket_id = 'covers' and (storage.foldername(name))[1] = (select auth.uid())::text);
