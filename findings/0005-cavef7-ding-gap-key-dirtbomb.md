# 0005 — CaveF7 ice cave: the ding‑wall "fake gap," the key↔locked‑door puzzle, and grabbing the walled‑off key with a dirt bomb

- **Status:** Confirmed — data‑verified (byte dumps this session) **and** player‑verified in‑game
- **Date:** 2026-07-05
- **Tags:** cave, cavef7, ice-cave, mBrickHA, ding-wall, fake-wall, iKeyB, locked-door, dirt-bomb, item-pickup, projectile-grab
- **Related:** [#0002](0002-hidden-room-dun4021-grandma-cell.md) (fake‑wall walk‑through), [#0003](0003-caved4-mummy-room-qinglong.md) (`mBrickHA` invincible monster‑wall)

## Summary

In the **CaveF7 ice cave**, a row of "ding walls" seems to have a **gap** you'd expect to walk through to reach a **key** — but it won't let you. The gap is a **cosmetic seam over solid, unbreakable collision**: the ding walls are `mBrickHA` (invincible brick‑MONSTERS, [#0003]). It is **not "too thin."** The key (`iKeyB`) is actually in a **walled‑off pocket** and pairs with a **locked door**; the ding cluster is a divider you route *around*, not through. And crucially — **player‑confirmed, there is no walking route to the key at all.** The only way to get it is **a dirt bomb's split‑rock, which hits the key and collects it from across the wall** — because in this engine **hitting an item picks it up, exactly like touching it**.

## The two rooms

- **`CaveF701` — has the KEY.** `iKeyB` (type `0x105`) at **col 18, row 5** (offset `713911`); pickup line *"LuWa got a key."* (~`713856`). One `mBrickHA` ding wall (col 17, row 1). The key sits **east of a solid `eBrickHA` wall** (col 10, row 5), and **there is no fake wall in this room.**
- **`CaveF702` — the ding CLUSTER + the LOCKED door.** Four `mBrickHA` ding walls (cols 8/10/11, rows 3–9), a **locked door `dDoorHALk`** (type `0x43`) at **col 9, row 9** (offset `714313`), the **stairs‑down `StepAD`** behind it at **col 10, row 8** (offset `714060`), and a **passable fake wall `eBrickHAFls`** (type `0x6d`) at **col 7, row 10** (offset `715154`).

## Why the gap won't let you through (it is not "too thin")

- The ding walls are **`mBrickHA` (type `0x133`)** — invincible brick‑**monsters** that ding when hit and never break ([#0003], confirmed in‑game there via a data overlay).
- **A single `mBrickHA` renders as a whole multi‑tile barrier** — the engine derives the extent at runtime; the record has **no width/extent field** (params after `x,y` are all zero, then `CD` padding). The brick seams you see *within and between* the ding tiles are **purely cosmetic**; collision fills each full 40 px tile.
- So the "gap" is **not a sub‑tile slit and not an opening** — it's a decorative seam over solid collision. You can't squeeze it, angle through it, or destroy it. **Hitbox precision / thinness has nothing to do with it.**

## The route — and the walled‑off key

The ding cluster is a **decoy**: it does **not** guard the key, and its "gap" is impassable. What actually matters:

1. **The key has no walking entrance.** `iKeyB` sits in a pocket of **CaveF701 (col 18, row 5)** behind a solid `eBrickHA` wall (col 10, row 5), with **no door, hole, or fake wall into that pocket — player‑confirmed there is no way to walk to it.**

   > ⚠️ **Correction.** An earlier version of this finding guessed an "east / `WX9Y2` entrance" from a World tag in the key's record. **That was wrong — the player verified in‑game that no such passage exists.** The `WX9Y2`/`WX8Y2` bytes are just world tags in the record, not a usable doorway.

2. **You obtain the key by hitting it with a projectile** (see below) — the *only* way in.
3. **The key opens the locked door `dDoorHALk` (col 9, row 9) in CaveF702**, behind which are the **stairs‑down `StepAD` (col 10, row 8)**.
4. *(Data note:* CaveF702 also has a **walk‑through fake‑wall tile `eBrickHAFls` at col 7, row 10** — confirmed passable in the bytes — but its exact role in the room isn't pinned down; don't treat it as *the* route.)*

## How you get the key: hit it with a dirt bomb (the only way)

With no walking route to the key, the player retrieved it with a **dirt bomb**:

- A **DirtBomb splits into extra dirt balls to the sides of its impact** (intended projectile behavior; `00DirtBall` is a real projectile type). One split lands in front of the key and **throws a rock onto it.**
- **Hitting an item collects it, exactly as if LuWa had walked into it** — item pickups fire on contact with LuWa's *projectiles/attacks*, not only his body. So the rock "touches" the key and grants it (*"LuWa got a key."*). Any projectile that can reach the key's tile should work; the dirt bomb's side‑split is what lets a shot curve around the wall.

**Bug or intentional? → Ambiguous — and the projectile grab is the *only* way in.** Player‑confirmed there is **no walking route** to the key, so this isn't a shortcut past a "proper" path — there is none. The mechanics it uses are intentional (projectiles collect items; dirt bombs split), so this is either **intended‑but‑unsignposted design** ("shoot the key across the wall") or a **level‑design oversight** where a *required* progression key is obtainable only through an emergent trick. Either way it carries real **soft‑lock potential**: a player who arrives without a projectile item — or who never learns that hitting an item collects it — could be stuck. The static data can't settle intent, but the practical takeaway is firm: **a projectile (the dirt bomb) is how you get this key.**

## Evidence

Byte‑dumps from `game-data/Area.add` (re‑verified this session, little‑endian):

- `iKeyB` `0x105` @ `713911`, `x=720 y=200` → **col 18, row 5** (CaveF701); pickup *"LuWa got a key."* @ ~`713856`. The record's param block carries `World` + `WX9Y2` bytes — **a world tag, NOT a usable entrance** (player‑confirmed the pocket has no walk‑in route).
- `eBrickHAFls` `0x6d` (passable fake wall) @ `715154`, `x=280 y=435` → **col 7, row 10** (CaveF702).
- `dDoorHALk` `0x43` (locked door) @ `714313`, `x=362 y=381` → **col 9, row 9** (CaveF702).
- `StepAD` `0x1b7` (stairs down) @ `714060`, `x=437 y=340` → **col 10, row 8** (CaveF702).
- `mBrickHA` `0x133` ding walls @ `714102 / 714144 / 714186 / 714355` — each a discrete record, all‑zero params after `x,y` then `CD CD CD CD`, **no extent field** (extent is engine‑derived; see [#0003]).
- Mechanics: `mBrickHA` unbreakable‑solid confirmed in‑game via overlay ([#0003]); `eBrickHAFls` walk‑through ([#0002]); **dirt‑bomb split + "hit an item to collect it" player‑verified in‑game** (this session).

## Open questions

- **Intended design vs oversight.** Player‑confirmed there is **no walking route** to the key — the projectile grab is the only way. Whether the designers intended "shoot the key" or the key was meant to be reachable and isn't (a soft‑lock‑adjacent oversight) can't be settled from the static data. *(An earlier draft's "east/`WX9Y2` entrance" theory is retracted — no such passage exists.)*
- **"Hit item = pickup" in code.** Player‑verified in‑game; not yet located in the decompiled code (which collision/pickup function grants an item on *projectile* contact is untraced).
- **Where the CaveF702 fake wall (col 7, row 10) leads** — whether it fully bypasses the locked door or only reaches its front — isn't confirmed in a running session.

## Note for the wiki

CaveF7: **don't attack the "gap" in the ding walls — it's a cosmetic seam over an invincible monster‑wall, not an opening.** The key (`iKeyB`) sits in a **walled‑off pocket with no walk‑in route** — **you must grab it with a projectile: throw a dirt bomb so its side‑split rock hits the key (hitting an item picks it up).** The key then opens the **locked door** to the stairs down. ⚠️ Warn readers: without a projectile / without knowing this trick, that key looks unobtainable.
