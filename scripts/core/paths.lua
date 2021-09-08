local path = require("cet_mod_manager/class/path")

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