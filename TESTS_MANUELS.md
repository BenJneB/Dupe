# Tests manuels

Ce que les tests automatiques ne couvrent pas : matériel (caméra, notifications), services réels
(Supabase, API), packaging. À cocher au fil des essais ; noter le problème à côté si ça casse.

Lancer : `flutter run -d <id> --dart-define-from-file=env.json` (`flutter devices` pour l'id).

## Téléphone Android

### Scan — mode Magasin
- [ ] La caméra s'ouvre, l'autorisation est demandée une seule fois.
- [ ] Tome possédé → bandeau **vert** (et « ×2 » / autre édition pour Dreamland 1-10).
- [ ] Tome en envie → bandeau **jaune** ; « Je l'ai acheté » le fait passer au vert.
- [ ] Tome manquant d'une série suivie → bandeau **bleu** (reconnu par série + numéro).
- [ ] Ouvrage inconnu → bandeau **gris**, ajout possible.
- [ ] Tome possédé sans ISBN : après un scan, « ISBN mémorisé », le scan suivant est instantané.
- [ ] Hors ligne (mode avion) : les tomes déjà en base sont reconnus.
- [ ] Code UPC de comic US → message d'aide.

### Scan — mode Rafale
- [ ] Plusieurs scans d'affilée, la file se remplit et se traite.
- [ ] Fermer l'appli en cours de file, rouvrir : la file reprend.
- [ ] Revue : correction d'une fiche, puis import en lot ; séries créées correctement.

### Prêts et notifications
- [ ] Prêter un tome avec date de retour = aujourd'hui ou demain → notification vers 10 h (inexacte, peut tarder).
- [ ] Marquer rendu avant la date → la notification ne vient pas.
- [ ] Redémarrer le téléphone avant la date → la notification vient quand même.

### Photo de couverture
- [ ] Prendre une photo depuis la fiche, elle s'affiche dans la grille.
- [ ] Après synchro, elle apparaît sur l'autre appareil.

### Export / partage
- [ ] Export JSON et CSV → feuille de partage Android (Drive, Fichiers, email).
- [ ] Le CSV s'ouvre correctement (accents) dans un tableur.
- [ ] Import CSV depuis le téléphone (sélection de fichier).

### APK signé
- [ ] Clé créée (`keytool`, voir README) + `android/key.properties`.
- [ ] `flutter build apk --release --split-per-abi --dart-define-from-file=env.json` → installation OK.
- [ ] Une 2e version s'installe par-dessus sans perdre les données.
- [ ] Icône adaptative correcte sur l'écran d'accueil.

## Synchro Supabase (téléphone + PC)
- [ ] Migrations appliquées sur le projet (`supabase/migrations/`).
- [ ] **Avant tout** (compte créé par lien, sans mot de passe) : sur un appareil encore connecté,
      Paramètres → Mot de passe → définir le mot de passe.
- [ ] Connexion email + mot de passe sur chaque appareil ; mauvais mot de passe → « Email ou mot de passe incorrect ».
- [ ] Créer un compte avec un autre email (si l'adresse peut recevoir l'email de Supabase) : lien de
      confirmation ouvert dans le navigateur, puis connexion OK ; avant confirmation → « pas encore confirmé ».
- [ ] Le gestionnaire de mots de passe (Android / navigateur) propose d'enregistrer le mot de passe.
- [ ] Ajout sur le téléphone → visible sur le PC (≤ 30 s ou bouton synchro), et inversement.
- [ ] Même tome modifié des deux côtés hors ligne → la modification la plus récente gagne.
- [ ] Suppression propagée.
- [ ] Icône d'état de synchro cohérente (en cours, erreur hors ligne, à jour).
- [ ] (Phase 9) Après mise à jour de l'appli, la synchro tire toujours les changements de l'autre appareil :
      le filtre du pull a changé (horodatage + id), il n'est vérifiable que sur le vrai Supabase.
- [ ] (Phase 9) Modifier des ouvrages sur les deux appareils et synchroniser en même temps (bouton) :
      les deux finissent identiques.

## Journal d'erreurs (phase 9)
- [ ] À propos → Journal : mode avion puis synchro → une seule entrée « sync » même après plusieurs minutes.
- [ ] « Copier » puis coller dans un message : texte lisible (date, niveau, source, message).
- [ ] « Partager » : feuille de partage sur Android, « Enregistrer sous » sur PC.
- [ ] Le journal est conservé après redémarrage de l'appli.
- [ ] Les messages d'erreur à l'écran sont en français (hors ligne, fichier invalide, code de connexion faux).

## PC Linux
- [ ] `packaging/linux/build_appimage.sh` → l'AppImage se lance, icône dans la fenêtre.
- [ ] Notification « prêts en retard » au démarrage, une seule fois par jour.
- [ ] Export/import via les fenêtres « Enregistrer sous » / « Ouvrir ».

## PC Windows (non vérifié depuis Linux)
- [ ] `flutter build windows --release --dart-define-from-file=env.json` compile.
- [ ] `ISCC.exe packaging\windows\dupe.iss` → installateur ; installation sans droits admin.
- [ ] Icône, notifications de retard, dialogues de fichiers, synchro.

## Filets de sécurité (phase 11)
- [ ] Supprimer un ouvrage puis « Annuler » : il revient, aussi sur l'autre appareil après synchro.
- [ ] Supprimer une série puis « Annuler » : la série et ses tomes reviennent.
- [ ] Paramètres → Sauvegardes automatiques : une hebdomadaire apparaît au premier lancement (collection non vide).
- [ ] Import CSV de test → sauvegarde « Avant import CSV » → « Revenir à cette sauvegarde » : l'import disparaît,
      y compris sur l'autre appareil après synchro.
- [ ] Ajouter un ouvrage sur l'autre appareil **sans synchroniser**, puis restaurer : il n'est pas supprimé (la
      restauration ne connaît que ce que l'appareil a vu). Synchroniser avant de restaurer.
- [ ] Exporter une sauvegarde automatique (partage / Enregistrer sous) puis la restaurer par fichier.

## Données réelles
- [ ] Import de ma collection (CSV Mangacollec / CLZ / tableur) : correspondance des colonnes devinée correctement.
- [ ] Réimporter le même fichier n'ajoute rien.
- [ ] Sauvegarde JSON → restauration sur un autre appareil vide.
- [ ] Statistiques plausibles (dépenses, valeur, tomes lus, séries complètes).
- [ ] Mode sombre lisible partout (bandeaux du scan, graphique).
