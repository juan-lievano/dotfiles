# zsh
Config `~/.zshrc`, `~/.zprofile`. URLs (`$MYSKY_…`) in `~/.config/zsh/links.zsh`, outside the repo.

|                | Command                       | Does                                         |
|----------------|-------------------------------|----------------------------------------------|
| **Helpers**    | `cheat`                       | list the sheets                              |
|                | `cheat NAME`                  | render `cheats/NAME.md`; unique prefix works |
|                | `t`                           | list tmux sessions                           |
|                | `t NAME [DIR]`                | attach or create; switches inside tmux       |
|                | `dotcheck`                    | tracked dotfiles still symlinked?            |
|                | `daily`                       | today's note in `~/Documents/DailyNotes`     |
|                | `todo`                        | edit `todos.md` there                        |
|                | `todo TEXT`                   | append TEXT under today's date               |
|                | `dev` / `doc`                 | cd `~/Documents/Developing` / `~/Documents`  |
|                | `termbg IMAGE`                | Ghostty background + palette from a picture  |
|                | &nbsp;&nbsp;`--blur 40`       | less blur (80)                               |
|                | &nbsp;&nbsp;other flags       | go to `img2palette`                          |
|                | `nq`                          | `networkQuality`                             |
|   | ──────────────────────────── | ──────────────────────────────────────────────────────────── |
| **Aliases**    | `n` / `c` / `p`               | `nvim` / `claude` / `python3`                |
|                | `ls`                          | eza: icons, directories first, by extension  |
|                | `tree`                        | eza tree: 2 levels, gitignored hidden        |
|   | ──────────────────────────── | ──────────────────────────────────────────────────────────── |
| **fzf**        | `Ctrl-F`, `Ctrl-T`            | pick files, paste the paths; `Tab` selects more |
|                | `Ctrl-G`, `Alt-C`             | cd to a directory below                      |
|                | `Ctrl-R`                      | history                                      |
|                | `PATH/**` `Tab`               | fuzzy-complete a typed path                  |
|                | &nbsp;lists                   | fd, hidden too; not `.git` `Library` `node_modules` |
|                | &nbsp;preview                 | file head / `ls -la`                         |
|   | ──────────────────────────── | ──────────────────────────────────────────────────────────── |
| **Line**       | `Esc`                         | vi normal mode, block cursor                 |
|                | `Esc` `v`, `Ctrl-X Ctrl-E`    | edit the line in nvim; `:wq` returns it      |
|                | `Ctrl-W` / `Ctrl-U`           | delete word / line backwards                 |
|   | ──────────────────────────── | ──────────────────────────────────────────────────────────── |
| **open**       | `open FILE`                   | default app (PDFs: sioyek)                   |
|                | `open -R FILE`                | reveal in Finder                             |
|                | `open .`                      | Finder here                                  |
|                | `open -a APP FILE`            | with that app                                |
|                | `open URL`                    | default browser                              |
|   | ──────────────────────────── | ──────────────────────────────────────────────────────────── |
| **Settings**   | `man`                         | pages open in nvim                           |
|                | `EDITOR`, `VISUAL`            | nvim                                         |
|                | `PATH`                        | `~/.local/bin`, rustup, `~/.cargo/bin` first |
|                | `XDG_CONFIG_HOME`             | `~/.config`                                  |
|                | `KEYTIMEOUT=1`                | Esc waits 10 ms                              |
|                | `TMUX_ONESHOT`                | tmux `o` popup: shell exits on first success |
|                | `CLAUDE_CODE_TMUX_TRUECOLOR`  | true colour for Claude inside tmux           |
|                | &nbsp;colours                       | zsh-patina, `~/.config/zsh-patina/`          |
|                | &nbsp;prompt                        | `user@host dir %`                            |
