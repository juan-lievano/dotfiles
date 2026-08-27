# Notes

Running log of things in flight: experiments that need a verdict, decisions
deferred, and questions that only real use can answer. Dated, newest first.

Settled decisions do **not** belong here — they go in `README.md` or in the
config's own comments. This file is for what is still open. Delete an entry
when it's resolved, and fold the answer into the docs.

---

## 2026-08-18 — dictation went deaf; fixed by restarting the speech daemons

Symptom: the mic popup appears (Hyper-H works), the level bar in it doesn't
move, no text lands — in every app, Safari included. Not permissions, not
kanata, not the mic: `log show` showed `corespeechd` receiving audio and the
recognizer failing every session with `kAFAssistantErrorDomain Code=1110`
("no speech detected"). Apple's on-device speech stack was simply wedged.

The fix, no sudo, no reboot, both relaunch on their own:

    killall corespeechd localspeechrecognition

Escalation if that ever isn't enough: toggle Dictation off/on in
System Settings ▸ Keyboard, then a reboot.

### ⚠️ Watch: does it recur?

If this needs doing more than once in a while, promote it to an alias in
`.zshrc` — `alias fixdictation="killall corespeechd localspeechrecognition"` —
and move this entry into `README.md`. Deliberately not added yet: one
occurrence doesn't earn a line in the shell config.

Two facts learned along the way, worth not re-discovering:

- **Lid closed = built-in mic is dead.** Apple Silicon hardware-disconnects
  the internal mic in clamshell; it records pure zeros. In clamshell the C922
  webcam is the *only* live mic, so if it's unplugged dictation has nothing.
- **The C922 has a loud ~70 Hz hum** (louder than speech at normal distance).
  Recognition copes today; if dictation gets flaky or misses words, suspect
  the hum first — different USB port, or a real mic — before suspecting macOS.

---

## 2026-08-09 — idea: wide mod (not started)

Shift the right hand one physical column right, laptop only. The point: the
right thumb then rests on Right Cmd, turning the nav/Return key into a true
thumb key like the Voyager's Enter thumb — and the hands sit a little further
apart on a cramped slab. Same idea as DreymaR's Wide mod.

Why it wouldn't break Voyager parity: finger assignments are untouched — every
finger keeps its letters and its layer entries; only the physical keys under
the right hand change. Per-finger muscle memory carries over.

**Scope: Colemak only.** QWERTY stays exactly as it is — layers and all, it's
already fine for a guest — so the wide shift, the right-Shift drop, and any
future remodeling land only in the Colemak layers.

Costs and unknowns, roughly in order of pain:

- **Can a thumb actually REST on a laptop key?** The Voyager's thumb keys take
  real force; the Air's scissor switches are shallow and light, so "resting"
  may turn out to mean hovering, which is no rest at all. This is the make-or-
  break unknown, and only trying it answers it.
- **The `j` homing bump is lost** — the right index lands on an unbumped `k`.
  Cheap fix: a tactile dot sticker on `k`.
- **Row overflow at the right edge — decided.** The home row gains (`'` ends
  up beside Return). On the bottom row, `/` lands on physical right Shift as a
  plain key and **right Shift disappears** — home row Shift (hold `;` / `o`)
  covers it, so the physical key isn't worth preserving. If a right pinky
  Shift is ever missed, the fallback is the angle mod's own trick mirrored:
  tap `/` / hold Shift, same shape as @cmz, at the cost of `/` key repeat.
- **Every deflayer's right half shifts with the hand** — symbols' numpad, nav,
  both alpha layouts. Mechanical, but all-or-nothing: shifting the alphas
  without the layers would split muscle memory between the boards.
- **The freed middle column** (physical `y h n`) needs a decision: symbols, or
  dead during the transition like Colemak's `b`.

Sequencing: not while two watch items are already open (Space-hold misfires,
caps-Ctrl). One experiment at a time, or a misfire can't be attributed.

---

## 2026-08-09 — kanata: nav layer fully ported, Caps Lock is Esc

Two changes, independent of each other:

- **Nav layer carries the rest of the Voyager's layer 2** — Home/PgUp/PgDn/End
  on the inner column, Ctrl-Shift-Tab / Ctrl-Tab on `n`/`m`, media transport
  and volume on the right hand. Mouse keys deliberately skipped (trackpad;
  settled, documented in the config and LAYOUT.md).
- **Caps Lock is a plain Esc, no longer Ctrl.** Voyager parity — it has
  `KC_ESCAPE` in that position. Ctrl now comes only from the home row mods and
  physical bottom-left Ctrl.

### ⚠️ Watch: do the fingers miss caps-Ctrl?

The old escape hatch for Ctrl-chords was Caps, usable with either hand. Now a
Ctrl-chord is either an opposite-hand home row hold (200ms) or a pinky reach to
the corner. If corner-Ctrl keeps happening for common chords (Ctrl-W, Ctrl-H),
that's the sign the hatch was earning its spot — the revert is swapping `esc`
back to `lctl` at the caps position in both alpha deflayers.

---

## 2026-08-08 — kanata: layers moved onto the thumbs

Commit `f3d8275`. Space-hold is now the symbol layer, Right Cmd is nav, Right
Option is the F-keys. Working on day one. **Revert target if it goes bad:
`git revert f3d8275`** — though since the nav-layer completion (2026-08-09
entry above) builds on it, that revert now needs conflict resolution rather
than applying clean.

### ⚠️ Watch: does Space-hold misfire?

The one that actually matters. A layer now sits on the most-pressed key on the
board, and any Space press held past 200ms opens it. The Voyager has run
exactly this arrangement without trouble, which is the whole argument for
trying it — but the Voyager's Space is a dedicated thumb key on a split board,
not a wide bar under a hand that rests differently.

Give it a few days of real prose, not just config editing. Failure looks like:
a stray `!` or `7` mid-sentence, or a space that doesn't appear.

Escalation order, cheapest first:

1. **Longer hold on Space alone.** Write a literal `250` (or `300`) in place of
   `$hold-time` in `@spc` and `@spck` only. Leave every other timing at 200 —
   Space is the single key whose hold competes with ordinary typing, so it's
   the only one that plausibly wants a different tapping term. This diverges
   from the Voyager, so note it in Oryx if it sticks.
2. **Revert the commit**, which costs the numpad and puts symbols back on the
   right index.

Also gone either way: Space no longer key-repeats. (It already didn't, under
the old launcher, so this isn't new — just worth not re-discovering.)

### Hyper + numpad needs a press order

Hyper is `a s d f` (`a r s t` in Colemak), and those four are **shadowed** on
the symbol layer. So Hyper plus a *numpad* digit only works if you press the
home row keys first and Space second.

Hyper plus the *number row* involves no layer at all and is unaffected — that's
the ordinary launcher path and it's fine.

Open question: is this ever actually annoying? If it is, the fix is to keep
left-hand mod-taps live on the symbol layer (the Voyager does — `^ & * (` are
mod-taps there), at the cost of key repeat on those four symbols.

### Smaller loose ends

- **Physical `b` is dead (`XX`) in Colemak.** Deliberate, so a mis-reach during
  the transition is silent rather than typing a letter. Once the layout is
  automatic, decide whether to leave it dead or make it `v` (a doubled letter
  being less annoying than a dead key). No rush — this is a transition aid.
- **The `launch` layer no longer launches anything.** It's F-keys and the
  layout toggle. Rename if it ever causes confusion; not worth the churn now.
- **Ctrl-N / Ctrl-P → Down / Up is still undecided**, and has been for a while.
  Written and commented out in `kanata.kbd` with the full trade-off. Costs nvim
  insert-mode keyword completion; moot if Raycast ever replaces Spotlight,
  since Raycast navigates with Ctrl-N/P natively. Decide or delete.
