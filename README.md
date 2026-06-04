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

```sh
git clone <repo-url> ~/dotfiles
# then symlink each entry into place, e.g.:
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.config/nvim ~/.config/nvim
# ...etc (see the table above)
```
