local dpi = require ("modules/gui/dpi")

-- config
local padding_x = 5
local padding_y = 5

---Button autoscales by default
---@param aLabel string
---@param aSizeX? number
---@param aSizeY? number
---@param aAutoscale? boolean
---@return boolean
local function button(aLabel, aSizeX, aSizeY, aAutoscale)
    aSizeX = aSizeX or 0
    aSizeY = aSizeY or 0
    aAutoscale = aAutoscale==nil or aAutoscale
    if aAutoscale then
        aSizeX = dpi.Scale(aSizeX)
        aSizeY = dpi.Scale(aSizeY)
    end
    local imgui_style = ImGui.GetStyle()
    ImGui.PushStyleVar(ImGuiStyleVar.FramePadding, imgui_style.FramePadding.x + dpi.Scale(padding_x), imgui_style.FramePadding.y + dpi.Scale(padding_y))
    local pressed = ImGui.Button(aLabel, aSizeX, aSizeY)
    ImGui.PopStyleVar(1)
    return pressed
end

return button