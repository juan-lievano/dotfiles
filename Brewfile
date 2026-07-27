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
# keyboard; skhd catches Hyper+N (from the Voyager's firmware or kanata's
# Space-hold layer) and runs .config/karabiner/open-app-slot.sh.
# Needs the Karabiner DriverKit driver, which the karabiner-elements cask below
# installs — keep that cask even after kanata takes over.
brew "kanata"
tap "koekeishiya/formulae"
brew "koekeishiya/formulae/skhd"

cask "wezterm"
cask "karabiner-elements"           # driver provider + rollback path for kanata
cask "codex"
cask "mactex-no-gui"

# --- Reinstall-on-demand (intentionally omitted; zero usage in shell history) ---
# ffmpeg, imagemagick, glow, qalculate-qt, mouseless, rbenv, opencode, pandoc,
# font-atkinson-hyperlegible
#
# --- Not via brew ---
# Claude Code: curl -fsSL https://claude.ai/install.sh | bash   (native installer)
# JetBrains Mono terminal font: bundled inside wezterm, no install needed
