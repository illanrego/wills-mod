-- Generated self-contained release entry: installed mods do not extend Lua package.path.

local BattleHud = {}
BattleHud.__index = BattleHud

local BELOW_NAME_SLOTS = {
  -- Fixed below-left markers: anchored to the name field's left edge and one
  -- row below the printed name, never to the name's width.
  classic = {
    enemy = { x = 8, y = 11 },
    player = { x = 80, y = 67 },
  },
  wide = {
    enemy = { x = 8, y = 19 },
    player = { x = 192, y = 75 },
  },
}

-- Engine HUD anchors, verified against BattleState.drawHUDs (v0.1.75):
-- classic enemy name row 0 (nameX anchor tile 1), player row 56 (tile 10);
-- wide panels draw names at panel origin + 8/+8, panels at (0,0)/(184,56).
local LAYOUTS = {
  classic = {
    enemy = { tx = 1, y = 0 },
    player = { tx = 10, y = 56 },
  },
  wide = {
    enemy = { x = 8, y = 8 },
    player = { x = 192, y = 64 },
  },
}

-- CenterMonName offset (BattleState.nameX): 1-2 glyph names print two tiles
-- right, 3-4 one tile, 5+ at the box edge. Counted in glyphs, not bytes.
function BattleHud.nameX(tx, glyphs)
  return tx * 8 + (glyphs <= 2 and 16 or glyphs <= 4 and 8 or 0)
end

-- The owned-ball position for a battler name, or nil for unknown layout/side.
function BattleHud.ballGeometry(layout, side, glyphs, nameWidth)
  local spec = LAYOUTS[layout] and LAYOUTS[layout][side]
  if not spec then return nil end
  local slot = ((BELOW_NAME_SLOTS[layout] or {})[side])
  if not slot then return nil end
  return slot.x, slot.y
end

-- The same owned-ball marker the engine's ListMenu draws.
function BattleHud.drawBall(graphics, bx, by)
  graphics.setColor(0, 0, 0, 1)
  graphics.circle("fill", bx, by, 3.5)
  graphics.setColor(1, 1, 1, 1)
  graphics.rectangle("fill", bx - 3.5, by - 0.5, 7, 1)
  graphics.circle("fill", bx, by, 1.2)
  graphics.setColor(0, 0, 0, 1)
end

local function enemyVisible(battle, battler)
  return not battle.enemySendingOut and not battle.introBalls
    and not (battler.fainted)
end

local function playerVisible(battle)
  return not battle.safari and not battle.demo and not battle.showPlayerBack
end

function BattleHud.drawNameBall(graphics, font, layout, side, battler)
  local name = battler.name or (battler.mon and battler.mon.species) or ""
  local glyphs = #font.split(name)
  local width = font.width(name)
  local bx, by = BattleHud.ballGeometry(layout, side, glyphs, width)
  if not bx then return 0 end
  BattleHud.drawBall(graphics, bx, by)
  return 1
end

-- Draws one owned ball per battler whose species is in the caught dex.
-- Returns how many balls were drawn. Draws in the battle's own canvas space
-- (battle.overlay fires inside BattleState:draw), so positions are raw
-- 160x144 (classic) or wide-canvas coordinates.
function BattleHud.drawOverlay(graphics, font, battle, owned)
  if not (battle and graphics and font) then return 0 end
  local wide = battle.isWideBattleLayout and battle:isWideBattleLayout()
  local layout = wide and "wide" or "classic"
  local count = 0
  local enemy = battle.enemy
  if enemy and enemy.mon and owned[enemy.mon.species] and enemyVisible(battle, enemy) then
    count = count + BattleHud.drawNameBall(graphics, font, layout, "enemy", enemy)
  end
  local player = battle.player
  if player and player.mon and owned[player.mon.species] and playerVisible(battle) then
    count = count + BattleHud.drawNameBall(graphics, font, layout, "player", player)
  end
  return count
end

return function(mod)
  mod.hooks:wrap("battle.overlay", function(next, battle)
    if next then next(battle) end
    local game = battle and battle.game
    local owned = ((game and game.save and game.save.pokedex) or {}).owned or {}
    BattleHud.drawOverlay(love.graphics, mod.ui.Font, battle, owned)
  end)
end
