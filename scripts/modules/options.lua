---@class options
---@field m_lang string
---@field m_autoscan boolean
---@field m_autoappear boolean
---@field m_theme string
local options = {
  m_lang = "en_us",
  m_autoscan = false,
  m_autoappear = true,
  m_theme = "default"
}

-- private functions

-- set the option to default value if it doesn't exist in the config file
local function setOption(val, def)
  if val == nil then
    return def
  else
    return val
  end
end

-- public methods

function options.Load()
  local file = io.open("config.json", "r")

  if file then
    local config = json.decode(file:read("*a"))
    file:close()

    options.m_lang = setOption(config.lang, options.m_lang)
    options.m_autoscan = setOption(config.autoscan, options.m_autoscan)
    options.m_autoappear = setOption(config.autoappear, options.m_autoappear)
    options.m_theme = setOption(config.theme, options.m_theme)
  end

  options.Save()
end

function options.Save()
  local config = {}

  config["lang"] = options.m_lang
  config["autoscan"] = options.m_autoscan
  config["autoappear"] = options.m_autoappear
  config["theme"] = options.m_theme

  local file = io.open("config.json", "w")
  file:write(json.encode(config))
  file:close()
end

return options