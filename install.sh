#!/usr/bin/env bash
# Recreate dotfile symlinks after cloning the repo. Safe to re-run.
# Self-locating: works from whatever path you cloned into.
set -euo pipefail
DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {                      # link <path relative to repo / $HOME>
  local rel="$1"
  local src="$HOME/$rel" dest="$DOT/$rel"
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
link .latexmkrc
link .config/git
link .config/nvim
link .config/kanata
link .config/skhd
link .config/wezterm
link .config/ghostty
link .config/qalculate
link .config/aerc/aerc.conf   # files, not the dir: accounts.conf (secrets) lives beside them
link .config/aerc/binds.conf
link .local/bin/img2palette  # terminal palette from an image; needs magick
link .local/bin/termbg       # image -> Ghostty background + palette, via img2palette
link .local/bin/termbg-daily # a different picture every day (pool: termbg-daily scan DIR)
link .local/bin/termbg-tour  # flip through the pool, a few seconds each
link .w3m/keymap              # file, not dir: ~/.w3m also holds cookies/history

# daily picture switch, 05:00 + login. A symlinked plist is fine for a gui/
# agent (daemons are the ones that must be real root-owned files).
link Library/LaunchAgents/com.jplk.termbg-daily.plist
launchctl bootout "gui/$(id -u)/com.jplk.termbg-daily" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$HOME/Library/LaunchAgents/com.jplk.termbg-daily.plist"

# Claude Code: files, not the dir — ~/.claude is mostly runtime state
# (sessions/, history.jsonl, caches, logs) that must not be tracked.
link .claude/settings.json
link .claude/keybindings.json
link .claude/CLAUDE.md
link .claude/statusline-command.sh

# git hooks live in tracked hooks/ (pre-push runs the dotcheck symlink audit)
git -C "$DOT" config core.hooksPath hooks

# fzf shell integration (generates ~/.fzf.zsh, needed for key bindings)
if command -v fzf &>/dev/null; then
  "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
  echo "fzf shell integration installed"
else
  echo "fzf not installed — skipping shell integration (run brew bundle first)"
fi

echo "done — open a new shell."
