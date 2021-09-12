---@class gui
local gui = {}
local m_dpi = require ("scripts/gui/dpi")
local m_style = require ("scripts/gui/style")
local m_widgets = require ("scripts/gui/widgets")
local m_window = require ("scripts/gui/window")

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