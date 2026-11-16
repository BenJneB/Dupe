# Dupe — Plan v3

> Suite de `PLAN.md` (phases 0-8) et `PLAN_V2.md` (phases 9-13). Les conventions de `CLAUDE.md` restent
> valables sans exception : une phase à la fois, fichiers < 250 lignes, textes d'interface dans
> `app_fr.arb`, jamais de lecture de `env.json`, jamais de connexion au projet Supabase distant, l'assistant
> stage fichier par fichier et l'utilisateur committe.
>
> Comme `PLAN_V2.md`, ce fichier sert aussi d'**état du projet** : à la fin de chaque phase, mettre à jour le
> tableau de la section 3 et ajouter un bilan « Réalisé / Écarts / Non vérifié » sous la phase concernée.

## 1. Objectif de la v3

La v2 a rendu l'appli fiable sur le papier ; **rien n'a encore été vérifié en conditions réelles**. La v3
commence par de courtes vérifications de base (ce qui ne peut pas attendre), traite les risques ouverts de la
v2, renforce l'outillage (CI, hooks, tests contre un vrai Supabase local), ajoute des fonctions de confort,
et se termine par une **recette complète** sur la version finale (phase 21).

Pourquoi la recette complète est à la fin (décision du 2026-11-14) : les phases 15, 17, 19 et 20 modifient ce
qu'elle vérifie (sources, statut de synchro, accès au scan, couvertures), et les phases 17-18 automatisent une
bonne partie de la liste (synchro contre Supabase local, tests d'intégration). Une recette complète maintenant
serait en grande partie à refaire.

### Ce qui existe déjà et n'est pas refait
CI (`ci.yml` : analyse, tests, builds Linux/Android/Windows), Releases sur tag, versions tirées du tag,
veille Supabase (`keep-alive.yml`), journal d'erreurs local consultable et partageable (remplace un service
externe type Sentry, volontairement écarté), sauvegardes automatiques, annulation des suppressions,
raccourci Android « Scanner », vibrations, lampe torche, signalement des nouvelles versions.

### Risques ouverts de la v2 et phase qui les traite
| Risque (`PLAN_V2.md` §6) | Traité en |
|---|---|
| 1. Aucun test réel (synchro, connexion, caméra, Windows, workflows) | Phase 14 (base), 17-18 (auto), 21 (recette) |
| 2. Filtre PostgREST du pull jamais vérifié contre un vrai serveur | Phase 17 ✅ (vérifié contre PostgREST local) ; 21 (`S-05` sur le projet réel) |
| 3. Compte existant sans mot de passe | Sans objet (2026-11-14 : aucun compte n'existait ; création en phase 14, `P-04`) |
| 4. Clés Comic Vine / Google Books extractibles des binaires publics | Phase 15 ✅ (aucune Release n'a encore été publiée : aucune clé exposée) |
| 5. Efficacité du `keep-alive` non prouvée ; tâches planifiées désactivées après 60 j | Phase 16 ✅ (vraie requête SQL ; réactivation par API, efficacité non documentée par GitHub) |
| 6. Horloge d'appareil très en avance qui gagne à tort la synchro | Phase 17 ✅ (avertissement, testé avec le faux serveur) |

## 2. Décisions déjà prises
- Pas de service de suivi d'erreurs externe : le journal local suffit.
- Les clés tierces sortent des binaires publics (phase 15) : elles sont saisies dans l'appli.
- Supabase **local** (CLI + Docker) est autorisé pour les tests ; le projet distant reste interdit.

## 3. État des phases

| Phase | Sujet | État | Tests auto | Vérifié en réel |
|---|---|---|---|---|
| 14 | Vérifications de base en réel et correctifs | close (réduite) | message de confirmation | CI, schéma, compte (2026-11-14) |
| 15 | Clés API saisies dans l'appli | ✅ fait (2026-11-14) | oui | non (phase 21 : `K-*`) |
| 16 | CI renforcée et veille Supabase fiable | ✅ fait (2026-11-14) | local | non (workflows non relancés) |
| 17 | Tests de synchro contre Supabase local | ✅ fait (2026-11-14) | 8 tests `supabase` (local) + horloge | Supabase local ; CI `supabase-tests` à voir |
| 18 | Hooks, commits conventionnels, tests d'intégration | ✅ fait (2026-11-14) | scripts + 4 parcours (Linux) | hooks non installés ; CI à voir |
| 19 | Accès rapide : widget et recherche vocale | ✅ fait (2026-11-14) | oui (plugins simulés) | non (téléphone) |
| 20 | Couvertures hors ligne, stats de lecture, partage des envies | ✅ fait (2026-11-15) | oui (connexion et cache simulés) | non (`O-*`, `T-*`, `E-*`) |
| 21 | Recette finale (reste de `TESTS_MANUELS.md`) | en cours (depuis 2026-11-15) — gel des fonctionnalités | — | — |

## 4. Phases

### Phase 14 — Vérifications de base en réel
Phase pilotée par l'utilisateur ; l'assistant analyse et corrige. Volontairement courte (environ une heure) :
seulement ce qui ne peut pas attendre la recette finale (phase 21).

- **CI** : premier passage des workflows (`Y-01`, ✅ 2026-11-14).
- **Compte** : schéma en place (`P-01`), création du compte dans l'appli (`P-04`), connexion sur le deuxième
  appareil (`S-01`). Le risque 3 (compte existant sans mot de passe) est sans objet : l'utilisateur ne s'était
  jamais connecté.
- **Synchro réelle** entre deux appareils (`S-04`) et nouveau filtre de pull (`S-05`, risque 2) : l'appli est
  utilisée au quotidien, une synchro cassée sans bruit jusqu'à la phase 17 n'est pas acceptable.
- **Journal** copiable (`J-02`) : moyen de rapporter tout échec, y compris pendant les phases suivantes.
- **Release de test** (`Y-02`, tag `v0.0.1-test` publié en *pre-release*, supprimé ensuite) et installation
  de l'APK signé sur le téléphone (`A-01`) : le circuit de publication n'a jamais tourné.
- Facultatif, si l'appli sert en magasin d'ici là : caméra et un livre possédé (`M-01`, `M-02`).
- Pour chaque échec : reproduire par un test automatisé quand c'est possible, **puis** corriger. Statut et date
  notés dans `TESTS_MANUELS.md`.

*Critère : les tests listés ci-dessus passent ou ont un écart documenté et accepté ; les workflows CI et
release ont tourné au moins une fois avec succès.*

**Bilan (2026-11-14)**
- **Réalisé** : CI verte au premier passage, Windows compris (`Y-01`) ; schéma Supabase vérifié (`P-01`) ;
  compte créé dans l'appli et connexion réussie sous Linux (`P-04`). Correctifs : tags `vX.Y.Z-suffixe`
  acceptés et publiés en *pre-release* (le tag de test prévu ne déclenchait rien) ; message après inscription
  et README précisés (le lien de confirmation redirige vers `localhost:3000`, page en erreur mais adresse
  confirmée) ; méthode « deux instances Linux » documentée pour tester la synchro sans téléphone.
- **Écarts** : `P-02` sans objet (aucun compte n'existait). Par décision de l'utilisateur, **reportés en tête
  de la phase 21** : `J-02` (journal vu vide, à revérifier), `S-01`, `S-05`, `S-04` (synchro réelle),
  `P-03`, `Y-02` (secrets et Release de test : le workflow release n'a donc pas encore tourné), `A-01`,
  `M-01`, `M-02` (Android).
- **Non vérifié** : tout ce qui est reporté ci-dessus ; en particulier le filtre de pull (risque 2) n'a
  toujours pas été confronté à un vrai serveur avant la phase 17.

### Phase 15 — Clés API saisies dans l'appli
Les Releases sont publiques : toute clé présente dans `ENV_JSON` est extractible des binaires.

- Paramètres → Sources : champs pour la clé Comic Vine et la clé Google Books (texte masqué, bouton
  afficher, bouton « Tester la clé » qui fait une requête réelle et affiche un message clair).
- Stockage dans `app_settings` local : **jamais synchronisé, jamais exporté dans les sauvegardes, jamais
  écrit dans le journal** (tests dédiés pour ces trois points).
- Résolution de la clé : clé saisie > `env.json` (pratique en développement). `sourceHasKey` et les
  providers lisent la clé au moment de l'appel ; une clé saisie active la source sans redémarrage.
- `release.yml` refuse de publier si `ENV_JSON` contient `COMIC_VINE_API_KEY` ou `GOOGLE_BOOKS_API_KEY`
  non vides, sans jamais afficher leur valeur.
- README : section « Clés des sources » (où les obtenir, où les saisir).

*Critère : une Release construite sans ces clés fonctionne avec Comic Vine après saisie de la clé dans
l'appli ; la clé n'apparaît ni dans une sauvegarde JSON, ni dans le journal, ni sur Supabase.*

**Bilan (2026-11-14)**
- **Réalisé** : Paramètres → Sources → *Clé API* sous Google Books et Comic Vine (champ masqué avec bouton
  afficher, *Tester la clé*, *Effacer*) ; clé saisie > `env.json` ; source activée sans redémarrage (les
  sources se reconstruisent quand une clé change). Stockage dans `app_settings` (local). Journal : toute clé
  connue (saisie ou compilée) est remplacée par `***`, ainsi que tout paramètre d'URL `key=` / `api_key=` /
  `token=`. `release.yml` : job `check-env` avant les builds, qui refuse un `ENV_JSON` contenant l'une des deux
  clés (n'affiche que leur nom ; simulé en local avec de fausses valeurs). README : « Clés des sources ».
- **Tests** : résolution des clés, persistance, activation sans redémarrage, absence de la clé dans la
  sauvegarde JSON, sur le faux serveur de synchro et dans le journal ; « Tester la clé » sur des réponses réelles
  (dont deux enregistrées avec une clé inventée) ; parcours complet dans Paramètres.
- **Écarts** : « Tester la clé » interroge un ISBN fixe (Google) ou une recherche « batman » (Comic Vine) plutôt
  que l'appel de l'appli. Aucune régénération de clé nécessaire : aucune Release n'a été publiée.
- **Non vérifié** : avec les vrais services et une version publiée (`K-01` à `K-05`, phase 21) ;
  `release.yml` n'a toujours jamais tourné.
- **Point découvert** : `OPEN_LIBRARY_CONTACT` (l'email de l'utilisateur) serait lui aussi lisible dans une
  Release publique ; d'abord seulement documenté, puis **refusé par `check-env`** (phase 21, 2026-11-15).

### Phase 16 — CI renforcée et veille Supabase fiable
- `ci.yml` : ajouter `dart format --output=none --set-exit-if-changed .` et une **vérification du code
  généré** (build_runner et `flutter gen-l10n`, puis `git diff --exit-code` sur les fichiers générés).
- Couverture : `flutter test --coverage`, rapport en artefact, pourcentage global dans le récapitulatif du job.
- Dependabot (`.github/dependabot.yml`) : écosystèmes `pub` et `github-actions`, hebdomadaire, cible `dev`,
  mises à jour mineures/patch groupées. La vérification du code généré attrape les mises à jour de
  freezed/drift/riverpod qui exigent une régénération.
- Badge de statut CI dans le README.Phase 16
- Veille Supabase : remplacer la requête refusée par la RLS par une vraie activité base, via une fonction
  SQL `keep_alive()` (`security definer`, renvoie `now()`, n'expose aucune donnée, exécutable par `anon`),
  nouvelle migration. Le workflow l'appelle par RPC.
- Tâches planifiées désactivées par GitHub après 60 jours sans activité du dépôt : trouver une solution
  **sans commit automatique** (par exemple réactivation via l'API GitHub), vérifier sa documentation
  actuelle, et documenter le comportement dans le README.

*Critère : un fichier mal formaté ou un `.g.dart` périmé fait échouer la CI ; Dependabot ouvre ses
premières pull requests ; le keep-alive appelle `keep_alive()` avec succès.*

**Bilan (2026-11-14)**
- **Réalisé** : `ci.yml` (job `test`) : `dart format --set-exit-if-changed .`, contrôle du code généré
  (build_runner + `flutter gen-l10n` puis `git status --porcelain` vide), `flutter test --coverage`, pourcentage
  hors code généré dans le récapitulatif (`tool/ci/coverage_summary.sh`), `lcov.info` en artefact.
  `.github/dependabot.yml` : `pub` et `github-actions`, hebdomadaire, vers `dev`, mineures et correctifs groupés
  (syntaxe vérifiée dans la doc officielle : `pub` pris en charge, `groups.update-types: [minor, patch]`).
  Badge CI dans le README. Migration `20261115090000_keep_alive.sql` : `keep_alive()` (`security definer`,
  `search_path` vide, renvoie `now()`, exécutable par `anon`/`authenticated`, retirée à `public`).
  `keep-alive.yml` l'appelle par RPC (en-tête `apikey` seul) et échoue si la réponse n'est pas 200.
  60 jours : le workflow se réactive lui-même à chaque passage (`PUT …/workflows/keep-alive.yml/enable`,
  `actions: write`), sans commit ; README documente la réactivation manuelle.
- **Vérifié en local** : le code actuel passe le formatage et ne change pas à la régénération ; couverture
  85,1 % (5144 / 6045 lignes écrites à la main) ; migration validée sur le PostgreSQL local (rôles substituts,
  transaction annulée) : appel anonyme OK, `public` sans droit d'exécution, aucune table lisible ; YAML valides.
- **Écarts** : `security definer` gardé comme demandé, bien qu'inutile pour `now()` (sans risque :
  `search_path` vide, aucune donnée lue). GitHub ne documente pas si réactiver un workflow actif remet le
  compteur des 60 jours à zéro : seule solution sans commit trouvée, à observer (`Y-13`).
- **Non vérifié** : aucun des workflows modifiés n'a tourné ; `keep_alive()` jamais appelé sur le vrai projet
  (migration à appliquer, `P-05`). **Dependabot ne pouvait pas fonctionner tel quel** : sa configuration n'est lue
  que sur la branche par défaut, alors `main` (« Initial commit »), et `dev` ne contenait que `PLAN.MD` — voir
  `P-06`. **Mise à jour 2026-11-15 (phase 21)** : la branche par défaut du dépôt est désormais `dev` (vérifié par
  l'API GitHub), qui contient le travail des phases et `.github/dependabot.yml` : Dependabot lit donc sa
  configuration sur `dev`. `P-06` probablement levé, à confirmer sur GitHub (Insights → Dependency graph →
  Dependabot : dernière exécution sans erreur) ; aucune pull request Dependabot à cette date (`Y-11`).

### Phase 17 — Tests de synchro contre Supabase local
Objectif : vérifier contre un vrai PostgREST/GoTrue ce que `fake_sync_remote.dart` simule.

- Supabase CLI (version épinglée) + Docker : `supabase start` applique `supabase/migrations/`. Configuration
  locale sans confirmation d'email. Documenter l'installation dans le README.
- Tests marqués `@Tags(['supabase'])`, **exclus de `flutter test` par défaut** (`dart_test.yaml`) pour que
  la suite habituelle reste rapide ; lancés par `flutter test --tags supabase`.
- Couvrir : filtre de pagination `or(...)` réel, égalités d'horodatage sur plusieurs pages, relecture de la
  dernière minute, triggers `server_updated_at` et dernière écriture gagnante, suppressions logiques, isolation
  RLS entre deux comptes, `keep_alive()`, upload/lecture d'une couverture dans le bucket privé, inscription et
  connexion par mot de passe.
- Job CI dédié (`supabase-tests`) sur Ubuntu, déclenché sur pull request et sur `dev`.
- Décalage d'horloge (risque 6) : à chaque synchro, comparer l'horloge de l'appareil à celle du serveur (en-tête
  `Date` de la réponse ou `now()` via RPC) ; au-delà de 2 minutes, entrée au journal et avertissement dans le
  statut de synchro (« L'heure de cet appareil semble fausse »). Pas de correction automatique.
- Mettre à jour `CLAUDE.md` : Supabase local autorisé, projet distant toujours interdit.

*Critère : `flutter test --tags supabase` passe en local et en CI ; un filtre PostgREST volontairement cassé
fait échouer un test.*

**Bilan (2026-11-14)**
- **Réalisé** :
  - `supabase/config.toml` écrit à la main (confirmation d'email désactivée, services inutiles coupés) — la CLI
    n'a pas pu être lancée pour le générer, à valider au premier `supabase start` ;
  - `dart_test.yaml` : tag `supabase` exclu par défaut, *preset* `supabase` ; `tool/supabase_tests.sh` (démarre
    Supabase local, lit `supabase status -o env`, **refuse toute URL non locale**, lance `flutter test -P supabase`) ;
  - 8 tests (`test/supabase/`) : synchro dans les deux sens et suppressions, égalités d'horodatage réparties sur
    plusieurs pages (filtre `or(...)` réel), commit tardif (relecture de la minute), dernière écriture gagnante
    et propriétaire conservés par le trigger, isolation RLS entre comptes, comptes par mot de passe (inscription,
    connexion, mauvais mot de passe, email pris, changement de mot de passe), `keep_alive()` en anonyme, photos
    privées par compte. Horodatages forcés par `psql` avec le trigger désactivé (base locale seulement) ;
  - job CI `supabase-tests` (PR et `dev`), CLI épinglée en 2.122.1 (`supabase/setup-cli@v3`) ;
  - **horloge** (risque 6) : `SyncRemote.serverTime()` via `keep_alive()` ; après une synchro, au plus une fois
    par heure, écart > 2 min → entrée au journal (une fois) et statut « l'heure de cet appareil semble fausse » ;
    rien si l'heure du serveur est inconnue. Testé avec le faux serveur.
- **Écarts** : `flutter test -P supabase` au lieu de `--tags supabase` (avec `exclude_tags` dans `dart_test.yaml`,
  `--tags` ne sélectionne rien : essayé). CLI épinglée en 2.122.1 (dernière 2.x) plutôt que 3.x sortie il y a
  12 jours. Les égalités d'horodatage ne se produisent pas naturellement contre un vrai serveur
  (`clock_timestamp()` par ligne) : elles sont forcées en SQL.
- **Vérifié** (Docker + CLI 2.122.1 via `npx`, accès Docker donné par l'utilisateur) : `supabase start`
  applique les 3 migrations (dont `keep_alive`) ; **les 8 tests passent du premier coup** contre le Supabase local
  (dont le vrai filtre `or(...)` de la phase 9 : risque 2 levé côté code) ; `supabase/config.toml` comparé à celui
  que génère `supabase init` 2.122.1 (aucune clé inconnue ; serveur d'emails de test coupé en plus).
  **Filtre volontairement cassé** (retour au seul `server_updated_at.gt`) : le test des égalités d'horodatage
  échoue (2 ouvrages reçus sur 5), puis fichier restauré à l'identique.
- **Non vérifié** : le job CI `supabase-tests` (n'a pas encore tourné : `Y-14`) ; le comportement sur le projet
  Supabase réel (phase 21, `S-05`).

### Phase 18 — Hooks, commits conventionnels, tests d'intégration
- `lefthook` (version épinglée, installation documentée) : pré-commit = format des fichiers Dart stagés +
  `flutter analyze` ; pré-push = `flutter test` ; commit-msg = vérification du format conventionnel
  (`feat:`, `fix:`, `chore:`, `docs:`, `test:`, `refactor:`, `ci:`) par un petit script dans `tool/`, sans
  dépendance Node.
- L'assistant ne committe toujours pas, mais **propose un message de commit conventionnel** à la fin de
  chaque phase. À ajouter dans `CLAUDE.md`.
- Changelog : notes de Release générées depuis les commits conventionnels entre deux tags (outil léger et
  épinglé, par exemple git-cliff), utilisées comme description de la Release.
- Tests d'intégration (`integration_test/`), sources et Supabase simulés : ajout manuel d'un tome dans une
  série, mode Magasin pour un ISBN possédé / en envie / tome manquant / inconnu, prêt puis retour, annulation
  d'une suppression. Exécutés en CI sur Linux (affichage virtuel) ; lancement sur téléphone documenté dans
  `TESTS_MANUELS.md`.

*Critère : un message de commit non conventionnel est refusé localement ; une Release de test affiche un
changelog généré ; les tests d'intégration passent en CI.*

**Bilan (2026-11-14)**
- **Réalisé** : `lefthook.yml` (lefthook 2.2.2, syntaxe `jobs` vérifiée dans sa doc à cette version,
  `glob_matcher: doublestar`) : pré-commit `dart format {staged_files}` + `stage_fixed` et `flutter analyze`,
  pré-push `flutter test`, commit-msg `tool/check_commit_msg.sh {1}` (bash, sans Node ; types du plan, portée en
  minuscules, `!`, 100 caractères max ; messages Merge/Revert/fixup!/squash!/amend! acceptés). Notes de Release :
  `tool/ci/release_notes.sh` (depuis le tag **stable** précédent, groupées par type en français, commits non
  conventionnels sous « Autres changements »), utilisé comme description par `release.yml` (`body_path`,
  historique complet). `integration_test/app_flows_test.dart` : ajout d'un tome à la main, mode Magasin
  (possédé / envie / tome manquant / inconnu), prêt puis retour, annulation d'une suppression ; job CI
  `integration` (`xvfb-run`). README « Hooks git » et « Tests d'intégration ». `CLAUDE.md` : l'assistant propose
  un message de commit conventionnel en fin de phase.
- **Vérifié en local** : les deux scripts par des tests Dart (dont un dépôt git temporaire avec tags stable et
  *pre-release*) ; les 4 parcours d'intégration passent sur l'appli Linux réelle (12 s).
- **Écarts** : pas de git-cliff : un script de 40 lignes sans dépendance, testable ici (git-cliff n'est pas
  installé et je ne peux pas l'exécuter). Le parcours Magasin est sauté sur téléphone (la caméra demande une
  autorisation que le test ne peut pas accorder).
- **Non vérifié** : lefthook n'est pas installé sur le poste (hooks jamais déclenchés : `H-01` à `H-03`) ; jobs
  CI `integration` et notes de Release jamais exécutés (`Y-15`) ; tests d'intégration sur téléphone (`H-04`).

### Phase 19 — Accès rapide : widget et recherche vocale
- **Widget Android** d'écran d'accueil (package `home_widget`, version et API vérifiées) : bouton
  « Scanner » qui ouvre le mode Magasin (même routage que le raccourci existant), et compteurs facultatifs
  (nombre d'ouvrages, prêts en retard) mis à jour après écriture ou synchro, regroupés pour ne pas
  rafraîchir en boucle. Android seulement, jamais appelé sur PC ni en test (fake injecté par `pumpApp`).
- **Recherche vocale** dans la barre de recherche globale (`speech_to_text`, vérifier les plateformes
  supportées ; bouton masqué là où ce n'est pas disponible), langue française, permission micro demandée à
  la première utilisation avec message d'explication.
- Analyse de la phrase dictée (`parseSpokenQuery`, domaine pur) : série + numéro de tome à partir de
  formulations comme « One Piece tome 107 », « Astérix numéro 12 », « Naruto volume douze », « tome 3 de
  Blacksad ». Nombres en lettres jusqu'à cent au moins. Tests unitaires couvrant ces cas.
- Objectif : du widget au scanner prêt en moins de 2 secondes à froid (mesure documentée dans
  `TESTS_MANUELS.md`).

*Critère : depuis l'écran d'accueil du téléphone, le widget ouvre le scan ; « One Piece tome 107 » dicté
affiche directement ce tome ou son absence.*

**Bilan (2026-11-14)**
- **Réalisé** :
  - **widget Android** (`home_widget` 0.10.0, Android et iOS seulement) : `DupeWidgetProvider.kt` + mise en
    page `dupe_widget.xml` (bouton « Scanner » bleu de l'icône, compteurs) ; le bouton ouvre `dupe://scan`, routé
    comme le raccourci (au lancement : `initiallyLaunchedFromHomeWidget`, appli ouverte : `widgetClicked`) ;
    compteurs « N ouvrages · N prêts en retard » préparés en Dart (traductions) et envoyés 2 s après la dernière
    modification d'ouvrages ou de prêts (synchro comprise), seulement si le texte change (`HomeWidgetUpdater`) ;
  - **dictée** (`speech_to_text` 7.5.0 : Android et Windows, **pas Linux** → bouton masqué) : micro dans la barre
    de recherche globale et dans l'écran de recherche, explication avant le premier usage (puis autorisation
    Android), panneau « J'écoute… » avec « Arrêter » (le refermer arrête l'écoute), français, `RECORD_AUDIO` et
    `RecognitionService` déclarés ;
  - **`parseSpokenQuery`** (domaine pur) : « X tome/numéro/n°/volume N », « tome N de/du/d' X », « X 12 » ;
    nombres en lettres jusqu'à 999 999 (`parseFrenchNumber`) ; `lookUpSpoken` : tome trouvé (exemplaire possédé
    d'abord) → fiche, série sans ce tome → série + « absent de ta collection », sinon recherche normale.
- **Tests** : 13 cas de phrases et 18 de nombres ; widget (ouverture du scan au lancement et appli ouverte,
  compteurs regroupés et non renvoyés à l'identique) ; dictée (tome trouvé, absent, phrase simple, explication
  une seule fois, annulation, rien entendu, pas de micro). Suite : 190 tests ; intégration : 4 parcours.
- **Écarts** : le compteur « prêts en retard » n'apparaît que s'il y en a ; une seule taille de widget
  (redimensionnable en largeur).
- **Non vérifié** : tout le côté téléphone (widget réel, chrono < 2 s à froid, micro, reconnaissance française,
  Windows) — `G-01` à `G-04`, `V-01` à `V-04`.
- **Risque nouveau** : `home_widget` 0.10.0 (dernière version) applique encore le Kotlin Gradle Plugin ; Flutter
  annonce que de futures versions refuseront de compiler (avertissement au build Android). Surveiller ses
  mises à jour (Dependabot).

### Phase 20 — Couvertures hors ligne, stats de lecture, partage des envies
- **Couvertures hors ligne** : préchargement en arrière-plan de toutes les couvertures de la collection et
  des envies (y compris les photos `dupe-cover:`), en Wi-Fi uniquement par défaut, réglable, interrompu
  proprement si la connexion change. Paramètres : taille du cache, progression, bouton « Vider ».
- **Statistiques de lecture** (nouvelle section de l'écran Statistiques) : ouvrages lus par mois sur 12 mois,
  pourcentage lu par type, délai moyen entre achat et lecture (seulement si les deux dates existent),
  taille de la pile à lire et ancienneté de son plus vieil ouvrage, séries abandonnées. Vérifier que
  marquer « lu » renseigne bien `read_date` ; sinon le corriger, sans inventer de date pour l'existant.
- **Partage de la liste d'envies** : filtres par type et priorité, puis image soignée (couvertures, titres,
  tomes ; prix max en option) générée hors écran et partagée via `FileIo` (feuille de partage sur Android,
  enregistrement sur PC), plus une version texte. Couvertures chargées avant la capture, repli sur une
  vignette sans image.

*Critère : en mode avion, toute la collection s'affiche avec ses couvertures ; la liste d'envies part par
message en image ; les stats de lecture correspondent à un jeu de test calculé à la main.*

**Bilan (2026-11-15)**
- **Réalisé** :
  - **couvertures hors ligne** : cache dédié `coverCacheManager` (`features/covers/data/cover_cache.dart`) dans le
    dossier support (`<support>/cover_cache`), utilisé par `CoverImage`. Le cache par défaut ne gardait que
    **200 fichiers 30 jours dans le dossier temporaire** (`/tmp` sous Linux, vidable par Android) : une grande
    collection n'aurait jamais été entièrement hors ligne. Préchargement `CoverPrefetch` (`cover_prefetch.dart`) :
    toutes les couvertures d'ouvrages et de séries non supprimés (envies comprises, photos `dupe-cover:`
    récupérées via `ensureUserCover`), une à une, au démarrage, au retour dans l'appli et à chaque changement
    de connexion ; Wi-Fi/câble seulement par défaut (`connectivity_plus` 7.3.2, `core/network/network_status.dart`),
    arrêt dès que la connexion n'est plus permise. Paramètres → *Couvertures hors ligne* : activer, Wi-Fi
    seulement, état/progression, place utilisée, « Vider » (photos de l'utilisateur jamais touchées) ;
  - **statistiques de lecture** (`stats/domain/reading_stats.dart`, section `reading_stats_section.dart`) : tomes lus
    par mois sur 12 mois (graphique + tableau, `MonthlyChart` généralisé), part lue par type, délai moyen achat →
    lecture (les deux dates requises, lectures avant achat exclues), pile à lire et son plus ancien tome (date
    d'achat, sinon d'ajout), séries avec un tome abandonné ; tomes comptés une fois même en plusieurs exemplaires ;
  - **date de lecture** : la puce « Lu » et « lus jusqu'au tome N » la remplissaient déjà ; **le formulaire ne le
    faisait pas** → corrigé (date du jour si vide). Rien d'inventé pour l'existant : les tomes lus sans date sont
    seulement comptés à part (« N tomes lus sans date… ») ;
  - **partage des envies** (`wishlist/presentation/share/`, route `/plus/envies/partager`) : filtres par type et
    priorité maximale, prix max en option, aperçu = l'image elle-même (`RepaintBoundary`, capture à 3× au plus,
    8000 px de haut maximum), couvertures préchargées avant la capture (vignette grise sinon), PNG via
    `FileIo.save` (feuille de partage Android, « Enregistrer sous » sur PC), version texte via
    `FileIo.shareText` (feuille de partage Android, presse-papiers sur PC).
- **Tests** : 13 nouveaux (préchargement ×4, connexion, stats de lecture ×2 dont le jeu calculé à la main, écran
  Statistiques, Paramètres ×2, partage ×2, date de lecture du formulaire — vérifié en échec sans le correctif).
  Suite : 203 tests ; intégration : 4 parcours.
- **Écarts** : l'aperçu est l'image capturée (pas un rendu totalement hors écran) ; pas de limite de taille du
  cache réglable, seulement la place affichée et « Vider » ; les couvertures téléchargées avant cette phase
  (ancien cache temporaire) sont retéléchargées une fois.
- **Non vérifié** : appareil réel (mode avion, Wi-Fi/données mobiles, feuille de partage, presse-papiers,
  Windows) — `O-01` à `O-04`, `T-01`, `T-02`, `E-01` à `E-03`.

### Phase 21 — Recette finale
Phase pilotée par l'utilisateur, sur la version issue de la phase 20 installée depuis une Release.

- **En premier : les tests reportés de la phase 14** (liste en tête de la section « Phase 21 » de
  `TESTS_MANUELS.md`) : `J-02`, `S-01`, `S-05`, `S-04`, `P-03`, `Y-02`, `A-01`, `M-01`, `M-02`.
- **Préparée au fil des phases** : chaque phase 15-20 ajoute à `TESTS_MANUELS.md` les tests de ce qu'elle
  livre, et marque « automatisé (phase N) » ceux que ses tests couvrent désormais (phases 17 et 18
  surtout) ; ces derniers ne sont plus déroulés à la main.
- Dérouler le reste de `TESTS_MANUELS.md` sur téléphone, Linux et Windows, dans l'ordre conseillé du fichier.
- Comme en phase 14 : chaque échec est reproduit par un test automatisé si possible, puis corrigé.
- Tests longs à lancer tôt dans la phase : notifications de prêt (lendemain), deux Releases **stables**
  successives pour la mise à jour (`A-02`, `Y-03`), observation de la veille Supabase (`Y-06`, plusieurs
  semaines).

*Critère : tous les tests de `TESTS_MANUELS.md` passent, sont automatisés, ou ont un écart documenté et
accepté.*

**Gel des fonctionnalités (2026-11-15, après fusion de la branche Authors dans `dev`)** : seuls les bugs et les
écarts aux tests sont corrigés ; toute nouvelle idée va dans « Après la v3 — idées notées », sans être codée.
Avant la reprise des tests : `check-env` refuse aussi `OPEN_LIBRARY_CONTACT` ; architecture détaillée déplacée de
`CLAUDE.md` vers `docs/ARCHITECTURE.md` (`CLAUDE.md` désormais versionné) ; branche par défaut `dev` (`P-06`).

**Déroulé** :
- `J-02` OK (2026-11-15, Linux et Android). Écart corrigé : le journal répétait la même liste de couvertures en
  échec à chaque relance du préchargement → écrite une fois tant qu'elle ne change pas (`cover_prefetch_test.dart`).
- `S-01`, `S-04`, `S-05` OK (2026-11-15, téléphone ↔ PC Linux ; synchro reçue dans les deux sens avec le
  filtre de pull de la phase 9).
- Exception au gel accordée par l'utilisateur (2026-11-15) : légende des pastilles placée **au-dessus** de la grille
  d'une série (hors de vue en dessous pour une longue série). Test dans `series_navigation_test.dart`.
- Exception au gel demandée par l'utilisateur (2026-11-15) : « Compléter les couvertures manquantes » n'interroge
  plus la BnF (jamais d'image ; source souvent la plus lente) : `lookupIsbn(…, except: {bnf})`. Tests dans
  `missing_covers_test.dart` et `metadata_aggregator_test.dart`.
- Exception au gel validée par l'utilisateur (2026-11-15, revue des idées) : ISBN affiché dans les résultats de
  recherche (`resultSubtitle(withIsbn:)`, tuiles de la recherche locale), barre indicative
  (`SeriesEntry.highestVolume` / `indicativeProgress`, `series_progress_bar.dart`), menu « Marquer comme lus » de la
  page auteur (`author_menu.dart`, `markOwnedRead`). Tests : `search_screen_test.dart`, `online_search_test.dart`,
  `series_navigation_test.dart`, `author_screen_test.dart`. `PLAN_V4.md` commencé (brouillon).
- Recette mise au second plan par l'utilisateur (2026-11-15) pour les améliorations. **Obfuscation des Releases
  publiques** : `release.yml` (APK, AppImage via `FLUTTER_BUILD_ARGS`, Windows) avec `--obfuscate
  --split-debug-info`, zips de symboles joints à la Release ; vérifié par expérience que l'obfuscation garde
  `Enum.name` (clés API, sources désactivées, sauvegardes compatibles entre builds) mais pas `runtimeType` →
  `coverError` et `LogObserver` n'en dépendent plus (`cover_cache_test.dart`). AppImage obfusquée construite en
  local avec ses symboles. À vérifier à la prochaine Release (`Y-16`).
- `P-03` OK (cinq *repository secrets* ; un premier essai avec tout dans un seul secret donnait « Missing secret
  ENV_JSON »). `Y-02` OK : premier passage de `release.yml` (tag `v0.0.1-test` sur `Phase21`), *pre-release*
  complète, APK signé avec la clé de l'utilisateur, aucune donnée personnelle dans le binaire.
- `A-01`, `M-01`, `M-02` OK (téléphone, APK de la Release). **Tests reportés de la phase 14 : tous faits.**
- `P-05` (migration `keep_alive`) et `Y-05` (veille lancée à la main) OK. Release de test supprimée.
  **Première version stable `v0.1.0`** publiée le 2026-11-15 (tag sur `main`, fusion Phase21 → `dev` → `main`).
  `N-01` lancé le 2026-11-15 (retour le lendemain) ; date proposée par défaut J+30 (`lend_dialog.dart`, prévu).
- CI : déclencheur `push` retiré de `ci.yml` (décision de l'utilisateur : une branche avec une PR passait deux
  fois) ; restent `pull_request` et `workflow_dispatch` ; badge du README sur `?event=pull_request` (`Y-12`).
- Compte : `S-11`, `S-12` OK ; `S-10` (changement de mot de passe) reporté par l'utilisateur.
- Synchro : `S-09` OK ; `S-04`/`S-05` déjà validés ; `S-06` à `S-08` reportés par l'utilisateur.
- Journal : `J-01`, `J-03`, `J-04` OK ; `J-05` partiel (fichier invalide reporté).
- Téléphone : `M-03` à `M-05`, `M-07`, `M-11`, `M-12` OK. **`M-14` en échec** : avec l'appli en arrière-plan
  sur l'écran de scan, caméra et lampe restaient allumées (contrôleur `MobileScannerController` créé par nous : le
  widget ne suit alors pas le cycle de vie) → `AppLifecycleListener` qui arrête la caméra quand l'appli est cachée
  et la relance au retour. Non testable automatiquement (plugin caméra Android) : à revérifier sur le téléphone.
  `M-09`/`M-10` (vibrations) : rien ne vibre, réglages haptiques du téléphone à vérifier. **Mode rafale (`R-01` à
  `R-04`) reporté après la v4** (décision de l'utilisateur) : écart accepté pour la recette de la v3.
- `M-14` OK après correction (lampe non rallumée au retour : accepté), `M-06` OK, `M-13` OK. Écart corrigé : le
  message « Code UPC » apparaissait souvent en scannant des livres (deux codes-barres dans la même image, le premier
  lu n'étant pas toujours l'ISBN) → `pickScannedCode` préfère l'ISBN (`parse_scanned_code_test.dart`).
- Fichiers et filets de sécurité : `F-01`, `F-02`, `B-01` à `B-03`, `B-05` à `B-08` OK ; `F-03` à `F-05`, `B-04`
  reportés. Code-barres très petit et plat (livre ActuSF) non lu à distance : conseils donnés (se rapprocher,
  « Saisir l'ISBN ») ; résolution d'analyse de la caméra à augmenter seulement si le problème persiste de près.
- Données réelles : `D-04`, `D-05` OK ; `D-01` à `D-03` à confirmer.
- Plateformes : `A-03`, `L-01` OK (icône absente du dock GNOME sans entrée `.desktop` : intégration documentée
  dans le README) ; Windows (`W-*`) reporté.
- Hooks : le pré-commit lance format et analyse en parallèle, et seulement si le commit contient du Dart (commits
  de documentation instantanés) ; pré-push inchangé (tests).
- Clés des sources : `K-01` à `K-04` OK sur la v0.1.0 (AppImage + téléphone) ; `K-05` vérifié en local.
- **Release `v0.1.1`** publiée le 2026-11-16 (fusion Phase21 → `dev` → `main`) : premier passage obfusqué, 3 zips
  de symboles présents, APK ~2 Mo plus légers.
  Mise à jour vérifiée : `A-02`, `Y-03`, `Y-04`, `Y-16` OK.
- Widget et dictée (`G-01` à `G-04`, `V-01` à `V-03`) OK sur Xiaomi / Android 14 ; `V-04` (Windows) reporté.
- Couvertures hors ligne, stats de lecture, partage des envies (`O-*`, `T-*`, `E-*`) : rien d'anormal.
- Écart : « Les quatre accords toltèques » et « Antidote au culte de la performance » créaient les séries « Poches
  Jouvence » (n° 1) et « Tracts Gallimard » (n° 50) : collections d'éditeur numérotées en 225, sans 461. Dans les
  notices BnF, une vraie série a toujours son 461 → `_seriesCollection` ignore un 225 sans 461 (fixture réelle
  `bnf/isbn_9782073047342.xml`).
- WARP 1 et 2 (Eoin Colfer) restés vides : tomes créés par « Il te manque … → Ajouter » (titre et numéro seuls). Au
  scan d'un tome sans ISBN, l'ISBN était mémorisé mais le reste jamais complété → `fillBlanks`
  (`metadata_mapping.dart`) remplit les champs vides depuis la source, sans écraser une saisie (titre remplacé
  seulement s'il est celui de la série). Tests `fill_blanks_test.dart`, `store_mode_test.dart`.
- Envies : glisser une envie vers la gauche la retire, avec « Annuler » (demande de l'utilisateur ; avant, seulement
  via la fiche → *Supprimer*). Test `wishlist_test.dart`.
- Test de rapidité du mode magasin (`store_mode_test.dart`) : chronométré du code saisi au verdict, sans le
  démarrage de l'appli de test (échouait quand la machine était chargée).
- `N-01` en échec : notifications de Dupe désactivées sur le téléphone (autorisation perdue avec une
  désinstallation), sans que l'utilisateur le sache ; et une réinstallation perdait tous les rappels. Corrigé :
  `LoanActions.reminderWillShow` (message au prêt si les notifications sont coupées, `areNotificationsEnabled`) et
  `syncReminders` au démarrage (rappels des prêts en cours reprogrammés, ceux des prêts rendus annulés).
  Tests dans `loans_flow_test.dart`.

**Retours déjà traités (2026-11-15, APK release sur Android)** :
- Free Quest tome 1 scanné en magasin : aucune série proposée. La BnF n'a pas ce tome ; l'autre source
  donne « Free Quest Tome 1 » sans numéro → `withVolumeFromTitle` (`metadata_merge.dart`) sépare le
  numéro du titre (« Tome 1 », « T01 », « Vol. 3 : sous-titre », « Livre 2 »). Test dans
  `metadata_aggregator_test.dart`.
- Journal : `[update] 404` à chaque démarrage tant qu'aucune Release n'est publiée → 404 = « à jour »
  (fixture réelle `github/latest_release_none.json`).
- « Voir la série » depuis un tome empilait une nouvelle page : le retour rejouait tout le parcours →
  `context.go` (pile onglet > série). Séries créées au scan sans couverture propre (listes, écran de série)
  → couverture du premier tome qui en a une. Test `series_navigation_test.dart`.
- Jumeaux Fowl tome 3 : série « Folio junior » proposée. La BnF met la collection d'éditeur numérotée en 225
  (« Folio junior » n° 1987) → `_seriesCollection` (`unimarc_parser.dart`) : 225 ignoré si le titre porte son
  propre tome (200 $h) sans 461, si un 461 désigne une autre série, ou si le numéro ≥ 1000. Fixture réelle
  `bnf/search_jumeaux_fowl.xml`.
- Confirmation avant de quitter (Android) : retour sur la racine d'un onglet → « Appuie de nouveau sur retour
  pour quitter » (2 s, `app/exit_guard.dart`). Test `exit_guard_test.dart`.
- Aucun indicateur « lu » : coche sur les pastilles des tomes lus (+ légende), « tout lu » sur la ligne d'une
  série, « Lu » sur un livre isolé (`reading_test.dart`).
- Couvertures de la collection importée : Paramètres → « Compléter les couvertures manquantes »
  (`covers/data/missing_covers.dart` : items avec ISBN sans couverture, recherche par ISBN, URL gardée seulement
  si elle se télécharge — mise en cache au passage) ; remplace aussi une adresse qui ne se télécharge pas (devinette
  Open Library enregistrée au scan), jamais une photo. Test `missing_covers_test.dart`.
- Ajout d'un tome N possédé dans une série : « Il te manque k tomes avant le N : les ajouter comme possédés ? »
  [Ajouter] (`item/previous_volumes_offer.dart`, `addVolumeRange`). Test dans `series_navigation_test.dart`.
- Jumeaux Fowl tome 1 Folio (9782075173827) : la fiche BnF a la série mais pas de numéro → bandeau « Tome ? de… ».
  Bandeau : « <titre> — série <série> » sans numéro ; le numéro est aussi lu dans le titre de **chaque** source avant
  la fusion (« Les jumeaux Fowl - Tome 1 » de Google comble le manque de la BnF).
- Scan ouvert hors d'un onglet de collection (journal, Plus, raccourci) : rangé en Livres. Menu de type dans la barre du
  scan, dernier choix mémorisé (`scan_last_type`).
- Un onglet rouvrait la dernière série/fiche consultée : il s'ouvre toujours sur sa liste (`goBranch(initialLocation: true)`).
- Tome sans numéro dans une série (Fowl 1 Folio) : compté dans la liste mais invisible dans la grille (« il manque
  le tome 1 ») → pastille « ? » en fin de grille, qui ouvre la fiche pour le numéroter (`volume_grid_test.dart`).
- Journal des couvertures : adresses en échec avec leur cause (HTTP 404…) ; « Compléter » liste les livres restés
  sans couverture et les sources qui ont répondu (diagnostic Kaamelott tome 1 : Open Library n'a rien, seul
  Google Books peut fournir l'image).
- **Vue par auteur** (demande de l'utilisateur, 2026-11-15) : puce « Par auteur » dans chaque onglet (auteurs triés
  par nom de famille, séries / livres / possédés, suit les filtres), page d'un auteur (`/…/auteur?nom=`), noms
  d'auteur cliquables sur les fiches livre et série (`features/authors/`). Noms regroupés sans ordre (« Colfer, Eoin »),
  accents ni casse ; une série sans auteur prend ceux de ses tomes. Les noms d'auteur ouvrent la page par `context.go`
  (pile onglet > auteur : le retour ne rejoue pas les allers-retours auteur ↔ série). Tests `author_groups_test.dart`,
  `author_screen_test.dart`.
- « Ajouter des tomes » proposait jusqu'au tome (nombre de pastilles + 1) : Jumeaux Fowl 1 et 3 → tome 4 inexistant
  créé. Proposition = total connu, sinon le plus haut tome présent s'il y a des trous, sinon le suivant
  (`VolumeGrid.suggestedRangeEnd`, `volume_grid_test.dart`).
- Écarts acceptés : manga scanné depuis l'onglet Comics rangé en Comics (l'onglet décide quand aucune
  série existante ne correspond) ; couvertures absentes quand aucune source n'a d'image (la BnF n'en
  fournit pas, Open Library rarement pour les éditions françaises).
- **Revue de code complète (2026-11-16)** : 5 revues en lecture seule (bugs + `/simplify`) sur tout le projet ;
  étape 1, les bugs, corrigée avec un test par bug (269 tests) :
  - « Compléter par scan » vérifie aussi le numéro de tome (tome 4 sur la carte du tome 3 → avertissement) ;
  - la rafale complète un tome créé vide au lieu d'en faire un 2ᵉ exemplaire (`same_volume.dart`, partagé avec le
    mode magasin) ;
  - liste des séries et fiche comptent les tomes pareil (hors-séries, tomes sans numéro, « 07 », éditions lues) ;
  - synchro : une session révoquée pendant une synchro ne bloque plus la reprise ; écouteur local annulé ;
  - vue liste : plus de clé en double avec deux tomes sans numéro ;
  - renommer une série renomme les tomes qui portaient son titre ;
  - prêts : retard notifié aussi sur Android (prêt synchronisé déjà en retard), rappel d'un tome supprimé annulé ;
  - caméra arrêtée quand un autre écran la recouvre (`M-15`, manuel) ;
  - photos envoyées suivies par compte (un autre compte les reçoit ; toutes renvoyées une fois après mise à jour) ;
  - import CSV : erreur affichée, bouton rendu ; un enregistrement ne fait jamais revivre une ligne supprimée
    (`upsert.dart`) ; code scanné pendant la vérification de « Compléter par scan » traité ensuite ;
  - journal des couvertures : nouvelle entrée si le nombre d'échecs change, ordre stable.
  Écarts acceptés : « Télécharger maintenant » et la réactivation ne rejournalisent pas un échec identique (choix
  de la phase 20, testé). Étapes 2-3 de la revue (factorisations, efficacité, outillage) : à planifier.

### Après la v3 — idées notées
Revue avec l'utilisateur le 2026-11-15 :
- **Faites en phase 21** (exception au gel) : ISBN dans les résultats de recherche texte et locale ; barre de
  progression **indicative** (grise : possédés / plus haut tome connu) pour les séries sans total ; « Marquer
  comme lus » depuis la page d'un auteur (livres hors série, ou tout avec les séries ; confirmation, date du jour).
- **Fait le 2026-11-15** (avant la Release `v0.1.1`) :
  - **Obfuscation des Releases publiques** (discuté le 2026-11-15) : `release.yml` avec `--obfuscate
    --split-debug-info`, symboles joints à chaque Release (pour `flutter symbolize` des traces du journal) ; avant cela,
    ne plus journaliser `runtimeType` (`coverError` dans `cover_cache.dart` : noms de classes illisibles une fois
    obfusqués). **Seulement les Releases publiques** (décision de l'utilisateur) : les APK signés construits en local
    pour son propre téléphone, même en release, restent non obfusqués (journal lisible). Gain observé : ~1,7 Mo sur l'APK arm64 ; ne protège pas les
    textes (secrets) : `check-env` reste nécessaire.
- **Toutes les autres idées sont reprises dans `PLAN_V4.md`** (fusionné le 2026-11-16 avec le plan v4 de
  l'utilisateur) : nombre de tomes et vue liste (23, faite) ; titres des tomes (24) ; qualité des données (22) ;
  couvertures par recherche texte et autre édition d'un livre hors série (25) ; **fin de la recette de la v3 (26)** ;
  livres numériques (27-28) ; photos, dédicaces, sources, alertes, recommandations (29-33) ; mot de passe oublié et
  liens de confirmation (34) ; recette v4 avec le mode rafale (35).

## 5. Actions manuelles de l'utilisateur
- **Phase 14** : créer le compte dans l'appli (fait). Le reste est reporté en phase 21.
- **Phase 15** : créer le secret `ENV_JSON` **sans** `COMIC_VINE_API_KEY` ni `GOOGLE_BOOKS_API_KEY` (et sans
  `OPEN_LIBRARY_CONTACT` pour ne pas publier son email) ; restreindre la clé Google Books à la Books API ;
  saisir les clés dans l'appli sur chaque appareil. Pas de régénération : aucune Release n'a été publiée.
- **Phase 16** : appliquer la migration `20261115090000_keep_alive.sql` ; activer Dependabot si nécessaire et
  vérifier qu'il lit sa configuration (branche par défaut = `dev` depuis la phase 21 : plus besoin de porter
  `.github/dependabot.yml` sur `main`) ; protéger `main` (pull request obligatoire, CI verte exigée) dans les
  réglages du dépôt.
- **Phase 17** : accès à Docker sans sudo (`sudo usermod -aG docker $USER`, puis se reconnecter), Supabase CLI
  2.122.1 (`.deb`, README « Tests de synchro contre un Supabase local »), `postgresql-client`.
- **Phase 18** : installer lefthook 2.2.2 (`.deb`, README « Hooks git ») puis `lefthook install`.
- **Phase 21** : d'abord les tests reportés de la phase 14 (synchro, secrets GitHub, Release de test,
  APK sur le téléphone), puis dérouler `TESTS_MANUELS.md` ; publier deux versions stables successives.

## 6. Hors périmètre (inchangé)
iOS/macOS, partage de collection, alertes de sortie des nouveaux tomes, scraping, cote automatique,
service externe de suivi d'erreurs.