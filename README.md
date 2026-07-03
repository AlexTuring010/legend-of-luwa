# Legend of LuWa — Secrets & Wiki Project

A research project to **fully document the 2002 action‑adventure game _Legend of LuWa_** —
its items, weapons, treasures, kungfu, bosses, areas, hidden rooms, and a complete
walkthrough — and turn that into a public wiki.

The game is old and obscure: at the time this project started there was essentially
**no walkthrough, item guide, or wiki anywhere online** (just a MobyGames stub and a few
store pages). That's the opportunity — anything documented here is close to the definitive
resource.

Because the game ships its content in custom `*.add` data files, most of the game's text
(all NPC dialog, item names, quest logic) can be **extracted and verified directly from the
data** instead of reconstructed from memory. That's what makes a one‑person wiki realistic.

---

## What's in here

| Folder | What it holds |
|---|---|
| `installer/` | The original distribution: `setup.exe`, `disk1.pak`, the cnc‑ddraw lag `_fix/`, and install readme/`.bat`. Kept so the game can always be reinstalled. **Not the game itself** — this is the installer. |
| `game-data/` | Copies of the installed game's data files (`Area.add`, `Item.add`, …) + the manual (`Luwa.hlp`). This is the **primary research source**. |
| `research/` | Derived artifacts: extracted manual text, string/offset indexes of `Area.add`, decoded file‑format notes. |
| `findings/` | **The research log.** One numbered markdown file per discovered secret/mechanic, with evidence. Start at `findings/README.md`. |
| `wiki/` | Draft wiki content, seeded from the data (items, treasures, walkthrough, …). |

The live installed game lives at `C:\Program Files\LegendOfLuwa\` (game version **2.4e**).

## The game, briefly

Real‑time fighting adventure set in mythical ancient China. You play **LuWa**, a teenage
warrior whose village was attacked; the goal is to defeat **Monster WuXing** in **Xuan Tower**
and save the **Green Angel**. Six areas — Greenfield, Yellowfield, Forest, Gold Mine, Desert,
Snow Mountains — then the final tower.

## How to record a discovery

Every secret we find gets logged. See **[`findings/README.md`](findings/README.md)** for the
convention; copy `findings/TEMPLATE.md`, give it the next number, and fill it in with the
**evidence** (which file, which byte offsets, which dialog). Confirmed examples:

- [`findings/0001-warm-ball.md`](findings/0001-warm-ball.md) — what the Warm Ball does
- [`findings/0002-hidden-room-dun4021-grandma-cell.md`](findings/0002-hidden-room-dun4021-grandma-cell.md) — the doorless secret room after Monster Gold

## Legal / scope note

_Legend of LuWa_ © 1999–2001 Beijing PingYi Software Co. Ltd.; © 2002 Loowa Software Company.
This repo is for **personal research and documentation**. The `installer/` is retained for
personal reinstallation. Game assets (graphics/audio) are **not** redistributed publicly;
the wiki publishes documentation, not the game.
