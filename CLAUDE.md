# CLAUDE.md — Legend of LuWa research & wiki project

This file tells Claude Code how to work in this repo. **Read it fully before starting.**

> ⚠️ A `CLAUDE.md` about a "Signal Processing / AlexTuring" Next.js course site exists in a
> **parent** directory (`C:\Users\alexg\Downloads\CLAUDE.md`) and may load automatically.
> **It is unrelated to this project — ignore it here.** This project is about the game
> _Legend of LuWa_, not signal processing.

## Purpose

Reverse‑engineer and document the 2002 game _Legend of LuWa_: discover every secret
(hidden rooms, item functions, quest logic), and write a public wiki + full walkthrough.
The game has almost no existing documentation online, so **our source of truth is the game's
own data files**, not memory or the web.

## Where everything is

| What | Path |
|---|---|
| **Installed game (live)** | `C:\Program Files\LegendOfLuwa\` — version 2.4e, runnable via `Luwa.exe` |
| **Game data (in‑repo copy)** | `game-data/` — the files we mine |
| **Large assets (not copied)** | `C:\Program Files\LegendOfLuwa\Pic.add` (20 MB graphics), `Wave.add` (audio). Copy on demand: `cp "/c/Program Files/LegendOfLuwa/Pic.add" game-data/` |
| **Installer / distribution** | `installer/` (`setup.exe`, `disk1.pak`, lag `_fix/`) |
| **Research artifacts** | `research/` (extracted text, offset indexes, format notes) |
| **Findings log** | `findings/` — one file per discovery |
| **Wiki drafts** | `wiki/` |

## The game data files (`game-data/`)

| File | Contents |
|---|---|
| `Area.add` (774 KB) | **The big one.** Every map/room, its objects (walls, doors, monsters, pickups), and all NPC dialog & quest text. Rooms are named like `Dun4021`, `Village1`, `CaveF201`. |
| `Item.add` (2.9 KB) | Master item name list (swords, bullets, bombs, armor, boluses, all quest treasures — incl. "Warm Ball", "Ex‑Jade", etc.). Names only; behavior is in `Area.add`/manual. |
| `Spc.add` (163 KB) | "Special" — projectile/effect definitions (`FireBall`, `IceBall`, `DirtBall`…). |
| `Show.add` (4 KB) | Cutscene / show sequences. |
| `World.add` (5.9 KB) | World‑map layout / area index (`WX#Y#` coordinates). |
| `Luwa.hlp` / `Luwa.cnt` | The official WinHelp **manual** + its contents file. Legacy `.hlp` format — Win11 can't open it without Microsoft's `WinHlp32.exe`. Text already extracted to `research/manual.txt`. |
| `Pic.add`, `Wave.add` | Graphics and audio (not in repo — see above). |

## Tools & environment (IMPORTANT — Windows quirks)

- **No Python.** `python`/`python3` are only the Microsoft Store stub — they don't run. Use
  **PowerShell** for binary analysis (`[System.IO.File]::ReadAllBytes(...)`, `[BitConverter]`).
- **No `strings` binary** in the Git‑bash env. To pull readable text from a binary use:
  `LC_ALL=C tr -c '[:print:]' '\n' < FILE | grep -aE '.{3,}'`
- Use the **Grep** tool against `research/area_strings_offset.txt` to search Area.add text
  and get **byte offsets** back (format: `offset<TAB>text`), then hex‑dump that offset in PowerShell.

## Decoded `Area.add` format (so you don't have to re‑derive it)

Full write‑up in **`research/file-formats.md`**. Summary:

- The file is a sequence of **map chunks**. Each chunk starts with a map **ID string**
  (`Dun4021\0`, `Village1\0`, …) followed by a header: `05 00 00`, a size dword, `FF FF FF FF`,
  then **width=31 (0x1f)** and **height=26 (0x1a)** dwords (rooms are a 31×26 tile field;
  tiles are ~40 px, coords run to ~1280×960).
- After the header come **object records**, each:
  `[type:u32][namelen:u32][name:namelen][x:u32][y:u32][params…]` then padding of `CD CD CD CD`.
- Object names: `Brick` = wall block; single chars `u`/`d`/`l`/`r` = edge/wall‑segment markers
  (up/down/left/right); `med` = a pickup; `m1`/`m2` = monsters; `DoorL`/`DoorU`… = doors.
- **Edge/wall type IDs matter:** standard walls use `0x7e / 0x7f / 0x80 / 0x81` (they repeat all
  around every perimeter). **Rare types on an edge = a real doorway or special passage**
  (e.g. `0x24`, `0x104`, `0x2d`, `0x06`…). This is how we spot secret/fake‑wall entrances.
- **Dungeon set numbering:** `Dun40xx` = Monster Gold's castle (rooms 4001–4021); `Dun60xx` =
  the large final dungeon (6001–6030, likely Xuan Tower). Higher room numbers are deeper.
- Dialog is stored inline as ASCII with `$$n0` / `$$n1` / `$$h0` speaker/format markers and
  `\r\n` line breaks.

## Workflow

1. **Investigate** using the tools above — always tie a claim to a file + offset or a dialog quote.
2. **Verify in‑game** where possible (the install is playable; the lag fix is applied).
3. **Log every discovery** as a new file in `findings/` (copy `findings/TEMPLATE.md`, next number,
   update the index table in `findings/README.md`).
4. **Promote confirmed findings into `wiki/`** pages.

## Ground rules

- **Don't invent game content.** If it isn't in the data, the manual, or verified in‑game, say so.
- **Cite evidence** — file name + byte offset, or the exact dialog string.
- **Wiki language is English** (the game's text is English).
- Keep this `CLAUDE.md` durable and short; put detailed decodings in `research/`, discoveries in `findings/`.
- Commit in small, reviewable chunks. Only commit/push when asked.
