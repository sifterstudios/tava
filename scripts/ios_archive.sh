#!/usr/bin/env bash
set -euo pipefail

# Build a signed IPA for TestFlight (requires Xcode + Apple ID auth in Xcode).
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

FLAVOR="${1:-production}"
TARGET="lib/main_${FLAVOR}.dart"
SCHEME="$FLAVOR"

echo "Building $FLAVOR → $TARGET"
flutter pub get
flutter build ipa \
  --flavor "$FLAVOR" \
  --target "$TARGET" \
  --export-options-plist=ios/ExportOptions.plist

echo "IPA ready under build/ios/ipa/"
echo "Upload with Transporter or: xcrun altool --upload-app ..."
