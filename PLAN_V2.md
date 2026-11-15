# Dupe — Plan v2

Suite de `PLAN.md` (phases 0 à 8 terminées). Même stack, mêmes conventions (`CLAUDE.md`), même méthode :
une phase à la fois, qui se termine par une appli qui compile sur Android et Linux, `flutter analyze` à zéro,
`flutter test` vert, puis arrêt en attendant le retour de l'utilisateur. Chaque phase ajoute à
`TESTS_MANUELS.md` ce qui ne se teste pas automatiquement.

Objectif de la v2 : rendre l'appli **fiable au quotidien** avant d'ajouter des fonctionnalités. La v1 fonctionne,
mais une erreur peut aujourd'hui passer inaperçue (synchro, messages d'erreur), se propager partout (pas
d'annulation, restauration qui fusionne) ou ne pas être vérifiable (Windows jamais compilé, pas de CI).

## Constats de départ (relecture du code, 2026-11-14)

- **Synchro** : le pull demande `server_updated_at > curseur`. L'horodatage est posé à l'écriture
  (`clock_timestamp()`), mais la ligne ne devient visible qu'au commit. Si deux appareils synchronisent en
  même temps, une ligne peut arriver avec un horodatage antérieur au curseur déjà avancé de l'autre appareil :
  elle n'y sera jamais tirée. Rare, silencieux, sans rattrapage.
- **Erreurs** : certaines avalées (`debugPrint` dans `supabase_sync.dart`, `loan_reminders.dart`), les autres
  affichées brutes (`'$e'`) en snackbar. Rien de consultable après coup.
- **Connexion** : code à 6 chiffres ou lien de l'email collé (modèles d'email non modifiables sans SMTP).
  Jugée bancale par l'utilisateur.
- **Suppression** : définitive du point de vue de l'utilisateur, alors que la base fait une suppression logique.
- **Restauration** : une sauvegarde fusionne (le plus récent gagne) ; elle ne permet donc **pas** de revenir
  en arrière après une erreur (ex. mauvais import CSV).
- **Distribution** : version figée à `1.0.0+1` (Android refuse une mise à jour sans numéro plus grand),
  Windows jamais compilé, pas de dossier `.github`.
- **Supabase gratuit** : projet mis en pause après une période d'inactivité (durée à vérifier dans la doc).

## Phases

### Phase 9 — Synchro fiable et journal d'erreurs ✅ (2026-11-14)
- **Pull avec chevauchement** : relire depuis `curseur − marge` (quelques secondes, constante documentée).
  Réappliquer une ligne déjà reçue ne change rien (`SyncCodec.apply`, plus récent gagne). Garder le curseur
  réel, n'appliquer la marge qu'à la requête ; éviter une boucle infinie quand une page entière tombe dans la
  marge (avancer sur `(server_updated_at, id)` si nécessaire).
- **Test** reproduisant le cas : `FakeSyncRemote` capable d'insérer une ligne « commitée en retard » avec un
  horodatage antérieur au curseur ; le test échoue avant le correctif, passe après.
- **Journal local** : `core/logging/` — anneau de N entrées (horodatage, niveau, source, message), persisté
  dans un fichier du dossier support, pas de dépendance si un fichier texte suffit. Remplace les `debugPrint`
  et enregistre toute exception attrapée (synchro, sources, fichiers, notifications, photos).
- **Messages lisibles** : traduire les exceptions connues (hors ligne, session expirée, quota, fichier
  illisible) en textes français ; le détail technique va au journal, pas dans le snackbar.
- **À propos → Journal** : écran listant les entrées, bouton « Copier » et « Partager » (pour me les envoyer).

Critère : deux appareils qui synchronisent en même temps finissent avec les mêmes données ; une erreur de
synchro sur le téléphone se retrouve, copiable, dans À propos → Journal.

### Phase 10 — Inscription et connexion par mot de passe
- **Écran d'inscription** dans l'appli (email, mot de passe, confirmation) : `signUp`. Règles de mot de
  passe = celles du projet Supabase (longueur minimale à lire dans le tableau de bord, ne pas l'inventer).
- **Connexion** email + mot de passe (`signInWithPassword`) ; lien « Créer un compte » depuis l'écran de
  connexion. Les inscriptions restent donc ouvertes côté Supabase.
- **Confirmation d'email** : activée par défaut chez Supabase, elle envoie un **lien** (même limite que
  la v1, pas de SMTP). Le lien s'ouvre dans le navigateur et valide le compte côté serveur ; l'appli affiche
  « Valide ton email puis connecte-toi ». Alternative : désactiver la confirmation dans le tableau de bord.
  Vérifier le comportement réel au moment de la phase (redirection après validation).
- Retirer le code à 6 chiffres et le lien collé (`email_sign_in.dart`), ainsi que l'entrée « Reporté » de
  `CLAUDE.md`. Les appareils déjà connectés gardent leur session.
- Mot de passe oublié : la réinitialisation Supabase passe aussi par un lien → hors appli dans un premier
  temps ; documenter la réinitialisation depuis le tableau de bord.
- Mot de passe jamais journalisé (phase 9) ni stocké : seule la session l'est, comme aujourd'hui.
- Tests : `FakeSyncAuth` étendu (inscription, email non confirmé, mauvais mot de passe, email déjà pris).

Critère : je crée mon compte depuis le téléphone, je valide l'email, puis je me connecte sur le téléphone
et le PC avec email + mot de passe.

### Phase 11 — Filets de sécurité
- **Annuler une suppression** : snackbar « Supprimé — Annuler » après suppression d'un ouvrage ou d'une série
  (série : restaure aussi les tomes supprimés avec elle). Restauration = `deleted_at` remis à null + bump
  `updated_at`, donc propagée par la synchro.
- **Sauvegardes automatiques locales** : JSON (format existant) une fois par semaine, et systématiquement
  avant un import CSV ou une restauration. Les N dernières sont gardées dans le dossier support.
  Paramètres → Sauvegarde : liste des sauvegardes automatiques (date, nombre d'ouvrages).
- **Restauration complète** (en plus de la fusion actuelle) : remettre la collection dans l'état de la
  sauvegarde — lignes absentes de la sauvegarde marquées supprimées, lignes présentes réécrites avec un
  `updated_at` actuel pour gagner à la synchro. Confirmation explicite (action destructrice, réversible
  uniquement via la sauvegarde automatique prise juste avant).

Critère : après un import CSV raté, je reviens à l'état d'avant en deux appuis, et l'autre appareil suit
après synchro.

### Phase 12 — CI, versions et distribution
- **GitHub Actions — vérification** (à chaque push) : `flutter analyze`, `flutter test`, compilation
  Linux et Android ; **compilation Windows** sur runner Windows (seule vérification possible sans PC Windows).
- **GitHub Actions — release** (sur tag `vX.Y.Z`) : version tirée du tag (`--build-name`, `--build-number`
  croissant), APK release par architecture signé (keystore en secret GitHub encodé base64), AppImage,
  installateur Inno Setup ; publication dans une Release GitHub. `env.json` reconstruit depuis les secrets
  GitHub, jamais versionné ni affiché dans les logs.
- **Dépôt public** : minutes GitHub Actions gratuites sur les runners standard (Windows compris) →
  vérification à chaque push. Les Releases sont publiques et téléchargeables sans authentification.
- **Clés dans les binaires publics** : les valeurs de `env.json` sont compilées dans les binaires et
  extractibles. Clé publishable Supabase : faite pour ça (RLS). **Google Books** : restreindre la clé dans
  la console Google (API Books seulement, quota) avant la première Release. **Comic Vine** : clé non
  restreignable → décider avant la première Release (accepter le risque, ou build public sans clé et build
  perso avec).
- **Versions** : `pubspec.yaml` garde une version de développement ; README : « créer une release =
  pousser un tag ».
- **Supabase en veille** : vérifier d'abord la politique actuelle de mise en pause du palier gratuit. Si elle
  s'applique, workflow planifié (cron) faisant une requête légère sur le projet. Dans l'appli, détecter un
  projet en pause et afficher un message clair (au lieu d'une erreur générique).
- **Nouvelle version disponible** : au démarrage, au plus une fois par jour, requête anonyme sur l'API
  GitHub (dernière Release du dépôt, sans jeton ; limite 60 req/h par IP, largement suffisant). Si la version
  est plus récente que celle installée (package_info_plus) : « Version X disponible » avec lien vers le
  fichier de la plateforme (APK selon l'architecture, AppImage, installateur). Désactivable dans
  Paramètres ; échec réseau silencieux (journalisé).

Critère : je pousse un tag, je récupère APK, AppImage et installateur Windows ; l'appli installée signale
la nouvelle version, et l'APK s'installe par-dessus la précédente sans perte de données.

### Phase 13 — Confort en magasin
- **Raccourci Android** « Scanner » (appui long sur l'icône) qui ouvre directement le mode Magasin
  (vérifier le package et sa compatibilité au moment de la phase, ex. `quick_actions`).
- **Retour haptique** différent selon le bandeau (possédé / envie / manquant / inconnu), pour connaître le
  résultat sans regarder l'écran ; désactivable dans Paramètres.
- **Lampe torche** dans l'écran de scan (`MobileScannerController.toggleTorch`).
- **Anti-doublon de lecture** : vérifier qu'un même code lu deux fois de suite n'est traité qu'une fois en
  mode Magasin comme en Rafale, l'ajouter sinon.

Critère : depuis l'écran d'accueil, un appui long → scan → vibration « déjà possédé » en moins de 3 s.

## Toujours hors périmètre

Ceux de `PLAN.md` (iOS/macOS, partage de collection, alertes de sortie des nouveaux tomes, scraping, cote
automatique). Les alertes de sortie restent exclues : aucune source fiable ne connaît les sorties françaises
à venir (BnF après parution, AniList = Japon).

## Décisions (utilisateur, 2026-11-14)

- Phase 10 : **écran d'inscription dans l'appli** (inscriptions ouvertes côté Supabase). Reste à trancher au
  début de la phase : confirmation d'email gardée (lien) ou désactivée.
- Phase 11 : sauvegarde automatique **hebdomadaire, 8 gardées** (plus celles prises avant import/restauration).
- Phase 12 : dépôt **public** → Releases GitHub publiques, vérification des nouvelles versions par l'API
  GitHub. **Signaler les nouvelles versions : oui.** Reste à trancher avant la première Release : clé Comic
  Vine dans le build public ou non (voir phase 12).
