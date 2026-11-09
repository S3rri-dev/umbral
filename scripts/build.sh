#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."

./scripts/compile.sh
name="$(plutil -extract CFBundleName raw -o - Info.plist)"
executable="$(plutil -extract CFBundleExecutable raw -o - Info.plist)"
identifier="$(plutil -extract CFBundleIdentifier raw -o - Info.plist)"
helper="$identifier.fan-control"
adapter=libUmbralNowPlaying.dylib
stage="$(mktemp -d "${TMPDIR:-/tmp}/umbral-build.XXXXXX")"
trap 'rm -rf "$stage"' EXIT
app="$stage/$name.app"
contents="$app/Contents"
resources="$contents/Resources"
icons="$stage/AppIcon.iconset"

mkdir -p "$resources" "$contents/MacOS" "$contents/Frameworks" \
    "$contents/Library/LaunchServices" "$contents/Library/LaunchDaemons" "$icons"
sips -s format png Resources/AppIcon.svg --out "$stage/app-icon.png" >/dev/null
sips -s format png Resources/MenuMark.svg --out "$resources/BrandMark.png" >/dev/null
for size in 16 32 128 256 512; do
    sips -z "$size" "$size" "$stage/app-icon.png" --out "$icons/icon_${size}x${size}.png" >/dev/null
    sips -z "$((size * 2))" "$((size * 2))" "$stage/app-icon.png" --out "$icons/icon_${size}x${size}@2x.png" >/dev/null
done
iconutil -c icns "$icons" -o "$resources/AppIcon.icns"
swift scripts/render-menu.swift "$resources/BrandMark.png" "$resources"
install -m 644 Info.plist "$contents/Info.plist"
install -m 755 ".build/umbral/$executable" "$contents/MacOS/$executable"
install -m 755 ".build/umbral/$adapter" "$contents/Frameworks/$adapter"
install -m 755 ".build/umbral/$helper" "$contents/Library/LaunchServices/$helper"
install -m 644 "Resources/$helper.plist" "$contents/Library/LaunchDaemons/$helper.plist"
install -m 644 Resources/now-playing.pl Resources/agent-prices.json Resources/CatMeow.wav LICENSE THIRD_PARTY_NOTICES.md CHANGELOG.md "$resources"
for localization in Resources/*.lproj; do
    ditto "$localization" "$resources/$(basename "$localization")"
done

for binary in "$contents/MacOS/$executable" "$contents/Frameworks/$adapter" "$contents/Library/LaunchServices/$helper"; do
    strip -S "$binary"
done
xattr -cr "$app" 2>/dev/null || true
codesign --force --sign - --identifier "$identifier.now-playing" "$contents/Frameworks/$adapter"
codesign --force --sign - --identifier "$helper" "$contents/Library/LaunchServices/$helper"
codesign --force --sign - "$app"
codesign --verify --deep --strict "$app"
mkdir -p dist
ditto --noextattr --noqtn "$app" "dist/$name.app"
printf '%s\n' "$PWD/dist/$name.app"
