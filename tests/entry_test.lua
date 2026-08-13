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
    insertBefore = function(items, anchorLabel, row)
      local out, inserted = {}, false
      for _, item in ipairs(items) do
        if not inserted and item.label == anchorLabel then
          out[#out + 1] = row
          inserted = true
        end
        out[#out + 1] = item
      end
      if not inserted then out[#out + 1] = row end
      return out
    end,
  },
}

entry()(mod)
assert(wrappedHooks["ui.start_menu.items"],
  "main must wrap ui.start_menu.items for the PKMN MAP row")
assert(wrappedHooks["render.hud"],
  "main must wrap render.hud for the walking encounter HUD")
assert(wrappedHooks["ui.options.rows"],
  "main must wrap ui.options.rows for the ENC. GUIDE options")

-- the start-menu wrap decorates rather than replaces
local vanilla = { { label = "POKéDEX" }, { label = "SAVE" }, { label = "QUIT" } }
local nextCalled = false
local items = wrappedHooks["ui.start_menu.items"](function()
  nextCalled = true
  return vanilla
end, { save = {} }, vanilla)
assert(nextCalled, "the start-menu wrap must preserve the hook chain")
assert(type(items) == "table" and #items == 4, "the start-menu wrap adds one row")
assert(items[2].label == "PKMN MAP", "the PKMN MAP row anchors before SAVE")
assert(items[3].label == "SAVE", "the vanilla rows stay in order")
