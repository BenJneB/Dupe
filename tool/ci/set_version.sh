#!/usr/bin/env bash
# Sets pubspec.yaml's version from a release tag and prints the release
# version (used in file names):
#   v1.2.3      -> pubspec 1.2.3+10203, prints 1.2.3
#   v1.2.3-test -> pubspec 1.2.3+10203, prints 1.2.3-test (pre-release)
# The build number (Android versionCode) must grow with every release:
# major*10000 + minor*100 + patch (minor and patch below 100). A suffix does
# not change it, and is kept out of pubspec (some platform builds only accept
# X.Y.Z): the app of a test release shows X.Y.Z in About.
# Usage: tool/ci/set_version.sh v1.2.3
set -euo pipefail

TAG="${1:?tag like v1.2.3 or v1.2.3-test}"
if [[ ! "$TAG" =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+)(-[0-9A-Za-z.-]+)?$ ]]; then
  echo "Invalid tag: $TAG (expected vX.Y.Z or vX.Y.Z-suffix)" >&2
  exit 1
fi
MAJOR="${BASH_REMATCH[1]}" MINOR="${BASH_REMATCH[2]}" PATCH="${BASH_REMATCH[3]}"
SUFFIX="${BASH_REMATCH[4]}"
if (( MINOR > 99 || PATCH > 99 )); then
  echo "Minor and patch must stay below 100" >&2
  exit 1
fi
VERSION="$MAJOR.$MINOR.$PATCH"
CODE=$(( MAJOR * 10000 + MINOR * 100 + PATCH ))
sed -i.bak "s/^version: .*/version: $VERSION+$CODE/" pubspec.yaml && rm pubspec.yaml.bak
echo "$VERSION$SUFFIX"
