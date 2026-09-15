# Terminal look from a picture

`termbg IMAGE` makes the picture Ghostty's faint background and turns its
colors into the terminal palette. Nothing in any config changes afterwards.

```
termbg ~/Downloads/painting.jpg
termbg photo.png --fg e6c9a8      # extra flags go to img2palette
termbg-daily scan ~/dotfiles/pictures/hopper # score a folder into the daily pool
termbg-daily next                            # today's didn't work: another one
termbg-daily next --repel 0 --tolerance 40   # ...with other img2palette settings
termbg-daily pick "soir bleu"                # a specific one, by any part of its name
termbg-daily retire "nighthawks"             # never again (moves it to retired/ beside it)
termbg-tour 5                                # flip through the pool, 5 s each; Ctrl-C stays put
```

Pictures live in `pictures/` in this repo, gitignored (big, in copyright);
`~/Pictures/terminal/` holds the frosted copy and the daily state.

## Pieces

| what | where | does |
|---|---|---|
| `termbg` | here | resizes + frosts the image into `~/Pictures/terminal/current*.jpg`, runs `img2palette`, writes `~/.config/ghostty/themes/from-image`, clicks Ghostty > Reload Configuration (~6 s) |
| `img2palette` | here | k-means the pixels (ImageMagick), maps clusters to the 16 ANSI slots by hue with a repulsion between hue families (`--repel`, `--tolerance`), lifts lightness so it reads on black; `--score` counts hue families; `--debug` lists the picks; `--preview/--quantized/--remap PNG` diagnostics on request |
| `termbg-daily` | here | one picture a day from `~/Pictures/terminal/daily/pool.txt` (pictures with ≥ 4 of Catppuccin's 8 hue families, `TERMBG_MIN`), shuffled so nothing repeats until all have run; `Library/LaunchAgents/com.jplk.termbg-daily.plist` runs it 05:00 + login |
| Ghostty config | `.config/ghostty/config` | fixed lines `theme = from-image` and `background-image = ~/Pictures/terminal/current-frosted.jpg` |
| nvim | `.config/nvim/colors/terminal.lua` | colorscheme that only names ANSI slots (no hexes, `termguicolors` off); plugins inherit via standard groups |
| zsh, ls | `.zshrc` | already use slot names |

Slots are the shared "abstract palette": 1 red, 2 green, 3 yellow, 4 blue,
5 magenta, 6 cyan, 8 grey, 9-15 bright. Everything downstream asks for a slot;
Ghostty decides what the slot looks like. A running nvim repaints on reload.

## Needs

- ImageMagick 7 (`brew install imagemagick`), Python 3, nothing else.
- Ghostty in System Settings > Privacy & Security > Accessibility, for the
  automatic reload. Without it `termbg` still writes everything and tells you
  to press Cmd-Shift-,.
- Images stay out of the repo (size, copyright). `current.txt` records the
  source path.
