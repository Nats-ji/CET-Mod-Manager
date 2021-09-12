local CETMM = require ("scripts/CETMM")

---@class api
local api = {}


-- enum
---@type ENUM_MODTYPE
api.MODTYPE = {
  ARCHIVE = CETMM.GetEnums().MODTYPE.ARCHIVE,
  ASI = CETMM.GetEnums().MODTYPE.ASI,
  CET = CETMM.GetEnums().MODTYPE.CET,
  RED4EXT = CETMM.GetEnums().MODTYPE.RED4EXT,
  REDSCRIPT = CETMM.GetEnums().MODTYPE.REDSCRIPT
}

--[[
  returns a list of all loaded mods in the following format:
  {
    ARCHIVE = {
      {
        name = "string",
        path = "string",
        enabled = "boolean",
        type = "string",
        formated_name = "string",
      },
      ...
    },
    ASI = {},
    CET = {},
    RED4EXT = {},
    REDSCRIPT = {},
  }
]]
function api.GetModList()
  return CETMM.GetModList().GetConstList()
end

--[[
  string: aName
  api.MODTYPE: aModType
  returns false when no mod has found, returns the mod info when the mod has been found:
  {
    name = "string",
    path = "string",
    enabled = "boolean",
    type = "string",
    formated_name = "string",
  }
]]

---@param aName string
---@param aModType ENUM_MODTYPE
---@return table|boolean
function api.HasMod(aName, aModType)
  return CETMM.GetModList().HasMod(aName, aModType)
end

return api