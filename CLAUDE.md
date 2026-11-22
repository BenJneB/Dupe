# Dupe — conventions du projet

Application Flutter personnelle de gestion de collection (mangas, BD, comics, livres), pour Android, Linux et
Windows, avec synchro Supabase optionnelle.
**État courant et suite du projet : `PLAN_V4.md`** (à relire avant chaque phase ; tenir à jour son tableau §3 et
ajouter un bilan « Réalisé / Écarts / Non vérifié » sous chaque phase terminée).
Historique : `PLAN.md` (spécification v1, phases 0-8) et `PLAN_V2.md` (phases 9-13, état au 2026-11-14).
Suite : `PLAN_V4.md` (phases 22-37, ordre d'exécution et décisions dans son §3). Phases 22-25, 29-34 et 37 faites ;
PWA (36) et livres numériques (27-28) abandonnés pour le moment (2026-11-20) ; tests manuels (recette v3 restante
et recette v4, phases 26 et 35) plus tard. En cours : corrections et améliorations tirées des écarts des bilans.
`PLAN_V3.md` prime en cas de contradiction (ex. Supabase **local** autorisé pour les tests, projet distant
toujours interdit). Recettes (21, 26, 35) pilotées par l'utilisateur : il rapporte les échecs de
`TESTS_MANUELS.md` et des workflows ; pour chaque échec, le reproduire par un test automatisé si possible, puis
corriger. Chaque phase ajoute ses tests manuels à `TESTS_MANUELS.md` et marque « automatisé (phase N) » ceux que
ses tests couvrent désormais. On avance phase par phase ; s'arrêter à la fin de chaque phase et attendre le retour
de l'utilisateur.

**Architecture : lire `docs/ARCHITECTURE.md`** avant de modifier ou d'ajouter du code dans un module, ou pour
savoir où vit une fonctionnalité (stack et versions, organisation de `lib/`, fonctionnement de chaque feature :
sources de métadonnées, scan, synchro, sauvegardes, couvertures, CI…). Le mettre à jour quand la structure change.

## Règles techniques (détail et raisons dans `docs/ARCHITECTURE.md`)
- Flutter stable 3.50 / Dart 3.14. Cibles : **android, windows, linux** (macOS abandonné, iOS hors périmètre).
- Material vient du package **`material_ui`** : importer `package:material_ui/material_ui.dart`, jamais
  `package:flutter/material.dart`.
- Scan caméra (mobile_scanner) : **Android uniquement** ; ne jamais l'instancier hors Android
  (`defaultTargetPlatform`).
- Liens externes seulement (Bédéthèque, Manga-News, Comic Vine) : **jamais de scraping**.
- Toute image réseau passe par **`coverCacheManager`** (`features/covers/data/cover_cache.dart`), jamais le
  `DefaultCacheManager`.
- Supabase : package Dart pur `supabase` (pas supabase_flutter). **Jamais de connexion au projet Supabase
  distant** ; Supabase **local** autorisé pour les tests (`sg docker -c tool/supabase_tests.sh`, puis
  `sg docker -c "npx -y supabase@2.122.1 stop"` ; `flutter test -P supabase`).
- Contact Open Library (`OPEN_LIBRARY_CONTACT`) et clés API : seulement dans env.json / saisies dans l'appli,
  jamais en dur, jamais synchronisés ni sauvegardés ; toute clé passe par `appLog.hideSecret`. Jamais de secret
  dans le journal.
- Messages d'erreur : `errorText(l10n, e)` / `reportError` (`app/error_text.dart`), jamais `'$e'` à l'écran.
- Navigation vers une série ou un auteur depuis une fiche (« Voir la série », noms d'auteur) et résultats de la
  recherche vocale : `context.go`, jamais `push` (sinon le retour rejoue tout le parcours / conflit de clés).
- Snackbar avec action : `persist: false` (material_ui la garde sinon jusqu'à fermeture).
- **Fichiers courts** (préférence de l'utilisateur) : viser < 250 lignes par fichier écrit à la main ; découper
  un écran qui grossit en widgets/fichiers dans son dossier.

## Règles de code
- Code, identifiants et commentaires en **anglais** ; textes d'interface en **français**, toujours dans
  `lib/l10n/app_fr.arb` (jamais de chaîne UI en dur). Après modif ARB : `flutter gen-l10n`.
- Délégués de localisation : `AppLocalizations.delegate` + `GlobalMaterialLocalizations.delegates`
  (de material_ui). Ne pas utiliser `AppLocalizations.localizationsDelegates` (legacy, casse Material).
- Aucun appel réseau depuis les widgets : passer par repositories + providers.
- Lints stricts `very_good_analysis` + strict-casts/inference/raw-types. `flutter analyze` doit être à zéro.
  Le lint impose la syntaxe Dart 3.14 `const new(...)` pour les constructeurs.
- Fichiers générés (`*.g.dart`, `*.freezed.dart`, `*.drift.dart`, `l10n/gen/`) versionnés ; régénérer avec
  `dart run build_runner build -d`. Drift en **génération modulaire** (`build.yaml`) : un `.drift.dart` par
  fichier source, importé explicitement (pas de `part`).
- Modèles freezed utilisés directement comme lignes drift (`@UseRowClass(..., generateInsertable: true)`).
  Enums persistés via `DbEnum.dbValue` (valeurs snake_case identiques à Postgres).
- Tables locales non synchronisées (`tables/local_tables.dart`) : `app_settings`, `metadata_cache`,
  `scan_queue` (pas de SyncedColumns).
- Drift `insertOrIgnore` renvoie le dernier rowid même si la ligne est ignorée : tester l'existence avant.
- Tables : id UUID v7 côté client, user_id, created_at, updated_at, deleted_at (suppression logique),
  sync_pending (local). Toute écriture passe par le repository (bump updated_at + sync_pending).
- Schéma versionné : après changement de tables, incrémenter `schemaVersion`, écrire la migration, puis
  `dart run drift_dev schema dump lib/core/database/app_database.dart drift_schemas/` puis
  `dart run drift_dev schema generate drift_schemas/ test/core/database/generated/` et compléter
  `test/core/database/migration_test.dart` (schéma actuel : v7, colonne `items.refused_covers`). Toute nouvelle colonne
  synchronisée exige sa migration Supabase, appliquée par l'utilisateur **avant** d'installer la version.
- Lecture ponctuelle : méthodes `get*` du repository, jamais `watch*().first` (bloque en test widget).

## Secrets
- Jamais de clé dans le code. Valeurs injectées via `--dart-define-from-file=env.json`, lues dans
  `core/config/env.dart` (`String.fromEnvironment`). `env.json` est git-ignoré et **ne doit jamais être lu** ;
  `env.example.json` contient les clés factices de référence.

## Tests
- `flutter test` doit passer à chaque fin de phase.
- `pumpApp` injecte des faux pour tout ce qui touche le matériel ou le réseau : `FakeLoanReminders`,
  `FakeAppShortcuts`, `FakeHomeScreenWidget`, `FakeVoiceInput`, `FakeNetworkStatus` (aucune connexion par défaut),
  `FakeCoverCache`, `FakeCoverScanner`, `FakeSuggestionSources`, `FakeSeriesCatalogSource`, `FakeReleaseNotifications`, `FakeReleaseBackground`, `MemoryBackupStore`, un `SeriesLookup` sans source (param `seriesLookup:`), pas de MangaDex (param `mangaDex:`) ; jamais les vrais
  plugins ni le réseau.
- Journal en test : `appLog.clear()` en début de test.
- Tests de Paramètres : la liste est longue ; une tuile peut être construite (cache) mais hors écran →
  `scrollUntilVisible` puis `ensureVisible` avant `tap` (`tapTile` de `screen_helpers.dart`).
- Capturer une image en test widget : appui puis attente réelle dans `tester.runAsync`. Tester un regroupement
  temporisé par un test unitaire (`ProviderContainer`, vraies attentes).
- Synchro : moteur testé avec `test/helpers/fake_sync_remote.dart` et `fake_sync_auth.dart` ; SQL validé sur le
  PostgreSQL local (base `dupe_sync_check`) ou le Supabase local.
- Unitaires obligatoires : utilitaire ISBN, chaque provider de métadonnées (HTTP simulé à partir de
  fixtures réelles dans `test/fixtures/<source>/`, via `test/helpers/fake_http.dart`), aggregator
  (`test/helpers/fake_metadata.dart`), calcul des tomes manquants, moteur de sync.
- Fixtures : récupérées avec curl et le User-Agent de l'appli, jamais inventées. Les réponses Google Books
  avec clé sont récupérées par l'utilisateur (`! curl … key=$(jq -r .GOOGLE_BOOKS_API_KEY env.json) -o …`) :
  vérifier qu'aucun `key=` n'apparaît dans le fichier avant de le stager.
- Scan : `test/helpers/scan_helpers.dart` (`linux`, `openScan`, `typeCode`, `repoOf`) ;
  `fakeMetadataSources(byIsbn: {...}, error: SocketException(...))` pour plusieurs ISBN ou le hors-ligne.
- Tests widget avec sources simulées : `pumpApp(overrides: [fakeMetadataSources()])`
  (`test/helpers/fake_sources.dart`). `Override` s'importe depuis `package:flutter_riverpod/misc.dart`.
- Données initiales d'un test widget : `pumpApp(seed: (db) async {...})` (écrit avant le démarrage de
  l'appli). Écrire en base après `pumpApp` via `runAsync` bloque (flux drift actifs).
- Tests de synchro : `FakeSyncAuth` (comptes en mémoire, mot de passe ≥ 6, `confirmEmail` + `confirm()`),
  `fillSignIn` dans `sync_flow_test.dart` ; codes e-mail simulés : `codes`, `sent`, `confirmSignUp`/`resetPassword` ; `pumpApp(overrides: [syncAuthProvider.overrideWithValue(FakeSyncAuth(...)),
  syncRemoteProvider.overrideWithValue(FakeSyncRemote())])` ; I/O fichiers réels dans `tester.runAsync`.
- Ne jamais `pkill -f <motif>` : le motif est dans la ligne de commande et tue le shell ; utiliser `pkill -x`.
- flutter_test simule Android par défaut : pour un comportement desktop, `variant:
  TargetPlatformVariant.only(TargetPlatform.linux)`.
- Widgets : navigation (`test/app/navigation_test.dart`), parcours collection
  (`test/features/collection/presentation/series_flow_test.dart`), écran de résultat du scan.
- Arborescence `test/` miroir de `lib/`. Helpers : `test/helpers/app_harness.dart` (`pumpApp` sur base
  en mémoire, `goBack` car `tester.pageBack()` ne connaît pas le BackButton de material_ui),
  `test_repositories.dart` (repo + horloge contrôlable).
- En test widget, la base se ferme via `tester.runAsync` (sinon blocage en temps simulé).
  `dart_test.yaml` : timeout 30 s par test. Suite complète ~60 s (394 tests, 2026-11-22) : le temps vient surtout
  de la compilation de chaque fichier de test widget. Helpers de navigation : `test/helpers/screen_helpers.dart`
  (`goTo`, `openSettings`, `tapTile`, `fillSignIn`) ; ne jamais importer un fichier `_test.dart` depuis un autre.

## Vérification de fin de phase
```
flutter analyze && flutter test
flutter build linux --debug --dart-define-from-file=env.example.json
flutter build apk --debug --dart-define-from-file=env.example.json
```
Windows ne se compile pas depuis Linux (à vérifier sur un PC Windows).

## Environnement connu
- Ubuntu 26.04 + GNOME Wayland : GTK3 plante en lisant la clé xsettings `antialiasing` supprimée.
  Contourné dans `linux/runner/main.cc` (bascule auto sur X11 si la clé manque). Ne pas retirer.
- `package:flutter/material.dart` est déprécié mais encore présent : des packages tiers (ex. go_router,
  pages d'erreur) l'utilisent encore. Si un widget tiers Material manque de thème/localisations dans
  notre arbre, utiliser `MaterialUiCompatibilityBridge` dans `MaterialApp.builder`.

## Données de l'utilisateur
- Collection de départ (bouton + `starter_*.dart`) supprimée le 2026-11-14 à la demande de l'utilisateur :
  sa collection passe désormais par l'import CSV / la synchro. Récupérable dans le commit « Phase 7 ».
- Plusieurs exemplaires d'un même tome (éditions) : la liste des séries compte les tomes distincts.

## Git
- Ne pas committer ni pousser : stager fichier par fichier, l'utilisateur committe.
- **En fin de phase, proposer un message de commit conventionnel** (`type(portée): description`, types `feat`,
  `fix`, `chore`, `docs`, `test`, `refactor`, `ci`, première ligne ≤ 100 caractères, en français) : il passe le hook
  `commit-msg` (`tool/check_commit_msg.sh`) et alimente les notes de Release (`tool/ci/release_notes.sh`).
  Contraintes du hook : première ligne ≤ 100 caractères (le détail va dans le corps), portée facultative en
  `[a-z0-9._/-]` seulement (`feat(series)`, jamais `feat(séries)`). **Vérifier le message avec
  `bash tool/check_commit_msg.sh <fichier>` avant de le proposer.**
- Publier une version (tag, Release) : **toujours fait à la main par l'utilisateur** ; ne pas proposer de script de
  release (décision du 2026-11-16).
- Hooks lefthook (`lefthook.yml`, phase 18) : pré-commit format, en parallèle de `tool/ci/check_generated.sh`
  (refuse un fichier généré à jour non stagé) puis analyze (seulement si des `.dart` / `.arb` sont stagés),
  pré-push tests.
- Tests d'intégration : `integration_test/` (helpers de `test/helpers/` importés en relatif), `flutter test
  integration_test -d linux` (ouvre une fenêtre) ; CI : `xvfb-run -a`.
- `CLAUDE.md` est versionné (retiré de `.git/info/exclude` le 2026-11-15). **Exception pour ce projet**
  (autorisation de l'utilisateur, 2026-11-16) : Claude **stage** ce `CLAUDE.md` avec ses autres changements, par
  dérogation à la règle de l'espace de travail qui interdit de stager les `CLAUDE.md` (qui reste valable ailleurs).
- **Juste avant de stager** : `dart format .`, puis `dart run build_runner build -d` et `flutter gen-l10n`, et stager
  aussi les fichiers générés modifiés (la CI exige un code généré à jour ; un `.g.dart` recopie les commentaires).

## Tests manuels
- `TESTS_MANUELS.md` : checklist de ce que l'utilisateur teste lui-même (téléphone, synchro réelle, packaging),
  autonome et avec identifiants (`M-09`, `S-05`…). La compléter quand une fonctionnalité ajoute un comportement
  non testable automatiquement ; mettre à jour le nombre de tests et le statut en tête.

