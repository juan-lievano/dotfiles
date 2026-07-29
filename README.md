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
| `.config/kanata/`          | `~/.config/kanata/`     | keyboard remaps (home row mods) |
| `.config/skhd/`            | `~/.config/skhd/`       | Hyper+N app launcher hotkeys   |
| `.config/karabiner/`       | `~/.config/karabiner/`  | `open-app-slot.sh` (live) + Karabiner rollback |
| `.config/wezterm/`         | `~/.config/wezterm/`    | terminal config                |
| `.config/qalculate/`       | `~/.config/qalculate/`  | calculator prefs               |
| `.config/aerc/aerc.conf`   | `~/.config/aerc/aerc.conf`  | aerc (email) main config   |
| `.config/aerc/binds.conf`  | `~/.config/aerc/binds.conf` | aerc keybindings           |
| `.w3m/keymap`              | `~/.w3m/keymap`         | w3m keys (aerc HTML viewing)   |

`.config/karabiner/` is **not** dead weight: `open-app-slot.sh` there is still
the live app-launcher script (skhd calls it on every hotkey), and
`karabiner.json` is kept as the rollback path if kanata is ever removed.

aerc is linked **per file**, not per directory: its credentials file
(`accounts.conf`) lives beside these in `~/.config/aerc/` and must stay out of
the repo (it's gitignored as a second line of defense; the password itself is
in the macOS Keychain). aerc only looks in `~/.config` because `.zprofile`
exports `XDG_CONFIG_HOME` — without it, aerc on macOS uses
`~/Library/Preferences`.

Secrets (`~/.ssh`, API tokens, etc.) are deliberately **not** here.

## Keyboard remapping (kanata)

Karabiner-Elements was replaced by [kanata](https://github.com/jtroo/kanata),
which has a real tap-hold state machine and therefore usable **home row mods**:
`asdf` / `jkl;` become Shift/Ctrl/Opt/Cmd when held, mirrored across both hands.
*Chordal hold* (`tap-hold-tap-keys` with a per-hand key list) settles a
same-hand roll as a tap, so `as` types "as" instead of firing a modifier — which
is what makes home row mods tolerable. Consequence worth remembering: reach for
the Ctrl on the **opposite hand** from the letter (`l`+w for Ctrl-W, `s`+h for
Ctrl-H). Caps Lock is still Ctrl and works regardless of hand.

The variant is chosen to **match the Voyager**, which runs QMK Chordal Hold with
Permissive Hold and Hold-On-Other-Key-Press both off. Under those settings QMK
gives a cross-hand roll finished inside the tapping term as a *tap*; the mod
only fires past the full timeout. kanata's `tap-hold-release-keys` is Permissive
Hold and fired modifiers on rolls the Voyager types straight through, so
`tap-hold-tap-keys` is used instead — same signature, waits out `$hold-time`.
Timings match Oryx too (`$hold-time` = `TAPPING_TERM`, `$tap-time` =
`QUICK_TAP_TERM`, both 200). The price is that deliberate mods are slower: hold
for the full 200ms before the other key, on both keyboards. Anything tuned here
should be changed in Oryx as well, or the two stop feeling alike.

### Symbol and navigation layers (hold `m` / hold `n`)

Both layer keys sit on the right index finger and both layers put their payload
on the **left** hand — the same opposite-hand rule the home row mods follow.

| hold `m` + | gives | | hold `n` + | gives |
|------------|-------|---|------------|-------|
| `q w e r t` | `! @ # $ %` | | `a s d f` | ← ↓ ↑ → |
| `a s d f g` | `^ & * ( )` | | | |
| `z`         | Tab | | | |

The symbols are the shifted number row in order, which is why the config writes
them `S-1`..`S-0` rather than as literal glyphs. Arrows are `hjkl` order moved
one hand over.

Both are `tap-hold-tap-keys` with `$right-hand-keys`, so a fast right-hand roll
(`mn`, `m,`) settles as a tap, while the left-hand payload keys wait out the
full `$hold-time` — you hold, *then* press; you can't roll into a symbol. `m`
keeps `@ctlm` as its tap action, so Ctrl-M → Return survives. The cost is that
`m` and `n` lose key repeat, and hesitating on either past 200ms opens a layer.

In the nav layer the left hand's own mods are shadowed (they *are* the arrows),
but `k`/`l`/`;` stay transparent, so Opt-Left, Ctrl-Left and Shift-Left still
chord normally. `j` is the exception — same finger as `n` — so Cmd-Left/Right
for line ends needs physical Left Cmd.

### The function row has to be rebuilt by hand

Brightness/volume/media are **not** in the keyboard hardware — the F-row sends
plain F1–F12, and macOS's Apple-keyboard HID driver translates it, but only for
keyboards it recognizes as Apple. Karabiner's driver seizes the internal
keyboard upstream of that translation, so kanata sees a bare `F12` and re-emits
it on the Karabiner *virtual* keyboard, which macOS doesn't consider an Apple
keyboard. Every media key silently becomes a dead F-key.

Karabiner-Elements did this translation itself; kanata doesn't
([#1141](https://github.com/jtroo/kanata/issues/1141),
[#975](https://github.com/jtroo/kanata/issues/975) — upstream doesn't maintain
macOS), so `kanata.kbd` does it in the `base` layer. F1/F2 and F7–F12 emit real
HID usages. F3/F4 have no usage kanata can send, so they fire the equivalent
macOS shortcut (`Ctrl-Up`, `Cmd-Space`) and **break if those are ever rebound** —
relevant if Raycast ever takes Cmd-Space. F5 (dictation) and F6 (Focus) have
neither a usage nor a default shortcut, so they stay dead.

Real F1–F12 are on the `launch` layer: **hold Space, press the key**. `fn` is
deliberately left unmapped — grabbing it as the F-key modifier would consume it
and kill fn+arrows, fn+Delete, and the globe/emoji picker.

Three processes, none of which start themselves:

| layer | what it is | started by |
|-------|------------|------------|
| dext (kernel driver) | Karabiner's VirtualHIDDevice | the `karabiner-elements` cask |
| VirtualHIDDevice daemon | userspace half of the driver | `org.pqrs.karabiner-vhid-daemon.plist` |
| kanata | the remapper itself | `brew services` (runs as root) |
| skhd | catches Hyper+N, launches apps | `skhd --start-service` (runs as user) |

`sudo ~/.config/kanata/install-services.sh` installs the daemon plist and starts
kanata; it's idempotent, and `--uninstall` reverses it. **Keep the
`karabiner-elements` cask installed** — kanata has no driver of its own, and
quitting Karabiner also kills the daemon (kanata then fails with
`connect_failed asio.system:61`), which is exactly why that plist exists.

The app launcher is split in two on purpose: kanata turns `Space`-hold + N into
Hyper+N, the Voyager already sends Hyper+N from firmware, and **skhd** catches
it and runs `.config/karabiner/open-app-slot.sh` (still the single source of
truth for app names). Homebrew builds kanata without the `cmd` feature, so it
can't run the script itself — and skhd running as a normal user agent means
`open -a` works without any root workaround.

### Permissions, and why they're so awkward

kanata needs **both** Input Monitoring *and* Accessibility; skhd needs
Accessibility. Neither can be granted in advance: they're bare Mach-O binaries
with ad-hoc signatures and no Team ID, so macOS identifies them by path +
content hash and only lists them *after* the process asks. Run from a terminal,
the request is attributed to the terminal instead — so grant them via
**System Settings → Privacy & Security → … → `+` → Cmd+Shift+G** and paste the
real Cellar path. kanata may need a reboot for a root-daemon grant to take.

### ⚠️ Homebrew upgrades silently break this

Because TCC keys on **path + content hash**, `brew upgrade kanata` (or `skhd`)
moves the binary to a new versioned Cellar path with a new hash and **silently
revokes every permission granted above**. There is no error and no prompt — the
keyboard just quietly stops being remapped after the next restart.

Both formulae are therefore **pinned** (`brew pin kanata skhd`), so a blanket
`brew upgrade` can't touch them. Upgrade deliberately, and expect to re-grant
both permissions afterwards. Check with `brew list --pinned`.

Rolling back to Karabiner-Elements: `sudo ~/.config/kanata/install-services.sh
--uninstall`, relaunch Karabiner-Elements, and re-enable `karabiner_grabber`
under Input Monitoring. `.config/karabiner/karabiner.json` is unchanged.

## Daily use

```sh
cd ~/dotfiles
git status            # see changed configs
git add -u            # stage modified tracked files
git commit -m "..."   # snapshot
git push              # back up to GitHub
```

`dotcheck` (a zsh function in `.zshrc`) verifies every tracked file is still a
live symlink — run it if a config ever seems to have "detached". The same
check runs automatically as a git `pre-push` hook (`hooks/pre-push`, wired up
by `install.sh` via `core.hooksPath`), so a push fails if any config has
detached; bypass once with `git push --no-verify`.

## Restoring on a new machine

Clone the repo into your **home folder**, install the software, then link:

```sh
git clone <repo-url> ~/dotfiles
cd ~/dotfiles

brew bundle --file=Brewfile        # 1. install the software the configs configure
./install.sh                       # 2. recreate every symlink
sudo ~/.config/kanata/install-services.sh   # 3. keyboard remapping services
```

Then **grant permissions by hand** — kanata needs Input Monitoring *and*
Accessibility, skhd needs Accessibility. See the kanata section above for why
none of this can be scripted.

Order matters: `install.sh` only creates symlinks, so running it first leaves
configs pointing at software that isn't installed yet. Skipping step 3 leaves
you with no keyboard remapping and no obvious error explaining why.

`install.sh` backs up anything already sitting at each target (as
`*.pre-dotfiles.<timestamp>`) before linking, and is safe to re-run. It's
self-locating (finds its own directory via `BASH_SOURCE`), so it works from
whatever path you cloned into — but see the note below on *where* to clone.

The `Brewfile` is a deliberately minimal list of essentials, with a comment
block at the bottom recording what was *intentionally* left out and why. On the
same Mac a second account doesn't need it (Homebrew is shared at
`/opt/homebrew`); it's insurance for a clean wipe or a different machine.

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
