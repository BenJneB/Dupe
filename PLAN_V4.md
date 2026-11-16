# Dupe — Plan v4 (brouillon)

> Commencé le 2026-11-15, pendant la recette de la v3 (phase 21). **Brouillon à valider par l'utilisateur** avant
> de démarrer : périmètre, découpage et ordre des phases peuvent changer. La v4 ne commence qu'une fois la
> phase 21 close. Mêmes règles qu'avant (`CLAUDE.md`) : une phase à la fois, tests automatisés + tests manuels
> ajoutés à `TESTS_MANUELS.md`, bilan « Réalisé / Écarts / Non vérifié » sous chaque phase, arrêt en fin de phase.

## 1. Objectif de la v4
Rendre la collection plus complète et plus juste sans saisie manuelle : comptes plus simples à gérer, séries
complétées (nombre de tomes, tomes manquants, titres), couvertures et éditions mieux reconnues, et livres
numériques rangés avec les livres papier. Toutes ces idées viennent de la recette de la v3 (2026-11-15) ; leur
texte d'origine est dans les phases ci-dessous.

## 2. Repris de la v3
- **Déjà livré pendant la phase 21** (exception au gel, 2026-11-15) : ISBN dans les résultats de recherche, barre
  de progression indicative pour les séries sans total, « marquer comme lus » depuis la page d'un auteur ; aussi :
  ajout des tomes précédents à l'ajout d'un tome N, légende de la grille en haut.
- **Fait en fin de v3** (2026-11-15) : obfuscation des Releases publiques (seulement elles ; les APK locaux de
  l'utilisateur restent lisibles), symboles joints à la Release, `coverError` sans `runtimeType`.
- **Tests reportés après la v4** (décision de l'utilisateur) : mode rafale `R-01` à `R-04`, à dérouler dans la
  recette de la v4 (phase 27).

## 3. État des phases
| Phase | Sujet | État |
|---|---|---|
| 22 | Compte : mot de passe oublié, liens de confirmation | à valider |
| 23 | Séries : nombre de tomes, tomes suivants, titres des tomes | ✅ fait (2026-11-15, avancée pendant la recette v3 à la demande de l'utilisateur) |
| 24 | Éditions et couvertures | à valider |
| 25 | Livres numériques (1/2) : support numérique, import Calibre | à valider |
| 26 | Livres numériques (2/2) : dossier EPUB/CBZ, Kobo | à valider |
| 27 | Recette de la v4 (dont mode rafale) | à valider |

## 4. Phases

### Phase 22 — Compte : mot de passe oublié, liens de confirmation
- **Mot de passe oublié sans être connecté** : lien « Mot de passe oublié ? » sur l'écran de connexion
  (email de réinitialisation Supabase), au lieu de passer par Paramètres → Mot de passe une fois connecté.
- **Lien de confirmation d'inscription** : il ouvre `localhost` (404). *Site URL* / *Redirect URLs* du projet
  Supabase à régler (action de l'utilisateur), et page d'arrivée (ou lien profond `dupe://`) qui confirme puis
  renvoie dans l'appli. Le lien de réinitialisation du mot de passe a le même besoin : à traiter ensemble.
- Question ouverte : lien profond `dupe://` (Android ; Linux/Windows à étudier) ou petite page web statique.

### Phase 23 — Séries : nombre de tomes, tomes suivants, titres des tomes
- **« Vérifier le nombre de tomes »** (sur une série, ou en lot dans Paramètres) : recherche AniList (manga) /
  Comic Vine (comics) et proposition du total trouvé, à confirmer (AniList donne les tomes japonais) ; rien pour
  BD et livres (pas de source). Complète la barre indicative livrée en phase 21.
- **Compléter une série à la création** : à l'ajout du tome 1 (ou du premier tome d'une nouvelle série), proposer
  d'ajouter les tomes suivants jusqu'au tome N (non possédés), N pré-rempli par AniList / Comic Vine quand c'est
  possible, saisi sinon (BD, livres). Existe déjà : « Ajouter des tomes » et la proposition des tomes précédents.
- **Titres des tomes dans l'écran d'une série** : la grille de pastilles (numéros seuls) est jugée pauvre. Vue liste
  des tomes (couverture, numéro, titre du tome, statut lu/prêté/envie), en bascule avec la grille, ou titre sous
  chaque pastille.

**Bilan (2026-11-15)**
- **Réalisé** :
  - `matchSeriesTotal` (`collection/domain/volume_count.dart`) : seul un titre identique (titre ou titre original,
    normalisés) avec un nombre de tomes est retenu ; `checkVolumeCount` (`data/volume_count_check.dart`) via
    `SeriesLookup` (AniList manga, Comic Vine comics ; rien pour BD et livres).
  - Menu d'une série → « Vérifier le nombre de tomes » (manga/comics seulement) → dialogue pré-rempli avec la source
    (« AniList : « ONE PIECE », 107 tomes (nombre de l'édition japonaise) ») → total enregistré.
  - Paramètres → Sources → « Vérifier le nombre de tomes des séries » (`volume_counts_screen.dart`,
    `VolumeCountScan`) : séries sans total vérifiées une à une, propositions cochées par défaut, rien d'enregistré
    avant « Appliquer ».
  - **Tomes suivants** : plutôt que créer des items « non possédés », le premier tome numéroté d'une série sans
    total déclenche « Combien de tomes compte la série ? » (pré-rempli par AniList / Comic Vine, délai 5 s, sinon
    vide ; « Plus tard ») : le total fait apparaître les tomes manquants en gris, ce que l'utilisateur attendait
    (Kaamelott). Pas dans la revue de rafale (ajouts en série).
  - Vue **liste** des tomes (`volume_list_view.dart`) : couverture, « Tome N », titre propre du tome s'il diffère
    de la série, statut, « Lu », ×N ; bascule grille/liste mémorisée (`VolumesAsList`, `series_volumes_as_list`).
  - `pumpApp` injecte par défaut un `SeriesLookup` sans source (jamais le réseau en test).
- **Écarts** : les « tomes suivants » passent par le nombre total (pas d'items créés) ; Comic Vine compte des
  numéros d'édition américaine (le dialogue le dit). Fichier `series_detail_screen.dart` à 249 lignes.
- **Non vérifié** : avec les vrais AniList et Comic Vine (`U-01` à `U-04`) ; titres propres des tomes de la vraie
  collection.
- **Retours de l'utilisateur (2026-11-16, `U-01`, `U-02`, `U-04`)** :
  - AniList ne connaît pas les mangas **français** (Free Quest, Everdark, Oneira, Dreamland…) : rien n'est proposé
    (écart accepté : pas d'autre source sans scraping). Comic Vine donne le nombre de l'édition américaine (annoncé
    dans le dialogue).
  - **Fait (2026-11-16)** : action « Nombre total de tomes… » dans le menu de **toutes** les séries ; pour BD,
    livres et séries introuvables (ou source en échec), le dialogue s'ouvre avec la raison et le total actuel, pour
    une saisie manuelle (`checkSeriesTotal`, tests `series_total_test.dart`).
  - **À faire** : titres des tomes aussi dans la vue pastilles, et un vrai **titre de tome** : aujourd'hui un tome
    n'a pas de champ « titre propre » (`applyMetadata` jette le sous-titre d'un tome numéroté ; le titre propre n'est
    connu que si la BnF le met en titre principal, ex. Kaamelott) → champ `volume_title` sur l'item (migration de
    schéma locale v3 + Supabase), rempli depuis BnF 200$a/$e/$i, Google Books `subtitle`, Comic Vine `name`.

### Phase 24 — Éditions et couvertures
- **« Compléter les couvertures » par recherche texte** : aujourd'hui recherche **par ISBN** seulement (Google Books
  avec clé, devinette Open Library ; la BnF n'est plus interrogée) et livres sans ISBN ignorés. La recherche en ligne
  est une recherche **texte** : Google Books et Open Library y renvoient d'autres éditions, souvent illustrées
  (Open Library `cover_i`). Si l'ISBN ne donne rien : recherche texte (titre + auteur, ou série + numéro) et
  couverture d'un résultat **concordant** (titre normalisé, auteur, numéro ; même ISBN de préférence), marquée
  « autre édition » et **proposée à valider** plutôt qu'appliquée d'office (risque de mauvaise image).
- **Autre édition d'un livre hors série** : en magasin, « Tu as ce tome dans une autre édition » ne marche que pour
  un tome de série (série reconnue + même numéro, éditeur compatible). Un livre hors série dans une autre édition
  (poche / grand format, réédition) donne « pas dans ta collection ». Après la recherche en ligne, comparer titre
  normalisé + auteur (`normalizeTitle`, `authorKey`) aux livres possédés sans série ; bandeau vert « autre
  édition ». Limite : il faut le réseau (l'ISBN seul ne relie pas deux éditions).

### Phase 25 — Livres numériques (1/2) : support numérique, import Calibre
Ebooks du téléphone/PC, Kindle ou Kobo, rangés dans la collection. **Métadonnées seulement** : jamais de
contournement de DRM ni de copie des fichiers.
- **Modèle** : support « papier / numérique » sur l'item (champ dédié plutôt que le texte libre `format`, migration
  de schéma + Supabase), affiché sur la fiche et la grille ; le mode magasin dit « tu l'as en numérique » ; stats
  séparables.
- **Import Calibre** (`metadata.db`, SQLite : titres, auteurs, séries + `series_index`, identifiants ISBN,
  couvertures) : le meilleur pivot, Calibre gérant déjà Kindle et Kobo.
- Classement : recherche par ISBN puis rattachement aux séries existantes (`series_matching.dart`), doublons par
  ISBN, revue avant import (comme la rafale).

### Phase 26 — Livres numériques (2/2) : dossier EPUB/CBZ, Kobo
- **Dossier de fichiers** (EPUB : OPF `dc:title`/`dc:creator`/`dc:identifier`, série `calibre:series` ou
  `belongs-to-collection` + `group-position` ; CBZ : `ComicInfo.xml` Series/Number ; PDF : titre seulement).
  Android : dossier choisi via le Storage Access Framework (accès persistant) ; desktop : file_selector.
- **Kobo branchée en USB** (desktop) : `.kobo/KoboReader.sqlite`, table `content` (titre, auteur, série, numéro,
  ISBN, `ReadStatus`, pourcentage, dernière lecture) → importe aussi le statut de lecture.
- **Kindle** : pas d'API publique ; livres achetés seulement via Calibre ou l'import CSV existant (export
  Goodreads…), fichiers personnels via le dossier `documents` en USB (métadonnées pauvres).
- Chemins/URI des fichiers en table **locale** (propres à l'appareil, non synchronisés), bouton « Ouvrir » vers la
  liseuse système.

### Phase 27 — Recette de la v4
Pilotée par l'utilisateur, comme la phase 21 : tests manuels ajoutés par les phases 22 à 26, puis **mode rafale
`R-01` à `R-04`** (reportés de la v3), et ce qui resterait non fait de la recette v3.

## 5. Hors périmètre (inchangé)
iOS/macOS, partage de collection, alertes de sortie des nouveaux tomes, scraping, cote automatique, service
externe de suivi d'erreurs.
