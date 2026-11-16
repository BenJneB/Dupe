-- Titre propre d'un tome (PLAN_V4 phase 24) : « Les renforts maléfiques » pour
-- Kaamelott tome 9. Colonne facultative ; les droits (RLS par user_id) et le
-- trigger de server_updated_at de la table items s'appliquent tels quels.
-- À appliquer AVANT d'installer la version de l'appli qui envoie ce champ :
-- sinon la synchro des ouvrages est refusée (colonne inconnue).

alter table public.items add column if not exists volume_title text;
