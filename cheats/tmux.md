# tmux

A session is a group of tabs for one project; a window is a tab in it.
Every tmux command is two steps: press the prefix (Ctrl-A), let go, press a key.
For the common letters, keeping Ctrl held works too: Ctrl-A Ctrl-C = Ctrl-A c.

## Tabs without the prefix (Ghostty sends tmux a private code)

The rule: a key skips the prefix only if programs never see it. Cmd and
Ctrl-Tab never reach the shell or nvim, so tmux can have them for free.
Ctrl-letters (Ctrl-T, Ctrl-N, Ctrl-W…) do reach them, so those stay behind Ctrl-A.

| Key                            | Does                 |
|--------------------------------|----------------------|
| `Cmd-T`                        | new window (tab)     |
| `Cmd-W`                        | close window (asks if busy) |
| `Ctrl-Tab` / `Cmd-Shift-]`     | next window          |
| `Ctrl-Shift-Tab` / `Cmd-Shift-[` | previous window    |
| `Cmd-1`-`Cmd-9`                | go to window N       |

## From the shell

| Command                        | Does                                                        |
|--------------------------------|-------------------------------------------------------------|
| `t`                            | list sessions                                               |
| `t NAME [DIR]`                 | attach to NAME, creating it if needed; switch if in tmux    |
| `tmux kill-session -t NAME`    | close a session and everything running in it                |
| `cheat tmux`                   | this sheet (`cheat` alone lists all sheets)                 |

## Windows and sessions (Ctrl-A, then…)

| Key     | Does                                           |
|---------|------------------------------------------------|
| `t`     | new window (tab)                               |
| `n`     | new session: `:new -A -s ` typed, add a name   |
| `1`-`9` | go to window N                                 |
| `Tab`   | next window                                    |
| `Shift-Tab` | previous window                            |
| `f`     | fuzzy-find any window in any session           |
| `w`     | tree view of all sessions and windows          |
| `,`     | rename window                                  |
| `$`     | rename session                                 |
| `&`     | close window (asks)                            |
| `d`     | detach: leave it all running, back to Ghostty  |

## Panes (Ctrl-A, then…)

| Key      | Does                                          |
|----------|-----------------------------------------------|
| `v`      | split side by side (like nvim Ctrl-W v)       |
| `s`      | split top / bottom (like nvim Ctrl-W s)       |
| arrows   | move between panes                            |
| `z`      | zoom pane to full size (again to undo)        |
| `x`      | close pane (asks)                             |

## Other (Ctrl-A, then…)

| Key      | Does                                          |
|----------|-----------------------------------------------|
| `[`      | scroll / copy mode, `q` quits                 |
| `o`      | one-command shell popup (`open x.pdf`); closes on success, `&` for GUI apps |
| `?`      | this sheet                                    |
| `:`      | type a tmux command (`:list-keys` shows all)  |
| `r`      | reload tmux.conf                              |
| `Ctrl-A` | send a literal Ctrl-A                         |

## Status bar, right side

`mem 34%` is how much memory is in use (yellow/red = Apple's memory-pressure
light). `cpu 9%` is the whole machine, so one process pegging one core shows
as ~8%. A third item names a process that used more than 15 minutes of CPU
in the last hour (`Python 58m` = 58 CPU-minutes). It's a fact, not a verdict:
a build you just ran will show for an hour; something you don't recognise is
the thing to look up (`ps -p PID` or `top -o cpu`). Refreshes every minute;
the hour is 60 refreshes, so sleep doesn't count. Script: `sysload.sh`,
history in `~/.cache/tmux-sysload-hist`.

## Leaving

| Want                        | Do                                                   |
|-----------------------------|------------------------------------------------------|
| come back later             | `Ctrl-A d`, then `t NAME` when you return             |
| done with the project       | `Ctrl-D` in every shell, or `tmux kill-session -t NAME` |

Mouse wheel scrolls; selecting with the mouse copies. Config: `~/.config/tmux/tmux.conf`.
