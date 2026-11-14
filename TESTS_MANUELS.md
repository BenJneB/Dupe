# Dupe — Tests manuels

> Document autonome, à jour au **2026-11-14**. Dupe est une appli Flutter personnelle de catalogue de
> collection (mangas, BD, comics, livres) pour Android, Linux et Windows, avec synchro Supabase optionnelle.
> Contexte : `PLAN_V2.md` (phases 9-13) et `PLAN_V3.md`. Une petite partie de ces tests est faite **maintenant**
> (phase 14, vérifications de base) ; tout le reste l'est à la fin (**phase 21, recette finale**), sur la version
> finale. Les phases 15 à 20 ajoutent leurs tests ici et marquent « automatisé (phase N) » ceux que leurs tests
> automatiques couvrent désormais.

Ce fichier liste ce que les **168 tests automatiques ne couvrent pas** : matériel (caméra, vibrations,
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
7c. **CI et Dependabot** : `P-05`, `P-06`, puis `Y-05`, `Y-09` à `Y-12`.
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
- [ ] **P-05** (phase 16) Migration `20261115090000_keep_alive.sql` appliquée (fonction `keep_alive()`).
- [ ] **P-06** (phase 16) `dev` à jour avec le travail des phases, et `.github/dependabot.yml` présent sur `main`
      (Dependabot ne lit sa configuration que sur la branche par défaut).
- [ ] **P-03** *(reporté en phase 21)* Secrets GitHub créés (README § Publier une version) ; décision prise pour la clé Comic Vine.

## 1. Scan — mode Magasin (téléphone)
- [ ] **M-01** *(reporté de la phase 14)* La caméra s'ouvre ; l'autorisation n'est demandée qu'une fois.
- [ ] **M-02** *(reporté de la phase 14)* Tome possédé → bandeau **vert** (badge « ×2 » s'il y a deux éditions).
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
- [ ] **M-14** (phase 13) Quitter l'écran de scan lampe allumée : la lampe s'éteint ; le réglage des
      vibrations est conservé après redémarrage de l'appli.

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
- [ ] **S-01** *(reporté de la phase 14)* Connexion email + mot de passe sur chaque appareil ; mauvais mot de passe → « Email ou mot de
      passe incorrect ».
- [ ] **S-02** Créer un compte avec un autre email (si Supabase peut lui écrire) : lien de confirmation ouvert
      dans le navigateur, puis connexion OK ; avant confirmation → « pas encore confirmé ».
- [ ] **S-03** Le gestionnaire de mots de passe propose d'enregistrer le mot de passe.
- [ ] **S-04** *(reporté de la phase 14)* Ajout sur le téléphone → visible sur le PC (≤ 30 s ou bouton synchro), et inversement.
- [ ] **S-05** *(reporté de la phase 14)* **(critique, phase 9)** Après la mise à jour, la synchro reçoit toujours les changements de
      l'autre appareil : le filtre du pull a changé et n'a été testé que contre un faux serveur.
- [ ] **S-06** Même tome modifié des deux côtés hors ligne → la modification la plus récente gagne.
- [ ] **S-07** Modifier sur les deux appareils et synchroniser en même temps (bouton) : identiques à la fin.
- [ ] **S-08** Suppression propagée.
- [ ] **S-09** Icône d'état de synchro cohérente (en cours, hors ligne, à jour, erreur).
- [ ] **S-10** (phase 10) Changer le mot de passe sur un appareil : l'autre reste connecté et synchronise ;
      une nouvelle connexion n'accepte que le nouveau mot de passe.
- [ ] **S-11** (phase 10) Inscription avec un mot de passe trop court → « Mot de passe refusé : trop court ou
      trop simple » ; deux mots de passe différents → message, rien n'est envoyé.
- [ ] **S-12** (phase 10) Se déconnecter puis se reconnecter au même compte : rien n'est dupliqué, la
      collection est identique sur les deux appareils.

## 6. Journal et messages d'erreur (phase 9)
- [ ] **J-01** Mode avion puis synchro → une seule entrée « sync » même après plusieurs minutes.
- [ ] **J-02** « Copier » puis coller dans un message : texte lisible (date, niveau, source, message).
      — REPORTÉ en phase 21 (2026-11-14, Linux) : écran vu vide alors que le fichier contenait une entrée
      « sync » (probablement consulté avant la première synchro) ; à revérifier après redémarrage.
- [ ] **J-03** « Partager » : feuille de partage sur Android, « Enregistrer sous » sur PC.
- [ ] **J-04** Le journal est conservé après redémarrage de l'appli.
- [ ] **J-05** Messages en français à l'écran (hors ligne, fichier invalide, mauvais mot de passe).
- [ ] **J-06** (phase 12, facultatif) Mettre le projet Supabase en pause depuis son tableau de bord, puis
      synchroniser → « Serveur de synchronisation indisponible… en pause ». Le réactiver ensuite (quelques
      minutes). Si le message est différent, copier le journal : le code d'erreur d'un projet en pause n'a
      jamais été observé.

## 7. Filets de sécurité (phase 11)
- [ ] **B-01** Supprimer un ouvrage puis « Annuler » : il revient, aussi sur l'autre appareil après synchro.
- [ ] **B-02** Supprimer une série puis « Annuler » : la série et ses tomes reviennent.
- [ ] **B-03** Paramètres → Sauvegardes automatiques : une hebdomadaire au premier lancement (collection non vide).
- [ ] **B-04** Import CSV de test → sauvegarde « Avant import CSV » → « Revenir à cette sauvegarde » : l'import
      disparaît, y compris sur l'autre appareil après synchro.
- [ ] **B-05** Ajouter un ouvrage sur l'autre appareil **sans synchroniser**, puis restaurer : il n'est pas
      supprimé (comportement attendu : synchroniser avant de restaurer).
- [ ] **B-06** Exporter une sauvegarde automatique puis la restaurer par fichier.
- [ ] **B-07** Après une restauration, une sauvegarde « Avant restauration » apparaît dans la liste et
      permet d'annuler la restauration.
- [ ] **B-08** Restaurer un fichier avec « Fusionner » : ce qui manquait est ajouté, rien n'est supprimé.

## 8. Plateformes et packaging
- [ ] **L-01** Linux : `packaging/linux/build_appimage.sh` → l'AppImage se lance, icône dans la fenêtre.
- [ ] **W-01** Windows : `flutter build windows --release --dart-define-from-file=env.json` compile
      (sinon : job `windows` de la CI).
- [ ] **W-02** Windows : installateur ; installation sans droits administrateur ; mise à jour par-dessus.
- [ ] **W-03** Windows : icône, notifications de retard, dialogues de fichiers, synchro.
- [ ] **A-01** *(reporté de la phase 14)* APK signé (clé `keytool` + `android/key.properties`, README) : installation OK.
- [ ] **A-02** Une version plus récente s'installe par-dessus sans perte de données.
- [ ] **A-03** Icône adaptative correcte sur l'écran d'accueil.

## 9. CI, Releases et mises à jour (phase 12)
- [x] **Y-01** Après le push : onglet *Actions* → `CI` vert, y compris le job **windows** (premier essai).
      — OK 2026-11-14 (GitHub Actions)
- [ ] **Y-02** *(reporté en phase 21)* Pousser un tag de test (`git tag v0.0.1-test && git push origin v0.0.1-test`) → *pre-release*
      avec 3 APK, l'AppImage et `Dupe-0.0.1-test-setup.exe`. Supprimer ensuite la Release et le tag
      (`git push --delete origin v0.0.1-test`). Une *pre-release* n'est jamais proposée comme mise à jour ;
      l'appli d'une version de test affiche `0.0.1` dans À propos.
- [ ] **Y-03** Installé en v1.0.0 alors que v1.0.1 existe : « Version 1.0.1 disponible — Télécharger » au
      démarrage ; le bouton ouvre le bon fichier (APK de l'architecture du téléphone, AppImage, installateur).
- [ ] **Y-04** Paramètres → Mises à jour → « Rechercher une mise à jour » ; désactiver le signalement.
- [ ] **Y-05** Workflow `Keep Supabase awake` lancé à la main (*Run workflow*) → vert : l'étape *Call
      keep_alive()* affiche `HTTP 200` et l'étape *Keep this scheduled workflow enabled* réussit.
- [ ] **Y-06** Pas d'email d'avertissement de pause de Supabase dans les semaines suivantes (depuis la phase 16,
      la veille appelle une vraie fonction SQL plutôt qu'une requête refusée par la RLS).
- [ ] **Y-07** À propos : la version affichée est celle du tag de la Release installée.
- [ ] **Y-08** « Rechercher une mise à jour » sur la dernière version → « Dupe est à jour ».
- [ ] **Y-09** (phase 16) Sur une branche de test : un fichier `.dart` mal formaté fait échouer l'étape
      *Formatting* de la CI ; un `.g.dart` modifié à la main fait échouer *Generated code is up to date*.
- [ ] **Y-10** (phase 16) Le récapitulatif du job `test` affiche « Couverture des tests » et l'artefact
      `coverage` contient `lcov.info`.
- [ ] **Y-11** (phase 16) Dependabot ouvre ses premières pull requests vers `dev` (une groupée par écosystème
      pour les mises à jour mineures et correctifs) ; leur CI passe ou signale une régénération.
- [ ] **Y-12** (phase 16) Le badge CI du README affiche l'état réel.
- [ ] **Y-13** (au bout de 60 jours sans push, si l'occasion se présente) `Keep Supabase awake` est toujours
      actif dans l'onglet *Actions* (efficacité non documentée de la réactivation par l'API).

## 10. Données réelles
- [ ] **D-01** Import de la collection (CSV Mangacollec / CLZ / tableur) : correspondance des colonnes devinée.
- [ ] **D-02** Réimporter le même fichier n'ajoute rien.
- [ ] **D-03** Sauvegarde JSON → restauration sur un autre appareil vide.
- [ ] **D-04** Statistiques plausibles (dépenses, valeur, tomes lus, séries complètes).
- [ ] **D-05** Mode sombre lisible partout (bandeaux du scan, graphique).

## 11. Clés des sources (phase 15)
Automatisé (phase 15) : la clé n'est ni dans une sauvegarde JSON, ni dans le journal, ni envoyée à Supabase ;
une clé saisie active la source sans redémarrage ; « Tester la clé » sur des réponses réelles enregistrées.
- [ ] **K-01** Version **publiée** (sans clé compilée) : Paramètres → Sources → Comic Vine → *Clé API* →
      saisir la clé → *Tester la clé* → « Clé valide » → *Enregistrer* ; la recherche « Batman 3 » (type
      Comics) trouve des résultats.
- [ ] **K-02** Idem pour Google Books (clé restreinte à Books API) : une recherche par ISBN affiche couverture
      et résumé.
- [ ] **K-03** Clé volontairement fausse → « Clé refusée » ; mode avion → « Pas de connexion ».
- [ ] **K-04** Sur le deuxième appareil, la clé n'apparaît pas (elle n'est pas synchronisée) : la saisir aussi.
- [ ] **K-05** `ENV_JSON` contenant `COMIC_VINE_API_KEY` : le workflow Release échoue au job `check-env` avec
      le nom de la clé, jamais sa valeur (à vérifier en même temps que `Y-02`, puis retirer la clé du secret).

