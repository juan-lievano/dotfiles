# Minimal Brewfile — essentials for a fresh machine/account
# Usage: brew bundle --file=~/dotfiles/Brewfile
# NOTE: On the SAME Mac a second account doesn't need this (brew is shared at
#       /opt/homebrew). It's insurance for a clean wipe or a different machine.

brew "neovim"
brew "fd"
brew "fzf"
brew "pyright"
brew "lua-language-server"
brew "texlab"                       # LaTeX language server (completion/diagnostics)
brew "aerc"                         # terminal email client (config tracked in this repo)
brew "w3m"                          # aerc's HTML filter depends on it (aerc.conf [filters])

# Keyboard remapping. kanata does home row mods + Ctrl rewrites on the built-in
# keyboard; skhd catches Hyper+N (home-row chord or Voyager firmware) and runs
# .config/skhd/open-app-slot.sh. kanata emits through the Karabiner DriverKit
# VirtualHIDDevice driver, which the karabiner-elements cask below installs —
# the cask stays for the driver alone; the app itself is unused.
brew "kanata"
tap "koekeishiya/formulae"
brew "koekeishiya/formulae/skhd"

cask "wezterm"
cask "ghostty"                      # dictation fallback: Apple dictation types into it, not into wezterm
cask "karabiner-elements"           # VirtualHIDDevice driver provider for kanata
cask "codex"
cask "mactex-no-gui"

# --- Reinstall-on-demand (intentionally omitted; zero usage in shell history) ---
# ffmpeg, imagemagick, glow, qalculate-qt, mouseless, rbenv, opencode, pandoc,
# font-atkinson-hyperlegible
#
# --- Not via brew ---
# Claude Code: curl -fsSL https://claude.ai/install.sh | bash   (native installer)
# JetBrains Mono terminal font: bundled inside wezterm and ghostty, no install needed
