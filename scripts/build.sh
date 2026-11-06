#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."
swift build --configuration release
bin_dir="$(swift build --configuration release --show-bin-path)"
app_name="$(plutil -extract CFBundleName raw -o - Info.plist)"
app_dir="$PWD/dist/$app_name.app"
resources="$app_dir/Contents/Resources"
icon_dir="$(mktemp -d "${TMPDIR:-/tmp}/umbral-icon.XXXXXX")"
trap 'rm -rf "$icon_dir"' EXIT

mkdir -p "$app_dir/Contents/MacOS" "$resources" "$icon_dir/AppIcon.iconset"
sips -s format png Resources/AppIcon.svg --out "$resources/BrandMark.png" >/dev/null
sips -s format png Resources/MenuMark.svg --out "$resources/MenuMark.png" >/dev/null
for size in 16 32 128 256 512; do
    sips -Z "$size" "$resources/BrandMark.png" --out "$icon_dir/AppIcon.iconset/icon_${size}x${size}.png" >/dev/null
    sips -Z "$((size * 2))" "$resources/BrandMark.png" --out "$icon_dir/AppIcon.iconset/icon_${size}x${size}@2x.png" >/dev/null
done
iconutil -c icns "$icon_dir/AppIcon.iconset" -o "$resources/AppIcon.icns"
install -m 755 "$bin_dir/MacUtilities" "$app_dir/Contents/MacOS/MacUtilities"
install -m 644 Info.plist "$app_dir/Contents/Info.plist"
codesign --force --sign - "$app_dir"
codesign --verify --strict "$app_dir"
printf '%s\n' "$app_dir"
