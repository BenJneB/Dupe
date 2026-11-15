#!/usr/bin/env bash
# Builds build/Dupe-<version>-x86_64.AppImage from the Linux release bundle.
# Usage (project root): packaging/linux/build_appimage.sh [env.json]
# appimagetool is downloaded once into build/tools/ (pinned release).
set -euo pipefail

ENV_FILE="${1:-env.json}"
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
VERSION="$(sed -n 's/^version: \([0-9.]*\).*/\1/p' "$ROOT/pubspec.yaml")"
APPDIR="$ROOT/build/appimage/Dupe.AppDir"
TOOL_DIR="$ROOT/build/tools"
TOOL="$TOOL_DIR/appimagetool-x86_64.AppImage"
TOOL_URL="https://github.com/AppImage/appimagetool/releases/download/1.9.1/appimagetool-x86_64.AppImage"

cd "$ROOT"
flutter build linux --release --dart-define-from-file="$ENV_FILE"

# Fresh AppDir: bundle in usr/bin, desktop entry and icon at the root.
rm -rf "$ROOT/build/appimage"
mkdir -p "$APPDIR/usr/bin"
cp -r build/linux/x64/release/bundle/. "$APPDIR/usr/bin/"
cp packaging/linux/dupe.desktop "$APPDIR/dupe.desktop"
cp assets/icon/dupe_icon.png "$APPDIR/dupe.png"
cat > "$APPDIR/AppRun" <<'RUN'
#!/bin/sh
HERE="$(dirname "$(readlink -f "$0")")"
exec "$HERE/usr/bin/dupe" "$@"
RUN
chmod +x "$APPDIR/AppRun"

if [ ! -x "$TOOL" ]; then
  mkdir -p "$TOOL_DIR"
  curl -fL -o "$TOOL" "$TOOL_URL"
  chmod +x "$TOOL"
fi
# --appimage-extract-and-run: works without FUSE.
ARCH=x86_64 "$TOOL" --appimage-extract-and-run "$APPDIR" "build/Dupe-$VERSION-x86_64.AppImage"
echo "build/Dupe-$VERSION-x86_64.AppImage"
