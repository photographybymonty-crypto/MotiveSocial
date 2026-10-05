#!/bin/bash
set -euo pipefail

APP_NAME="Motive Social"
BUNDLE="dist/$APP_NAME.app"
MACOS="$BUNDLE/Contents/MacOS"
RES="$BUNDLE/Contents/Resources"
BIN="$MACOS/$APP_NAME"

rm -rf dist
mkdir -p "$MACOS" "$RES"

SDK="$(xcrun --sdk macosx --show-sdk-path)"

swiftc Sources/*.swift \
  -sdk "$SDK" \
  -target x86_64-apple-macos13.0 \
  -O \
  -framework SwiftUI \
  -framework AppKit \
  -o "$BIN"

cat > "$BUNDLE/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleName</key>
  <string>Motive Social</string>
  <key>CFBundleDisplayName</key>
  <string>Motive Social</string>
  <key>CFBundleIdentifier</key>
  <string>com.motivegreen.motivesocial</string>
  <key>CFBundleExecutable</key>
  <string>Motive Social</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleShortVersionString</key>
  <string>0.1</string>
  <key>CFBundleVersion</key>
  <string>1</string>
  <key>LSMinimumSystemVersion</key>
  <string>13.0</string>
  <key>NSHighResolutionCapable</key>
  <true/>
</dict>
</plist>
PLIST

chmod +x "$BIN"
codesign --force --deep --sign - "$BUNDLE"
codesign --verify --deep --strict "$BUNDLE"
file "$BIN"
ditto -c -k --sequesterRsrc --keepParent "$BUNDLE" "dist/Motive-Social-macOS.zip"

echo "SUCCESS"
