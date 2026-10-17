#!/bin/sh
# Look the selection up in Dictionary.app, then bring Dictionary forward.
# Run by sioyek's `_dict` (new_command in prefs_user.config, key sd). A plain
# `open dict://word` launches Dictionary but, with sioyek fullscreen in its own
# Space, macOS does not switch to it; the AppleScript `activate` is the one
# call that does (same trick as open-in-sioyek/main.swift). Sioyek passes the
# selection as one argument; spaces must be %20 in the URL.
word=$(printf '%s' "$*" | sed 's/ /%20/g')
[ -n "$word" ] || exit 0
open "dict://$word"
osascript -e 'tell application "Dictionary" to activate'
