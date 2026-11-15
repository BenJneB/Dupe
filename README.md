# Dupe

Application personnelle pour cataloguer une collection de mangas, BD, comics et livres
(Android, Windows, Linux). Spécification : [PLAN.md](PLAN.md).

## Prérequis
- Flutter stable ≥ 3.50 (`flutter doctor` sans erreur)
- Android : SDK Android + téléphone avec le débogage USB activé
- Linux : toolchain desktop Linux (clang, cmake, ninja, GTK 3)
- Windows : Visual Studio avec la charge « Développement Desktop en C++ » (compilation sur Windows uniquement)

## Configuration
Les secrets ne sont jamais dans le code : ils sont injectés à la compilation depuis `env.json`
(ignoré par git).

```sh
cp env.example.json env.json   # puis remplir les vraies valeurs
```

| Clé | Usage | Obligatoire |
|---|---|---|
| `SUPABASE_URL`, `SUPABASE_ANON_KEY` | Synchronisation cloud (phase 7) | non (mode local seul sinon) |
| `COMIC_VINE_API_KEY` | Métadonnées comics (phase 3) | non |
| `OPEN_LIBRARY_CONTACT` | Email envoyé à Open Library dans le User-Agent (limite 3 req/s au lieu de 1) | non |
| `GOOGLE_BOOKS_API_KEY` | Google Books (couvertures, résumés). Sans clé la source est désactivée : le quota anonyme est épuisé (HTTP 429) | recommandée |

## Développement
```sh
flutter pub get
dart run build_runner build -d   # après modification d'un fichier @riverpod / freezed
flutter gen-l10n                 # après modification de lib/l10n/app_fr.arb
flutter analyze
flutter test
```

## Lancer l'application
```sh
# Android (téléphone branché en USB, débogage activé)
flutter devices
flutter run -d <id-du-téléphone> --dart-define-from-file=env.json

# Linux
flutter run -d linux --dart-define-from-file=env.json

# Windows (sur une machine Windows)
flutter run -d windows --dart-define-from-file=env.json
```

## Compiler
```sh
flutter build apk --release --dart-define-from-file=env.json      # build/app/outputs/flutter-apk/
flutter build linux --release --dart-define-from-file=env.json    # build/linux/x64/release/bundle/
flutter build windows --release --dart-define-from-file=env.json  # sur Windows
```

## Note Linux (GNOME récent / Ubuntu 26.04)
GTK 3 en Wayland plante au démarrage car la clé GNOME `xsettings antialiasing` a disparu.
`linux/runner/main.cc` le détecte et bascule alors automatiquement sur X11 (XWayland).
Pour forcer un backend : `GDK_BACKEND=wayland` ou `GDK_BACKEND=x11`.
