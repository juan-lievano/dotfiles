#!/bin/sh
# Render LAYOUT.md to a PDF and open it, for consulting away from the editor.
#
#     ~/.config/kanata/layout-pdf.sh [output.pdf]
#
# Output defaults to $TMPDIR so no generated artifact lands in the repo --
# unlike voyager_layout.pdf, which is committed because only Oryx can produce
# it, this one is a build product of LAYOUT.md and stays disposable.
#
# pandoc + xelatex, both already here (Brewfile: mactex-no-gui; pandoc).
# Menlo covers every glyph the grids use EXCEPT the media-transport symbols --
# no stock macOS monospace font has ⏮ ⏯ ⏭ -- so the pipe substitutes
# same-width stand-ins to keep the grid columns aligned: « prev, ▶ play/pause,
# » next. ⚠️ becomes (!) because Latin Modern lacks it too. LAYOUT.md itself
# is untouched; if a future edit adds a glyph that silently vanishes from the
# PDF, run pandoc by hand and look for "Missing character" warnings.
set -e
export LC_ALL=en_US.UTF-8

dir="$(cd "$(dirname "$0")" && pwd)"
out="${1:-${TMPDIR:-/tmp}kanata-layout.pdf}"

sed -e 's/⏮/«/g' -e 's/⏯/▶/g' -e 's/⏭/»/g' -e 's/⚠️/(!)/g' "$dir/LAYOUT.md" |
  pandoc -o "$out" --pdf-engine=xelatex \
    -V monofont=Menlo -V monofontoptions='Scale=0.85' \
    -V geometry:margin=1.5cm

open "$out"
