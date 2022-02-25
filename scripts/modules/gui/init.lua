---@class gui
local gui = {}
local m_dpi = require ("modules/gui/dpi")
local m_style = require ("modules/gui/style")
local m_widgets = require ("modules/gui/widgets")
local m_window = require ("modules/gui/window")

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
  m_dpi.Initialize()
  m_window.Initialize()
end

function gui.Render()
  m_window.Render()
end

return gui