# Dupe — architecture

Description détaillée des choix techniques et de l'organisation du code (déplacée de `CLAUDE.md` le
2026-11-15). Les règles à respecter sont dans `CLAUDE.md` ; ce fichier dit **où vit quoi et pourquoi**.
À tenir à jour quand un module change de structure ou de comportement.

## Stack
- Flutter stable 3.50 / Dart 3.14. Cibles : **android, windows, linux** (macOS abandonné, iOS hors périmètre).
- Material vient du package **`material_ui`** (découplé du SDK) : importer
  `package:material_ui/material_ui.dart`, jamais `package:flutter/material.dart`.
- Riverpod 3 + `riverpod_generator` (annotations `@riverpod`), go_router, freezed + json_serializable.
- Base locale : drift 2.35 + sqlite3 3.x (SQLite embarqué via build hook, pas de sqlite3_flutter_libs),
  ouverte avec `NativeDatabase.createInBackground` dans `getApplicationSupportDirectory()`
  (pas drift_flutter : il mettrait la base dans ~/Documents sous Linux). Fonction SQL `fold()` = recherche
  sans accents ni casse (`core/utils/text_fold.dart`).
- Réseau : dio 5.11 (`core/network/` : client avec User-Agent générique, `RateLimiter`, `MemoryCache`),
  xml 7.1 (BnF). Scan : mobile_scanner 7.5, **Android uniquement** (le plugin n'a pas d'implémentation
  Linux/Windows : ne jamais l'instancier hors Android, tester `defaultTargetPlatform`).
- Liens externes : url_launcher 6.3 (`features/search/domain/external_links.dart` : Bédéthèque, Manga-News,
  Comic Vine — liens seulement, jamais de scraping).
- Couvertures : cached_network_image 4.0 (`app/widgets/cover_image.dart`) avec **`coverCacheManager`**
  (`features/covers/data/cover_cache.dart`, flutter_cache_manager 3.5 : `<support>/cover_cache`, 20 000 fichiers,
  2 ans ; jamais le `DefaultCacheManager` : 200 fichiers dans le dossier temporaire). Index en sqflite sur Android,
  JSON sur Linux/Windows (pas besoin de sqflite desktop). Tout nouvel affichage d'image réseau passe par lui.
- Notifications : flutter_local_notifications 23 + timezone (`features/loans/data/loan_reminders.dart`). Android
  seulement planifie (inexact, `zonedSchedule` à 10 h le jour de retour, instant absolu `tz.UTC`, pas de base
  de fuseaux) ; Linux n'a pas de planificateur et Windows hors MSIX ne sait pas annuler → sur desktop,
  notification « prêts en retard » au démarrage, une fois par jour (`loans_overdue_notified_on`).
  Android : compileSdk 37 + core library desugaring (`android/app/build.gradle.kts`), receivers dans le manifest.
  Au démarrage, `LoanActions.syncReminders` reprogramme les rappels des prêts en cours et annule ceux des prêts
  rendus (réinstallation, autre appareil) ; au prêt, `reminderWillShow` prévient si les notifications sont coupées.
  Tests : `pumpApp` injecte `FakeLoanReminders` (`test/helpers/fake_reminders.dart`), jamais le vrai plugin.
- Graphiques : fl_chart 1.3 pour la seule courbe temporelle (`stats/presentation/monthly_chart.dart` : `MonthlyChart` /
  `MonthlyTable` génériques — dépenses et tomes lus —, infobulle au toucher + vue tableau) ; le reste en widgets simples (tuiles, barres classées `BarRow`).
  Couleurs : `chart_colors.dart` (bleu de la palette dataviz validée clair/sombre), textes aux couleurs du thème.
- Supabase : package Dart pur `supabase` 2.16 (pas supabase_flutter : évite app_links/plugins natifs sur
  desktop). Session dans `app_settings` (`supabase_session`), flux implicite, connexion email + mot de passe.
- Photos de couverture : image_picker 1.2 (caméra sur Android, sélecteur de fichier sur desktop).

## Architecture (`lib/`)
- `app/` : `app.dart` (MaterialApp.router), `router.dart` (go_router, `AppRoutes`), `theme.dart`,
  `adaptive_shell.dart` (NavigationBar < 600 px, NavigationRail ≥ 600, rail étendu ≥ 1100, enveloppé par
  `exit_guard.dart` : double retour pour quitter sur Android), `widgets/` partagés. « Voir la série » = `context.go`
  (pile onglet > série), jamais `push`. Un onglet s'ouvre toujours sur sa liste (`initialLocation: true`).
- `core/` : `config/env.dart`, `database/` (`app_database.dart`, `tables/` un fichier par table,
  `converters.dart`), `sync/`, `network/`, `metadata/`, `utils/`.
- `features/<feature>/{data,domain,presentation}` : repositories / modèles freezed / widgets + providers.
  `presentation/` : un dossier par écran (`collection_tab/`, `series/`, `item/`) + `providers/`.
- **Fichiers courts** (préférence de l'utilisateur) : viser < 250 lignes par fichier écrit à la main ; dès
  qu'un écran grossit, le découper en widgets/fichiers dans son dossier plutôt qu'un gros fichier.
- `core/metadata/` : `MetadataProvider` (interface), `MetadataResult` (freezed), `MetadataAggregator`
  (priorités par type `defaultPriorities`, timeout 5 s par source, cache mémoire, fusion `metadata_merge.dart`),
  `providers/<source>/` (provider + parser séparés). Câblage Riverpod : `metadata_providers.dart`.
  - BnF SRU (`unimarcXchange`) : source principale FR (titre, tome 200$h/461$v, prix 010$d, auteurs
    700-702 rôles 070/440). Open Library : `/api/books?jscmd=data` (legacy mais documenté) + `search.json`,
    1 req/s sans contact. Google Books : **clé obligatoire en pratique** (sans clé → 429), provider activé
    seulement si `GOOGLE_BOOKS_API_KEY` est renseigné. Contact Open Library : `OPEN_LIBRARY_CONTACT`
    dans env.json (accord de l'utilisateur, 2026-11-14), jamais en dur dans le code (dépôt GitHub).
  - Séries : `series_metadata.dart` (`SeriesMetadata`, `SeriesMetadataProvider`), `series_lookup.dart`
    (AniList pour manga, Comic Vine pour comics, rien pour BD/livres). AniList GraphQL sans clé, limite
    observée 30 req/min (mode dégradé) → 1 requête / 2 s ; décrit l'œuvre originale (tomes JP), Dreamland
    (manfra) absent. Comic Vine : clé `COMIC_VINE_API_KEY`, 1 req/s, sert aussi la recherche texte d'issues.
  - Cache disque des réponses (`response_store.dart`, `DriftResponseStore` dans `core/database/local_stores.dart`) :
    `CachePolicy` trouvé 60 j, introuvable 3 j, texte 3 j ; une entrée périmée sert de secours si la source
    échoue (hors ligne). Timeout appliqué par appel source dans `_persisted`.
  - Sources activables (`source_settings.dart`, `SourceId`, `DisabledSources` dans `app_settings`). Une seule
    bascule Comic Vine.
  - Clés API (phase 15, `core/metadata/api_keys.dart`) : `SavedApiKeys` (saisies dans Paramètres → Sources,
    `app_settings` `api_key_<source>`) > `builtInApiKeys` (env.json, développement) via `apiKeysProvider` ;
    `sourceHasKey(id, keys)`. Les providers de sources **regardent** `apiKeysProvider` (clé saisie = source
    active sans redémarrage). Jamais synchronisées/sauvegardées (`app_settings` est local) ; toute clé passe par
    `appLog.hideSecret` (remplacée par `***`, plus les paramètres d'URL `key=`/`api_key=`/`token=`).
    « Tester la clé » : `api_key_check.dart` (fixtures `invalid_key.json` enregistrées avec une clé inventée).
    `release.yml` (`check-env`) refuse un `ENV_JSON` contenant `COMIC_VINE_API_KEY` / `GOOGLE_BOOKS_API_KEY` /
    `OPEN_LIBRARY_CONTACT`.
- Scan (`features/scan/`) : `ScanScreen` à deux modes ; type = onglet d'origine, sinon dernier choisi dans le menu
  de type de la barre (`scan_last_type`), Livres au départ.
  - Magasin : `StoreChecker` (data) → `StoreCheck` (domain). Recherche locale par ISBN d'abord (instantané,
    hors ligne), puis en ligne seulement pour reconnaître un tome d'une série de la collection (série + numéro) ;
    un tome possédé sans ISBN reçoit l'ISBN scanné (« ISBN mémorisé ») pour les scans suivants, et ses champs vides
    sont complétés depuis la source (`fillBlanks`, jamais une saisie écrasée).
    Bandeau `store/` (couleurs fixes vert/jaune/bleu, gris = thème).
  - Rafale : file persistée `scan_queue` (`ScanQueueRepository`), `ScanQueueWorker` séquentiel (sources
    limitées), relancé à l'ouverture du scan et de la revue ; `importScanQueue` ajoute en lot (séries créées au
    fil de l'eau) ; revue `/scan/revue`, correction via `/scan/revue/ouvrage` (`ItemFormScreen(popOnSave)`).
  - `loadItemDraft` / `applyAttachment` : `features/collection/data/item_drafts.dart` (partagés formulaire/rafale).
- Nombre de tomes (v4 phase 23) : `matchSeriesTotal` (titre identique seulement) + `checkVolumeCount` ;
  `series_total_actions.dart` (menu « Vérifier le nombre de tomes », question au premier tome numéroté d'une série
  sans total, pré-remplie, délai 5 s) ; `VolumeCountScan` + `volume_counts_screen.dart` (Paramètres → Sources, en
  lot, propositions à valider). Vue liste des tomes : `volume_list_view.dart`, bascule `VolumesAsList`.
- Progression des séries (`collection_tab/series_progress_bar.dart`) : barre réelle si `totalVolumes` est connu,
  sinon barre **indicative** grise (`SeriesEntry.indicativeProgress` = possédés / `highestVolume`, plus haut numéro
  simple calculé en SQL dans `collection_entries_query.dart`).
- Recherche : l'ISBN est ajouté au sous-titre des résultats texte (`resultSubtitle(withIsbn: true)`) et des livres
  de la recherche locale ; pas dans le bandeau du magasin ni la revue de rafale (code qu'on vient de scanner).
- Lecture (`collection/data/reading_actions.dart`, extension du repository) : statut en un appui
  (`ItemReadingBar`, puces qui passent à la ligne : un SegmentedButton déborde sur téléphone), « Marquer comme
  lus jusqu'au tome N » (`series_menu.dart`), filtre « À lire » (`ViewSettings.toReadOnly`, `unreadCount` de
  `collection_entries_query.dart`, statuts `toReadStatuses`).
- Envies (`features/wishlist/`) : items `envie` triés par priorité, retirés d'un glissement (avec « Annuler ») ; « Prochains tomes à acheter » =
  `nextVolumesToBuy` (séries suivies, manquants non déjà en envie), ajout en un appui.
- Auteurs (`features/authors/`) : `groupByAuthor` (`authorKey` : « Nom, Prénom » remis dans l'ordre, sans accents ni
  casse ; une série prend aussi les auteurs de ses tomes via `seriesItemAuthorsProvider`), vue « Par auteur » de
  l'onglet (`ViewSettings.byAuthor`, suit les filtres), `AuthorScreen` (`AppRoutes.author`, non filtrée),
  `AuthorMenu` (page auteur : « Marquer comme lus », `markOwnedRead` de `reading_actions.dart`),
  `AuthorLinks` sur les fiches livre/série (`context.go`, comme « Voir la série »). `EntryTile` (`entries_list.dart`) partagé par l'onglet et la page auteur.
- Prêts (`features/loans/`) : `LoansRepository` (lend/markReturned/borrowerNames), `LoanActions` (prêt + rappel),
  `ItemLoanSection` sur la fiche, `LoansScreen` (en cours/historique, retards surlignés).
- Exemplaires : plusieurs items par numéro (éditions) ; `VolumeSlot.copies`, badge ×N + `volume_copies_sheet` ;
  « Ajouter un exemplaire » = `newItem(copyOf:)` → `newCopy` ; en magasin `StoreCheck.otherEdition`.
- Prix (phase 6) : « Je l'ai acheté » = `confirmBought` (`item/bought_action.dart`, prix pré-rempli par le prix
  éditeur) → `markBought` (`collection/data/purchase_actions.dart`) ; sur la fiche, la liste d'envies et le
  bandeau jaune (qui repasse vert via `ref.invalidate(storeCheckProvider)`).
- Statistiques (`features/stats/`) : `computeCollectionStats` (tomes comptés une fois même en plusieurs
  exemplaires, l'argent compte chaque exemplaire ; devise principale = la plus fréquente, autres devises à
  part, jamais converties ; valeur = estimée > prix éditeur > prix payé ; 12 derniers mois).
- Synchro (`core/sync/`, phase 7) : `SyncEngine` générique sur les tables drift (`SyncCodec` : dates UTC ISO,
  colonnes JSON, `sync_pending` local) ; push des lignes `sync_pending` (démarquées si `updated_at` inchangé),
  pull par curseur **serveur** `server_updated_at` par table ; dernière écriture gagnante des deux côtés
  (trigger SQL + `_localWins`). `adoptUser` : nouveau compte → tout repousser. `SyncController` : statut +
  déclencheurs (démarrage, reprise, 3 s après modif, 30 s, bouton). `SyncAuth` (phase 10 : `signIn` / `signUp` / `setPassword`, email + mot de passe ;
  `signUp` renvoie false si l'email doit être confirmé — option Supabase *Confirm email*, gérée dans les deux cas ;
  avec confirmation, un email déjà inscrit renvoie un faux utilisateur sans `identities` → `emailTaken`).
  Comptes créés par lien avant la v2 : sans mot de passe → Paramètres → *Mot de passe* (`setPassword`,
  `set_password_dialog.dart`). Supprimer un utilisateur Supabase efface ses lignes (`on delete cascade`).
  `SupabaseSyncAuth` / `LocalOnlyAuth` sans env. Schéma distant : `supabase/migrations/` (RLS user_id =
  auth.uid(), pas de DELETE, pas de FK entre tables, bucket privé `covers/<uid>/`).
- Pull (phase 9) : pagination par clé `(server_updated_at, id)` (`SyncCursor`, filtre PostgREST `or` avec valeurs
  entre guillemets, instants envoyés en UTC `Z`) et relecture de `SyncEngine.overlap` (1 min) avant le curseur :
  une ligne commitée tard peut porter un horodatage antérieur. `SyncCodec.apply` ignore une ligne déjà
  identique (même `updated_at` + `user_id`) → suppose que deux écritures d'une ligne n'ont jamais le même
  `updated_at` (horloge µs ; le `Device` de test avance son horloge à chaque lecture, `test/helpers/sync_device.dart`).
- Erreurs de synchro typées : `SyncException.failure` (`offline` / `session` / `rejected`), `SignInException`
  (`SupabaseSyncAuth` traduit les `AuthException`).
- **Supabase local autorisé pour les tests** (phase 17, `PLAN_V3.md`) : `tool/supabase_tests.sh` (CLI 2.122.1,
  Docker, `supabase/config.toml`, refuse une URL non locale) → `flutter test -P supabase` (tag `supabase`
  exclu par défaut dans `dart_test.yaml` ; `--tags supabase` ne marche pas avec cette exclusion). Tests dans
  `test/supabase/` (`LocalSupabase` : compte neuf par test, `psql` + trigger désactivé pour forcer
  `server_updated_at`). L'utilisateur a autorisé `npx -y supabase@2.122.1` (2026-11-14) et
  donné l'accès Docker ; lancer `sg docker -c tool/supabase_tests.sh` (le script retombe sur npx sans CLI
  installée), puis `sg docker -c "npx -y supabase@2.122.1 stop"`.
- Horloge (phase 17) : `SyncRemote.serverTime()` (`keep_alive()`), `ClockCheck` (écart > 2 min, 1×/h) →
  `SyncState.clockSkew`, journal une fois, statut « l'heure de cet appareil semble fausse ».
- **Jamais de connexion au projet Supabase distant** (règle de l'espace de travail) : SQL validé sur le
  PostgreSQL local (base `dupe_sync_check`, rôles `dupe_test_*`, stubs auth/storage), moteur testé avec
  `test/helpers/fake_sync_remote.dart` (mêmes règles que les triggers) et `fake_sync_auth.dart`.
- Photos (`features/covers/`) : URL `dupe-cover:<itemId>-<ms>.jpg`, fichier local `<support>/covers/`, upload
  après la synchro (`uploadPendingCovers`), téléchargement à l'affichage (`userCoverFileProvider`).
- Sauvegarde/import (`features/backup/`, phase 8) : JSON = format de la synchro (`SyncCodec.toRemote`, lignes
  supprimées incluses), restauration = `SyncCodec.apply(pending: true)` (fusion, plus récent gagne, jamais
  d'effacement). CSV maison (`csv_codec.dart` : `;` + BOM en écriture, séparateur détecté en lecture, lignes
  vides gardées pour les numéros de ligne). Import : `guessMapping` (en-têtes FR/EN, Mangacollec, CLZ, notre
  export), écran de correspondance, doublons ignorés (ISBN / tome de série / livre isolé, autre ISBN =
  nouvelle édition). Fichiers : `FileIo` (desktop : dialogues file_selector ; Android : feuille de partage
  share_plus) — `FakeFileIo` en test.
- Journal (phase 9, `core/logging/`) : global `appLog` (pas un provider, utilisable partout), 500 entrées,
  fichier JSON-lines `dupe_log.jsonl` du dossier support (attaché dans `main.dart`, compacté à 2× la capacité),
  erreurs Flutter/non attrapées + `LogObserver` (échecs de providers) + synchro (une entrée par changement
  d'échec, pas toutes les 30 s) + sources de métadonnées. Jamais de secret dans le journal. Écran
  `/plus/a-propos/journal` (copier, partager via `FileIo`, vider). Tests : `appLog.clear()` en début de test.
- Messages d'erreur : `app/error_text.dart` — `errorText(l10n, e)` (phrase française) / `reportError` (journal +
  phrase). Jamais `'$e'` à l'écran.
- `AppRoutes` est dans `app/app_routes.dart` (réexporté par `router.dart`).
- Filets de sécurité (phase 11) : « Supprimé — Annuler » (`collection/presentation/undo_delete.dart`,
  `persist: false` car material_ui garde sinon les snackbars à action) → `restoreItem` / `restoreSeries` (la série
  restaure les tomes supprimés au même instant). Sauvegardes automatiques (`backup/data/auto_backups.dart`) :
  hebdomadaire au démarrage (`weeklyIfDue` dans `app.dart`), avant import CSV (import annulé si elle échoue) et
  avant restauration ; 8 gardées par type ; nom de fichier = métadonnées (`<kind>_<UTC>_<n>.json`) ;
  `BackupStore` : dossier `<support>/backups` (écriture .part puis renommage), `MemoryBackupStore` injecté par
  `pumpApp`. Restauration : choix fusion (`restore`) ou **remplacement** (`JsonBackup.replace` : lignes de la
  sauvegarde réécrites à `now` via `SyncCodec.apply(force:)`, autres lignes supprimées ; gagne à la synchro). Lire
  le fichier avant la sauvegarde « avant restauration » (la rotation peut le supprimer).
- Thème : `AppThemeMode` (système/clair/sombre dans `app_settings`). À propos : version via package_info_plus,
  attribution Comic Vine (exigée par leurs conditions).
- Icône : `DupeLogo` (CustomPainter) → `tool/render_icons_test.dart --update-goldens` → `assets/icon/` →
  `dart run flutter_launcher_icons` (Android adaptatif + Windows) ; Linux : `set_window_icon` dans
  `linux/runner/my_application.cc`. Pillow est cassé sur ce poste (pas de `_imaging`).
- Packaging : `android/key.properties` (ignoré) → signature release, sinon clé debug ; `packaging/windows/dupe.iss`
  (Inno Setup, `/DAppVersion=`) ; `packaging/linux/build_appimage.sh` (appimagetool 1.9.1 épinglé).
- CI (phases 12 et 16, `.github/workflows/`) : `ci.yml` (déclenché par les pull requests et à la main, plus
  par les push depuis le 2026-11-15 ; badge du README filtré `?event=pull_request`) (format `--set-exit-if-changed`, code généré à jour —
  build_runner + gen-l10n puis `git status --porcelain` vide —, analyze, `test --coverage` + récapitulatif
  `tool/ci/coverage_summary.sh` hors code généré, builds Linux/Android/Windows + Inno Setup 6.7.1 via choco) ;
  **toujours `dart format .` avant de stager** ; `.github/dependabot.yml` (pub + actions, vers `dev`, lu sur
  la branche par défaut, `dev` depuis 2026-11-15) ; `release.yml` (tag `vX.Y.Z`, ou `vX.Y.Z-suffixe` → *pre-release* jamais proposée en mise à jour ; pubspec reçoit
  toujours `X.Y.Z+code`, le suffixe ne va que dans les noms de fichiers ; → `tool/ci/set_version.sh` → APK `--split-per-abi` signés, AppImage,
  installateur → Release ; refuse de publier sans les secrets ; binaires **obfusqués** + zips de symboles par
  plateforme dans la Release, `FLUTTER_BUILD_ARGS` pour `build_appimage.sh` ; jamais de `runtimeType` dans les
  messages : illisible une fois obfusqué, `Enum.name` reste intact), `keep-alive.yml` (cron quotidien : RPC `keep_alive()` de la
  migration `20261115090000_keep_alive.sql`, échec si ≠ 200 ; se réactive via `PUT …/enable`). Actions épinglées : checkout v7, flutter-action v2 (Flutter 3.50.0), setup-java v6
  (Temurin 21), upload v7 / download v8, action-gh-release v3. Secrets : `ENV_JSON`, `ANDROID_KEYSTORE_BASE64`,
  `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD` — jamais lus ni affichés par Claude.
- Nouvelles versions (`features/updates/`) : `UpdateChecker` (API GitHub anonyme, dépôt public, 1×/jour,
  `update_check_enabled` / `update_checked_on`), fichier choisi par plateforme/ABI (`Abi.current()`), notice
  au démarrage **en release seulement** via `rootMessengerKey` (`app.dart`), section Paramètres → Mises à jour.
  Fixture réelle : `test/fixtures/github/release_appimagetool_1.9.1.json`.
- `SyncFailure.unavailable` : erreur 5xx (page non JSON → `PostgrestException.code` = statut HTTP), message
  « projet Supabase peut-être en pause ».
- Rattachement auto d'un tome scanné (`features/collection/domain/series_matching.dart`) : titre de série
  normalisé (accents, ponctuation, qualificatifs entre parenthèses ignorés) + éditeur compatible (inclusion).
  Candidats : BnF 461$t, 225$a **seulement si numéroté ($v) et confirmé par le 461** (un 225 sans 461 est une
  collection d'éditeur : Folio junior, Tracts Gallimard, Poches Jouvence), titre du volume
  s'il est numéroté. Sans correspondance → proposition de créer la série (`SeriesAttachment`). Le type de la
  série trouvée prime sur le type de l'onglet.
- Confort magasin (phase 13) : vibrations par verdict (`scan/presentation/store/store_haptics.dart`, retour
  haptique système, `store_haptics_enabled`, déclenchées par `ref.listen` dans `StoreResultBanner` au verdict
  final), lampe torche (`camera_scanner_view.dart`), raccourci Android (`scan/data/app_shortcuts.dart`,
  quick_actions 1.1.1, icône `res/drawable/ic_shortcut_scan.xml`; `FakeAppShortcuts` injecté par `pumpApp`).
  Anti-doublon : `DetectionSpeed.noDuplicates` + `enqueue` qui refuse un ISBN déjà en file.
- Accès rapide (phase 19) : widget Android (`features/home_widget/`, `home_widget` 0.10.0, natif
  `DupeWidgetProvider.kt` + `res/layout/dupe_widget.xml`, lien `dupe://scan` routé dans `app.dart`, compteurs
  `HomeWidgetUpdater` regroupés 2 s) ; dictée (`features/search/data/voice_input.dart`, `speech_to_text`, Android +
  Windows seulement ; `presentation/voice_search.dart` ; ouvrir les résultats avec `context.go`, jamais `push`
  depuis l'écran de recherche : conflit de clés de pages) ; `domain/spoken_query.dart` + `french_numbers.dart`.
  `pumpApp` injecte `FakeHomeScreenWidget` et `FakeVoiceInput`. Tester un regroupement temporisé par un test
  unitaire (`ProviderContainer`, vraies attentes) : écrire en base après `pumpApp` bloque.
- Phase 20 : **couvertures hors ligne** (`CoverPrefetch`, `cover_prefetch.dart` : URL distinctes des items et
  séries non supprimés, photos via `ensureUserCover`, démarrage + reprise + changement de connexion, Wi-Fi seulement
  par défaut `cover_prefetch_enabled` / `cover_prefetch_wifi_only`, annulé par compteur de passage ; les
  adresses en échec sont journalisées avec leur cause, une seule fois tant que la liste ne change pas) ; connexion
  `core/network/network_status.dart` (`connectivity_plus`, `NetworkKind` unmetered/metered/none) ; Paramètres
  `covers/presentation/offline_covers_section.dart`. `pumpApp` injecte `FakeNetworkStatus` (aucune connexion par
  défaut) et `FakeCoverCache` (`test/helpers/fake_covers.dart`). **Stats de lecture** :
  `stats/domain/reading_stats.dart` (`volumesOf` partagé avec `collection_stats.dart`). Choisir « Lu » remplit
  `read_date` partout (puce, « lus jusqu'au tome N », formulaire) ; ne jamais inventer de date pour l'existant.
  **Partage des envies** : `wishlist/presentation/share/` (`WishFilter`, image = `RepaintBoundary` capturée,
  couvertures préchargées par `loadShareCovers`), `FileIo.shareText` (Android : partage ; PC : presse-papiers).
  Capturer une image en test widget : appui puis attente réelle dans `tester.runAsync`.
  « Compléter les couvertures manquantes » : `covers/data/missing_covers.dart` (`MissingCoversFill`, URL gardée
  seulement si `CoverCache.fetch` réussit ; remplace aussi une URL qui ne se télécharge pas, jamais une photo ;
  n'interroge pas la BnF, sans images : `MetadataAggregator.lookupIsbn(…, except:)`).
  Après l'ajout d'un tome N possédé : `offerPreviousVolumes` propose 1..N-1 manquants (snackbar, `persist: false`).
- Tests de Paramètres : la liste est longue ; une tuile peut être construite (cache) mais hors écran →
  `scrollUntilVisible` puis `ensureVisible` avant `tap` (`tapTile` de `backup_screens_test.dart`).
- `l10n/app_fr.arb` (template) → code généré dans `l10n/gen/`.
- `supabase/migrations/` : SQL du schéma + RLS.
