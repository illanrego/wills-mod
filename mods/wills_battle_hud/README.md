# Will's Battle HUD

**Pokédex owned-ball markers beside battler names in battle — FireRed/LeafGreen style.**

When you battle a Pokémon whose species is already in your caught dex, a Pokédex ball appears right after its name — for the enemy and for your own Pokémon. Works in classic and wide battle layouts, and derives everything from your save and imported ROM data.

## Install

1. Open **MODS** in Gen1Recomp (`F10` on desktop).
2. **Import mod .zip** and select `wills_battle_hud-0.1.3.zip`.
3. Enable **Will's Battle HUD**.

## Usage

Battle any wild or trainer Pokémon. If you already own the species, a ball marker shows beside the name. Nothing else changes — no input, no battle mechanics, no link state.

## Development

Requires the Gen1Recomp AppImage runtime plus the official modkit tooling (see the Encounter Guide repo for the same workflow).

```sh
# run the test suite (fixtures only)
WILLS_MOD_ROOT="$PWD" love tests/runner

# regenerate main.lua after editing lib/
python3 tools/bundle.py

# official mod validation, ROM-content lint, and packaging
modkit validate --base fixture --strict .
modkit lint .
modkit pack -o dist/wills_battle_hud-0.1.3.zip .
```

## Scope

- **In:** owned-ball markers on battler names (classic + wide layouts).
- **Planned:** EXP bar under the player's name (FR/LG style), from the imported growth curves.

Part of **Will's Mod** — a collection of Gen1Recomp mods by Illan.
