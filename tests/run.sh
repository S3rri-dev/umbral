#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."
if [ "$#" -eq 0 ]; then
    ./scripts/build.sh
fi

app="${1:-dist/Umbral.app}"
info="$app/Contents/Info.plist"
resources="$app/Contents/Resources"
executable="$(plutil -extract CFBundleExecutable raw -o - "$info")"
binary="$app/Contents/MacOS/$executable"

plutil -lint "$info"
for key in CFBundleName CFBundleIdentifier CFBundleShortVersionString CFBundleVersion LSMinimumSystemVersion; do
    test "$(plutil -extract "$key" raw -o - "$info")" = "$(plutil -extract "$key" raw -o - Info.plist)"
done
test "$(lipo -archs "$binary")" = arm64
minimum="$(plutil -extract LSMinimumSystemVersion raw -o - "$info")"
test "$(xcrun vtool -show-build "$binary" | awk '/minos/{print $2}')" = "$minimum"
test -s "$resources/AppIcon.icns"
test -s "$resources/BrandMark.png"
test -s "$resources/MenuBarIcon.png"
test -s "$resources/MenuBarIcon@2x.png"
test -s "$resources/LICENSE"
test -s "$resources/THIRD_PARTY_NOTICES.md"
test -s "$app/Contents/Frameworks/libUmbralNowPlaying.dylib"
helper="$(plutil -extract CFBundleIdentifier raw -o - "$info").fan-control"
test -x "$app/Contents/Library/LaunchServices/$helper"
plutil -lint "$app/Contents/Library/LaunchDaemons/$helper.plist"
codesign --verify --deep --strict "$app"
if nm -pa "$binary" | grep -E '/Users/|/private/var/folders/' >/dev/null; then
    printf '%s\n' 'El ejecutable contiene rutas locales en sus símbolos.' >&2
    exit 1
fi

python3 - <<'PY'
from xml.etree import ElementTree as ET

ns = {"svg": "http://www.w3.org/2000/svg"}
app = ET.parse("Resources/AppIcon.svg").getroot()
menu = ET.parse("Resources/MenuMark.svg").getroot()

for tag, keys in [("path", ["d"]), ("rect", ["x", "y", "width", "height", "rx"])]:
    app_piece = app.findall("svg:" + tag, ns)[-1]
    menu_piece = menu.find("svg:" + tag, ns)
    assert all(app_piece.get(key) == menu_piece.get(key) for key in keys), tag

print("Los dos contornos de Fuga coinciden en la app y la barra de menús.")
PY
if [ "$(uname -m)" = arm64 ]; then
    "$binary" --selftest
    "$app/Contents/Library/LaunchServices/$helper" --selftest
fi
printf 'Bundle ARM64, recursos y firma local verificados.\n'
