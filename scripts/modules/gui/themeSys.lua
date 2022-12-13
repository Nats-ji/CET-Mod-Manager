---@class themeSys
local themeSys = {
    themes = {
        default = require("modules/gui/themes/default"),
        ua_special = require("modules/gui/themes/ua_special"),
        white = require("modules/gui/themes/white"),
    },
    currentTheme = {} ---@type baseTheme
}

function themeSys.Initialize()
    local theme = CETMM.GetOptions().m_theme
    themeSys.Load(theme)
end

---Load theme
---@param aTheme string
---@param aNoSave? bool
function themeSys.Load(aTheme, aNoSave)
    if themeSys.themes[aTheme] then
        themeSys.currentTheme = themeSys.themes[aTheme]
    else
        themeSys.currentTheme = themeSys.themes.default
        spdlog.error(string.format("Failed to load theme %s, loaded default theme instead.", aTheme))
    end
    if not aNoSave then
        CETMM.GetOptions().m_theme = themeSys.currentTheme:GetName()
        CETMM.GetOptions().Save()
    end
end

function themeSys.GetCurrentTheme()
    return themeSys.currentTheme
end

---@param aStyle ImGuiCol
---@param aColor number[]
function themeSys.PushColor(aStyle, aColor)
  ImGui.PushStyleColor(aStyle, unpack(aColor))
end

function themeSys.PushTheme()
    themeSys.PushColor(ImGuiCol.TitleBg,              themeSys.currentTheme:GetStyleColor("TitleBg"              ))
    themeSys.PushColor(ImGuiCol.TitleBgCollapsed,     themeSys.currentTheme:GetStyleColor("TitleBgCollapsed"     ))
    themeSys.PushColor(ImGuiCol.TitleBgActive,        themeSys.currentTheme:GetStyleColor("TitleBgActive"        ))
    themeSys.PushColor(ImGuiCol.Border,               themeSys.currentTheme:GetStyleColor("Border"               ))
    themeSys.PushColor(ImGuiCol.WindowBg,             themeSys.currentTheme:GetStyleColor("WindowBg"             ))
    themeSys.PushColor(ImGuiCol.ScrollbarBg,          themeSys.currentTheme:GetStyleColor("ScrollbarBg"          ))
    themeSys.PushColor(ImGuiCol.ScrollbarGrab,        themeSys.currentTheme:GetStyleColor("ScrollbarGrab"        ))
    themeSys.PushColor(ImGuiCol.ScrollbarGrabHovered, themeSys.currentTheme:GetStyleColor("ScrollbarGrabHovered" ))
    themeSys.PushColor(ImGuiCol.ScrollbarGrabActive,  themeSys.currentTheme:GetStyleColor("ScrollbarGrabActive"  ))
    themeSys.PushColor(ImGuiCol.ResizeGrip,           themeSys.currentTheme:GetStyleColor("ResizeGrip"           ))
    themeSys.PushColor(ImGuiCol.ResizeGripHovered,    themeSys.currentTheme:GetStyleColor("ResizeGripHovered"    ))
    themeSys.PushColor(ImGuiCol.ResizeGripActive,     themeSys.currentTheme:GetStyleColor("ResizeGripActive"     ))
    themeSys.PushColor(ImGuiCol.Text,                 themeSys.currentTheme:GetStyleColor("Text"                 ))
    themeSys.PushColor(ImGuiCol.Header,               themeSys.currentTheme:GetStyleColor("Header"               ))
    themeSys.PushColor(ImGuiCol.HeaderHovered,        themeSys.currentTheme:GetStyleColor("HeaderHovered"        ))
    themeSys.PushColor(ImGuiCol.HeaderActive,         themeSys.currentTheme:GetStyleColor("HeaderActive"         ))
    themeSys.PushColor(ImGuiCol.CheckMark,            themeSys.currentTheme:GetStyleColor("CheckMark"            ))
    themeSys.PushColor(ImGuiCol.FrameBg,              themeSys.currentTheme:GetStyleColor("FrameBg"              ))
    themeSys.PushColor(ImGuiCol.FrameBgHovered,       themeSys.currentTheme:GetStyleColor("FrameBgHovered"       ))
    themeSys.PushColor(ImGuiCol.FrameBgActive,        themeSys.currentTheme:GetStyleColor("FrameBgActive"        ))
    themeSys.PushColor(ImGuiCol.Button,               themeSys.currentTheme:GetStyleColor("Button"               ))
    themeSys.PushColor(ImGuiCol.ButtonHovered,        themeSys.currentTheme:GetStyleColor("ButtonHovered"        ))
    themeSys.PushColor(ImGuiCol.ButtonActive,         themeSys.currentTheme:GetStyleColor("ButtonActive"         ))
    themeSys.PushColor(ImGuiCol.Separator,            themeSys.currentTheme:GetStyleColor("Separator"            ))
    themeSys.PushColor(ImGuiCol.PopupBg,              themeSys.currentTheme:GetStyleColor("PopupBg"              ))

    ImGui.PushStyleVar(ImGuiStyleVar.WindowPadding, 8, 8)
    ImGui.PushStyleVar(ImGuiStyleVar.WindowRounding, 0)
end

function themeSys.PopTheme()
    ImGui.PopStyleColor(25)
    ImGui.PopStyleVar(2)
end

return themeSys