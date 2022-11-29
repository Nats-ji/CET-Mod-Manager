local CETMM = require ("modules/CETMM")
---@class gui
local gui = {}
local m_dpi = require ("modules/gui/dpi")
local m_themeSys = require ("modules/gui/themeSys")
local m_widgets = require ("modules/gui/widgets")
local m_window = require ("modules/gui/window")
local m_windows = require ("modules/gui/windows")
local m_initialized = false
local m_showUninstall = false

function gui.GetDPI()
  return m_dpi
end

function gui.GetThemeSys()
  return m_themeSys
end

function gui.GetWindow()
  return m_window
end

function gui.Initialize()
  if not m_initialized then
    m_showUninstall = CETMM.IsUninstalled()
    m_dpi.Initialize()
    if m_showUninstall then
      m_themeSys.Load("default", true)
    else
      m_themeSys.Initialize()
      m_window.Initialize()
    end
    m_initialized = true
  end
end

function gui.Render()
  m_themeSys.PushTheme()
  if m_showUninstall then
    m_windows.uninstall.Render()
  else
    m_window.Render()
  end
  m_themeSys.PopTheme()
end

return gui