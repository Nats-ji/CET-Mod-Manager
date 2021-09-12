-- enums

local enum = require "cet_mod_manager/class/enum"

---@class enums
local enums = {}

---@class ENUM_MODTYPE : enum
---@field ARCHIVE number
---@field ASI number
---@field CET number
---@field RED4EXT number
---@field REDSCRIPT number
enums.MODTYPE = enum({
  "ARCHIVE",
  "ASI",
  "CET",
  "RED4EXT",
  "REDSCRIPT"
})

return enums