local backend = require("modules/backend")
local EXT_Uninstall = backend.GetUninstall()
local widget = require("modules/gui/widgets")
local dpi = require("modules/gui/dpi")

---@class windows.uninstall
local uninstall = {
    m_draw = true,
    m_removeConfig = false,
    m_removeDofiles = false,
}

function uninstall.Render()
    if uninstall.m_draw then
        ImGui.Begin("CET Mod Manager Uninstalled", bit32.bor(ImGuiWindowFlags.NoSavedSettings))
        ImGui.SetWindowPos((dpi.GetDisplayResolution().x - ImGui.GetWindowWidth())/2, (dpi.GetDisplayResolution().y - ImGui.GetWindowHeight())/2, ImGuiCond.Always)
        ImGui.Text("It appears that you have uninstalled CET Mod Manager,\nDo you want to remove the leftover files?")
        ImGui.Spacing()
        uninstall.m_removeConfig = ImGui.Checkbox("Remove the config file.", uninstall.m_removeConfig)
        uninstall.m_removeDofiles = ImGui.Checkbox("Remove the Dofile folder and it's contents.", uninstall.m_removeDofiles)
        ImGui.Spacing()
        
        if ImGui.BeginTable("footer_btns", 2, ImGuiTableFlags.NoSavedSettings) then
            ImGui.TableSetupColumn("col1", ImGuiTableColumnFlags.WidthStretch)
            ImGui.TableSetupColumn("col2", ImGuiTableColumnFlags.WidthStretch)
            ImGui.TableNextRow()
            ImGui.TableSetColumnIndex(1)

            if widget.button("Yes", 80, 0, true) then
                EXT_Uninstall.SetFilesToRemove(true, uninstall.m_removeConfig, uninstall.m_removeDofiles)
                uninstall.m_draw = false
            end
            ImGui.SameLine()
            if widget.button("No", 80, 0, true) then
                uninstall.m_draw = false
            end

            ImGui.EndTable()
        end
        ImGui.End()
    end
end

return uninstall