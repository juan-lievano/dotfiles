#!/usr/bin/env bash
# Recreate dotfile symlinks after cloning the repo. Safe to re-run.
# Self-locating: works from whatever path you cloned into.
set -euo pipefail
DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {                      # link <path relative to repo / $HOME>
  local rel="$1" src="$HOME/$rel" dest="$DOT/$rel"
  mkdir -p "$(dirname "$src")"
  if [ -e "$src" ] && [ ! -L "$src" ]; then
    mv "$src" "$src.pre-dotfiles.$(date +%s)"   # stash whatever was there
  fi
  ln -sfn "$dest" "$src"                          # -n: replace, don't nest
  echo "linked ~/$rel"
}

link .zshrc
link .zprofile
link .gitconfig
link .config/git
link .config/nvim
link .config/karabiner
link .config/wezterm
link .config/qalculate

echo "done — open a new shell."
