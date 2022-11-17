local backend = require("modules/backend")
local EXT_Uninstall = backend.GetUninstall()

---@class windows.uninstall
local uninstall = {
    m_draw = true,
    m_removeConfig = false,
    m_removeDofiles = false,
}

function uninstall.Render()
    if uninstall.m_draw then
        ImGui.Begin("CET Mod Manager Uninstall", ImGuiWindowFlags.NoSavedSettings)
        ImGui.Text("It appears that you have uninstalled CET Mod Manager,\nDo you want to remove the remaining files?")
        uninstall.m_removeConfig = ImGui.Checkbox("Remove the config file.", uninstall.m_removeConfig)
        uninstall.m_removeDofiles = ImGui.Checkbox("Remove the Dofile folder and it's contents.", uninstall.m_removeDofiles)
        if ImGui.Button("Yes") then
            EXT_Uninstall.SetFilesToRemove(true, uninstall.m_removeConfig, uninstall.m_removeDofiles)
            uninstall.m_draw = false
        end
        ImGui.SameLine()
        if ImGui.Button("No") then
            uninstall.m_draw = false
        end
        ImGui.End()
    end
end

return uninstall