#!/bin/zsh
set -euo pipefail
cd "$(dirname "$0")/.."

sdk="$(xcrun --show-sdk-path)"
compat=()
pinned_sdk=/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk
if [[ -z "${DEVELOPER_DIR:-}" && -d "$pinned_sdk" ]]; then
    sdk="$pinned_sdk"
    compat=(-Xfrontend -interface-compiler-version -Xfrontend 6.3.2)
fi
minimum="$(plutil -extract LSMinimumSystemVersion raw -o - Info.plist)"
target="arm64-apple-macosx$minimum"
jobs="$(sysctl -n hw.logicalcpu)"
objects="$PWD/.build/umbral/objects"
sources=(Sources/Umbral/**/*.swift)
mkdir -p "$objects"
python3 - "$objects" "${sources[@]}" <<'PYMAP'
import json
import sys
from pathlib import Path

objects = Path(sys.argv[1])
entries = {"": {"swift-dependencies": str(objects / "master.swiftdeps")}}
for source in sys.argv[2:]:
    base = source.removesuffix(".swift").replace("/", "__")
    entries[source] = {
        "object": str(objects / (base + ".o")),
        "swift-dependencies": str(objects / (base + ".swiftdeps")),
    }
(objects / "output-file-map.json").write_text(json.dumps(entries))
PYMAP

swiftc -O -incremental -enable-batch-mode -j "$jobs" -module-name Umbral \
    -output-file-map "$objects/output-file-map.json" -target "$target" -sdk "$sdk" \
    "${compat[@]}" -I Sources/VMStatisticsCompat -I Sources/HIDEventSystem \
    "${sources[@]}" -o .build/umbral/Umbral

swiftc -O -target "$target" -sdk "$sdk" "${compat[@]}" -emit-library \
    -module-name UmbralNowPlaying \
    Sources/NowPlayingAdapter/*.swift \
    Sources/Umbral/Services/Notch/NotchPlaybackSource.swift \
    Sources/Umbral/Services/Notch/NotchPlaybackCommand.swift \
    -o .build/umbral/libUmbralNowPlaying.dylib

swiftc -O -target "$target" -sdk "$sdk" "${compat[@]}" \
    Sources/Umbral/Services/FanControl/FanControlSupport.swift \
    Sources/Umbral/Services/FanControl/FanControlXPC.swift \
    Sources/Umbral/Services/SystemMonitor/SMCClient.swift \
    Sources/Umbral/Services/Metrics/TemperatureSensorSelector.swift \
    Sources/Umbral/Services/FanControl/FanControlHardware.swift \
    Sources/FanControlHelper/main.swift \
    -o .build/umbral/io.github.s3rri-dev.umbral.fan-control
