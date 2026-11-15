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
| 2. Filtre PostgREST du pull jamais vérifié contre un vrai serveur | Phase 14 (`S-05`, en réel), 17 (auto) |
| 3. Compte existant sans mot de passe | Sans objet (2026-11-14 : aucun compte n'existait ; création en phase 14, `P-04`) |
| 4. Clés Comic Vine / Google Books extractibles des binaires publics | Phase 15 |
| 5. Efficacité du `keep-alive` non prouvée ; tâches planifiées désactivées après 60 j | Phase 16 |
| 6. Horloge d'appareil très en avance qui gagne à tort la synchro | Phase 17 |

## 2. Décisions déjà prises
- Pas de service de suivi d'erreurs externe : le journal local suffit.
- Les clés tierces sortent des binaires publics (phase 15) : elles sont saisies dans l'appli.
- Supabase **local** (CLI + Docker) est autorisé pour les tests ; le projet distant reste interdit.

## 3. État des phases

| Phase | Sujet | État | Tests auto | Vérifié en réel |
|---|---|---|---|---|
| 14 | Vérifications de base en réel et correctifs | en cours | — | CI verte (2026-11-14) |
| 15 | Clés API saisies dans l'appli | à faire | — | — |
| 16 | CI renforcée et veille Supabase fiable | à faire | — | — |
| 17 | Tests de synchro contre Supabase local | à faire | — | — |
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

### Phase 16 — CI renforcée et veille Supabase fiable
- `ci.yml` : ajouter `dart format --output=none --set-exit-if-changed .` et une **vérification du code
  généré** (build_runner et `flutter gen-l10n`, puis `git diff --exit-code` sur les fichiers générés).
- Couverture : `flutter test --coverage`, rapport en artefact, pourcentage global dans le récapitulatif du job.
- Dependabot (`.github/dependabot.yml`) : écosystèmes `pub` et `github-actions`, hebdomadaire, cible `dev`,
  mises à jour mineures/patch groupées. La vérification du code généré attrape les mises à jour de
  freezed/drift/riverpod qui exigent une régénération.
- Badge de statut CI dans le README.
- Veille Supabase : remplacer la requête refusée par la RLS par une vraie activité base, via une fonction
  SQL `keep_alive()` (`security definer`, renvoie `now()`, n'expose aucune donnée, exécutable par `anon`),
  nouvelle migration. Le workflow l'appelle par RPC.
- Tâches planifiées désactivées par GitHub après 60 jours sans activité du dépôt : trouver une solution
  **sans commit automatique** (par exemple réactivation via l'API GitHub), vérifier sa documentation
  actuelle, et documenter le comportement dans le README.

*Critère : un fichier mal formaté ou un `.g.dart` périmé fait échouer la CI ; Dependabot ouvre ses
premières pull requests ; le keep-alive appelle `keep_alive()` avec succès.*

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
- **Phase 14** : créer le compte dans l'appli, vérifier la synchro, créer le tag de test
  `v0.0.1-test` (puis supprimer la *pre-release* et le tag), installer l'APK sur le téléphone.
- **Phase 15** : retirer `COMIC_VINE_API_KEY` et `GOOGLE_BOOKS_API_KEY` du secret `ENV_JSON` ; restreindre la
  clé Google Books à la Books API dans la console Google ; envisager de régénérer la clé Comic Vine si une
  Release publique l'a déjà contenue.
- **Phase 16** : activer Dependabot si nécessaire ; protéger `main` (pull request obligatoire, CI verte
  exigée) dans les réglages du dépôt.
- **Phase 17** : installer Docker et la Supabase CLI sur le poste.
- **Phase 18** : `lefthook install` après récupération du dépôt.
- **Phase 21** : dérouler `TESTS_MANUELS.md` ; publier deux versions stables successives.

## 6. Hors périmètre (inchangé)
iOS/macOS, partage de collection, alertes de sortie des nouveaux tomes, scraping, cote automatique,
service externe de suivi d'erreurs.