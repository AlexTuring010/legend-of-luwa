# Items, Weapons & Treasures

Source legend: 📖 manual · 🔬 data (`Area.add`/`Item.add`) · 🎮 in‑game · ❓ unconfirmed.
Full item name list is in `game-data/Item.add`.

## Swords 📖

Your main weapon. Equip the newest one you own (menu → Weapon and armor).

| Sword | Attack power | Sword bullets |
|---|---|---|
| Practise Sword | 6 | — |
| Bravery Sword | 15 | — |
| Dragon Sword | 30 | 3 |
| **Fire Sword** | 60 | 5 |
| Xuan Sword | 100 | 3 |

> Sword bullets fire when you swing at full breath **after** learning Power Magic.
> The **Fire Sword** is obtained by trading the **Warm Ball** to a freezing cave NPC —
> see [finding #0001](../findings/0001-warm-ball.md).

## Bullets & Bombs 📖

- **Bullets** (need skill + purchase): darts, arrows, knives, ice darts.
- **Bombs** (no skill needed, hard to buy): arrow bomb, dirt bomb, ice bomb, fire bomb.
- The **DirtBomb** is described as "very powerful — save it until you really need it." 🔬
  Note: it does **not** open the doorless secret cell `Dun4021` (that's a walk‑through fake
  wall, not a bombable one — [finding #0002](../findings/0002-hidden-room-dun4021-grandma-cell.md)).

## Armor 🔬

Leather → Bronze → DarkSilk → GoldSilk (`Item.add` order; effects ❓ — confirm in‑game).

## Consumable items 📖

| Item | Effect |
|---|---|
| Life bottle | Auto‑used when collected (not shown in menu); raises max life. |
| Med Bolus | Restores 10 life. |
| Med Bolus L | Restores 20 life. |
| Torch | Lights up one room. |

## Kungfu (magic) 📖

| Kungfu | Effect |
|---|---|
| Drop Magic | Drops some enemy bullets. |
| Bounce Magic | Reflects some enemy bullets. |
| Power Magic | At full breath: 4× sword power + fire sword bullets. |
| Run Magic | 2× sword power; lets LuWa jump onto low walls. |
| Blood Magic | Kills all small monsters in a room; costs life (20, then 30, 40…). |
| Breath Dao | Saves breath when fighting/running. |
| Recover Dao | Speeds up breath recovery. |

## Treasures 📖🔬

Documented in the manual 📖:

| Treasure | Effect |
|---|---|
| Key | Opens one specific dungeon/cave door (not shown in menu). |
| Dungeon map | Shows a dungeon's map (`?` = important treasure or locked door). |
| Bolus Hulu | Holds 5 Med Boluses. |
| Woodcat | Revives LuWa when killed. |
| Cateye | See further in darkness. |
| OldSilk Boots | Protect LuWa's feet in the desert. |
| Ladder | Cross lava or water. |

Additional quest treasures present in `Item.add` 🔬 (functions from data/quests; confirm in‑game):

| Item | Notes |
|---|---|
| **Warm Ball** | Trade for the Fire Sword. ✅ [#0001](../findings/0001-warm-ball.md) |
| **Ex‑Jade** / Half Ex‑Jade | Magical item Monster Gold kidnapped grandma for; collected in two halves, then combined. 🔬 [#0002](../findings/0002-hidden-room-dun4021-grandma-cell.md) |
| Xuan Iron | Quest material (smithing‑related). ❓ |
| Cheng Wood | Quest material. ❓ |
| Miner Permit | Grants entry to the gold mine. ❓ |
| Gold Pin | Given to an NPC in a quest. ❓ |
| Wine Hulu | Traded to an NPC ("Give it to…"). ❓ |
| Smith's Book | Smithing‑related. ❓ |
| Silver Rabbit, Golden Frog, Gold Flower, Green Bolus, Wood Lotus, Home Coin, Letter, Map | Quest/key items — roles ❓, to be traced in `Area.add`. |

---

_To extend: grep `research/area_script_text.txt` for an item name to find the NPC/quest dialog
that uses it, confirm the effect, then update the relevant row and cite the offset._
