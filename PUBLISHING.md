# Will's Mod — Publishing Plan

Status: **awaiting your in-game test of `dist/wills_mod-1.0.0.zip`** (v1.0.0).
Everything below is researched against the live gen1recomp repo/wiki (dev
branch, Aug 2026) and GameBanana. No publication step runs until you've
tested the single mod and said go.

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

## 5. Auto-release workflow (official template, stamped)

`modkit.py add-release-workflow` (dev modkit) copies this into
`.github/workflows/release.yml` — pre-stamped with our mod id. Version
resolution: manual `version` input → `[release X.Y.Z]` in commit message →
manifest version ahead of all tags → patch bump on newest tag. Archive =
repo root (`git archive HEAD`) minus `.github`/`.gitignore`/`.gitattributes`,
so **keep screenshots under `.github/resources/`** and they never ship.

```yaml
name: Release

on:
  push:
    branches: [main]
    paths-ignore:
      - '.github/**'
      - '**.md'
  workflow_dispatch:
    inputs:
      version:
        description: "Exact version to release (e.g. 0.3.0). Leave blank to auto-resolve."
        required: false
        default: ""

permissions:
  contents: write

concurrency:
  group: release
  cancel-in-progress: false

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Determine version
        id: ver
        env:
          DISPATCH_VERSION: ${{ github.event.inputs.version }}
        run: |
          set -euo pipefail
          python3 - <<'PY' >> "$GITHUB_OUTPUT"
          import json, os, re, subprocess, sys
          SEMVER = re.compile(r"^(\d+)\.(\d+)\.(\d+)$")
          def sh(*args):
              return subprocess.run(args, capture_output=True, text=True).stdout.strip()
          def parse(text):
              m = SEMVER.match(text)
              return tuple(int(p) for p in m.groups()) if m else None
          def die(msg):
              print(f"::error::{msg}", file=sys.stderr)
              raise SystemExit(1)
          with open("manifest.json", encoding="utf-8") as fh:
              manifest_version = str(json.load(fh).get("version", ""))
          released = sorted(
              v for v in (parse(tag[1:]) for tag in sh("git", "tag", "-l", "v*").splitlines()) if v
          )
          latest = released[-1] if released else None
          override = os.environ.get("DISPATCH_VERSION", "").strip()
          if not override:
              found = re.search(r"\[release\s+(\d+\.\d+\.\d+)\]", sh("git", "log", "-1", "--pretty=%B"))
              override = found.group(1) if found else ""
          manifest_ver = parse(manifest_version)
          if override:
              version = parse(override) or die(f"invalid version override {override!r} (expected X.Y.Z)")
              source = "the override"
          elif manifest_ver and (latest is None or manifest_ver > latest):
              version = manifest_ver
              source = "manifest.json"
          elif latest:
              major, minor, patch = latest
              patch += 1
              if patch > 99:
                  minor, patch = minor + 1, 0
              version = (major, minor, patch)
              source = "a patch bump on v%d.%d.%d" % latest
          else:
              die(f"manifest.json version {manifest_version!r} is not X.Y.Z "
                  "and there is no vX.Y.Z tag to count from")
          text = "%d.%d.%d" % version
          print(f"Releasing {text}, from {source}.", file=sys.stderr)
          print(f"version={text}")
          print(f"tag=v{text}")
          PY

      - name: Refuse to clobber an existing release
        env:
          GH_TOKEN: ${{ github.token }}
          TAG: ${{ steps.ver.outputs.tag }}
        run: |
          set -euo pipefail
          if git rev-parse -q --verify "refs/tags/$TAG" >/dev/null; then
            echo "::error::Tag $TAG already exists. Pick a different version."
            exit 1
          fi
          if gh release view "$TAG" >/dev/null 2>&1; then
            echo "::error::Release $TAG already exists. Pick a different version."
            exit 1
          fi

      - name: Build the mod .zip
        env:
          VERSION: ${{ steps.ver.outputs.version }}
          MOD_ID: "wills_mod"
        run: |
          set -euo pipefail
          staging="$RUNNER_TEMP/pkg"
          out="$GITHUB_WORKSPACE/dist"
          rm -rf "$staging" "$out"
          mkdir -p "$staging" "$out"
          git archive HEAD | tar -x -C "$staging"
          rm -rf "$staging/.github" "$staging/.gitattributes" \
                 "$staging/.gitignore" "$staging/.luarc.json"
          python3 - "$staging/manifest.json" "$VERSION" <<'PY'
          import json, sys
          path, version = sys.argv[1], sys.argv[2]
          with open(path, encoding="utf-8") as fh:
              manifest = json.load(fh)
          manifest["version"] = version
          with open(path, "w", encoding="utf-8") as fh:
              json.dump(manifest, fh, indent=2, ensure_ascii=False)
              fh.write("\n")
          PY
          zip_path="$out/${MOD_ID}-${VERSION}.zip"
          (cd "$staging" && zip -qr "$zip_path" .)
          unzip -l "$zip_path"
          unzip -p "$zip_path" manifest.json > "$RUNNER_TEMP/packed-manifest.json"
          python3 - "$RUNNER_TEMP/packed-manifest.json" "$VERSION" <<'PY'
          import json, sys
          path, expected = sys.argv[1], sys.argv[2]
          with open(path, encoding="utf-8") as fh:
              version = json.load(fh)["version"]
          if version != expected:
              raise SystemExit(f"::error::packed manifest says {version}, expected {expected}")
          print(f"manifest.json is at the archive root and reports {version}")
          PY
          (cd "$out" && sha256sum "${MOD_ID}"-*.zip > sha256sums.txt)
          cat "$out/sha256sums.txt"

      - name: Publish GitHub Release
        env:
          GH_TOKEN: ${{ github.token }}
          VERSION: ${{ steps.ver.outputs.version }}
          TAG: ${{ steps.ver.outputs.tag }}
          MOD_ID: "wills_mod"
        run: |
          set -euo pipefail
          prev="$(git tag -l 'v*' --sort=-v:refname | grep -v "^${TAG}$" | head -1 || true)"
          range="${prev:+${prev}..}$GITHUB_SHA"
          changes="$(git log --no-merges --pretty='- %s' "$range" | head -50 || true)"
          notes=$'Download the .zip and install it from the game: MODS > Import mod .zip.'
          if [ -n "$changes" ]; then
            notes+=$'\n\n## Changes\n\n'"$changes"
          fi
          gh release create "$TAG" \
            --target "$GITHUB_SHA" \
            --title "$VERSION" \
            --notes "$notes" \
            "dist/${MOD_ID}-${VERSION}.zip" \
            "dist/sha256sums.txt"
          echo "Published release $TAG"
```

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
