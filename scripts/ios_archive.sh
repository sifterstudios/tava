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

echo "Building $FLAVOR → $TARGET"
flutter pub get
flutter build ipa \
  --flavor "$FLAVOR" \
  --target "$TARGET" \
  --export-options-plist=ios/ExportOptions.plist

echo "IPA ready under build/ios/ipa/"
echo "Upload with Transporter or: xcrun altool --upload-app -f build/ios/ipa/*.ipa -t ios --api-key <KEY> --api-issuer <ISSUER>"