local options = {
  m_lang = "en_us",
  m_autoscan = false,
  m_autoappear = true,
}

-- private functions

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
  local config = json.decode(file:read("*a"))
  file:close()

  options.m_lang = setOption(config.lang, options.m_lang)
  options.m_autoscan = setOption(config.autoscan, options.m_autoscan)
  options.m_autoappear = setOption(config.autoappear, options.m_autoappear)

  options.Save()
end

function options.Save()
  local config = {}

  config["lang"] = options.m_lang
  config["autoscan"] = options.m_autoscan
  config["autoappear"] = options.m_autoappear

  local file = io.open("config.json", "w")
  file:write(json.encode(config))
  file:close()
end

return options