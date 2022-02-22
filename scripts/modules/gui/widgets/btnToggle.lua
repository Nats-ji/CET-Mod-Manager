local dpi = require ("modules/gui/dpi")
local style = require ("modules/gui/style")
local theme = require ("modules/gui/theme")

---@param aLabel string|string[]
---@param aValue boolean
---@param aSizeX? number
---@param aSizeY? number
local function btnToggle(aLabel, aValue, aSizeX, aSizeY)
  if type(aLabel) == "table" then
    aLabel = aValue and aLabel[1] or aLabel[2]
  end
  aSizeX = aSizeX ~= nil and aSizeX or 0
  aSizeY = aSizeY ~= nil and aSizeY or 0

  if aValue then
		style.PushColor(ImGuiCol.Button, theme.CustomToggleOn)
		style.PushColor(ImGuiCol.ButtonHovered, theme.CustomToggleOnHovered)
		style.PushColor(ImGuiCol.Text, theme.CustomToggleOnText)
	else
		style.PushColor(ImGuiCol.Button, theme.Button)
		style.PushColor(ImGuiCol.ButtonHovered, theme.ButtonHovered)
		style.PushColor(ImGuiCol.Text, theme.Text)
	end
  if ImGui.Button(aLabel, aSizeX, aSizeY) then
    aValue = not aValue
  end
  ImGui.PopStyleColor(3)
  return aValue
end

return btnToggle