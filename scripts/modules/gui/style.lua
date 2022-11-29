---@class style
local style = {}
local theme = require ("modules/gui/theme")

function style.Initialize()
  theme.Load()
end

function style.GetTheme()
  return theme
end

---@param aStyle number
---@param aColor number[]
function style.PushColor(aStyle, aColor)
  ImGui.PushStyleColor(aStyle, aColor[1], aColor[2], aColor[3], aColor[4])
end

function style.PushTheme()
  theme:Push()
  style.PushColor(ImGuiCol.TitleBg,              theme.TitleBg)
  style.PushColor(ImGuiCol.TitleBgCollapsed,     theme.TitleBgCollapsed)
  style.PushColor(ImGuiCol.TitleBgActive,        theme.TitleBgActive)
  style.PushColor(ImGuiCol.Border,               theme.Border)
  style.PushColor(ImGuiCol.WindowBg,             theme.WindowBg)
  style.PushColor(ImGuiCol.ScrollbarBg,          theme.ScrollbarBg)
  style.PushColor(ImGuiCol.ScrollbarGrab,        theme.ScrollbarGrab)
  style.PushColor(ImGuiCol.ScrollbarGrabHovered, theme.ScrollbarGrabHovered)
  style.PushColor(ImGuiCol.ScrollbarGrabActive,  theme.ScrollbarGrabActive)
  style.PushColor(ImGuiCol.ResizeGrip,           theme.ResizeGrip)
  style.PushColor(ImGuiCol.ResizeGripHovered,    theme.ResizeGripHovered)
  style.PushColor(ImGuiCol.ResizeGripActive,     theme.ResizeGripActive)
  style.PushColor(ImGuiCol.Text,                 theme.Text)
  style.PushColor(ImGuiCol.Header,               theme.Header)
  style.PushColor(ImGuiCol.HeaderHovered,        theme.HeaderHovered)
  style.PushColor(ImGuiCol.HeaderActive,         theme.HeaderActive)
  style.PushColor(ImGuiCol.CheckMark,            theme.CheckMark)
  style.PushColor(ImGuiCol.FrameBg,              theme.FrameBg)
  style.PushColor(ImGuiCol.FrameBgHovered,       theme.FrameBgHovered)
  style.PushColor(ImGuiCol.FrameBgActive,        theme.FrameBgActive)
  style.PushColor(ImGuiCol.Button,               theme.Button)
  style.PushColor(ImGuiCol.ButtonHovered,        theme.ButtonHovered)
  style.PushColor(ImGuiCol.ButtonActive,         theme.ButtonActive)
  style.PushColor(ImGuiCol.Separator,            theme.Separator)
  style.PushColor(ImGuiCol.PopupBg,              theme.PopupBg)

  ImGui.PushStyleVar(ImGuiStyleVar.WindowPadding, 8, 8)
  ImGui.PushStyleVar(ImGuiStyleVar.WindowRounding, 0)
end

function style.PopTheme()
  ImGui.PopStyleColor(25)
  ImGui.PopStyleVar(2)
end

return style