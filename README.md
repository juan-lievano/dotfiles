# dotfiles

Personal config backup. The real files live here in `~/dotfiles`; each is
**symlinked** back to where the app expects it, so nothing changed about how
the machine works — editing `~/.zshrc` and `~/dotfiles/.zshrc` is the same file.

Two companion files: **`NOTES.md`** is the running log of what's still *open* —
experiments awaiting a verdict, decisions deferred, questions only real use can
answer. Settled things live here in `README.md` instead.
**`.config/kanata/LAYOUT.md`** draws every keyboard layer, which is the one
thing prose is bad at.

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
| `.config/skhd/`            | `~/.config/skhd/`       | app launcher + Ctrl-`<key>` rewrites |
| `.config/wezterm/`         | `~/.config/wezterm/`    | terminal config                |
| `.config/ghostty/`         | `~/.config/ghostty/`    | terminal config (trial, ported from wezterm) |
| `.config/qalculate/`       | `~/.config/qalculate/`  | calculator prefs               |
| `.config/aerc/aerc.conf`   | `~/.config/aerc/aerc.conf`  | aerc (email) main config   |
| `.config/aerc/binds.conf`  | `~/.config/aerc/binds.conf` | aerc keybindings           |
| `.w3m/keymap`              | `~/.w3m/keymap`         | w3m keys (aerc HTML viewing)   |
| `.claude/settings.json`    | `~/.claude/settings.json` | Claude Code settings         |
| `.claude/keybindings.json` | `~/.claude/keybindings.json` | Claude Code key bindings  |
| `.claude/CLAUDE.md`        | `~/.claude/CLAUDE.md`   | global instructions for Claude |
| `.claude/statusline-command.sh` | `~/.claude/statusline-command.sh` | statusline renderer |

aerc is linked **per file**, not per directory: its credentials file
(`accounts.conf`) lives beside these in `~/.config/aerc/` and must stay out of
the repo (it's gitignored as a second line of defense; the password itself is
in the macOS Keychain). aerc only looks in `~/.config` because `.zprofile`
exports `XDG_CONFIG_HOME` — without it, aerc on macOS uses
`~/Library/Preferences`.

Claude Code is linked **per file** for the same reason: `~/.claude` is mostly
runtime state — `sessions/`, `history.jsonl` (full prompt transcripts),
`projects/`, caches and daemon logs — none of which belongs in git. Nor does
`~/.claude.json`, which despite the name is machine state (OAuth account,
`machineID`, per-project history), not config. Project-level
`.claude/settings.local.json` is gitignored as machine-specific.

Claude rewrites `settings.json` itself when you change something via `/config`,
and that is safe here: for **user**-scope settings it resolves the symlink and
renames its temp file onto the real target in this repo, so the link survives
and the edit is tracked. (Repo-scope settings get the opposite treatment — it
refuses to write through a symlink at all, which is also why
`permissions.defaultMode: "auto"` is only honoured from user settings.)

Paths in `settings.json` use `~`, not `/Users/<name>`, so the file survives a
move to a machine with a different username. Tilde is expanded in permission
rules and in `additionalDirectories` (verified against a no-rule control that
denies), and in the `statusLine` command, which runs through a shell.

Secrets (`~/.ssh`, API tokens, etc.) are deliberately **not** here.

## Keyboard remapping (kanata)

> **Every layer is drawn in [`.config/kanata/LAYOUT.md`](.config/kanata/LAYOUT.md).**
> Read that first if you want to know *what a key does*; read this section for
> *why*. Open questions about the current setup are in
> [`NOTES.md`](NOTES.md).

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

### Two alpha layouts: QWERTY and Colemak-DH (hold Right Option, tap `\`)

```
tab   q w f p b   j l u y ;   [ ] \
ctrl  a r s t g   m n e i o   ' ret
z     x c d v _   k h , . /   shift
```

Colemak-DH with the **left-hand angle mod**: the left bottom row slides one key
left onto Left Shift, so it's reached at an angle instead of a claw. Physical
`lsft z x c v` type `z x c d v`, and physical `b` falls off the end with nothing
to fill it — `b` lives on physical `t` in Colemak-DH, and the index-inward
stretch has no other claimant. It's left dead on purpose, so a mis-reach during
the transition is silent rather than quietly typing a letter.

Left Shift becoming `z` is `tap z / hold Shift`, not a plain `z`. That looks
like the fussier option and is actually the cheaper one: with a plain `z` the
only left Shift left is hold-`a`, which is *already* a 200ms tap-hold, so
nothing is gained and the pinky Shift is lost for free. The price is that `z`
loses key repeat and dawdling past 200ms fires Shift. It does **not** interfere
with `<hold m>z` → Tab — a held layer replaces the base action outright, so the
tap-hold underneath is never consulted.

Almost nothing else moves. Home row mods keep their positions and their
Shift/Ctrl/Opt/Cmd order, and only change which letter they tap (`a r s t` /
`n e i o`). The function row, number row, Caps-as-Ctrl, the three thumb layer
keys, the nav layer and the *entire right half* of the symbol layer are all
shared verbatim. Two things do move:

- **The symbols layer's left half angles too**, since it sits on the bottom row
  that shifted — `tab [ ] ` `` land on `lsft z x c`. That's a second deflayer
  (`symbols-cmk`), but no second switch: the active base layer picks which one
  Space opens. Its right half is a byte-for-byte copy, because the numpad there
  is positional.
- **The Ctrl rewrites follow the letter, not the key.** Colemak swaps `h` and
  `m`, so Ctrl-Delete moves to physical `m` and Ctrl-Return to physical `h` —
  the two forks simply trade physical keys. Ctrl-`[` → Esc needs no twin (`[`
  doesn't move) and neither does Ctrl-`;` → `~`, which follows `;` to physical
  `p` by itself because `defoverrides` matches on *output* keys.

The toggle is one key rather than a force-QWERTY / force-Colemak pair, which
costs exactly one thing: nothing tells you which layout is live. The tell is
that you start typing garbage; the fix is to press it again. kanata boots into
QWERTY because `base` is the first deflayer, so a restart — including the one
after a Homebrew upgrade breaks the service — is always a known state.

This is scoped to the built-in keyboard along with everything else here. The
Voyager's layout lives in its own firmware and is unaffected.

### The layers live on the thumbs

The Voyager holds both of its layers with a thumb. This now matches it 1:1:

| key | tap | hold | Voyager |
|-----|-----|------|---------|
| Space | Space | symbol + number layer | `LT(1, KC_SPACE)` |
| Right Cmd | Return | nav layer | `LT(2, KC_ENTER)` |
| Right Option | — | real F1–F12, layout toggle | (its Hyper thumb key) |

They used to sit on the right index — hold `m` for symbols, hold `n` for nav —
which is precisely what forced every payload onto the left hand, since the right
one was busy holding the layer open. On a thumb both hands are free, and that's
the whole unlock: the symbol layer can carry the Voyager's numpad.

Physical Right Cmd and Right Option are consumed. Both modifiers survive
elsewhere — Cmd on physical Left Cmd and on the home row mods of either hand,
Opt on physical Left Option and likewise.

> ⚠️ **This puts a layer on the most-pressed key on the board.** Any Space press
> held past 200ms now opens the symbol layer. The Voyager has run exactly this
> arrangement without trouble, which is the argument for trying it, but it's the
> one part of this design that could prove to be a mistake in daily use. The
> cheap knob if it misfires is a longer hold time on **Space alone** — write a
> literal `250` in place of `$hold-time` in `@spc`/`@spck` and leave every other
> timing at 200, since Space is the only key whose hold fights ordinary prose.
> The expensive fix is moving symbols back off the thumb, which costs the
> numpad. Space also loses key repeat, though it already had under the old
> launcher.

#### The symbol layer (hold Space)

```
  ! @ # $ %        -  7 8 9 =         q w e r t  |  y u i o p
  ^ & * ( )        +  4 5 6 *         a s d f g  |  h j k l ;
tab [ ] `          .  1 2 3 /         z x c v    |  n m , . /
                         0                       |  right thumb
```

Left hand types symbols, right hand types a real numpad — the Voyager's Sym+Num
layer, both halves. The left half is the shifted number row in order, which is
why the config writes it `S-1`..`S-0` rather than as literal glyphs.

The right half is **positional**: physical `u i o` / `j k l` / `m , .` spell
`789` / `456` / `123` in either alpha layout, so it's duplicated verbatim
between `symbols` and `symbols-cmk` and the two must be edited together. In
Colemak letters it reads `l u y` / `n e i` / `h , .` for the digits, with
`k m j` giving `.` `+` `-` and `/ o ;` giving `/` `*` `=`.

`0` sits on Right Cmd — the right thumb, where the Voyager puts it, and where a
real numpad puts it. That doesn't conflict with Right Cmd being the nav key: a
held layer's entry replaces the base action outright, so the tap-hold underneath
is never consulted while Space is down.

Digits used to be reachable **only as Shift + a left-hand glyph**, through ten
`@sy1`..`@sy0` forks that peeled the pre-applied Shift back off with `unmod`.
All ten are gone, and with them the awkward rule that Shift then had to come
from `;` or a physical Shift key. `x c v` still give `` { } ~ `` for free, since
`` [ ] ` `` are unshifted and a held Shift produces the other half on its own.

The right hand keeps its home row mods on the numpad (`@np4`..`@npx` — Cmd, Opt,
Ctrl under `4 5 6`, Shift under `*`), mirroring `MT(MOD_RGUI, KC_4)` and friends
in the firmware, so modifiers stay chordable without leaving the layer. Chordal
hold settles a roll like `456` as taps, so digits are no slower than letters;
the cost is that holding one no longer repeats it. The left hand's mods are
shadowed on purpose — that half is for typing, not chording.

#### The nav layer (hold Right Cmd)

Arrows on `a s d f` (← ↓ ↑ →), `hjkl` order moved one hand over. Shared verbatim
by both alpha layouts, since the arrows are positional.

Moving the layer key to the thumb bought this layer a key back. `j` used to sit
under the very finger holding the layer open and was physically unpressable; it
now carries Right Cmd — which is what the Voyager has there (`KC_RIGHT_GUI`) —
so Cmd-Left/Right for line ends works from inside the layer instead of needing
physical Left Cmd. `j`/`k`/`l`/`;` are **replaced** by plain Cmd/Opt/Ctrl/Shift
rather than left transparent, so Opt-Left, Ctrl-Left and Shift-Left fire
instantly instead of waiting out the mod-taps underneath. The Voyager does the
same. The cost is that those four can't be tapped for their letters while
navigating.

#### What the thumb move deleted

Two aliases and a genuinely nasty workaround disappeared, which is the best
evidence that thumbs are the right shape for this:

- **`@symm` and `@symh` are gone.** Whichever physical key was *also* the layer
  key had to wrap its tap-hold inside the Ctrl `fork` and resolve on press,
  because as a tap action the fork fired on release and read Ctrl at the wrong
  instant — releasing `s` a hair early typed a literal `m`. That cost the key
  its repeat and made a held Ctrl repeat Return/Delete instead of opening the
  layer. Both now collapse into the plain `@ctlh` / `@ctlm` forks that already
  existed; they just trade physical keys between the two layouts.
- **`@navn` / `@navk` are gone**, so physical `n` is an ordinary letter again —
  key repeat back, no 200ms tap-hold, no mid-word hesitation opening nav.
- **`@app1`..`@app7` are gone** — see the launcher section below.

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

Real F1–F12 are on the `launch` layer: **hold Right Option, press the key**. `fn` is
deliberately left unmapped — grabbing it as the F-key modifier would consume it
and kill fn+arrows, fn+Delete, and the globe/emoji picker.

Four pieces, none of which start themselves:

| layer | what it is | started by |
|-------|------------|------------|
| dext (kernel driver) | Karabiner's VirtualHIDDevice | the `karabiner-elements` cask |
| VirtualHIDDevice daemon | userspace half of the driver | `org.pqrs.karabiner-vhid-daemon.plist` |
| kanata | the remapper itself | `brew services` (runs as root) |
| skhd | catches Hyper+N (from either keyboard), launches apps | `skhd --start-service` (runs as user) |

`sudo ~/.config/kanata/install-services.sh` installs the daemon plist and starts
kanata; it's idempotent, and `--uninstall` reverses it.

**Keep the `karabiner-elements` cask installed**, even though nothing here uses
Karabiner-Elements itself. kanata has no virtual keyboard of its own — macOS
exposes no public API for synthesizing HID input at that level — so it emits
through pqrs's DriverKit VirtualHIDDevice, and the cask is just the delivery
vehicle for that driver.

Karabiner-Elements.app can stay closed. It normally starts the VirtualHIDDevice
daemon and takes it down on quit, which would leave kanata failing with
`connect_failed asio.system:61` — installing the daemon as its own LaunchDaemon
(`org.pqrs.karabiner-vhid-daemon.plist`) is what decouples the two, and is
exactly why that plist exists. The dependency that remains is on the driver, not
the app: if the dext or its daemon goes down, kanata goes down with it.

The app launcher needs **no kanata support at all**. skhd binds the raw chord
(`cmd + ctrl + alt + shift - 1`) and runs `.config/skhd/open-app-slot.sh`
(the single source of truth for app names). Hyper is simply all four home
row mods held together — `a s d f` in QWERTY, `a r s t` in Colemak — then a
digit on the number row. The Voyager sends the same chord from a thumb key in
firmware, so one skhd binding serves both keyboards with nothing in between.

kanata used to convert `Space`-hold + N into Hyper+N via a row of `@app1`..
`@app7` aliases emitting `M-A-C-S-<n>`. Space is the symbol layer now, and that
row was in any case a second path to a keystroke the home row already produces,
so it's deleted. Homebrew builds kanata without the `cmd` feature, so it could
never have run the script itself — and skhd running as a normal user agent means
`open -a` works without any root workaround.

**Hyper+H starts (and stops) macOS Dictation.** That is not an skhd line: the
chord is set as the Dictation shortcut itself in System Settings > Keyboard >
Dictation, so macOS catches it from either keyboard and pressing it again (or
Esc) stops listening. It needed one kanata change: `h` on the laptop is
`@ctlh` (Ctrl-H → Delete), and Hyper contains Ctrl, so a plain fork turned
Hyper-H into Cmd-Opt-Shift-Delete before it ever left the keyboard. `@ctlh` is
now a `switch` that passes `h` through untouched when all four mods are held.
Any *other* letter would need the same treatment only if it has a Ctrl fork
(`h`, `[`, `m`); and it has to be a right-hand key, because a left-hand letter
pressed while `a s d f` are held is a same-hand roll and chordal hold resolves
the mods as taps.

Note one interaction: Hyper is `a s d f`, and those four are *shadowed* while
the symbol layer is up. If you ever want Hyper plus a **numpad** digit, press
the home row keys first and Space second. Hyper plus the **number row** involves
no layer at all and is the ordinary path.

### skhd also carries the Ctrl-`<key>` rewrites, for the Voyager

kanata is scoped to the **built-in keyboard only** (`macos-dev-names-include`),
because the Voyager runs its own QMK home row mods and letting kanata re-process
them would double up. The consequence is easy to forget: every rewrite defined
in `kanata.kbd` — `@ctlh` (Ctrl-H → Delete, Ctrl-Opt-H → delete word,
Ctrl-Cmd-H → delete line), `@ctlb` (Ctrl-[ → Esc), the Ctrl-M fork, the Ctrl-;
override — **exists only on the laptop**. On the Voyager the chord resolves in
firmware and leaves as a literal Ctrl-Opt-H, which macOS does not understand.

It doesn't compose on its own, which is the counter-intuitive part. macOS
resolves text commands by **one exact-chord lookup** in AppKit's
`StandardKeyBinding.dict`. `^h` and `^?` are separate rows both landing on
`deleteBackward:`, and `~^?` lands on `deleteWordBackward:` — but there is no
`~^h` row at all. Ctrl-H is not "the Delete key with Option applied on top"; it
is its own entry, so Option has nothing to modify.

`skhdrc` closes the gap by rewriting at the event-tap level, which sits above
the keyboard driver and is therefore keyboard-blind. It can't double-fire on the
laptop: kanata rewrites *below* that tap, so skhd only ever sees the already
converted keystroke.

#### ⚠️ This works partly by luck — read this before extending it

skhd's `-k` **synthesizes** a new event and posts it to `kCGHIDEventTap`, which
re-merges the modifiers you are still **physically holding**. So the Ctrl you're
holding rides along into the replacement event. Ctrl-Opt-H survives only because
the dict happens to carry a *second* row — `~^^?` (Ctrl-Opt-Delete) — that also
lands on `deleteWordBackward:`. Nothing about the design guarantees that.

Adding a rewrite whose target has only **one** row will therefore fail, and this
is not hypothetical: Ctrl-Cmd-H is exactly that case. `@^?` is the only row for
`deleteToBeginningOfLine:`, so the leaked Ctrl makes it unbound. It works in GUI
apps because Cmd-Backspace is reached some other way, but the pattern is real.

Before blaming this, check the two things that are **expected** and unfixable:

| Symptom | Why | Verdict |
|---------|-----|---------|
| Ctrl-Cmd-H doesn't delete a line in the terminal | legacy key encoding has no bit for Cmd; dropped downstream of skhd | can never work, also fails from the laptop |
| Ctrl-Opt-H doesn't delete a word in the terminal | arrives as `ESC DEL`, and `.zshrc` runs `bindkey -v` with `KEYTIMEOUT=1`, so `^[` is eaten instantly as vi-cmd-mode | by design — use `^W` / `^U` in here |

**Verified:** Safari (native Cocoa text fields), macOS 15.
**Not verified — check here first if something misbehaves:**
- **Electron/Java apps** (VS Code, Slack, Discord, JetBrains) implement their own
  key handling and may not honor `~^^?`. The leaked Ctrl is the likely culprit.
- **Key repeat.** Holding Ctrl-H to backspace continuously may not repeat, since
  each press forks a short-lived `skhd -k`.

The real fix, if any of this turns into a recurring annoyance, is to stop
synthesizing and **rewrite the in-flight event instead** — take the keydown,
change its keycode and clear Ctrl from its flags, pass it through. That's what
kanata's `unmod` does and why the laptop has none of these problems.
Hammerspoon can do it in a few lines and would replace all seven `skhdrc` lines
with one generic rule. It was not done now because nothing was actually broken.

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
