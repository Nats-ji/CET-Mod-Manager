local CETMM = {}

local m_api
local m_core
local m_auth = require ("scripts/auth")
local m_gui = require ("scripts/gui")
local m_options = require ("scripts/options")
local m_locale

local i18n = require ("scripts/i18n")

function CETMM.GetModList()
  return m_core.mods
end

function CETMM.GetEnums()
  return m_core.enums
end

function CETMM.GetHelper()
  return m_core.helper
end

function CETMM.GetScanSystem()
  return m_core.scan
end

function CETMM.GetUISystem()
  return m_gui
end

function CETMM.GetOptions()
  return m_options
end

function CETMM.GetAPI()
  return m_api
end

function CETMM.GetLocale()
  return m_locale
end

function CETMM.Initialize()
  m_core = m_auth.GetCore()
  m_api = require ("scripts/api")
  m_locale = require ("scripts/locale")

  -- Load config
  m_options.Load()
  m_locale.Initialize()

  registerForEvent("onInit", function()
  -- init
  end)
end

function CETMM.Update()
  registerForEvent("onUpdate", function()

  end)
end

function CETMM.Event() -- Hotkey, Console event..

end

function CETMM.Render()
  registerForEvent("onDraw", function()
    if ImGui.Button(i18n("button_scan")) then
      CETMM.GetScanSystem().ScanALL()
    end
    if ImGui.Button("CN") then
      CETMM.GetOptions().m_lang = "zh_cn"
      CETMM.GetLocale().SetLocale()
    end
  end)
end

function CETMM.Shutdown()
  registerForEvent("onShutdown", function()
    m_options.Save()
  end)
end

print('loooooadeeeee')

return CETMM