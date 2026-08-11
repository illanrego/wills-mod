local entry = assert(loadfile(os.getenv("WILLS_MOD_ROOT") .. "/main.lua"))

local wrappedHooks = {}
local mod = {
  content = { screens = { register = function() end } },
  hooks = { wrap = function(_, hook, callback)
    wrappedHooks[hook] = callback
  end },
  ui = {
    Font = {
      split = function(text)
        local out = {}
        for _ in text:gmatch(".") do out[#out + 1] = true end
        return out
      end,
      width = function(text) return #text * 8 end,
    },
  },
}

entry()(mod)
assert(wrappedHooks["battle.overlay"], "main must wrap the battle.overlay hook for the owned-ball markers")

local nextCalled = false
local battle = {
  game = { save = { pokedex = { owned = {} } } },
}
local result = wrappedHooks["battle.overlay"](function() nextCalled = true end, battle)
assert(nextCalled, "the battle.overlay wrap must preserve the hook chain")
assert(result == nil, "the battle.overlay wrap must not replace the hook result")
assert(battle.game.save.pokedex.owned ~= nil, "the battle.overlay wrap must not mutate the save")
