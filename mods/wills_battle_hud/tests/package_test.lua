local root = assert(os.getenv("WILLS_MOD_ROOT"))
local wrappedHooks = {}
local mod = {
  content = { screens = { register = function() end } },
  hooks = { wrap = function(_, hook, callback)
    wrappedHooks[hook] = callback
  end },
  ui = { Font = {} },
}

package.loaded["lib.battle_hud"] = nil
local originalPath = package.path
package.path = "/nonexistent/?.lua;/nonexistent/?/init.lua"
local ok, err = pcall(function()
  local entry = assert(loadfile(root .. "/main.lua"))
  entry()(mod)
end)
package.path = originalPath

assert(ok, "installed entry must be self-contained: " .. tostring(err))
assert(wrappedHooks["battle.overlay"], "installed entry must register the battle.overlay wrap")

local overlayOk, overlayErr = pcall(wrappedHooks["battle.overlay"], function() end, {
  game = { save = { pokedex = { owned = {} } } },
})
assert(overlayOk, "installed battle.overlay wrap must not depend on the project package.path: "
  .. tostring(overlayErr))
