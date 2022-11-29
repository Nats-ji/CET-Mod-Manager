local dpi = require ("modules/gui/dpi")
local themeSys = require ("modules/gui/themeSys")

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
		themeSys.PushColor(ImGuiCol.Button, themeSys.GetCurrentTheme():GetStyleColor("CustomToggleOn"))
		themeSys.PushColor(ImGuiCol.ButtonHovered, themeSys.GetCurrentTheme():GetStyleColor("CustomToggleOnHovered"))
		themeSys.PushColor(ImGuiCol.ButtonActive, themeSys.GetCurrentTheme():GetStyleColor("CustomToggleOnActive"))
		themeSys.PushColor(ImGuiCol.Text, themeSys.GetCurrentTheme():GetStyleColor("CustomToggleOnText"))
	else
		themeSys.PushColor(ImGuiCol.Button, themeSys.GetCurrentTheme():GetStyleColor("Button"))
		themeSys.PushColor(ImGuiCol.ButtonHovered, themeSys.GetCurrentTheme():GetStyleColor("ButtonHovered"))
		themeSys.PushColor(ImGuiCol.ButtonActive, themeSys.GetCurrentTheme():GetStyleColor("ButtonActive"))
		themeSys.PushColor(ImGuiCol.Text, themeSys.GetCurrentTheme():GetStyleColor("Text"))
	end
  if ImGui.Button(aLabel, aSizeX, aSizeY) then
    aValue = not aValue
  end
  ImGui.PopStyleColor(4)
  ImGui.PopStyleVar(1)
  return aValue
end

return btnToggle