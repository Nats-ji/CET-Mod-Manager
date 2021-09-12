local CETMM = require ("scripts/CETMM")
local i18n = require ("scripts/i18n")

---@class locale
local locale = {}

function locale.Initialize()
  i18n.loadFile("lang/en_us.lua")
  locale.SetLocale()
end

function locale.SetLocale()
  i18n.loadFile(string.format("lang/%s.lua", CETMM.GetOptions().m_lang))
  i18n.setLocale(CETMM.GetOptions().m_lang)
end

return locale