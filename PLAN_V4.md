# Dupe — Plan v4

> Suite de `PLAN_V3.md`. Les conventions de `CLAUDE.md` restent valables sans exception (une phase à la fois,
> fichiers < 250 lignes, textes dans `app_fr.arb`, jamais de lecture de `env.json`, jamais de connexion au Supabase
> distant, l'assistant stage et propose un message de commit conventionnel, l'utilisateur committe).
>
> Comme les plans précédents, ce fichier sert d'**état du projet** : mettre à jour le tableau de la section 3 et
> ajouter un bilan « Réalisé / Écarts / Non vérifié » sous chaque phase terminée.
>
> Les bibliothèques citées sont des pistes : **vérifier version, plateformes supportées (Android, Linux,
> Windows) et maintenance** avant de les adopter, et préférer du code maison simple quand un package n'apporte
> pas assez.
>
> **Calendrier (décisions de l'utilisateur)** : la v4 a commencé pendant la recette de la v3 (2026-11-15/16) avec
> les phases 23 et 24 ; la **fin de la recette v3 est la phase 26**, à faire **juste avant les livres numériques**,
> eux-mêmes placés en fin de v4 (avant la recette de la v4). Le
> plan ci-dessous fusionne le premier brouillon (idées issues de la recette, 2026-11-15) et le plan v4 rédigé par
> l'utilisateur (2026-11-16) ; les numéros déjà utilisés sont gardés, l'**ordre d'exécution** est dans la section 3.

## 1. Objectif de la v4

Enrichir la collection après la v3 : des données plus complètes et plus justes (ISBN, couvertures, séries, titres
des tomes), des photos propres, le suivi des dédicaces, les livres numériques rangés avec les livres papier, et
deux fonctions tournées vers la suite de la collection : être prévenu des nouveautés et recevoir des suggestions.

## 2. Principes transverses

- **Tout changement de schéma** suit la procédure de `CLAUDE.md` : `schemaVersion`, migration drift, dump du
  schéma, test de migration, migration SQL Supabase avec RLS, prise en charge par `SyncCodec`, sauvegarde JSON
  et export CSV. **La migration Supabase est appliquée par l'utilisateur avant d'installer la version qui
  l'utilise** (sinon la synchro est refusée) ; les versions plus anciennes ignorent les colonnes inconnues.
- **Plugins mono-plateforme** (Android seulement) : jamais instanciés ailleurs, fake injecté par `pumpApp`,
  repli fonctionnel sur PC.
- **Nouvelles sources** : fixtures réelles, limiteur de débit, cache disque `CachePolicy`, activables dans
  Paramètres → Sources, échecs au journal, jamais de scraping.
- **Photos** : jamais de métadonnées EXIF conservées (position GPS notamment), puisqu'elles partent sur Supabase.

### Repris de la v3
- **Déjà livré pendant la phase 21** (exceptions au gel) : ISBN dans les résultats de recherche, barre de
  progression indicative pour les séries sans total, « marquer comme lus » depuis la page d'un auteur, ajout des
  tomes précédents à l'ajout d'un tome N, légende de la grille en haut, glisser pour retirer une envie, tomes vides
  complétés au scan.
- **Fait en fin de v3** (2026-11-15) : obfuscation des Releases publiques (seulement elles ; les APK locaux de
  l'utilisateur restent lisibles), symboles joints à la Release, `coverError` sans `runtimeType`.
- **Tests reportés après la v4** (décision de l'utilisateur) : mode rafale `R-01` à `R-04`, à dérouler dans la
  recette de la v4 (phase 35).

## 3. État des phases

| Ordre | Phase | Sujet | État | Tests auto | Vérifié en réel |
|---|---|---|---|---|---|
| 1 | 23 | Séries : nombre de tomes, tomes suivants, vue liste | ✅ fait (2026-11-15/16) | oui | en partie (`U-*`) |
| 2 | 24 | Titres des tomes (champ dédié, vue pastilles) | ✅ fait (2026-11-16) | oui (+ Supabase local) | non (`I-*`) |
| 3 | 22 | Qualité des données et ISBN manquants | ✅ fait (2026-11-16) | oui | non (`C-*`) |
| 4 | 25 | Éditions et couvertures | ✅ fait (2026-11-16) | oui | non (`X-*`) |
| 5 | 29 | Photos : redressement et recadrage | ✅ fait (2026-11-16) | oui | non (`P-*`) |
| 6 | 30 | Recommandations | ✅ fait (2026-11-16) | oui | non (`G-*`) |
| 7 | 37 | Ajout d'une série complète (ISBN de tous les tomes sans rescanner) | ✅ fait (2026-11-17) | oui | non (`Z-*`) |
| 8 | 31 | Dédicaces | ✅ fait (2026-11-17) | oui (+ Supabase local) | non (`W-*`) |
| 9 | 32 | Nouvelles sources de métadonnées | à faire | — | — |
| 10 | 33 | Alertes de nouveautés | à faire | — | — |
| 11 | 34 | Compte : mot de passe oublié, liens de confirmation | à faire | — | — |
| 12 | 26 | Fin de la recette de la v3 (reprise de la phase 21) | à faire, juste avant les livres numériques | — | — |
| 13 | 27 | Livres numériques (1/2) : support numérique, import Calibre | à faire | — | — |
| 14 | 28 | Livres numériques (2/2) : dossier EPUB/CBZ, Kobo | à faire | — | — |
| 15 | 36 | Version web installable (PWA) | à faire | — | — |
| 16 | 35 | Recette de la v4 (dont mode rafale) | à faire | — | — |

L'ordre compte : 22 est rapide et utile tout de suite ; 29 sert à 31 ; 32 fournit les données dont 33 a besoin.
**Décisions de l'utilisateur (2026-11-16)** : les livres numériques (27-28) passent à la fin, juste avant la recette
de la v4, et la fin de la recette de la v3 (26) juste avant eux ; les **recommandations remontent en phase 30**
(avant les dédicaces, renumérotées 31, les sources 32 et les alertes 33). Conséquence : elles partent des sources
actuelles (AniList, BnF, Google Books, Open Library) ; Wikidata et MangaUpdates (phase 32) les enrichiront
ensuite. **Décisions du 2026-11-17** : une version web installable (PWA, phase 36) en fin de v4, juste avant la
recette ; l'ajout d'une série complète (phase 37, idée de l'utilisateur) juste après les recommandations. L'ordre
reste ajustable.

## 4. Phases

### Phase 22 — Qualité des données et ISBN manquants
- **Indicateur ISBN manquant** : badge discret sur la fiche d'un ouvrage possédé sans ISBN, et sur sa pastille
  dans la grille des tomes (activable, pour ne pas surcharger la grille).
- **Écran « Qualité de la collection »** (Plus → Statistiques ou Paramètres) : compteurs cliquables qui ouvrent
  la liste filtrée correspondante : sans ISBN, sans couverture, sans numéro de tome dans une série, livre isolé
  qui ressemble à un tome de série, série sans nombre total de tomes. Reprend l'action existante « Compléter
  les couvertures manquantes » (et « Vérifier le nombre de tomes des séries », phase 23).
- **Mode complétion par scan** : depuis la liste « sans ISBN », parcourir les ouvrages un par un ; pour chacun,
  scanner le livre (caméra sur Android, champ ISBN ou douchette sur PC) pour lui attribuer l'ISBN. Contrôles :
  ISBN valide, pas déjà porté par un autre ouvrage (sinon proposer de voir le doublon), titre trouvé en ligne
  cohérent avec celui de l'ouvrage (sinon demander confirmation). Option « Compléter aussi les infos
  manquantes » qui réutilise `Compléter` sans écraser les champs saisis (`fillBlanks`, déjà utilisé au scan).
- Réutilise le mécanisme « ISBN mémorisé » du mode Magasin plutôt que de dupliquer la logique.

*Critère : depuis l'écran Qualité, j'attribue un ISBN à dix ouvrages à la suite en les scannant, et le compteur
« sans ISBN » baisse d'autant.*

**Bilan (2026-11-16)**
- **Réalisé** :
  - Feature `quality/` : `computeQuality` (`domain/collection_quality.dart`, `QualityIssue`) — possédés sans ISBN
    (les envies n'en ont pas besoin), sans couverture, tomes de série sans numéro, livres isolés qui ressemblent à un
    tome (marqueur « Tome N » via `titleHasVolume`, ou titre d'une série du même type), séries sans total ;
    `collectionQualityProvider` en direct (flux drift items + séries).
  - Plus → **« Qualité de la collection »** (`quality_screen.dart`) : compteurs, chaque ligne ouvre sa liste
    (`quality_list_screen.dart`, chaque livre ou série ouvre sa fiche) ; « Compléter par scan » ; réglage
    « Signaler les ISBN manquants dans les séries » (point sur la pastille, désactivé par défaut,
    `MissingIsbnInGrid`) ; actions automatiques réunies : couvertures (`MissingCoversTile`, extrait des Paramètres),
    titres des tomes, nombre de tomes.
  - **Complétion par scan** (`isbn_completion_screen.dart`) : livres un par un (caméra sur Android, champ / douchette
    sur PC), « Passer », progression ; `IsbnAssignment` : ISBN déjà porté par un autre livre → refus + « Voir ce
    livre » ; titre trouvé en ligne incohérent (`titlesFit` : égalité ou inclusion de titres normalisés, série
    comprise) → confirmation ; sources injoignables → ISBN gardé sans contrôle de titre ; option « Compléter aussi
    les infos manquantes » (`fillBlanks`, comme « ISBN mémorisé » du mode Magasin, titre de tome compris).
  - Fiche d'un livre possédé sans ISBN : puce « ISBN manquant · scanner » qui ouvre la complétion pour ce seul livre.
  - Tests : `collection_quality_test.dart` (calcul, contrôles, attribution), `quality_screens_test.dart` (parcours
    complet : 3 → 1 « sans ISBN », doublon, titre différent, « Passer » ; puce de la fiche ; point sur la pastille).
- **Écarts** : écran placé dans Plus (pas dans Statistiques ni Paramètres) ; le contrôle de cohérence ne fait
  qu'une comparaison de titres normalisés (pas d'auteur ni d'éditeur).
- **Non vérifié** : critère des dix livres scannés à la suite sur le téléphone (`C-01` à `C-04`).
- **Ajustements (2026-11-16, demandes de l'utilisateur)** : indicateur d'ISBN manquant **activé par défaut** ; en plus
  du point sur les pastilles, une **icône** (QR) sur la ligne d'une série, d'un livre isolé et d'un auteur qui ont des
  livres possédés sans ISBN, avec leur nombre en infobulle (`MissingIsbnMark`, `SeriesEntry.missingIsbnCount` en SQL,
  `AuthorGroup.missingIsbnCount`), en liste comme en grille ; un seul réglage les coupe tous.

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
  - **Repris en phase 24** : titres des tomes aussi dans la vue pastilles, et un vrai **titre de tome** : aujourd'hui un tome
    n'a pas de champ « titre propre » (`applyMetadata` jette le sous-titre d'un tome numéroté ; le titre propre n'est
    connu que si la BnF le met en titre principal, ex. Kaamelott) → champ `volume_title` sur l'item (migration de
    schéma locale v3 + Supabase), rempli depuis BnF 200$a/$e/$i, Google Books `subtitle`, Comic Vine `name`.

### Phase 24 — Titres des tomes
Demande de l'utilisateur (`U-04`, 2026-11-16) : un tome n'affiche souvent que « Tome 1 ».
- Champ **`volume_title`** (titre propre du tome) sur l'item : migration de schéma locale v3 + migration Supabase,
  synchro, sauvegarde/import (JSON, CSV).
- Rempli à l'ajout et au scan (`applyMetadata`, `fillBlanks`) depuis BnF (200$a quand c'est le titre du tome, $e,
  $i), Google Books `subtitle`, Comic Vine `name` ; modifiable dans le formulaire.
- Affiché dans la vue liste, sur la fiche, et **sous les pastilles** de la vue grille (ou en infobulle si la place
  manque) ; « Compléter les couvertures »/le scan complètent aussi les titres manquants.

**Bilan (2026-11-16)**
- **Réalisé** :
  - Champ `volumeTitle` / `volume_title` : modèle `Item`, table `items`, **schéma local v3** (`addColumn`, dump
    `drift_schema_v3.json`, tests de migration v1→v3 et v2→v3), migration Supabase
    `20261116120000_volume_title.sql` (colonne facultative ; RLS et trigger inchangés). Synchro et sauvegarde JSON
    par `SyncCodec` (générique) ; CSV : colonne « Titre du tome » à l'export et à l'import (`ImportField.volumeTitle`,
    en-têtes « Titre du tome », « Sous-titre », « Subtitle »…).
  - Règle `volumeTitleOf` (`metadata_mapping.dart`) : pour un tome de série, le titre de la notice quand il diffère
    de celui de la série (BnF : « Les renforts maléfiques »), le sous-titre (Comic Vine : nom de l'issue ; BnF
    200 $e/$i ; Google), ou les deux ; **vide** pour un livre isolé ou un tome connu seulement par son numéro.
    Appliquée à l'ajout (`applyMetadata` via `loadItemDraft`), au scan d'un tome vide (`fillBlanks`, sans écraser
    une saisie) ; champ « Titre du tome » dans le formulaire.
  - **Tomes déjà présents** : Paramètres → Sources → « Compléter les titres des tomes » (`VolumeTitleFill`) :
    tomes de série numérotés, avec ISBN, sans titre ; recherche par ISBN (réponses souvent déjà en cache), titre
    seul enregistré. Les tomes ajoutés avant dont le titre est déjà le titre propre (ex. Kaamelott) s'affichent sans
    rien faire (`VolumeSlot.ownTitle`).
  - Affichage : vue liste, fiche (sous le titre), et sous chaque pastille de la vue grille (colonnes de largeur
    fixe dès qu'un tome a un titre, deux lignes au plus).
  - Tests : `fill_blanks_test.dart`, `item_drafts_test.dart`, `volume_title_fill_test.dart`, `migration_test.dart`,
    `import_export_test.dart`, `series_navigation_test.dart` ; tests `supabase` verts sur le Supabase local **après**
    la migration (avant : « Could not find the 'volume_title' column », la synchro est refusée).
- **Écarts** : pas d'infobulle sur les pastilles (l'appui long y ajoute un tome) : titre affiché en dessous. Les
  tomes sans ISBN ne peuvent pas être complétés automatiquement (formulaire, ou futur mode complétion par scan de
  la phase 22).
- **Non vérifié** : migration appliquée au vrai projet Supabase (action de l'utilisateur, **avant** d'installer
  cette version) ; titres trouvés sur la vraie collection (`I-01` à `I-03`).

### Phase 25 — Éditions et couvertures
- **« Compléter les couvertures » par recherche texte** : aujourd'hui recherche **par ISBN** seulement (Google Books
  avec clé, devinette Open Library ; la BnF n'est plus interrogée) et livres sans ISBN ignorés. **Décision de
  l'utilisateur (2026-11-16)** : les livres **sans ISBN restent ignorés** (rien n'est cherché pour eux) ; on leur
  attribue d'abord un ISBN par la complétion par scan de la phase 22, puis ils entrent dans la recherche. La recherche en ligne
  est une recherche **texte** : Google Books et Open Library y renvoient d'autres éditions, souvent illustrées
  (Open Library `cover_i`). Si l'ISBN ne donne rien : recherche texte (titre + auteur, ou série + numéro) et
  couverture d'un résultat **concordant** (titre normalisé, auteur, numéro ; même ISBN de préférence), marquée
  « autre édition » et **proposée à valider** plutôt qu'appliquée d'office (risque de mauvaise image).
- **Autre édition d'un livre hors série** : en magasin, « Tu as ce tome dans une autre édition » ne marche que pour
  un tome de série (série reconnue + même numéro, éditeur compatible). Un livre hors série dans une autre édition
  (poche / grand format, réédition) donne « pas dans ta collection ». Après la recherche en ligne, comparer titre
  normalisé + auteur (`normalizeTitle`, `authorKey`) aux livres possédés sans série ; bandeau vert « autre
  édition ». Limite : il faut le réseau (l'ISBN seul ne relie pas deux éditions).

**Décisions (2026-11-16)** : validation dans Qualité ; refus mémorisés sur l'appareil seulement (pas de migration) ;
« autre édition » en magasin seulement si titre **et** auteur correspondent ; livres sans ISBN ignorés.

**Ajustement (2026-11-16, demande de l'utilisateur)** : « Compléter les couvertures manquantes », « Compléter les
titres des tomes » et « Vérifier le nombre de tomes des séries » **retirés des Paramètres** : ils ne vivent plus que
dans Plus → Qualité de la collection (actions sur les données, pas des réglages). « Nombre total de tomes… » reste
dans le menu de chaque série (une série précise, saisie manuelle).

**Bilan (2026-11-16)**
- **Réalisé** :
  - `covers/domain/edition_match.dart` : `mainTitle` (titre normalisé sans sous-titre), `sameWork` (même titre ou
    série, même numéro de tome, un auteur commun quand les deux en ont), `sameStandaloneBook` (titre **et** auteur
    exigés).
  - « Compléter les couvertures manquantes » : quand l'ISBN ne donne aucune image, recherche texte (série + numéro
    pour un tome, titre + auteur sinon ; sans la BnF, `searchText(except:)`) → `proposeCover` : résultat concordant
    dont l'image se télécharge, même ISBN en premier → **proposition** (`CoverProposals`), jamais appliquée d'office.
  - Qualité → « Couvertures proposées » (`cover_proposals_screen.dart`) : image, source et titre de l'autre édition,
    **Garder** / **Refuser**, « Tout garder » ; une proposition laissée de côté reste. Refus mémorisés localement
    (`RefusedCovers`, `cover_refused`).
  - Mode Magasin : un livre hors série possédé dans une autre édition → bandeau vert « Tu as ce livre dans une autre
    édition » (`StoreChecker`, `listStandaloneItems`) ; un homonyme d'un autre auteur reste inconnu.
  - Tests : `edition_match_test.dart`, `cover_proposals_test.dart` (proposé puis gardé ; refus non reproposé),
    `store_mode_test.dart` (autre édition, homonyme).
- **Écarts** : propositions gardées en mémoire (pas en base) : elles disparaissent au redémarrage de l'appli et
  reviennent au prochain passage de « Compléter les couvertures » ; pas de bouton « Passer » (une proposition non
  traitée reste simplement dans la liste).
- **Non vérifié** : pertinence des propositions sur la vraie collection, et l'autre édition en magasin (`X-01` à
  `X-03`).

### Phase 26 — Fin de la recette de la v3
Décision de l'utilisateur (2026-11-16) : terminer la recette de la v3 (phase 21, `TESTS_MANUELS.md`) avant les
livres numériques. Tests restants (reportés ou non faits) déroulés comme en phase 21, puis clôture de la phase 21
dans `PLAN_V3.md` (critère : chaque test OK, automatisé, ou écart documenté et accepté). Les tests du mode rafale
restent pour la phase 35.

### Phase 27 — Livres numériques (1/2) : support numérique, import Calibre
Ebooks du téléphone/PC, Kindle ou Kobo, rangés dans la collection. **Métadonnées seulement** : jamais de
contournement de DRM ni de copie des fichiers.
- **Modèle** : support « papier / numérique » sur l'item (champ dédié plutôt que le texte libre `format`, migration
  de schéma + Supabase), affiché sur la fiche et la grille ; le mode magasin dit « tu l'as en numérique » ; stats
  séparables.
- **Import Calibre** (`metadata.db`, SQLite : titres, auteurs, séries + `series_index`, identifiants ISBN,
  couvertures) : le meilleur pivot, Calibre gérant déjà Kindle et Kobo.
- Classement : recherche par ISBN puis rattachement aux séries existantes (`series_matching.dart`), doublons par
  ISBN, revue avant import (comme la rafale).

### Phase 28 — Livres numériques (2/2) : dossier EPUB/CBZ, Kobo
- **Dossier de fichiers** (EPUB : OPF `dc:title`/`dc:creator`/`dc:identifier`, série `calibre:series` ou
  `belongs-to-collection` + `group-position` ; CBZ : `ComicInfo.xml` Series/Number ; PDF : titre seulement).
  Android : dossier choisi via le Storage Access Framework (accès persistant) ; desktop : file_selector.
- **Kobo branchée en USB** (desktop) : `.kobo/KoboReader.sqlite`, table `content` (titre, auteur, série, numéro,
  ISBN, `ReadStatus`, pourcentage, dernière lecture) → importe aussi le statut de lecture.
- **Kindle** : pas d'API publique ; livres achetés seulement via Calibre ou l'import CSV existant (export
  Goodreads…), fichiers personnels via le dossier `documents` en USB (métadonnées pauvres).
- Chemins/URI des fichiers en table **locale** (propres à l'appareil, non synchronisés), bouton « Ouvrir » vers la
  liseuse système.

### Phase 29 — Photos : redressement et recadrage
Objectif : une photo prise de travers devient une couverture droite, bien cadrée, au bon format.

- **Android, détection automatique** : scanner de documents ML Kit (`google_mlkit_document_scanner` ou
  équivalent) qui détecte les bords, corrige la perspective et recadre. Vérifier sa dépendance aux services
  Google Play et le comportement hors ligne ; en cas d'indisponibilité, basculer sur l'éditeur manuel.
- **Éditeur manuel, toutes plateformes** (fichiers maison, Flutter pur) : l'image avec quatre coins
  déplaçables (pré-placés sur un cadre par défaut, loupe sous le doigt pour la précision), rotation par quart de
  tour, zoom via `InteractiveViewer`. Le redressement est calculé avec le package `image` (correction de
  perspective par les quatre coins, application de l'orientation EXIF, redimensionnement), dans un isolate pour
  ne pas figer l'interface.
- **Sortie normalisée** : JPEG, côté long 1200 px maximum, qualité ~85, EXIF supprimé. Ratio libre par défaut,
  avec préréglages (manga/livre de poche, album BD, comics).
- **Original conservé localement** (non synchronisé) pour pouvoir refaire le recadrage ; seule l'image finale
  est envoyée sur Supabase. Purge des originaux possible dans Paramètres.
- Action « Recadrer la couverture » sur les photos existantes (`dupe-cover:`).
- Tests : calcul des coins et de la transformation sur des images de test générées, suppression de l'EXIF,
  dimensions de sortie.

*Critère : une photo de couverture prise de biais sur le téléphone donne une image droite et sans bord de table
en moins de trois appuis ; l'image envoyée ne contient aucune donnée EXIF.*

**Bilan (2026-11-16)**
- **Réalisé** :
  - `covers/domain/perspective.dart` : homographie quatre coins → rectangle (vraie perspective, élimination de
    Gauss ; pas `copyRectify` du package `image`, qui n'est qu'un mélange bilinéaire et courbe les bords),
    `outputSize` (côtés opposés les plus longs, préréglage de ratio, 1200 px max, jamais agrandi),
    `rotateQuadClockwise`, `CoverAspect` (libre, manga/poche 11,5×18, album BD 24×32, comics 17×26).
  - `covers/data/cover_processing.dart` (package `image` 4.13, chaque étape dans `Isolate.run`) : `prepare`
    (orientation EXIF appliquée, 2400 px max), `rotate`, `crop` (source réduite d'abord si elle est bien plus grande
    que la sortie, puis échantillonnage bilinéaire), `normalize` (sortie du scanner) ; JPEG qualité 85, **EXIF
    vidé** à chaque encodage.
  - Android : scanner ML Kit `google_mlkit_document_scanner` 0.7.2 (`cover_scanner.dart`, mode `base` : détection,
    recadrage, rotation, sans les filtres de « nettoyage » ; import depuis la galerie possible). Annulation → rien ;
    impossible de démarrer (services Google Play absents/anciens, module pas encore téléchargé hors ligne) →
    `ScannerUnavailable`, journalisé, puis éditeur manuel.
  - Éditeur manuel toutes plateformes (`presentation/crop/`) : quatre coins déplaçables (cadre par défaut à 10 % des
    bords), loupe ×2,5 sous le doigt (`RawMagnifier`), zoom `InteractiveViewer` (poignées de taille constante),
    quart de tour, réinitialisation, préréglages de ratio.
  - Original (photo redressée par l'EXIF, sans EXIF, 2400 px max) gardé dans `covers/originals/<itemId>.jpg`,
    **jamais synchronisé** (la synchro ne lit que les URL des items) ; bouton « Recadrer la couverture » sur la fiche
    (photos `dupe-cover:` ; original absent → la couverture elle-même, téléchargée si besoin) ; Paramètres → « Photos
    originales » (taille, « Vider » : les couvertures restent).
  - Tests : `perspective_test.dart`, `cover_processing_test.dart` (orientation, EXIF supprimé, coins sans bord noir
    après redressement, dimensions), `cover_photo_form_test.dart` (éditeur, scanner, recadrage d'une photo existante),
    `cover_photos_test.dart` (originaux, purge). `pumpApp` injecte `FakeCoverScanner` (indisponible par défaut).
- **Écarts** : pas de détection automatique des bords hors Android (cadre par défaut à déplacer) ; avec le scanner
  ML Kit, l'« original » gardé est l'image déjà recadrée par ML Kit (il ne rend pas la photo brute) ; la photo
  passe par `image_picker` (2400 px, qualité 92) avant l'éditeur.
- **Non vérifié** : prises de vue réelles (biais, faible lumière, couverture brillante), ML Kit sur le téléphone
  (premier téléchargement du module, hors ligne), temps de traitement sur le téléphone (`P-01` à `P-04`).
- **Correctif rafale (retour de l'utilisateur pendant la phase, Everdark)** : un tome dont la BnF n'avait pas répondu
  (délai, limite de débit) était importé avec la seule fiche Google Books (titre « Everdark », sans numéro) → livre
  isolé hors de la série. `ScanQueueWorker` : si une source a échoué et que le résultat n'a **ni série ni numéro**,
  l'entrée passe « échec » (bouton Réessayer de la revue) au lieu d'être importée (`scan_queue_worker_test.dart`).

### Phase 30 — Recommandations
Calcul local et explicable, sans apprentissage automatique ni service externe d'IA.

- **Profil** déduit de la collection : auteurs, éditeurs/collections, genres et tags (AniList, sujets Open
  Library ; MangaUpdates après la phase 32), pondérés par le nombre d'ouvrages, le statut lu et la note.
- **Familles de suggestions**, chacune avec sa raison affichée (« Parce que tu as 12 albums de Larcenet ») :
  - du même auteur (par nom d'auteur avec les sources actuelles ; enrichi par les identifiants d'auteur de la
    phase 32 une fois celle-ci faite) ;
  - recommandations communautaires d'AniList pour les mangas bien notés (MangaUpdates ajouté en phase 32) ;
  - même collection d'éditeur ;
  - suites et séries liées (AniList ; Wikidata après la phase 32).
- **Classement** : score simple et documenté (poids du profil, popularité modérée, diversité des familles),
  exclusion de ce qui est possédé, en envie ou déjà écarté.
- **Retour utilisateur** : « Pas intéressé » (table synchronisée `recommendation_feedback`) qui écarte la
  suggestion et réduit le poids de sa raison ; « Ajouter aux envies » en un appui.
- **Calcul** en arrière-plan, résultats mis en cache une semaine, rafraîchissement manuel ; écran
  « Suggestions » (Plus) avec filtre par type.
- Tests : scoring et exclusions sur un jeu de données construit à la main, raisons affichées.

*Critère : sur la vraie collection, au moins la moitié des dix premières suggestions paraissent pertinentes à
l'utilisateur, et chacune affiche une raison compréhensible.*


**Bilan (2026-11-16)**
- **Réalisé** : `features/recommendations/` — profil local (`taste_profile.dart` : poids lu/note/envie), familles
  « même auteur » (BnF `searchByAuthor`, 6 auteurs les plus lourds), « communauté » et « liée » (AniList
  `neighbours`, 6 séries manga ; homonyme écarté si ni titre ni auteur commun), score documenté dans
  `suggestion_ranking.dart` (famille, popularité modérée, ×0,5 par « Pas intéressé » de même raison, diversité),
  exclusions (possédé, envie, synonymes AniList, écarté). Table synchronisée `recommendation_feedback` (schéma
  **v4** + migration Supabase `20261116180000_recommendation_feedback.sql`). Écran Plus → Suggestions (raison,
  filtre par type, « Ajouter aux envies » = tome 1 d'une série non suivie ou livre, « Pas intéressé »,
  Recalculer), cache local 7 jours. Clients BnF/AniList partagés (`bnfSourceProvider`, `anilistSourceProvider`).
  Tests : fixtures réelles (`anilist/neighbours_*.json`, `bnf/author_larcenet.xml`), classement, moteur, écran.
- **Écarts** : famille « même collection d'éditeur » non faite (la collection n'est pas stockée sur les ouvrages) ;
  titres AniList en anglais/rōmaji ; Wikidata/MangaUpdates en phase 32.
- **Non vérifié** : pertinence sur la vraie collection (`G-01`), synchro des refus (`G-02`) ; migration Supabase
  **à appliquer avant d'installer**.

### Phase 31 — Dédicaces
- **Schéma** : sur `items`, `is_signed` (bool), `signed_by` (texte, pré-rempli avec les auteurs de l'ouvrage),
  `signed_on` (date), `signed_place` (festival, librairie…), `signing_note` (texte de la dédicace, à qui).
- **Photos multiples** : nouvelle table synchronisée `item_photos` (`item_id`, `kind` : dédicace | autre,
  `position`, chemin), stockées dans le même bucket privé que les couvertures et passées par le pipeline
  d'envoi existant. Prise de vue avec l'éditeur de la phase 29 (sans correction de perspective forcée : une
  dédicace se photographie souvent page ouverte).
- **Interface** : section « Dédicace » sur la fiche (coche, champs, galerie, plein écran avec zoom), badge sur la
  pastille du tome et dans les listes, filtre « Dédicacés », compteur dans les statistiques, colonnes dans
  l'export CSV.
- **Sauvegarde des photos** : les photos de dédicace sont irremplaçables, or les sauvegardes JSON n'en
  gardent que les références. Ajouter un export « Archive complète » (zip : JSON + toutes les photos, package
  `archive`) et sa restauration.

*Critère : je coche un tome comme dédicacé, j'ajoute deux photos sur le téléphone, et je les retrouve sur le PC
après synchro ; l'archive complète restaure les photos sur un appareil vierge.*


**Bilan (2026-11-17)**
- **Réalisé** : schéma **v5** (`items` : `is_signed`, `signed_by`, `signed_on`, `signed_place`, `signing_note` ;
  table synchronisée `item_photos` : `item_id`, `url` `dupe-cover:`, `kind` dédicace | autre, `position`) + migration
  Supabase `20261117120000_signed_copies.sql` (validée sur le Supabase local avec celle de la phase 30, tests
  `-P supabase` verts). Photos par le pipeline des couvertures (`uploadPendingCovers` lit aussi `item_photos`).
  Formulaire : section « Dédicace » (`item_signing_fields.dart`, signataire pré-rempli avec les auteurs, détails
  effacés si décoché). Fiche : `signing/item_signing_section.dart` (détails, galerie, ajout de photo redressée
  sans EXIF à 1200 px sans recadrage forcé, appui long = suppression) et plein écran avec zoom et balayage
  (`photo_viewer.dart`) ; « Ajouter une photo » aussi sur un ouvrage non dédicacé. Stylo sur les pastilles, la vue
  liste, les lignes et la grille des onglets (`SignedMark`) ; filtre « Dédicacés » ; tuile des statistiques ;
  5 colonnes dans l'export CSV. Paramètres → « Archive complète (avec photos) » / « Restaurer une archive
  complète » (`full_archive.dart`, package `archive` : `sauvegarde.json` + `photos/`, photos d'un autre appareil
  téléchargées, restauration en fusion, aucun chemin hors du dossier des photos).
  Tests : migration v4 → v5, envoi des photos, archive (appareil vierge, chemin malveillant, fichier invalide),
  parcours complet (`signed_copy_test.dart`).
- **Écarts** : pas de choix du type de photo (toutes « dédicace ») ni de réordonnancement ; photos à 1200 px (même
  format que les couvertures) ; l'import CSV ignore les colonnes de dédicace ; restauration d'archive en fusion
  seulement (pas de « remplacer »).
- **Non vérifié** : critère réel (deux photos sur le téléphone retrouvées sur le PC), archive sur un appareil vierge
  (`W-01` à `W-03`) ; migration Supabase **à appliquer avant d'installer**.

### Phase 32 — Nouvelles sources de métadonnées
**Avant de coder** : produire un bilan à partir du journal et de la base (par type : part des ouvrages sans
couverture, sans numéro, sans série, sans ISBN, sources en échec) et le présenter à l'utilisateur pour
prioriser.

Sources candidates (vérifier documentation et conditions d'utilisation actuelles) :
- **Wikidata** (SPARQL, sans clé, User-Agent identifiant l'appli exigé) : ISBN → œuvre, série et numéro
  d'ordre, suite/précédent, auteurs avec identifiants stables. Sert le rattachement aux séries et prépare les
  alertes (phase 33) et enrichit les recommandations (phase 30) : œuvres d'un auteur.
- **MangaDex** (sans clé) : couvertures par tome, parfois de l'édition française ; recherche par titre de
  série puis numéro, avec préférence pour la langue `fr`.
- **MangaUpdates** (API publique v1, sans clé) : nombre de tomes, statut, recommandations ; complète AniList
  pour le nombre total de tomes (dont des œuvres non japonaises qu'AniList ignore, cf. retours `U-01`).
- **Metron** (comics, jeton gratuit saisi dans l'appli comme en phase 15, 20 requêtes/min) : issues, dates de
  sortie, couvertures ; complète Comic Vine.
- **Sudoc** (`isbn2ppn` puis notice) : dernier recours, recoupe largement la BnF.

Intégration : chaque source comme `MetadataProvider` ou `SeriesMetadataProvider`, priorités par type mises à
jour dans `defaultPriorities`, fusion sans écraser une donnée plus fiable (BnF reste prioritaire pour les
éditions françaises).

*Critère : sur un échantillon fixé des ouvrages sans couverture ou sans numéro (fixtures), le taux de
complétion mesuré avant/après progresse, chiffres notés dans le bilan de phase.*


### Phase 33 — Alertes de nouveautés
**Limite assumée** : aucune source fiable ne liste les sorties françaises *à venir*. L'alerte signale une
nouveauté **dès qu'elle apparaît** dans une source (souvent à la parution, parfois un peu avant via Google
Books), pas des mois à l'avance. Exception : les comics US, dont Metron connaît les dates de sortie.

- **Abonnements** : interrupteur « Prévenir des nouveaux tomes » par série (activé par défaut pour les séries
  suivies, réglable) ; nouvelle table synchronisée `followed_authors` (nom, identifiants externes Wikidata /
  BnF / AniList quand connus) pour suivre un auteur depuis la vue par auteur.
- **Détection** :
  - série : chercher un tome de numéro supérieur au plus grand connu (BnF par titre de série et éditeur, Google
    Books triée par nouveauté, Metron pour les comics) ;
  - auteur : nouvelles notices de l'auteur depuis la dernière vérification (BnF, Google Books, Wikidata) ;
  - dédoublonnage par ISBN, ignorer ce qui est déjà possédé ou en envie.
- **Exécution sur l'appareil**, pas de serveur : au plus une fois par jour, au démarrage ou à la reprise ; sur
  Android, tâche de fond périodique (`workmanager`, Wi-Fi par défaut). Vérification étalée : nombre de séries
  par passage limité, limiteurs de débit et cache existants respectés.
- **Résultats** : table synchronisée `release_alerts` (statut nouveau / vu / ignoré / ajouté) pour qu'une
  alerte traitée sur un appareil ne revienne pas sur l'autre ; écran « Nouveautés » (Plus), notification locale
  regroupée (« 3 nouveautés dans tes séries »), ajout aux envies en un appui.
- Paramètres : activation globale, fréquence, Wi-Fi seulement, notifications.

*Critère : avec une série dont je possède les tomes 1 à N-1 et dont le tome N existe à la BnF (fixtures), une
alerte apparaît une seule fois, sur les deux appareils, et part en envie en un appui.*

### Phase 34 — Compte : mot de passe oublié, liens de confirmation
- **Mot de passe oublié sans être connecté** : lien « Mot de passe oublié ? » sur l'écran de connexion
  (email de réinitialisation Supabase), au lieu de passer par Paramètres → Mot de passe une fois connecté.
- **Lien de confirmation d'inscription** : il ouvre `localhost` (404). *Site URL* / *Redirect URLs* du projet
  Supabase à régler (action de l'utilisateur), et page d'arrivée (ou lien profond `dupe://`) qui confirme puis
  renvoie dans l'appli. Le lien de réinitialisation du mot de passe a le même besoin : à traiter ensemble.
- Question ouverte : lien profond `dupe://` (Android ; Linux/Windows à étudier) ou petite page web statique.

### Phase 35 — Recette de la v4
Pilotée par l'utilisateur, comme la phase 21 : tests manuels ajoutés par les phases 22 à 37, puis **mode rafale
`R-01` à `R-04`** (reportés de la v3), et ce qui resterait non fait de la recette v3.

### Phase 36 — Version web installable (PWA)
Décision de l'utilisateur (2026-11-17) : en fin de v4, avant la recette. Flutter web, installable depuis le
navigateur, même compte Supabase que les autres appareils.
- **Faisabilité vérifiée (2026-11-17, en-têtes CORS)** : BnF, Open Library, AniList et Google Books répondent au
  navigateur ; **Comic Vine non** (source désactivée sur le web).
- **À adapter** : drift web (SQLite WebAssembly, stockage du navigateur) ; tout `dart:io` (photos de couverture,
  sauvegardes, journal) derrière une abstraction ; `Isolate.run` indisponible (recadrage via `compute` ou direct).
- **Désactivé sur le web** : rappels de prêt (notifications), widget d'accueil, raccourcis, scanner ML Kit (éditeur
  manuel seul) ; recherche vocale à vérifier. Scan des codes-barres par la caméra possible (mobile_scanner web,
  HTTPS obligatoire).
- **Hébergement** : site statique HTTPS (GitHub Pages construit par la CI), URL de retour à ajouter dans Supabase.
- **Risque à tester d'abord** : couvertures réseau sur le web (CanvasKit exige le CORS des images ; certaines BnF /
  Google peuvent manquer).

*Critère : la collection synchronisée s'affiche dans le navigateur du PC et du téléphone, l'appli s'installe
depuis le navigateur, un ajout fait sur le web arrive sur le téléphone.*

### Phase 37 — Ajout d'une série complète
Idée de l'utilisateur (2026-11-17) : ajouter ou compléter une série entière sans scanner chaque tome pour son ISBN.
- **Recherche par nom de série** (BnF, notices liées 461 + numéro 200$h, comme vu pour Everdark : 7 tomes avec ISBN
  et numéros) ; Google Books en appoint. Pagination SRU (`startRecord`) pour les longues séries (One Piece).
- **Choix de l'édition** : regrouper par éditeur / collection ; l'utilisateur choisit la bonne.
- **Écran de revue** : un tome par ligne (numéro, titre, ISBN, couverture), coche « possédé » / « envie » / ignoré,
  plage rapide (« j'ai 1 à 12 »).
- **Série déjà présente** : les tomes sans ISBN reçoivent l'ISBN et les champs vides (`fillBlanks`, jamais une
  saisie écrasée) ; les tomes absents sont créés ; aucun doublon (même numéro). Action aussi depuis le menu d'une
  série : « Compléter depuis la BnF ».
- Tests : fixtures réelles (série courte et série paginée), fusion avec une série existante sans ISBN.

*Critère : pour une série possédée sans ISBN, une seule action donne leur ISBN à tous les tomes ; une nouvelle
série de 20 tomes s'ajoute en moins de cinq appuis.*

**Ajouts de l'utilisateur pendant la phase (2026-11-17)** : proposer la série complète quand le scan reconnaît un
tome de série ; mettre à jour **une** série (menu de la série) **ou toutes** (Qualité).

**Bilan (2026-11-17)**
- **Réalisé** : `BnfProvider.searchSeriesVolumes` (titre, pages SRU de 50, `startRecord`, 6 pages max) ;
  `domain/series_catalog.dart` (numéros « T07 », « . 31 », « 01 » ; éditions regroupées par éditeur via
  `publishersMatch` ; un tome = toutes ses notices, ISBN le plus bas par défaut = première impression ; autre titre
  écarté, ex. « Blue Lock épisode Nagi ») ; `domain/series_completion.dart` (`planCompletion` : tome sans ISBN
  complété par `fillBlanks`, tome absent créé possédé/envie, tome déjà avec ISBN jamais touché, aucun doublon).
  Écran `presentation/series_completion/` (titre, éditions en puces, « Possédés jusqu'au tome N », choix par tome,
  autre ISBN au choix si réimpressions) ; entrées : menu « + » d'un onglet (« Série complète (BnF) »), menu d'une
  série (« Compléter depuis la BnF »), bandeau du mode Magasin (« Ajouter la série complète », `context.go`).
  Qualité → « Compléter les ISBN des séries (BnF) » (`SeriesIsbnFill`) : toutes les séries ayant des tomes
  possédés sans ISBN, édition choisie par l'éditeur de la série, rien de créé ; plusieurs éditions possibles →
  série signalée, à faire depuis son menu. Tests : fixtures réelles (`bnf/series_everdark.xml`,
  `series_blue_lock_p1/p2.xml`), plan, écran (nouvelle série, menu, Qualité), bandeau magasin.
- **Écarts** : ISBN par défaut = première impression, pas forcément celui de l'exemplaire réel (une réimpression
  a son propre ISBN) ; BnF seule (Google Books non utilisé) ; écran à 262 lignes (un peu au-dessus de 250).
  Test photo `cover_photo_form_test` : attente réelle portée à 2 s (échouait sous la charge de la suite complète).
- **Non vérifié** : vraie collection (`Z-01` à `Z-03`).

## 5. Actions manuelles de l'utilisateur
- **Phase 24** : appliquer la migration Supabase du titre de tome **avant** d'installer la version qui l'utilise.
- **Phase 29** : tester sur téléphone plusieurs prises de vue (biais, faible lumière, couverture brillante).
- **Phase 30** : juger la pertinence des suggestions sur la vraie collection.
- **Phase 31** : tester l'archive complète sur un appareil vierge (ou une installation propre).
- **Phase 32** : créer un compte Metron et générer un jeton ; relire le bilan avant priorisation.
- **Phase 33** : vérifier sur Android que la tâche de fond n'est pas tuée par l'économiseur de batterie.
- **Phase 34** : régler *Site URL* / *Redirect URLs* du projet Supabase.

## 6. Hors périmètre
iOS/macOS, partage de collection, scraping, cote automatique, notifications poussées par un serveur,
recommandations par service d'IA externe, service externe de suivi d'erreurs, recherche du nombre de tomes des
BD et des livres (abandonnée par l'utilisateur le 2026-11-16).
