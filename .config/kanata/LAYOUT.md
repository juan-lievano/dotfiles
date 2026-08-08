# Layout reference

Every layer in `kanata.kbd`, drawn. The `deflayer` grids in the config itself
are in **defsrc physical order**, which tells you where a key sits but is hard
to read as a layout; this file is the at-a-glance version. `kanata.kbd` remains
the source of truth — if the two disagree, the config is right and this is
stale.

Scope: the **built-in MacBook keyboard only**. The Voyager runs its own QMK
firmware and none of this applies to it (`macos-dev-names-include` in the
config). The two are deliberately kept in sync by hand; the rightmost column of
the last table says where each piece comes from.

`│` marks where the right hand starts. The bottom line of each grid is the thumb
row. `·` is transparent (falls through to the layer underneath).

---

## The thumb keys

Three keys carry every layer. This is the spine of the whole design, and it
mirrors the Voyager's `LT()` thumbs one for one.

| key | tap | hold |
|-----|-----|------|
| **Space** | Space | `symbols` / `symbols-cmk` |
| **Right Cmd** | Return | `nav` |
| **Right Option** | — | `launch` |

Physical Right Cmd and Right Option are consumed as modifiers. Both survive on
their left-hand physical keys and on the home row mods of either hand.

---

## `base` — QWERTY

```
 esc   br-  br+  msn  spot  --   --  │  ⏮   ⏯    ⏭   mute vol- vol+
  `     1    2    3    4    5        │  6    7    8    9    0    -    =   bspc
 tab    q    w    e    r    t        │  y    u    i    o    p    [    ]    \
 ctrl   A    S    D    F    g        │  h    J    K    L    :    '   ret
 shift  z    x    c    v    b        │  n    m    ,    .    /   shift
                ctrl  opt  cmd  SPACE│ RET   FN
```

Home row mods (`A S D F` / `J K L :` above), Cmd innermost:

```
   a    s    d    f                       j    k    l    ;
 shift ctrl opt  cmd                     cmd  opt ctrl shift
```

Caps Lock is Ctrl. The function row is remapped **back** to macOS media keys —
that's a repair, not a preference; see the long note in `kanata.kbd`. F5 and F6
stay dead because they have neither an HID usage kanata can emit nor a default
shortcut.

Ctrl rewrites on this layer: `h` → Delete, `m` → Return, `[` → Esc, `;` → `~`.

## `colemak` — Colemak-DH, left-hand angle mod

```
 esc   br-  br+  msn  spot  --   --  │  ⏮   ⏯    ⏭   mute vol- vol+
  `     1    2    3    4    5        │  6    7    8    9    0    -    =   bspc
 tab    q    w    f    p    b        │  j    l    u    y    ;    [    ]    \
 ctrl   A    R    S    T    g        │  m    N    E    I    O    '   ret
  z     x    c    d    v   (XX)      │  k    h    ,    .    /   shift
                ctrl  opt  cmd  SPACE│ RET   FN
```

The **angle mod** slides the left bottom row one key left onto Left Shift, so
it's reached at an angle instead of a claw. That key is `tap z / hold Shift`,
not a plain `z` — with a plain `z` the only left Shift left would be hold-`a`,
which is already a 200ms tap-hold, so the pinky Shift would be lost for nothing.

`(XX)` is physical `b`, deliberately **dead**. Colemak-DH puts `b` on physical
`t` and the index-inward stretch has no other claimant, so a mis-reach there is
silent rather than quietly typing a letter.

Home row mods keep their positions and their Shift/Ctrl/Opt/Cmd order; only the
tapped letters change (`a r s t` / `n e i o`).

Ctrl rewrites follow the **letter**, not the key, so the two forks trade
physical keys: physical `h` (= letter `m`) → Return, physical `m` (= letter `h`)
→ Delete.

**Toggle between the two layouts: hold Right Option, tap `\`.** Nothing signals
which is live — the tell is that you start typing garbage, and the fix is to
press it again. kanata boots into QWERTY, because `base` is the first deflayer.

---

## `symbols` / `symbols-cmk` — hold Space

The Voyager's Sym+Num layer, both halves: symbols left, a real numpad right.

```
  ·     ·    ·    ·    ·    ·    ·   │  ·    ·    ·    ·    ·    ·
  ·     ·    ·    ·    ·    ·        │  ·    ·    ·    ·    ·    ·    ·    ·
  ·     !    @    #    $    %        │  -    7    8    9    =    ·    ·    ·
  ·     ^    &    *    (    )        │  +    4    5    6    *    ·    ·
  ·    tab   [    ]    `    ·        │  .    1    2    3    /    ·
                 ·    ·    ·   held  │  0    ·
```

`symbols-cmk` is identical except that the bottom-left four slide one key left
with the angle mod — `tab [ ] ` `` land on `lsft z x c` instead of `z x c v`.
**The right half is byte-identical in both** and must be edited in both places
together.

The numpad is **positional**: physical `u i o` / `j k l` / `m , .` spell
`7 8 9` / `4 5 6` / `1 2 3` whichever alpha layout is live. In Colemak letters
that reads:

```
   j    l    u    y    ;                -    7    8    9    =
   m    n    e    i    o     ---->      +    4    5    6    *
   k    h    ,    .    /                .    1    2    3    /
```

`0` is on **Right Cmd**, the right thumb — where the Voyager puts it and where a
real numpad puts it. That doesn't conflict with Right Cmd being the nav key: a
held layer's entry replaces the base action outright, so the tap-hold underneath
is never consulted while Space is down.

The right hand keeps its home row mods on the numpad, so modifiers stay
chordable without leaving the layer:

```
   4    5    6    *
  cmd  opt ctrl shift
```

The left hand's mods are shadowed on purpose — that half is for typing, not
chording. Consequence for the launcher: Hyper is `a s d f`, which is shadowed
here, so if you ever want Hyper plus a *numpad* digit, press the home row keys
first and Space second.

`x c v` still give `` { } ~ `` for free — `` [ ] ` `` are unshifted keys, so a
held Shift produces the other half on its own. The digits need no such trick any
more; they are literal.

> ⚠️ This puts a layer on the most-pressed key on the board. Any Space press
> held past 200ms opens it. If that misfires in practice, the cheap knob is a
> literal `250` in place of `$hold-time` in `@spc`/`@spck` **only** — Space is
> the one key whose hold competes with ordinary prose.

---

## `nav` — hold Right Cmd

```
  ·     ·    ·    ·    ·    ·    ·   │  ·    ·    ·    ·    ·    ·
  ·     ·    ·    ·    ·    ·        │  ·    ·    ·    ·    ·    ·    ·    ·
  ·     ·    ·    ·    ·    ·        │  ·    ·    ·    ·    ·    ·    ·    ·
  ·     ←    ↓    ↑    →    ·        │  ·   cmd  opt  ctrl shift ·    ·
  ·     ·    ·    ·    ·    ·        │  ·    ·    ·    ·    ·    ·
                 ·    ·    ·    ·    │ held  ·
```

Arrows in `hjkl` order moved one hand over. Shared verbatim by both alpha
layouts, since the arrows are positional and the four right-hand keys are plain
modifiers.

Those four are **replaced**, not left transparent, so Cmd-Left, Opt-Left,
Ctrl-Left and Shift-Left fire instantly instead of waiting out the mod-taps
underneath. The Voyager does the same (literal `KC_RIGHT_GUI` etc., not
mod-taps). The cost is that they can't be tapped for their letters while
navigating.

`j` carrying Cmd is new: it used to sit under the very finger holding the layer
open and was physically unpressable. Moving the layer key to the thumb freed it.

## `launch` — hold Right Option

```
 ·     F1   F2   F3   F4   F5   F6   │ F7   F8   F9  F10  F11  F12
 ·      ·    ·    ·    ·    ·        │  ·    ·    ·    ·    ·    ·    ·    ·
 ·      ·    ·    ·    ·    ·        │  ·    ·    ·    ·    ·    ·    ·   TOG
 ·      ·    ·    ·    ·    ·        │  ·    ·    ·    ·    ·    ·    ·
 ·      ·    ·    ·    ·    ·        │  ·    ·    ·    ·    ·    ·
                ·    ·    ·    ·     │  ·   held
```

The real F1–F12, since the base function row is media keys. `TOG` on `\` is the
QWERTY/Colemak toggle, put far from everything else because a stray press means
typing garbage until you notice.

`fn` is deliberately left unmapped — grabbing it as the F-key modifier would
consume it and kill fn+arrows, fn+Delete and the globe/emoji picker.

The name is now a small lie: this layer no longer launches anything.

---

## The app launcher (no layer)

**Hold `a s d f` together (`a r s t` in Colemak) for Hyper, then a number-row
digit.** All four home row mods at once *is* Hyper; skhd binds the raw
`cmd + ctrl + alt + shift - N` chord and runs
`.config/karabiner/open-app-slot.sh`, which is the single source of truth for
app names.

kanata is not in the path at all. This is also the only launcher route the
Voyager can share, since it sends the same chord from firmware.

---

## Cross-reference with the Voyager

`zsa_voyager_*_source/.../keymap.c`, layout `waLwq`.

| here | Voyager |
|------|---------|
| Space → symbols | `LT(1, KC_SPACE)` — left thumb |
| Right Cmd → nav, `0` on symbols | `LT(2, KC_ENTER)`, `KC_0` on layer 1 |
| Right Option → launch | its `ALL_T(KC_BSPC)` Hyper thumb |
| `4 5 6 *` mod-taps | `MT(MOD_RGUI, KC_4)`, `MT(MOD_RALT, KC_5)`, `MT(MOD_RCTL, KC_6)` |
| nav's `j k l ;` | `KC_RIGHT_GUI / ALT / CTRL / SHIFT`, layer 2 |
| `tap-hold-tap-keys`, 200/200 | Chordal Hold, `TAPPING_TERM` / `QUICK_TAP_TERM` 200 |
| angle mod, dead `b` | same |

**Not ported.** The Voyager's layer 2 also carries mouse keys, media transport,
Home/End/PgUp/PgDn and volume; only the arrows and the four right-hand modifiers
came across. Its layer 1 puts F1–F12 on the number row, where here they live on
`launch` instead.

Anything retuned here should be retuned in Oryx as well, or the two keyboards
stop feeling alike.
