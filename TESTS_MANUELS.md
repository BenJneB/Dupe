# Dupe — Tests manuels

> Document autonome, à jour au **2026-11-15**. Dupe est une appli Flutter personnelle de catalogue de
> collection (mangas, BD, comics, livres) pour Android, Linux et Windows, avec synchro Supabase optionnelle.
> Contexte : `PLAN_V2.md` (phases 9-13) et `PLAN_V3.md`. Une petite partie de ces tests est faite **maintenant**
> (phase 14, vérifications de base) ; tout le reste l'est à la fin (**phase 21, recette finale**), sur la version
> finale. Les phases 15 à 20 ajoutent leurs tests ici et marquent « automatisé (phase N) » ceux que leurs tests
> automatiques couvrent désormais.

Ce fichier liste ce que les **270 tests automatiques (et 4 parcours d'intégration) ne couvrent pas** : matériel (caméra, vibrations,
notifications, raccourci), services réels (Supabase, API GitHub, sources de métadonnées), plateformes non
compilées ici (Windows) et workflows GitHub (jamais exécutés).

**Statut au 2026-11-14 : phase 14 close (`Y-01`, `P-01`, `P-04` faits ; le reste reporté en phase 21).**

## Comment tester et rapporter
- Lancer : `flutter run -d <id> --dart-define-from-file=env.json` (`flutter devices` pour l'id), ou installer
  l'APK / l'AppImage / l'installateur d'une Release.
- **Deux « appareils » sur un seul PC Linux** (synchro sans téléphone) : l'appli accepte plusieurs instances
  et range ses données sous `$XDG_DATA_HOME`. Après `flutter build linux --debug --dart-define-from-file=env.json` :
  `build/linux/x64/debug/bundle/dupe &` puis
  `XDG_DATA_HOME=$HOME/.dupe-appareil2 build/linux/x64/debug/bundle/dupe` (second appareil, vide au départ ;
  le supprimer ensuite avec `rm -rf ~/.dupe-appareil2`).
- Cocher `[x]` ce qui marche. En cas d'échec, noter à côté : **identifiant**, appareil, ce qui était attendu,
  ce qui s'est passé, et le contenu de **À propos → Journal → Copier** (les erreurs y sont enregistrées).
- Les identifiants (`S-03`, `Y-02`…) servent à citer un test dans une analyse ou un ticket. Ils ne sont
  jamais renumérotés ; un test ajouté prend le numéro suivant de sa section.
- **Suivi** (une note par test, à la fin de sa ligne) : `— OK 2026-11-20 (Pixel 7)`,
  `— ÉCHEC 2026-11-20 (Pixel 7) : …`, ou `— ÉCART ACCEPTÉ : …` (critère de fin des phases 14 et 21 : chacun
  de leurs tests est OK, automatisé ou a un écart documenté et accepté).

## Phase 14 — vérifications de base (close le 2026-11-14)
Faits : `Y-01` (CI), `P-01` (schéma), `P-04` (compte créé ; `P-02` sans objet). Tout le reste de la phase 14
est **reporté en tête de la phase 21** (décision de l'utilisateur, 2026-11-14), voir ci-dessous.

## Phase 21 — ordre conseillé pour la recette finale
Tous les tests non faits en phase 14 et non marqués « automatisé ». Le but : lancer tôt ce qui prend du temps
à lui seul, et tester d'abord ce dont dépendent les autres tests.

**0. D'abord, les tests reportés de la phase 14 (à ne pas oublier)**, dans cet ordre :
   - `J-02` — journal : relancer l'appli, ouvrir À propos → Journal, « Copier » (écran vu vide le 2026-11-14
     alors que le fichier contenait une entrée).
   - `S-01`, `S-05`, `S-04` — connexion sur un deuxième appareil, puis synchro réelle dans les deux sens
     (deux instances Linux suffisent, voir « Comment tester »).
   - `P-03` — secrets GitHub ; `Y-02` — Release de test `v0.0.1-test`, puis la supprimer avec son tag.
   - `A-01` — installer l'APK de cette Release sur le téléphone ; `M-01`, `M-02` — caméra et livre possédé.
1. **Lancer ce qui tourne seul** : publier une première version **stable** (ex. `v0.1.0`) et l'installer
   partout ; prêter un tome avec retour demain (`N-01`, vérifié le lendemain) ; `Y-05`.
2. **Compte** : `S-10`, `S-11`, `S-12` (et `S-01` rapidement sur la version finale).
3. **Synchro** (bloquante pour `B-01`, `B-04`, `F-01`) : `S-05` et `S-04` revérifiés sur la version finale,
   puis `S-06` à `S-09`.
4. **Journal** : `J-01`, `J-03` à `J-05`.
5. **Téléphone, à la maison avec quelques livres** : `M-01` à `M-14`, puis `R-01` à `R-04`.
6. **Fichiers et filets de sécurité** : `F-01` à `F-05`, `B-01` à `B-08`, puis seulement `D-01` (import de la
   vraie collection, protégé par la sauvegarde « Avant import »), `D-02` à `D-05`.
7. **Plateformes** : `A-03`, `L-01`, `W-01` à `W-03` (PC Windows) ; puis une deuxième version stable (ex.
   `v0.1.1`) pour `A-02`, `Y-03`, `Y-04`, `Y-07`, `Y-08` (une *pre-release* n'est pas vue par la vérification
   des mises à jour).
7b. **Clés des sources** (sur une version publiée) : `K-01` à `K-05`.
7c. **CI et Dependabot** : `P-05`, `P-06`, puis `Y-05`, `Y-09` à `Y-12`, `Y-14`.
7d. **Horloge** (phase 17) : `S-13`.
7e. **Hooks et intégration** (phase 18) : `H-01` à `H-04`, `Y-15`.
7f. **Widget et dictée** (phase 19, téléphone) : `G-01` à `G-04`, `V-01` à `V-04`.
7g. **Couvertures, stats, envies** (phase 20) : `O-01` à `O-04` (`O-02` en mode avion), `T-01`, `T-02`,
   `E-01` à `E-03`.
7h. **Retours de recette Android** (2026-11-15, téléphone + vraie collection) : `Q-01` à `Q-11`.
8. **Le lendemain / plus tard** : `N-01` à `N-04` ; `M-12` chronométré en magasin ; `Y-06` (observation sur
   plusieurs semaines) ; `J-06` (facultatif, met le projet en pause).

## 0. Préalables (dans l'ordre)
- [x] **P-01** Migrations Supabase appliquées (`supabase/migrations/`, README § Synchronisation).
      — OK 2026-11-14 (tableau de bord : tables et bucket présents)
- [x] **P-02** Compte créé avant la v2 (par lien email, sans mot de passe) : installer la nouvelle version
      **par-dessus, sans se déconnecter** (la session doit survivre à la mise à jour), puis Paramètres →
      *Mot de passe* → le définir. À faire avant toute déconnexion, sinon le compte reste bloqué.
      — ÉCART ACCEPTÉ 2026-11-14 : sans objet, l'utilisateur ne s'était jamais connecté (aucun compte, aucune
      donnée serveur). Remplacé par `P-04`.
- [x] **P-04** Créer le compte dans l'appli : Paramètres → *Se connecter* → *Créer un compte* (email, mot de
      passe deux fois). Avec *Confirm email* activé : ouvrir le lien reçu, puis se connecter. Si « Un compte
      existe déjà » : supprimer l'utilisateur sans données dans Authentication → Users et recommencer.
      La collection locale est envoyée sur le compte. Le lien de confirmation redirige vers `localhost:3000`
      (*Site URL* par défaut) : page en erreur, mais l'adresse est confirmée (observé le 2026-11-14 ; message
      de l'appli précisé en conséquence).
      — OK 2026-11-14 (Linux) : compte créé, lien confirmé, connexion réussie.
- [x] **P-05** (phase 16) Migration `20261115090000_keep_alive.sql` appliquée (fonction `keep_alive()`).
      — OK 2026-11-15 : migration appliquée dans le SQL Editor du projet.
- [ ] **P-06** (phase 16) `.github/dependabot.yml` présent sur la branche par défaut (Dependabot ne lit sa
      configuration que là). Branche par défaut = `dev` depuis le 2026-11-15, qui contient le fichier : **probablement
      levé** ; à confirmer dans Insights → Dependency graph → Dependabot (dernière vérification sans erreur).
- [x] **P-07** (phase 17) Docker utilisable sans sudo, Supabase CLI 2.122.1 et `psql` installés ;
      `tool/supabase_tests.sh` passe (README « Tests de synchro contre un Supabase local »).
      — OK 2026-11-14 (Linux) : accès Docker donné, CLI via `npx` (sans installation), 8 tests verts.
- [x] **P-03** *(reporté en phase 21)* Secrets GitHub créés (README § Publier une version) ; décision prise pour la clé Comic Vine.
      — OK 2026-11-15 : 5 *repository secrets* (un par valeur) ; `ENV_JSON` sans clés ni contact (`check-env` vert) ;
      clé Comic Vine (et Google Books) saisie dans l'appli, jamais dans `ENV_JSON`.

## 1. Scan — mode Magasin (téléphone)
- [x] **M-01** *(reporté de la phase 14)* La caméra s'ouvre ; l'autorisation n'est demandée qu'une fois.
      — OK 2026-11-15 (téléphone, version 0.0.1 de la Release) : caméra ouverte, autorisation demandée une seule fois.
- [x] **M-02** *(reporté de la phase 14)* Tome possédé → bandeau **vert** (badge « ×2 » s'il y a deux éditions).
      — OK 2026-11-15 (téléphone, version 0.0.1 de la Release) : tome possédé → bandeau vert.
- [x] **M-03** Tome en envie → bandeau **jaune** ; « Je l'ai acheté » le fait passer au vert.
      — OK 2026-11-15 (téléphone, v0.1.0).
- [x] **M-04** Tome manquant d'une série suivie → bandeau **bleu** (reconnu par série + numéro).
      — OK 2026-11-15 (téléphone, v0.1.0).
- [x] **M-05** Ouvrage inconnu → bandeau **gris**, ajout possible.
      — OK 2026-11-15 (téléphone, v0.1.0).
- [x] **M-06** Tome possédé sans ISBN : après un scan, « ISBN mémorisé » ; le scan suivant est instantané.
      — À PRÉCISER 2026-11-15 : ISBN bien ajouté au tome, mais message « ISBN mémorisé » non vu (il s'affiche dans
      le bandeau vert, sous « Déjà possédé », pas en notification).
      — OK 2026-11-15 (nouveau build) : ligne « ISBN mémorisé » vue, brève si le livre bouge (accepté).
- [x] **M-07** Hors ligne (mode avion) : les tomes déjà en base sont reconnus.
      — OK 2026-11-15 (téléphone, v0.1.0).
- [ ] **M-08** Code UPC de comic US → message d'aide.
      — REPORTÉ (2026-11-15, choix de l'utilisateur).
- [ ] **M-09** (phase 13) Vibrations : 1 forte (vert), 2 moyennes (jaune), 3 légères (bleu), 1 brève (gris),
      au verdict final et une seule fois par scan. Si rien ne vibre : vérifier le retour haptique système.
      — À REFAIRE 2026-11-15 : aucune vibration ; retour haptique système (vibration au toucher) et mode
      silencieux à vérifier sur le téléphone.
- [ ] **M-10** (phase 13) Paramètres → Scan → couper « Vibrer selon le résultat » : plus de vibration.
      — REPORTÉ avec `M-09` (2026-11-15).
- [x] **M-11** (phase 13) Lampe torche : le bouton allume / éteint ; absent si le téléphone n'a pas de flash.
      — OK 2026-11-15 (téléphone, v0.1.0).
- [x] **M-12** (phase 13) Raccourci : appui long sur l'icône → « Scanner » → scan en mode Magasin, depuis
      l'appli fermée comme ouverte. Critère de phase : vibration « déjà possédé » en moins de 3 s.
      — OK 2026-11-15 (téléphone, v0.1.0).
- [x] **M-13** Garder le même livre devant la caméra : un seul verdict, une seule vibration.
      — OK 2026-11-15 : un seul verdict. Écart vu : message « Code UPC » souvent affiché sur des livres (second
      code-barres lu dans la même image) → l'ISBN est désormais préféré (`pickScannedCode`, test unitaire) ; à revoir.
- [x] **M-14** (phase 13) Quitter l'écran de scan lampe allumée : la lampe s'éteint ; le réglage des
      vibrations est conservé après redémarrage de l'appli.
      — ÉCHEC 2026-11-15 : lampe restée allumée en quittant l'appli sans la fermer (éteinte en tuant le processus).
      Corrigé : caméra arrêtée quand l'appli passe en arrière-plan, relancée au retour (`camera_scanner_view.dart`) ;
      à revérifier (plugin caméra non testable automatiquement).
      — OK 2026-11-15 (nouveau build) : lampe éteinte en arrière-plan ; elle ne se rallume pas au retour (accepté).
- [ ] **M-15** (phase 21, revue de code) Rafale : un livre devant la caméra, ouvrir la revue, retirer son entrée
      d'un glissement : elle ne revient pas dans la file tant que la revue est ouverte ; au retour sur le scan, la
      caméra repart. Même chose dans « Compléter par scan » avec une question affichée (caméra arrêtée dessous).

## 2. Scan — mode Rafale (téléphone)
- [ ] **R-01** Plusieurs scans d'affilée : la file se remplit et se traite.
      — REPORTÉ après la v4 (décision de l'utilisateur, 2026-11-15).
- [ ] **R-02** Fermer l'appli en cours de file, rouvrir : la file reprend.
      — REPORTÉ après la v4 (décision de l'utilisateur, 2026-11-15).
- [ ] **R-03** Revue : correction d'une fiche, puis import en lot ; séries créées correctement.
      — REPORTÉ après la v4 (décision de l'utilisateur, 2026-11-15).
- [ ] **R-04** (phase 13) 1 vibration légère par ajout ; 1 brève et « déjà dans la file » pour un doublon.
      — REPORTÉ après la v4 (décision de l'utilisateur, 2026-11-15).

## 3. Prêts et notifications
- [ ] **N-01** Prêter un tome avec retour aujourd'hui ou demain → notification vers 10 h (inexacte, peut tarder).
      — À REFAIRE 2026-11-16 : pas de notification (prêt créé le 15 en v0.1.0, retour le 16 ; appli réinstallée
      plusieurs fois entre-temps). Pistes : autorisation de notifier refusée, restrictions de batterie / démarrage
      automatique du fabricant, alarme inexacte retardée. Refaire sans réinstaller l'appli avant l'échéance.
      — Cause trouvée 2026-11-16 : notifications de Dupe **désactivées** (autorisation perdue avec une
      désinstallation). Corrigé : message au prêt si le rappel ne peut pas s'afficher ; rappels des prêts en cours
      reprogrammés au démarrage (réinstallation, prêt créé sur un autre appareil), ceux des prêts rendus annulés.
      À refaire avec les notifications autorisées.
- [ ] **N-02** Marquer rendu avant la date → pas de notification.
- [ ] **N-03** Redémarrer le téléphone avant la date → la notification vient quand même.
- [ ] **N-04** PC (Linux/Windows) : notification « prêts en retard » au démarrage, une fois par jour.

## 4. Photos, export, fichiers
- [x] **F-01** Photo de couverture depuis la fiche : visible dans la grille ; sur l'autre appareil après synchro.
      — OK 2026-11-15 (téléphone + PC, v0.1.0).
- [x] **F-02** Export JSON et CSV → feuille de partage Android (Drive, Fichiers, email).
      — OK 2026-11-15 (téléphone + PC, v0.1.0).
- [ ] **F-03** Le CSV s'ouvre correctement (accents) dans un tableur.
      — REPORTÉ (2026-11-15, choix de l'utilisateur).
- [ ] **F-04** Import CSV depuis le téléphone (sélection de fichier).
      — REPORTÉ (2026-11-15, choix de l'utilisateur).
- [ ] **F-05** PC : export/import via les fenêtres « Enregistrer sous » / « Ouvrir ».
      — REPORTÉ (2026-11-15, choix de l'utilisateur).

## 5. Compte et synchro Supabase (téléphone + PC)
Couvert contre un Supabase **local** par les tests `supabase` (phase 17, verts le 2026-11-14) : `S-04` à `S-08`
et la logique de `S-01`/`S-11`. Restent manuels : le comportement sur le **vrai** projet et sur de vrais
appareils (reportés de la phase 14).
- [x] **S-01** *(reporté de la phase 14)* Connexion email + mot de passe sur chaque appareil ; mauvais mot de passe → « Email ou mot de
      passe incorrect ».
      — OK 2026-11-15 (téléphone, PC, et instance Linux vide : mauvais mot de passe refusé).
- [ ] **S-02** Créer un compte avec un autre email (si Supabase peut lui écrire) : lien de confirmation ouvert
      dans le navigateur, puis connexion OK ; avant confirmation → « pas encore confirmé ».
- [ ] **S-03** Le gestionnaire de mots de passe propose d'enregistrer le mot de passe.
- [x] **S-04** *(reporté de la phase 14)* Ajout sur le téléphone → visible sur le PC (≤ 30 s ou bouton synchro), et inversement.
      — OK 2026-11-15 (téléphone ↔ PC, dans les deux sens).
- [x] **S-05** *(reporté de la phase 14)* **(critique, phase 9)** Après la mise à jour, la synchro reçoit toujours les changements de
      l'autre appareil : le filtre du pull a changé et n'a été testé que contre un faux serveur.
      — OK 2026-11-15 (téléphone ↔ PC avec la version de la recette).
- [ ] **S-06** Même tome modifié des deux côtés hors ligne → la modification la plus récente gagne.
      — REPORTÉ (2026-11-15, choix de l'utilisateur).
- [ ] **S-07** Modifier sur les deux appareils et synchroniser en même temps (bouton) : identiques à la fin.
      — REPORTÉ (2026-11-15, choix de l'utilisateur).
- [ ] **S-08** Suppression propagée.
      — REPORTÉ (2026-11-15, choix de l'utilisateur).
- [x] **S-09** Icône d'état de synchro cohérente (en cours, hors ligne, à jour, erreur).
      — OK 2026-11-15 (v0.1.0) : en cours, hors ligne, à jour cohérents (« erreur » non provoquée, voir `J-06`).
- [ ] **S-10** (phase 10) Changer le mot de passe sur un appareil : l'autre reste connecté et synchronise ;
      une nouvelle connexion n'accepte que le nouveau mot de passe.
      — REPORTÉ (2026-11-15, choix de l'utilisateur) : à faire plus tard dans la recette.
- [x] **S-11** (phase 10) Inscription avec un mot de passe trop court → « Mot de passe refusé : trop court ou
      trop simple » ; deux mots de passe différents → message, rien n'est envoyé.
      — OK 2026-11-15 (instance Linux de test) : mot de passe trop court refusé ; mots de passe différents signalés.
- [ ] **S-13** (phase 17) Avancer l'heure d'un appareil de 10 minutes (réglage manuel), synchroniser : le
      statut affiche « l'heure de cet appareil semble fausse (écart de 10 min…) » ; une entrée au journal.
- [x] **S-12** (phase 10) Se déconnecter puis se reconnecter au même compte : rien n'est dupliqué, la
      collection est identique sur les deux appareils.
      — OK 2026-11-15 (PC) : déconnexion puis reconnexion, aucun doublon constaté ; à revoir si un doublon apparaît.

## 6. Journal et messages d'erreur (phase 9)
- [x] **J-01** Mode avion puis synchro → une seule entrée « sync » même après plusieurs minutes.
      — OK 2026-11-15 (téléphone) : une entrée « SyncException(offline) », puis plus rien malgré les tentatives
      toutes les 30 s (prévu). Premier essai sans entrée : journal vidé après le premier échec.
- [x] **J-02** « Copier » puis coller dans un message : texte lisible (date, niveau, source, message).
      — REPORTÉ en phase 21 (2026-11-14, Linux) : écran vu vide alors que le fichier contenait une entrée
      « sync » (probablement consulté avant la première synchro) ; à revérifier après redémarrage.
      — OK 2026-11-15 (Linux, après redémarrage : entrées du 14 et du 15 ; Android : journaux collés lisibles).
      Écart corrigé au passage : le même échec de couvertures était écrit à chaque relance du préchargement
      (4 fois en 45 s) → écrit une seule fois tant que la liste ne change pas.
- [x] **J-03** « Partager » : feuille de partage sur Android, « Enregistrer sous » sur PC.
      — OK 2026-11-15 (téléphone : feuille de partage ; PC : « Enregistrer sous »).
- [x] **J-04** Le journal est conservé après redémarrage de l'appli.
      — OK 2026-11-15 (Linux) : vu pendant `J-02`, entrées du 2026-11-14 affichées après redémarrage.
- [ ] **J-05** Messages en français à l'écran (hors ligne, fichier invalide, mauvais mot de passe).
      — PARTIEL 2026-11-15 : mauvais mot de passe et hors ligne (« sources indisponibles ») en français ; fichier
      invalide à la restauration reporté par l'utilisateur.
- [ ] **J-06** (phase 12, facultatif) Mettre le projet Supabase en pause depuis son tableau de bord, puis
      synchroniser → « Serveur de synchronisation indisponible… en pause ». Le réactiver ensuite (quelques
      minutes). Si le message est différent, copier le journal : le code d'erreur d'un projet en pause n'a
      jamais été observé.

## 7. Filets de sécurité (phase 11)
- [x] **B-01** Supprimer un ouvrage puis « Annuler » : il revient, aussi sur l'autre appareil après synchro.
      — OK 2026-11-15 (téléphone + PC, v0.1.0).
- [x] **B-02** Supprimer une série puis « Annuler » : la série et ses tomes reviennent.
      — OK 2026-11-15 (téléphone + PC, v0.1.0).
- [x] **B-03** Paramètres → Sauvegardes automatiques : une hebdomadaire au premier lancement (collection non vide).
      — OK 2026-11-15 (téléphone + PC, v0.1.0).
- [ ] **B-04** Import CSV de test → sauvegarde « Avant import CSV » → « Revenir à cette sauvegarde » : l'import
      disparaît, y compris sur l'autre appareil après synchro.
      — REPORTÉ (2026-11-15, choix de l'utilisateur).
- [x] **B-05** Ajouter un ouvrage sur l'autre appareil **sans synchroniser**, puis restaurer : il n'est pas
      supprimé (comportement attendu : synchroniser avant de restaurer).
      — OK 2026-11-15 (« a l'air ok » : rien d'anormal constaté).
- [x] **B-06** Exporter une sauvegarde automatique puis la restaurer par fichier.
      — OK 2026-11-15 (« a l'air ok » : rien d'anormal constaté).
- [x] **B-07** Après une restauration, une sauvegarde « Avant restauration » apparaît dans la liste et
      permet d'annuler la restauration.
      — OK 2026-11-15 (« a l'air ok » : rien d'anormal constaté).
- [x] **B-08** Restaurer un fichier avec « Fusionner » : ce qui manquait est ajouté, rien n'est supprimé.
      — OK 2026-11-15 (« a l'air ok » : rien d'anormal constaté).

## 8. Plateformes et packaging
- [x] **L-01** Linux : `packaging/linux/build_appimage.sh` → l'AppImage se lance, icône dans la fenêtre.
      — OK 2026-11-15 (AppImage v0.1.0, GNOME) : se lance ; pas d'icône dans le dock sans entrée de menu
      (normal pour une AppImage non intégrée) → intégration documentée dans le README (§ Linux : AppImage).
- [ ] **W-01** Windows : `flutter build windows --release --dart-define-from-file=env.json` compile
      (sinon : job `windows` de la CI).
      — REPORTÉ (2026-11-15, pas de PC Windows sous la main).
- [ ] **W-02** Windows : installateur ; installation sans droits administrateur ; mise à jour par-dessus.
      — REPORTÉ (2026-11-15, pas de PC Windows sous la main).
- [ ] **W-03** Windows : icône, notifications de retard, dialogues de fichiers, synchro.
      — REPORTÉ (2026-11-15, pas de PC Windows sous la main).
- [x] **A-01** *(reporté de la phase 14)* APK signé (clé `keytool` + `android/key.properties`, README) : installation OK.
      — OK 2026-11-15 (téléphone, version 0.0.1 de la Release) : APK arm64 de la Release `v0.0.1-test` installé par-dessus la version locale, données et connexion conservées.
- [x] **A-02** Une version plus récente s'installe par-dessus sans perte de données.
      — OK 2026-11-16 : v0.1.1 installée par-dessus la v0.1.0 (Releases), données et connexion conservées.
- [x] **A-03** Icône adaptative correcte sur l'écran d'accueil.
      — OK 2026-11-15 (téléphone).

## 9. CI, Releases et mises à jour (phase 12)
- [x] **Y-01** Après le push : onglet *Actions* → `CI` vert, y compris le job **windows** (premier essai).
      — OK 2026-11-14 (GitHub Actions)
- [x] **Y-02** *(reporté en phase 21)* Pousser un tag de test (`git tag v0.0.1-test && git push origin v0.0.1-test`) → *pre-release*
      avec 3 APK, l'AppImage et `Dupe-0.0.1-test-setup.exe`. Supprimer ensuite la Release et le tag
      (`git push --delete origin v0.0.1-test`). Une *pre-release* n'est jamais proposée comme mise à jour ;
      l'appli d'une version de test affiche `0.0.1` dans À propos.
      — OK 2026-11-15 (run #1, 7 min 39) : *pre-release* avec les 3 APK, l'AppImage et l'installateur ; APK arm64
      signé avec la clé de l'utilisateur (même SHA-256 que les builds locaux), sans email ni clé API dans `libapp.so`.
      Release et tag à supprimer après `A-01`. Notes : « Première version », les anciens commits « Phase N » (non
      conventionnels) sont rangés dans « Autres changements ».
- [x] **Y-03** Installé en v1.0.0 alors que v1.0.1 existe : « Version 1.0.1 disponible — Télécharger » au
      démarrage ; le bouton ouvre le bon fichier (APK de l'architecture du téléphone, AppImage, installateur).
      — OK 2026-11-16 : v0.1.0 → « Version 0.1.1 disponible — Télécharger », APK arm64 proposé.
- [x] **Y-04** Paramètres → Mises à jour → « Rechercher une mise à jour » ; désactiver le signalement.
      — OK 2026-11-16 (v0.1.1).
- [x] **Y-05** Workflow `Keep Supabase awake` lancé à la main (*Run workflow*) → vert : l'étape *Call
      keep_alive()* affiche `HTTP 200` et l'étape *Keep this scheduled workflow enabled* réussit.
      — OK 2026-11-15 : *Run workflow* vert : `HTTP 200` et workflow maintenu actif.
- [ ] **Y-06** Pas d'email d'avertissement de pause de Supabase dans les semaines suivantes (depuis la phase 16,
      la veille appelle une vraie fonction SQL plutôt qu'une requête refusée par la RLS).
- [x] **Y-07** À propos : la version affichée est celle du tag de la Release installée.
      — OK 2026-11-16 : « 0.1.1+2101 » (2101 = numéro 101 du tag + 2000 ajouté par `--split-per-abi` pour arm64).
- [x] **Y-08** « Rechercher une mise à jour » sur la dernière version → « Dupe est à jour ».
      — OK 2026-11-16 (v0.1.1, vu avec `Y-04`).
- [ ] **Y-09** (phase 16) Sur une branche de test : un fichier `.dart` mal formaté fait échouer l'étape
      *Formatting* de la CI ; un `.g.dart` modifié à la main fait échouer *Generated code is up to date*.
- [x] **Y-10** (phase 16) Le récapitulatif du job `test` affiche « Couverture des tests » et l'artefact
      `coverage` contient `lcov.info`.
      — PARTIEL 2026-11-15 : artefact `coverage` présent (30 Ko) ; le récapitulatif « Couverture des tests »
      du job `test` n'est pas lisible par l'API : à regarder sur GitHub.
      — OK 2026-11-15 (vu par l'utilisateur sur GitHub).
- [ ] **Y-11** (phase 16) Dependabot ouvre ses premières pull requests vers `dev` (une groupée par écosystème
      pour les mises à jour mineures et correctifs) ; leur CI passe ou signale une régénération.
      — EN ATTENTE 2026-11-15 : aucune PR Dependabot à ce jour (première exécution hebdomadaire à venir).
- [x] **Y-12** (phase 16) Le badge CI du README affiche l'état réel.
      — OK 2026-11-15 : badge filtré `?event=pull_request` → « CI - passing » (dernier run de PR vert).
- [x] **Y-14** (phase 17) Le job `supabase-tests` de la CI passe sur une pull request.
      — OK 2026-11-15 : `supabase-tests` vert sur la PR `dev` → `main` (run 43746943865), comme les 5 autres jobs.
- [x] **Y-16** (recette, obfuscation) Prochaine Release (`v0.1.1`) : elle contient aussi
      `dupe-0.1.1-symbols-android.zip`, `…-linux.zip`, `…-windows.zip` ; l'APK et l'AppImage obfusqués démarrent
      et fonctionnent normalement (clés saisies et sources désactivées conservées après la mise à jour) ; le journal
      reste en français et lisible (causes des couvertures : « HTTP 404 », « pas de réseau »).
      — OK 2026-11-16 : zips de symboles présents ; APK obfusqué fonctionnel, clés et réglages conservés, journal lisible.
- [ ] **Y-13** (au bout de 60 jours sans push, si l'occasion se présente) `Keep Supabase awake` est toujours
      actif dans l'onglet *Actions* (efficacité non documentée de la réactivation par l'API).

## 10. Données réelles
- [ ] **D-01** Import de la collection (CSV Mangacollec / CLZ / tableur) : correspondance des colonnes devinée.
      — À CONFIRMER (2026-11-15) : « a l'air ok ou à faire plus tard » ; non coché faute de résultat précis.
- [ ] **D-02** Réimporter le même fichier n'ajoute rien.
      — À CONFIRMER (2026-11-15) : « a l'air ok ou à faire plus tard » ; non coché faute de résultat précis.
- [ ] **D-03** Sauvegarde JSON → restauration sur un autre appareil vide.
      — À CONFIRMER (2026-11-15) : « a l'air ok ou à faire plus tard » ; non coché faute de résultat précis.
- [x] **D-04** Statistiques plausibles (dépenses, valeur, tomes lus, séries complètes).
      — OK 2026-11-15 (v0.1.0).
- [x] **D-05** Mode sombre lisible partout (bandeaux du scan, graphique).
      — OK 2026-11-15 (v0.1.0).

## 11. Clés des sources (phase 15)
Automatisé (phase 15) : la clé n'est ni dans une sauvegarde JSON, ni dans le journal, ni envoyée à Supabase ;
une clé saisie active la source sans redémarrage ; « Tester la clé » sur des réponses réelles enregistrées.
- [x] **K-01** Version **publiée** (sans clé compilée) : Paramètres → Sources → Comic Vine → *Clé API* →
      saisir la clé → *Tester la clé* → « Clé valide » → *Enregistrer* ; la recherche « Batman 3 » (type
      Comics) trouve des résultats.
      — OK 2026-11-15 (AppImage v0.1.0).
- [x] **K-02** Idem pour Google Books (clé restreinte à Books API) : une recherche par ISBN affiche couverture
      et résumé.
      — OK 2026-11-15 (AppImage v0.1.0).
- [x] **K-03** Clé volontairement fausse → « Clé refusée » ; mode avion → « Pas de connexion ».
      — OK 2026-11-15 (AppImage v0.1.0).
- [x] **K-04** Sur le deuxième appareil, la clé n'apparaît pas (elle n'est pas synchronisée) : la saisir aussi.
      — OK 2026-11-15 (téléphone en v0.1.0 : aucune clé reçue, saisies à part).
- [x] **K-05** `ENV_JSON` contenant `COMIC_VINE_API_KEY` (ou `OPEN_LIBRARY_CONTACT`) : le workflow Release
      échoue au job `check-env` avec le nom de la variable, jamais sa valeur (à vérifier en même temps que
      `Y-02`, puis la retirer du secret).
      — VÉRIFIÉ EN LOCAL 2026-11-15 (filtre jq de `check-env` : refuse les 3 variables, n'affiche que leur
      nom) ; `check-env` vert sur la vraie Release. Refus non constaté sur GitHub (facultatif).

## 12. Hooks, commits et tests d'intégration (phase 18)
Automatisé (phase 18) : vérification des messages (`tool/check_commit_msg.sh`) et notes de version
(`tool/ci/release_notes.sh`) testées sur un dépôt git temporaire ; les 4 parcours d'intégration passent sous Linux.
- [x] **H-01** `lefthook install` (README « Hooks git ») ; `git commit -m "Phase 19"` est refusé avec le format
      attendu ; `git commit -m "feat: …"` passe.
      — OK 2026-11-15 : commit au message de 103 caractères refusé par le hook, message conforme accepté.
- [ ] **H-02** Un fichier `.dart` mal formaté et stagé est reformaté et re-stagé au commit ; une erreur
      d'analyse bloque le commit.
- [ ] **H-03** `git push` lance `flutter test` et s'arrête si un test échoue.
- [ ] **H-04** Tests d'intégration sur le téléphone : `flutter test integration_test -d <id>` (3 parcours ;
      le parcours Magasin est sauté à cause de la caméra).
- [x] **Y-15** La Release de test (`Y-02`) a pour description les notes générées (groupées par type) ; le job
      `integration` de la CI est vert.
      — OK 2026-11-15 : notes de `v0.0.1-test` groupées par type (Nouveautés, Corrections, Documentation…) ;
      job `integration` vert sur les PR.

## 13. Widget d'écran d'accueil et recherche vocale (phase 19)
Automatisé (phase 19) : ouverture du scan depuis le widget (au lancement et appli ouverte), compteurs regroupés
et non renvoyés s'ils n'ont pas changé, découpage des phrases (« One Piece tome 107 », « tome 3 de Blacksad »,
nombres en lettres jusqu'à 999 999), ouverture du tome dicté / absence / recherche normale, explication du micro
une seule fois. Simulés : le plugin du widget et le micro.
- [x] **G-01** Ajouter le widget « Dupe » sur l'écran d'accueil : bouton « Scanner » et « N ouvrages » (puis
      « · N prêts en retard » s'il y en a).
      — OK 2026-11-16 (Xiaomi, Android 14).
- [x] **G-02** « Scanner » depuis l'écran d'accueil ouvre le scan en mode Magasin, appli fermée comme ouverte.
      — OK 2026-11-16 (Xiaomi, Android 14).
- [x] **G-03** Les compteurs suivent un ajout, une suppression, une synchro venant de l'autre appareil (en
      quelques secondes, appli ouverte).
      — OK 2026-11-16 (Xiaomi, Android 14).
- [x] **G-04** Chrono à froid (appli fermée, balayée des applis récentes) : du toucher sur « Scanner » à la
      caméra prête, **objectif < 2 s**. Noter la mesure et le modèle de téléphone.
      — OK 2026-11-16 (Xiaomi, Android 14) : caméra prête en moins de 2 s (mesure non chiffrée).
- [x] **V-01** Android : micro de la barre de recherche → explication (une seule fois) → autorisation du micro
      demandée par Android → « J'écoute… ».
      — OK 2026-11-16 (Xiaomi, Android 14).
- [x] **V-02** « One Piece tome 107 » (ou un tome possédé) : la fiche du tome s'ouvre ; un tome absent ouvre la
      série avec « Tome N de … : absent de ta collection » ; « Dune » lance une recherche normale.
      — OK 2026-11-16 (Xiaomi, Android 14).
- [x] **V-03** Nombres dits en lettres (« Naruto volume douze »), et « Arrêter » / glisser le panneau vers le bas
      arrête l'écoute.
      — OK 2026-11-16 (Xiaomi, Android 14).
- [ ] **V-04** Windows : la dictée fonctionne (reconnaissance vocale de Windows) ; Linux : pas de bouton micro.


## 14. Couvertures hors ligne, stats de lecture, partage des envies (phase 20)
Automatisé (phase 20) : préchargement (chaque couverture une fois, photos `dupe-cover:` comprises, lignes
supprimées ignorées, échecs comptés et retentés au passage suivant), Wi-Fi seulement par défaut, arrêt dès la
perte de connexion puis reprise, désactivation, section Paramètres (état, taille, « Vider ») ; statistiques de
lecture sur un jeu calculé à la main ; date de lecture remplie en choisissant « Lu » dans le formulaire ;
filtres et texte partagés, image PNG produite. Simulés : la connexion (`connectivity_plus`) et le cache disque.
- [x] **O-01** Téléphone en Wi-Fi : Paramètres → Couvertures hors ligne passe à « Téléchargement : n / N » puis
      « N couvertures disponibles hors ligne », avec la place utilisée.
      — OK 2026-11-16 (« a l'air ok » : rien d'anormal constaté).
- [x] **O-02** **Critère de la phase** : mode avion, appli relancée : la collection (onglets, séries, fiches) et
      les envies s'affichent **avec leurs couvertures**. Pareil sur Linux sans réseau, **après un redémarrage
      du PC** (les couvertures ne sont plus dans `/tmp`).
      — OK 2026-11-16 (« a l'air ok » : rien d'anormal constaté).
- [x] **O-03** Sur données mobiles (Wi-Fi coupé) : « En attente du Wi-Fi », rien n'est téléchargé ; couper le
      Wi-Fi pendant un téléchargement l'interrompt ; « Wi-Fi seulement » décoché : le téléchargement reprend.
      — OK 2026-11-16 (« a l'air ok » : rien d'anormal constaté).
- [x] **O-04** « Vider » : la place retombe à ~0 Mo, les photos prises soi-même restent visibles ; toucher la
      ligne d'état relance le téléchargement.
      — OK 2026-11-16 (« a l'air ok » : rien d'anormal constaté).
- [x] **T-01** Statistiques → « Tomes lus par mois » : marquer un tome « Lu » (puce de la fiche, menu « lus
      jusqu'au tome N », ou formulaire) l'ajoute au mois courant ; la vue tableau donne les mêmes chiffres.
      — OK 2026-11-16 (« a l'air ok » : rien d'anormal constaté).
- [x] **T-02** Pile à lire, plus ancien tome, délai achat → lecture et séries abandonnées correspondent à ce
      qu'on sait de sa collection (les tomes lus avant la v3, sans date, sont seulement signalés).
      — OK 2026-11-16 (« a l'air ok » : rien d'anormal constaté).
- [x] **E-01** Envies → Partager : filtres par type et priorité, aperçu avec couvertures (vignette grise pour une
      couverture introuvable), « Afficher le prix max ».
      — OK 2026-11-16 (« a l'air ok » : rien d'anormal constaté).
- [x] **E-02** **Critère de la phase** : Android, « Partager l'image » → l'envoyer par message (WhatsApp,
      SMS…) : l'image est nette et lisible sur le téléphone du destinataire ; « Partager le texte » idem.
      — OK 2026-11-16 (« a l'air ok » : rien d'anormal constaté).
- [x] **E-03** Linux / Windows : « Partager l'image » ouvre « Enregistrer sous » (fichier PNG correct) ;
      « Partager le texte » copie la liste dans le presse-papiers.
      — OK 2026-11-16 (« a l'air ok » : rien d'anormal constaté).

## 15. Retours de recette Android (2026-11-15)
Automatisé (recette) : tome lu dans le titre (« Free Quest Tome 1 », « T01 »), collection d'éditeur numérotée
ignorée (« Folio junior » n° 1987), absence de Release GitHub silencieuse, « Voir la série » puis retour vers
l'onglet, onglet toujours ouvert sur sa liste, couverture d'une série = celle du premier tome, double retour pour
quitter, type du scan choisi et mémorisé, pastille « ? » pour un tome sans numéro, indicateur « lu »,
proposition d'ajouter les tomes précédents, « Compléter les couvertures manquantes » (adresses cassées
remplacées, photos gardées), vue et page par auteur. Simulés : les sources et le cache des couvertures.
- [ ] **Q-01** Android : sur la liste d'un onglet, retour → « Appuie de nouveau sur retour pour quitter » ;
      un second appui dans les 2 s ferme l'appli, après 2 s il ne fait que réafficher le message.
- [ ] **Q-02** Scanner en magasin un tome d'une série nouvelle (Free Quest 1, Jumeaux Fowl 3) : le formulaire
      propose de créer la bonne série (pas « Folio junior ») avec le bon numéro.
- [ ] **Q-03** Ajouter le tome 9 possédé d'une série qui n'a que le 1 : « Il te manque 7 tomes avant le 9 » →
      Ajouter → les tomes 2 à 8 apparaissent en vert.
- [ ] **Q-04** Plus → Qualité → « Compléter les couvertures manquantes » (déplacé des Paramètres le 2026-11-16) sur la vraie collection : progression,
      couvertures ajoutées visibles dans les listes ; le journal liste les livres restés sans couverture et les
      sources qui ont répondu ; « Télécharger maintenant » liste les adresses en échec avec leur cause.
- [ ] **Q-05** Scan ouvert depuis Plus / le journal : choisir « BD » dans le menu de type ; au scan suivant
      ouvert hors d'un onglet, « BD » est déjà choisi.
- [ ] **Q-06** Livres → « Par auteur » sur la vraie collection : un auteur écrit de deux façons selon la source
      n'apparaît qu'une fois ; sa page liste toutes ses séries et livres ; toucher un nom d'auteur sur une fiche
      ouvre la même page.
- [x] **Q-07** Recherche (locale, et en ligne par texte) : l'ISBN apparaît dans le sous-titre des livres.
      — OK 2026-11-16 : ISBN affiché quand la source en donne un (pas toujours en recherche en ligne : Open
      Library ou Comic Vine n'en fournissent pas pour tous les résultats).
- [x] **Q-08** Séries sans nombre total de tomes : barre **grise** (possédés / plus haut tome), distincte de la barre
      normale des séries dont le total est connu ; un appui long sur la barre grise explique « Progression estimée ».
      — OK 2026-11-16 : barre grise visible ; l'appui long sur la barre fine est difficile mais fonctionne.
- [x] **Q-09** Page d'un auteur → menu ⋮ → « Marquer les livres hors série comme lus » / « Tout marquer comme lu » :
      confirmation avec le nombre de livres, puis livres marqués « Lu » avec la date du jour.
      — OK 2026-11-16.
- [ ] **Q-10** Tome créé vide (« Ajouter des tomes », ou « Il te manque … → Ajouter ») puis scanné en mode Magasin :
      « ISBN mémorisé », et la fiche du tome a maintenant couverture, auteurs, éditeur, prix (ce que tu avais saisi
      reste inchangé).
- [ ] **Q-11** Envies : glisser un livre vers la gauche le retire, « Annuler » le remet.

## 16. Séries : nombre de tomes et vue liste (v4, phase 23)
Automatisé (phase 23) : seul un titre identique propose un total ; vérification depuis le menu d'une série et en
lot (propositions décochables, rien d'enregistré avant « Appliquer ») ; question au premier tome (pré-remplie,
« Plus tard ») ; vue liste avec titres propres, statut et choix mémorisé. Simulés : AniList et Comic Vine.
- [ ] **U-01** Manga suivi sans total (ex. One Piece) : ⋮ → « Vérifier le nombre de tomes » → total AniList
      proposé (nombre japonais) → Enregistrer → les tomes manquants apparaissent en gris, la barre devient normale.
      — PARTIEL 2026-11-16 : mangas français (Free Quest, Everdark, Oneira) introuvables sur AniList (œuvres non
      japonaises, comme Dreamland) ; comics : I hate Fairyland trouvé, nombre de l'édition américaine (annoncé) ;
      BD et livres : pas d'action (pas de source) — l'utilisateur attendait au moins une saisie manuelle.
      Corrigé : « Nombre total de tomes… » dans le menu de toutes les séries, saisie manuelle si rien n'est trouvé ;
      à revoir sur Kaamelott (BD) et Free Quest (manga introuvable).
- [x] **U-02** Plus → Qualité (anciennement Paramètres → Sources) → « Vérifier le nombre de tomes des séries » sur la vraie collection :
      propositions plausibles (titres identiques), décocher une erreur éventuelle, Appliquer.
      — OK 2026-11-16 : seul I hate Fairyland trouvé (mêmes limites que `U-01`).
- [ ] **U-03** Scanner le tome 1 d'une nouvelle série : « Combien de tomes compte la série ? » (pré-rempli pour un
      manga ou un comic si la source connaît la série, vide pour une BD) ; « Plus tard » ne change rien.
- [x] **U-04** Écran d'une série → icône liste : couvertures, « Tome N », titres propres des tomes (BnF), statut
      et « Lu » ; le choix liste/pastilles est conservé après redémarrage.
      — OK 2026-11-16 pour la vue liste ; souhaits : titres aussi dans la vue pastilles, et un vrai titre de tome
      (souvent seulement « Tome 1 » : le titre propre n'est connu que si la BnF le donne en titre principal).

## 17. Titres des tomes (v4, phase 24)
Automatisé (phase 24) : règle de remplissage (titre propre, sous-titre, vide), ajout depuis une source, tome vide
complété au scan, remplissage en lot par ISBN, CSV, migrations locale (v3) et Supabase (local), affichage.
- [ ] **I-00** **Avant d'installer cette version** : appliquer `supabase/migrations/20261116120000_volume_title.sql`
      dans le SQL Editor du projet Supabase (sinon la synchro est refusée).
- [ ] **I-01** Plus → Qualité → « Compléter les titres des tomes » : progression, puis des titres apparaissent
      sous les pastilles et dans la vue liste (Kaamelott, Jumeaux Fowl…).
- [ ] **I-02** Scanner le tome d'une série dont la notice a un titre propre : « Titre du tome » pré-rempli dans le
      formulaire, affiché sur la fiche et sous la pastille ; modifiable.
- [ ] **I-03** Synchro : un titre de tome saisi sur le téléphone arrive sur le PC ; l'export CSV a la colonne
      « Titre du tome ».

## 18. Qualité de la collection et ISBN manquants (v4, phase 22)
Automatisé (phase 22) : compteurs (sans ISBN, sans couverture, sans numéro, ressemble à un tome, série sans total),
complétion par scan avec ses contrôles (doublon, titre différent, passer), compteur qui baisse, puce de la fiche,
point sur les pastilles. Simulées : les sources.
- [ ] **C-01** Plus → Qualité de la collection : les compteurs correspondent à ce que tu sais de ta collection ;
      chaque ligne ouvre la liste des livres (ou séries) concernés.
- [ ] **C-02** **Critère de la phase** : « Compléter par scan » sur le téléphone, scanner **dix** livres à la suite ;
      le compteur « sans ISBN » baisse de dix, les livres gagnent couverture et infos manquantes.
- [ ] **C-03** Scanner un livre déjà dans la collection → « Cet ISBN est déjà celui de … » ; un autre livre que celui
      affiché → demande de confirmation.
- [ ] **C-04** Fiche d'un livre possédé sans ISBN → « ISBN manquant · scanner ». Par défaut : point sur les
      pastilles concernées, icône sur les séries, livres et auteurs qui ont des livres sans ISBN (nombre en appui long) ;
      Qualité → « Signaler les ISBN manquants » décoché → plus aucun indicateur.

## 19. Éditions et couvertures (v4, phase 25)
Automatisé (phase 25) : correspondance d'une autre édition (titre, auteur, numéro), couverture proposée puis gardée,
refus non reproposé, « autre édition » d'un livre hors série en magasin et homonyme ignoré. Simulées : les sources.
- [ ] **X-01** Plus → Qualité → « Compléter les couvertures manquantes » sur la vraie collection, puis
      Qualité → « Couvertures proposées » : les images proposées sont bien celles des bons livres (autre édition).
- [ ] **X-02** Garder une proposition → la couverture apparaît dans les listes ; en refuser une → elle n'est plus
      proposée au passage suivant (sur cet appareil).
- [ ] **X-03** En magasin, scanner un roman que tu possèdes dans une autre édition (poche / grand format) : bandeau
      vert « Tu as ce livre dans une autre édition ».

