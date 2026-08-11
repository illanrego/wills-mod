# Changelog

## 0.1.2 — 2026-08-11

- Fixes battle owned-ball X alignment by using fixed icon slots beside the name fields instead of deriving X from `Font.width(name)`.
- Enemy/rival ball now sits at the far-left name icon slot; player ball sits just before the player name.

## 0.1.1 — 2026-08-11

- Aligns owned-ball markers from the live battle screenshot: enemy/rival marker shifts one tile left; our/player marker shifts one tile right in wide battle layout.

## 0.1.0 — 2026-08-11

- First release.
- Adds Pokédex owned-ball markers beside battler names in battle (classic and wide layouts).
- Wraps the engine's public battle.overlay hook; read-only, no permissions.
