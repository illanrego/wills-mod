# Encounters Guide — Competition Research (2026-08-13)

**Question:** does anything like our Encounters Guide already exist in the
Gen1Recomp ecosystem?

**Short answer: no map-first encounter guide exists.** The closest mods are
species-first lists or encounter *triggers*; nothing else browses the real
Kanto Town Map with exact-source separation, truthful odds, and a walking
HUD. Our guide is the unique implementation — keep pushing it.

## Closest existing things (checked 2026-08-13)

| Mod | What it actually is | vs. our guide |
|---|---|---|
| `modern_kanto` **ATLAS** (MadeinTaly) | Screen that folds the merged encounter dataset into **one row per species** (level range + dex owned marks), counting per-area owned — answers "what do I still need" | Species-first list. NOT map-first; sources (routes/floors/caves) are **merged**, no exact-source identity, no per-step odds, no walking HUD, no "you are here" |
| **Area DexNav** (FAFF0x pack) | Press SELECT to **start an encounter** with an uncaught mon from the current area's table | Encounter trigger, not a guide |
| **overworld_encounters** (Gamecorner_033) | Visible overworld wild spawns | Different feature (spawns, not info) |
| **recomp_cartographer** (Sedatb23) | Dump maps to Tiled, edit, reload | Map *editing* tool, not a guide |
| `example_dexnav` (official gallery) | START-menu dex overlay with seen/owned counts + exports | Dex *browser*, not an encounter guide |
| **Town Map wild encounter data** (madramdesign MOD-IDEAS.md #3) | An *unbuilt idea*: "overlay [encounter data] on Town Map or a Start-menu 'AREA DEX'" | The exact concept we implemented — nobody built it; the idea note confirms the gap |

## Sources searched

- Official mod index (bryanthaboi/gen1recomp-mod-index, metadata-only
  community index): ~40 mods across translations, music, QoL, quests,
  overworld, UI — no encounter guide.
- madramdesign's mod catalog (CATALOG.md / mods-database.json / MOD-IDEAS.md).
- FAFF0x/gen1recomp bundled mods (30+).
- GameBanana Gen1Recomp section.
- Official gallery examples (`mods/examples/`).
- GitHub repository search.

## What is genuinely unique about ours

1. **Map-first navigation** — the real Kanto Town Map *is* the menu; the
   cursor snaps between encounter-bearing locations.
2. **Exact source identity** — routes, floors, caves, gates, buildings, and
   Pokémon Centers are never merged (`-- MT. MOON 1F` ≠ `-- MT. MOON B1F`).
3. **Truthful data** — LAND/WATER separation, compact level ranges, exact
   per-step odds, all derived at runtime from the player's own import.
4. **You are here** — blinking current-location marker, even off-encounter.
5. **Walking HUD** — AUTO/ALWAYS/OFF + SMALL/MEDIUM/LARGE while exploring.

## Recommended next step

Done (2026-08-13): submitted to the **official mod index**
(bryanthaboi/gen1recomp-mod-index) as PR
https://github.com/bryanthaboi/gen1recomp-mod-index/pull/134
(`mods/Illan@wills_mod/` — meta.json + description.md, schema-validated,
`automatic_version_check: true`). Awaiting maintainer merge; the nightly
refresh then tracks new releases from illanrego/wills-mod automatically.
