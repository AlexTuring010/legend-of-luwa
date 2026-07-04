# 0004 — CaveD mummy room: the "ding walls" are an unbreakable brick‑MONSTER divider

- **Status:** Confirmed in‑game (isolated overlay test) **and in the game's code** (Ghidra decompilation)
- **Date:** 2026-07-04
- **Tags:** cave, qinglong, mummy, mBrickHA, invincible-wall, divider, ding, monster-gate, design
- **Related:** corrects [#0003](0003-caved4-bomb-gated-secret-qinglong.md); [#0002](0002-hidden-room-dun4021-grandma-cell.md)

## Summary

In the QingLong cave (**CaveD**, the room with the **pink mummy**, `mZummyB`), the row of "block
walls" that make the **ding** sound and refuse to break to *any* weapon, bomb, or magic are **not
walls at all** — they are **`mBrickHA` (type `0x133`), a MONSTER that's drawn to look like a row of
bricks.** It's invincible (damage‑immune), so:
- hitting it **dings** (you're attacking an enemy that takes no damage),
- **nothing breaks it — by design** (no sword/bomb/bullet/kungfu, confirmed by exhaustive testing),
- it isn't counted for the "all monsters dead" gate (killing the mummy still flips the music).

So the room was **never** meant to be solved by breaking those blocks. The `mBrickHA` row is a
permanent divider; you go **around** it.

## Evidence

- **Object identity is the record `type`, not the label** (all these walls carry the throwaway label
  `BrickD`). Resolving via `Spc.add`: `type 0x133 → mBrickHA` (the `m` prefix = **monster**). See
  [`research/file-formats.md`](../research/file-formats.md).
- **Isolated in‑game confirmation:** a data overlay that flipped **only** `mBrickHA` (0x133) → passable
  (everything else pristine/solid) made **exactly** the ding‑barrier walk‑through while the ladder,
  sliding block, and every `eBrickHA` wall stayed solid. The player confirmed it directly. This
  pins the ding‑walls to `mBrickHA` with certainty.
- **Player‑verified facts:** no weapon breaks them (tested Fire Sword, Xuan Sword, FireBomb, every
  bullet/bomb); Blood Magic & Run Magic do nothing; killing the mummy alone triggers "all monsters
  dead" (so `mBrickHA` doesn't count — consistent with an invincible/uncounted obstacle).
- One `mBrickHA` object renders as the whole visual row (the reliable `CD`‑delimited count shows the
  room has ~26 objects total, *not* 24 wall objects — the "24 blocks" is one monster drawn as bricks).

## Room mechanics (as understood)

- **Mummy** (`mZummyB`) sits in the right area, behind the `mBrickHA` divider; reachable on foot from
  the right, but the **`StepAU` ladder** yanks you back **up** if you try to return left, and there's
  no gap under it.
- The **"movable thing"** on the left is a **sliding/pushable block** (`eBrickDBSld`, `0x67`) — you
  *push* it (not hit it), and it only becomes movable once **all monsters are dead**.
- The divider (`mBrickHA`) fully separates the mummy side from the left/exit side and **cannot be
  removed**. Bullets can't pass it either.

## The mummy is a "mom" that splits — and *how* you kill it decides respawn (DATA‑CONFIRMED)

The mummy is **`mZummyB`, a splitter ("mom mummy").** Confirmed from `Spc.add`: `mZummyB` (0x16c) and
**only** its child `mZummy` (0x16b) carry a unique spawn property — **`f6 = 0xA000A`, `f7 = 10`** (a
trio of `10`s) — that **no** ordinary monster has (`mRat`, `mBatBig`, `mRabbit` all have `f6=f7=0`).
Their HP field (`f2`) matches a mother/child pair: **mom `mZummyB` = 240, child `mZummy` = 30.**

This is the whole respawn mystery, and **it was never a timer** — it's the **kill method**:

- **Kill it *normally*** → it **splits into ~4 child mummies** (`mZummy`), which you then kill. The
  split is **not** logged as a real death, so the mom **respawns** every time you leave and re‑enter.
  (This is what cost the player hours of confusion.)
- **Kill it in one powerful hit** — e.g. **Power Magic** at full breath (the sword fires beams) — and
  it **dies outright, without splitting.** *That* is recorded as a **permanent kill**: the mummy never
  returns, **even after leaving the cave entirely** (player‑verified).

## Root cause — confirmed in the game's code (Ghidra decompilation of `Luwa.exe`)

Decompiling the executable pins it to the engine's **generic split logic**, not room‑specific code:

- **The split is gated by ONE monster‑definition field, offset `0x128` ("split‑child‑type").** Getter:
  `FUN_0041b680(def) => return *(def + 0x128)`. It is **‑1 for every normal monster**; the mummy is the
  **only** entry in the 517‑type table with it set (the `0xA000A`/`10` props). That's the "bolted‑on"
  field — a late, per‑mob upgrade, exactly as theorized.
- **The split path sets no kill/clear flag.** The mummy's death method `FUN_0040d550` reads that field
  and, if it splits, spawns **`rand()%3 + 2` = 2–4 children** (matching the in‑game "~4"), copies the
  mom's position, adds them to the room's actor list, and **`return 1`** — *that is all it does.* It
  never registers a kill.
- So a normal hit routes the mom through the **split path → the normal‑death code that records the
  permanent kill never runs → her "killed" flag stays unset → she respawns.** A one‑shot kills her
  outright (skips the split) → normal‑death path → flag set → **permanent**, even after leaving the cave.

**It's a *generic* engine oversight, not a hand‑coded room special‑case.** The split‑death path simply
never counts as a "real" kill, and the mummy is the *only* monster that triggers it (only one with
`0x128` set) — which is also why it slipped playtesting. Refines the "they upgraded one mob and forgot
the logic" theory: correct in spirit, but engine‑wide rather than room‑local.

*(Done with Ghidra 12.1.2 on `Luwa.exe`; key functions: `FUN_0040d550` = split, `FUN_0041b680` =
split‑child‑type getter. The Ghidra project + decompiled listing are a local RE artifact, not in this repo.)*

## The solution

**Kill the mom mummy with a no‑split power attack** (Power Magic full‑breath sword‑beam, or any blow
strong enough to kill it before it divides). It dies permanently → now go up, re‑clear level 1, come
back down (or leave and return) and the mummy is **still dead** → walk **left** to the sliding block
(`eBrickDBSld`) and the exit. **The normal split‑kill is the trap; the overkill is the intended path.**

## Open questions

- Exact "no‑split" rule — a raw damage threshold vs the mom's 240 HP, or does the Power Magic beam
  carry a special no‑split flag? (`mZummyB` props: `f6=0xA000A` / `f7=10` are the split params; find
  the threshold/flag field.)
- Where the **permanent‑kill flag** is stored — it survives leaving the cave, so it's saved somewhere
  (likely a not‑yet‑decoded "events/flags" section of the `.sav`).

## Note for the wiki

Two gold gotchas: **(1)** the "ding bricks" are an **invincible monster** (`mBrickHA`), not a wall —
stop hitting them; **(2)** the mummy is a **mom that splits — kill it in ONE big hit (Power Magic) so
it doesn't divide, or it respawns forever.** That one tip would've saved hours.
