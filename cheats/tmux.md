# tmux

A session is a group of tabs for one project; a window is a tab in it.
Every tmux command is two steps: press the prefix (Ctrl-A), let go, press a key.
For the common letters, keeping Ctrl held works too: Ctrl-A Ctrl-C = Ctrl-A c.

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
| `c`     | new window                                     |
| `t`     | new session: `:new -A -s ` typed, add a name   |
| `1`-`9` | go to window N                                 |
| `n` `p` | next / previous window                         |
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
| `?`      | this sheet                                    |
| `:`      | type a tmux command (`:list-keys` shows all)  |
| `r`      | reload tmux.conf                              |
| `Ctrl-A` | send a literal Ctrl-A                         |

## Leaving

| Want                        | Do                                                   |
|-----------------------------|------------------------------------------------------|
| come back later             | `Ctrl-A d`, then `t NAME` when you return             |
| done with the project       | `Ctrl-D` in every shell, or `tmux kill-session -t NAME` |

Mouse wheel scrolls; selecting with the mouse copies. Config: `~/.config/tmux/tmux.conf`.
