local path = require("cet_mod_manager/class/path")

---@class paths
---@field gameRoot path
---@field archive path
---@field plugins path
---@field cetmods path
---@field cetscripts path
---@field cetmmRoot path
---@field cetmmAsiRoot path
---@field red4ext path
---@field redscript path
local paths = {}

-- private functions

local function load_path()
  local file = io.open("cet_mod_manager/paths.json", "r")
  if file then
    local paths_tb = json.decode(file:read("*a"))
    for k, v in pairs(paths_tb) do
      paths[k] = path(v)
    end
    file:close()
  else
    print("paths.json doesn't exit.")
  end
end

load_path()

return paths