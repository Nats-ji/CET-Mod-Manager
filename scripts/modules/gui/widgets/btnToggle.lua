local dpi = require ("modules/gui/dpi")
local style = require ("modules/gui/style")
local theme = require ("modules/gui/theme")

-- config
local padding_x = 5
local padding_y = 5

---@param aLabel string|string[]
---@param aValue boolean
---@param aSizeX? number
---@param aSizeY? number
---@param aAutoscale? boolean
local function btnToggle(aLabel, aValue, aSizeX, aSizeY, aAutoscale)
  if type(aLabel) == "table" then
    aLabel = aValue and aLabel[1] or aLabel[2]
  end
  aSizeX = aSizeX or 0
  aSizeY = aSizeY or 0
  aAutoscale = aAutoscale==nil or aAutoscale
  if aAutoscale then
    aSizeX = dpi.Scale(aSizeX)
    aSizeY = dpi.Scale(aSizeY)
  end
  local imgui_style = ImGui.GetStyle()
  ImGui.PushStyleVar(ImGuiStyleVar.FramePadding, imgui_style.FramePadding.x + dpi.Scale(padding_x), imgui_style.FramePadding.y + dpi.Scale(padding_y))
  if aValue then
		style.PushColor(ImGuiCol.Button, theme.CustomToggleOn)
		style.PushColor(ImGuiCol.ButtonHovered, theme.CustomToggleOnHovered)
		style.PushColor(ImGuiCol.ButtonActive, theme.CustomToggleOnActive)
		style.PushColor(ImGuiCol.Text, theme.CustomToggleOnText)
	else
		style.PushColor(ImGuiCol.Button, theme.Button)
		style.PushColor(ImGuiCol.ButtonHovered, theme.ButtonHovered)
		style.PushColor(ImGuiCol.ButtonActive, theme.ButtonActive)
		style.PushColor(ImGuiCol.Text, theme.Text)
	end
  if ImGui.Button(aLabel, aSizeX, aSizeY) then
    aValue = not aValue
  end
  ImGui.PopStyleColor(4)
  ImGui.PopStyleVar(1)
  return aValue
end

return btnToggle