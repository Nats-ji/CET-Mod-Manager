---@class dpi
local dpi = {}
local m_fontscale
local m_displayRes = {}
local m_defaultVars = {}

local function get_vars()
  local style = ImGui.GetStyle()
  local vars = {
    WindowPadding = { x = style.WindowPadding.x, y = style.WindowPadding.y },
    WindowRounding = style.WindowRounding,
    ChildRounding = style.ChildRounding,
    PopupRounding = style.PopupRounding,
    FramePadding = { x = style.FramePadding.x, y = style.FramePadding.y },
    FrameRounding = style.FrameRounding,
    ItemSpacing = { x = style.ItemSpacing.x, y = style.ItemSpacing.y },
    ItemInnerSpacing = { x = style.ItemInnerSpacing.x, y = style.ItemInnerSpacing.y },
    CellPadding = { x = style.CellPadding.x, y = style.CellPadding.y },
    TouchExtraPadding = { x = style.TouchExtraPadding.x, y = style.TouchExtraPadding.y },
    IndentSpacing = style.IndentSpacing,
    ColumnsMinSpacing = style.ColumnsMinSpacing,
    ScrollbarSize = style.ScrollbarSize,
    ScrollbarRounding = style.ScrollbarRounding,
    GrabMinSize = style.GrabMinSize,
    GrabRounding = style.GrabRounding,
    LogSliderDeadzone = style.LogSliderDeadzone,
    TabRounding = style.TabRounding,
    TabMinWidthForCloseButton = style.TabMinWidthForCloseButton,
    DisplayWindowPadding = { x = style.DisplayWindowPadding.x, y = style.DisplayWindowPadding.y },
    DisplaySafeAreaPadding = { x = style.DisplaySafeAreaPadding.x, y = style.DisplaySafeAreaPadding.y },
    MouseCursorScale = style.MouseCursorScale;
  }
  return vars
end

function dpi.Initialize()
  m_displayRes.x, m_displayRes.y = GetDisplayResolution()
  m_fontscale = ImGui.GetFontSize()/18
  m_defaultVars = get_vars()
end

function dpi.GetDisplayResolution()
  return m_displayRes
end


function dpi.GetScale()
  return m_fontscale
end

function dpi.Scale(aNumber)
  return aNumber * m_fontscale
end

function dpi.PushScale()
  local vars = get_vars()
  local style = ImGui.GetStyle()
  for key, value in pairs(vars) do
    if type(value) == "table" then
      style[key].x = math.floor(value.x * m_fontscale)
      style[key].y = math.floor(value.y * m_fontscale)
    else
      style[key] = math.floor(value * m_fontscale)
    end
  end
end

function dpi.PopScale()
  local style = ImGui.GetStyle()
  for key, value in pairs(m_defaultVars) do
    if type(value) == "table" then
      style[key].x = value.x
      style[key].y = value.y
    else
      style[key] = value
    end
  end
end

return dpi