eval "$(/opt/homebrew/bin/brew shellenv)"

# Make XDG-aware tools (e.g. aerc) use ~/.config instead of ~/Library/* on macOS
export XDG_CONFIG_HOME="$HOME/.config"
