# Reverse‑engineered file formats

Notes on how _Legend of LuWa_'s `*.add` data files are structured. Everything here was derived
by hex analysis of `game-data/` — treat it as "best current understanding," extend as we learn.

## Tooling reminders (Windows env)

- **No Python** (Store stub only). Use **PowerShell** for bytes:
  `$b=[IO.File]::ReadAllBytes($path); [BitConverter]::ToUInt32($b,$off)`.
- **No `strings`.** Extract text with: `LC_ALL=C tr -c '[:print:]' '\n' < FILE | grep -aE '.{3,}'`.
- `research/area_strings_offset.txt` = every ASCII run in `Area.add` as `byteOffset<TAB>text`
  (regenerate with the PowerShell scan below). Grep it, then hex‑dump the offset.

## `Area.add` — maps, objects, dialog

A flat sequence of **map chunks**. Each chunk:

```
<ID string>\0            e.g. "Dun4021\0", "Village1\0", "CaveF201\0"
05 00 00                 chunk marker
<u32 size>               d0 02 = 720 for Dun4021 (chunk/data size-ish)
FF FF FF FF
<u32 width>  = 0x1f (31) tiles
<u32 height> = 0x1a (26) tiles
FF FF FF FF
... a few dwords (start position, etc.) ...
<object records>
<inline dialog>
```

Rooms are **31×26 tiles**; a tile is **40 px**, so world coords run to ~1280×960.
Convert an object's pixel coord to a tile: `col = x/40`, `row = y/40`.

### Object record

```
[u32 type][u32 namelen][name: namelen bytes][u32 x][u32 y][params…] <pad> CD CD CD CD
```

- `CD CD CD CD` is MSVC uninitialized‑memory fill; it reliably pads/terminates records, so it's
  handy as a record separator when walking the chunk.
- **Names seen:** `Brick` (wall block), `u`/`d`/`l`/`r` (single‑char edge/wall‑segment markers,
  up/down/left/right), `med` (a pickup/item), `m1`/`m2`/… (monsters), `DoorL`/`DoorU`/`DoorD`
  (doors), plus NPC names (`Hero`, `Boy`, `girl`, `npc`, `doc`).

### Edge/wall **type IDs** (the key to finding secrets)

The `type` dword on `Brick` and on `u/d/l/r` edge markers encodes the tile/behavior:

| Type range | Meaning (working theory) |
|---|---|
| `0x7e, 0x7f, 0x80, 0x81` | **Ordinary walls** — repeat all around every room perimeter. |
| rare values (`0x06, 0x0b, 0x22, 0x24, 0x2d, 0x3d, 0x104, 0x198, …`) | **Doorways / special passages / fake walls** — a rare type sitting on an edge marks where a room actually opens. |
| `0xfd` on `med` records | a collectible pickup (e.g. the gold hoard in `Dun4020`). |

**Method to find a hidden entrance:** render a room's objects to a grid, then look for the edge
whose type is *not* in the ordinary‑wall set. That edge is the way in. (This is how
[finding #0002](../findings/0002-hidden-room-dun4021-grandma-cell.md) located the doorless cell.)

### Dungeon numbering

- `Dun40xx` = **Monster Gold's castle** (rooms `Dun4001`–`Dun4021`).
- `Dun60xx` = **large final dungeon** (`Dun6001`–`Dun6030`, likely Xuan Tower).
- Higher room number ≈ deeper. Some rooms cross‑reference each other by ID string (warps/stairs,
  e.g. `Dun4008`↔`Dun4015`); most adjacency is spatial, not string‑referenced.

### Dialog

Inline ASCII with markers: `$$n0`/`$$n1`/`$$n2` (speaker/box variants), `$$h0` ("hero got …"
event lines), and `\r\n` line breaks. Item‑grant lines read like `LuWa got the <item>.`

### Regenerate the offset index

```powershell
$b=[IO.File]::ReadAllBytes("game-data/Area.add"); $s=[Text.StringBuilder]::new(); $st=-1
$o=@(); for($i=0;$i -lt $b.Length;$i++){ $c=$b[$i]
  if($c -ge 32 -and $c -le 126){ if($st -lt 0){$st=$i}; [void]$s.Append([char]$c) }
  else { if($s.Length -ge 3){$o+="$st`t$($s)"}; [void]$s.Clear(); $st=-1 } }
$o | Out-File research/area_strings_offset.txt -Encoding utf8
```

## Other files (less explored)

- `Item.add` — item **name** table (behavior lives in `Area.add`/manual).
- `Spc.add` — projectile/effect defs (`FireBall`, `IceBall`, `DirtBall`, …).
- `World.add` — world map / area index; uses `WX#Y#` coordinate tokens.
- `Show.add` — cutscene/show sequences.
- `Pic.add` / `Wave.add` — graphics / audio (not yet decoded; not in repo — see `game-data/README.md`).
- `Luwa.hlp` — WinHelp manual; text already extracted to `research/manual.txt`.

## TODO / next decodes

- Confirm the exact semantic of each special edge type (map type → door vs fake wall vs one‑way).
- Locate per‑room spatial position (to stitch full floor‑plans).
- Decode the `med`/pickup `params` to read **which item** a pickup grants.
- Decode `Pic.add` (sprite/graphic extraction for the wiki).
