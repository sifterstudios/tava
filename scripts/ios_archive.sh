#!/usr/bin/env bash
set -euo pipefail

# Build a signed IPA for TestFlight (requires Xcode + Apple ID auth in Xcode).
# Homebrew rsync breaks Xcode's IPA export (-E / --extended-attributes), so keep
# /usr/bin ahead of Homebrew for the xcodebuild export phase Flutter invokes.
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:${PATH}"

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

FLAVOR="${1:-production}"
TARGET="lib/main_${FLAVOR}.dart"

DEFINES_FILE="${DART_DEFINES_FILE:-$ROOT/dart_defines.json}"
if [[ ! -f "$DEFINES_FILE" ]]; then
  echo "Missing $DEFINES_FILE — copy dart_defines.example.json and set SUPABASE_ANON_KEY." >&2
  exit 1
fi

echo "Building $FLAVOR → $TARGET (defines: $DEFINES_FILE)"
flutter pub get
flutter build ipa \
  --flavor "$FLAVOR" \
  --target "$TARGET" \
  --dart-define-from-file="$DEFINES_FILE" \
  --export-options-plist=ios/ExportOptions.plist

echo "IPA ready under build/ios/ipa/"
echo "Upload with Transporter or: xcrun altool --upload-app -f build/ios/ipa/*.ipa -t ios --api-key <KEY> --api-issuer <ISSUER>"