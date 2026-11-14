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
| 18 | Hooks, commits conventionnels, tests d'intégration | à faire | — | — |
| 19 | Accès rapide : widget et recherche vocale | à faire | — | — |
| 20 | Couvertures hors ligne, stats de lecture, partage des envies | à faire | — | — |
| 21 | Recette finale (reste de `TESTS_MANUELS.md`) | à faire | — | — |

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
  Release publique ; documenté (« le laisser vide dans `ENV_JSON` »), non bloqué par `check-env`.

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
  (migration à appliquer, `P-05`). **Dependabot ne peut pas fonctionner tel quel** : sa configuration n'est lue
  que sur `main` (aujourd'hui « Initial commit ») et `dev` ne contient que `PLAN.MD` (pas de `pubspec.yaml`) —
  voir `P-06`.

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

## 5. Actions manuelles de l'utilisateur
- **Phase 14** : créer le compte dans l'appli (fait). Le reste est reporté en phase 21.
- **Phase 15** : créer le secret `ENV_JSON` **sans** `COMIC_VINE_API_KEY` ni `GOOGLE_BOOKS_API_KEY` (et sans
  `OPEN_LIBRARY_CONTACT` pour ne pas publier son email) ; restreindre la clé Google Books à la Books API ;
  saisir les clés dans l'appli sur chaque appareil. Pas de régénération : aucune Release n'a été publiée.
- **Phase 16** : appliquer la migration `20261115090000_keep_alive.sql` ; mettre `dev` à jour avec le travail
  des phases et porter `.github/dependabot.yml` sur `main` (sinon Dependabot ne fait rien) ; activer Dependabot
  si nécessaire ; protéger `main` (pull request obligatoire, CI verte exigée) dans les réglages du dépôt.
- **Phase 17** : accès à Docker sans sudo (`sudo usermod -aG docker $USER`, puis se reconnecter), Supabase CLI
  2.122.1 (`.deb`, README « Tests de synchro contre un Supabase local »), `postgresql-client`.
- **Phase 18** : `lefthook install` après récupération du dépôt.
- **Phase 21** : d'abord les tests reportés de la phase 14 (synchro, secrets GitHub, Release de test,
  APK sur le téléphone), puis dérouler `TESTS_MANUELS.md` ; publier deux versions stables successives.

## 6. Hors périmètre (inchangé)
iOS/macOS, partage de collection, alertes de sortie des nouveaux tomes, scraping, cote automatique,
service externe de suivi d'erreurs.