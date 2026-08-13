# Will's Mod — Publishing Plan

Status: **GitHub published** (v1.0.0) + **official gallery PR open**: https://github.com/bryanthaboi/gen1recomp/pull/1223 (Lane A, entry #9 `wills_mod` in `mods/examples/`). PR fully verified locally against the user's real Blue import: `modkit validate --base imported --strict` green, lint clean, standalone suite 8/8, merged gallery suite 296/296 (all 9 mods load together, #9 asserts Will's Mod's stated effects). Awaiting maintainer review. Next: GameBanana + Discord announcement.
Everything below is researched against the live gen1recomp repo/wiki (dev
branch, Aug 2026) and GameBanana.

Published GitHub release:
- Repo: https://github.com/illanrego/wills-mod
- Release: https://github.com/illanrego/wills-mod/releases/tag/v1.0.0
- Asset: `wills_mod-1.0.0.zip` + `sha256sums.txt`

---

## 1. How distribution works on this platform (research summary)

Gen1Recomp ships a **native mod platform**: content registries, events and
hooks, per-mod saves/options, and an **in-game mod manager** (Options menu /
`F10`). There is no Steam-Workshop-style store — distribution is:

| Channel | Role | Effort |
|---|---|---|
| **GitHub repo + Releases** | The official update channel. Manifest field `"github": "owner/repo"` makes the in-game manager's **Update / Versions** fetch new `.zip` releases from the repo. Files must sit at the archive root. | Primary. Do this. |
| **GameBanana** | Biggest general mod host. Dedicated section **"Gen1Recomp (Pokémon Red, Blue, Yellow)"** (game id 25428), subcategories **Content** (47804) and **Quality of Life** (47815). Active today (FM music mods, Bigger Bag, QoL packs). | Discoverability. Do this. |
| **Discord** | THE community hub — the official README points to `https://bois.icu` for "SUPPORT / ANNOUNCEMENTS / MODS". Mod showcase posts live here. | Announcement. Do this. |
| **Official gallery** (`mods/examples/` in the gen1recomp repo) | CONTRIBUTING-mods.md Lane A: PR your mod into the gallery/showcase. High bar: green `modkit validate --base imported`, tests asserting the stated effect, polish checklist. Ships disabled with the engine. | Optional, later. |
| **Reddit r/PokemonROMhacks** | Broad ROM-hack audience; mod showcases are core content. | Optional. |

**Non-negotiable rules** (wiki Guide-Publishing + CONTRIBUTING-mods.md):

- **No ROM-derived bytes in the distributed zip** (`modkit lint`, MK301–304).
  Will's Mod passes: everything derives at runtime from the player's cache.
- README + CHANGELOG (keep-a-changelog, heading per version) + `mod.card`
  with the tri-ledger (`changed`/`added`/`known`). We have all three.
- Semver; `modApi` stays 2; `game_version` range declared.
- **Screenshots**: fine on GitHub/GameBanana (of the player's own build),
  but keep them OUT of the release zip — put them in `.github/resources/`,
  which the official release workflow excludes from the archive.

## 2. Blockers before publishing

1. **Your in-game test** of `dist/wills_mod-1.0.0.zip` — both features,
   both layouts (classic + wide battle), HUD modes/sizes, `H` key.
2. **Repo shape decision** (below) — affects where files land.

## 3. Repo shape decision

The official release workflow (`tools/mod_release_workflow.yml`) runs
`git archive HEAD` from the **repo root**, so the mod is expected to BE the
repo (manifest at root — exactly the shape of your encounter-guide repo).

- **Recommended: flatten** `wills-mod` to repo-root mod (`git mv
  mods/wills_mod/* .`, drop the `mods/` layer, fold in the battle-hud
  history). One repo = one mod = one release channel. Matches official
  tooling and the in-game Update/Versions expectation.
- Alternative: keep `mods/wills_mod/` and add a `cd mods/wills_mod` to the
  workflow (and to GameBanana zip prep). More moving parts, no benefit now
  that it's one mod.

## 4. Execution phases

### Phase 0 — You test (blocking)

```sh
# from the game: F10 → MODS → Import mod .zip →
#   wills-mod/mods/wills_mod/dist/wills_mod-1.0.0.zip
```

Verify: START → PKMN MAP opens the Kanto map; walking HUD appears on grass
(AUTO) and toggles with H; a battle shows owned-ball markers under names in
both classic and wide layouts; Options shows ENC. GUIDE HUD / ENC. GUIDE
SIZE rows. Report anything off.

### Phase 1 — Repo shape + presentation

1. Flatten to repo-root mod (or keep subdir — see §3).
2. Add screenshots: use the existing shots from `~/Documents/encounters-guide1.png` (PKMN MAP), `encounters-guide2.png` (walking HUD), `encounters-guide3.png` (encounter list), plus `~/Downloads/Screenshot_20260812_211133.jpg` (battle HUD). They are copied under `mods/wills_mod/.github/resources/` as `screenshot-map.png`, `screenshot-walking-hud.png`, `screenshot-encounter-list.png`, and `screenshot-battle-hud.jpg`. Keep screenshots OUT of the release zip — the official release workflow excludes `.github/`.
3. Root README: the mod README (already written at
   `mods/wills_mod/README.md`; it becomes the repo README after flatten).
4. Commit locally (no push).

### Phase 2 — GitHub repo + first release

```sh
# from the repo root (after flatten)
git add -A && git commit -m "feat: Will's Mod v1.0.0 — encounter guide + battle HUD in one mod"
gh repo create illanrego/wills-mod --public --source . --push
# first release: tag + release with the packed zip (files at root)
gh release create v1.0.0 dist/wills_mod-1.0.0.zip \
  --title "1.0.0" \
  --notes "Download the .zip and install it from the game: MODS > Import mod .zip."
```

Then add the official auto-release workflow (§5) so every future version
bump publishes itself. Verify in-game: MODS → Will's Mod → **Update /
Versions** lists v1.0.0.

### Phase 3 — Archive the Encounter Guide repo

`illanrego/gen1recomp-encounter-guide` stays public as an archive: push its
5 pending commits (v0.3.0→v0.6.0 history), add a README banner "superseded —
now part of Will's Mod (github.com/illanrego/wills-mod)", stop cutting
releases there. (Optional: leave as-is; it still works standalone.)

### Phase 4 — GameBanana

1. Account (or reuse) → submit a mod to
   `gamebanana.com/mods/games/25428`, subcategory **Quality of Life**.
2. Upload `wills_mod-1.0.0.zip` (the packed zip, files at root), the three
   screenshots, and the description draft (§7).
3. GameBanana screenshots may be moderated; link the GitHub repo in the
   description so Update/Versions is discoverable.

### Phase 5 — Discord showcase (bois.icu)

Join via `https://bois.icu`, post in the mods/showcase channel using the
draft in §8. Keep it short, link the repo, mention it's open-source.

### Phase 6 — Optional: official gallery PR

CONTRIBUTING-mods.md Lane A checklist before opening the PR:

- [ ] `modkit validate --base imported --strict` green (needs the real
      imported dataset; CI also runs it)
- [ ] `modkit lint` green (already verified)
- [ ] tests/ with at least one suite asserting the stated effect (we have
      11 files)
- [ ] README opens with one sentence + persona + the three try-it commands
- [ ] `mod.card` complete (author, tri-ledger, credits)
- [ ] CHANGELOG heading matches manifest version
- [ ] Disabled by default (gallery entries sit in `mods/examples/`)

## 5. Auto-release workflow (installed custom workflow)

A custom workflow is installed at `.github/workflows/release.yml`. I did **not**
keep the generic `modkit add-release-workflow` output because it archives the
repo root directly and would include source/test/support files for this repo
shape. The custom workflow:

- triggers manually, or on pushes that change manifest/main/lib/docs shipped
  in the mod;
- runs `python3 tools/bundle.py`;
- stages only the importable files: `CHANGELOG.md`, `LICENSE`, `README.md`,
  `main.lua`, `manifest.json`, `mod.card`;
- writes the selected version into the staged manifest;
- publishes `wills_mod-X.Y.Z.zip` and `sha256sums.txt`;
- keeps `.github/resources/` screenshots, tests, tools, and publishing docs
  out of the release zip.

For v1.0.0 I created the release manually from the already verified
`dist/wills_mod-1.0.0.zip`; the workflow is for future releases.

## 6. Version bump protocol (after this ships)

1. Bump `manifest.json` `version` + add CHANGELOG heading (same version).
2. Commit + push to `main` (no tag needed).
3. Workflow cuts the release from the manifest version; in-game Update picks
   it up.

## 7. GameBanana listing draft

- **Game:** Gen1Recomp (Pokémon Red, Blue, Yellow) — gamebanana.com/mods/games/25428
- **Category:** Quality of Life
- **Title:** Will's Mod — Encounter Guide + Owned-Ball Battle HUD
- **Description:**

> Will's Mod is a catch-'em-all toolkit for Gen1Recomp, combining two
> read-only tools:
>
> 🗺️ **Encounter Guide** — START → PKMN MAP opens the real Kanto Town Map
> from your imported ROM. Hop between encounter-bearing locations and drill
> into exact routes, floors, and buildings, with honest LAND/WATER
> separation, compact level ranges, and exact per-step odds. A blinking
> marker shows your current location, and a walking HUD lists the area's
> species while you explore (modes AUTO/ALWAYS/OFF, sizes SMALL/MEDIUM/LARGE).
>
> ⚪ **Battle HUD** — a Pokédex ball marker appears beside a battler's name
> when you've already caught that species, in both classic and wide layouts.
>
> Pure ROM-derived data — works with Red, Blue, or Yellow. No copyrighted
> content shipped, no save/mechanics touched.
>
> Install: MODS (F10) → Import mod .zip → enable Will's Mod. Updates:
> the mod is on GitHub — in-game Update/Versions pulls new releases
> automatically (github.com/illanrego/wills-mod).
>
> Made by Illan · MIT · open source

## 8. Discord showcase post draft (bois.icu)

> **Will's Mod** — a small catch-'em-all toolkit I've been running for a
> while, now as one mod: a map-first Encounter Guide (START → PKMN MAP,
> exact routes/floors/odds from your own ROM) + a battle HUD that marks
> Pokémon you already caught with a Pokédex ball next to their name.
> Read-only, no ROM content shipped, works on Red/Blue/Yellow, desktop +
> Android. Install via MODS → Import mod .zip; updates come through the
> in-game updater from GitHub: github.com/illanrego/wills-mod
> (screenshots in the repo).

## 9. Verified build state (this doc's baseline)

- `mods/wills_mod/` merged: guide lib (names/model/screens/map_screen/hud)
  + battle_hud lib + unified entry (6 screen registrations, start-menu row,
  render.hud wrap, battle.overlay wrap, 2 options rows).
- Tests: **11/11 green** (model, names, hud, map_screen, screens, main,
  package_factory, blue_cache [live], battle_hud, entry, package).
- `modkit validate --base fixture --strict`: **ok** · `modkit lint`: **ok**
  (no ROM-derived content).
- Packed: `dist/wills_mod-1.0.0.zip` — reproducible, files at archive root
  (main.lua, manifest.json, README.md, CHANGELOG.md, mod.card, LICENSE,
  .modkit/pack.json).
- Manifest: `id wills_mod`, api 2, category TOOL, profile content,
  `"github": "illanrego/wills-mod"`.
