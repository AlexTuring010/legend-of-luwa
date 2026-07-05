# 0006 — The Heart / max‑life system: 9 Hearts total — 2 assembled from "1/4 Heart" pieces, 7 found whole

- **Status:** Confirmed (data) — enumerated + adversarially re‑verified. *(Save‑based "how many do I have" is **not** reliable — see caveats.)*
- **Date:** 2026-07-05
- **Tags:** hearts, max-life, 1/4-heart, broken-heart, collectible, trade, mender, village4, upgrade
- **Related:** [#0003](0003-caved4-mummy-room-qinglong.md) (Village4 = QingLong, world tile `WX6Y6`)

## Summary

LuWa's max life is raised by collecting **Hearts**. There are **9 named Hearts** in the game. **Seven are found already whole** in dungeons/caves; **two are assembled from "broken‑heart" pieces.** The piece item is **"1/4 Heart"**, so **4 pieces = 1 complete Heart**; there are **exactly 8 pieces**, which build **2 Hearts** at a trade NPC. Chasing pieces only matters for those 2 Hearts — the other 7 are picked up whole.

## The 8 broken‑heart pieces ("1/4 Heart")

Each prints *"LuWa got a piece of / broken heart!"* on pickup.

| # | Room | World tile | `Area.add` offset | Notes |
|---|------|-----------|-------------------|-------|
| 1 | `CaveA601` | `WX5Y2` (CaveA, early) | `351505` | floor pickup, same room as a key |
| 2 | `CaveA701` | `WX7Y1` (CaveA, early) | `352364` | reached up the stairs (`StepAU`) |
| 3 | House `WHB02` | `WX1Y2` (standalone hut) | `358760` | inside a furnished house interior |
| 4 | House `WHC03` | `WX4Y9` (standalone hut) | `364901` | inside the house interior |
| 5 | `Dun2015` | `WX4Y5` (Dungeon 2) | `407169` | monster‑guarded, near the `Dun2016` boss |
| 6 | `CaveD601` | `WX7Y9` (CaveD, gold region) | `552540` | **appears only after killing every monster in the room** — invisible until the room is cleared, so very easy to miss (player-confirmed). Same "clear-to-unlock" gate as the CaveD mummy room in [#0003](0003-caved4-mummy-room-qinglong.md) |
| 7 | `Dun6008` | `WX10Y4` (Monster Water's dungeon, Dun6 — *not* Xuan Tower) | `601673` | monster‑guarded |
| 8 | `CaveE401` | `WX9Y6` (CaveE, late) | `731650` | floor pickup |

## The trade — the mender in Village4

The NPC (object label **`doc`**) in **Village4 (QingLong, `WX6Y6`)** — the gold‑miners' village by Monster Gold's castle — mends the pieces: *"There is nothing in the world that I can not mend. I even mend broken pieces of Heart! Do you have such pieces?"* Hand over pieces to receive a complete Heart, **twice**:

- 1st trade → **Heart of Mature** (`"OK, here is a complete Heart." → "LuWa got the Heart of Mature."` @ `528052`/`528090`)
- 2nd trade → **Heart of Perfection** (@ `528454`/`528492`)

The dialog never states the "**4 pieces per Heart**" count — it's inferred from the item name **"1/4 Heart"** (and 8 pieces → 2 Hearts is exact).

## The 7 Hearts found whole (no pieces needed)

Each grants *"LuWa got the Heart of ___"* directly:

| Heart | Room | `Area.add` offset |
|---|---|---|
| Bravery | `Dun1004` | `328587` (trigger `mkheart` @ `328542`) |
| Luck | `CaveA101` | `346828` |
| Power | `Dun2016` (boss room) | `407993` (obj `heart2`) |
| Justice | `Dun3009` | `486902` |
| Ease | `Dun4019` (Monster Gold's castle) | `586534` |
| Calm | `Dun6029` (Monster Water's dungeon, Dun6) | `632784` |
| Warm | `Dun5008` | `641504` (pickup obj `iHeartA0` @ `641459`) |

**9 Hearts total** = 7 whole + 2 assembled (Mature, Perfection).

## Evidence

- **Piece count = 8:** grep of `research/area_strings_offset.txt` returns **exactly 8** `"broken heart!"` strings (offsets in the table above), each preceded by `"LuWa got a piece of"`.
- **Item:** `game-data/Item.add` heart family = `Heart` / `HeartTest` / **`1/4 Heart`** (the `1/4` encodes 4 pieces per whole Heart).
- **Trade:** the block @ `528052`–`528728` sits inside the **Village4** map chunk (header @ `526449`; region tag `WX6Y6`) — two mend sequences yielding **Mature** and **Perfection**, plus *"I even mend broken / pieces of Heart!"* (@ `528323`/`528728`), obj `doc`.
- **7 whole Hearts:** offsets listed above (all distinct `"LuWa got the Heart of ___"` grants).
- **Exclusion:** the Village6 *"LuWa got a piece of…"* @ `633724` is **"piece of Xuan Iron"**, not a heart — correctly excluded.

## Caveats / open questions

- **"4 pieces per Heart" is inferred** (from the item name), not stated in dialog — but the 8‑pieces → 2‑Hearts arithmetic is clean.
- **Save‑based "how many do I hold" is unreliable.** `1/4 Heart` = Item.add index 41 (`Array1` byte offset `100`); the current active `Proc*.sav` read **0** pieces while the Jul‑4 `Proc*.sav.bak` read **3** — this save chain was cheat‑edited/reset earlier, so trust in‑game count over the file. **Completed‑Heart / max‑life total is not readable** from the located save slots (the `Heart` slot @ offset `54` reads 0 even when pieces are held) → it lives in a separate, not‑yet‑located max‑life field.
- A couple of overworld `WX#Y#` tags (esp. Dun3/Justice) are each room's nearest world tag, reliable but not double‑checked in‑game.

## Note for the wiki

Max HP comes from **9 Hearts**: **7 found whole** (Bravery, Luck, Power, Justice, Ease, Calm, Warm — see rooms above) and **2 assembled** from **8 "1/4 Heart" pieces** (4 each) traded to the **mender in Village4/QingLong (`WX6Y6`)** for the **Heart of Mature** and **Heart of Perfection**. Piece hunting only affects those last two.
