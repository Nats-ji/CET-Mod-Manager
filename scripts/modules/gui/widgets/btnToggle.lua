local dpi = require ("modules/gui/dpi")
local themeSys = require ("modules/gui/themeSys")
local theme = themeSys.GetCurrentTheme()

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
		themeSys.PushColor(ImGuiCol.Button, theme:GetStyleColor("CustomToggleOn"))
		themeSys.PushColor(ImGuiCol.ButtonHovered, theme:GetStyleColor("CustomToggleOnHovered"))
		themeSys.PushColor(ImGuiCol.ButtonActive, theme:GetStyleColor("CustomToggleOnActive"))
		themeSys.PushColor(ImGuiCol.Text, theme:GetStyleColor("CustomToggleOnText"))
	else
		themeSys.PushColor(ImGuiCol.Button, theme:GetStyleColor("Button"))
		themeSys.PushColor(ImGuiCol.ButtonHovered, theme:GetStyleColor("ButtonHovered"))
		themeSys.PushColor(ImGuiCol.ButtonActive, theme:GetStyleColor("ButtonActive"))
		themeSys.PushColor(ImGuiCol.Text, theme:GetStyleColor("Text"))
	end
  if ImGui.Button(aLabel, aSizeX, aSizeY) then
    aValue = not aValue
  end
  ImGui.PopStyleColor(4)
  ImGui.PopStyleVar(1)
  return aValue
end

return btnToggle