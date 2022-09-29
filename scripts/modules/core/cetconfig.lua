local paths = require("cet_mod_manager/paths")

---@class cetconfig
local cetconfig = {
  path = paths.plugins / "cyber_engine_tweaks" / "config.json",
  config = {}
}

---@return table
local function load_cetconfig()
  local file = io.open(cetconfig.path:ToString(), "r")
  local cet_config
  if file then
    cet_config = json.decode(file:read("*a"))
    file:close()
  end
  return cet_config
end

local function save_cetconfig(aConfig)
  local file = io.open(cetconfig.path:ToString(), "w")
  file:write(json.encode(aConfig))
  file:close()
end

---@param aConfig table
function cetconfig.Set(aConfig)
  local cet_config = load_cetconfig()
  for key, value in pairs(aConfig) do
    if cet_config[key] ~= nil then
      cet_config[key] = value
    end
  end
  save_cetconfig(cet_config)
end

function cetconfig.Load()
  cetconfig.config = load_cetconfig()
end

return cetconfig

