#!/bin/sh
# Ring the terminal bell in the WezTerm pane this Claude Code session lives in.
# Fired by the Stop hook in .claude/settings.json the moment a turn finishes —
# Claude Code's built-in channels have no turn-end event, only a 60s idle
# reminder, which always arrived stale. The bell itself is silent; wezterm.lua
# turns it into a macOS banner only when this pane isn't the one being looked at.
#
# Hooks don't get a tty of their own, so resolve this pane's tty through
# wezterm's CLI ($WEZTERM_PANE is exported into every pane and inherited here).
if [ -n "$WEZTERM_PANE" ]; then
  tty=$(wezterm cli list --format json 2>/dev/null |
    jq -r --arg p "$WEZTERM_PANE" '.[] | select(.pane_id == ($p | tonumber)) | .tty_name')
  if [ -n "$tty" ] && [ -w "$tty" ]; then
    printf '\a' > "$tty"
    exit 0
  fi
fi
# Not in WezTerm (or lookup failed): try the controlling terminal, else give up quietly.
printf '\a' > /dev/tty 2>/dev/null || true
