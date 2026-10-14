# zsh

The shell as set up in `.zshrc`: vi keys on the command line, fzf for picking
files, and a handful of one-word helpers. `cheat` alone lists every sheet.

## macOS `open`

| Command                 | Does                                                   |
|-------------------------|--------------------------------------------------------|
| `open FILE`             | open with the default app (PDFs go to sioyek)          |
| `open -R FILE`          | reveal: Finder on the file's folder, file selected     |
| `open .`                | Finder on the current directory                        |
| `open -a APP FILE`      | open with a specific app (`open -a Preview x.pdf`)     |
| `open URL`              | in the default browser                                 |

## Own helpers

| Command                 | Does                                                   |
|-------------------------|--------------------------------------------------------|
| `cheat [NAME]`          | render `cheats/NAME.md`; a unique prefix works (`cheat s`) |
| `t [NAME [DIR]]`        | tmux: list sessions / attach or create NAME            |
| `dotcheck`              | every tracked dotfile still symlinked into the repo?   |
| `daily`                 | today's note in `~/Documents/DailyNotes`               |
| `todo [TEXT]`           | append TEXT under today's date in todos.md; none: edit it |
| `dev` / `doc`           | cd to `~/Documents/Developing` / `~/Documents`         |
| `termbg IMAGE`          | Ghostty background + palette from a picture            |
| `nq`                    | networkQuality (speed test)                            |
| `n` / `c` / `p`         | nvim / claude / python3                                |
| `ls` / `tree`           | eza, icons, dirs first / two-level tree                |

## Fuzzy finding (fzf)

| Key                     | Does                                                   |
|-------------------------|--------------------------------------------------------|
| `Ctrl-F`                | pick a file, paste its path at the cursor (`n Ctrl-F`) |
| `Ctrl-G`                | cd into a directory below here                         |
| `Ctrl-R`                | search command history                                 |
| `PATH/**` then `Tab`    | fuzzy-complete a typed path: `mv ~/Downloads/**<Tab> .` |
| `Tab` in the list       | multi-select (Ctrl-F)                                  |

## Editing the command line (vi mode)

| Key                     | Does                                                   |
|-------------------------|--------------------------------------------------------|
| `Esc`                   | normal mode: `b` `w` `0` `$` `dd` `ciw`... as in vim   |
| `i` / `a`               | back to typing                                         |
| `Esc` `v`, or `Ctrl-X Ctrl-E` | edit the line in nvim; `:wq` returns it, not yet run |
| `Ctrl-W` / `Ctrl-U`     | delete word / line backwards                           |
| `Ctrl-D`                | leave the shell                                        |

Man pages open in nvim (`MANPAGER`). Bookmarked URLs (`$MYSKY_...`) come from
`~/.config/zsh/links.zsh`, outside the repo.
