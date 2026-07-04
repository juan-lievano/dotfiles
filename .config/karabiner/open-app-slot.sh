#!/bin/sh
# Single source of truth for app-slot shortcuts.
# Karabiner runs this for both Space+N (built-in keyboard) and Hyper+N (Voyager),
# so editing an app name here updates both shortcuts at once.
case "$1" in
  1) app="WezTerm" ;;
  2) app="Safari" ;;
  3) app="Preview" ;;
  4) app="Mail" ;;
  5) app="WhatsApp" ;;
  6) app="Visual Studio Code" ;;
  7) app="Dictionary" ;;
  *) exit 1 ;;
esac
exec open -a "$app"
