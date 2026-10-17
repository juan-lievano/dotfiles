#!/bin/sh
# Right side of the tmux status bar: "mem 35% cpu 24%", both "how much is in
# use", refreshed every status-interval. Native probes, ~1.3 s, nothing
# resident.
#
# mem is 100 minus Apple's "System-wide memory free percentage" (free +
# reclaimable cache), so above ~80% is when to quit something. Its colour is
# Activity Monitor's Memory Pressure light, straight from the kernel: 1 normal,
# 2 warning (yellow), 4 critical (red). cpu is 100 minus top's idle figure,
# over all cores: one process pegging one core shows as ~8% on 12 cores.
#
# Runaway check, one rule: name the process that used the most CPU over the
# last hour, if that was more than 15 minutes' worth. "Python 58m" means
# 58 CPU-minutes in the last hour. Each run appends one line per process
# (run number, pid, CPU seconds, name) to a cache file and keeps the last 60
# runs; the hour is 60 samples, not 60 wall-clock minutes, so sleep doesn't
# count. A fresh process is measured from its first sample, so a hot one
# shows up as soon as it has burned 15 minutes, not after an hour.
mem=$(memory_pressure | awk '/free percentage/ {printf "%d%%", 100 - $NF}')
case $(sysctl -n kern.memorystatus_vm_pressure_level) in
  1) memcol=colour8 ;;   # normal: dim like the window list
  2) memcol=colour3 ;;   # warning: yellow
  *) memcol=colour1 ;;   # critical: red
esac
# Two samples a second apart: top's first sample is an average since its
# counters were last read, not a current reading (it showed 33% vs a real 17%).
cpu=$(top -l 2 -n 0 -s 1 | awk '/CPU usage/ {v = 100 - $7} END {printf "%d%%", v}')
hist=${XDG_CACHE_HOME:-$HOME/.cache}/tmux-sysload-hist
mkdir -p "${hist%/*}"
# cputime on macOS is MM:SS.ss (minutes keep counting past 60); keyed on
# pid+name so a reused pid doesn't inherit the old process's total.
hot=$(ps -U "$USER" -o pid=,cputime=,comm= | awk -v hist="$hist" -v limit=15 '
  BEGIN {
    while ((getline line < hist) > 0) { old[++n] = line; split(line, f, " "); if (f[1] > run) run = f[1] }
    close(hist); run++
    for (i = 1; i <= n; i++) {                       # oldest reading per pid+name inside the window
      split(old[i], f, " "); k = f[2] SUBSEP f[4]
      if (f[1] > run - 60 && (!(k in first) || f[1] < firstrun[k])) { first[k] = f[3]; firstrun[k] = f[1] }
    }
  }
  {
    sub(/.*\//, "", $3); split($2, t, ":"); now = t[1]*60 + t[2]
    print run, $1, now, $3 > (hist ".new")
    if (($1, $3) in first) { d = now - first[$1, $3]; if (d > best) { best = d; who = $3 } }
  }
  END {
    for (i = 1; i <= n; i++) { split(old[i], f, " "); if (f[1] > run - 60) print old[i] > (hist ".new") }
    if (best > limit * 60) printf " %s %dm", who, best / 60
  }')
mv -f "$hist.new" "$hist"
printf '#[fg=%s]mem %s #[fg=colour8]cpu %s%s' "$memcol" "$mem" "$cpu" "$hot"
