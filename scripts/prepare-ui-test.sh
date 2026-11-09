#!/bin/bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
    printf 'Uso: %s ruta/a/Umbral.app\n' "$0" >&2
    exit 2
fi

app="$1"
repo="$(cd "$(dirname "$0")/.." && pwd)"
identifier="$(plutil -extract CFBundleIdentifier raw -o - "$repo/Info.plist")"
source_identifier="$(plutil -extract CFBundleIdentifier raw -o - "$app/Contents/Info.plist")"
if [ "$source_identifier" != "$identifier" ]; then
    printf 'Se esperaba un bundle de Umbral con identificador %s.\n' "$identifier" >&2
    exit 1
fi
codesign --verify --deep --strict "$app"

qa_dir="$(mktemp -d "${TMPDIR:-/tmp}/umbral-qa.XXXXXX")"
keep_copy=false
trap 'if ! "$keep_copy"; then rm -rf "$qa_dir"; fi' EXIT
qa_app="$qa_dir/Umbral QA.app"
qa_identifier="$identifier.qa.$(uuidgen | tr '[:upper:]' '[:lower:]')"
ditto --noextattr --noqtn "$app" "$qa_app"
plutil -replace CFBundleIdentifier -string "$qa_identifier" "$qa_app/Contents/Info.plist"
plutil -replace CFBundleDisplayName -string 'Umbral QA' "$qa_app/Contents/Info.plist"
codesign --force --sign - "$qa_app"
codesign --verify --deep --strict "$qa_app"
keep_copy=true
printf '%s\n' "$qa_app"
