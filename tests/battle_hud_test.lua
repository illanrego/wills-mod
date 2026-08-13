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

-- ball placement: immediately right of the name end, vertically centered on
-- the name row. X follows Font.width(name): short names put the ball right
-- after a short name, long names right after a long name.
local bx, by = BattleHud.ballGeometry("classic", "enemy", 6, 48)
eq(bx, 8 + 48 + 3, "classic enemy ball sits right of the enemy name end")
eq(by, 4, "classic enemy ball is centered on the enemy name row")
local px, py = BattleHud.ballGeometry("classic", "player", 7, 56)
eq(px, 80 + 56 + 3, "classic player ball sits right of the player name end")
eq(py, 60, "classic player ball is centered on the player name row")
local wx, wy = BattleHud.ballGeometry("wide", "player", 7, 56)
eq(wx, 192 + 56 + 3, "wide player ball sits right of the wide-layout name end")
eq(wy, 68, "wide player ball is centered on the wide name row")
eq(BattleHud.ballGeometry("bogus", "enemy", 6, 48), nil, "ballGeometry returns nil for unknown layouts")
eq(BattleHud.ballGeometry("wide", "trainer", 6, 48), nil, "ballGeometry returns nil for unknown sides")
local shortX = BattleHud.ballGeometry("classic", "enemy", 2, 16)
eq(shortX, 24 + 16 + 3, "short names put the ball right after the short name")
local longX = BattleHud.ballGeometry("classic", "enemy", 8, 64)
eq(longX, 8 + 64 + 3, "long names put the ball right after the long name")
eq(longX - shortX, (8 + 64) - (24 + 16),
  "the ball moves right by exactly the name-width delta")
-- a 10-glyph player name would overflow the 160px classic canvas: clamp
local clampX = BattleHud.ballGeometry("classic", "player", 10, 80)
eq(clampX, 160 - 3.5 - 1, "overflowing names clamp the ball on-canvas")
eq(clampX + 3.5, 160 - 1, "the clamped ball still fits inside the canvas")

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
eq(circles[1][2], 8 + 48 + 3, "the enemy ball sits right of the enemy name end")
eq(circles[1][3], 4, "the enemy ball is centered on the enemy name row")
eq(circles[1][4], 3.5, "the enemy ball matches the ListMenu owned-ball size")
eq(rectangles[1][2], (8 + 48 + 3) - 3.5, "the ball's white band spans the enemy circle horizontally")
eq(rectangles[1][3], 4 - 0.5, "the ball's white band crosses the circle vertically")

-- both owned: two balls, each at its side's name row
local bothOwned = makeBattle({
  owned = { PIDGEY = true, PIKACHU = true },
  enemy = makeBattler("PIDGEY", "PIDGEY"),
  player = makeBattler("PIKACHU", "PIKACHU"),
})
local ballCount = #circles
eq(BattleHud.drawOverlay(graphics, font, bothOwned, { PIDGEY = true, PIKACHU = true }), 2,
  "both owned battlers get a ball")
eq(circles[#circles][2], 80 + 56 + 3, "the classic player ball sits right of the player name end")
eq(circles[#circles][3], 60, "the player ball is centered on the player name row")

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
eq(circles[wideBase + 1][2], 8 + 48 + 3, "the wide enemy ball sits right of the enemy name end")
eq(circles[wideBase + 1][3], 12, "the wide enemy ball is centered on the wide name row")
eq(circles[#circles][2], 192 + 56 + 3, "the wide player ball sits right of the player name end")
eq(circles[#circles][3], 68, "the wide player ball is centered on the wide player name row")

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
