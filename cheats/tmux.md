# tmux
Config `~/.config/tmux/tmux.conf`. Prefix `Ctrl-A`; for `t c n p w d v s x z f o e` Ctrl may stay held.

|                | Key                           | Does                                         |
|----------------|-------------------------------|----------------------------------------------|
| **No prefix**  | `Cmd-T`                       | new window                                   |
|                | `Cmd-W`                       | close window; asks unless one idle zsh       |
|                | `Ctrl-Tab`, `Cmd-Shift-]`     | next window                                  |
|                | `Ctrl-Shift-Tab`, `Cmd-Shift-[` | previous window                            |
|                | `Cmd-1`-`Cmd-9`               | window N                                     |
|                | &nbsp;outside tmux            | these keys print junk (Ghostty sends codes)  |
|   | ─────────────────────────────── | ──────────────────────────────────────────────── |
| **Shell**      | `t`                           | list sessions                                |
|                | `t NAME [DIR]`                | attach or create; switches inside tmux       |
|                | `tmux kill-session -t NAME`   | end a session                                |
|   | ─────────────────────────────── | ──────────────────────────────────────────────── |
| **Windows**    | `t`, `c`                      | new window, same directory                   |
|                | `Tab` / `Shift-Tab`           | next / previous (`p` previous too)           |
|                | `1`-`9`                       | window N                                     |
|                | `f`                           | fuzzy-pick a window in any session           |
|                | `w`                           | tree of sessions and windows                 |
|                | `,`                           | rename                                       |
|                | `&`                           | close (asks)                                 |
|   | ─────────────────────────────── | ──────────────────────────────────────────────── |
| **Sessions**   | `n`                           | types `:new -A -s `; a name creates or switches |
|                | `$`                           | rename                                       |
|                | `d`                           | detach                                       |
|                | &nbsp;last window closed      | lands in another session, not out of tmux    |
|   | ─────────────────────────────── | ──────────────────────────────────────────────── |
| **Panes**      | `v` / `s`                     | split side by side / stacked, same directory |
|                | &nbsp;arrows                        | move                                         |
|                | `z`                           | zoom, again to undo                          |
|                | `x`                           | close (asks)                                 |
|   | ─────────────────────────────── | ──────────────────────────────────────────────── |
| **Copy mode**  | `e`, `[`                      | enter: frozen pane, scroll and copy          |
|                | `PageUp`                      | enter, one page up                           |
|                | `j` `k`, `Ctrl-D` `Ctrl-U`    | line, half page                              |
|                | `g` / `G`                     | oldest line / bottom                         |
|                | `/` `?`, then `n` `N`         | search down / up, next / previous            |
|                | `w` `b` `0` `$` `H` `M` `L`   | move like nvim                               |
|                | `v` / `V` / `Ctrl-V`          | select / lines / block                       |
|                | `y`, `Enter`                  | copy and leave; `Cmd-V` pastes               |
|                | `yy` / `Y`                    | copy the line / to its end                   |
|                | `yiw` / `yaw`                 | copy the word / with the spaces after it     |
|                | `]`                           | paste the last copy into the pane            |
|                | `Esc` / `q`                   | drop selection / leave                       |
|                | &nbsp;in Claude               | only what's on screen; scroll Claude first   |
|   | ─────────────────────────────── | ──────────────────────────────────────────────── |
| **Other**      | `o`                           | one-command shell popup; closes on success   |
|                | `:`                           | command prompt (`:list-keys`)                |
|                | `r`                           | reload tmux.conf                             |
|                | `Ctrl-A`                      | literal Ctrl-A                               |
|                | &nbsp;mouse                         | wheel scrolls, selecting copies              |
|   | ─────────────────────────────── | ──────────────────────────────────────────────── |
| **Status bar** | `+N` after the session name   | other sessions running                       |
|                | `mem 34%`                     | memory in use; yellow / red = pressure       |
|                | `cpu 9%`                      | whole machine; one busy core is ~8%          |
|                | `Python 58m`                  | over 15 CPU-minutes in the last hour         |
|                | &nbsp;refresh                 | 60 s, `sysload.sh`; `~/.cache/tmux-sysload-hist` |
|   | ─────────────────────────────── | ──────────────────────────────────────────────── |
| **Settings**   | &nbsp;windows                       | numbered from 1, gaps closed                 |
|                | &nbsp;window name                   | running command; for Claude the pane title   |
|                | &nbsp;scrollback                    | 50000 lines                                  |
|                | &nbsp;clipboard                     | copies reach macOS (OSC 52)                  |
|                | `Shift-Enter`                 | reaches programs that ask (extended keys)    |
|                | &nbsp;inline images                 | pass through                                 |
|                | `Esc`                         | no delay                                     |
|                | &nbsp;look                          | bar on top, transparent; terminal's colours  |
