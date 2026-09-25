# Minimal Brewfile — essentials for a fresh machine/account
# Usage: brew bundle --file=~/dotfiles/Brewfile
# NOTE: On the SAME Mac a second account doesn't need this (brew is shared at
#       /opt/homebrew). It's insurance for a clean wipe or a different machine.

brew "neovim"
brew "fd"
brew "fzf"
brew "imagemagick"                  # termbg / img2palette (terminal palette + background from an image)
brew "pyright"
brew "lua-language-server"
brew "texlab"                       # LaTeX language server (completion/diagnostics)
brew "aerc"                         # terminal email client (config tracked in this repo)
brew "w3m"                          # aerc's HTML filter depends on it (aerc.conf [filters])
brew "ripgrep"
brew "gh"
brew "git-filter-repo"
brew "pipenv"
brew "poppler"                      # pdftotext / pdftoppm (PDF reading and page renders)
brew "eza"                          # ls replacement (aliased in .zshrc); colours are ANSI slots
brew "zsh-patina"                   # command-line syntax highlighting (config in .config/zsh-patina)

# Keyboard remapping. kanata does home row mods + Ctrl rewrites on the built-in
# keyboard; skhd catches Hyper+N (home-row chord or Voyager firmware) and runs
# .config/skhd/open-app-slot.sh. kanata emits through the Karabiner DriverKit
# VirtualHIDDevice driver, which the karabiner-elements cask below installs —
# the cask stays for the driver alone; the app itself is unused.
brew "kanata"
tap "koekeishiya/formulae"
brew "koekeishiya/formulae/skhd"

cask "wezterm"
cask "ghostty"                      # daily driver on trial (Hyper+1); also the only terminal Apple dictation types into
cask "karabiner-elements"           # VirtualHIDDevice driver provider for kanata
cask "codex"
cask "mactex-no-gui"
cask "discord"
cask "docker-desktop"

# --- Reinstall-on-demand (intentionally omitted; zero usage in shell history) ---
# ffmpeg, glow, qalculate-qt, mouseless, rbenv, opencode, pandoc, inkscape, qmk toolchain,
# font-atkinson-hyperlegible, font-meslo-lg-nerd-font
#
# --- Not via brew ---
# Claude Code: curl -fsSL https://claude.ai/install.sh | bash   (native installer)
# JetBrains Mono terminal font: bundled inside wezterm and ghostty, no install needed
