local CETMM = require("modules/CETMM")
local dpi = CETMM.GetUISystem().GetDPI()

---@class windows.fonts
local fonts = {
    modal = require("modules/gui/windows/fonts/modal"),
}

local m_drawWindow = false
local m_fonts = CETMM.GetBackEnd().GetFonts()
local m_current_seleted_fontfamily = m_fonts.currentFamily
local m_current_seleted_style = m_fonts.currentStyle

function fonts.Render()
    m_drawWindow = ImGui.Begin("Font Settings", m_drawWindow, ImGuiWindowFlags.NoSavedSettings)
    if m_drawWindow then
        ImGui.SetWindowPos(dpi.GetDisplayResolution().x / 2 - 300 * dpi.GetScale(),
            dpi.GetDisplayResolution().y * 0.1 * dpi.GetScale(),
            ImGuiCond.FirstUseEver)
        ImGui.Text("Font:")
        if ImGui.BeginCombo("Font", m_current_seleted_fontfamily) then

            for _, fontfamily in ipairs(m_fonts.families) do
                local is_selected = m_current_seleted_fontfamily == fontfamily.family
                if ImGui.Selectable(fontfamily.family, is_selected) then
                    m_current_seleted_fontfamily = fontfamily.family
                    m_current_seleted_style = fontfamily.styles[1]
                end
                if is_selected then
                    ImGui.SetItemDefaultFocus()
                end
            end
            ImGui.EndCombo()
        end
        ImGui.Text("Font Style:")
        if ImGui.BeginCombo("Font Style", m_current_seleted_style) then
            for fontstyle, _ in pairs(font.list[font_popup.m_fontlist_current_item]) do
                local is_selected = font_popup.m_fontstyle_current_item == fontstyle
                if ImGui.Selectable(fontstyle, is_selected) then
                    font_popup.m_fontstyle_current_item = fontstyle
                end
                if is_selected then
                    ImGui.SetItemDefaultFocus()
                end
            end
            ImGui.EndCombo()
        end
        ImGui.Text("Size:")
        ImGui.Text("Font Range:")

        ImGui.Button("Ok")
        ImGui.SameLine()
        ImGui.Button("Cancel")
        ImGui.End()
    end
end

return fonts
