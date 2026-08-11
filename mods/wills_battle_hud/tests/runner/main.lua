local root = assert(os.getenv("WILLS_MOD_ROOT"), "WILLS_MOD_ROOT is required")
package.path = root .. "/?.lua;" .. root .. "/?/init.lua;" .. package.path

local tests = { "battle_hud_test.lua", "entry_test.lua", "package_test.lua" }
for _, file in ipairs(tests) do
  local ok, err = pcall(function() dofile(root .. "/tests/" .. file) end)
  if not ok then
    print("FAIL " .. file .. "\n" .. tostring(err))
    love.event.quit(1)
    return
  end
  print("PASS " .. file)
end
love.event.quit(0)
