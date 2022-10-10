---@class CETMM
local CETMM = {}

-- local m_api
local m_gui
local m_event
local m_hotkeys
local m_options
-- local m_font
local m_locale
local m_dofiles
local m_version
local m_backend

-- function CETMM.GetModList()
--   return m_core.mods
-- end

-- function CETMM.GetEnums()
--   return m_core.enums
-- end

-- function CETMM.GetHelper()
--   return m_core.helper
-- end

-- function CETMM.GetScanSystem()
--   return m_core.scan
-- end

-- function CETMM.GetModOpEx()
--   return m_core.modopex
-- end

-- function CETMM.GetPaths()
--   return m_core.paths
-- end

-- function CETMM.GetCETConfig()
--   return m_core.cetconfig
-- end

function CETMM.GetUISystem()
  return m_gui
end

function CETMM.GetOptions()
  return m_options
end

-- function CETMM.GetFont()
--   return m_font
-- end

-- function CETMM.GetAPI()
--   return m_api
-- end

function CETMM.GetLocale()
  return m_locale
end

function CETMM.GetDofiles()
  return m_dofiles
end

function CETMM.GetVersion()
  return m_version
end

function CETMM.GetBackEnd()
  return m_backend
end

function CETMM.Initialize()
  -- m_api = require ("modules/api")
  m_options = require ("modules/options")
  -- m_font = require("modules/font")
  m_locale = require ("modules/locale")
  m_dofiles = require ("modules/dofiles")
  m_event = require ("modules/event")
  m_hotkeys = require("modules/hotkeys")
  m_version = require ("modules/version")

  -- Load config
  m_options.Load()
  m_locale.Initialize()

  -- m_font.Initialize()

  registerForEvent("onInit", function()
  -- init
  m_backend = require ("modules/backend")
  m_backend.GetMods().Scan()
  m_dofiles.Scan()
  m_gui = require ("modules/gui")
  m_gui.Initialize()
  end)
end

function CETMM.Update()
  registerForEvent("onUpdate", function()

  end)
end

function CETMM.Event() -- Hotkey, Console event..
  m_event.Register()
  m_hotkeys.Register()
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

return CETMM