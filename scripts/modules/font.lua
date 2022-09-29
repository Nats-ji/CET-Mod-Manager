local CETMM = require("modules/CETMM")
local cetconfig = CETMM.GetCETConfig()

---@class font
local font = {
  list = {},
  fontfamilies = {},
  config = {},
  current_settings = {}
}

local function load_list()
  local file = io.open("fonts.json", "r")
  if file then
    font.list = json.decode(file:read("*a"))
    file:close()
  end
end

local function sort_fontfamilies()
  for fontfamily, _ in pairs(font.list) do
    table.insert(font.fontfamilies, fontfamily)
  end
  table.sort(font.fontfamilies)
end

local function save_font(aConfig)
  -- need core function
end

local function get_settings_from_config()
  if font.config["font_path"] == "" then
    font.current_settings = { fontfamily = "Default", style = "Regular" }
    return
  end

  local font_path = font.config["font_path"]:gsub("/", "\\"):upper() -- sanitize path
  for font_family, styles in pairs(font.list) do
    for style, path in pairs(styles) do
      if path:upper() == font_path then
        font.current_settings = { fontfamily = font_family, style = style }
        return
      end
    end
  end
end

function font.Initialize()
  load_list()
  sort_fontfamilies()
  font.GetConfig()
  get_settings_from_config()
end

function font.GetConfig()
  cetconfig.Load()
  font.config["font_path"] = cetconfig.config["font_path"]
  font.config["font_size"] = cetconfig.config["font_size"]
  font.config["font_glyph_ranges"] = cetconfig.config["font_glyph_ranges"]
end

return font