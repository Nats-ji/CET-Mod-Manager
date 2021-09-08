-- Mod operation extended
local modopex = {}

-- Enable/disable a cet mod by renaming

function modopex.ToggleCETModState(aMod) -- mod: aMod, bool: success, string: err
  local success, err
  if aMod:IsEnabled() then
    success, err = os.rename((aMod:GetPath() / "init.lua"):ToString(), (aMod:GetPath() / "init.lua_disabled"):ToString())
    if success then
      aMod:SetEnabled(false)
    end
  else
    success, err = os.rename((aMod:GetPath() / "init.lua_disabled"):ToString(), (aMod:GetPath() / "init.lua"):ToString())
    if success then
      aMod:SetEnabled(true)
    end
  end
  return success, err
end

-- Enable/disable other mods

return modopex