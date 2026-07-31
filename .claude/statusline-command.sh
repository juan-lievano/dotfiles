#!/bin/sh
# Claude Code status line: 5-hour session usage + time until reset
input=$(cat)

pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
resets_at=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
transcript=$(echo "$input" | jq -r '.transcript_path // empty')

if [ -z "$pct" ] && [ -z "$resets_at" ]; then
  exit 0
fi

# Format consumed percentage, with age of the data (transcript mtime ~= last API response)
consumed=""
if [ -n "$pct" ]; then
  consumed=$(printf "%.0f%% used" "$pct")
  if [ -n "$transcript" ] && [ -f "$transcript" ]; then
    mtime=$(stat -f %m "$transcript" 2>/dev/null)
    if [ -n "$mtime" ]; then
      age=$(( $(date +%s) - mtime ))
      if [ "$age" -lt 60 ]; then
        consumed="$consumed (updated just now)"
      elif [ "$age" -lt 3600 ]; then
        consumed="$consumed (updated $(( age / 60 ))m ago)"
      else
        consumed="$consumed (updated $(( age / 3600 ))h $(( (age % 3600) / 60 ))m ago)"
      fi
    fi
  fi
fi

# Format time remaining
remaining=""
if [ -n "$resets_at" ]; then
  now=$(date +%s)
  secs=$(( resets_at - now ))
  if [ "$secs" -gt 0 ]; then
    hrs=$(( secs / 3600 ))
    mins=$(( (secs % 3600) / 60 ))
    if [ "$hrs" -gt 0 ]; then
      remaining=$(printf "%dh %02dm left" "$hrs" "$mins")
    else
      remaining=$(printf "%dm left" "$mins")
    fi
  else
    remaining="resetting soon"
  fi
fi

# Combine
if [ -n "$consumed" ] && [ -n "$remaining" ]; then
  printf "%s | %s" "$consumed" "$remaining"
elif [ -n "$consumed" ]; then
  printf "%s" "$consumed"
elif [ -n "$remaining" ]; then
  printf "%s" "$remaining"
fi
