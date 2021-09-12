---@class style
local style = {}
local theme = require ("scripts/gui/theme")
local dpi = require ("scripts/gui/dpi")

---@param aStyle number
---@param aColor number[]
function style.PushColor(aStyle, aColor)
  ImGui.PushStyleColor(aStyle, aColor[1], aColor[2], aColor[3], aColor[4])
end

function style.PushTheme()
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
  style.PushColor(ImGuiCol.Separator,            theme.Border)

  ImGui.PushStyleVar(ImGuiStyleVar.WindowPadding, 8, 8)
  ImGui.PushStyleVar(ImGuiStyleVar.WindowRounding, 0)
  ImGui.PushStyleVar(ImGuiStyleVar.FramePadding, 8, 8)
  dpi.PushScale()
end

function style.PopTheme()
  ImGui.PopStyleColor(24)
  ImGui.PopStyleVar(3)
  dpi.PopScale()
end

return style