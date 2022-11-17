local CETMM = require ("modules/CETMM")
---@class gui
local gui = {}
local m_dpi = require ("modules/gui/dpi")
local m_style = require ("modules/gui/style")
local m_widgets = require ("modules/gui/widgets")
local m_window = require ("modules/gui/window")
local m_windows = require ("modules/gui/windows")
local m_initialized = false
local m_showUninstall = false

function gui.GetDPI()
  return m_dpi
end

function gui.GetStyle()
  return m_style
end

function gui.GetWindow()
  return m_window
end

function gui.Initialize()
  if not m_initialized then
    m_showUninstall = CETMM.GetBackEnd().GetUninstall().IsAsiRemoved()
    m_dpi.Initialize()
    m_window.Initialize()
    m_initialized = true
  end
end

function gui.Render()
  if m_showUninstall then
    m_windows.uninstall.Render()
  else
    m_window.Render()
  end
end

return gui