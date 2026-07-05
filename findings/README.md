# Findings log

Every secret, mechanic, or item function we discover gets its **own numbered file** here,
with the **evidence** that backs it (which data file, which byte offsets, which dialog lines).
This is what makes the wiki trustworthy instead of guesswork.

## How to add a finding

1. Copy `TEMPLATE.md` to `NNNN-short-slug.md` using the **next free number** (zero‑padded to 4).
2. Fill in every section. Always cite evidence: `game-data/<file>` + byte offset, or the exact
   dialog string. Mark **Status** honestly (`Confirmed` = proven in data and/or in‑game;
   `Plausible` = strong data evidence, not yet verified in‑game; `Open` = hypothesis).
3. Add a row to the index below.
4. When a finding is solid, fold it into the relevant `wiki/` page.

## Index

| # | Title | Status | Tags |
|---|---|---|---|
| [0001](0001-warm-ball.md) | Warm Ball — trade item for the Fire Sword | Confirmed | item, trade, fire-sword |
| [0002](0002-hidden-room-dun4021-grandma-cell.md) | Hidden room after Monster Gold (grandma's cell, `Dun4021`) | Confirmed (data) / Plausible (exact tile) | secret-room, castle, ex-jade, fake-wall |
| [0003](0003-caved4-mummy-room-qinglong.md) | CaveD4 near QingLong — mummy room, `mBrickHA` monster-wall, splitter respawn bug (+ solution) | Confirmed (in-game + Ghidra) | cave, qinglong, mummy, mBrickHA, splitter, respawn-bug, ghidra |
| [0004](0004-village6-seven-boys-gold-flower-puzzle.md) | Silver Village (Village6) "seven boys" Gold Flower puzzle — pick the wandering `rBoyD` NPC among `mBoyD` monsters | Confirmed (in-game + data) | village6, puzzle, gold-flower, mBoyD, rBoyD, icedart, npc-vs-monster |
| [0005](0005-cavef7-ding-gap-key-dirtbomb.md) | CaveF7 ice cave — ding-wall "fake gap," key↔locked-door chain, and grabbing the walled-off key with a dirt bomb (hitting an item collects it) | Confirmed (data + in-game) | cave, cavef7, mBrickHA, fake-wall, iKeyB, locked-door, dirt-bomb, item-pickup |
| [0006](0006-hearts-maxlife-system.md) | The Heart / max-life system — 9 Hearts total: 8 "1/4 Heart" pieces → 2 assembled Hearts (Village4 mender), + 7 found whole | Confirmed (data) | hearts, max-life, 1/4-heart, broken-heart, trade, mender, upgrade |
| [0007](0007-wuxing-final-boss-damage-mechanic.md) | Monster WuXing (final boss) — reflect thunder → white circle → knife → red circle → damageable; + the shadow-LuWa (`mShadow`) summon | Confirmed (in-game) | final-boss, wuxing, xuan-tower, damage-mechanic, reflect, knife, shadow-luwa |

## Conventions

- Numbers are permanent; never renumber. If a finding is wrong, keep the file and set
  **Status: Retracted** with a note, so the reasoning trail survives.
- Prefer one focused finding per file. Link related findings with `[#NNNN](NNNN-...md)`.
- Coordinates from `Area.add`: object `x`/`y` are in pixels; tile = 40 px, so
  `col = x/40`, `row = y/40`. Rooms are 31×26 tiles.
