#!/usr/bin/env bash
# Sets pubspec.yaml's version from a release tag: v1.2.3 -> 1.2.3+10203.
# The build number (Android versionCode) must grow with every release:
# major*10000 + minor*100 + patch (minor and patch below 100).
# Usage: tool/ci/set_version.sh v1.2.3   (prints the version)
set -euo pipefail

TAG="${1:?tag like v1.2.3}"
if [[ ! "$TAG" =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
  echo "Invalid tag: $TAG (expected vX.Y.Z)" >&2
  exit 1
fi
MAJOR="${BASH_REMATCH[1]}" MINOR="${BASH_REMATCH[2]}" PATCH="${BASH_REMATCH[3]}"
if (( MINOR > 99 || PATCH > 99 )); then
  echo "Minor and patch must stay below 100" >&2
  exit 1
fi
VERSION="$MAJOR.$MINOR.$PATCH"
CODE=$(( MAJOR * 10000 + MINOR * 100 + PATCH ))
sed -i.bak "s/^version: .*/version: $VERSION+$CODE/" pubspec.yaml && rm pubspec.yaml.bak
echo "$VERSION"
