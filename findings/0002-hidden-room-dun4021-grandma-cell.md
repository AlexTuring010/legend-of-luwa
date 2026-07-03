# 0002 — Hidden room after Monster Gold: grandma's cell (`Dun4021`)

- **Status:** Confirmed (it's a doorless secret cell holding grandma + the Ex‑Jade) /
  Plausible (exact entry tile & adjacent room not yet verified in‑game)
- **Date:** 2026-07-04
- **Tags:** secret-room, castle, monster-gold, ex-jade, fake-wall, dun4021
- **Related:** [#0001](0001-warm-ball.md)

## Summary

The room you can see on the map **after the Golden Monster boss (Monster Gold) in the castle**
but can't enter is map **`Dun4021`** — the last room of the castle. It holds the **grandmother**
(kidnapped by Monster Gold for the **Ex‑Jade**) and a pickup. It has **no normal door** — the
entrance is a **fake / walk‑through wall on the room's top side** (which is why **DirtBombs do
nothing** — it isn't a bombable wall).

## Evidence

Story (`game-data/Area.add`):
- @ `589465` — `Monster Gold locked me here for the Ex‑Jade. I thought I would never see my
  granddaughter again. Thank you for saving me. see you in QingLong Village.`
- @ `524667` — `The Ex‑Jade is in the box by my side. Take it with you. But in fact it is only
  half of the Ex‑Jade. A few years ago, a pirate grabbed the other half away.`
- Granddaughter's foreshadowing dream (elsewhere in `Area.add`): `Believing my Grandmother has a
  magical item, Monster Gold took her away.` / `I saw grandmother was kept in a dark room without
  doors or windows.`

Map structure (`game-data/Area.add`):
- `Dun4021` map header @ `589210`. Header dims: width `0x1f`=31, height `0x1a`=26 tiles.
- The castle is the **`Dun40xx`** set (rooms `Dun4001`–`Dun4021`). `Dun4021` is the deepest/last.
- The `Dun4021` chunk is tiny (~596 bytes vs 1.5–2.3 KB for normal rooms) — a nearly empty cell.
  It contains only: a `med` pickup and the grandma dialog. **No `Door*` object.**
- Rendered object map: the cell's **only non‑standard wall edges are on the top row**:
  - `'u'` edge, **type `0x06`**, @ `589305` → col 3, row 1 (top wall, upper‑left)
  - `'l'` edge, **type `0x198`**, @ `589668` → col 13, row 1 (top wall, middle)
  - everything else is standard wall (`'d'` type `0x7e`, `'l'` type `0x80`).
- **Why that's the entrance:** across the castle, ordinary walls are types `0x7e/0x7f/0x80/0x81`
  (they repeat all around every perimeter); **real doorways use rare edge types**
  (e.g. Dun4018's doors are `0x24`/`0x104`; Dun4020 uses `0x2d`/`0x3d`/`0x104`). `Dun4021`'s only
  rare edges (`0x06`, `0x198`) sit on the **top wall** → that's the way in.
- The cell's spawn/entry coordinate in the header is up in the **top‑left** (~col 2, row 2),
  next to the `0x06` marker — consistent with entering through the top‑left.

In‑game observation:
- DirtBombs at the wall did **nothing** (user‑tested) → not a destructible wall; it's a
  **walk‑through fake wall** (the manual warns "some walls are fake, some are invisible" —
  `research/manual.txt`).

## How it works (in‑game)

`Dun4021` is a secret cell tucked against Monster Gold's treasure room (`Dun4020`, the one full
of gold pickups). It isn't connected by a normal door; you enter by walking **through a fake
section of its top wall** (upper‑left → top‑middle). Inside: rescue grandma and take the Ex‑Jade
(half of it here; a pirate has the other half, which you later combine into the whole Ex‑Jade).
Rescuing her also completes the granddaughter's quest in QingLong Village — whose reward is the
**Warm Ball** (see [#0001](0001-warm-ball.md)).

## Reproduction / verification

Confirmed from data end‑to‑end for identity/contents/mechanic. **To finish verifying in‑game:**
stand in Monster Gold's treasure room and walk LuWa firmly into the wall shared with the cell
(hold the direction) along its **top edge, left portion** — a fake wall lets you pass; no bomb/key.

## Open questions

- Exact adjacent room and whether you push **up** or **down** into the fake wall (the data has no
  per‑room world coordinates, so up/down isn't proven yet).
- Which of the two top‑wall markers (`0x06` @ col 3 vs `0x198` @ col 13) is the passable tile.
- **Next step to nail it:** stitch the full `Dun40xx` floor‑plan (all 21 rooms) to fix
  `Dun4021`'s neighbor and the exact passable tile.
