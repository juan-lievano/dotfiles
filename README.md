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
| `.latexmkrc`               | `~/.latexmkrc`          | LaTeX build layout             |
| `.config/git/`             | `~/.config/git/`        | global gitignore               |
| `.config/nvim/`            | `~/.config/nvim/`       | Neovim config                  |
| `.config/karabiner/`       | `~/.config/karabiner/`  | keyboard remaps (caps→ctrl)    |
| `.config/wezterm/`         | `~/.config/wezterm/`    | terminal config                |
| `.config/qalculate/`       | `~/.config/qalculate/`  | calculator prefs               |
| `.config/aerc/aerc.conf`   | `~/.config/aerc/aerc.conf`  | aerc (email) main config   |
| `.config/aerc/binds.conf`  | `~/.config/aerc/binds.conf` | aerc keybindings           |

aerc is linked **per file**, not per directory: its credentials file
(`accounts.conf`) lives beside these in `~/.config/aerc/` and must stay out of
the repo (it's gitignored as a second line of defense; the password itself is
in the macOS Keychain). aerc only looks in `~/.config` because `.zprofile`
exports `XDG_CONFIG_HOME` — without it, aerc on macOS uses
`~/Library/Preferences`.

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

Clone the repo into your **home folder** and run `install.sh`:

```sh
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` recreates every symlink. It backs up anything already sitting at
each target (as `*.pre-dotfiles.<timestamp>`) before linking, and is safe to
re-run. It's self-locating (finds its own directory via `BASH_SOURCE`), so it
works from whatever path you cloned into — but see the note below on *where* to
clone.

### Why `~/dotfiles` and not `~/Documents` (or any iCloud folder)

Keep this repo **outside iCloud Drive** (i.e. not in `~/Documents` or `~/Desktop`
if those sync to iCloud). Two reasons:

1. **iCloud evicts files.** With "Optimize Mac Storage" on, iCloud silently
   replaces files you haven't touched lately with placeholder stubs that
   re-download on access. Since `~/.zshrc` is a *symlink into this repo*, an
   evicted target means your shell can hang or fail to start — especially
   offline or early in boot, exactly when you can't afford it. Config files need
   to be always-present and instant; iCloud optimizes for the opposite.
2. **`.git` corruption.** File-sync services sync individual files without
   understanding git's locking, so a `.git` directory living in iCloud can get
   corrupted by a partial or concurrent sync.

You don't need iCloud for backup anyway — **the GitHub remote already is the
backup**, with full version history (which iCloud doesn't give you). The home
folder is local-only and never evicted, so it's the right home for the live repo.
