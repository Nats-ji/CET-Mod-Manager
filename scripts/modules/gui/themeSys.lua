local CETMM = require("modules/CETMM")
---@class themeSys
local themeSys = {}
local themes = {
    default = require("modules/gui/themes/default"),
    ua_special = require("modules/gui/themes/ua_special"),
    white = require("modules/gui/themes/white"),
}
local currentTheme = {} ---@type baseTheme

function themeSys.Initialize()
    local theme = CETMM.GetOptions().m_theme
    themeSys.Load(theme)
end

---Load theme
---@param aTheme string
---@param aNoSave? bool
function themeSys.Load(aTheme, aNoSave)
    if themes[aTheme] then
        currentTheme = themes[aTheme]
    else
        currentTheme = themes.default
        spdlog.error(string.format("Failed to load theme %s, loaded default theme instead.", aTheme))
    end
    if aNoSave then
        CETMM.GetOptions().m_theme = currentTheme:GetName()
        CETMM.GetOptions().Save()
    end
end

function themeSys.GetCurrentTheme()
    return currentTheme
end

---@param aStyle ImGuiCol
---@param aColor number[]
function themeSys.PushColor(aStyle, aColor)
  ImGui.PushStyleColor(aStyle, unpack(aColor))
end

function themeSys.PushTheme()
    themeSys.PushColor(ImGuiCol.TitleBg,              currentTheme:GetStyleColor("TitleBg"              ))
    themeSys.PushColor(ImGuiCol.TitleBgCollapsed,     currentTheme:GetStyleColor("TitleBgCollapsed"     ))
    themeSys.PushColor(ImGuiCol.TitleBgActive,        currentTheme:GetStyleColor("TitleBgActive"        ))
    themeSys.PushColor(ImGuiCol.Border,               currentTheme:GetStyleColor("Border"               ))
    themeSys.PushColor(ImGuiCol.WindowBg,             currentTheme:GetStyleColor("WindowBg"             ))
    themeSys.PushColor(ImGuiCol.ScrollbarBg,          currentTheme:GetStyleColor("ScrollbarBg"          ))
    themeSys.PushColor(ImGuiCol.ScrollbarGrab,        currentTheme:GetStyleColor("ScrollbarGrab"        ))
    themeSys.PushColor(ImGuiCol.ScrollbarGrabHovered, currentTheme:GetStyleColor("ScrollbarGrabHovered" ))
    themeSys.PushColor(ImGuiCol.ScrollbarGrabActive,  currentTheme:GetStyleColor("ScrollbarGrabActive"  ))
    themeSys.PushColor(ImGuiCol.ResizeGrip,           currentTheme:GetStyleColor("ResizeGrip"           ))
    themeSys.PushColor(ImGuiCol.ResizeGripHovered,    currentTheme:GetStyleColor("ResizeGripHovered"    ))
    themeSys.PushColor(ImGuiCol.ResizeGripActive,     currentTheme:GetStyleColor("ResizeGripActive"     ))
    themeSys.PushColor(ImGuiCol.Text,                 currentTheme:GetStyleColor("Text"                 ))
    themeSys.PushColor(ImGuiCol.Header,               currentTheme:GetStyleColor("Header"               ))
    themeSys.PushColor(ImGuiCol.HeaderHovered,        currentTheme:GetStyleColor("HeaderHovered"        ))
    themeSys.PushColor(ImGuiCol.HeaderActive,         currentTheme:GetStyleColor("HeaderActive"         ))
    themeSys.PushColor(ImGuiCol.CheckMark,            currentTheme:GetStyleColor("CheckMark"            ))
    themeSys.PushColor(ImGuiCol.FrameBg,              currentTheme:GetStyleColor("FrameBg"              ))
    themeSys.PushColor(ImGuiCol.FrameBgHovered,       currentTheme:GetStyleColor("FrameBgHovered"       ))
    themeSys.PushColor(ImGuiCol.FrameBgActive,        currentTheme:GetStyleColor("FrameBgActive"        ))
    themeSys.PushColor(ImGuiCol.Button,               currentTheme:GetStyleColor("Button"               ))
    themeSys.PushColor(ImGuiCol.ButtonHovered,        currentTheme:GetStyleColor("ButtonHovered"        ))
    themeSys.PushColor(ImGuiCol.ButtonActive,         currentTheme:GetStyleColor("ButtonActive"         ))
    themeSys.PushColor(ImGuiCol.Separator,            currentTheme:GetStyleColor("Separator"            ))
    themeSys.PushColor(ImGuiCol.PopupBg,              currentTheme:GetStyleColor("PopupBg"              ))

    ImGui.PushStyleVar(ImGuiStyleVar.WindowPadding, 8, 8)
    ImGui.PushStyleVar(ImGuiStyleVar.WindowRounding, 0)
end

function themeSys.PopTheme()
    ImGui.PopStyleColor(25)
    ImGui.PopStyleVar(2)
end

return themeSys