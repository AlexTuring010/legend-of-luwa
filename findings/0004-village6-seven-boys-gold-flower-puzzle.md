# 0004 — Silver Village (Village6): the "seven boys" Gold Flower puzzle — pick the one who *wanders*

- **Status:** Confirmed — solved in‑game by the player **and** explained in the data
- **Date:** 2026-07-05
- **Tags:** village6, silver-village, puzzle, gold-flower, seven-boys, mBoyD, rBoyD, icedart, kungfu, npc-vs-monster
- **Related:** [#0002](0002-hidden-room-dun4021-grandma-cell.md) (`r*` NPCs are the item‑givers), [#0003](0003-caved4-mummy-room-qinglong.md) (`m*` prefix = **monster**; identity is the record **type**, not the label)

## Summary

In **Silver Village (`Village6`, world tile `WX10Y2`)**, one of the three KongFu‑master brothers sets a test: a back room holds **"seven boys," all drawn identically.** One boy hands you a **Gold Flower**; **hitting any other boy kills you instantly.** The trick: the decoy boys are **monsters** and the real boy is a **passive NPC**, so they *behave* differently — **the decoys chase you, the real one wanders.** Bring the Gold Flower back to the master and he teaches LuWa to **fly Icedart** (needed to beat Monster Water).

## The player's solution (confirmed in‑game)

- **All the "bad" boys walk straight toward LuWa** (they home in / aggro like normal monsters).
- **The correct boy walks around randomly**, ignoring you.
- **Method:** stand in the **down‑right corner and wait a moment** → every bad boy piles up around you in the corner → the **one boy still wandering the room normally is the real one** → **run to him** (walk into him, don't attack) to receive the Gold Flower.
- **Never swing at a boy.** Hitting a decoy = death ("if you hit any other boy, you are dead!"). You *interact* with the right one, you don't fight anything.

## Why it works (the data behind the behavior)

The "seven identical boys" are **two different object types** — and the m/r prefix predicts the exact behavior the player observed:

- **Decoys = `mBoyD` (type `0x132`).** The **`m` prefix = MONSTER** (it sits one slot before `mBrickHA` `0x133`, the invincible brick‑monster from [#0003](0003-caved4-mummy-room-qinglong.md)). Monsters run the **chase/aggro AI** → they walk toward LuWa. In the map they're a **stack of five `mBoyD` spawned on one centre tile** (`col 9–10, row 6`) that chase LuWa at runtime.
- **Real boy = `rBoyD` (type `0x17c`).** The **`r` prefix = interactive NPC** — the same friendly family as `rOld` / `rOldBlue` / `rOldGreen`, the NPCs that *hand LuWa things* (grandma's Ex‑Jade in [#0002](0002-hidden-room-dun4021-grandma-cell.md); the DarkSilk Armor; kungfu). It has **no aggro AI → it just wanders.** It sits **apart** from the decoy stack at **`x=120, y=440` → `col 3, row 11`** (near the room's left‑edge doors).

So "the boy who walks around normally" **is literally the one non‑monster object in the room.** The behavioral tell the player found is the object‑type difference made visible. This is the same core lesson as [#0003](0003-caved4-mummy-room-qinglong.md): *identity is the record **type**, not the (throwaway) label* — here every boy's label is even the junk string `StepAD`.

## Evidence

- **Master's challenge**, room `V6Hs002` (`game-data/Area.add` chunk @ `685912`):
  - `687520` — `"...seven boys in the room behind."`
  - `687569` — `"...you a gold flower."`
  - `687595` — `"But if you hit any other boy,"` … `687621` `"boy, you are dead!"`
  - `687691`–`687735` — `"You will pay your life / as the price of no / thinking."`
  - `688085`–`688107` — `"Got the Gold Flower? / Good. Give it to me."`
  - Reward `687922`–`687966` — `"LuWa learned to fly / Icedart and got a bag / of Icedart."`
- **The boys' room `V6Hs003`** (`game-data/Area.add` chunk @ `690637`–`692442`), decoded via the `CD CD CD CD` record walk + `Spc.add` type resolver:
  - **five `mBoyD` (type `0x132`, monster)** records @ offsets `692120 / 692162 / 692204 / 692246 / 692288`, all on one centre tile `x=380, y=240` (≈ `col 9–10, row 6`);
  - **one `rBoyD` (type `0x17c`, NPC)** @ offset `691856`, at `x=120, y=440` (`col 3, row 11`) — the only non‑monster boy.
- **The Gold Flower grant + both dialog branches** sit on a `0x1f0` trigger‑container (label `rboyd`) @ `691586`, parked on the centre tile:
  - `691629` — `"My good friend!  I will give you a Gold Flower."` → `"LuWa got the Gold Flower."` (`$$n2` = item‑grant marker);
  - `691763` — the wary/decoy line `"Hi! Why are you hanging around this dangerous place?"`
  - (also `research/area_script_text.txt` lines 10074–10084.)
- **Location:** `Village6` = "Silver Village," world tile `WX10Y2`; the three brothers are `rOldBlue` (`0x18f`), `rOldGreen` (`0x192`) (+ a red brother), who "tried different methods to remove the ice hill."

## How it works (in‑game)

Enter the back room, go to the **bottom‑right corner**, pause until the aggro boys clump onto you, spot the **lone wanderer**, and **walk into him** to get the Gold Flower. Hand it to the master → he teaches **Icedart** (and gives a bag of it). Do not attack anything in the room.

## Reproduction / verification

Player‑verified: the corner‑bait method reliably isolates the wandering `rBoyD`. Data‑verified: exactly one `rBoyD` NPC vs a stack of `mBoyD` monsters in `V6Hs003`.

## Open questions

- **Count: the data shows six boy objects, the dialog says "seven."** The bytes cleanly give **5× `mBoyD` + 1× `rBoyD` = 6**; a 7th boy can't be forced from the data. Two non‑boy records share the centre tile — a `SeperatC` (`0x1a7` @ `692086`) and the `0x1f0` dialog‑container — one of which may render an extra sprite, or "seven" is narrative rounding. *(Corrects an earlier draft that said "six `mBoyD`": the first `StepAD`‑labelled record there is the `SeperatC`, not a boy.)*
- **Kill‑on‑hit is inferred, not yet in code.** `re-tools/decomp.c` contains no boy/flower logic, so "hitting a decoy = death" rests on the master's explicit wording + `mBoyD` being a monster‑class entity — solid, but not code‑proven.
- **Sprites unexamined.** `Pic.add` wasn't opened, so whether the safe boy also *looks* different is unconfirmed — the player‑verified **behaviour tell (decoys chase, the real boy wanders)** is the reliable cue regardless.
- **Dialog vs sprite split.** The flower grant lives on the `0x1f0` container at the *centre* tile (with the monsters), while the friendly `rBoyD` sprite spawns at `col 3, row 11` — so the decisive identity is the **type** (`0x17c`), not the raw spawn coordinate.

## Note for the wiki

Silver Village's Icedart test: **don't fight — the seven boys look identical, but six are `mBoyD` monsters (they chase you) and one is a wandering `rBoyD` NPC (he ignores you).** Corner yourself, let the chasers gather, then run to the boy who's still wandering and walk into him for the Gold Flower → trade it to the master for Icedart.
