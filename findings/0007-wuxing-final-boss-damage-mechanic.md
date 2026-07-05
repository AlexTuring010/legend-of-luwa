# 0007 — Monster WuXing (final boss): the reflect→knife→red‑circle damage combo, and the shadow‑LuWa summon

- **Status:** Confirmed — solved in‑game by the player
- **Date:** 2026-07-06
- **Tags:** final-boss, wuxing, xuan-tower, damage-mechanic, reflect, thunder, knife, red-circle, shadow-luwa, mShadow
- **Related:** [#0003](0003-caved4-mummy-room-qinglong.md) (mummy — conditional invincibility + code‑driven spawn, direct parallel)

## Summary

**Monster WuXing** (type `bWuXing` `0x2f`), the final boss on **Tower07** (top of Xuan Tower), is **immune to all direct attacks by default.** You unlock his vulnerability each cycle with a **three‑step combo**: **reflect his thunder back at him → a white circle appears under him → throw a knife (his own knife type) at him while the circle is white → the circle turns red → now your attacks damage him.** He also **dynamically summons shadow‑LuWas** (`mShadow` `0x158`).

## How to damage him (player‑confirmed)

Normal hits do nothing — his body is immune until you "unlock" him each cycle:

1. **Reflect his thunder back into him.** When WuXing throws a thunder/lightning bolt, hit it so it bounces back and strikes him → a **white circle** appears under him. *(This step deals no damage — it's the setup.)*
2. **Throw a knife at him while the circle is white** — specifically **the same knife he throws at you** (the *Knife* bullet). This flips the circle **white → red**.
3. **While the circle is red, attack him** — he's now vulnerable and **loses HP.** You get a **few‑second window** per red circle before it fades.
4. **Every hit you land floods the room with small monsters.** Clear them with **Blood Magic** (press **Space** = kill all small monsters in the room). If you're low on life, **spam bombs** to clear the adds instead — the dead monsters can **drop healing potions**, and even **cats** (extra lives / respawns).
5. **Repeat** the cycle (reflect → knife → red → hit → clear the adds) until his **3000 HP** is gone.

**Requirement:** you need the **Knife bullet** (one of the four learnable bullets — darts / arrows / knives / ice darts) for step 2. Reflecting (step 1) is likely the intended job of **Bounce Magic** ("reflects some of enemy's bullets", manual kungfu list).

## The shadow‑LuWa summon

WuXing **spawns `mShadow` (type `0x158`) at runtime** — dark, LuWa‑looking minions that attack the player. `mShadow` is placed **0 times** in any map (`Area.add`) because it's a **code‑driven summon**, not a placed object — the same reason the mummy's split‑children ([#0003](0003-caved4-mummy-room-qinglong.md)) never appear in the map data.

> **Correction to an earlier project assessment.** A prior investigation rated the "shadow‑LuWa final boss" childhood memory as *likely false (~5–10%)*, because no shadow/LuWa boss type is **placed** anywhere. That verdict was **wrong** — the shadows are **real**, just **dynamically summoned**, so a static‑placement scan can't see them. Lesson: **"0 placements" ≠ "cut content"** for anything a boss can spawn. `mShadow` is the game's only shadow enemy (all other shadow‑ish types are the `mGhostA–H` family).

## Evidence

- **Player‑confirmed in‑game:** the reflect → white‑circle → knife → red‑circle → damage cycle; and WuXing summoning shadow‑LuWas that attack the player.
- **Data:** `bWuXing` = type `0x2f` (Spc.add record @ `18357`), placed once in **Tower07** (Area.add chunk @ `771876`) at **col 21, row 5** — the only enemy on the top floor. `mShadow` = type `0x158`, **0 placements** across all of `Area.add` (15,121 CD‑delimited records) = dynamic summon. WuXing's def does **not** contain `mShadow`'s type id as a field → the summon is hardcoded in his behavior code (as with the mummy's split in [#0003](0003-caved4-mummy-room-qinglong.md)).
- **His stats (Spc.add, byte‑verified):** **HP = 3000** (byte `0x8` = `0x0bb8`; cf. `bWater` 4000, `bFire` 900), attack = 100. So he is **finite / killable** — once you flip the circle red, sustained hits *will* drain him; there's no bottomless HP.
- **No static "immune" flag.** His def flag sits in the normal boss family (no `type‑0x2f` immunity branch in the decompiled death path) — i.e. his invulnerability is **not** a permanent bit, it's a **conditional, code‑driven gate**. That matches the mechanic exactly: the reflect→knife→red‑circle combo is what *opens* the gate; nothing has to override an "always immune" flag.

## Open questions

- The exact code path for the **red‑circle vulnerability flip** (reflect + knife → damageable state) and the `mShadow` summon — would need a targeted Ghidra trace on `Luwa.exe` (like [#0003](0003-caved4-mummy-room-qinglong.md)'s `FUN_0040d550`). *(A def+partial‑decompilation sweep this project ran did **not** find it — WuXing's own class methods aren't in the partial `decomp.c`, and a data‑only guess was wrong and self‑refuted. The mechanic was found **in‑game**, a reminder that runtime boss behavior needs playtesting, not just byte‑mining.)*
- Whether `mShadow`'s sprite is literally a recolored **LuWa** (in the undecoded `Pic.add`) — the player reports it looks like a dark LuWa.

## Note for the wiki

**Final boss — Monster WuXing (top of Xuan Tower).** Immune to direct hits. Each cycle: **reflect his thunder back at him (white circle appears) → throw a Knife at him while it's white (circle turns red) → then attack him (he takes damage).** He also summons shadow‑LuWa minions that chase you. Bring the **Knife bullet**, and ideally **Bounce Magic** for the reflect.
