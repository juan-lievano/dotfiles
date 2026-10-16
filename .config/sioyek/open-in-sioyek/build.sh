#!/bin/sh
# Builds "~/Applications/Open in sioyek.app" from main.swift + Info.plist and
# makes it the default PDF handler. Needs the Xcode command line tools
# (swiftc) and /Applications/sioyek.app. Safe to re-run. See main.swift.
set -eu
here=$(cd "$(dirname "$0")" && pwd)
app="$HOME/Applications/Open in sioyek.app"

pkill -x open-in-sioyek 2>/dev/null || true   # the resident copy runs the old binary
mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources"
swiftc -O -o "$app/Contents/MacOS/open-in-sioyek" "$here/main.swift"
cp "$here/Info.plist" "$app/Contents/Info.plist"
# Borrow sioyek's icon (it ships a .ico; sips converts it). Not fatal if missing.
sips -s format icns /Applications/sioyek.app/Contents/Resources/icon2.ico \
     --out "$app/Contents/Resources/icon.icns" >/dev/null 2>&1 || true
codesign -s - -f "$app" 2>/dev/null
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$app"
"$app/Contents/MacOS/open-in-sioyek" --set-default
