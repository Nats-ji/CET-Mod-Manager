---@class CETMM
local CETMM = {}

-- local m_api
local m_gui     ---@type gui
local m_event   ---@type event
local m_hotkeys ---@type hotkeys
local m_options ---@type options
-- local m_font
local m_locale  ---@type locale
local m_dofiles ---@type dofiles
local m_version ---@type string
local m_backend ---@type backend
local m_uninstalled = false

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

function CETMM.IsUninstalled()
  return m_uninstalled
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
  m_uninstalled = m_backend.GetUninstall().IsAsiRemoved()
  if not m_uninstalled then
    m_backend.GetMods().Scan()
    m_dofiles.Scan()
  end
  m_gui = require ("modules/gui")
  end)
end

function CETMM.Update()
  registerForEvent("onUpdate", function()

  end)
end

function CETMM.Event() -- Hotkey, Console event..
  if not m_uninstalled then
    m_event.Register()
    m_hotkeys.Register()
  end
end

function CETMM.Render()
  registerForEvent("onDraw", function()
    m_gui.Initialize()
    m_gui.Render()
  end)
end

function CETMM.Shutdown()
  registerForEvent("onShutdown", function()
    m_options.Save()
  end)
end

return CETMM