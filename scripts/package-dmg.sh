#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."
./scripts/build.sh
app_name="$(plutil -extract CFBundleName raw -o - Info.plist)"
version="$(plutil -extract CFBundleShortVersionString raw -o - Info.plist)"
arch="$(lipo -archs "dist/$app_name.app/Contents/MacOS/$(plutil -extract CFBundleExecutable raw -o - Info.plist)")"
test "$arch" = arm64
stage="$(mktemp -d "${TMPDIR:-/tmp}/umbral-dmg.XXXXXX")"
trap 'rm -rf "$stage"' EXIT

mkdir "$stage/volume"
ditto "dist/$app_name.app" "$stage/volume/$app_name.app"
ln -s /Applications "$stage/volume/Applications"
hdiutil create -srcfolder "$stage/volume" -volname "$app_name" \
    -format UDZO "$stage/umbral.dmg"
hdiutil verify "$stage/umbral.dmg"

output="$PWD/dist/$app_name-$version-$arch.dmg"
mv -f "$stage/umbral.dmg" "$output"
printf '%s\n' "$output"
