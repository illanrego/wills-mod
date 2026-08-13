local root = assert(os.getenv("WILLS_MOD_ROOT"))
local wrappedHooks = {}
local mod = {
  content = { screens = { register = function() end } },
  hooks = { wrap = function(_, hook, callback)
    wrappedHooks[hook] = callback
  end },
  ui = { Font = {} },
}

local originalPath = package.path
package.path = "/nonexistent/?.lua;/nonexistent/?/init.lua"
local ok, err = pcall(function()
  local entry = assert(loadfile(root .. "/main.lua"))
  entry()(mod)
end)
package.path = originalPath

assert(ok, "installed entry must be self-contained: " .. tostring(err))
assert(wrappedHooks["ui.start_menu.items"],
  "installed entry must register the ui.start_menu.items wrap")
assert(wrappedHooks["render.hud"],
  "installed entry must register the render.hud wrap")
assert(wrappedHooks["ui.options.rows"],
  "installed entry must register the ui.options.rows wrap")

local hudOk, hudErr = pcall(wrappedHooks["render.hud"], function() end,
  { save = {} }, {})
assert(hudOk, "installed render.hud wrap must not depend on the project package.path: "
  .. tostring(hudErr))
