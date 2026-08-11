return function(mod)
  mod.hooks:wrap("battle.overlay", function(next, battle)
    if next then next(battle) end
    local game = battle and battle.game
    local owned = ((game and game.save and game.save.pokedex) or {}).owned or {}
    BattleHud.drawOverlay(love.graphics, mod.ui.Font, battle, owned)
  end)
end
