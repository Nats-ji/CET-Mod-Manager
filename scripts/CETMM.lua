local CETMM = {}

local m_api
local m_core
local m_gui
local m_event
local m_auth
local m_options
local m_locale
local m_dofiles

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

function CETMM.GetModOpEx()
  return m_core.modopex
end

function CETMM.GetPaths()
  return m_core.paths
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

function CETMM.GetDofiles()
  return m_dofiles
end

function CETMM.Initialize()
  m_auth = require ("scripts/auth")
  m_core = m_auth.GetCore()
  m_api = require ("scripts/api")
  m_options = require ("scripts/options")
  m_locale = require ("scripts/locale")
  m_event = require ("scripts/event")
  m_dofiles = require ("scripts/dofiles")

  -- Load config
  m_options.Load()
  m_locale.Initialize()

  registerForEvent("onInit", function()
  -- init
  m_gui = require ("scripts/gui")
  m_dofiles.Scan()
  m_gui.Initialize()
  end)
end

function CETMM.Update()
  registerForEvent("onUpdate", function()

  end)
end

function CETMM.Event() -- Hotkey, Console event..
  m_event.Register()
end

function CETMM.Render()
  registerForEvent("onDraw", function()
    m_gui.GetStyle().PushTheme()
    m_gui.Render()
    m_gui.GetStyle().PopTheme()
  end)
end

function CETMM.Shutdown()
  registerForEvent("onShutdown", function()
    m_options.Save()
  end)
end

print('loooooadeeeee')

return CETMM