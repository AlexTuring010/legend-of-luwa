# 0003 — CaveD4 near QingLong: the mummy room, its unbreakable monster‑wall, and the respawn bug

- **Status:** Confirmed — verified in‑game **and** in the game's code (Ghidra decompilation)
- **Date:** 2026-07-04
- **Tags:** cave, qinglong, mummy, mZummyB, mBrickHA, splitter, respawn-bug, ghidra, icebomb, merchant
- **Related:** [#0002](0002-hidden-room-dun4021-grandma-cell.md)

## Summary

The multi‑level cave next to **QingLong Village** (world tile **WX6Y6**) is **CaveD4**
(`CaveD401 → CaveD402 → CaveD403`). Level 1 hands you a bag of **IceBombs**; the deepest room holds a
**pink mummy** behind a row of "block walls" that **ding** and refuse to break; the payoff is a
**hidden bomb merchant.** The two real gotchas:

1. **The "ding walls" are not walls — they're `mBrickHA`, an invincible brick‑MONSTER divider.**
   Nothing breaks them (no sword / bomb / bullet / magic), *by design.* Stop hitting them.
2. **The mummy (`mZummyB`) is a "mom" that splits into 2–4 children — and *how* you kill it decides
   whether it respawns.** Kill it normally → it splits → it **respawns** on re‑entry (a bug).
   One‑shot it (Power Magic beams) → it dies for real → **permanent.**

## The cave (structure)

- **QingLong Village = `Village4`, world coord `WX6Y6`** (name @ `539299`, `WX6Y6` @ `538886`). `CaveD4`
  sits at the same tile (`CaveD401` header @ `547871`, `World`/`WX6Y6` @ `548164`).
- **`CaveD401` (level 1):** `LuWa got a bag of IceBomb.` @ `548332`. Clear it → hidden stairs down.
- **`CaveD403` (payoff):** a hidden **bomb merchant** — `10 ArrowBomb/DirtBomb/IceBomb for 10 coins`
  @ `550232–550438`, NPC `How did you get here? I cannot let you go bare-handed since you found me.` @ `550583`.

> ⚠️ **Retracted early theory:** the IceBombs are **not** the tool for the walls, and the walls are
> **not** bombable/breakable — see below. (This finding supersedes the old "bomb‑gated secret" note.)

## The "ding walls" = `mBrickHA` (invincible brick‑monster)

- Object identity is the record's **`type`**, not the throwaway label (`BrickD`). Resolving via `Spc.add`,
  the ding‑blocks are **`type 0x133 = mBrickHA`** — the **`m` prefix = MONSTER.** It's *drawn* as a row of
  bricks but is an enemy, so hitting it **dings** (attack lands, zero damage), and it's damage‑immune →
  **never breaks.**
- **Verified in‑game:** an isolated data overlay flipping *only* `mBrickHA` (0x133) → passable made
  *exactly* the ding‑barrier walk‑through while the ladder, sliding block, and all `eBrickHA` walls stayed
  solid.
- **One `mBrickHA` object renders as the whole visual row** (the reliable `CD`‑delimited count shows ~26
  objects in the room, not 24 wall objects — "24 blocks" = 1 monster drawn as bricks).

## The mummy is a splitter (`mZummyB`) — kill method decides respawn

- **Data:** `mZummyB` (0x16c) and only its child `mZummy` (0x16b) carry a unique split property
  (`f6=0xA000A`, `f7=10`) that **no** ordinary monster has. HP field: **mom 240, child 30.**
- **Normal kill →** it splits into ~4 children → the mom **respawns** every re‑entry (the trap that ate hours).
- **One powerful hit (Power Magic full‑breath sword‑beams) →** dies outright, **no split → permanent**,
  even after leaving the cave (player‑verified).

## Root cause — confirmed in the game's code (Ghidra decompilation of `Luwa.exe`)

- **The split is gated by ONE monster‑def field, offset `0x128` ("split‑child‑type").**
  `FUN_0041b680(def) => return *(def + 0x128)`. It is **‑1 for every normal monster**; the mummy is the
  **only** entry in the 517‑type table with it set — the "bolted‑on" late upgrade.
- **The split path sets no kill/clear flag.** `FUN_0040d550` (the mummy's death method) reads that field
  and, if it splits, spawns **`rand()%3 + 2` = 2–4 children**, copies the mom's position, adds them to the
  room's actor list, and **`return 1`** — *that is all it does.* It never registers a kill.
- So a normal hit routes the mom through the **split path → the normal‑death code that records the
  permanent kill never runs → her "killed" flag stays unset → she respawns.** A one‑shot kills her
  outright (skips the split) → normal‑death path → flag set → **permanent.**
- **It's a *generic* engine oversight, not a hand‑coded room special‑case** — the split‑death path simply
  never counts as a "real" kill, and the mummy is the *only* monster that triggers it (only one with
  `0x128` set), which is also why it slipped playtesting. Refines the "they upgraded one mob and forgot
  the logic" theory: right in spirit, engine‑wide rather than room‑local.

*(Ghidra 12.1.2 on `Luwa.exe`; key functions `FUN_0040d550` = split, `FUN_0041b680` = split‑child‑type
getter. Ghidra project + decompiled listing are a local RE artifact, not in this repo.)*

## The solution

**Kill the mom with a no‑split power attack** — Power Magic at full breath (sword fires beams), or any
blow strong enough to kill her before she divides. She dies permanently; then cross to the left (the
"movable thing" is a **sliding/pushable block, `eBrickDBSld`**, that becomes pushable once monsters are
dead) and reach the exit. **The normal split‑kill is the trap; the overkill is the intended path.**
*(Also viable: the up‑and‑back route — one‑shot her, go up, re‑clear level 1, come back — she stays dead.)*

## Room mechanics recap

- Mummy sits behind the `mBrickHA` divider; reachable on foot from the right, but the **`StepAU` ladder**
  yanks you back **up** if you try to return left.
- The **"movable thing"** = `eBrickDBSld` (sliding block), pushable only once all monsters are dead.
- The divider (`mBrickHA`) cannot be removed, and bullets cannot pass it.

## Open questions

- Exact "no‑split" threshold (raw damage vs the mom's 240 HP, or a special beam flag).
- Where the **permanent‑kill flag** is stored — it survives leaving the cave, so it's saved (likely a
  not‑yet‑decoded events/flags section of the `.sav`).

## Note for the wiki

Two gold gotchas: **(1)** the "ding bricks" are an **invincible monster** (`mBrickHA`), not a wall —
stop hitting them; **(2)** the mummy is a **mom that must be one‑shot** (Power Magic) or it respawns
forever.
