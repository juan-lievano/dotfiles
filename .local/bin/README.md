# Terminal look from a picture

`termbg IMAGE` makes the picture Ghostty's heavily blurred background and
turns its colors into the terminal palette. Nothing in any config changes
afterwards; run it again with another picture whenever you feel like it.
Every run starts by printing its own option list.

```
termbg ~/Downloads/painting.jpg
termbg photo.png --blur 40        # less blur (default 80; 120+ is a gradient)
termbg photo.png --fg e6c9a8      # every other flag goes to img2palette
```

Pictures live in `backgrounds/` in this repo, gitignored (big, in copyright);
`~/Pictures/terminal/` holds the resized and blurred copies and `current.txt`
with the source path.

## Pieces

| what | where | does |
|---|---|---|
| `termbg` | here | resizes + blurs the image into `~/Pictures/terminal/current*.jpg`, runs `img2palette`, writes `~/.config/ghostty/themes/from-image`, clicks Ghostty > Reload Configuration (~6 s) |
| `img2palette` | here | k-means the pixels (ImageMagick), maps clusters to the 16 ANSI slots by hue with a repulsion between hue families (`--repel`, `--tolerance`), lifts lightness so it reads on black; `--debug` lists the picks; `--preview/--quantized/--remap PNG` diagnostics on request |
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

## Keepers

Runs worth coming back to. The generator is deterministic: the same image and
flags reproduce the same theme (verified 2026-09-25 by diffing a rerun against
the live file).

```
termbg "backgrounds/1916–1919 - Rocks and Sea (70.1292).jpg" --tolerance 360 --repel 0
```

Hopper, Rocks and Sea. `--tolerance 360 --repel 0` lets every slot take the
nearest cluster with no fallback to Catppuccin and no hue exclusion, so the
whole palette is the painting's blues, greens and ochres. Result:

```
palette = 0=#3d434e   palette = 8=#848d9c
palette = 1=#ee9675   palette = 9=#ffae31
palette = 2=#b2e0a0   palette = 10=#a8d532
palette = 3=#d6ce70   palette = 11=#e0da74
palette = 4=#79b9f6   palette = 12=#c2e2ff
palette = 5=#b2d9ff   palette = 13=#cce4ff
palette = 6=#8cc89a   palette = 14=#87c9ff
palette = 7=#b1b89c   palette = 15=#cad2b5
background = #152032   foreground = #cad2b5   cursor-color = #afd2f4
```
