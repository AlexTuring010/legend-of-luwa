# Reverse‑engineered file formats & RE playbook

How _Legend of LuWa_'s `*.add` and `*.sav` files are structured, plus the techniques (and
mistakes) from decoding them. Extend as we learn.

## TL;DR — the biggest time‑savers (read these first)

1. **An object's identity is its record `type` u32 — NOT the editor label string.** Labels like
   `Brick`, `BrickD`, `u`, `d`, `med` are throwaway names reused across *dozens* of unrelated types.
   Always resolve the `type` through `Spc.add`. (I wasted a lot of time treating labels as identity.)
2. **`Spc.add` IS the type table.** `type` is an index into it → gives the real name + properties.
3. **Records end with `CD CD CD CD`.** Split on that to count/parse reliably. Ad‑hoc byte‑walkers
   **under‑count** (they desync on variable‑length records) — burned me repeatedly.
4. **To mod game data:** write your edited file to
   `C:\Users\<u>\AppData\Local\VirtualStore\Program Files\LegendOfLuwa\` — the (virtualized) game
   reads *that* instead of the install, the real install is never touched, and revert = delete the
   overlay. The game reads data at **map load**, so changes need a room reload/restart to show.
5. **The running game loads *all* of `Area.add`.** Every map name is in memory once; the **current +
   adjacent rooms appear 2–3×** (others 1×). That's how to find "what room is the player in."
6. **One object can render as many tiles.** A single `mBrickHA` draws as a whole *row* of bricks — so
   "24 blocks" the player sees can be 1 object. Don't expect object counts to match visual counts.

## `Spc.add` — the master type/definition table

Header + offset table + records:

```
[u32 count]                 = 0x205 = 517 entries
[count × u32 offset]        offset table: entry i → byte offset of record i
... records ...             each: [dwords...][u32 namelen][name][u32 prop dwords...]
```

Resolve a `type` id → name + props (PowerShell):

```powershell
$spc=[IO.File]::ReadAllBytes("game-data/Spc.add")
function TOff($i){ [BitConverter]::ToUInt32($spc,4+$i*4) }            # type id -> record offset
function RName($ro){ for($p=$ro;$p -lt $ro+60;$p++){ $L=[BitConverter]::ToUInt32($spc,$p)
  if($L -ge 2 -and $L -le 20){ $ok=$true; for($j=0;$j -lt $L;$j++){ $c=$spc[$p+4+$j]
    if($c -lt 32 -or $c -gt 126){$ok=$false;break} }
    if($ok){ $n=-join(0..($L-1)|%{[char]$spc[$p+4+$_]}); if($n -match '[A-Za-z]{2}'){return $n} } } } }
# name = RName (TOff $type)
```

### Type name prefixes (the roster is ~517 entries)

| Prefix | Meaning | Examples |
|---|---|---|
| `m*` | **Monster** | `mZummyB` (mummy), `mRat`, `mBatBig`, `mBrickHA` (**invincible brick‑monster used as a wall!**) |
| `e*` | Environment / scenery | `eBrickHA` (solid wall), `eBrickHAFls` (passable *fake* wall), `eBrickDBSld` (sliding/pushable block), `eStairB` |
| `d*` | Doors / holes / stairs | `dDoorHA`, `dHoleAu`, `dStairAUp` |
| `00*` | Projectiles | `00FireBall`, `00IceBall`, `00DirtBall`, `00Bone` |
| `i*` | Items on the ground | `iLadder`, `iGoldA`, `iArrow`, `iDart` |
| `Seperat*` | Separators / dividers | `SeperatC`, `SeperatD1` |
| `Wall*` / `wallbreak` | The **actually breakable** wall types | `wallbreak`, `WallBreak1`, `WallHa1..3` |

### Key resolved type IDs (from the mummy‑room work)

| id | name | notes |
|---|---|---|
| `0x6c` | `eBrickHA` | standard **solid** wall (see collision below) |
| `0x6d` | `eBrickHAFls` | **passable fake wall** (identical sprite, walk through) |
| `0x67` | `eBrickDBSld` | **sliding / pushable** block ("movable thing") |
| `0x133` | `mBrickHA` | **invincible brick‑MONSTER** used as a divider — dings, never breaks |
| `0x16c` | `mZummyB` | the "pink mummy" |
| `0x155` | `mRat` | small rats |
| `0xde` | `HoleInvOn` | invisible hole/opening (passability family) |
| `0x1b9` / `0x1b7` | `StepAU` / `StepAD` | stairs up / down (the "ladder" that yanks you up = StepAU) |

## `Area.add` — maps, objects, dialog

A flat sequence of **map chunks**. Chunk = ID string (`CaveD403\0`, `Dun4021\0`) then a header
(`05 00 00`, size dword, `FF FF FF FF`, **width=0x1f=31**, **height=0x1a=26**, …), then the
object records, with dialog inlined.

Rooms are **31×26 tiles**, tile = **40 px** → `col = x/40`, `row = y/40`.

### Object record

```
[u32 type][u32 namelen][name][u32 x][u32 y][prop dwords…] CD CD CD CD
```

- Reliable full histogram = collect record starts at chunk start + every position after a
  `CD CD CD CD` run, read `type` at each, resolve via `Spc.add`. (Don't hand‑roll a length walker.)
- Dialog: inline ASCII with `$$n0/$$n1/$$n2` (speaker/box) and `$$h0` ("hero got…") markers, `\r\n`
  line breaks; grants read `LuWa got the <item>.`

### Passability / collision

- `eBrickHA` (solid) vs `eBrickHAFls` (passable) differ by a flag in their `Spc.add` props:
  `eBrickHA` has `0x20030000` where `eBrickHAFls` has `0`. **But in RAM the game parses props into a
  different runtime struct**, so that file‑offset flag does *not* line up in memory — live‑patching
  it failed. To change wall behavior: **edit the file type/flag and reload** (overlay technique).
- To make a wall passable without guessing flags: change its record `type` `0x6c` → `0x6d`
  (eBrickHA → eBrickHAFls). Sprite stays a wall, but you walk through.
- `mBrickHA` is a **monster**, so it can't be "made passable" as a wall type sensibly — but flipping
  its `type` to `0x6d` in a data overlay does neutralise it (used to *confirm* it was the divider).

## Modding technique — the VirtualStore overlay

The game is a legacy **virtualized** app (its saves land in VirtualStore). So:
1. Read the pristine file from `game-data/` (our master copy).
2. Patch bytes, write to `…\AppData\Local\VirtualStore\Program Files\LegendOfLuwa\<File>`.
3. Player fully restarts (or re‑enters the room) → game reads the overlay. Install stays byte‑identical.
4. Revert = delete the overlay file. (Verify `C:\Program Files\LegendOfLuwa\<File>` still matches the master.)

Do **not** write to `C:\Program Files\…` directly (needs admin, and it's the real install — the auto
guard will block it anyway).

## Reading the live game (process memory)

`Get-Process Luwa` → `OpenProcess(0x0438,…)` (VM_OPERATION|READ|WRITE|QUERY) →
walk regions with `VirtualQueryEx` (committed + readable protect) → `ReadProcessMemory` in chunks →
**`[Text.Encoding]::ASCII.GetString` + `String.IndexOf`** for searching (per‑byte PS loops over
100 MB time out). `WriteProcessMemory` works but patching parsed game structs is unreliable (see
collision note) — reading (e.g. current‑room detection) is the solid use.

## Save files — `Proc1.sav` / `Proc2.sav` / `Proc3.sav`

Live in `…\AppData\Local\VirtualStore\Program Files\LegendOfLuwa\`. 46,485 bytes. **You cannot save
inside caves**, so a cave room's exact sub‑position isn't stored (only the world tile, e.g.
`WX6Y6`, appears near the end as text).

Layout: small header (`u32 @16 = 66` = item count) then **two parallel 66‑entry `uint16` arrays**,
indexed in **`Item.add` order**:

| Array | Offset | Meaning |
|---|---|---|
| Array 1 | **20** (`20 + 2*(idx-1)`) | owned / **capacity**. Swords: 1 = owned. "Bag" items: **number of bags = max ammo ÷ 10** (e.g. IceBomb Bag `30` → cap `300`). Kungfu/magic: 1 = learned. |
| Array 2 | **156** (`156 + 2*(idx-1)`) | **current ammo count** for bullets/bombs (Dart, Arrow, IceBomb, …). |

Useful offsets: Fire Sword @26, Xuan Sword @28; Blood Magic @106, Run Magic @112; IceBomb *count* @178.
Edit two bytes, player reloads slot (don't Save first if the game's running, or it overwrites).

## PowerShell gotchas (all hit during this project)

- **No Python** (Store stub only), **no `strings`** binary. Use PowerShell for bytes; `tr -c '[:print:]'` for text.
- **`[int]$x` throws on `u32 > 2^31`** ("Value too large for Int32"). Guard: `if($x -lt 0x2000 -and …)` or compare as `uint`.
- **`$pid` is a read‑only automatic variable** — name your target `$tpid`.
- **Little‑endian**: `0x20030000` in memory is bytes `00 00 03 20`. Getting this backwards = 0 matches.
- **A `for`/`while` loop piped to `Out-String` is a parse error** ("empty pipe element") — collect to an array first.
- Char‑by‑char loops over large buffers are far too slow — use `.GetString` + `.IndexOf`.

## Superseded / corrections

- The earlier "edge/wall type IDs `0x7e–0x81` = walls, `u/d/l/r` = edge markers" model was **wrong** —
  it mis‑read throwaway labels as identity. Resolve `type` through `Spc.add` instead.

## TODO / next decodes

- Decode a monster's `Spc.add` props: which field is HP, which is the damage‑immunity flag (`mBrickHA`
  is immune — nail the flag so we can predict what breaks any given wall).
- Locate per‑room world position to stitch full floor‑plans (world coords aren't per‑room in `Area.add`).
- Decode `Pic.add` (sprites) for the wiki.
- Monster **respawn** rule — **answered** (it's the splitter‑death bug; see [#0003](../findings/0003-caved4-mummy-room-qinglong.md)). Still open: the exact permanent‑kill flag location in the `.sav`.
