-- Couvertures refusées synchronisées (2026-11-20) : images proposées que
-- l'utilisateur a refusées pour un ouvrage (clés d'image normalisées : id Google
-- Books, id / ISBN Open Library, sinon hôte + chemin). Une image refusée n'est
-- plus proposée pour cet ouvrage ; d'autres images peuvent l'être. Les droits (RLS
-- par user_id) et le trigger de server_updated_at de la table items s'appliquent
-- tels quels.
-- À appliquer AVANT d'installer la version de l'appli qui envoie ce champ :
-- sinon la synchro des ouvrages est refusée (colonne inconnue).

alter table public.items
  add column if not exists refused_covers jsonb not null default '[]';
