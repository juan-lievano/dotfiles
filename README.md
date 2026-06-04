# dotfiles

Personal config backup. The real files live here in `~/dotfiles`; each is
**symlinked** back to where the app expects it, so nothing changed about how
the machine works — editing `~/.zshrc` and `~/dotfiles/.zshrc` is the same file.

## What's tracked

| Repo path                  | Symlinked to            | What it is                     |
|----------------------------|-------------------------|--------------------------------|
| `.zshrc`                   | `~/.zshrc`              | zsh shell config               |
| `.zprofile`                | `~/.zprofile`           | login-shell Homebrew bootstrap |
| `.gitconfig`               | `~/.gitconfig`          | git identity + settings        |
| `.config/git/`             | `~/.config/git/`        | global gitignore               |
| `.config/nvim/`            | `~/.config/nvim/`       | Neovim config                  |
| `.config/karabiner/`       | `~/.config/karabiner/`  | keyboard remaps (caps→ctrl)    |
| `.config/wezterm/`         | `~/.config/wezterm/`    | terminal config                |
| `.config/qalculate/`       | `~/.config/qalculate/`  | calculator prefs               |

Secrets (`~/.ssh`, API tokens, etc.) are deliberately **not** here.

## Daily use

```sh
cd ~/dotfiles
git status            # see changed configs
git add -u            # stage modified tracked files
git commit -m "..."   # snapshot
git push              # back up to GitHub
```

`dotcheck` (a zsh function in `.zshrc`) verifies every tracked file is still a
live symlink — run it if a config ever seems to have "detached".

## Restoring on a new machine

Clone the repo, then run the script below to recreate every symlink. It backs
up anything already sitting at each target (as `*.pre-dotfiles.<timestamp>`)
before linking, and is safe to re-run.

```sh
git clone <repo-url> ~/dotfiles
```

```sh
#!/usr/bin/env bash
# Recreate dotfile symlinks after cloning into ~/dotfiles. Safe to re-run.
set -euo pipefail
DOT="$HOME/dotfiles"

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
```

To run it: paste into a file (e.g. `~/dotfiles/install.sh`) and `bash install.sh`,
or paste the block straight into your terminal.
