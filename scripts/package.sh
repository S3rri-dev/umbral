#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."
if [ -n "$(git status --porcelain)" ]; then
    printf '%s\n' 'Confirma los cambios antes de empaquetar el código fuente.' >&2
    exit 1
fi

./scripts/package-dmg.sh
name="$(plutil -extract CFBundleName raw -o - Info.plist)"
version="$(plutil -extract CFBundleShortVersionString raw -o - Info.plist)"
bundle_id="$(plutil -extract CFBundleIdentifier raw -o - Info.plist)"
minimum="$(plutil -extract LSMinimumSystemVersion raw -o - Info.plist)"
commit="$(git rev-parse HEAD)"
app="$PWD/dist/$name.app"
./tests/run.sh "$app"

stage="$(mktemp -d "${TMPDIR:-/tmp}/umbral-release.XXXXXX")"
trap 'rm -rf "$stage"' EXIT
base="$name-$version"
dmg="$base-arm64.dmg"
app_zip="$base-arm64-app.zip"
src_zip="$base-src.zip"
manifest="$base-manifest.json"

cp "dist/$dmg" "$stage/$dmg"
ditto -c -k --keepParent "$app" "$stage/$app_zip"
git archive --format=zip --prefix="$base/" --output="$stage/$src_zip" "$commit"

python3 - "$stage" "$manifest" "$version" "$bundle_id" "$minimum" "$commit" "$dmg" "$app_zip" "$src_zip" <<'PY'
import hashlib
import json
from pathlib import Path
import sys

folder, manifest, version, bundle_id, minimum, commit, *filenames = sys.argv[1:]
folder = Path(folder)
files = []
for name in filenames:
    path = folder / name
    digest = hashlib.sha256(path.read_bytes()).hexdigest()
    files.append({"name": name, "bytes": path.stat().st_size, "sha256": digest})

release = {
    "version": version,
    "bundleIdentifier": bundle_id,
    "architecture": "arm64",
    "minimumMacOS": minimum,
    "sourceCommit": commit,
    "signature": "ad-hoc",
    "notarized": False,
    "assets": files,
}
(folder / manifest).write_text(json.dumps(release, indent=2) + "\n", encoding="utf-8")
PY

(
    cd "$stage"
    shasum -a 256 "$dmg" "$app_zip" "$src_zip" "$manifest" > SHA256SUMS.txt
    shasum -a 256 -c SHA256SUMS.txt
    unzip -tq "$app_zip"
    unzip -tq "$src_zip"
)
mv -f "$stage/$app_zip" "$stage/$src_zip" "$stage/$manifest" "$stage/SHA256SUMS.txt" dist/
