#!/bin/sh
# Single source of truth for app-slot shortcuts.
# skhd runs this for Hyper+N from either keyboard (home-row chord on the
# laptop, thumb key on the Voyager), so editing an app name here updates
# both at once.
#
# Hyper+0 is NOT handled here: it is "Switch to Desktop 1", bound natively in
# System Settings > Keyboard > Keyboard Shortcuts > Mission Control. It lives
# there because a synthetic `skhd -k` press would re-merge the still-held
# hyper modifiers (see skhdrc) and fire an app slot instead.
case "$1" in
  1) app="WezTerm" ;;
  2) app="Safari" ;;
  3) app="Preview" ;;
  4) app="Mail" ;;
  5) app="WhatsApp" ;;
  6) app="Calendar" ;;
  7) app="Spotify" ;;
  8) app="Dictionary" ;;
  *) exit 1 ;;
esac
exec open -a "$app"
