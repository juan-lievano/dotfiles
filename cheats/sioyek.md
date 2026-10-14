# sioyek

PDF viewer, vim-ish. Keys act straight away, no prefix; `:` opens a command
palette where every command can be typed by name (fuzzy). Position, bookmarks
and highlights persist per file across restarts.

## Open and leave

| Key / command           | Does                                            |
|-------------------------|-------------------------------------------------|
| `Hyper-3`               | launch / focus sioyek                           |
| `open file.pdf`         | open in sioyek (default PDF app)                |
| `o`                     | open a file (system dialog)                     |
| `Ctrl-O`                | open a recent file (fuzzy list)                 |
| `Ctrl-T` / `Ctrl-W`     | new window / close window                       |
| `gf`                    | reveal the current file in Finder               |
| `q`                     | quit                                            |
| `cheat sioyek`          | this sheet                                      |

## Move

| Key                     | Does                                            |
|-------------------------|-------------------------------------------------|
| `j` / `k`               | scroll a line down / up                         |
| `Ctrl-D` / `Ctrl-U`     | half screen down / up                           |
| `Space` / `Shift-Space` | screen down / up                                |
| `gg` / `G`              | first / last page                               |
| `Home`                  | go to page N (type the number)                  |
| `gc` / `gC`             | next / previous chapter                         |
| `t`                     | table of contents                               |
| `Backspace` / `Shift-Backspace` | back / forward in jump history          |
| `f`                     | follow a link: labels appear, type one          |
| `Ctrl-]` / `l`          | jump to / preview the reference under the cursor |

## Look

| Key                     | Does                                            |
|-------------------------|-------------------------------------------------|
| `+` / `-`               | zoom in / out                                   |
| `=`                     | fit page width                                  |
| `F10`                   | fit text width (trims margins)                  |
| `r` / `R`               | rotate                                          |
| `F11`                   | fullscreen                                      |
| `F5`                    | presentation mode (one page, no UI)             |
| `F8`                    | dark mode (inverts the page)                    |
| `F7`                    | visual scroll: `j`/`k` move a reading ruler     |

## Find

| Key                     | Does                                            |
|-------------------------|-------------------------------------------------|
| `/` or `Ctrl-F`         | search; `n` / `N` next / previous hit           |
| `c/`                    | search within the current chapter               |
| `s`                     | web-search the selected text (Google Scholar)   |

## Mark

| Key                     | Does                                            |
|-------------------------|-------------------------------------------------|
| `b` / `gb` / `db`       | add / go to / delete a bookmark                 |
| `h` / `gh` / `dh`       | highlight the selection (then a colour letter) / go to / delete |
| `m` + letter / `` ` `` + letter | set / jump to a mark, like vim          |
| `v`                     | keyboard text selection                         |
| `Ctrl-C`                | copy the selection                              |

Mouse: drag selects text, wheel scrolls, middle-click a word searches it.
Config: `~/.config/sioyek/prefs_user.config` and `keys_user.config`; defaults
with every option documented live in `/Applications/sioyek.app/Contents/MacOS/`.
