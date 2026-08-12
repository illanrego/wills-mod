local BattleHud = require("lib.battle_hud")

local function eq(actual, expected, message)
  assert(actual == expected,
    (message or "values differ") .. ": expected " .. tostring(expected) .. ", got " .. tostring(actual))
end

-- pure geometry: the engine's CenterMonName offset (nameX)
eq(BattleHud.nameX(1, 2), 24, "1-2 glyph names print two tiles right")
eq(BattleHud.nameX(1, 3), 16, "3-4 glyph names print one tile right")
eq(BattleHud.nameX(1, 5), 8, "5+ glyph names print at the box edge")
eq(BattleHud.nameX(10, 2), 96, "the player box anchor is respected")

-- ball placement: absolute HUD slots, independent of the Pokémon name.
-- Live feedback showed the real bug: different name lengths move the marker.
-- The marker must be anchored to the battle HUD panel/side, not to text width.
local bx, by = BattleHud.ballGeometry("classic", "enemy", 6, 48)
eq(bx, 64, "classic enemy ball uses a fixed left-side HUD slot")
eq(by, 3, "classic enemy ball aligns with the name row")
local px, py = BattleHud.ballGeometry("classic", "player", 7, 56)
eq(px, 152, "classic player ball uses a fixed right-side HUD slot")
eq(py, 59, "classic player ball aligns with the player name row")
local wx, wy = BattleHud.ballGeometry("wide", "player", 7, 56)
eq(wx, 272, "wide player ball uses a fixed right-side HUD slot")
eq(wy, 67, "wide player ball aligns with the wide name row")
eq(BattleHud.ballGeometry("bogus", "enemy", 6, 48), nil, "ballGeometry returns nil for unknown layouts")
eq(BattleHud.ballGeometry("wide", "trainer", 6, 48), nil, "ballGeometry returns nil for unknown sides")
local zubatX = BattleHud.ballGeometry("wide", "enemy", 5, 40)
eq(zubatX, 64, "shorter enemy names do not move the enemy marker")
local magikarpX = BattleHud.ballGeometry("wide", "enemy", 8, 64)
eq(magikarpX, 64, "longer enemy names do not move the enemy marker")

-- drawing: owned species get the ListMenu ball after the name
local circles, rectangles, colors = {}, {}, {}
local graphics = {
  setColor = function(r, g, b, a) colors[#colors + 1] = { r, g, b, a } end,
  circle = function(mode, x, y, radius) circles[#circles + 1] = { mode, x, y, radius } end,
  rectangle = function(mode, x, y, w, h) rectangles[#rectangles + 1] = { mode, x, y, w, h } end,
}
local function splitGlyphs(text)
  local out = {}
  for _ in text:gmatch(".") do out[#out + 1] = true end
  return out
end
local font = {
  split = splitGlyphs,
  width = function(text) return #text * 8 end,
}

local function makeBattler(species, name)
  return { name = name, mon = { species = species, level = 5 } }
end
local function makeBattle(opts)
  opts = opts or {}
  local battle = {
    game = { save = { pokedex = { owned = opts.owned or {} } } },
    player = opts.player,
    enemy = opts.enemy,
    enemySendingOut = opts.enemySendingOut,
    introBalls = opts.introBalls,
    safari = opts.safari,
    demo = opts.demo,
    showPlayerBack = opts.showPlayerBack,
  }
  if opts.wide then
    battle.isWideBattleLayout = true
    battle.isWideBattleLayout = function() return true end
  end
  return battle
end

-- enemy owned, player unowned: exactly one ball at the enemy name row
local ownedEnemy = makeBattle({
  owned = { PIDGEY = true },
  enemy = makeBattler("PIDGEY", "PIDGEY"),
  player = makeBattler("PIKACHU", "PIKACHU"),
})
eq(BattleHud.drawOverlay(graphics, font, ownedEnemy, { PIDGEY = true }), 1,
  "one ball is drawn for the owned enemy")
eq(circles[1][1], "fill", "the owned ball is a filled circle")
eq(circles[1][2], 64, "the enemy ball uses the fixed enemy HUD slot")
eq(circles[1][3], 3, "the enemy ball aligns with the enemy name row")
eq(circles[1][4], 3.5, "the enemy ball matches the ListMenu owned-ball size")
eq(rectangles[1][2], 64 - 3.5, "the ball's white band spans the enemy circle horizontally")
eq(rectangles[1][3], 3 - 0.5, "the ball's white band crosses the circle vertically")

-- both owned: two balls, each at its side's name row
local bothOwned = makeBattle({
  owned = { PIDGEY = true, PIKACHU = true },
  enemy = makeBattler("PIDGEY", "PIDGEY"),
  player = makeBattler("PIKACHU", "PIKACHU"),
})
local ballCount = #circles
eq(BattleHud.drawOverlay(graphics, font, bothOwned, { PIDGEY = true, PIKACHU = true }), 2,
  "both owned battlers get a ball")
eq(circles[#circles][2], 152, "the classic player ball uses the fixed right-side HUD slot")
eq(circles[#circles][3], 59, "the player ball aligns with the player name row")

-- unowned species: no ball
local noneOwned = makeBattle({
  owned = {},
  enemy = makeBattler("PIDGEY", "PIDGEY"),
  player = makeBattler("PIKACHU", "PIKACHU"),
})
eq(BattleHud.drawOverlay(graphics, font, noneOwned, {}), 0, "unowned battlers get no ball")

-- wide layout uses the wide HUD geometry
local wideBattle = makeBattle({
  wide = true,
  owned = { PIDGEY = true, PIKACHU = true },
  enemy = makeBattler("PIDGEY", "PIDGEY"),
  player = makeBattler("PIKACHU", "PIKACHU"),
})
local wideBase = #circles
eq(BattleHud.drawOverlay(graphics, font, wideBattle, { PIDGEY = true, PIKACHU = true }), 2, "wide battles still mark owned battlers")
eq(circles[wideBase + 1][2], 64, "the wide enemy ball uses the fixed enemy HUD slot")
eq(circles[wideBase + 1][3], 11, "the wide enemy ball aligns with the wide name row")
eq(circles[#circles][2], 272, "the wide player ball uses the fixed right-side HUD slot")
eq(circles[#circles][3], 67, "the wide player ball aligns with the wide player name row")

-- HUD visibility guards: no ball while the enemy is being sent out
local sendingOut = makeBattle({
  owned = { PIDGEY = true },
  enemy = makeBattler("PIDGEY", "PIDGEY"),
  player = makeBattler("PIKACHU", "PIKACHU"),
  enemySendingOut = true,
})
eq(BattleHud.drawOverlay(graphics, font, sendingOut, { PIDGEY = true }), 0,
  "no ball while the enemy is being sent out")
-- no player ball in a safari battle
local safari = makeBattle({
  owned = { PIKACHU = true },
  enemy = makeBattler("PIDGEY", "PIDGEY"),
  player = makeBattler("PIKACHU", "PIKACHU"),
  safari = true,
})
eq(BattleHud.drawOverlay(graphics, font, safari, { PIKACHU = true }), 0,
  "no player ball in safari battles")
-- no enemy ball once it fainted
local fainted = makeBattle({
  owned = { PIDGEY = true },
  enemy = makeBattler("PIDGEY", "PIDGEY"),
  player = makeBattler("PIKACHU", "PIKACHU"),
})
fainted.enemy.fainted = true
eq(BattleHud.drawOverlay(graphics, font, fainted, { PIDGEY = true }), 0,
  "no enemy ball after it faints")

-- defensiveness: no battle, no battlers, no graphics -> zero, never crash
eq(BattleHud.drawOverlay(nil, nil, nil, {}), 0, "a nil battle draws nothing")
eq(BattleHud.drawOverlay(graphics, font, makeBattle({}), {}), 0, "a battle without battlers draws nothing")
