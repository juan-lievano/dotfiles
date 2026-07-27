#!/usr/bin/env bash
# Install kanata + its driver daemon as boot services. Run once, with sudo:
#
#     sudo ~/.config/kanata/install-services.sh
#
# Safe to re-run (idempotent). To undo everything:
#
#     sudo ~/.config/kanata/install-services.sh --uninstall
#
# kanata on macOS needs three layers. This installs the two that don't
# start themselves:
#   1. dext (kernel driver)  - from the karabiner-elements cask, already loaded
#   2. VirtualHIDDevice daemon - normally started by Karabiner-Elements; without
#      it kanata dies with `connect_failed asio.system:61`
#   3. kanata - via `brew services`, which already knows the right --cfg path
set -euo pipefail

LABEL="org.pqrs.karabiner-vhid-daemon"
PLIST_SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$LABEL.plist"
PLIST_DST="/Library/LaunchDaemons/$LABEL.plist"

[ "$(id -u)" -eq 0 ] || { echo "must run with sudo" >&2; exit 1; }

if [ "${1:-}" = "--uninstall" ]; then
  echo "==> stopping kanata"
  brew services stop kanata 2>/dev/null || true
  echo "==> removing $LABEL"
  launchctl bootout "system/$LABEL" 2>/dev/null || true
  rm -f "$PLIST_DST"
  echo "done. Relaunch Karabiner-Elements to go back to the old setup."
  exit 0
fi

echo "==> installing $LABEL"
cp "$PLIST_SRC" "$PLIST_DST"
chown root:wheel "$PLIST_DST"
chmod 644 "$PLIST_DST"
# bootout first so re-running picks up plist edits
launchctl bootout "system/$LABEL" 2>/dev/null || true
launchctl bootstrap system "$PLIST_DST"

echo "==> waiting for the daemon"
for _ in $(seq 1 10); do
  pgrep -f "VirtualHIDDevice-Daemon" >/dev/null && break
  sleep 0.5
done
pgrep -f "VirtualHIDDevice-Daemon" >/dev/null \
  && echo "    daemon running" \
  || { echo "    daemon NOT running — check /var/log/karabiner-vhid-daemon.log" >&2; exit 1; }

# kanata and skhd are ad-hoc signed bare binaries living at versioned Cellar
# paths, so macOS TCC identifies them by path + content hash. ANY upgrade
# silently revokes their Input Monitoring / Accessibility grants and the
# remapping just stops working. Pin them so a blanket `brew upgrade` can't do
# that behind your back; upgrade deliberately, then re-grant.
echo "==> pinning kanata + skhd (upgrades silently revoke TCC grants)"
sudo -u "${SUDO_USER:-$(logname)}" brew pin kanata skhd 2>/dev/null || true

echo "==> starting kanata"
# `start` fails with "Bootstrap failed: 5" if the service is already loaded,
# so use restart, which handles both the first run and re-runs.
brew services restart kanata

echo
echo "done. Verify with:"
echo "    sudo launchctl list | grep -E 'kanata|vhid'"
echo "    tail -f /opt/homebrew/var/log/kanata.log"
echo
echo "To stop kanata later:  sudo brew services stop kanata"
echo "Panic exit any time:   lctl+spc+esc  (physical keys, pre-remap)"
