# Terminal look from a picture

`termbg IMAGE` makes the picture Ghostty's faint background and turns its
colors into the terminal palette. Nothing in any config changes afterwards.

```
termbg ~/Downloads/painting.jpg
termbg photo.png --fg e6c9a8      # extra flags go to img2palette
```

## Pieces

| what | where | does |
|---|---|---|
| `termbg` | here | resizes + frosts the image into `~/Pictures/terminal/current*.jpg`, runs `img2palette`, writes `~/.config/ghostty/themes/from-image`, clicks Ghostty > Reload Configuration |
| `img2palette` | here | k-means the pixels (ImageMagick), maps clusters to the 16 ANSI slots by hue, lifts lightness so it reads on black; `--preview/--quantized/--remap` PNGs |
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
