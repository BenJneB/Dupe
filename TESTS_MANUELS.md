# Dupe — Tests manuels

> Document autonome, à jour au **2026-11-14**. Dupe est une appli Flutter personnelle de catalogue de
> collection (mangas, BD, comics, livres) pour Android, Linux et Windows, avec synchro Supabase optionnelle.
> Contexte complet et état du projet : `PLAN_V2.md`.

Ce fichier liste ce que les **168 tests automatiques ne couvrent pas** : matériel (caméra, vibrations,
notifications, raccourci), services réels (Supabase, API GitHub, sources de métadonnées), plateformes non
compilées ici (Windows) et workflows GitHub (jamais exécutés).

**Statut au 2026-11-14 : aucun de ces tests n'a encore été fait.**

## Comment tester et rapporter
- Lancer : `flutter run -d <id> --dart-define-from-file=env.json` (`flutter devices` pour l'id), ou installer
  l'APK / l'AppImage / l'installateur d'une Release.
- Cocher `[x]` ce qui marche. En cas d'échec, noter à côté : **identifiant**, appareil, ce qui était attendu,
  ce qui s'est passé, et le contenu de **À propos → Journal → Copier** (les erreurs y sont enregistrées).
- Les identifiants (`S-03`, `Y-02`…) servent à citer un test dans une analyse ou un ticket.

## 0. Préalables (dans l'ordre)
- [ ] **P-01** Migrations Supabase appliquées (`supabase/migrations/`, README § Synchronisation).
- [ ] **P-02** Compte créé avant la v2 (par lien email, sans mot de passe) : **sur un appareil encore
      connecté**, Paramètres → *Mot de passe* → le définir. À faire avant toute déconnexion.
- [ ] **P-03** Secrets GitHub créés (README § Publier une version) ; décision prise pour la clé Comic Vine.

## 1. Scan — mode Magasin (téléphone)
- [ ] **M-01** La caméra s'ouvre ; l'autorisation n'est demandée qu'une fois.
- [ ] **M-02** Tome possédé → bandeau **vert** (badge « ×2 » s'il y a deux éditions).
- [ ] **M-03** Tome en envie → bandeau **jaune** ; « Je l'ai acheté » le fait passer au vert.
- [ ] **M-04** Tome manquant d'une série suivie → bandeau **bleu** (reconnu par série + numéro).
- [ ] **M-05** Ouvrage inconnu → bandeau **gris**, ajout possible.
- [ ] **M-06** Tome possédé sans ISBN : après un scan, « ISBN mémorisé » ; le scan suivant est instantané.
- [ ] **M-07** Hors ligne (mode avion) : les tomes déjà en base sont reconnus.
- [ ] **M-08** Code UPC de comic US → message d'aide.
- [ ] **M-09** (phase 13) Vibrations : 1 forte (vert), 2 moyennes (jaune), 3 légères (bleu), 1 brève (gris),
      au verdict final et une seule fois par scan. Si rien ne vibre : vérifier le retour haptique système.
- [ ] **M-10** (phase 13) Paramètres → Scan → couper « Vibrer selon le résultat » : plus de vibration.
- [ ] **M-11** (phase 13) Lampe torche : le bouton allume / éteint ; absent si le téléphone n'a pas de flash.
- [ ] **M-12** (phase 13) Raccourci : appui long sur l'icône → « Scanner » → scan en mode Magasin, depuis
      l'appli fermée comme ouverte. Critère de phase : vibration « déjà possédé » en moins de 3 s.
- [ ] **M-13** Garder le même livre devant la caméra : un seul verdict, une seule vibration.

## 2. Scan — mode Rafale (téléphone)
- [ ] **R-01** Plusieurs scans d'affilée : la file se remplit et se traite.
- [ ] **R-02** Fermer l'appli en cours de file, rouvrir : la file reprend.
- [ ] **R-03** Revue : correction d'une fiche, puis import en lot ; séries créées correctement.
- [ ] **R-04** (phase 13) 1 vibration légère par ajout ; 1 brève et « déjà dans la file » pour un doublon.

## 3. Prêts et notifications
- [ ] **N-01** Prêter un tome avec retour aujourd'hui ou demain → notification vers 10 h (inexacte, peut tarder).
- [ ] **N-02** Marquer rendu avant la date → pas de notification.
- [ ] **N-03** Redémarrer le téléphone avant la date → la notification vient quand même.
- [ ] **N-04** PC (Linux/Windows) : notification « prêts en retard » au démarrage, une fois par jour.

## 4. Photos, export, fichiers
- [ ] **F-01** Photo de couverture depuis la fiche : visible dans la grille ; sur l'autre appareil après synchro.
- [ ] **F-02** Export JSON et CSV → feuille de partage Android (Drive, Fichiers, email).
- [ ] **F-03** Le CSV s'ouvre correctement (accents) dans un tableur.
- [ ] **F-04** Import CSV depuis le téléphone (sélection de fichier).
- [ ] **F-05** PC : export/import via les fenêtres « Enregistrer sous » / « Ouvrir ».

## 5. Compte et synchro Supabase (téléphone + PC)
- [ ] **S-01** Connexion email + mot de passe sur chaque appareil ; mauvais mot de passe → « Email ou mot de
      passe incorrect ».
- [ ] **S-02** Créer un compte avec un autre email (si Supabase peut lui écrire) : lien de confirmation ouvert
      dans le navigateur, puis connexion OK ; avant confirmation → « pas encore confirmé ».
- [ ] **S-03** Le gestionnaire de mots de passe propose d'enregistrer le mot de passe.
- [ ] **S-04** Ajout sur le téléphone → visible sur le PC (≤ 30 s ou bouton synchro), et inversement.
- [ ] **S-05** **(critique, phase 9)** Après la mise à jour, la synchro reçoit toujours les changements de
      l'autre appareil : le filtre du pull a changé et n'a été testé que contre un faux serveur.
- [ ] **S-06** Même tome modifié des deux côtés hors ligne → la modification la plus récente gagne.
- [ ] **S-07** Modifier sur les deux appareils et synchroniser en même temps (bouton) : identiques à la fin.
- [ ] **S-08** Suppression propagée.
- [ ] **S-09** Icône d'état de synchro cohérente (en cours, hors ligne, à jour, erreur).

## 6. Journal et messages d'erreur (phase 9)
- [ ] **J-01** Mode avion puis synchro → une seule entrée « sync » même après plusieurs minutes.
- [ ] **J-02** « Copier » puis coller dans un message : texte lisible (date, niveau, source, message).
- [ ] **J-03** « Partager » : feuille de partage sur Android, « Enregistrer sous » sur PC.
- [ ] **J-04** Le journal est conservé après redémarrage de l'appli.
- [ ] **J-05** Messages en français à l'écran (hors ligne, fichier invalide, mauvais mot de passe).

## 7. Filets de sécurité (phase 11)
- [ ] **B-01** Supprimer un ouvrage puis « Annuler » : il revient, aussi sur l'autre appareil après synchro.
- [ ] **B-02** Supprimer une série puis « Annuler » : la série et ses tomes reviennent.
- [ ] **B-03** Paramètres → Sauvegardes automatiques : une hebdomadaire au premier lancement (collection non vide).
- [ ] **B-04** Import CSV de test → sauvegarde « Avant import CSV » → « Revenir à cette sauvegarde » : l'import
      disparaît, y compris sur l'autre appareil après synchro.
- [ ] **B-05** Ajouter un ouvrage sur l'autre appareil **sans synchroniser**, puis restaurer : il n'est pas
      supprimé (comportement attendu : synchroniser avant de restaurer).
- [ ] **B-06** Exporter une sauvegarde automatique puis la restaurer par fichier.

## 8. Plateformes et packaging
- [ ] **L-01** Linux : `packaging/linux/build_appimage.sh` → l'AppImage se lance, icône dans la fenêtre.
- [ ] **W-01** Windows : `flutter build windows --release --dart-define-from-file=env.json` compile
      (sinon : job `windows` de la CI).
- [ ] **W-02** Windows : installateur ; installation sans droits administrateur ; mise à jour par-dessus.
- [ ] **W-03** Windows : icône, notifications de retard, dialogues de fichiers, synchro.
- [ ] **A-01** APK signé (clé `keytool` + `android/key.properties`, README) : installation OK.
- [ ] **A-02** Une version plus récente s'installe par-dessus sans perte de données.
- [ ] **A-03** Icône adaptative correcte sur l'écran d'accueil.

## 9. CI, Releases et mises à jour (phase 12)
- [ ] **Y-01** Après le push : onglet *Actions* → `CI` vert, y compris le job **windows** (premier essai).
- [ ] **Y-02** `git tag v1.0.0 && git push origin v1.0.0` → Release avec 3 APK, l'AppImage et
      `Dupe-1.0.0-setup.exe`.
- [ ] **Y-03** Installé en v1.0.0 alors que v1.0.1 existe : « Version 1.0.1 disponible — Télécharger » au
      démarrage ; le bouton ouvre le bon fichier (APK de l'architecture du téléphone, AppImage, installateur).
- [ ] **Y-04** Paramètres → Mises à jour → « Rechercher une mise à jour » ; désactiver le signalement.
- [ ] **Y-05** Workflow `Keep Supabase awake` lancé à la main (*Run workflow*) → vert.
- [ ] **Y-06** Pas d'email d'avertissement de pause de Supabase dans les semaines suivantes (question ouverte :
      une requête refusée par la RLS compte-t-elle comme activité ?).

## 10. Données réelles
- [ ] **D-01** Import de la collection (CSV Mangacollec / CLZ / tableur) : correspondance des colonnes devinée.
- [ ] **D-02** Réimporter le même fichier n'ajoute rien.
- [ ] **D-03** Sauvegarde JSON → restauration sur un autre appareil vide.
- [ ] **D-04** Statistiques plausibles (dépenses, valeur, tomes lus, séries complètes).
- [ ] **D-05** Mode sombre lisible partout (bandeaux du scan, graphique).
