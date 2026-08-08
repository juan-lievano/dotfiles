# Notes

Running log of things in flight: experiments that need a verdict, decisions
deferred, and questions that only real use can answer. Dated, newest first.

Settled decisions do **not** belong here — they go in `README.md` or in the
config's own comments. This file is for what is still open. Delete an entry
when it's resolved, and fold the answer into the docs.

---

## 2026-08-08 — kanata: layers moved onto the thumbs

Commit `f3d8275`. Space-hold is now the symbol layer, Right Cmd is nav, Right
Option is the F-keys. Working on day one. **Revert target if it goes bad:
`git revert f3d8275`** — nothing else depends on it.

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

### The Voyager's nav layer is only half ported

Its layer 2 also carries mouse keys, media transport, Home/End/PgUp/PgDn and
volume. Only the arrows and the four right-hand modifiers came across.

Not obviously worth porting — the laptop has a trackpad a few centimetres away,
and the media keys are already on the function row. Revisit only if reaching
for them on the Voyager and finding them missing here becomes a real friction.

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
