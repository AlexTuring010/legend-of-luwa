# game-data/

Copies of the installed game's data files, taken from `C:\Program Files\LegendOfLuwa\`
(game version **2.4e**). These are the **primary research source** for the project — all
in‑game text and logic lives here.

| File | Size | What it is |
|---|---|---|
| `Area.add` | 774 KB | All maps/rooms + their objects (walls, doors, monsters, pickups) + all NPC dialog & quest text. The most important file. |
| `Item.add` | 2.9 KB | Master item name list. |
| `Spc.add` | 163 KB | Projectile / special‑effect definitions. |
| `Show.add` | 4 KB | Cutscene / show sequences. |
| `World.add` | 5.9 KB | World‑map layout / area index. |
| `Luwa.hlp` | 302 KB | Official manual (legacy WinHelp format). |
| `Luwa.cnt` | <1 KB | Manual contents/index file. |

## Not included here (large binary assets)

These live only in the install and are **git‑ignored** to keep the repo lean. Copy on demand:

```bash
cp "/c/Program Files/LegendOfLuwa/Pic.add"  game-data/   # 20 MB — all graphics/sprites
cp "/c/Program Files/LegendOfLuwa/Wave.add" game-data/   # 1 MB  — audio
```

## Refreshing these copies

If the game is reinstalled/updated, re‑copy:

```bash
cp "/c/Program Files/LegendOfLuwa/"{Area,Item,Spc,Show,World}.add game-data/
cp "/c/Program Files/LegendOfLuwa/"Luwa.{hlp,cnt} game-data/
```

See `../research/file-formats.md` for how these files are structured and decoded.
