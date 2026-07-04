# 0003 — CaveD4 near QingLong: the bomb-gated secret (mummy/wall puzzle → hidden bomb shop)

- **Status:** ⚠️ **Partly RETRACTED** — the "bomb / break the dividing wall" solution is **WRONG**
  (proven in‑game: *nothing* breaks those walls). Cave location, IceBomb pickup, and bomb merchant
  are still correct. Real answer: **[#0004](0004-caveD-mummy-room-mbrickha.md)**.
- **Date:** 2026-07-04
- **Tags:** cave, puzzle, bombs, icebomb, monster-gate, qinglong, merchant, retracted
- **Related:** [#0004](0004-caveD-mummy-room-mbrickha.md), [#0002](0002-hidden-room-dun4021-grandma-cell.md)

> ⚠️ **Correction:** the "ding" dividing walls are **not** breakable and **not** bombable — they are
> `mBrickHA`, an **invincible brick‑MONSTER** used as a permanent divider ([#0004]). The IceBombs are
> *not* the intended tool for the wall. Everything below about breaking/bombing the wall is superseded;
> the cave structure, the IceBomb pickup, and the hidden bomb merchant remain accurate.

## Summary

The multi-level cave next to **QingLong Village** is **CaveD4** (`CaveD401` → `CaveD402` → `CaveD403`),
sitting at the village's own world tile **WX6Y6**. It's a **bomb-gated secret**: level 1 hands you a
bag of **IceBombs**, level 2 is a monster/wall puzzle, and the payoff is a **hidden bomb merchant**.
The "ding" walls are meant to be dealt with using **bombs, not the sword** — the player is not missing
a later-game item; the tool (IceBombs) is given one room earlier.

## Evidence (`game-data/Area.add`)

- **QingLong Village = `Village4`, world coord `WX6Y6`** (name string @ `539299`; `WX6Y6` @ `538886`).
  `CaveD4` is at the same tile: `CaveD401` header @ `547871`, with `World`/`WX6Y6` @ `548164`.
- **`CaveD401` (level 1)** gives bombs: `LuWa got a bag of IceBomb.` @ `548332`. Exits via `StepAU` stairs.
- **`CaveD402` (level 2, the puzzle room)**, header @ `549081` (dims 31×26). Objects:
  - **4 monsters** (`Xa`), all on the **right** side: type `0xde` @ col15/row6 (`548809`); type `0x155` ×3 at
    col17/row7, col18/row5, col16/row9 (`548847`,`548885`,`548923`). Header monster-count dword = `04`.
  - **`StepAU` (top-left, col3/row1)** → linked to `CaveD401` (bytes `…StepAU…CaveD401…` @ `549255`): stairs **up** to level 1.
  - **`StepAU` (bottom-left, col2/row14)** → linked to `CaveD` (next room) @ `549394`: stairs **down** to `CaveD403`.
  - **`BrickD` walls**, ordinary type `0x6c`; special types `0x0c` and `0x1b9` (the latter at col15/row1, atop the monster pen).
- **`CaveD403` (the payoff)** is a **hidden bomb merchant**: `10 ArrowBomb for 10 coins`, `10 DirtBomb for 10 coins`,
  `10 IceBomb for 10 coins` (@ `550232`–`550438`) and NPC line `How did you get here? I cannot let you go
  bare-handed since you found me. What do you need?` (@ `550583`).

## How it works (in‑game)

1. **Level 1 (`CaveD401`):** clear the monsters; that opens the hidden stairs **down** (the manual: doors open
   only once all monsters in a room are perished). Pick up the **bag of IceBombs**.
2. **Level 2 (`CaveD402`):** all 4 enemies (incl. the "pink mummy") are penned on the **right**, behind `BrickD`
   walls. The **left** stairway down (to the merchant) is a **monster-cleared gate** — it only opens once **all 4**
   enemies are dead. The ladder/stairs geometry stops you reaching the right pen on foot, and enemies **respawn on
   re-entry**, so you can't clear them across two visits — they must all die in **one** visit.
3. **The intended tool is BOMBS.** Hitting the dividing walls with the **sword** produces the "ineffective" **ding**
   (manual: *"A sound 'ding' means the attack is ineffective — change the sword, bullet, or kungfu"*). Use the
   **IceBombs** from level 1: bomb through / bomb the penned enemies. Kill all 4 → the left stairway opens →
   descend to **`CaveD403`**, the secret bomb shop.

## Reproduction / verification

- Structure, monster placement, stair links, the IceBomb pickup, and the merchant are all confirmed from `Area.add`.
- **Not yet pinned:** whether the specific `BrickD` divider tiles are *destroyed* by a bomb, or whether you lob a
  bomb *over* them to kill the penned enemies. Both resolve the puzzle and both use the level-1 IceBombs — the
  correction to the player's mental model ("is it later game?") holds either way: **no, bombs are the answer, and
  you already have them.**

## Open questions

- Which `BrickD` type (`0x0c` / `0x1b9`) is the destructible divider, vs. plain wall.
- Which `Xa` type (`0xde` vs `0x155`) is the "pink mummy" sprite (needs `Pic.add`/`Spc.add` decode).
