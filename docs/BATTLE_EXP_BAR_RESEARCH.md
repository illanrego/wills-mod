# Battle EXP Bar — Research (2026-08-13)

**Question:** is there a Gen1Recomp mod showing an experience bar in battle
like FireRed/LeafGreen (FR/LG-style battle EXP bar)?

**Short answer: yes — it exists, in two forms. Do not build a separate mod
for it** (same reasoning as the battle HUD removal: covered elsewhere).

## What exists

| Mod | Style | Placement | License | Link |
|---|---|---|---|---|
| `battle_exp_bar` (madramdesign) | Gen 3+ / FRLG-style, blue fill, fills right-to-left toward next level, animates on EXP gain/level-up, classic + wide layouts, style options BLUE/BLACK/OFF | under the player's **HP bar** | MIT | https://github.com/madramdesign/gen1recomp-battle-exp-bar |
| Gen II battle EXP bar (Deftones565 QoL pack) | Gen II-style bar inside a quality-of-life pack (`EXP BAR` toggle) | battle HUD | MIT | https://github.com/Deftones565/gen1recomp-mod-quality-of-life |

Note: in the real FRLG games the EXP bar sits **below the HP bar** — which is
exactly what the standalone `battle_exp_bar` mod renders. A variant placed
*below the Pokémon name* is not a standard FRLG layout and was not found in
any source searched.

## Sources searched (2026-08-13)

- FAFF0x/gen1recomp mod list (the community "official" mods page): 30+ mods —
  Advanced Box System, Area DexNav, Catch Helper, DV/EV Editor, EXP Share
  Modes, Free Master Ball/Rare Candy, Guaranteed Catch, HM Anywhere, Item
  Shortcut, Kanto Achievements, Modern Bag, Move Inspector/Learn Stats/Moves
  Manager, Nickname Changer, Pokédex Plus, Trade Evolution Fix, Quest System,
  Repel Reuse, Reusable Machines, Summon, Universal Free TM Shop, art mods,
  quests, Performance Monitor — **no battle EXP bar** (EXP Share Modes is
  experience *distribution*, not a bar).
- GameBanana Gen1Recomp section (game 25428): **no EXP bar mod**.
- Official bryanthaboi/gen1recomp gallery (`mods/examples/`): none.
- GitHub repository search (`gen1recomp exp bar`): the two entries above.

## Conclusion / recommendation

- The FR/LG-style battle EXP bar is **already implemented and MIT-licensed**
  (standalone, active 2026-08, has options and wide-layout support).
- Building our own would duplicate it — the same call we made for the
  owned-ball battle HUD (Catch Helper).
- **Recommendation: skip.** If we ever want it, reference the existing mod
  instead; the engine data needed (`data.pokemon[species].growthRate` +
  `data.growth_rates[rate].expForLevel(level)` + `mon.exp`) is already
  verified data-derived, so a from-scratch variant stays possible later.

## If we ever revisit (notes, not a plan)

- Position under the name is NOT the FRLG layout; FRLG puts it under the HP
  bar — match the existing mod's placement if we ever build our own.
- `affects_link: false`, read-only, draw-only hook — same surface as the
  removed battle HUD overlay.
