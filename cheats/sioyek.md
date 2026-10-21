# sioyek

PDF viewer, vim-ish. Keys act straight away, no prefix; `:` opens a command
palette where every command can be typed by name (fuzzy). Inside any menu
(`O`, `t`, `:`, `gb`...) `Ctrl-N`/`Ctrl-P` move the selection (bound in
keys_user.config via `[m]control_menu`), `Enter` picks, `Esc` closes.
Position, bookmarks and highlights persist per file across restarts. There
are no tabs: one window shows one PDF, a newly opened file replaces it, and
`O` is the tab list.

## Open and leave

| Key / command           | Does                                            |
|-------------------------|-------------------------------------------------|
| `Hyper-3`               | launch / focus sioyek                           |
| `open file.pdf`         | open in sioyek, via the "Open in sioyek" shim (also Finder, Dock stacks, nvim `<leader>ll`) |
| `O`                     | fuzzy list of every PDF opened before: the "tabs" |
| `Ctrl-O` / `Backspace`  | back to where you were, across PDFs too         |
| `o` / `go`              | open a file: system dialog / built-in browser   |
| `Ctrl-T` / `Ctrl-W`     | a second window if you really want one / close it |
| `F11`                   | leave / re-enter fullscreen (starts fullscreen) |
| `gf`                    | reveal the current file in Finder               |
| `q` / `Cmd-W`          | quit (Cmd-W closed the window but kept the app)  |
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
| `Ctrl-O` / `Ctrl-I`     | back / forward in jump history, like nvim (also `Backspace` / `Shift-Backspace`) |
| `f`                     | follow a link: labels appear, type one          |
| `Ctrl-]` / `l`          | jump to / preview the reference under the cursor |

## Look

| Key                     | Does                                            |
|-------------------------|-------------------------------------------------|
| `+` / `-`               | zoom in / out                                   |
| `=`                     | fit page width                                  |
| `F10`                   | fit text width (trims margins)                  |
| `Ctrl-R` / `Ctrl-Shift-R` | rotate clockwise / counter (`r` / `R` disabled) |
| `F11`                   | leave / re-enter fullscreen (starts fullscreen) |
| `F5`                    | presentation mode (one page, no UI)             |
| `F8`                    | dark mode (inverts the page)                    |
| `F7`                    | visual scroll: `j`/`k` move a reading ruler     |

## Find

| Key                     | Does                                            |
|-------------------------|-------------------------------------------------|
| `/` or `Ctrl-F`         | search; `n` / `N` next / previous hit           |
| `c/`                    | search within the current chapter               |
| `ss`                    | Google the selection (also middle-click a word) |
| `sd`                    | the selection in Dictionary.app                 |

## Mark

| Key                     | Does                                            |
|-------------------------|-------------------------------------------------|
| `b` / `gb` / `db`       | add a bookmark (asks for its text) / list them and jump / delete one |
| `h` / `gh`              | highlight the selection (then a colour letter) / go to one |
| click it, then `ch`     | add a comment to that highlight; clicking it shows the comment in the status bar |
| click it, then `dh`     | delete that highlight (and its comment)         |
| `m` + letter / `` ` `` + letter | set / jump to a mark, like vim          |
| `v`                     | keyboard text selection                         |
| `y` / `Ctrl-C`          | copy the selection                              |

Mouse: drag selects text, double-click selects a word, wheel scrolls.
Config: `~/.config/sioyek/prefs_user.config` and `keys_user.config`; defaults
with every option documented live in `/Applications/sioyek.app/Contents/MacOS/`.
PDFs are routed through `~/Applications/Open in sioyek.app` (source in
`~/.config/sioyek/open-in-sioyek/`), which activates sioyek so macOS switches
to its fullscreen Space; rebuild with its `build.sh`.
