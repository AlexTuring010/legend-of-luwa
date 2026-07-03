# 0001 — Warm Ball: trade item for the Fire Sword

- **Status:** Confirmed
- **Date:** 2026-07-04
- **Tags:** item, quest, trade, fire-sword, ex-jade
- **Related:** [#0002](0002-hidden-room-dun4021-grandma-cell.md)

## Summary

The **Warm Ball** is a quest/key item — a warmth‑radiating "precious stone." Its sole purpose
is a single trade: you give it to a **freezing man in a cold cave**, and he hands you the
**Fire Sword** (attack power 60, 5 sword bullets — a major weapon upgrade). You obtain the
Warm Ball earlier as a reward for saving an old man's granddaughter.

## Evidence

Item exists in the master list:
- `game-data/Item.add` — entry **"Warm Ball"** (grouped with quest treasures: Ex‑Jade, Silver
  Rabbit, Golden Frog, Ladder, Gold Flower, Miner Permit, …).

Obtaining it (reward for saving the granddaughter), `game-data/Area.add`:
- @ `663098` — `LuWa got the Warm Ball.`
- @ `663402`–`663453` — `Let me change 1000 coins / to the Warm Ball.` … `LuWa returned 1000 coins / and got the Warm ball.`
  → the reward is a **choice of 1000 coins _or_ the Warm Ball**, and you can swap the coins for
  it later (so the game values it ≥ 1000 coins).

Using it (the trade), `game-data/Area.add`:
- @ `708586`–`708607` — `…I would definitely trade it / for warmness!`
- @ `708672` — `Trade WarmBall with Fire Sword`
- @ `708734` — `LuWs got the Fire Sword.` _(sic — game's own typo "LuWs")_
- Nearby alt dialog: `Damn, it's too cold! The Fire Sword has little help… Would you like to
  trade your precious stone with my sword which can master fire?`

(Search reproducibly: `grep -i "warm" research/area_strings_offset.txt` gives these byte offsets.)

## How it works (in‑game)

1. Save the old man's granddaughter. As thanks he offers two gifts: **1000 coins or the Warm Ball.**
   Take the Warm Ball (or take coins and swap later).
2. Find the **freezing NPC in a cold cave** (Snow Mountains region). His Fire Sword "does not
   help much" against the cold; he'll trade it away "for warmness."
3. Give him the Warm Ball → he warms up and gives you the **Fire Sword.**

## Reproduction / verification

Data‑confirmed end to end (reward dialog + trade dialog both present). In‑game: complete the
granddaughter rescue, then visit the cold‑cave NPC to execute the trade. Manual confirms Fire
Sword stats (`research/manual.txt`: "Fire Sword: attacking power 60, 5 sword bullets").

## Open questions

- Exact map/room of the cold‑cave NPC (offset ~708k sits in the `Dun60xx`/late‑game region).
- Exact location of the granddaughter‑rescue giver (offset ~663k).
